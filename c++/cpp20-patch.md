# 🍌 C++20 特性

C++20 引入了许多新特性和语言改进，下面是其中一些主要的特性：

1、概念（Concepts）：C++20 引入了概念的概念，允许程序员在编写模板代码时指定参数必须满足的类型约束。

2、模块（Modules）：C++20 引入了模块，允许程序员将代码分割为逻辑单元，减少了头文件包含带来的编译时间和二进制文件大小。

3、协程（Coroutines）：C++20 引入了协程，使得异步编程变得更加简单和高效。

4、初始化列表构造函数模板（Template for Initialization List Constructors）：C++20 允许使用模板定义初始化列表构造函数，从而支持更多的初始化方式。

5、constexpr 函数的参数和返回值类型不再有限制（Relaxing Constraints on constexpr Functions）：C++20 允许 constexpr 函数的参数和返回值类型可以是任意的，而不再有限制。

6、空指针常量表达式（Constexpr Null Pointer）：C++20 引入了一个新的空指针常量表达式 std::nullptr_t，允许在编译时进行更安全的空指针检查。

7、编译时字符串操作（Compile-Time String Operations）：C++20 引入了编译时字符串操作，可以在编译时进行字符串的拼接、截取和转换等操作。

8、多线程库改进（Improvements to the Thread Library）：C++20 改进了多线程库，引入了一些新的特性，如同步队列、锁升级、线程局部存储等。

9、元编程改进（Improvements to Metaprogramming）：C++20 引入了一些元编程改进，如 consteval 函数、requires 表达式、typename 在模板参数列表中的位置更加灵活等。

10、三路比较操作符

11、异常规范

12、初始化上下文优化

13、类型特性修改和增强

14、std::ranges库

15、捕获初始化

16、线程本地存储

17、统一的构造和析构

18、数学分隔符

19、同步队列

20、其他细节改进：C++20 还引入了一些其他的细节改进，如三向比较操作符、格式化字符串函数 std::format()、std::span 容器、标准库中对文件系统的支持等。

## 三向比较

### 太空飞船 spaceship 运算符

C++20标准新引入了一名为“太空飞船”(spaceship)的运算符`<=>`。它是一个三向比较运算符。`<=>`并不是C++20首创的，实际上Perl、PHP、Ruby等语言早已支持了三向比较运算符，C++是后来的学习者。

```cpp
// lhs <=> rhs
// 可能产生三种结果 该结果可以和0比较
// 小于0 lhs < rhs
// 等于0 lhs == rhs
// 大于0 lhs > rhs
#include <iostream>
using namespace std;

int main()
{
    bool b = 7 <=> 11 < 0;
    std::cout << b << std::endl; // 1
    return 0;
}
```

运算符`<=>`的返回值只能与0和自身类型来比较，如果同其他数值比较，编译器会报错。

```cpp
bool b = 7 <=> 11 < 100; // 编译失败,<=>的结果不能与0之外的数值比较
```

### 三向比较的返回类型

可以看出`<=>`的返回结果并不是一个普通类型，根据标准三向比较会返回3种类型，而这3种类型又会分为有3～4种最终结果。

```cpp
std::strong_ordering
std::weak_ordering
std::partial_ordering
```

### std::strong_ordering

```cpp
// 表达式 lsh <=> rhs
std::strong_ordering
    - std::strong_ordering::less    对应 lhs  < rhs
    - std::strong_ordering::equal   对应 lhs == rhs
    - std::strong_ordering::greater 对应 lhs  > rhs
```

`std::strong_ordering` 类型的结果强调的是strong的含义，表达的是一种可替换性，简单来说，若`lhs == rhs`，那么在任何情况下rhs和lhs都可以相互替换，也就是`fx(lhs) == fx(rhs)`。

对于基本类型中的int类型，三向比较返回的是`std::strong_ordering`，例如：

```cpp
#include <iostream>

using namespace std;

int main()
{
    std::cout << typeid(decltype(7 <=> 11)).name();
    // St15strong_ordering
    return 0;
}
```

对于有复杂结构的类型，`std::strong_ordering` 要求其数据成员和基类的三向比较结果都为`std::strong_ordering`。例如：

默认情况下自定义类型是不存在三向比较运算符函数的，需要用户显式默认声明。

```cpp
#include <iostream>
#include <compare>

using namespace std;

class B
{
public:
    int a;
    long b;
    auto operator <=> (const B&) const = default;
};

class D : public B
{
public:
    short c;
    auto operator <=> (const D&) const = default;
};

int main()
{
    D x1, x2;
    std::cout << typeid(decltype(x1 <=> x2)).name() << std::endl;
    // St15strong_ordering
    return 0;
}
```

对结构体B而言，由于int和long的比较结果都是`std::strong_ordering`，因此结构体B的三向比较结果也是`std::strong_ordering`。  
对结构体D，其 基类 和 成员 的比较结果是`std::strong_ordering`，D的三向比较结果同样是`std::strong_ordering`。

### std::weak_ordering

```cpp
lhs <=> rhs
    - std::weak_ ordering::less      对应 lhs < rhs
    - std::weak_ordering::equivalent 对应 lhs == rhs
    - std::weak_ ordering::greater   对应 lhs > rhs
```

weak表达的是不可替换性。即若有`lhs == rhs`，则rhs和lhs不可以相互替换，也就是`fx(lhs) != fx(rhs)`。这种情况在基础类型中并没有，但是它常常发生在用户自定义类中，比如一个大小写不敏感的字符串类：

```cpp
#include <iostream>
#include <compare>
#include <string>

using namespace std;

int ci_compare(const char* s1, const char* s2)
{
    while(tolower(*s1) == tolower(*s2++))
    {
        if(*s1++ == '\0')
        {
            return 0;
        }
    }
    return tolower(*s1) - tolower(*--s2);
}

class CIString
{
public:
    CIString(const char*s) : str_(s){}
    std::weak_ordering operator<=>(const CIString& b) const
    {
        return ci_compare(str_.c_str(), b.str_.c_str()) <=> 0;
    }
private:
    std::string str_;
};

int main()
{
    CIString s1{"HELLO"}, s2{"hello"};
    std::cout << (s1 <=> s2 == 0) << std::endl;
    // 1
    return 0;
}
```

以上代码实现了一个简单的大小写不敏感的字符串类，它对于s1和s2的比较结果是`std::weak_ordering::equivalent`，表示两个操作数是等价的。但是它们不是相等的也不能相互替换。当`std::weak_ordering`和`std::strong_ordering`同时出现在基类和数据成员的类型中时，该类型的三向比较结果是`std::weak_ordering`，例如：

```cpp
struct D : B 
{
  CIString c{""};
  auto operator <=> (const D&) const = default;
};

D w1, w2;
std::cout << typeid(decltype(w1 <=> w2)).name();
```

用MSVC编译运行上面这段代码会输出`class std::weak_ordering`，因为D中的数据成员CIString的三向比较结果为`std::weak_ordering`。请注意，如果显式声明默认三向比较运算符函数为`std::strong_ordering operator <=> (const D&) const = default;`那么一定会遭遇到一个编译错误。

### std::partial_ordering

```cpp
std::partial_ordering
    - std::partial_ordering::less
    - std::partial_ordering::equivalent
    - std::partial_ ordering::greater
    - std::partial_ordering::unordered
```

`std::partial_ordering`约束力比`std::weak_ordering`更弱，它可以接受当`lhs == rhs`时rhs和lhs不能相互替换。
同时它还能给出第四个结果`std::partial_ordering::unordered`，表示进行比较的两个操作数没有关系。比如基础类型中的浮点数：

```cpp
#include <iostream>
using namespace std;

int main()
{
    std::cout << typeid(decltype(7.7 <=> 11.1)).name();
    // St16partial_ordering
    return 0;
}
```

会输出`class std::partial_ordering`而不是`std::strong_ordering`，是因为浮点的集合中存在一个特殊的NaN，它和其他浮点数值是没关系的：

```cpp
#include <iostream>
using namespace std;

int main()
{
    std::cout << ((0.0 / 0.0 <=> 1.0) == std::partial_ordering::unordered);
    // 1
    return 0;
}
```

当`std::weak_ordering`和`std::partial_ordering`同时出现在基类和数据成员的类型中时，该类型的三向比较结果是`std::partial_ordering`，例如：

```cpp
struct D : B 
{
  CIString c{""};
  float u;
  auto operator <=> (const D&) const = default;
};

D w1, w2;
std::cout << typeid(decltype(w1 <=> w2)).name();
// class std::partial_ordering
```

再次强调一下，`std::strong_ordering`、`std::weak_ordering`和`std::partial_ordering`只能与0和类型自身比较。深究其原因，是这3个类只实现了参数类型为自身类型和`nullptr_t`的比较运算符函数。

### std::variant

`std::variant`是 C++17 引入的标准库模板（使用前请确保你的编译器支持 C++ 17），它提供了一种类型安全的变体类型，可以存储不同类型的值。 `std::variant`表示一个类型安全的联合体，即可以在一个变量中存储不同类型的值，而且一次只能存储它其中一个可能的类型的值。 `std::variant`的主要优点是提供了类型安全和灵活性。它可以用于处理具有多种可能类型的数据，例如在函数参数中传递不同类型的参数，或者在处理异质集合时存储不同类型的元素。 以下是使用`std::variant`的一些示例代码：

```cpp
#include <iostream>
#include <variant>
using namespace std;

void processVariant(const std::variant<int, double, std::string>& v)
{
    std::visit([](auto &value){
        std::cout << "Value: " << value << std::endl;
    }, v);
}

int main()
{
    std::variant<int, double, std::string> v = 42;
    processVariant(v);
    v = 3.14;
    processVariant(v);
    v = "Hello, world";
    processVariant(v);
    std::cout << typeid(std::get<0>(v)).name() << std::endl;
    // i
    std::cout << typeid(std::get<1>(v)).name() << std::endl;
    // d
    std::cout << typeid(std::get<2>(v)).name() << std::endl;
    // NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
    return 0;
}
/*
Value: 42
Value: 3.14
Value: Hello, world
*/
// https://en.cppreference.com/w/cpp/utility/variant
```

需要注意的是，`std::variant`在存储类型时使用了动态多态性（即运行时多态），这意味着在编译时无法确定存储的具体类型，而是在运行时根据实际赋值来确定。 这也意味着在使用`std::variant`时，需要谨慎处理类型转换和操作，以确保类型安全。

### std::common_comparison_category

在C++20的标准库中有一个模板元函数 `std::common_comparison_category` ，它可以帮助我们在一个类型合集中判断出最终三向比较的结果类型，当类型合集中存在不支持三向比较的类型时，该模板元函数返回void。

```cpp
https://en.cppreference.com/w/cpp/utility/compare/common_comparison_category
```

### 对基础类型的支持

1. 对两个算术类型的操作数进行一般算术转换，然后进行比较。其中整型的比较结果为`std::strong_ordering`，浮点型的比较结果为`std::partial_ordering`。例如`7 <=> 11.1`中，整型7会转换为浮点类型，然后再进行比较，最终结果为`std::partial_ordering`类型。
2. 对于无作用域枚举类型和整型操作数，枚举类型会转换为整型再进行比较，无作用域枚举类型无法与浮点类型比较。

```cpp
enum color {
  red
};

auto r = red <=> 11;   //编译成功
auto r = red <=> 11.1; //编译失败
```

3. 对两个相同枚举类型的操作数比较结果，如果枚举类型不同，则无法编译。
4. 对于其中一个操作数为bool类型的情况，另一个操作数必须也是bool类型，否则无法编译。比较结果为`std::strong_ordering`。
5. 不支持作比较的两个操作数为数组的情况，会导致编译出错，例如：

```cpp
int arr1[5];
int arr2[5];
auto r = arr1 <=> arr2; // 编译失败
```

6. 对于其中一个操作数为指针类型的情况，需要另一个操作数是同样类型的指针，或者是可以转换为相同类型的指针，比如数组到指针的转换、派生类指针到基类指针的转换等，最终比较结果为`std::strong_ordering`。

```cpp
char arr1[5];
char arr2[5];
char* ptr = arr2;
auto r = ptr <=> arr1;
// 上面的代码可以编译成功，若将代码中的arr1改写为int arr1[5]，则无法编译，因为int [5]无法转换为char *。如果将char * ptr = arr2;修改为void * ptr = arr2;，就可以编译成功了。
```

### 自动生成的比较运算符函数

标准库中提供了一个名为`std::rel_ops`的命名空间，在用户自定义类型已经提供了`==`运算符函数和<运算符函数的情况下，帮助用户实现其他4种运算符函数， 包括`!=、>、<=和>=`，例如：

```cpp
#include <string>
#include <utility>
class CIString2 {
public:
  CIString2(const char* s) : str_(s) {}

  bool operator < (const CIString2& b) const {
       return ci_compare(str_.c_str(), b.str_.c_str()) < 0;
  }
private:
  std::string str_;
};

using namespace std::rel_ops;
CIString2 s1{ "hello" }, s2{ "world" };
bool r = s1 >= s2;
```

不过因为C++20标准有了三向比较运算符的关系，所以不推荐上面这种做法了。C++20标准规定，如果用户为自定义类型声明了三向比较运算符，那么编译器会为其自动生成`<、>、<=和>=`这4种运算符函数。对于CIString我们可以直接使用这4种运算符函数:

```cpp
CIString s1{ "hello" }, s2{ "world" };
bool r = s1 >= s2;
```

那么这里就会产生一个疑问，很明显三向比较运算符能表达两个操作数是相等或者等价的含义，为什么标准只允许自动生成4种运算符函数，却不能自动生成`==和=!`这两个运算符函数呢？实际上这里存在一个严重的性能问题。在C++20标准拟定三向比较的早期，是允许通过三向比较自动生成6个比较运算符函数的，而三向比较的结果类型也不是3种而是5种，多出来的两种分别是`std::strong_equality`和`std::weak_equality`。但是在提案文档p1190中提出了一个严重的性能问题。简单来说，假设有一个结构体：

```cpp
struct S {
    std::vector<std::string> names;
    auto operator<=>(const S &) const = default;
};
```

它的三向比较运算符的默认实现这样的：

```cpp
template<typename T>
std::strong_ordering operator<=>(const std::vector<T>& lhs, const std::vector<T> & rhs)
{
    size_t min_size = min(lhs.size(), rhs.size());
    for (size_t i = 0; i != min_size; ++i) {
        if (auto const cmp = std::compare_3way(lhs[i], rhs[i]); cmp != 0) {
            return cmp;
        }
    }
    return lhs.size() <=> rhs.size();
}
```

这个实现对于`<和>`这样的运算符函数没有问题，因为需要比较容器中的每个元素。但是`==`运算符就显得十分低效，对于`==`运算符高效的做法是先比较容器中的元素数量是否相等，如果元素数量不同，则直接返回false：

```cpp
template<typename T>
bool operator==(const std::vector<T>& lhs, const std::vector<T>& rhs)
{
    const size_t size = lhs.size();
    if (size != rhs.size()) {
        return false;
    }

    for (size_t i = 0; i != size; ++i) {
        if (lhs[i] != rhs[i]) {
            return false;
        }
    }
    return true;
}
```

想象一下，如果标准允许用三向比较的算法自动生成`==`运算符函数会发生什么事情， 很多旧代码升级编译环境后会发现运行效率下降了，尤其是在容器中元素数量众多且每个元素数据量庞大的情况下。 很少有程序员会注意到三向比较算法的细节，导致这个性能问题难以排查。基于这种考虑，C++委员会修改了原来的三向比较提案， 规定声明三向比较运算符函数只能够自动生成4种比较运算符函数。由于不需要负责判断是否相等， 因此`std::strong_equality`和`std::weak_equality`也退出了历史舞台。对于`==和!=`两种比较运算符函数， 只需要多声明一个`==`运算符函数，`!=`运算符函数会根据前者自动生成：

```cpp
class CIString {
public:
  CIString(const char* s) : str_(s) {}

  std::weak_ordering operator<=>(const CIString& b) const {
       return ci_compare(str_.c_str(), b.str_.c_str()) <=> 0;
  }

  bool operator == (const CIString& b) const {
       return ci_compare(str_.c_str(), b.str_.c_str()) == 0;
  }
private:

  std::string str_;
};

CIString s1{ "hello" }, s2{ "world" };
bool r1 = s1 >= s2; // 调用operator<=>
bool r2 = s1 == s2; // 调用operator ==
```

### 兼容旧代码

现在C++20标准已经推荐使用`<=>和==`运算符自动生成其他比较运算符函数，而使用`<、==以及std::rel_ops`生成其他比较运算符函数会因为`std::rel_ops`已经不被推荐使用而被编译器警告。则那么对于老代码，我们是否需要去实现一套`<=>和==`运算符函数呢？其实大可不必，C++委员会在裁决这项修改的时候已经考虑到老代码的维护成本，所以做了兼容性处理，即在用户自定义类型中，实现了`<、==`运算符函数的数据成员类型，在该类型的三向比较中将自动生成合适的比较代码。比如：

```cpp
struct Legacy {
  int n;
  bool operator==(const Legacy& rhs) const
  {
       return n == rhs.n;
  }
  bool operator<(const Legacy& rhs) const
  {
       return n < rhs.n;
  }
};

struct TreeWay {
  Legacy m;
  std::strong_ordering operator<=>(const TreeWay &) const = default;
};

TreeWay t1, t2;
bool r = t1 < t2;
```

在上面的代码中，结构体TreeWay的三向比较操作会调用结构体Legacy中的`<和==`运算符来完成，其代码类似于：

```cpp
struct TreeWay {
  Legacy m;
  std::strong_ordering operator<=>(const TreeWay& rhs) const {
       if (m < rhs.m) return std::strong_ordering::less;
       if (m == rhs.m) return std::strong_ordering::equal;
       return std::strong_ordering::greater;
  }
};
```

需要注意的是，这里`operator<=>`必须显式声明返回类型为`std::strong_ordering`，使用auto是无法通过编译的。

### 三向比较总结

C++20新增的三向比较特性，该特性的引入为实现比较运算提供了方便。 我们只需要实现`==和<=>`两个运算符函数，剩下的4个运算符函数就可以交给编译器自动生成了。 虽说`std::rel_ops`在实现了`==和<`两个运算符函数以后也能自动提供剩下的4个运算符函数， 但显然用三向比较更加便捷。另外，三向比较提供的3种结果类型也是`std::rel_ops`无法媲美的。 进一步来说，由于三向比较的出现，`std::rel_ops`在C++20中已经不被推荐使用了。 最后，C++委员会没有忘记兼容性问题，这让三向比较能够通过运算符函数`<和==`来自动生成。

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

## C++20关于constexpr的优化

### 允许constexpr虚函数

在C++20标准前，虚函数是不允许声明为constexpr的。很多时候虚函数是无状态的，这种情况下是有条件作为常量表达式被优化的。

```cpp
#include <iostream>
using namespace std;

struct X
{
    virtual int f() const { return 1; }
};

int main(int argc, char **argv)
{
    X x;
    int i = x.f();
    return 0;
}
```

如果作为常量表达式进行优化，则可以减少函数调用。可惜在C++17标准中不允许我们这么做，直到C++20标准明确允许在常量表达式中使用虚函数，所以上面的代码可以修改为：

```cpp
#include <iostream>
using namespace std;

struct X
{
    constexpr virtual int f() const
    {
        int res = 999;
        return res;
    }
};

int main(int argc, char **argv)
{
    X x;
    constexpr int i = x.f();
    // 此处等价于
    // constexpr int i = 999;
    std::cout << i << std::endl; // 999
    return 0;
}
```

constexpr虚函数在继承重写上并没有其他特殊的要求，constexpr的虚函数可以覆盖重写普通虚函数，普通虚函数也可以覆盖重写constexpr的虚函数。

```cpp
#include <iostream>
using namespace std;

struct X1
{
    virtual int f() const = 0;
};

struct X2 : public X1
{
    constexpr virtual int f() const { return 2; }
};

struct X3 : public X2
{
    constexpr virtual int f() const { return 4; }
};

struct X4 : public X3
{
    virtual int f() const { return 5; }
};

constexpr int (X1::*pf)() const = &X1::f;

constexpr X2 x2;
static_assert(x2.f() == 2);
static_assert((x2.*pf)() == 2);

constexpr X1 const &r2 = x2;
static_assert(r2.f() == 2);
static_assert((r2.*pf)() == 2);

constexpr const X1 *p2 = &x2;
static_assert(p2->f() == 2);
static_assert((p2->*pf)() == 2);

constexpr X3 x3;
static_assert(x3.f() == 4);

constexpr X4 x4;
// static_assert(x4.f() == 5); // 编译错误 X4::f 不是constexpr
constexpr const X1 *p4 = &x4;
// static_assert(p4->f() == 4); // 编译错误 X4::f 不是constexpr

int main(int argc, char **argv)
{
    return 0;
}
```

总之就是constexpr越来越自由了，如果采用新版本的C++，其实不用特意去记忆这些东西，毕竟IDE会智能提示我们的。只需要知道有些场景中使用这些特性可以变得更高效就好了。

### 允许在constexpr函数中出现try-catch

在C++20标准以前try-catch是不能出现在constexpr函数中的，如

```cpp
#include <iostream>
using namespace std;

constexpr int f(int x)
{
    try
    {
        return x + 1;
    }
    catch (...)
    {
        return 0;
    }
}

int main(int argc, char **argv)
{
    constexpr int n = f(1);
    return 0;
}
```

C++17编译上面代码会得到一个友好的警告，C++20标准编译时，允许try-catch存在于
constexpr函数，但是throw语句依旧是被禁止的，也就是catch部分永远不会被执行，没有什么意义。

### 允许在constexpr中进行平凡的默认初始化

从C++20开始，标准允许在constexpr中进行平凡的默认初始化。

```cpp
#include <iostream>
using namespace std;

struct X
{
    bool val;
};

constexpr void f()
{
    X x;
}

int main(int argc, char **argv)
{
    f();
    return 0;
}
```

C++17编译则会报错，提示x没有初始化，需要用户提供一个构造函数，或者C++17这样写

```cpp
struct X
{
    bool value = false;
};
```

虽然C++20标准的编译器是能够编译，但是我们依然应该养成声明对象时随手初始化的习惯，避免让代码出现未定义的行为。 可以看 你可能不知道的C++部分 的 “为什么声明的变量没有被默认初始化”部分。

### 允许在constexpr中更改联合类型的有效成员

C++20之前对constexpr的另一个限制就是禁止更改联合类型的有效成员，如

```cpp
#include <iostream>
using namespace std;

union Foo
{
    int i;
    float f;
};

constexpr int use()
{
    Foo foo{};
    foo.f = 1.2f;
    foo.i = 3; // C++20之前将会编译失败
    return foo.i;
}

int main(int argc, char **argv)
{
    int arr[use()] = {0};
    return 0;
}
```

在GCC和MSVC C++17中上面代码是能够编译通过的。C++20除此之外还允许许多特性，如允许dynamic_cast和typeid出现在
常量表达式中，允许在constexpr函数使用未经评估的内联汇编。

### 使用consteval声明立即函数

constexpr声明函数并不一来常量表达式上下文环境，在非常量表达式环境中，函数可以退化表现为普通函数。但是有时候
我们希望确保函数在编译期就执行计算，无法在编译期确定的直接让编译器报错。
C++20推出了一个新的概念 立即函数，立即函数需要使用consteval说明符来声明。

```cpp
#include <iostream>
using namespace std;

consteval int sqr(int n)
{
    return n * n;
}

constexpr int r = sqr(100);
int x = 100;
int r2 = sqr(x); // 编译错误 调用 consteval 函数 "sqr" 不会生成有效的常数表达式
// 因为x不是const也不是constexpr
// sqr用consteval声明不会退化为普通函数

int main(int argc, char **argv)
{
    return 0;
}
```

如果一个立即函数在另外一个立即函数中被调用，则函数定义时的上下文环境不必是一个常量表达式。怎么理解呢，就是传参问题，下面的n在sqrsqr函数中看，不是常量表达式,但是是没问题的。

```cpp
#include <iostream>
using namespace std;

consteval int sqr(int n)
{
    return n * n;
}

consteval int sqrsqr(int n)
{
    n = 5;//这里没问题
    return sqr(sqr(n));
}

int main(int argc, char **argv)
{
    int arr[sqrsqr(10)]{0};
    std::cout << sizeof(arr) / sizeof(int) << std::endl; // 625
    return 0;
}
```

lambda表达式也可以使用consteval说明符

```cpp
#include <iostream>
using namespace std;

auto sqr = [](int n) consteval
{ return n * n; };
int r = sqr(100);

int main(int argc, char **argv)
{
    std::cout << r << std::endl; // 10000
    auto ptr = sqr;//gcc实测获取立即函数的函数地址是没有问题的
    std::cout << ptr(100) << std::endl;
    return 0;
}
```

### 使用constinit检查常量初始化

C++中有一种典型的错误叫做 “Static Initialization Order Fiasco”,指的是因为静态初始化顺序错误导致的问题，
因为这种错误往往发生在main函数之前，所以比较难以排查。在Effective C++中也有讲到。

```cpp
//a.cpp
static int a = 100;
```

```cpp
//b.cpp
extern int a;
struct X
{
    X(){
        n = a;
    }
    int n{0};
};

static X x;
```

没错就是这样，我们没办法控制哪个对象先构造，如果x在y之前构造，就会引发一个未定义的结果。
为了避免这种问题，我们通常希望使用常量初始化程序去初始化静态变量，不幸的是常量初始化规则很复杂。
C++20引入constinit说明符用，主要用于具有静态存储持续时间的变量声明，它要求变量具有常量初始化程序。

```cpp
#include <iostream>
using namespace std;

constinit int x = 11; // 编译成功，全局变量具有静态存储持续

int main(int argc, char **argv)
{
    constinit static int y = 42; // 编译成功，静态变量具有静态存储持续
    constinit int z = 7;         // 编译失败，局部变量是动态分配的
    return 0;
}
```

其次，constinit要求变量 初始化的程序部分应该是常量初始化程序

```cpp
#include <iostream>
using namespace std;

const char *f()
{
    return "hello";
}

constexpr const char *g() { return "cpp"; }
constinit const char *str1 = f(); // 编译错误 f()不是一个常量初始化程序
constinit const char *str2 = g(); // 编译成功

int main(int argc, char **argv)
{
    return 0;
}
```

constinit还能用于非初始化声明，告知编译器thread_local变量已经被初始化

```cpp
#include <iostream>
using namespace std;

thread_local int x = 100;

extern thread_local constinit int x;

int f()
{
    return x;
}

// constinit强调常量初始化 但是初始化的对象并不要求具有常量属性
constinit int number = 999;

int main(int argc, char **argv)
{
    std::cout << number << std::endl;
    return 0;
}
```

constinit强调常量初始化 但是初始化的对象并不要求具有常量属性。

### 判断常量求值环境

- `std:is_constant_evaluated`

用于检查当前表达式是否是一个常量求值环境 返回bool类型

```cpp
#include <iostream>
#include <cmath>
using namespace std;

int main(int argc, char **argv)
{
    std::cout << std::pow(2.0, 3) << std::endl; // 8
    return 0;
}
```

```cpp
#include <iostream>
#include <cmath>
#include <type_traits>
using namespace std;

constexpr double power(double b, int x)
{
    if (std::is_constant_evaluated() && x >= 0)
    {
        double r = 1.0, p = b;
        unsigned int u = (unsigned int)x;
        while (u != 0)
        {
            if (u & 1)
                r *= p;
            u /= 2;
            p *= p;
        }
        return r;
    }
    else
    {
        return std::pow(b, (double)x);
    }
}

int main(int argc, char **argv)
{
    // 常量环境 编译期间就算好了
    constexpr double kilo = power(10.0, 3);
    int n = 3;
    // 非常量环境 运行时算
    double mucho = power(10.0, n);
    std::cout << kilo << std::endl;  // 1000
    std::cout << mucho << std::endl; // 1000

    int n1 = -1;
    constexpr double q = power(10.0, n1); // 编译错误  ‘int n1’ is not const
    std::cout << q << std::endl;
    // 因为会走std::pow

    return 0;
}
```

有一个概念叫做 明显常量求值

1. 常量表达式，如数组长度、case表达式、非类型模板实参等
2. if constexpr语句中的条件
3. constexpr变量的初始化程序
4. 立即函数的调用
5. 约束概念表达式
6. 可在常量表达式中使用或具有常量初始化的变量初始化程序

```cpp
#include <iostream>
#include <type_traits>
using namespace std;

template <bool>
struct X
{
};

X<std::is_constant_evaluated()> x;
// 非类型模板实参，函数返回true，最终类型为X<true>

int main(int argc, char **argv)
{
    return 0;
}
```

```cpp
#include <iostream>
#include <type_traits>
using namespace std;

constexpr int f()
{
    const int n = std::is_constant_evaluated() ? 13 : 17; // n是13
    int m = std::is_constant_evaluated() ? 13 : 17;       // m可能是13或者17，取决于函数环境
    char arr[n] = {};                                     // char[13]
    return m + sizeof(arr);
}

int main(int argc, char **argv)
{
    int p = f();     // m为13，p为26
    int q = p + f(); // m为17，q为56 因为这里p是非const的 赋值右边不是常量求值环境
    return 0;
}
```

如果当判断是否为明显常量求值时存在多个条件，那么编译器会试探`std::is_constant_evaluated()`两种情况求值，比如：

```cpp
#include <iostream>
#include <type_traits>
using namespace std;

int y = 1000;
const int a = std::is_constant_evaluated() ? y : 1;
const int b = std::is_constant_evaluated() ? 2 : y;

int main(int argc, char **argv)
{
    std::cout << a << std::endl; // 1
    std::cout << b << std::endl; // 2
    return 0;
}
```

- 当对a求值时，编译器试探`std::is_constant_evaluated()==true`的情况，发现y会改变a的值，所以最后选择`std::is_constant_evaluated()==false`
- 当对b求值时，编译器试探`std::is_constant_evaluated()==true`的情况，发现结果恒为2，于是直接在编译时完成初始化

```cpp
#include <iostream>
#include <type_traits>
using namespace std;

int x = 2000;
int y = 1000;
const int a = std::is_constant_evaluated() ? y : 2; // (true,y)不符合 (false,2)符合
const int b = std::is_constant_evaluated() ? 5 : y; // (true,5)符合
const int c = std::is_constant_evaluated() ? 3 : 4; // (true,3)符合
const int d = std::is_constant_evaluated() ? x : y; // (true,x)不符合 (false,y)符合

int main(int argc, char **argv)
{
    std::cout << a << std::endl; // 2
    std::cout << b << std::endl; // 5
    std::cout << c << std::endl; // 3
    std::cout << d << std::endl; // 1000
    return 0;
}
```

### C++20constexpr总结

我只想喊，什么狗屎C++，大傻逼。
