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

## alignas和alignof

### 不可忽视的字节对齐问题

C++11中新增了alignof和alignas两个关键字，其中alignof运算符可以用于获取类型的对齐字节长度，alignas说明符可以用来改变类型的默认对齐字节长度。这两个关键字的出现解决了长期以来C++标准中无法对数据对齐进行处理的问题。

字节对齐的知识可以看 C++ 第 19 章 特殊工具与技术 内存字节对齐部分

### C++11标准之前控制数据对齐的方法

C++11之前没有一个标准的方法设定数据的对齐字节长度，只能依靠编程技巧和各种编译器提供的扩展功能。

```cpp
#include <iostream>
using namespace std;

#define ALIGNOF(type, result)   \
    struct type##_alignof_trick \
    {                           \
        char c;                 \
        type member;            \
    };                          \
    result = offsetof(type##_alignof_trick, member)

// offsetof: Offset of member MEMBER in a struct of type TYPE.

int main(int argc, char **argv)
{
    int x1 = 0;
    ALIGNOF(int, x1);
    std::cout << x1 << std::endl; // 4
    return 0;
}
```

上面的把戏不能在某些类型使用，如函数指针

```cpp
int x1 = 0;
ALIGNOF(void(*)(), x1); // 无法通过编译
```

可以使用typedef解决

```cpp
#include <iostream>
using namespace std;

#define ALIGNOF(type, result)   \
    struct type##_alignof_trick \
    {                           \
        char c;                 \
        type member;            \
    };                          \
    result = offsetof(type##_alignof_trick, member)

// offsetof: Offset of member MEMBER in a struct of type TYPE.

int main(int argc, char **argv)
{
    int x1 = 0;
    typedef void (*f)();
    ALIGNOF(f, x1);
    std::cout << x1 << std::endl; // 8
    return 0;
}
```

一种更好的写法使用类模板

```cpp
#include <iostream>
using namespace std;

template <class T>
struct alignof_trick
{
    char c;
    T member;
};

#define ALIGNOF(type) offsetof(alignof_trick<type>, member)

int main(int argc, char **argv)
{
    auto x1 = ALIGNOF(int);
    auto x2 = ALIGNOF(void (*)());
    auto x3 = ALIGNOF(char *);
    std::cout << x1 << " " << x2 << " " << x3 << std::endl; // 4 8 8
    return 0;
}
```

MSVC和GCC C++11之前提供了自己的alignof

```cpp
// MSVC
auto x1 = __alignof(int)
auto x2 = __alignof(void(*)())
// GCC
#include <iostream>
using namespace std;

auto x3 = __alignof__(int);
auto x4 = __alignof__(void (*)());

int main(int argc, char **argv)
{
    std::cout << x3 << " " << x4 << std::endl; // 4 8
    return 0;
}
```

对于设置字节对齐C++11之前不得不用编译器提供的扩展功能。

```cpp
// MSVC
short x1;
__declspec(align(8)) short x2;
std::cout << "x1 = " << __alignof(x1) << std::endl;
std::cout << "x2 = " << __alignof(x2) << std::endl;
```

```cpp
#include <iostream>
using namespace std;

short x3;
__attribute__((aligned(8))) short x4;

int main(int argc, char **argv)
{
    std::cout << __alignof__(x3) << std::endl; // 2
    std::cout << __alignof__(x4) << std::endl; // 8
    return 0;
}
```

### C++11使用alignof运算符

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    auto x1 = alignof(int);
    auto x2 = alignof(void (*)());
    int a = 0;
    auto x3 = alignof(a);
    auto x4 = alignof(decltype(a));
    std::cout << x1 << " " << x2 << " " << x3 << " " << x4 << std::endl;
    // 4 8 4 4
    return 0;
}
```

假设我们为a设置下字节对齐

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    auto x1 = alignof(int);
    auto x2 = alignof(void (*)());
    alignas(8) int a = 0;
    auto x3 = alignof(a);
    auto x4 = alignof(decltype(a));
    std::cout << x1 << " " << x2 << " " << x3 << " " << x4 << std::endl;
    // 4 8 8 4
    return 0;
}
```

可以通过alignof获得类型`std::max_align_t`的对齐字节长度，这是一个非常重要的值。C++11定义了`std::max_align_t`，它是一个平凡的标准布局类型，其对齐字节长度要求至少与每个标量类型一样严格。也就是说，所有的标量类型都适应`std::max_align_t`的对齐字节长度。C++标准还规定，诸如new和malloc之类的分配函数返回的指针需要适合于任何对象，也就是说内存地址至少与`std::max_align_t`严格对齐。

```cpp
#include <iostream>
#include <cstddef>
using namespace std;

int main(int argc, char **argv)
{
    for (int i = 0; i < 100; i++)
    {
        auto *p = new char;
        auto addr = reinterpret_cast<std::uintptr_t>(p);
        std::cout << addr % alignof(std::max_align_t) << std::endl; // 全输出0
        delete p;
    }
    std::cout << alignof(std::max_align_t) << std::endl; // 16
    return 0;
}

//std::uintptr_t 是 C++ 标准库中定义的一种整数类型，它是无符号整数类型，足以容纳指针的位数，并且可以用于在指针和整数之间进行转换。在 C++11 标准之后引入，位于 <cstdint> 头文件中。
//这种类型的主要作用是在需要在指针和整数之间进行转换时提供一种标准的方式，通常在涉及低级内存操作或者跨平台开发时会用到。
```

### C++11使用alignas说明符

```cpp
alignas(n)
// n必须为2的幂值
```

```cpp
#include <iostream>
using namespace std;

struct X
{
    char a1;
    int a2;
    double a3;
};

struct X1
{
    alignas(16) char a1;
    alignas(double) int a2;
    double a3;
};

int main(int argc, char **argv)
{
    std::cout << alignof(X) << std::endl;     // 8
    std::cout << sizeof(X) << std::endl;      // 16
    std::cout << alignof(X1) << std::endl;    // 16
    std::cout << sizeof(X1) << std::endl;     // 32
    std::cout << sizeof(double) << std::endl; // 8
    return 0;
}
```

还可以设置结构体的对齐方式

```cpp
#include <iostream>
using namespace std;

struct alignas(16) X2
{
    char a1;
    int a2;
    double a3;
};

struct alignas(16) X3
{
    alignas(8) char a1;
    alignas(double) int a2;
    double a3;
};

struct alignas(4) X4
{
    alignas(8) char a1;
    alignas(double) int a2;
    double a3;
};

// alignas(1)作用就是X5占用的字节数是1的倍数，就是设置1没有什么意义
struct alignas(1) X5
{
    alignas(1) char a1;
    alignas(1) int a2;
    alignas(1) char a3;
};

int main(int argc, char **argv)
{
    std::cout << alignof(X2) << std::endl; // 16
    std::cout << sizeof(X2) << std::endl;  // 16

    std::cout << alignof(X3) << std::endl; // 16
    std::cout << sizeof(X3) << std::endl;  // 32

    std::cout << alignof(X4) << std::endl; // 8
    std::cout << sizeof(X4) << std::endl;  // 24

    std::cout << alignof(X5) << std::endl;      // 4
    std::cout << sizeof(X5) << std::endl;       // 12
    std::cout << offsetof(X5, a1) << std::endl; // 0
    std::cout << offsetof(X5, a2) << std::endl; // 4
    std::cout << offsetof(X5, a3) << std::endl; // 8

    alignas(4) X5 x5;
    std::cout << alignof(x5) << std::endl; // 4
    return 0;
}
```

### C++11其他对齐字节长度的支持

C++11提供了 `alignof`和`alignas`支持对齐字节长度的控制之外，还提供了
`std::alignment_of`、`std::aligned_storage`、`std::aligned_union`类模板以及
`std::align`函数模板支持对于对齐字节长度的控制。

* `std::alignment_of`和`alignof`功能相似，可以获取类型的对齐字节长度

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    std::cout << std::alignment_of<int>::value << std::endl; // 4
    std::cout << std::alignment_of<int>() << std::endl;      // 4

    std::cout << std::alignment_of<double>::value << std::endl; // 8
    std::cout << std::alignment_of<double>() << std::endl;      // 8
    return 0;
}
```

* `std::aligned_storage`可以用来分配一块指定对齐字节长度和大小的内存

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    std::aligned_storage<128, 16>::type buffer;
    std::cout << sizeof(buffer) << std::endl;                     // 128 内存长度
    std::cout << alignof(buffer) << std::endl;                    // 16对齐长度
    std::cout << (sizeof(buffer) % alignof(buffer)) << std::endl; // 0
    return 0;
}
```

* `std::aligned_union`接受一个`std::size_t`作为分配内存的大小，以及不定数量的类型。`std::aligned_union`会获取这些类型中对齐字节长度最大作为分配内存的对齐字节长度。

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    std::aligned_union<64, double, int, char>::type buffer;
    std::cout << sizeof(buffer) << std::endl;  // 64
    std::cout << alignof(buffer) << std::endl; // 8
    std::cout << alignof(double) << std::endl; // 8
    std::cout << alignof(int) << std::endl;    // 4
    std::cout << alignof(char) << std::endl;   // 1
    return 0;
}
```

* `std::aligned_alloc` 是 C++17 中引入的函数，用于分配一块特定对齐要求的内存。

```cpp
// void* aligned_alloc(std::size_t alignment, std::size_t size);
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    char *buffer = (char *)std::aligned_alloc(8, 5);
    for (int i = 0; i < 5; i++)
    {
        buffer[i] = i;
    }
    std::free(buffer);
    return 0;
}
```

* `std::align`函数模板，该函数接受一个指定大小的缓冲区空间的指针和一个对齐字节长度，返回一个该缓冲区中最近的能找到符合指定对齐字节长度的指针。通常来说，我们传入的缓冲区内存大小为预分配的缓冲区大小加上预指定对齐字节长度的字节数。

```cpp
void* align(std::size_t alignment, std::size_t size, void*& ptr, std::size_t& space);
```

```cpp
#include <iostream>
#include <memory>
using namespace std;

int main(int argc, char **argv)
{
    constexpr int align_size = 32;
    constexpr int alloc_size = 10001;
    constexpr int buff_size = align_size + alloc_size;
    char dest[buff_size]{0};
    char src[buff_size]{0};
    void *dest_ori_ptr = dest;
    void *src_ori_ptr = src;

    size_t dest_size = sizeof(dest);
    size_t src_size = sizeof(src);

    char *dest_ptr = static_cast<char *>(std::align(align_size, alloc_size, dest_ori_ptr, dest_size));
    char *src_ptr = static_cast<char *>(std::align(align_size, alloc_size, src_ori_ptr, src_size));

    printf("%lu\n", reinterpret_cast<std::uintptr_t>(dest));                       // 140728303141552
    std::cout << reinterpret_cast<std::uintptr_t>(dest) % align_size << std::endl; // 16
    printf("%lu\n", reinterpret_cast<std::uintptr_t>(src));                        // 140728303151600
    std::cout << reinterpret_cast<std::uintptr_t>(src) % align_size << std::endl;  // 16

    printf("%lu\n", reinterpret_cast<std::uintptr_t>(dest_ptr));                       // 140728303141568
    std::cout << reinterpret_cast<std::uintptr_t>(dest_ptr) % align_size << std::endl; // 0
    printf("%lu\n", reinterpret_cast<std::uintptr_t>(src_ptr));                        // 140728303151616
    std::cout << reinterpret_cast<std::uintptr_t>(src_ptr) % align_size << std::endl;  // 0
    return 0;
}
```

## C++11显式自定义类型转换运算符

C++支持自定义类型转换运算符，自定义转换运算符可以对原本没有关系的两个类型进行转换。C++专家对自定义类型转换都保持谨慎的态度，原因是自定义类型转换可能更容易写出
与实际期待不符的代码，编译器无法给出提示。

```cpp
#include <iostream>
#include <vector>
using namespace std;

template <class T>
class SomeStorage
{
public:
    SomeStorage() = default;
    SomeStorage(std::initializer_list<T> l) : data_(l){};
    operator bool() const
    {
        std::cout << typeid(T).name() << " "
                  << "operator bool()" << std::endl;
        return !data_.empty();
    }

private:
    std::vector<T> data_;
};

int main(int argc, char **argv)
{
    SomeStorage<float> s1{1., 2., 3.};
    SomeStorage<int> s2{1, 2, 3};
    std::cout << std::boolalpha << "s1 == s2 : " << (s1 == s2) << std::endl;
    std::cout << "s1 + s2 : " << (s1 + s2) << std::endl;
    /*
    s1 == s2 : f operator bool()
    i operator bool()
    true
    s1 + s2 : f operator bool()
    i operator bool()
    2
    */
    return 0;
}
```

在s1和s2比较和相加的过程中，编译器会对它们做隐式的自定义类型转换以符合比较和相加的条件。求和运算会将bool转为int,结果输出2。可见，自定义类型
转换运算符有时候就是这么不尽如人意。类型转换问题不止存在于自定义类型转换运算符，构造函数中也有同样问题。

```cpp
#include <iostream>
#include <cstring>
using namespace std;

class SomeString
{
public:
    SomeString(const char *p) : str_(strdup(p)) {}
    SomeString(int alloc_size) : str_((char *)malloc(alloc_size)) {}
    ~SomeString() { free(str_); }

private:
    char *str_;
    friend void PrintStr(const SomeString &str);
};

void PrintStr(const SomeString &str)
{
    std::cout << str.str_ << std::endl;
}

int main(int argc, char **argv)
{
    PrintStr("hello world");
    PrintStr(58); // 代码写错 却编译成功了 漏写了 "58"
    return 0;
}
```

因为58隐式调用了`SomeString(int alloc_size)`。当然C++已经考虑到这种情况，可以使用explicit说明符将构造函数声明为显式，这样隐式的构造将无法通过
编译。

```cpp
class SomeString
{
public:
    SomeString(const char *p) : str_(strdup(p)) {}
    explicit SomeString(int alloc_size) : str_((char *)malloc(alloc_size)) {}
    ~SomeString() { free(str_); }

private:
    char *str_;
    friend void PrintStr(const SomeString &str);
};

PrintStr(SomeString(58));
```

借鉴构造函数的explicit,C++11将explicit引入自定义类型转换中，称为显式自定义类型转换。

```cpp
#include <iostream>
#include <vector>
using namespace std;

template <class T>
class SomeStorage
{
public:
    SomeStorage() = default;
    SomeStorage(std::initializer_list<T> l) : data_(l) {}
    explicit operator bool() const
    {
        return !data_.empty();
    }

private:
    std::vector<T> data_{};
};

int main(int argc, char **argv)
{
    SomeStorage<float> s1{1., 2., 3.};
    SomeStorage<int> s2{1, 2, 3};
    // std::cout << (s1 == s2) << std::endl; // 编译失败 没有与这些操作数匹配的 "==" 运算符C/C++(349) 编译器推断不出来
    // std::cout << (s1 + s2) << std::endl;  // 编译失败 没有与这些操作数匹配的 "+" 运算符C/C++(349)

    std::cout << static_cast<bool>(s1) << std::endl; // 1 可以显式转换成功
    std::cout << static_cast<bool>(s2) << std::endl; // 1 可以显式转换成功
    return 0;
}
```

对于布尔转换，在以下几种语境，可以隐式执行布尔转换，即使这个转换被声明为explicit

* if、while、for的控制表达式
* 内建逻辑运算符 `!`、`&&`、`||`的操作数
* 条件运算符`?:`的首个操作数
* static_assert声明中的bool常量表达式
* noexcept说明符中的表达式

## 模板参数优化

### 允许局部和匿名类型作为模板实参

在C++11之前，将局部或匿名类型作为模板实参是不被允许的，C++11之后允许了。

```cpp
#include <iostream>
using namespace std;

template <class T>
class X
{
};

template <class T>
void f(T t){};

struct
{
} unnamed_obj;

int main(int argc, char **argv)
{
    struct A
    {
    };
    enum
    {
        e1
    };
    typedef struct
    {
    } B;
    B b;
    X<A> x1;
    X<A *> x2;
    X<B> x3;
    f(e1);
    f(unnamed_obj);
    f(b);
    return 0;
}
```

### 允许函数模板的默认模板参数

C++11中，可以自由在函数模板中使用默认的模板参数，C++11之前只能在类模板中 函数模板不支持。

```cpp
#include <iostream>
using namespace std;

template <class T = double>
void foo()
{
    T t;
}

template <class T = double>
void foo1(T t)
{
}

int main(int argc, char **argv)
{
    foo();   // void foo<double>()
    foo1(1); // void foo1<int>(int t)
    return 0;
}
```

我们知道类模板的默认模板参数以及函数的默认参数都要保证从右往左定义默认值，而函数模板没有
这样的限制。

```cpp
#include <iostream>
using namespace std;

template <class T = double, class U, class R = double>
void foo(U u)
{
}

int main(int argc, char **argv)
{
    foo(5);
    return 0;
}
```

## SFINAE

### 替换失败和编译错误

SFINAE（Substitution Failure Is Not An Error，替换失败不是错误）主要是指在函数模板重载时，当模板形参替换为指定的实参或由函数实参推导出模板形参的过程中出现了失败，则放弃这个重载而不是抛出一个编译失败。

```cpp
#include <iostream>
using namespace std;

template <int I>
struct X
{
};

char foo(int);
char foo(float);

template <class T>
X<sizeof(foo((T)0))> f(T)
{
    return X<sizeof(foo((T)0))>();
}

int main(int argc, char **argv)
{
    f(1);
    return 0;
}
```

在这段代码中，模板参数推导过程会推导出 T 为 int 类型。然后，在实例化函数模板 f 时，
编译器会尝试调用 `foo((T)0)`。由于 foo 函数有多个重载，编译器无法确定调用哪个版本。
但是根据 SFINAE 规则，编译器不会报错，而是会将这个候选项从候选集合中排除掉。
因此，这个模板实例化过程不会导致编译错误。

### SFINAE规则详解

在SFINAE规则中，模板形参的替换有两个时机，首先是在模板推导的最开始阶段，当明确地指定替换模板形参的实参时进行替换；
其次在模板推导的最后，模板形参会根据实参进行推导或使用默认的模板实参。这个替换会覆盖到函数模板和模板形参中的所有类型和表达式。

```cpp
#include <iostream>
using namespace std;

template <class T>
T foo(T &t)
{
    T tt(t);
    return tt;
}

void foo(...) {}

int main(int argc, char **argv)
{
    double x = 7.0;
    foo(x); // double foo<double>(double &t)
    foo(5); // void foo(...)
    return 0;
}
```

`foo(x)`推导符合foo模板,而`foo(5)`不行，则将其交给了`void foo(...)`

下面的例子中，`foo(bar)`推导符合foo模板，然后完成替换进行下一步编译工作，编译器发现Bar无法生成隐式的复制构造函数。
想使用替换失败为时已晚，只能编译报错。

```cpp
#include <iostream>
using namespace std;

template <class T>
T foo(T &t)
{
    T tt(t);
    return tt;
}

void foo(...) {}

class Bar
{
public:
    Bar() {}
    Bar(Bar &&) {}
};

int main(int argc, char **argv)
{
    Bar bar;
    foo(bar);
    // note: ‘constexpr Bar::Bar(const Bar&)’ is implicitly declared as deleted because ‘Bar’ declares a move constructor or move assignment operator
    return 0;
}
```

下面的例子也比较类似,是推断时符合模板参数替换规则，编译进行下一步时发现构造函数不能访问，为时已晚只能编译报错。

```cpp
#include <iostream>
using namespace std;

template <class T>
T foo(T *t)
{
    return T();
}

void foo(...) {}

class Bar
{
    Bar() {}
};

int main(int argc, char **argv)
{
    foo(static_cast<Bar *>(nullptr));
    // error: ‘Bar::Bar()’ is private within this context
    return 0;
}
```

还有些其他的样例如下

```cpp
#include <iostream>
using namespace std;

template <class T>
struct A
{
    using X = typename T::X;
};

template <class T>
typename T::X foo(typename A<T>::X);

template <class T>
void foo(...) {}

template <class T>
auto bar(typename A<T>::X) -> typename T::X; // 后置返回

template <class T>
void bar(...) {}

int main()
{
    foo<int>(0); // 编译通过 void foo<int>(...)
    bar<int>(0); // error: ‘int’ is not a class, struct, or union type
    return 0;
}
```

下面是一个标准文档中的一个例子

```cpp
#include <iostream>
using namespace std;

struct X
{
};
struct Y
{
    Y(X) {}
}; // X 可以转化为 Y

X foo(Y, Y) { return X(); }

template <class T>
auto foo(T t1, T t2) -> decltype(t1 + t2)
{
    return t1 + t2;
}

// 先模板推导，不符合+规则 替换失败处理 切好X能转化为Y
int main(int argc, char **argv)
{
    X x1, x2;
    X x3 = foo(x1, x2); // X foo(Y, Y)
    Y y1(x1), y2(x2);
    return 0;
}
```

下面的是一个非类型替换的SFINAE例子

```cpp
#include <iostream>
using namespace std;

template <int I>
void foo(char (*)[I % 2 == 0] = 0)
{
    std::cout << "I%2==0" << std::endl;
}

template <int I>
void foo(char (*)[I % 2 == 1] = 0)
{
    std::cout << "I%2==1" << std::endl;
}

int main(int argc, char **argv)
{
    char a[1];
    foo<1>(&a); // void foo<1>(char (*)[1] = (char (*)[1])0)
    foo<2>(&a); // void foo<2>(char (*)[1] = (char (*)[1])0)
    foo<3>(&a); // void foo<3>(char (*)[1] = (char (*)[1])0)
                // I%2==1
                // I%2==0
                // I%2==1
    return 0;
}
```

SFINAE结合decltype关键字发挥作用

```cpp
#include <iostream>
using namespace std;

class SomeObj1
{
public:
    void Dump2File() const
    {
        std::cout << "dump this object to file" << std::endl;
    }
};

class SomeObj2
{
};

template <class T>
auto DumpObj(const T &t) -> decltype(((void)t.Dump2File()), void())
{
    t.Dump2File();
}

void DumpObj(...)
{
    std::cout << "the object must have a member function Dump2File" << std::endl;
}

int main(int argc, char **argv)
{
    DumpObj(SomeObj1()); // auto DumpObj<SomeObj1>(const SomeObj1 &t)->void
    DumpObj(SomeObj2()); // void DumpObj(...)
    // dump this object to file
    // the object must have a member function Dump2File
    return 0;
}
```

请注意这里的写法`decltype(((void)t.Dump2File()),void())`，在括号里利用逗号表达式让编译器从左往右进行替换和推导，逗号右边的是最终我们想设置的函数返回值类型，而逗号左边则检查了对象t的类型是否具有Dump2File成员函数。如果成员函数存在，即符合语法规则，可以顺利地调用模板版本的函数；反之则产生替换失败，调用另一个重载版本的DumpObj函数。

## 外部模板

先回顾以下C和C++中extern关键字的作用：它可以在声明变量和函数的时候使用，用于指定目标为外部链接，但本身并不参与目标的定义，所以对目标的属性没有影响。extern最常被使用的场景是当一个变量需要在多份源代码中使用的时候，如果每份源代码都定义一个变量，在代码链接时会出错，正确的方法是在其中一个源代码中定义该变量，在其他的源代码中使用extern声明该变量为外部变量。

```cpp
// src1.cpp
int x = 0;
// src2.cpp
extern int x;
x = 11;
```

但是我们知道，在多份源代码中同一模板进行相同的实例化不会有任何链接问题

```cpp
// header.h
template<class T>
bool foo(T t)
{
	return true;
}
// src1.cpp
#include <header.h>
bool b = foo(7);
// src2.cpp
#include <header.h>
bool b = foo(11);
```

之所以没有连接问题，是因为连接器对模板有特殊待遇。 编译器在编译每份源代码的时候会按照单个源代码的需要生成模板的实例，
而连接器对于这些实例会进行一次去重操作。它将完全相同的实例删除，最后只留下一份实例。

这样就有了，问题，如果成千上万的源文件，都这样搞编译和链接将会符出大量的额外时间成本。

为了优化编译和链接的性能，C++11提出了外部模板的特性，这个特性保留了extern关键字的语义并扩展了关键字的功能，让它能够声明一个外部模板实例。

先回顾如何显式实例化一个模板

```cpp
// header.h
template<class T>
bool foo(T t)
{
	return true;
}
// src1.cpp
#include "header.h"
template bool foo<double>(double);
// src2.cpp
#include "header.h"
template bool foo<double>(double);
```

上面的每个源文件都实例化了一个模板实例，在链接时将其中一个副本删除。如果想在这里声明一个外部模板，只需要在其中一个
显式实例化前加上extern template，例如

```cpp
// header.h
template<class T> bool foo(T t)
{
	return true;
}
// src1.cpp
#include <header.h>
extern template bool foo<double>(double);
// src2.cpp
#include <header.h>
template bool foo<double>(double);
```

这样以来省去了之前的冗余副本实例生成和删除的过程，改变了构建过程。

外部模板同样支持类模板，例如

```cpp
// header.h
template<class T> 
class bar
{
public:
	void foo(T t) {};
};
// src1.cpp
#include<header.h>
extern template class bar<int>;
extern template void bar<int>::foo(int);
// src2.cp
#include<header.h>
template class bar<int>;
```

extern template不仅可以声明外部模板实例，还可以明确具体的外部实例成员函数。

工程实践：通常在实际的工程应用中并不会使用外部模板这个特性，因为这回大大增加项目代码的维护成本。但理论上，这种优化应该是比较有效的。

## 连续右尖括号的解析优化

C++11有个很扯淡的情况，两个连续的右尖括号`>>`会被编译器解析为右移。

```cpp
#include <vector>
typedef std::vector<std::vector<int> > Table; // 编译成功
typedef std::vector<std::vector<bool>> Flags; // 编译失败 >>被解析为右移
```

C++11则解决了以上问题，但是又出了新问题值得注意

```cpp
template<int N>
class X{};
X <1 >> 3>x;
```

在C++11中，`2>>3`不会被识别，而是`>`与前面的`<`匹配相当于`(X<1>)>3>x`,解决办法是

```cpp
X<(1>>3)> x;
```

而且此类问题还设计模板编程，例如

```cpp
#include <iostream>
using namespace std;

template <int I>
struct X
{
    static int const c = 2;
};

template <>
struct X<0>
{
    typedef int c;
};

template <typename T>
struct Y
{
    static int const c = 3;
};

static int const c = 4;

int main(int argc, char **argv)
{
    std::cout << (Y<X<1> >::c > ::c > ::c) << std::endl;//0
    std::cout << (Y<X< 1>>::c > ::c > ::c) << std::endl;//0
    return 0;
}
```

上面代码C++11会输出两个0，之前则会输出0和3

```cpp
//C++11
std::cout << (Y<(X<1> )>::c > ::c > ::c) << std::endl;//0
std::cout << (Y<(X< 1>)>::c > ::c > ::c) << std::endl;//0
// 即 3 > 4 > 4 即 0 > 4 则结果为0
//C++11之前
std::cout << (Y<(X<1> )>::c > ::c > ::c) << std::endl;//0
std::cout << (Y<X< （1>>::c) > ::c > ::c) << std::endl;//0
// Y<X<0> ::c > ::c
// Y<(X<0>::c)::c 故为3
```

总之这样太扯淡了，还是小心微妙，以最新C++标准为准。

## friend声明模板形参

在C++11标准中，将一个类声明为另一个类的友元，可以忽略前者的class关键字，这里忽略前面class关键字还有一个大前提，必须
提前声明该类，例如：

```cpp
#include <iostream>
using namespace std;

class C;

class X1
{
    friend class C; // C++11前后都能编译成功
};

class X2
{
    friend C; // C++11及其之后才能编译成功
};

int main(int argc, char **argv)
{
    return 0;
}
```

这里重中之重 `友元声明可以户端class关键字`。这一特性使得friend可以多做很多事情，比如声明基本类型、用friend声明别名、用friend声明模板参数：

```cpp
#include <iostream>
using namespace std;

class C;
typedef C Ct;

class X1
{
    friend C;
    friend Ct;
    friend void;
    friend int;
};

template <typename T>
class R
{
    friend T;
};

int main(int argc, char **argv)
{
    R<C> rc;
    R<Ct> rct;
    R<int> ri;
    R<void> rv;
    return 0;
}
```

虽然上面代码可以编译通过，但是对基本类型，如上面的friend void 和 friend int,编译器会忽略它们。R也同理，例如类`R<int>`没有友元。

还有个比较骚的操作

```cpp
#include <iostream>
using namespace std;

class InnerVisitor
{
};

template <typename T>
class SomeDatabase
{
    friend T;
    // 内部数据...
public:
    // 外部接口...
};

using DiagDatabase = SomeDatabase<InnerVisitor>;

using StandardDatabase = SomeDatabase<void>;

int main(int argc, char **argv)
{
    DiagDatabase d1;
    // d1是可以被InnerVistor访问内部数据的
    StandardDatabase d2;
    // d2则没有友元关系
    return 0;
}
```
