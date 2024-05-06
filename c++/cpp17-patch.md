# 🍎 C++17 特性

C++17 引入了许多新特性和语言改进，下面是其中一些主要的特性：

1、结构化绑定（Structured Binding）：可以通过结构化绑定语法将一个复杂数据类型的成员变量绑定到一个或多个变量上，从而方便地访问这些变量。

2、if with initializer：允许在 if 语句中声明和初始化变量，简化了代码。

3、嵌套命名空间（Nested Namespace）：可以将命名空间嵌套到其他命名空间中，提高了代码的组织性和可读性。

4、表达式语句（Expression Statement）：允许将一个表达式作为语句使用，方便了一些特殊情况的编码。

5、constexpr if 语句：允许在编译时根据条件选择不同的代码路径，提高了代码的性能和可读性。

6、类模板参数推导（Class Template Argument Deduction）：允许编译器从函数调用中推导出类模板参数，简化了代码。

7、折叠表达式（Fold Expression）：可以使用折叠表达式对多个表达式进行折叠求值，简化了代码。

8、元编程（Metaprogramming）：引入了一些新的元编程特性，如变量模板、内联变量和 if constexpr 等。

9、[[nodiscard]]属性：可以使用[[nodiscard]]属性来告诉编译器，某个函数返回的结果不应该被忽略。

10、内联变量（Inline Variable）：可以将变量声明为内联的，从而避免了多个编译单元中定义相同的变量时的重复定义错误。

11、UTF-8 字符串字面量：C++17 支持 UTF-8 字符串字面量，可以更好地处理多语言字符集。

12、std::variant类型

13、std::any类型

14、并行算法库

15、std::filesystem 文件系统库

16、新的字符串字面值后缀 sv, if and s

17、其他细节改进：C++17 还引入了一些其他的细节改进，如 constexpr lambda 表达式、std::invoke()函数、`std::optional<T>`类模板等。

## 文件系统库

C++17 新特性 用起来就是一个字 爽

### std::filesystem::path

```cpp
#include <iostream>
#include <filesystem>
using namespace std;
namespace fs = std::filesystem;

int main()
{
    // 赋值
    fs::path m_path = "sandbox\\a\\b"; // 初始化
    m_path.assign("sandbox\\a");       // 赋值

    // 连接
    m_path.append("c");
    m_path /= "d";          // 自动带分隔符号
    cout << m_path << endl; //"sandbox\\a\\c"
    m_path.concat("\\e");
    m_path += "\\f";        // 不自动带分隔符
    cout << m_path << endl; //"sandbox\\a\\c\\d\\e\\f"

    // 修改器
    m_path.clear(); // 擦除
    m_path.assign("sandbox/a/b");
    fs::path p = m_path.make_preferred(); // 偏好分隔符 //在 Windows 上 \ 是偏好分隔符， foo/bar 将被转换为 foo\bar 。
    cout << p << endl;                    //"sandbox\\a\\b"
    p.assign("dir/dir/m.txt");
    cout << p.remove_filename() << endl; //"dir/dir/"
    cout << p.remove_filename() << endl; //"dir/dir/" 返回值*this
    // 替换单个文件名组分 "a/b/f.mp4"
    cout << fs::path("a/b/c.mp4").replace_filename("f.mp4") << endl;
    // 替换文件扩展名 "/a/b.html"
    cout << fs::path("/a/b.mp4").replace_extension("html") << endl;
    // 交换两个路径
    fs::path a = "p";
    fs::path b = "b";
    a.swap(b);
    cout << a << " " << b << endl; //"b" "p"

    // 格式观察器
    cout << m_path.string() << endl;         // sandbox\a\b
    wcout << m_path.wstring() << endl;       // sandbox\a\b
    cout << m_path.generic_string() << endl; // sandbox/a/b 返回转换到字符串的通用路径名格式

    // 字典序列比较
    fs::path other("sandbox\\a\\b");
    cout << m_path.compare(other) << endl; // 0

    // 生成
    cout << fs::path("/dsc/./../").lexically_normal().string() << endl; //'\'  路径的正规形式
    cout << fs::path("/a/d").lexically_relative("/a/b/c") << endl;      //"..\\..\\d" 路径的相对形式
    cout << fs::path("/a/b/e").lexically_proximate("/a/b/c/c") << endl; //"..\\..\\e" 转换路径到准确形式

    // 分解
    cout << fs::current_path() << endl; // 执行程序路径
    //"C:\\Users\\gaowanlu\\Desktop\\MyProject\\tempcpp\\ConsoleApplication2\\ConsoleApplication2"
    cout << fs::current_path().root_name() << endl;
    //"C:"
    cout << fs::path("/mes/cpp.cpp").root_path() << endl;      //"/" 若存在则返回路径的根路径
    cout << fs::path("/mes/cpp.cpp").root_directory() << endl; //"/"若存在则返回路径的根目录
    cout << fs::path("/mes/cpp.cpp").root_name() << endl;      //"" 若存在则返回路径的根名
    // 返回相对根路径的路径
    cout << fs::path("/mes/cpp.cpp").relative_path() << endl; //"mes/cpp.cpp"
    // 到父目录的路径。
    cout << fs::path("/mes/cpp.cpp").parent_path() << endl; //"/mes"
    cout << fs::path("/mes/.").parent_path() << endl;       //"/mes"
    // 返回文件名
    cout << fs::path("/mes/cpp.cpp").filename() << endl; //"cpp.cpp"
    cout << fs::path("..").filename() << endl;           //..
    cout << fs::path("/mes/..").filename() << endl;      //..
    // 返回文件名，并剥去扩展名
    auto temp = fs::path("/mes/filename.cpp");
    cout << temp.stem() << endl; //"filename"
    // 返回扩展名部分
    cout << temp.extension() << endl;                 //".cpp"
    cout << fs::path("sdc/../.").extension() << endl; //""

    // 查询
    cout << fs::path("  ").empty() << endl;                // 0 检查路径是否为空
    cout << fs::path("").empty() << endl;                  // 1
    cout << fs::path("/a/s").has_extension() << endl;      // 0 检查 root_path() 是否为空。
    cout << fs::path("/a/s").has_root_name() << endl;      // 0
    cout << fs::path("/a/s").has_root_directory() << endl; // 1
    cout << fs::path("/a/s").has_relative_path() << endl;  // 1
    cout << fs::path("/a/s").has_parent_path() << endl;    // 1
    cout << fs::path("/a/s").has_filename() << endl;       // 1
    cout << fs::path("/a/s").has_stem() << endl;           // 1
    cout << fs::path("/a/s").has_extension() << endl;      // 0

    // 检查是否为相对或绝对路径
    cout << fs::path("/as/sda").is_absolute() << endl;    // 0
    cout << fs::path("../ssd/../").is_relative() << endl; // 1

    // 迭代器
    for (auto p = temp.begin(); p != temp.end(); p++)
    {
        cout << *p << endl; //"/" "mes" "filename.cpp"
    }

    // 非成员函数支持
    // swap hash_value
    // 字典序列比较 operator== operator!= operator!= operator< operator<=
    // operator> operator>= operator<=>
    // operator/
    // 用分隔符连接两个路径 operator<<
    // operator>>

    // 支持hash
    size_t code = fs::hash_value(temp);
    cout << code << endl; // 12442686431355853930
    auto code_other = hash<fs::path>{}(temp);
    cout << (code == code_other) << endl; // 1
    return 0;
}
```

## 扩展的inline说明符

### 定义非常量静态成员变量的问题

在C++17标准以前，定义类的非常量静态成员变量是一件让人头痛的事情，因为变量的声明和定义必须分开进行。

```cpp
#include <iostream>
using namespace std;

class X
{
public:
    static std::string text;
};

std::string X::text{"hello"};

int main(int argc, char **argv)
{
    X::text += " world";
    std::cout << X::text << std::endl;
    return 0;
}
```

`static std::string text`是静态成员变量的声明，`std::string X::text{"hello"}`
是静态成员变量的定义和初始化。为了保证代码能够顺利地编译，必须保证
静态成员变量地定义有且只有一份，非常引发错误，比较常见的就是为了方便
将静态成员变量的定义放在头文件中。

```cpp
#ifndef X_H
#define X_H
class X
{
public:
    static std::string text;
};
std::string X::text{"hello"};
#endif
```

因为被include到多个cpp文件中，在链接时会发生重复定义的错误。对于一些字面量类型如 整型、浮点型等，这种情况有所缓解，至少对于它们而言静态成员
变量可以一边声明一边定义的。

```cpp
#include <iostream>
#include <string>
class X
{
public:
    static const int num{5};
};
int main()
{
    std::cout << X::num << std::endl;
    return 0;
}
```

虽然常量可以让它们方便地声明和定义，但却丢失了修改变量地能力，对于std::string这种非字面量类型，这种方法是无能为力的。

### C++17内联定义静态变量

C++17标准中增强了inline说明符的能力，允许内联定义静态变量。

下面代码可以编译和运行，即使将类X的定义作为头文件包含在多个CPP中也不会有任何问题，这种情况下，编译器会在类X的定义首次出现时对内联静态成员进行定义和初始化。

```cpp
#include <iostream>
using namespace std;

class X
{
public:
    inline static std::string text{"hello"};
};

int main(int argc, char **argv)
{
    X::text += " world";
    std::cout << X::text << std::endl;
    return 0;
}
```

### C++17 constexpr内联属性

C++17中，constexpr声明静态成员变量时，被赋予了变量的内联属性，如

```cpp
#include <iostream>
using namespace std;

class X
{
public:
    static constexpr int num{5};
};

// 以上代码在C++17中等同于

class A
{
public:
    inline static constexpr int num{5};
};

int main(int argc, char **argv)
{
    char buffer1[X::num]{0};
    char buffer2[A::num]{0};
    return 0;
}
```

自C++11以来就有,这种用法，那么C++11和C++17中有什么区别。

```cpp
static constexpr int num{5};
```

C++11 ，num是只有声明没有定义的，虽然我们可以通过`std::cout << X::num << std::endl`输出其结果，但这实际上是编译器的一个小把戏，它将`X::num`直接替换为了5。如果将输出语句修改为`std::cout << &X::num << std::endl`，那么链接器会明确报告`X::num`缺少定义。

从C++17开始情况发生了变化，`static constexpr int num{5}`既是声明也是定义，所以在C++17标准中`std::cout << &X::num << std::endl`可以顺利编译链接，并且输出正确的结果。值得注意的是，对于编译器而言为`X::num`产生定义并不是必需的，如果代码只是引用了`X::num`的值，那么编译器完全可以使用直接替换为值的技巧。只有当代码中引用到变量指针的时候，编译器才会为其生成定义。

### C++17 if constexpr

if constexpr 是C++17标准提出的特性。

1. if constexpr的条件必须是编译期就能确定结果的常量表达式
2. 条件结果一旦确定，编译器将只编译符合条件的代码块
3. 和运行时if的另一个不同点：if constexpr不支持短路规则

错误样例

```cpp
#include <iostream>
using namespace std;

void check1(int i)
{
    if constexpr (i > 0) // 编译失败，不是常量表达式
    {
        std::cout << "i>0" << std::endl;
    }
    else
    {
        std::cout << "i<=0" << std::endl;
    }
}

int main(int argc, char **argv)
{
    return 0;
}
```

正确样例

```cpp
#include <iostream>
using namespace std;

void check2()
{
    if constexpr (sizeof(int) > sizeof(char))
    {
        std::cout << "sizeof(int) > sizeof(char)" << std::endl;
    }
    else
    {
        std::cout << "sizeof(int) <= sizeof(char)" << std::endl;
    }
}

int main(int argc, char **argv)
{
    check2();
    return 0;
}
// sizeof(int) > sizeof(char)
```

其中check2函数会被编译器省略为

```cpp
void check2()
{
    std::cout << "sizeof(int) > sizeof(char)" << std::endl;
}
```

if constexpr还可以用于模板

```cpp
#include <iostream>
using namespace std;

template <class T>
bool is_same_value(T a, T b)
{
    return a == b;
}

// 针对浮点特化
template <>
bool is_same_value<double>(double a, double b)
{
    if (std::abs(a - b) < 0.0001)
    {
        return true;
    }
    else
    {
        return false;
    }
}

int main(int argc, char **argv)
{
    double x = 0.1 + 0.1 + 0.1 - 0.3;
    std::cout << is_same_value(5, 5) << std::endl;  // 1
    std::cout << (x == 0.) << std::endl;            // 0
    std::cout << is_same_value(x, 0.) << std::endl; // 1
    return 0;
}
```

上面的例子如果不用模板特化，使用if constexpr即可写到一个模板函数中。

```cpp
#include <iostream>
#include <type_traits>

using namespace std;

template <class T>
auto is_same_value(T a, T b)
{
    if constexpr (std::is_same<T, double>::value)
    {
        if (std::abs(a - b) < 0.0001)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    else
    {
        return a == b;
    }
}

int main(int argc, char **argv)
{
    double x = 0.1 + 0.1 + 0.1 - 0.3;
    std::cout << (x == 0.) << std::endl;            // 0
    std::cout << is_same_value(x, 0.) << std::endl; // 1
    std::cout << is_same_value(1, 1) << std::endl;  // 1
    return 0;
}
```

最重要的一点是if constexpr不支持短路规则。

```cpp
#include <iostream>
#include <string>
#include <type_traits>

using namespace std;

template <class T>
auto any2i(T t)
{
    if constexpr (std::is_same<T, std::string>::value && T::npos == -1)
    {
        return atoi(t.c_str());
    }
    else
    {
        return t;
    }
}

int main(int argc, char **argv)
{
    std::cout << any2i(std::string("6")) << std::endl; // 6
    std::cout << any2i(6) << std::endl;                // 编译错误 因为int::npos是非法的
    // if constexpr 的表达式是先全部确定后再进行计算出结果的 和运行时的if不一样
    return 0;
}
```

可以这样修改一些 用 if constexpr嵌套

```cpp
#include <iostream>
#include <string>
#include <type_traits>

using namespace std;

template <class T>
auto any2i(T t)
{
    if constexpr (std::is_same<T, std::string>::value)
    {
        if constexpr (T::npos == -1)
        {
            return atoi(t.c_str());
        }
    }
    else
    {
        return t;
    }
}

int main(int argc, char **argv)
{
    std::cout << any2i(std::string("6")) << std::endl; // 6
    std::cout << any2i(6) << std::endl;                // 6
    return 0;
}
```

## 确定的表达式求值顺序

### 表达式求值顺序的不确定性

C++作者贾尼·斯特劳斯特卢普的作品《C++程序设计语言（第4版）》中有一段这样的代码：

```cpp
#include <iostream>
#include <cassert>
using namespace std;

void f2()
{
    std::string s = "but I have heard it works even if you don't believe in it";
    s.replace(0, 4, "").replace(s.find("even"), 4, "only").replace(s.find(" don't"), 6, "");
    assert(s == "I have heard it works only if you believe in it"); // OK
}

int main(int argc, char **argv)
{
    f2();
    return 0;
}
```

这段代码本意是描述string的replace用法，但C++17之前隐含着一个很大的问题，根源是表达式求值顺序。
也就是说如C++17之前 `foo(a, b, c)`，这里foo、a、b、c的求值顺序是没有确定的。

从C++17开始，函数表达式一定会在函数的参数之前求值，foo一定会在a、b、c之前求值，但是参数之间的求值顺序依然没有确定。  
对于后缀表达式和移位操作符而言，表达式求值总是从左往右，比如：

```cpp
E1[E2]
E1.E2
E1.*E2
E1->*E2
E1<<E2
E1>>E2
```

对于赋值表达式，顺序是从右往左：

```cpp
E1=E2
E1+=E2
E1-=E2
E1*=E2
E1/=E2
.......
```

对于new表达式，C++17也做了规定。new表达式的内存分配总是优先于T构造函数中参数E的求值。

```cpp
new T(E)
```

涉及重载运算符的表达式的求值顺序应由与之相应的内置运算符的求值顺序确定，而不是函数调用的顺序规则。

## 字面量优化

### 十六进制浮点字面量

C++11开始，标准库引入了`std::hexfloat`、`std::defaultfloat`来修改浮点输入和输出的默认格式化。

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    double float_array[]{5.875, 1000, 0.117};
    for (auto elem : float_array)
    {
        std::cout << std::hexfloat << elem << " = " << std::defaultfloat << elem << std::endl;
    }
    // 0x1.78p+2 = 5.875
    // 0x1.f4p+9 = 1000
    // 0x1.df3b645a1cac1p-4 = 0.117
    return 0;
}
// 0x1.f40000p+9可以表示为： 0x1.f4 * (2^9)。
```

虽然C++11能在输入输出的时候将浮点数格式化为十六进制的能力，但不能在源码中使用，在C++17中得到了支持。

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    double float_array[]{0x1.7p+2, 0x1.f4p+9, 0x1.df3b64p-4};
    for (auto elem : float_array)
    {
        std::cout << std::hexfloat << elem << " = " << std::defaultfloat << elem << std::endl;
    }
    return 0;
}

// 0x1.7p+2 = 5.75
// 0x1.f4p+9 = 1000
// 0x1.df3b64p-4 = 0.117
```

使用十六进制字面量的优势很明显，可以更精准地表示浮点数。例如`IEE-754`标准最小的单精度值很容易写为`0x1.0p-126`。缺点就是可读性较差。

### 二进制整数字面量

在C++14标准中，定义了二进制整数字面量，如十六进制(0x 0X)和八进制`0`都有固定前缀一样，二进制整数也有字面量前缀`0b`和`0B`,
GCC的扩展很早就支持了二进制整数字面量，只不过到C++14才纳入标准。

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    auto x = 0b11001101L + 0xcd1 + 077LL + 42; // long long x
    std::cout << x << std::endl;               // 3591
    return 0;
}
```

### 单引号作为整数分隔符

C++14标准还增加了一个用单引号作为整数分隔符的特性，目的是让比较长的整数阅读起来更加容易。单引号整数分隔符对于十进制、八进制、十六进制、二进制整数都是有效的，比如：

```cpp
#include <iostream>
using namespace std;

constexpr int x = 123'456;
static_assert(x == 0x1e'240);
static_assert(x == 036'11'00);
static_assert(x == 0b11'110'001'001'000'000);

int main(int argc, char **argv)
{
    return 0;
}
```

由于单引号在过去有用于界定字符的功能，因此这种改变可能会引起一些代码的兼容性问题，比如：

```cpp
#include <iostream>

#define M(x, ...) __VA_ARGS__
int x[2] = {M(1'2, 3'4)};

int main()
{
    // C++14以上，x[0] = 34, x[1] = 0
    std::cout << "x[0] = " << x[0] << ", x[1] = " << x[1] << std::endl;
    return 0;
    // C++11为 x[0] = 0, x[1] = 0
    // 因为C++11将“1'2, 3'4”整体作为了一个参数
}
```

### 原生字符串字面量

C++中嵌入一段带格式和特殊符号的字符串是比较麻烦的，如HTML嵌入到源代码中。

原生字符串字面量并不是一个新的概念，比如在Python中已经支持在字符串之前加R来声明原生字符串字面量了。使用原生字符串字面量的代码会在编译的时候被编译器直接使用，也就是说保留了字符串里的格式和特殊字符，同时它也会忽略转移字符，概括起来就是所见即所得。

```cpp
prefix R"delimiter(raw_characters)delimiter"
```

prefix与delimiter是可选部分

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    char hello_world_html[] = R"(<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes">
  <title>Hello World!</title>
</head>
<body>
Hello World!
</body>
</html>
)";
    printf("%s", hello_world_html);
    return 0;
}
```

delimiter可以是由除括号、反斜杠和空格以外的任何源字符构成的字符序列，长度至多为16个字符。通过添加delimiter可以改变编译器对原生字符串字面量范围的判定，从而顺利编译带有`)"`的字符串

```cpp
char hello_world_html[] = R"cpp(<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes">
  <title>Hello World!</title>
</head>
<body>
"(Hello World!)"
< / body >
< / html>
)cpp";
```

C++11标准除了让我们能够定义char类型的原生字符串字面量外，对于`wchar_t`、`char8_t`（C++20标准开始）、`char16_t`和`char32_t`类型的原生字符串字面量也有支持。要支持这4种字符类型，就需要用到另外一个可选元素prefix了。这里的prefix实际上是声明4个类型字符串的前缀L、u、U和u8。

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    char8_t utf8[] = u8R"(你好世界)"; // C++20标准开始
    char16_t utf16[] = uR"(你好世界)";
    char32_t utf32[] = UR"(你好世界)";
    wchar_t wstr[] = LR"(你好世界)";
    return 0;
}
```

原生字符串字面量除了能连接原生字符串字面量以外，还能连接普通字符串字面量。

* 普通字符串字面量：

```cpp
普通字符串字面量是用双引号 " 括起来的字符序列。例如："Hello, World!"。
在普通字符串中，特殊字符（如换行符 \n、制表符 \t 等）需要使用转义序列表示。
例如，要表示一个包含换行符的字符串，可以写成 "Hello\nWorld"。
```

* 原生字符串字面量：

```cpp
原生字符串字面量是用两个R"()"包围的字符序列，中间的括号可以自定义。例如：R"(Hello, World!)"。
原生字符串字面量中的内容会按照字面的形式来进行解释，不对特殊字符进行转义。因此，可以直接包含特殊字符而无需使用转义序列。
例如，要表示一个包含换行符的字符串，可以写成 R"(Hello World)"，其中换行符直接在字符串中表现为换行。
原生字符串字面量通常用于包含大量特殊字符或者需要在字符串中使用大量反斜杠的情况，以提高可读性。
```

### 用户自定义字面量

在C++11标准中新引入了一个用户自定义字面量的概念，程序员可以通过自定义后缀将整数、浮点数、字符和字符串转化为特定的对象。

```cpp
#include <iostream>
using namespace std;

template <int scale, char... Unit_char>
struct LengthUnit
{
    constexpr static int value = scale;
    constexpr static char unit_str[sizeof...(Unit_char) + 1] = {Unit_char..., '\0'};
};

template <class T>
class LengthWithUnit
{
public:
    LengthWithUnit() : length_unit_(0) {}
    LengthWithUnit(unsigned long long length) : length_unit_(length * T::value)
    {
    }

    template <class U>
    LengthWithUnit<std::conditional_t<(T::value > U::value), U, T>>
    operator+(const LengthWithUnit<U> &rhs)
    {
        // 返回单位比较小的
        using unit_type = std::conditional_t<(T::value > U::value), U, T>;
        return LengthWithUnit<unit_type>((length_unit_ + rhs.get_length() / unit_type::value));
    }

    unsigned long long get_length() const { return length_unit_; }
    constexpr static const char *get_unit_str() { return T::unit_str; }

private:
    unsigned long long length_unit_;
};

template <class T>
std::ostream &operator<<(std::ostream &out, const LengthWithUnit<T> &unit)
{
    out << unit.get_length() / T::value << LengthWithUnit<T>::get_unit_str();
    return out;
}

int main(int argc, char **argv)
{
    using MMUnit = LengthUnit<1, 'm', 'm'>;       // 1 mm
    using CMUnit = LengthUnit<10, 'c', 'm'>;      // 1 cm = 10 mm
    using DMUnit = LengthUnit<100, 'd', 'm'>;     // 1 dm = 100 mm
    using MUnit = LengthUnit<1000, 'm'>;          // 1 m = 1000 mm
    using KMUnit = LengthUnit<1000000, 'k', 'm'>; // 1 km = 100 0000 mm

    using LengthWithMMUnit = LengthWithUnit<MMUnit>;
    using LengthWithCMUnit = LengthWithUnit<CMUnit>;
    using LengthWithDMUnit = LengthWithUnit<DMUnit>;
    using LengthWithMUnit = LengthWithUnit<MUnit>;
    using LengthWithKMUnit = LengthWithUnit<KMUnit>;

    auto total_length = LengthWithCMUnit(1) + LengthWithMUnit(2) + LengthWithMMUnit(4); // LengthWithMMUnit total_length
    std::cout << total_length << std::endl;                                             // 2104mm
    return 0;
}
```

这样写LengthWithUnit太麻烦了,可以使用自定义字面量改造

语法

```cpp
retrun_type operator "" identifier (params)
```

样例

```cpp
#include <iostream>
using namespace std;

template <int scale, char... Unit_char>
struct LengthUnit
{
    constexpr static int value = scale;
    constexpr static char unit_str[sizeof...(Unit_char) + 1] = {Unit_char..., '\0'};
};

template <class T>
class LengthWithUnit
{
public:
    LengthWithUnit() : length_unit_(0) {}
    LengthWithUnit(unsigned long long length) : length_unit_(length * T::value)
    {
    }

    template <class U>
    LengthWithUnit<std::conditional_t<(T::value > U::value), U, T>>
    operator+(const LengthWithUnit<U> &rhs)
    {
        // 返回单位比较小的
        using unit_type = std::conditional_t<(T::value > U::value), U, T>;
        return LengthWithUnit<unit_type>((length_unit_ + rhs.get_length() / unit_type::value));
    }

    unsigned long long get_length() const { return length_unit_; }
    constexpr static const char *get_unit_str() { return T::unit_str; }

private:
    unsigned long long length_unit_;
};

template <class T>
std::ostream &operator<<(std::ostream &out, const LengthWithUnit<T> &unit)
{
    out << unit.get_length() / T::value << LengthWithUnit<T>::get_unit_str();
    return out;
}

using MMUnit = LengthUnit<1, 'm', 'm'>;       // 1 mm
using CMUnit = LengthUnit<10, 'c', 'm'>;      // 1 cm = 10 mm
using DMUnit = LengthUnit<100, 'd', 'm'>;     // 1 dm = 100 mm
using MUnit = LengthUnit<1000, 'm'>;          // 1 m = 1000 mm
using KMUnit = LengthUnit<1000000, 'k', 'm'>; // 1 km = 100 0000 mm

using LengthWithMMUnit = LengthWithUnit<MMUnit>;
using LengthWithCMUnit = LengthWithUnit<CMUnit>;
using LengthWithDMUnit = LengthWithUnit<DMUnit>;
using LengthWithMUnit = LengthWithUnit<MUnit>;
using LengthWithKMUnit = LengthWithUnit<KMUnit>;

LengthWithMMUnit operator"" _mm(unsigned long long length)
{
    return LengthWithMMUnit(length);
}

LengthWithCMUnit operator"" _cm(unsigned long long length)
{
    return LengthWithCMUnit(length);
}

LengthWithDMUnit operator"" _dm(unsigned long long length)
{
    return LengthWithDMUnit(length);
}

LengthWithMUnit operator"" _m(unsigned long long length)
{
    return LengthWithMUnit(length);
}

LengthWithKMUnit operator"" _km(unsigned long long length)
{
    return LengthWithKMUnit(length);
}

int main(int argc, char **argv)
{
    auto total_length = 1_cm + 2_m + 4_mm;
    std::cout << total_length; // 2104mm
    return 0;
}
```

不得不说C++确实是狗屎，就是因为扩展性太高太灵活内容太多包袱重，狗屎中的狗屎。

用户自定义字面量支持整数、浮点数、字符和字符串4种类型。虽然它们都通过字面量运算符函数来定义，但是对于不同的类型字面量运算符函数，语法在参数上有略微的区别。

对于整数字面量运算符函数有3种不同的形参类型`unsigned long long`、`const char *`以及形参为空。其中`unsigned long long`和`const char*`比较简单，编译器会将整数字面量转换为对应的无符号`long long`类型或者常量字符串类型，然后将其作为参数传递给运算符函数。而对于无参数的情况则使用了模板参数，形如`operator "" identifier<char…c>()`。

对于浮点数字面量运算符函数也有3种形参类型`long double`、`const char *`以及形参为空。和整数字面量运算符函数相比，除了将`unsigned long long`换成了`long double`，没有其他的区别。

对于字符串字面量运算符函数目前只有一种形参类型列表`const char * str`, `size_t len`。其中str为字符串字面量的具体内容，len是字符串字面量的长度。

```cpp
#include <iostream>
using namespace std;

unsigned long long operator"" _w1(unsigned long long n)
{
    return n;
}

const char *operator"" _w2(const char *str)
{
    return str;
}

unsigned long long operator"" _w3(long double n)
{
    return n;
}

std::string operator"" _w4(const char *str, size_t len)
{
    return str;
}

char operator""_w5(char n)
{
    return n;
}

unsigned long long operator""if(unsigned long long n)
{
    if (n < 100)
    {
        return 0;
    }
    return n;
}

int main(int argc, char **argv)
{
    auto x1 = 123_w1;           // unsigned long long x1
    auto x2_1 = 123_w2;         // const char *x2_1
    auto x2_2 = 12.3_w2;        // const char *x2_2
    auto x3 = 12.3_w3;          // unsigned long long x3
    auto x4 = "hello world"_w4; // std::string x4
    auto x5 = 'a'_w5;           // char x5
    auto x6 = 123if;            // unsigned long long x6
    return 0;
}
```

字面量运算符函数使用模板参数,在这种情况下函数本身没有任何形参，字面量的内容通过可变模板参数列表`<char…>`传到函数，例如：

```cpp
#include <iostream>
using namespace std;

template <char... c>
std::string operator"" _w()
{
    std::string str;
    // (str.push_back(c),...);//C++17折叠表达式
    using unused = int[];
    unused arr{(str.push_back(c), 0)...};
    return str;
}

int main(int argc, char **argv)
{
    auto x = 123_w;              // std::string x
    auto y = 12.3_w;             // std::string y
    std::cout << x << std::endl; // 123
    std::cout << y << std::endl; // 12.3
    return 0;
}
```

## C++17中使用new分配指定对齐字节长度的对象

内存分配器会按照`std::max_align_t`的对齐字节长度分配对象的内存空间。这一点在C++17标准中发生了改变，new运算符也拥有了根据对齐字节长度分配对象的能力。
这个能力是通过让new运算符接受一个`std::align_val_t`类型的参数来获得分配对象需要的对齐字节长度来实现的：

```cpp
void* operator new(std::size_t, std::align_val_t);
void* operator new[](std::size_t, std::align_val_t);
```

编译器会自动从类型对齐字节长度的属性中获取这个参数并且传参，不需要额外的代码介入。例如：

```cpp
#include <iostream>
using namespace std;

union alignas(256) X
{
    char a1;
    int a2;
    double a3;
};

int main(int argc, char **argv)
{
    std::cout << sizeof(X) << std::endl; // 256
    X *x = new X();
    std::cout << reinterpret_cast<std::uintptr_t>(x) % 256 << std::endl; // C++17:0 C++11:可能不是0
    delete x;
    return 0;
}
```

## C++17 std::launder

`std::launder()`是C++17新引入的函数，它想要解决C++的一个核心问题。

```cpp
#include <iostream>
using namespace std;

struct X
{
    const int n;
};

union U
{
    X x;
    float f;
};

int main(int argc, char **argv)
{
    U u = {{1}};
    // u.x.n = 10; // 表达式必须是可修改的左值
    std::cout << u.x.n << std::endl; // 1

    X *p = new (&u.x) X{2};
    std::cout << u.x.n << std::endl; // 2
    std::cout << p->n << std::endl;  // 2
    return 0;
}
```

虽然这里`u.x.n`也变为了2，但是编译器有理由认为`u.x.n`一但被初始化后不能被修改，从标准来看这个结果是未定义的。标准库引入`std::launder()`就是为了解决此问题。它的目的是防止编译器追踪到数据的来源以阻止编译器对数据的优化。

```cpp
int main(int argc, char **argv)
{
    U u = {{1}};
    std::cout << u.x.n << std::endl; // 1

    X *p = new (&u.x) X{2};
    assert(*std::launder(&u.x.n) == 2);
    return 0;
}
```

## 返回值优化

返回值优化设计C++11 ~ C++17。返回值优化是C++中的一种编译优化技术，允许编译器将返回的对象直接构造到它们本要存储的变量空间中，而不产生临时对象。严格来说返回值优化分为RVO（Return Value Optimization）和NRVO（Named Return Value Optimization），不过在优化方法上的区别并不大，一般来说当返回语句的操作数为临时对象时，我们称之为RVO；而当返回语句的操作数为具名对象时，我们称之为NRVO。在C ++ 11标准中，这种优化技术被称为`复制消除`（copy elision）。如果使用GCC作为编译器，则这项优化技术是默认开启的，取消优化需要额外的编译参数`-fno-elide- constructors`。

```cpp
#include <iostream>
using namespace std;

class X
{
public:
    X()
    {
        std::cout << "X()" << std::endl;
    }
    X(const X &x)
    {
        std::cout << "X(const X &x)" << std::endl;
    }
    ~X()
    {
        std::cout << "~X()" << std::endl;
    }
};

X make_x()
{
    X x1;
    return x1;
}

int main(int argc, char **argv)
{
    X x2 = make_x();
    // X()
    // ~X()
    return 0;
}
```

整个过程一次复制构造函数都没有调用，这就是NRVO的效果，即使将make_x改为下面

```cpp
X make_x()
{
 return X();
}
```

也会收到同样的效果，只不过优化技术名称从NRVO变成了RVO。如果在编译命令行中添加`-fno-elide-constructors`,则会输出

```cpp
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -Wall -O0")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -std=c++11 -Wall -O0 -fno-elide-constructors")

// X()
// X(const X &x)
// ~X()
// X(const X &x)
// ~X()
// ~X()
```

但是实测C++20哪怕加了`-fno-elide-constructors`也是仅仅输出

```cpp
// X()
// ~X()
```

实际上返回值优化是很容易失效的，例如

```cpp
#include <iostream>
#include <ctime>
using namespace std;

class X
{
public:
    X()
    {
        std::cout << "X()" << std::endl;
    }
    X(const X &x)
    {
        std::cout << "X(const X &x)" << std::endl;
    }
    ~X()
    {
        std::cout << "~X()" << std::endl;
    }
};

X make_x()
{
    X x1, x2;
    if (std::time(nullptr) % 50 == 0)
    {
        return x1;
    }
    else
    {
        return x2;
    }
}

int main(int argc, char **argv)
{
    X x3 = make_x();
    return 0;
}
```

输出

```cpp
X()
X()
X(const X &x)
~X()
~X()
~X()
```

发生了复制，这是由于x1或者x2复制到x3是无法在编译器决定的。因此编译器无法在默认构造阶段
就对x3进行构造，它需要分别将x1和x2构造后，根据运行时的结果将x1或者x2复制构造到x3。
在这个过程中返回值优化技术也尽其所能将中间的临时对象优化掉了，所以这里只会看到一次复制构造函数的调用。

很明显C++11这样的优化，是需要复制构造函数是能够访问的。到了C++17指定，在传递临时对象或者从函数返回临时对象的情况下，编译器应该省略对象的复制和移动构造函数，即使这些复制和移动构造还有一些额外的作用，最终还是
直接将对象构造到目标的存储变量上，从而避免临时对象的产生，标准还强调，复制和移动构造函数甚至可以是不存在或者不可访问的。对于C++17，所有类型都能使用工厂函数，即使该类型没有复制或者移动构造函数，例如：

```cpp
#include <iostream>
#include <atomic>
using namespace std;

template <class T, class Arg>
T create(Arg &&arg)
{
    return T(std::forward<Arg>(arg));
}

int main(int argc, char **argv)
{
    std::atomic<int> x = create<std::atomic<int>>(11);
    return 0;
}
```

由于`std::atomic`的复制构造函数被显式删除了，同时编译器也不会提供默认的移动构造函数，上面代码在C++17之前无法编译成功。

## 折叠表达式

C++17引入了折叠表达式的新特性，例如用折叠表达式方式写模板递归

```cpp
#include <iostream>
using namespace std;

template <class... Args>
auto sum(Args... args)
{
    return (args + ...);
}

// template <>
// double sum<int, double, double>(int __args0, double __args1, double __args2)
// {
//     return static_cast<double>(__args0) + (__args1 + __args2);
// }

int main(int argc, char **argv)
{
    std::cout << sum(1, 5.0, 11.) << std::endl; // 17
    return 0;
}
```

### 四种折叠方式

在上面的例子，我们不再需要编写多个sum函数，然后通过递归的方式求和。C++17标准中有4种折叠规则，分别是一元向左折叠、一元向右折叠、二元向左折叠、二元向右折叠。

上面的例子是一个典型的一元向右折叠

```cpp
(args op ...)折叠为(arg0 op (arg1 op .. (argN-1 op argN)))
```

一元向左折叠

```cpp
(... op args)折叠为((((arg0 op arg1) op arg2) op ...) op argN)
```

二元向右折叠，二元折叠与一元唯一区别是多了一个初始值

```cpp
(args op ... op init)折叠为(arg0 op (arg1 op ...(argN-1 op (argN op init))))
```

二元向左折叠

```cpp
(init op ... op args)折叠为(((((init op arg0) op arg1) op arg2) op ..) op argN)
```

```cpp
#include <iostream>
using namespace std;

// 一元向右折叠
template <class... Args>
auto sum1(Args... args)
{
    return (args + ...);
}

// template <>
// double sum1<int, double, double>(int __args0, double __args1, double __args2)
// {
//     return static_cast<double>(__args0) + (__args1 + __args2);
// }

// 一元向左折叠
template <class... Args>
auto sum2(Args... args)
{
    return (... + args);
}

// template <>
// double sum2<int, double, double>(int __args0, double __args1, double __args2)
// {
//     return (static_cast<double>(__args0) + __args1) + __args2;
// }

// 二元向右折叠
template <class... Args>
auto sum3(Args... args)
{
    return (1 + ... + args);
}

// template <>
// double sum3<int, double, double>(int __args0, double __args1, double __args2)
// {
//     return ((static_cast<double>(1 + __args0)) + __args1) + __args2;
// }

// 二元向左折叠
template <class... Args>
auto sum4(Args... args)
{
    return (args + ... + 1);
}

// template <>
// double sum4<int, double, double>(int __args0, double __args1, double __args2)
// {
//     return static_cast<double>(__args0) + (__args1 + (__args2 + 1));
// }

int main(int argc, char **argv)
{
    std::cout << sum1(1, 5.0, 11.) << std::endl; // 17
    std::cout << sum2(1, 5.0, 11.) << std::endl; // 17

    std::cout << sum3(1, 5.0, 11.) << std::endl; // 18
    std::cout << sum4(1, 5.0, 11.) << std::endl; // 18
    return 0;
}
```

还有可以用在`std::cout`,毕竟`<<`是操作符，符合折叠表达式规则。

```cpp
#include <iostream>
#include <string>
using namespace std;

template <class... Args>
void print(Args... args)
{
    (std::cout << ... << args) << std::endl;
}

// template <>
// void print<std::basic_string<char, std::char_traits<char>, std::allocator<char>>, const char *, const char *>(std::basic_string<char, std::char_traits<char>, std::allocator<char>> __args0, const char *__args1, const char *__args2)
// {
//     std::operator<<(std::operator<<(std::operator<<(std::cout, __args0), __args1), __args2).operator<<(std::endl);
// }

int main(int argc, char **argv)
{
    print(std::string("hello "), "c++ ", "world");
    // hello c++ world
    return 0;
}
```

### 一元折叠表达式种空参数包的特殊处理

一元折叠表达式对空参数包展开有一些特殊规则，就是编译器无法确定折叠表达式最终的求值类型

```cpp
template <typename... Args>
auto sum(Args... args)
{
    return (args + ...);
}
```

如果Args为空则auto无法确定值类型了，二元折叠表达式不会，因为可以指定一个初始值。

```cpp
template <typename... Args>
auto sum(Args... args)
{
    return (args + ... + 0);
}
```

为了解决一元折叠表达式种参数包为空的问题，以下规则必须遵守

1. 只有`&&`、`||`和`,`运算符能够在空参数包的一元折叠表达式中使用。
2. `&&`的求值结果一定为true
3. `||`的求值结果一定为false
4. `,`的求值结果为`void()`
5. 其他运算符都是非法的

```cpp
#include <iostream>
using namespace std;

template <typename... Args>
auto andop(Args... args)
{
    return (args && ...);
}

int main(int argc, char **argv)
{
    std::cout << std::boolalpha << andop(); // true
    return 0;
}
```

### using声明中的包展开

从C++17标准开始，包展开允许出现在using声明的列表中，这对于可变参数类模板派生于形参包的情况很有用。下面是使用using进行继承构造函数

```cpp
#include <iostream>
#include <string>
using namespace std;

template <class T>
class Base
{
public:
    Base() {}
    Base(T t) : t_(t) {}

private:
    T t_;
};

template <class... Args>
class Derived : public Base<Args>...
{
public:
    using Base<Args>::Base...;
};

// template <>
// class Derived<int, std::basic_string<char, std::char_traits<char>, std::allocator<char>>, bool> : public Base<int>, public Base<std::basic_string<char, std::char_traits<char>, std::allocator<char>>>, public Base<bool>
// {

// public:
//     inline Derived(int t) noexcept(false)
//         : Base<int>(t), Base<std::basic_string<char, std::char_traits<char>, std::allocator<char>>>(), Base<bool>()
//     {
//     }

//     // inline constexpr ~Derived() noexcept = default;
//     inline Derived(std::basic_string<char, std::char_traits<char>, std::allocator<char>> t) noexcept(false)
//         : Base<int>(), Base<std::basic_string<char, std::char_traits<char>, std::allocator<char>>>(t), Base<bool>()
//     {
//     }

//     inline Derived(bool t) noexcept(false)
//         : Base<int>(), Base<std::basic_string<char, std::char_traits<char>, std::allocator<char>>>(), Base<bool>(t)
//     {
//     }
// };

int main(int argc, char **argv)
{
    Derived<int, std::string, bool> d1 = 11;
    Derived<int, std::string, bool> d2 = std::string("hello");
    Derived<int, std::string, bool> d3 = true;
    return 0;
}
```

## typename优化

几乎用不到

### 允许使用typename声明模板形参

在C++17标准之前，必须使用class来声明模板形参，而typename是不允许使用的，如

```cpp
// GCC C++11是没有问题的，支持typename
#include <iostream>
using namespace std;

// C++11 别名模板
template <typename T>
using A = int;

template <template <typename> typename T>
struct B
{
};

int main(int argc, char **argv)
{
    [[maybe_unused]] B<A> ba{};
    return 0;
}
```

## 模板参数优化

相对于以类型为模板参数的模板以非类型为模板参数的模板实例化规则更严格。C++17之前主要包括以下几种规则：

* 如果是整型作为模板实参，则必须是模板参数类型的经转换常量表达式。

```cpp
#include <iostream>
using namespace std;

constexpr char v = 42;
constexpr char foo()
{
    return 42;
}

template <int>
struct X
{
};

int main(int argc, char **argv)
{
    X<v> x1;
    X<foo()> x2;
    return 0;
}
// constexpr char到int的转换满足隐式转换和常量表达式
```

* 如果对象指针作为模板实参，则必须是静态或者有内部或者外部链接的完整对象
* 如果函数指针作为模板实参，则必须是有链接的函数指针
* 如果左值引用的形参作为模板实参，则必须也有内部或外部链接
* 对于成员指针作为模板实参，必须是静态成员

后面的四条规则都强调了两种特性:链接和静态

```cpp
#include <iostream>
using namespace std;

template <const char *>
struct Y
{
};

extern const char str1[] = "hello world"; // 外部链接
const char str2[] = "hello world";        // 内部链接

int main(int argc, char **argv)
{
    Y<str1> y1;
    Y<str2> y2;
    return 0;
}
```

C++17之前返回指针的常量表达式的返回值作为模板实参是不能编译通过的

```cpp
#include <iostream>
using namespace std;

int v = 42;
constexpr int *foo() { return &v; }
template <const int *>
struct X
{
};

int main(int argc, char **argv)
{
    X<foo()> x; // C++11 类型 "const int *" 的非类型模板参数无效
    // C++17可以编译通过
    return 0;
}
```

C++17强调了一条规则，非类型模板形参使用的实参可以是该模板形参类型的任何经转换常量表达式，其中经转换常量表达式的定义添加了对象、数组、函数等到指针的转换。上面代码C++17可以，因为新规则不再强调经转换常量表达式的求值结果为整型。也不再要求指针是具有链接的，取而代之的是必须满足经转换常量表达式求值。

```cpp
// C++17可以编译通过
#include <iostream>
using namespace std;

template <const char *>
struct Y
{
};

int main(int argc, char **argv)
{
    static const char str[] = "hello world";
    Y<str> y; // C++11 模板参数不能封引用非外部实体
    // C++11 error: ‘& str’ is not a valid template argument of type ‘const char*’ because ‘str’ has no linkage
    return 0;
}
```

以下对象作为非类型模板实参依旧会造成编译错误，但也是不一定的不同编译器之间有很大的不同

1. 对象的非静态成员对象
2. 临时对象
3. 字符串字面量
4. typeid的结果
5. 预定义变量

```cpp
// 非静态成员对象不是常量表达式
#include <iostream>
using namespace std;

struct X
{
    int x;
};

template <int>
struct Y
{
};

int main(int argc, char **argv)
{
    X obj;
    Y<obj.x> y; // err 毕竟obj.x是运行时才确定的 模板实参需要编译时就能确定
    return 0;
}
```

### 扩展的模板参数匹配规则

一直以来，模板形参只能精确匹配实参列表，实参列表里的每一项必须和模板形参有着相同的类型。

```cpp
#include <iostream>
using namespace std;

template <template <typename> class T, class U>
void foo()
{
    T<U> n;
}
template <class, class = int>
struct bar
{
};

int main(int argc, char **argv)
{
    foo<bar, double>(); // compile: C++11 failed C++17 succ
    return 0;
}
```

C++11写成下面也会报错

```cpp
#include <iostream>
using namespace std;

template <template <typename, typename> class T, class U>
void foo()
{
    // T<U> n; // 不注释掉就会报错
 // error: wrong number of template arguments (1, should be 2)
}
template <class, class = int>
struct bar
{
};

int main(int argc, char **argv)
{
    foo<bar, double>();
    return 0;
}
```

### 非类型模板形参使用auto作为占位符

C++17可以在非类型模板形参使用auto作为占位符,下面代码中的全部auto都被推导为了int

```cpp
#include <iostream>
using namespace std;

template <template <auto> class T, auto N>
void foo()
{
    T<N> n;
}

template <auto>
struct bar
{
};

int main(int argc, char **argv)
{
    foo<bar, 5>();
    return 0;
}
```

## 类模板的模板实参推导

### 通过初始化构造推导类模板的模板实参

C++17之前，实例化类模板必须显式指定模板实参

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    std::tuple<int, double, const char *> v{5, 11.7, "hello world"};
    return 0;
}
```

上面太麻烦所以出现了`std::make_pair`和`std::make_tuple`这样的函数

```cpp
auto v = std::make_tuple(5, 11.7, "hello world");
```

C++17支持了类模板的模板实参推导，上面的代码可以进一步简化

```cpp
std::tuple v{5, 11.7, "hello world"};
// std::tuple<int, double, const char *> v
```

实参推导对非类型形参的类模板同样适用

```cpp
#include <iostream>
using namespace std;

template <class T, std::size_t N>
struct MyCountOf
{
    MyCountOf(T (&)[N]) {}
    std::size_t value{N};
};

int main(int argc, char **argv)
{
    MyCountOf c("hello");              // struct MyCountOf<const char, 6UL>
    std::cout << c.value << std::endl; // 6
    return 0;
}
```

对非类型模板形参为auto占位符的情况也是支持推导的

```cpp
#include <iostream>
using namespace std;

template <class T, auto N>
struct X
{
    X(T (&)[N]) {}
};

int main(int argc, char **argv)
{
    X x("hello");
    return 0;
}
```

与函数模板不同，类模板实参是不允许部分推导的

```cpp
#include <iostream>
using namespace std;

template <class T1, class T2>
void foo(T1, T2)
{
}

template <class T1, class T2>
struct A
{
    A(T1, T2) {}
};

int main(int argc, char **argv)
{
    foo<int>(5, 6.8);          // 函数模板允许部分推导 void foo<int, double>(int, double)
    A<> a1(2, 3.3);            // 编译错误
    A<int> a2(5, 6.8);         // 编译错误
    A<int, double> a3(5, 6.8); // OK
    A a4(5, 6.8);              // OK
    return 0;
}
```

### 拷贝初始化优先

在类模板参数实参推导时，拷贝初始化优先

```cpp
#include <iostream>
#include <vector>
#include <tuple>
using namespace std;

int main(int argc, char **argv)
{
    std::vector v1{1, 2, 3};
    // std::vector<int, std::allocator<int>> v1
    std::vector v2{v1};
    // std::vector<int, std::allocator<int>> v2

    std::tuple t1{5, 6.8, "hello"};
    // std::tuple<int, double, const char *> t1
    std::tuple t2{t1};
    // std::tuple<int, double, const char *> t2

    // 也就是拷贝初始化优先而不是套了一层

    std::vector v3{v1};
    // std::vector<int, std::allocator<int>> v3
    std::vector v4 = {v1};
    // std::vector<int, std::allocator<int>> v4
    auto v5 = std::vector{v1};
    // std::vector<int, std::allocator<int>> v5
    return 0;
}
```

使用列表初始化的时候，仅当初始化列表只有一个与目标类模板相同的元素才会触发拷贝初始化，其他情况会创建新的类型。

```cpp
#include <iostream>
#include <vector>
#include <tuple>
using namespace std;

int main(int argc, char **argv)
{
    std::vector v1{1, 2, 3};
    std::vector v3{v1, v1};
    // std::vector<std::vector<int, std::allocator<int>>, std::allocator<std::vector<int, std::allocator<int>>>> v3

    std::tuple t1{5, 6.8, "hello"};
    std::tuple t3{t1, t1};
    // std::tuple<std::tuple<int, double, const char *>, std::tuple<int, double, const char *>> t3
    return 0;
}
```

### lambda类型的用途

要将一个lambda表达式作为数据成员存储在某个对象中，如何编写这类的代码

```cpp
#include <iostream>
using namespace std;

template <class T>
struct LambdaWarp
{
    LambdaWarp(T t) : func(t) {}
    template <class... Args>
    void operator()(Args &&...arg)
    {
        func(std::forward<Args>(arg)...);
    }
    T func;
};

int main(int argc, char **argv)
{
    auto l = [](int a, int b)
    {
        std::cout << a + b << std::endl;
    };
    LambdaWarp<decltype(l)> x(l);
    x(11, 7); // 18
    return 0;
}
```

C++17支持了类模板的模板实参推导后，可以进行一些代码优化

```cpp
#include <iostream>
using namespace std;

template <class T>
struct LambdaWarp
{
    LambdaWarp(T t) : func(t) {}
    template <class... Args>
    void operator()(Args &&...arg)
    {
        func(std::forward<Args>(arg)...);
    }
    T func;
};

int main(int argc, char **argv)
{
    LambdaWarp x([](int a, int b)
                 { std::cout << a + b << std::endl; });
    x(11, 7); // 18
    return 0;
}
```

## 用户自定义推导指引

### 使用自定义推导指引推导模板实例

以一个我们想自己写一个pair为例子

```cpp
#include <iostream>
using namespace std;

template <typename T1, typename T2>
struct MyPair
{
    MyPair(const T1 &x, const T2 &y) : first(x), second(y)
    {
    }
    T1 first;
    T2 second;
};

int main(int argc, char **argv)
{
    MyPair p(5, 11.7); // struct MyPair<int, double>
    // MyPair p1(5, "hello"); // MyPair<int, char [6]> p1
    return 0;
}
```

有点出乎意料`hello`并没有被当做`const char*`处理而是被当作`char[6]`处理了。
因为MyPair的构函数参数都是引用类型，所以无法触发数组类型的衰退为指针。

可以用下面的自定义makePair,现进行值传递进行退化为指针

```cpp
#include <iostream>
using namespace std;

template <typename T1, typename T2>
struct MyPair
{
    MyPair(const T1 &x, const T2 &y) : first(x), second(y)
    {
    }
    T1 first;
    T2 second;
};

template <typename T1, typename T2>
inline MyPair<T1, T2>
makePair(T1 x, T2 y)
{
    return MyPair<T1, T2>(x, y);
}

int main(int argc, char **argv)
{
    makePair(1, "hello");
    // inline MyPair<int, const char *> makePair<int, const char *>(int x, const char *y)
    return 0;
}
```

但是支持了用户自定义推导指引，可以这样写

```cpp
#include <iostream>
using namespace std;

template <typename T1, typename T2>
struct MyPair
{
    MyPair(const T1 &x, const T2 &y) : first(x), second(y)
    {
    }
    T1 first;
    T2 second;
};

// 按值处理
template <typename _T1, typename _T2>
MyPair(_T1, _T2) -> MyPair<_T1, _T2>;

int main(int argc, char **argv)
{
    MyPair p(1, "hello");
    // MyPair<int, const char *> p
    return 0;
}
```

用户自定义推导指引的目的是告诉编译器如何进行推导。自定义推导指引可以以更灵活方式使用

```cpp
#include <iostream>
#include <vector>
using namespace std;

namespace std
{
    template <class... T>
    vector(T &&...t) -> vector<std::common_type_t<T...>>;
}

int main(int argc, char **argv)
{
    std::vector v{1, 5u, 3.0}; // std::vector<double, std::allocator<double>> v
    std::common_type_t<int, unsigned, double>;
    // using std::common_type_t<int, unsigned int, double> = double
    return 0;
}
```

自定义推导指引的对象不一定是模板，例如下面的有点特化的模样

```cpp
MyPair<int, const char*)->MyPair<long long, std::string>;
MyPair p2(5, "hello");
```

自定义推导指引支持explicit说明符，作用和其他使用场景类似，都要求对象显式构造

```cpp
explicit MyPair(int, const char*)->MyPair<long long, std::string>;
MyPair p1(5, "hello");
MyPair p2{5, "hello"};
MyPair p3 = {5, "hello"}; // 错误，因为是explicit的
```

用户自定义推导指引声明的前半部分就如同一个构造函数声明，这就引发了一个新的问题，当类模板的构造函数和用户自定义推导指引同时满足实例化要求的时候编译器是如何选择的？

```cpp
#include <iostream>
using namespace std;

template <typename T1, typename T2>
struct MyPair
{
    MyPair(T1 x, T2 y) : first(x), second(y) {}
    T1 first;
    T2 second;
};

MyPair(int, const char *) -> MyPair<long long, std::string>;

int main(int argc, char **argv)
{
    MyPair p1(5u, "hello"); // MyPair<unsigned int, const char *> p1
    MyPair p2(5, "hello");  // MyPair<long long, std::string> p2
    return 0;
}
```

p1第一个参数不满足int,所以不会采用`MyPair(int, const char *) -> MyPair<long long, std::string>;`

### 聚合类型类模板的推导指引

C++20之前聚合类型的类模板是无法进行模板实参推导的，可以使用推导指引解决，如果有C++20环境不加
推导指引也没问题。

```cpp
#include <iostream>
using namespace std;

template <class T>
struct Wrap
{
    T data;
};

template <class T>
Wrap(T) -> Wrap<T>;

int main(int argc, char **argv)
{
    Wrap w1{7};
    Wrap w2 = {7};
    return 0;
}
```
