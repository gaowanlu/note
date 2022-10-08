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

### std::promise

std::promise也是一种产生future的一种方式，promise与future关联，future可以进行get的标志不再是相应任务进行返回，而是promise.set\_value方法，传送future可以get的数据

```cpp
#include <iostream>
#include <thread>
#include <future>
#include <chrono>

using namespace std;

void task(std::promise<string> m_promise) {
    m_promise.set_value("hello promise");
    this_thread::sleep_for(chrono::milliseconds(2000));
    cout << "task end" << endl;
}

int main(int argc, char** argv)
{
    std::promise<string> m_promise;
    std::promise<string> m_promise_other;
    m_promise.swap(m_promise_other);//swap交换
    future<string> m_future = m_promise.get_future();
    thread m_thread([&] {
        task(std::move(m_promise));//赋值拷贝与拷贝构造是被禁止的，可以使用移动构造
    });
    cout << m_future.get() << endl;
    m_thread.join();
    //hello promise
    //task end
    //从功能上来看promise也是中线程通信的一种方式
    return 0;
}
```

### 将异常存与future中

async

```cpp
#include<iostream>
#include<stdexcept>
#include<future>
using namespace std;

void func() {
	throw std::exception("func throw exception");
}

int main() {
	future<void>f = async(func);
	try {
		f.get();
	}
	catch (const exception&e) {
		cout << e.what() << endl;//func throw exception
	}
	return 0;
}
```

packaged\_task

```cpp
#include<iostream>
#include<stdexcept>
#include<future>
using namespace std;

void func() {
	throw std::exception("func throw exception");
}

int main() {
	packaged_task<void()> task(func);
	future<void> f=task.get_future();
	task();
	try {
		f.get();
	}
	catch (exception& e) {
		cout << e.what() << endl;//func throw exception
	}
	return 0;
}
```

promise

```cpp
#include<iostream>
#include<stdexcept>
#include<future>
#include<exception>

using namespace std;

void func(promise<void>m_promise) {
	/*try {
		throw runtime_error("error");
	}
	catch (...) {
		m_promise.set_exception(std::current_exception());
	}*/
	//或者使用
	m_promise.set_exception(std::make_exception_ptr(runtime_error("error")));
}

int main() {
	promise<void> m_promise;
	future<void> f = m_promise.get_future();
	thread t1([&] {func(move(m_promise)); });
	try {
		f.get();
	}
	catch (const exception& e) {
		cout << e.what() << endl;//error
	}
	t1.join();
	return 0;
}
```

### std::shared\_future多个线程的等待

future只能get一次，如果多个线程需要等待同一个future呢，应该怎样做呢

```cpp
#include<thread>
#include<future>
#include<string>
#include<iostream>

using namespace std;

string func() {
	return "func";
}

int main() {
	future<string> f = async(func);
	//运行出错，存在竞争关系,f只能get一次
	thread t1([&] {cout << f.get() << endl; });
	thread t2([&] {cout << f.get() << endl; });
	t1.join();
	t2.join();
	return 0;
}
```

使用shared\_future。类模板`std::shared_future`提供访问异步操作结果的机制，类似于`std::future`，只是允许多个线程等待相同的共享状态。不像`std::future`，因此只有一个实例可以引用任何特定的异步结果%29，`std::shared_future`是可复制的，多个共享的未来对象可能引用相同的共享状态。如果每个线程通过自己的副本访问同一个共享状态，则从多个线程访问该状态是安全的。`shared_future`对象。

```cpp
#include<thread>
#include<future>
#include<string>
#include<iostream>

using namespace std;

string func() {
	return "func";
}

int main() {
	future<string> f = async(func);
	cout << boolalpha << f.valid() << endl;//true
	shared_future<string> sf(move(f));
	//shared_future<string>sf = f.share();
	cout << boolalpha << f.valid() << endl;//false

	thread t1([&] {
		shared_future<string> local = sf;
		local.get(); cout << "f ok" << endl; 
	});
	thread t2([&] {
		shared_future<string> local = sf;
		local.get(); cout << "f ok" << endl; 
	});
	t1.join();
	t2.join();
	//f ok
	//f ok
	return 0;
}
```
