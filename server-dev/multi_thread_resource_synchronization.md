# 多线程编程与资源同步

有些内容不详细，说明在 c++并发编程或者 UNIX 环境高级编程中，已经详细涉及过了，且再次会避开 Windows 相关开发，并且对特别重要的内容进行详细学习

## 线程的基本概念及常见问题

1、主线程退出、支线程也将退出吗？

windows：当主线程退出时，支线程也会退出  
linux：主线程退出，支线程一般还会继续运行，但此时这个进程将会变成僵尸进程。但是在有些 linux 版本中，主线程退出时支线程也会退出，请以确切的系统确定

2、某个线程崩溃，会导致进程退出吗？

一般来说一个支线程崩溃不会导致进程退出，但是往往在支线程中产生段错误 Segment Fault，会产生一个信号，操作系统对这个信号的默认处理方式就是结束进程，这样进程就会销毁

## 线程的基本操作

在此只是简单介绍回顾，详细内容还得读 UNIX 系统环境高级编程

1、创建线程

线程创建使用 pthread_create 函数，注意返回响应的错误码很重要，C++11 中支持 std::thread 类可以在 C++并发编程中学习

2、获取线程 ID

不展开记录了，可以使用 pthread_self、pthread_create、syscall(SYS_gettid) 见其他笔记

pstack 命令,可以查看一个进程的线程数量和每个线程的调用堆栈情况,htop 查看进程占用资源,`ps -efaL`查看线程,C++11 获取线程 ID 请对 C++并发编程部分进行学习

3、等待线程结束

pthread_join、pthread_exit 不再详细介绍  
C++11 中，std::thread 提供 join、joinable 等方法

## 惯用法：讲 C++类对象实例指针作为线程函数的参数

主要是在 C++11 中，通常这样使用,进行一定封装使用 std::thread 时对象地址与其方法的地址，C++11 的 thread 有非常多的构造函数，还是用了 std::bind 之类的功能。

```cpp
#include <iostream>
#include <memory>
#include <thread>
#include <unistd.h>
using namespace std;

class Thread
{
public:
    Thread() = default;
    ~Thread() = default;
    void start();
    void stop();

private:
    void threadFunc(int argc1, int argc2);

private:
    std::shared_ptr<std::thread> m_thread;
    bool m_stoped{false};
};

void Thread::start()
{
    m_stoped = false;
    m_thread.reset(new std::thread(&Thread::threadFunc, this, 1, 2));
}

void Thread::stop()
{
    m_stoped = true;
    if (m_thread->joinable())
    {
        m_thread->join();
    }
}

void Thread::threadFunc(int argc1, int argc2)
{
    while (!m_stoped)
    {
        cout << "hello" << endl;
    }
}

int main(int argc, char **argv)
{
    Thread thread;
    thread.start();
    sleep(2);
    thread.stop();
    return 0;
}
```

## 整形变量的原子操作

多个线程同时操作某个资源读写时，需要采取一定手段保护这些资源，一面资源访问冲突

1、给整形变量赋值不是原子操作

整型变量操作一般有三种

```cpp
//初始化
int a = 1;
mov dword ptr [a], 1
//自身加或减去一个值
a++;
mov eax, dword ptr [a]
inc eax
mov dword ptr [a], eax
//将一个变量赋值给另一个变量，或把一个表达式赋值给一个变量
int b = a;
mov eax, dword ptr [b]
mov dword ptr [a], eax
```

显然不是原子操作

2、C++对整形变量原子操作的支持

常用的类型，详细的可以看 cppreference https://en.cppreference.com/w/cpp/atomic/atomic

从 C++11 支持了 std::atomic 原子模板类

## Linux 线程同步对象

### linux 互斥体

主要有，pthread_mutex_t、pthread_mutex_init、pthread_mutex_destroy、pthread_mutex_lock、pthread_mutex_trylock、pthread_mutex_unlock、
pthread_mutexattr_init、pthread_mutexattr_destroy、pthread_mutexattr_settype、pthread_mutexattr_gettype 需要了解掌握

### 锁的类型

- PTHREAD_MUTEX_NORMAL 普通锁

普通锁 (PTHREAD_MUTEX_NORMAL) 是最基本的互斥锁类型，它没有附加的特性或保证。它遵循以下规则：

当一个线程持有普通锁时，其他试图获取锁的线程将被阻塞，直到持有锁的线程释放它。  
如果多个线程同时试图获取锁，系统无法保证哪个线程会获得锁。这可能会导致不公平性，即某些线程可能会连续多次获得锁，而其他线程则无法获得锁。  
普通锁不提供死锁检测或递归锁定。

- PTHREAD_MUTEX_ERRORCHECK 检错锁

使用检错锁时，以下是一些特点和行为：  
当一个线程持有检错锁时，其他试图获取锁的线程将被阻塞，直到持有锁的线程释放它。  
如果同一个线程多次尝试获取同一个检错锁，系统将会检测到这种递归行为，并返回一个错误码。  
如果同一个线程尝试再次获取已经持有的检错锁，系统将会检测到死锁情况，并返回一个错误码。  
如果一个线程试图释放它不持有的检错锁，系统也会检测到这个错误，并返回一个错误码。

- PTHREAD_MUTEX_RECURSIVE 可重入锁

可重入锁允许同一线程多次获取锁，而不会导致死锁。当同一线程多次请求锁时，该锁会保持计数，并在每次解锁时递减计数。只有当计数为零时，锁才会被完全释放，其他线程才能获取锁。

### linux 信号量

主要需要掌握以下 API，可以到 UNIX 环境编程笔记进行复习

```cpp
#include <semaphore.h>
int sem_init(sem_t* sem,int pshared,unsigned int value);
int sem_destroy(sem_t* sem);
int sem_post(sem_t* sem);
int sem_wait(sem_t* sem);
int sem_trywait(sem_t* sem);
int sem_timewait(sem_t* sem,const struct timespec* abs_timeout);
```

### 条件变量

主要掌握，pthread_cond_t、pthread_cond_init、pthread_cond_destroy、pthread_cond_wait、pthread_cond_timedwait、pthread_cond_signal、pthread_cond_broadcast

条件变量信号丢失问题，如果一个条件变量信号在产生时没有相关线程调用 pthread_cond_wait 捕获该信号，该信号就会永远丢失，在此调用 pthread_cond_wait 将会导致永久阻塞

### 读写锁

主要掌握，pthread_rwlock_init、pthread_rwlock_destroy、pthread_rwlock_t、pthread_rwlock_rdlock、pthread_rwlock_tryrdlock、pthread_rwlock_timedrdlock、pthread_rwlock_wrlock、pthread_rwlock_trywrlock、pthread_rwlock_timedwrlock、pthread_rwlock_unlock

属性设置，pthread_rwlockattr_setkind_np、pthread_rwlockattr_getkind_np、pthread_rwlockattr_init、pthread_rwlockattr_destroy

pthread_rwlockattr_setkind_np 第二个参数，设置读写锁类型

```cpp
enum {
    //读者优先，同时请求读锁和写锁时，请求读锁的线程优先获得锁
    PTHREAD_RWLOCK_PREFER_READER_NP,
    //读者优先
    PTHREAD_RWLOCK_PREFER_WRITER_NP,
    //写着优先
    PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP,
    PTHREAD_RWLOCK_DEFAULT_NP = PTHREAD_RWLOCK_PREFER_READER_NP
};
```

## C++11/14/17 线程同步对象

1、内置的 mutex 主要有，样例去看

| 互斥量                | 版本  | 作用                                |
| --------------------- | ----- | ----------------------------------- |
| mutex                 | C++11 | 基本的互斥量                        |
| timed_mutex           | C++11 | 有超时机制的互斥量                  |
| recursive_mutex       | C++11 | 可重入的互斥量                      |
| recursive_timed_mutex | C++11 | 结合 timed_mutex 与 recursive_mutex |
| shared_timed_mutex    | C++14 | 具有超时机制的共享互斥量，读写锁    |
| shared_mutex          | C++17 | 共享的互斥量，读写锁                |

2、互斥量管理，RAII 风格

| 互斥量管理  | 版本  | 作用                   |
| ----------- | ----- | ---------------------- |
| lock_guard  | C++11 | 基于作用域的互斥量管理 |
| unique_lock | C++11 | 更加灵活的互斥量管理   |
| shared_lock | C++14 | 共享互斥量的管理       |
| scoped_lock | C++17 | 多互斥量避免锁的管理   |

3、条件变量，std::condition_variable

https://en.cppreference.com/w/cpp/thread/condition_variable

## 如何确保创建的线程一定能运行

使用条件变量通知不就行了吗，哈哈

## 多线程使用锁经验

1、减少锁的使用

* 加锁和解锁操作，本身有一定的开销
* 临界区的代码不能并发执行
* 进入临界区次数过于频繁，线程之间对临界区的争夺太过激烈，若线程竞争互斥体失败，则会陷入阻塞让出CPU、所以执行上下文切换的次数要远远多于不适用互斥体的次数

2、明确锁的范围

3、减少锁的使用粒度，指的是尽量减少锁作用的临界区代码范围，临界区的代码范围小，多个线程排队进入临界区的时间就会短

4、避免死锁的建议

* 在一个函数中如果有一个加锁操作，在函数退出时记得解锁
* 在线程退出时一定要及时释放其持有的锁
* 多线程请求锁的方向要一致，避免死锁
* 当需要同一个线程重复请求一个锁时，就需要明白使用锁的行为是递增锁引用计数，还是阻塞或者直接获得锁

## 线程局部存储

### POSIX

对于存在多个线程的进程，有时需要每个线程都操作自己的这份数据，把这样的数据称为线程局部存储(Thread Local Storage,TLS),将对应的存储区域称为线程局部存储区  
相关API

```cpp
#include <pthread.h>
int pthread_key_create(pthread_key_t *key, void (*destr_function) (void *));
int pthread_key_delete(pthread_key_t key);
int pthread_setspecific(pthread_key_t key, const void *pointer);
void * pthread_getspecific(pthread_key_t key);
```

将pthread_key_t定义为全局变量，每个线程可以使用setspecific、getspecifi设置与获取自己线程的pointer

### std::thread_local

C++11提供了thread_local来定义一个线程变量

```cpp
std::thread_local int g_mydata = 1;
//每个线程都有自己单独的g_mydata变量
```

* 对于线程变量，每个线程都会有变量的一个拷贝，互不影响，该局部变量一直存在，直到线程退出
* 系统的线程局部存储区域的内存空间并不大，尽量不要用这个空间存储大的数据块

## C 库的非线程安全函数

```cpp
#include <time.h>
{
    time_t tNow = time(nullptr);
    time_t tEnd = tNow + 1800;
    struct tm* ptm = localtime(&tNow);
    struct tm* ptmEnd = localtime(&tEnd);
}
//会发现ptm与ptmEnd地址是一样的
```

函数的返回值是一指针类型，外部不需要释放这个指针存储的地址对应的内存，所以这个函数内部一定使用了一个全局变量或者函数内部的静态变量，在此调用函数时把上一次的结果覆盖了  
如果当多个线程同时调用时，可能会出现很大的问题，此函数是非线程安全函数，类似的还有socket、strtok、gethostbyname等

```cpp
struct tm* localtime(cnost time_t* timep);
```

常见的函数,这些线程安全版本的函数一般会接受额外的参数来存储结果，而不是使用静态缓冲区。这样，每个线程都可以使用自己的缓冲区，避免了线程间的竞争条件。

```cpp
strtok\strtok_r
asctime\asctime_r
ctime\ctime_r
gmtime\gmtime_r
localtime\localtime_r
gethostbyname\gethostbyname_r gethostbyname2_r
getpwuid\getpwuid_r
```

## 线程池与队列系统的设计

1、线程池，这都是经典操作了吧，C++服务器开发精髓P270有样例代码用C++11写的，网上也有很多  
2、环形队列，如果生产者和消费者的速度差不多，可以将队列改为环形队列，可以节省内存空间  
3、消息中间件，建议学习RabbitMQ  

## 协程 Routine

协程（Coroutine）是一种轻量级的线程替代方案，它可以在一个线程中实现多个并发执行的任务，而无需使用多线程的上下文切换开销。在协程中，任务的切换是由程序主动控制的，而不是由操作系统或调度器决定的。

协程通常被称为“用户级线程”或“轻量级线程”，它提供了一种更加灵活、高效的并发编程模型。协程的主要特点包括：

1、轻量级：协程是非常轻量级的执行单元，它的创建和切换开销相对较小，不像线程那样需要操作系统的调度和管理。

2、非抢占式：协程的切换是由程序员显式控制的，不像线程那样会被操作系统抢占。在协程中，任务之间的切换是协作式的，需要主动释放执行权。

3、共享状态：协程通常在同一个地址空间中共享状态，这使得协程之间的通信和数据共享更加简单。但也需要注意对共享状态进行正确的同步和互斥操作，以避免竞态条件。

4、高度可控：由于协程的切换是由程序主动控制的，可以更精确地控制任务的执行顺序和调度策略，从而实现更灵活的并发编程。
