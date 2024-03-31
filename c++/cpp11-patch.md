# 🐕 C++11 特性

C++11 引入了许多新特性和语言改进，下面是其中一些主要的特性：

1、自动类型推断（auto）：使用 auto 关键字，编译器可以自动推断变量的类型，从而简化变量声明和定义。

2、Lambda 表达式：Lambda 表达式是一个可调用的代码块，它可以像函数一样接受参数和返回值，并且可以在函数内部定义。

3、Range-based for 循环：可以使用范围 for 循环遍历容器中的元素，代码更加简洁明了。

4、nullptr 关键字：C++11 引入了一个新的关键字 nullptr，用来表示空指针。

5、右值引用（rvalue reference）：C++11 引入了右值引用的概念，可以支持移动语义和完美转发，提高了代码的性能和可维护性。

6、管理内存的智能指针：引入了 shared_ptr 和 unique_ptr 等智能指针，可以更加方便地管理内存。

7、静态断言（static_assert）：C++11 引入了静态断言，用于在编译时检查表达式是否为真，如果不为真，则会产生编译错误。

8、变长参数模板（variadic template）：C++11 中可以使用模板来定义可变数量的参数列表。

9、类型别名（type alias）：使用 typedef 关键字可以给类型取一个别名，而使用关键字 using 可以更加灵活地定义类型别名。

10、Unicode 字符串字面量：C++11 支持 Unicode 字符串字面量，可以更好地处理多语言字符集。

11、并发编程库：C++11 引入了一个并发编程库，包括原子操作、线程、锁等功能，可以更加方便地进行并发编程。可以读一下《C++并发编程实战第2版》

12、统一初始化语法`{}`初始化

13、委托构造函数

14、constexper函数和变量

15、类型推断decltype

16、智能指针

17、字符串字面值`R"()"`

18、std::function 和 std::bind

19、虚析构函数

20、override 和 final 关键字

## 线程局部存储

### 操作系统和编译器对线程局部存储的支持

线程局部存储是指对象内存在线程开始后分配，线程结束时回收且每个线程有该对象自己的实例，简单地说，线程局部存储的对象都是独立于各个线程的。实际上，这并不是一个新鲜的概念，虽然C++一直没有在语言层面支持它，但是很早之前操作系统就有办法支持线程局部存储了。

在Windows中可以通过API函数TlsAlloc来分配一个未使用的线程局部存储槽索引(TLS slot index),这个索引实际上是Windows
内部线程环境块TEB中线程局部存储数组的索引。通过API函数TlsGetValue与TlsSetValue可以获取和设置线程局部存储数组
对应于索引元素的值。API函数TlsFree用于释放线程局部存储槽索引。

Linux使用了pthreads (POSIX threads)作为线程接口，在pthreads中可以调用pthread_key_create、pthread_key_delete
创建与删除一个类型为pthread_key_t的键。利用这个键可以使用pthread_setspecific函数设置线程相关的内存数据。
可以用pthread_getspecific函数获取之前设置的内存数据。

在C++11之前各个编译器有自己的关键字，gcc和clang用`__thread`声明线程局部存储变量。Visual Studio C++则用
`__declspec(thread)`,各个编译器五花八门，C++11标准中正式添加了新的`thread_local`说明符来声明线程局部存储变量。

### thread_local说明符

thread_local说明符可以用来声明线程声明周期的对象。可以与static和extern结合，分别指定内部与外部链接，不过额外的
static并不影响对象的声明周期。

```cpp
#include <iostream>
using namespace std;

struct X
{
    thread_local static int i;
};

thread_local X a;

int main(int argc, char **argv)
{
    thread_local X b;
    return 0;
}
```

线程局部存储，它能够解决全局变量或者静态变量在多线程操作中存在的问题，典型的例子就是errno.  
POSIX将errno重新定义为线程独立的变量，直到C++11之前，errno都是一个静态变量，而从C++11开始errno被修改为一个
线程局部存储变量。

尽可能不要将线程局部存储变量，提供给线程外使用，不然声明周期没有管理好，可能会造成未定义的程序形为，程序崩溃。

使用取地址运算符`&`取到线程局部存储变量的地址是运行时被计算出来的，它不是一个常量，无法与constexper结合

```cpp
#include <iostream>
using namespace std;

int n = 0;

class X
{
public:
    static int n;
};

int X::n = 0;

thread_local int tv;

int main(int argc, char **argv)
{
    constexpr int *n_ptr = &n; // 可以
    static int n1 = 0;
    constexpr int *n1_ptr = &n1;   // 可以
    constexpr int *x_nptr = &X::n; // 可以

    int x = 0;
    // constexpr int *x_ptr = &x;
    // main.cpp(10, 28): 变量 "x" (已声明 所在行数:9) 的指针或引用不可用作常量

    // constexpr int *tv_ptr = &tv;
    // main.cpp(27, 29): 变量 "tv" (已声明 所在行数:14) 的指针或引用不可用作常量

    return 0;
}
```

tv在线程创建时才可能确定内存地址。

### 线程局部存储对象初始化与销毁

线程threadfunc1和threadfunc2分别只调用了一次构造和析构函数，而且引用计数的递增也不会互相干扰，也就是说两个线程中线程局部存储对象是独立存在的。

线程threadfunc3，它进行了两次线程局部存储对象的构造和析构，这两次分别对应foo和bar函数里的线程局部存储对象tv。现，虽然这两个对象具有相同的对象名，
但是由于不在同一个函数中，因此也应该认为是相同线程中不同的线程局部存储对象，它们的引用计数的递增同样不会相互干扰。

```cpp
#include <iostream>
#include <string>
#include <thread>
#include <mutex>
using namespace std;

std::mutex g_out_lock;

struct RefCount
{
    RefCount(const char *f) : i(0), func(f)
    {
        std::lock_guard<std::mutex> lock(g_out_lock);
        std::cout << std::this_thread::get_id() << "|" << func << " ：ctor i(" << i << ")" << std::endl;
    }
    ~RefCount()
    {
        std::lock_guard<std::mutex> lock(g_out_lock);
        std::cout << std::this_thread::get_id() << "|" << func << " :dtor i(" << i << ")" << std::endl;
    }
    void inc()
    {
        std::lock_guard<std::mutex> lock(g_out_lock);
        std::cout << std::this_thread::get_id() << "|" << func << " :ref count add 1 to i(" << i << ")" << std::endl;
        i++;
    }
    int i;
    std::string func;
};

RefCount *lp_ptr = nullptr;

void foo(const char *f)
{
    std::string func(f);
    thread_local RefCount tv(func.append("#foo").c_str());
    tv.inc();
}

void bar(const char *f)
{
    std::string func(f);
    thread_local RefCount tv(func.append("#bar").c_str());
    tv.inc();
}

void threadfunc1()
{
    const char *func = "threadfunc1";
    foo(func);
    foo(func);
    foo(func);
}

void threadfunc2()
{
    const char *func = "threadfunc2";
    foo(func);
    foo(func);
    foo(func);
}

void threadfunc3()
{
    const char *func = "threadfunc3";
    foo(func);
    bar(func);
    bar(func);
}

int main(int argc, char **argv)
{
    std::thread t1(threadfunc1);
    std::thread t2(threadfunc2);
    std::thread t3(threadfunc3);
    t1.join();
    t2.join();
    t3.join();
    return 0;
}

// 139681121900096|threadfunc1#foo ：ctor i(0)
// 139681121900096|threadfunc1#foo :ref count add 1 to i(0)
// 139681121900096|threadfunc1#foo :ref count add 1 to i(1)
// 139681121900096|threadfunc1#foo :ref count add 1 to i(2)
// 139681121900096|threadfunc1#foo :dtor i(3)
// --------------------------------------------------------------
// 139681105114688|threadfunc3#foo ：ctor i(0)
// 139681105114688|threadfunc3#foo :ref count add 1 to i(0)
// 139681105114688|threadfunc3#bar ：ctor i(0)
// 139681105114688|threadfunc3#bar :ref count add 1 to i(0)
// 139681105114688|threadfunc3#bar :ref count add 1 to i(1)
// 139681105114688|threadfunc3#bar :dtor i(2)
// 139681105114688|threadfunc3#foo :dtor i(1)
// --------------------------------------------------------------
// 139681113507392|threadfunc2#foo ：ctor i(0)
// 139681113507392|threadfunc2#foo :ref count add 1 to i(0)
// 139681113507392|threadfunc2#foo :ref count add 1 to i(1)
// 139681113507392|threadfunc2#foo :ref count add 1 to i(2)
// 139681113507392|threadfunc2#foo :dtor i(3)
```
