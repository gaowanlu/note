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

## C++11/14/17 线程同步对象

## 如何确保创建的线程一定能运行

## 多线程使用锁经验

## 线程局部存储

## C 库的非线程安全函数

## 线程池与队列系统的设计

## 纤程 Fiber

## 协程 Routine
