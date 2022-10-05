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
