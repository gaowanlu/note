---
cover: >-
  https://images.unsplash.com/photo-1650170496638-b05030a94005?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI1MzAzMzQ&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 🚀 协程

## 协程

非常nice的讲解 <https://www.bilibili.com/video/BV1c8411f7dw>

### 什么是协程

先学会使用，然后在学习背后的实现原理。由浅到深才是学习的正确姿势。

协程：是一种可以被挂起和回复的函数。

电脑本机没有环境可以使用 轻松使用C++2a环境:<https://godbolt.org/>

### 函数调用VS协程

![函数调用VS协程](../.gitbook/assets/2024-03-27232828.png)

函数的调用是调用的函数进行return，然后返回回来，继续执行，且调用的函数已经执行完了，不会中断。

而协程是可以执行到某处co_yield或co_await时，然后跳转到某个地方(协程被挂起时不是必须回到被调用的地方，完全可以指定其他协程，这就是协程调度的内容了)，当协程被执行resume时继续执行协程
当co_return时协程将结束。

### 简单实例

简单认识

- 协程返回值类型与promise_type、initial_suspend、final_suspend、unhandled_exception、get_return_object、yield_value、return_void、return_value
- std::coroutine_handle、done、()、resume、from_promise
- co_await、co_yield、co_return
- awaitable、await_ready、await_suspend、await_resume

```CMake
project(main)

add_compile_options(-Wall)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -Wall -O0")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -std=c++2a -Wall -O0")

add_executable(main.exe main.cpp)
# target_link_libraries(main.exe)
```

```cpp
// main.cpp
// 测试gcc12.1可以编译通过 测试支持最低版本gcc11.1
#include <iostream>
#include <coroutine>
#include <string_view>

class CoMessage
{
public:
    std::string_view str;
};

// 协程返回类型
struct CoRet
{
    // 协程返回类型中需要有一个promise_type类型
    struct promise_type
    {
        CoMessage _message;
        int _out;

        // 返回类型为awaitable
        std::suspend_never initial_suspend()
        {
            return {};
        }

        // 返回类型为awaitable
        std::suspend_never final_suspend() noexcept
        {
            std::cout << "final_suspend" << std::endl;
            return {};
        }

        void unhandled_exception()
        {
        }

        CoRet get_return_object()
        {
            return {std::coroutine_handle<promise_type>::from_promise(*this)};
        }

        std::suspend_always yield_value(int r)
        {
            _out = r;
            return {};
        }

        void return_void() // 即co_return ;
        {
        }

        // void return_value(std::string str) // 即co_return str;
        // {
        // }
    };

    std::coroutine_handle<promise_type> _h; //_h.resume() 或 _h() 协程会在被挂起的地方恢复

    // ~CoRet()
    // {
    //     if (_h)
    //     {
    //         _h.destroy();
    //     }
    // }
};

// 自定义awaitable类型
struct Awaitable
{
    CoMessage *_message;
    // 其返回值决定co_wait时是否被挂起 true为不挂起 false为挂起
    bool await_ready()
    {
        return false;
    }

    // 在cowait时要挂起 即将跳转走之前被执行 返回值为void则跳转到被调用处
    // 也可以返回其他std::coroutine_handle执行要跳转到的位置
    void await_suspend(std::coroutine_handle<CoRet::promise_type> h)
    {
        _message = &h.promise()._message;
    }

    // co_wait时的返回值
    CoMessage await_resume()
    {
        return *_message;
    }
};

CoRet CoFunction()
{
    // 协程开始被调度时就会隐式创建一个返回类型中的promise_type对象
    // 创建的这个promise_type对象就会控制协程的运行以及内外的数据交换
    // CoRet::promise_type promise;
    // CoRet coRet = promise.get_return_object(); 即协程的返回值
    // 然后会进行 co_await promise.initial_suspend()

    // 而gcc12.1以上可以这样写
    // Awaitable awaitable;
    // CoMessage message = co_await awaitable; // 从awaitable.await_resume()返回的
    // 不然要这样写
    CoMessage message = co_await Awaitable();

    std::cout << "coroutine message=" << message.str << std::endl;

    co_return; // 调用promise的return_void或return_value
    // 最后会进行 co_await promise.final_suspend()
}

int main(int argc, char **argv)
{
    CoRet ret = CoFunction();
    std::cout << "CoFunction() next line" << std::endl;
    ret._h.promise()._message.str = "hello"; // 写到协程的promise对象中
    ret._h();
    // ret._h.resume(); 与 ret._h() 等价
    std::cout << "over" << std::endl;
    return 0;
}

// co_yield等价于 co_await promise.yield_value(expr)
// 协程如果调用了co_return 则 ret._h.done()将会返回真

// CoFunction() next line
// coroutine message=hello
// final_suspend
// over
```

### std::suspend_never的实现

std::suspend_never是一个std默认实现的一个awaitable

```cpp
struct suspend_never
{
  constexpr bool await_ready() const noexcept { return true; } // 不挂起co_wait直接无效继续执行co_wait后面的代码
  constexpr void await_suspend(coroutine_handle<>) const noexcept {}
  constexpr void await_resume() const noexcept {}
};
```

### std::suspend_always的实现

std::suspend_always也是一个std默认实现的一个awaitable

```cpp
struct suspend_always
{
  constexpr bool await_ready() const noexcept { return false; } // co_wait时直接挂起然后触发await_suspend 然后等待resume再回来
  constexpr void await_suspend(coroutine_handle<>) const noexcept {} 
  constexpr void await_resume() const noexcept {}
};
```

### 进一步熟悉流程

这里可以进一步了解final_suspend的返回值

```cpp
// main.cpp
// 测试gcc12.1可以编译通过 测试支持最低版本gcc11.1
#include <iostream>
#include <coroutine>
#include <string_view>

class CoMessage
{
public:
    std::string_view str;
};

// 协程返回类型
struct CoRet
{
    // 协程返回类型中需要有一个promise_type类型
    struct promise_type
    {
        CoMessage _message;
        std::string_view _out;

        // 返回类型为awaitable
        std::suspend_always initial_suspend()
        {
            std::cout << "initial_suspend" << std::endl;
            return {};
        }

        // 返回类型为awaitable
        std::suspend_never final_suspend() noexcept
        {
            // final_suspend返回值决定了协程会不会被destory 当返回std::suspend_never时final_suspend执行后协程handle被destory 在调用handle.done()返回0
            // 当返回std::suspend_always也就是协程最后有被挂起，那么handle.done()会返回真，而且如果返回std::suspend_always我们是需要在它处显示handle.destory()
            std::cout << std::coroutine_handle<promise_type>::from_promise(*this).done() << std::endl;
            std::cout << "final_suspend" << std::endl;
            std::cout << "co_return " << _out << std::endl;
            return {};
        }

        void unhandled_exception()
        {
        }

        CoRet get_return_object()
        {
            return {std::coroutine_handle<promise_type>::from_promise(*this)};
        }

        std::suspend_never yield_value(std::string_view r)
        {
            _out = r;
            return {};
        }

        // void return_void() // 即co_return ;
        // {
        // }

        void return_value(std::string_view str) // 即co_return str; 可以将内容通过co_return存到promise中
        {
            _out = str;
        }
    };

    std::coroutine_handle<promise_type> _h; //_h.resume() 或 _h() 协程会在被挂起的地方恢复

    // ~CoRet()
    // {
    //     if (_h)
    //     {
    //         _h.destroy();
    //     }
    // }
};

// 自定义awaitable类型
struct Awaitable
{
    CoMessage *_message;
    // 其返回值决定co_wait时是否被挂起 true为不挂起 false为挂起
    bool await_ready()
    {
        return false;
    }

    // 在cowait时要挂起 即将跳转走之前被执行 返回值为void则跳转到被调用处
    // 也可以返回其他std::coroutine_handle执行要跳转到的位置
    void await_suspend(std::coroutine_handle<CoRet::promise_type> h)
    {
        _message = &h.promise()._message;
    }

    // co_wait时的返回值
    CoMessage await_resume()
    {
        return *_message;
    }
};

CoRet CoFunction()
{
    // 协程开始被调度时就会隐式创建一个返回类型中的promise_type对象
    // 创建的这个promise_type对象就会控制协程的运行以及内外的数据交换
    // CoRet::promise_type promise;
    // CoRet coRet = promise.get_return_object(); 即协程的返回值
    // 然后会进行 co_await promise.initial_suspend()

    // 而gcc12.1以上可以这样写
    // Awaitable awaitable;
    // CoMessage message = co_await awaitable; // 从awaitable.await_resume()返回的
    // 不然要这样写
    CoMessage message = co_await Awaitable();

    std::cout << "coroutine message=" << message.str << std::endl;

    co_return "888888"; // 调用promise的return_void或return_value
    // 最后会进行 co_await promise.final_suspend()
}

int main(int argc, char **argv)
{
    std::cout << "start main" << std::endl;
    CoRet ret = CoFunction();
    std::cout << "CoFunction() next line" << std::endl;
    ret._h(); // 回到 co_await promise.initial_suspend()
    // 从co_await Awaitable()跳过来了
    std::cout << "=>" << ret._h.done() << std::endl; // 0

    ret._h.promise()._message.str = "hello"; // 写到协程的promise对象中
    ret._h.resume();                         // 回到co_await Awaitable();
    std::cout << "over" << std::endl;
    std::cout << ret._h.done() << std::endl; // 0
    std::cout << ret._h.promise()._out << std::endl; // 888888
    // 协程结束后不能在被resume了

    return 0;
}
// ret._h.destory()可以提前销毁协程handle

// start main
// initial_suspend
// CoFunction() next line
// =>0
// coroutine message=hello
// 1
// final_suspend
// co_return 888888
// over
// 0
// 888888
```

### 简单理解协程调度

从这个例子中其实可以看 其实协程可以看成任务状态机，通过promise与coroutine_handle与外界交互
只不过最大优势就是 可以自动维持上下文，状态机挂起的时候，可以自动回到触发状态机的地方即调用resume()的地方。

这么一来像做服务器的有什么打的优势，其实就是epoll+协程+非阻塞IO，而且可以做到单线程并发
例如epoll 来了新连接 则为新连接创建协程，epoll监听连接套接字可读时 可以向promise中标记 你可以读了 或者 可以写了。然后进行resume() 每个协程内部其实就是死循环 read process write之类的相关操作，要暂时不处理了比如EAGAIN了，完全可以co_wait出去回到原来要执行的地方，可能会处理下一个协程，这么一来可以发现 C++协程更像是一种状态机的语法糖一样的感觉，而且很容易围绕非阻塞IO去做
一些异步任务，而且完全可以单线程，安全好用简单，在必要的时候进行resume触发执行，协程也有自知之明 自己会co_wait co_yield co_return不会进行阻塞 不是在运行就是在挂起等待被resume 这才是关键与精髓。

```cpp

#include <coroutine>
#include <future>
#include <thread>
#include <iostream>
#include <unordered_map>
#include <unordered_set>
#include <vector>


using namespace std;

struct CoRet
{
    struct promise_type
    {
        int _in;
        int _out;
        int _res;
        suspend_never initial_suspend() {return {};}
        suspend_always final_suspend() noexcept {return {};}
        void unhandled_exception() {}
        CoRet get_return_object()
        { return 
            {coroutine_handle<promise_type>::from_promise(*this)};
        }
        suspend_always yield_value(int r) {
            _out = r;
            return {};
        }
        void return_value(int r) {
            _res = r;
        }
    };

    coroutine_handle<promise_type> _h; // _h.resume(), _h()
};

struct Input
{
    int* _in;
    int* _out;
    bool await_ready() { return false; }
    void await_suspend(coroutine_handle<CoRet::promise_type> h) 
    { _in = &h.promise()._in; _out = &h.promise()._out; }
    int await_resume() { return *_in; }
};

// 协程
CoRet Guess() {
    // co_await promise.initial_suspend();
    int res = (rand()%30)+1;
    Input input;
    int numGuess = 0;
    while(true)
    {
        int g = co_await input;
        
        ++numGuess;
        (*input._out) = (res>g ? 1: (res == g? 0 : -1));
        if((*input._out) == 0) co_return numGuess;
    }    
    // co_await promise.final_suspend();...
}



struct Hasher
{
    size_t operator() (const pair<int, int>& p) const
    {
        return (size_t)(p.first << 8) + (size_t)(p.second); 
    }
};
int main()
{
    srand(time(nullptr));

    unordered_map<pair<int, int>, vector<CoRet>, Hasher> buckets;
    for(auto i = 0; i<100; ++i) buckets[make_pair(1, 30)].push_back(Guess());

    while(!buckets.empty())
    {
        auto it = buckets.begin();
        auto& range = it->first;//1
        auto& handles = it->second;//vector<CoRet>存放协程
                
        int g = (range.first+range.second)/2;//中间数
        auto ur = make_pair(g+1, range.second);//右边部分
        auto lr = make_pair(range.first, g-1);//左边部分

        vector<future<int>> cmp;
        cmp.reserve(handles.size());

        // 这个循环是非阻塞的非常快
        for(auto& coret : handles)
        {
            // 为每个任务去开线程 去执行协程
            cmp.push_back(async(launch::async, [&coret, g]() { // 判断中间数
                coret._h.promise()._in = g;
                coret._h.resume(); // 协程内部遇见co_wait co_yield会返回来               
                return coret._h.promise()._out;
            }));
            // 获得许多future 即lamda返回值向条件变量一样
        }

        // 遍历所有协程，前面已经让协程去异步运行了
        for(int i=0; i< handles.size(); ++i)
        {
            int r = cmp[i].get(); // 等待future返回值这里是阻塞的 只有相应协程被resume lamda返回才可以get()返回
            
            if(r == 0) {//猜对了
                cout << "The secret number is " << handles[i]._h.promise()._in
                << ", total # guesses is " << handles[i]._h.promise()._res
                << endl;
            }            
            else if (r == 1) buckets[ur].push_back(handles[i]);//将协程移到右边部分去执行
            else buckets[lr].push_back(handles[i]);//将协程移到左边部分去执行
        }
        buckets.erase(it);//删除原来范围的，猜中了的不用再猜协程中的数字了，剩余协程不是去左边就是右边
    }

/*
    auto ret = Guess();
    pair<int, int> range = {1,30};    
    int in, out;
    do
    {
        in = (range.first+range.second)/2;
        ret._h.promise()._in = in; 
        cout << "main: make a guess: " << ret._h.promise()._in << endl;

        ret._h.resume(); // resume from co_await

        out = ret._h.promise()._out;
        cout << "main: result is " << 
        ((out == 1) ? "larger" :
        ((out == 0) ? "the same" : "smaller"))
            << endl;
        if(out == 1) range.first = in+1;
        else if(out == -1) range.second = in-1;
    }
    while(out != 0);
*/
}
```

### 不同线程resume同一个协程

一个线程程将一个协程运行到某个位置 然后协程挂起了。
完全可以使用其他线程 继续完成协程。
谁进行resume谁就执行协程 而且resume内部还可能触发另一个协程handle的resume。
这里就发现了，其实resume需要保证线程安全，通过一个挂起的协程handle被多个线程同时handle,会出现问题的。
C++协程是无栈协程 其协程frame存放在堆上 而且是对称的协程 也就是协程之间地位是平等的 一个协程可以随便
跳到其他协程 哪怕在两个协程见反复横跳都没问题 但是如果我们用一起的函数调用 这样loop多了就会栈溢出了
而无栈协程不会，只是在两个状态机之间切换跳转。

```cpp
#include <iostream>
#include <coroutine>
#include <string_view>
#include <thread>
#include <future>

class CoMessage
{
public:
    std::string_view str;
};

struct Awaitable;

struct CoRet
{
    struct promise_type
    {
        CoMessage _message;
        std::string_view _out;

        std::suspend_always initial_suspend()
        {
            std::cout << "3=>" << std::this_thread::get_id() << std::endl;
            return {};
        }

        std::suspend_never final_suspend() noexcept;

        void unhandled_exception()
        {
        }

        CoRet get_return_object()
        {
            std::cout << "4=>" << std::this_thread::get_id() << std::endl;
            return {std::coroutine_handle<promise_type>::from_promise(*this)};
        }

        std::suspend_never yield_value(std::string_view r)
        {
            _out = r;
            return {};
        }

        // void return_void()
        // {
        // }

        void return_value(std::string_view str)
        {
            std::cout << "5=>" << std::this_thread::get_id() << std::endl;
            _out = str;
        }
    };

    std::coroutine_handle<promise_type> _h;
};

struct Awaitable
{
    CoMessage *_message;
    bool await_ready() noexcept
    {
        return false;
    }

    void await_suspend(std::coroutine_handle<CoRet::promise_type> h) noexcept
    {
        _message = &h.promise()._message;
    }

    CoMessage await_resume() noexcept
    {
        std::cout << "6=>" << std::this_thread::get_id() << std::endl;
        return *_message;
    }
};

std::suspend_never CoRet::promise_type::final_suspend() noexcept
{
    std::cout << "7=>" << std::this_thread::get_id() << std::endl;
    return {};
}

CoRet CoFunction()
{
    std::cout << "2=>" << std::this_thread::get_id() << std::endl;
    CoMessage message1 = co_await Awaitable();
    CoMessage message2 = co_await Awaitable();
    CoMessage message3 = co_await Awaitable();
    co_return "888888";
}

int main(int argc, char **argv)
{
    std::cout << "1=>" << std::this_thread::get_id() << std::endl;
    CoRet ret = CoFunction();
    ret._h();
    ret._h.promise()._message.str = "hello";
    ret._h.resume();
    // 开新线程去处理协程
    std::future<int> fu = std::async(
        [&]
        {
            ret._h.resume();
            ret._h.resume();
            return 999;
        });
    fu.get(); // 等待异步任务
    return 0;
}

// 1=>140087387162432
// 4=>140087387162432
// 3=>140087387162432
// 2=>140087387162432
// 6=>140087387162432
// 6=>140087383815744
// 6=>140087383815744
// 5=>140087383815744
// 7=>140087383815744
```

### C风格揭秘协程

CppCon 2016 C++ Coroutines Under the Covers

Coroutines In C

```cpp
void* f(int n)
{
    void* hdl = CORO_BEGIN(malloc);
    for(int i = n;; ++i)
    {
        CORO_SUSPEND(hdl);
        print(i);
        CORO_SUSPEND(hdl);
        print(-i);
    }
    CORO_END(hdl, free);
}
int main()
{
    void* coro = f(1);
    for(int i = 0; i < 4; ++i)
    {
        CORO_RESUME(coro);
    }
    CORO_DESTROY(coro);
}
// 输出 1,-1,2,-2

define i32 @main()
{
    call void @print(i32 1)
    call void @print(i32 -1)
    call void @print(i32 2)
    call void @print(i32 -2)
    ret i32 0
}
```

如何建立协程的帧 Build Coroutine Frame

```cpp
void* f(int n)
{
    void* hdl = CORO_BEGIN(malloc);
    for(int i = n;; ++i)
    {
        CORO_SUSPEND(hdl);
        print(i);
        CORO_SUSPEND(hdl);
        print(-i);
    }
    CORO_END(hdl, free);
}
// 只需要记录声明周期跨越CORO_SUSPEND的
struct f.frame {
    int i;
};
```

解密创建协程帧

```cpp
struct f.frame {
    int i;
}
void* f(int n)
{
    void* hdl = CORO_BEGIN(malloc);
    f.frame* frame = (f.frame*)hdl;
    for(frame->i = n;; ++frame->i)
    {
        CORO_SUSPEND(hdl);
        print(frame->i);
        CORO_SUSPEND(hdl);
        print(-frame->i);
    }
    CORO_END(hdl, free);
}
```

解密创建跳跃点 Create Jump Points，像游戏存档一样

```cpp
struct f.frame
{
    int suspend_index;
    int i;
};
void* f(int n)
{
    void* hdl = CORO_BEGIN(malloc);
    f.frame* frame = (f.frame*)hdl;
    for(frame->i = n;; ++frame->i)
    {
        frame->suspend_index = 0;
r0:     CORO_SUSPEND(hdl);
        print(frame->i);
        frame->suspend_index = 1;
r1:     CORO_SUSPEND(hdl);
        print(-frame->i);
    }
    CORO_END(hdl, free);
}
```

背后可以分为三部分

```cpp
// Coroutine Start Function
void* f(int n)
{
    void* hdl = CORO_BEGIN(malloc);
    //...
    return hdl;
}
// Coroutine Resume Function
void f.resume(f.frame* frame)
{
    switch(frame->suspend_index)
    {
        //...
    }
}
// Coroutine Destroy Function
void f.destroy(f.frame* frame)
{
    switch(frame->suspend_index)
    {
        //...
    }
    free(frame);
}
```

假设编译器生成的f.resume

```cpp
void f.resume(f.frame* frame)
{
    switch (frame->suspend_index)
    {
        case 0: goto r0;
        default: goto r1;
    }
    for(frame->i = n;;++frame->i)
    {
        frame->suspend_index = 0;
r0:     CORO_SUSPEND(hdl);
        print(frame->i);
        frame->suspend_index = 1;
r1:     CORO_SUSPEND(hdl);
        print(-frame->i);
    }
    CORO_END(hdl, free);
}
```

After CleanUp

```cpp
void* f(int* n)
{
// 进一步抽象
    void* hdl = CORO_BEGIN(malloc);
    f.frame* frame = (f.frame*)hdl;
    frame->ResumeFn = &f.resume;
    frame->DestroyFn = &f.destroy;
    frame->i = n;
    frame->suspend_index = 0;
    return coro_hdl;
}
void f.destroy(f.frame* frame)
{
    free(frame);
}
void f.cleanup(f.frame* frame){}
void f.resume(f.frame* frame)
{
    if(frame->index == 0)
    {
        print(frame->i);
        frame->suspend_index = 1;
    }
    else
    {
        print(-frame->i);
        ++frame->i;
        frame->suspend_index = 0;
    }
}
struct f.frame
{
    FnPtr ResumeFn;
    FnPtr DestroyFn;
    int suspend_index;
    int i;
};
```

### std::noop_coroutine

std::noop_coroutine() 是 C++20 中引入的一个函数，位于 <coroutine> 头文件中。它是一个空的协程（coroutine），用作协程（coroutine）的占位符或者空操作。

### 尽可能用协程替代std::future与std::promise

因为future和promise 需要分配内存 原子操作 互斥锁 条件变量等，开销比较大。例如，假设在某些代码中需要传递一个协程对象，但是实际上不需要执行该协程，这时就可以使用 std::noop_coroutine() 来代替，以达到占位的目的。

![future与promise](../.gitbook/assets/2024-03-30172542.png)

可以免去额外的内存申请 原子操作 互斥锁 条件变量的开销

下面代码整体经过流程

1. 创建王子协程 suspend_always。
2. 创建公主协程 suspend_always。  
3. 将公主协程赋值到王子协程的promise _next上去
4. 公主协程去co_await王子
5. 进而触发王子的await_suspend 在其中进行std::async对王子进行resume
王子 std::this_thread::sleep_for(500ms); 然后co_return将金币赋值到了promise上
最后利用王子 final_suspend 返回一个awaiter await_ready返回false 触发 await_suspend 返回值 决定跳往哪里王子的有_next则跳往公主的int c = co_await future; 得到了王子co_return的金币量。  
6. 最后公主也co_return了，其返回awaiter的await_ready返回false,公主协程被done了标记为1，而且awaiter await_suspend返回空协程，最后我们async创建的协程其实结束了,主线程一直循环检查公主done,此时公主done了，一切都结束了。

```cpp
#include <iostream>
#include <chrono>
#include <future>
#include <thread>
#include <coroutine>
using namespace std;

struct Task
{
    struct promise_type
    {
        int _result;
        coroutine_handle<> _next = nullptr;

        Task get_return_object()
        {
            return Task{coroutine_handle<promise_type>::from_promise(*this)};
        }

        std::suspend_always initial_suspend()
        {
            return {};
        }

        // 协程结束时 王子结束时利用最后的co_wait final_suspend() 利用final_suspend返回值运行公主协程
        auto final_suspend() noexcept
        {
            struct next_awaiter
            {
                promise_type *me;
                bool await_ready() noexcept
                {
                    return false;
                }
                coroutine_handle<> await_suspend(coroutine_handle<promise_type> h) noexcept
                {
                    // 跳到哪里
                    if (h.promise()._next)
                    {
                        return h.promise()._next; // 有公主就跳到公主挂起哪里
                    }
                    else
                    {
                        return std::noop_coroutine();
                    }
                }
                void await_resume() noexcept
                {
                }
            };
            return next_awaiter{this};
        }

        void return_value(int i) { _result = i; }
        void unhandled_exception() {}
    };

    using handle = coroutine_handle<promise_type>;
    handle _h;
    std::future<void> _t;

    // awaiter
    bool await_ready()
    {
        return false;
    }
    void await_suspend(handle h)
    {
        _h.promise()._next = h;
        _t = std::async(
            [&]()
            {
                _h.resume();
            });
    }
    int await_resume()
    {
        return _h.promise()._result;
    }
};

Task Prince()
{
    int coins = 1;
    std::this_thread::sleep_for(500ms);
    std::cout << std::this_thread::get_id() << "Prince - found treasure!" << std::endl;
    co_return coins;
}

Task Princess(Task &future)
{
    std::cout << std::this_thread::get_id() << "Princess - wait for Prince" << std::endl;
    int c = co_await future; // 触发Prince的await_suspend 把公主协程挂到王子的promise的next 然后开一个线程去resume王子
    std::cout << std::this_thread::get_id() << "Princess - got" << c << " coins." << std::endl;
    co_return 0;
}

int main(int argc, char **argv)
{
    auto prince = Prince();           // 创建王子协程
    auto princess = Princess(prince); // 创建公主协程
    princess._h.resume();             // 会执行到co_wait future返回

    while (!princess._h.done())
    {
        cout << std::this_thread::get_id() << " main wait ...\n";
        std::this_thread::sleep_for(100ms);
    }
    std::cout << std::this_thread::get_id() << " main: done" << std::endl;
    return 0;
}

/*
140521947157440Princess - wait for Prince
140521947157440 main wait ...
140521947157440 main wait ...
140521947157440 main wait ...
140521947157440 main wait ...
140521947157440 main wait ...
140521947141696Prince - found treasure!
140521947141696Princess - got1 coins.
140521947157440 main: done
*/
```
