---
coverY: 0
---

# 第4章 同步操作

## 同步操作

### 总览

此章节主要内容有，等待时间或条件、使用future、限时等待、简化代码四个部分

### 循环等待

下面使用std::this\__thread::sleep_\_for实现线程的休眠，休眠的时候虽然不工作，但是它是一个间隔休眠在不断工作的任务，这样浪费了资源

```cpp
#include <mutex>
#include <thread>
#include <iostream>

using namespace std;

bool flag=false;
mutex m;

void wait_for_flag() {
    unique_lock<mutex>lk(m);
    while (!flag) {//线程一直处于间隔休眠的工作状态
        lk.unlock();
        this_thread::sleep_for(chrono::milliseconds(100));//休眠0.1s
        lk.lock();
    }
    cout << "flag is true" << endl;
}

void change_for_flag() {
    this_thread::sleep_for(chrono::milliseconds(10000));//休眠10s
    unique_lock<mutex>lk(m);
    flag = true;
}

int main()
{
    thread a([]()->void {
        wait_for_flag();
        });
    thread b([]()->void {
        change_for_flag();
        });
    a.join(); b.join();
    //10秒钟后才会输出flag is true
    return 0;
}

```

### 等待条件达成

C++标准库中条件变量有两套实现，std::condition\__variable和std::condition\_variable\_any,前者只能配和mutex使用，后者可以和合适的互斥量一起工作，值得注意的是，调用条件变量的notify\_one或者notify\_all并不是进行解锁，而是通知等待队列上线程可以去竞争锁了，如果拿到了锁则调用wiat谓词判断条件。_

```cpp
#include <mutex>
#include <thread>
#include <iostream>
#include <condition_variable>

using namespace std;

bool flag=false;
mutex m;
condition_variable flag_condition;

void wait_for_flag() {
    unique_lock<mutex>lk(m);
    //当wait时，首先会先unlock掉lk,将线程出于阻塞或等待状态
    flag_condition.wait(lk, [] {
        cout << "wait check" << endl;
        return flag;//返回false才会进行等待
    });
    //当被notify后重新获得锁m，再次进行等待条件检查
    //条件满足时则不再wait，条件不满足时则在此进入wait
    cout << "flag is true" << endl;
}

void change_for_flag() {
    this_thread::sleep_for(chrono::milliseconds(10000));//休眠10s
    unique_lock<mutex>lk(m);
    flag = true;
    flag_condition.notify_one();
    //挑一个等待的线程唤醒，notify_one并不会将锁释放掉，而是通知等待状态的线程可以去竞争锁了
    cout << "notify_one" << endl;
    this_thread::sleep_for(chrono::milliseconds(5000));
    cout << "15s end" << endl;
    //最后由lk析构将锁释放掉
}
/*
wait check
notify_one
15s end
wait check
flag is true
*/

int main()
{
    thread a([]()->void {
        wait_for_flag();
        });
    thread b([]()->void {
        change_for_flag();
        });
    a.join(); b.join();
    return 0;
}

```

### 构建线程安全的队列

```cpp
#include <mutex>
#include <thread>
#include <iostream>
#include <queue>
#include <condition_variable>
#include <memory>

using namespace std;

template<typename T>
class safe_queue {
private:
    queue<T> m_queue;
    mutable mutex m_mutex;
    condition_variable m_condition;
public:
    safe_queue() = default;
    safe_queue(safe_queue const& other) {
        //safe_queue是safe_queue的友元哦
        lock_guard<mutex> lk(other.m_mutex);
        //为什么不需要锁住自已，因为这里是构造函数啊
        m_queue = other.m_queue;
    }
    void push(T value) {
        lock_guard<mutex>lk(m_mutex);
        m_queue.push(value);
        m_condition.notify_all();
    }
    T&& wait_and_pop() {
        unique_lock<mutex> lk(m_mutex);
        m_condition.wait(lk, [this] {return !m_queue.empty(); });
        T value = m_queue.front();
        m_queue.pop();
        return std::move(value);
    }

    bool try_pop(T&value) {
        lock_guard<mutex> lk(m_mutex);
        if (m_queue.empty()) {
            return false;
        }
        value = m_queue.front();
        m_queue.pop();
        return true;
    }

    bool empty() const {
        lock_guard<m_mutex> lk(m_mutex);
        return m_queue.empty();
    }
    
};

int main()
{
    safe_queue<int> m_queue;
    vector<int>info = {1,2,3,4,5,6,7,8,9,10};
    thread a(
        [&]{
            for (auto const& item : info) {
                //this_thread::sleep_for(chrono::milliseconds(1000));
                m_queue.push(item);
            }
        });
    thread b(
        [&]()->void {
            for (int i = 0; i < 10; i++) {
                int&& data = m_queue.wait_and_pop();
                cout << data << endl;
            }
        });
    a.join(); b.join();
    return 0;
}

```

### 使用future

future有两种一种为std::future<>一种为std::shared\__future<>,其区别和std::unique\_ptr<>与std::shared\__ptr<>类似，std::thread执行的任务不能有返回值，但可以future进行解决

```cpp
#include<iostream>
#include<future>

using namespace std;

int async_task() {
	this_thread::sleep_for(chrono::milliseconds(5000));
	return 999;
}

int main() {
	future<int> res = std::async(async_task);
	int data=res.get();//阻塞直到async_task任务返回
	cout << data << endl;//999
	shared_future<int> res1 = async(async_task);
	shared_future<int> res2 = res1;
	cout << res1.get() << " " << res2.get() << endl;//999 999 
	return 0;
}
```

### 使用std::async向函数传递参数

其规则与std::thread使用的方式类似

```cpp
#include<iostream>
#include<future>

using namespace std;

int async_sum(int a,int b) {
	return a + b;
}

class Task {
public:
	int sum(int const & a,int const & b) {
		return a + b;
	}
};

class Runable {
public:
	int operator()(int a,int b) {
		return a + b;
	}
};


int main() {
	//函数指针
	auto future1=async(async_sum,1,2);
	Task task;
	int a = 1, b = 2;
	//对象方法
	auto future2 = async(&Task::sum,task,std::ref(a),std::ref(b));
	//可执行对象
	auto future3 = async(Runable(),1,2);
	cout << future1.get() << " " << future2.get() << " " << future3.get() << endl;//3 3 3
	return 0;
}
```

### std::async的选项

async第一个参数可以为std::launch&#x20;

1、std::launch::async为开启新线程执行任务其也是默认参数

2、std::launch::deferred为调用延迟到wait()或get(）调用时才执行

```cpp
#include<iostream>
#include<future>

using namespace std;

void func1() {
	cout << "async and deferred" << endl;
}

int main() {
	future<void> future1 = async(launch::async,func1);//马上执行
	auto future2 = async(launch::deferred,func1);//推迟执行等待wait或get
	auto future3 = async(func1);//默认为launch::async
	future1.wait();
	future3.get();
	future2.get();
	/*
	async and deferred
	async and deferred
	async and deferred
	*/
	return 0;
}
```

### future与任务关联std::packaged\_task<>

packaged\_task作为线程函数传递 到 std::thread 对象中，或作为可调用对象传递到另一个函数中或直接调用

```cpp
#include<iostream>
#include<future>

using namespace std;

int func(int a,int b) {
	return a + b;
}

void run(packaged_task<int(int, int)> &task) {
	task(1,2);
	cout << "started task" << endl;
}

int main() {
	packaged_task<int(int, int)> task(func);
	
	thread a([&] {
		this_thread::sleep_for(chrono::milliseconds(3000));
		run(task);//执行任务
	});

	future<int> res=task.get_future();
	cout << res.get() << endl;
	a.join();
	//started task
	//3
	return 0;
}
```

有意思的任务队列

```cpp
#include <deque>
#include <mutex>
#include <future>
#include <thread>
#include <utility>
#include <iostream>

using namespace std;

std::mutex m;
std::deque<std::packaged_task<int()> > tasks;//任务队列

bool run_state = true;

void process_func()//消息处理队列
{
    while (run_state)
    {
        std::packaged_task<int()> task;
        {
            std::lock_guard<std::mutex> lk(m);
            if (tasks.empty())
                continue;
            task = std::move(tasks.front());
            tasks.pop_front();
        }
        task();//调用task并不会开启新线程，task只是一个可调用对象
    }
}

std::thread process_thread(process_func);//开启任务处理线程

template<typename Func>
std::future<int> post_task(Func f)
{
    std::packaged_task<int()> task(f);
    std::future<int> res = task.get_future();
    std::lock_guard<std::mutex> lk(m);
    tasks.push_back(std::move(task));
    return res;
}


int f() {
    static int num = 0;
    this_thread::sleep_for(chrono::milliseconds(100));//模拟任务时常
    return ++num;
}

deque<future<int>>results;

int main() {
    thread a([&] {
        for (int i = 0; i < 100; i++) {
            results.push_back(post_task(f));
        }
    });
    a.join();//提交任务到队列完毕
    
    thread reading_res([&] {
        for (auto& item : results) {
            cout << item.get() << endl;
            //当future关联的packaged_task被调用并返回结果后，才能get出结果
            //在相应task没被调用或结束之前，调用get相会阻塞
        }
    });

    reading_res.join();//任务全部处理完之后，才能关闭任务处理线程
    run_state = false;//关闭任务处理线程
    process_thread.join();
    return 0;
}

```
