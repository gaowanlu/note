# C++ 20 常用新特性

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

10、其他细节改进：C++20 还引入了一些其他的细节改进，如三向比较操作符、格式化字符串函数 std::format()、std::span 容器、标准库中对文件系统的支持等。

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
