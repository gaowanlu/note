---
cover: >-
  https://images.unsplash.com/photo-1652361561624-09537e993eb4?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI1MzAzMzQ&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 😜 第 2 章 变量和基本类型

## 第 2 章 变量和基础类型

### 基本内置类型

### 算术类型

```
标识符      含义        大小
bool        布尔类型    未定义大小
char        字符        8位
wchar_t     宽字符      16位
char16_t    Unicode字符 16位
char32_t    Unicode字符 32位
char8_t     字符        8位 （C++20）
short       短整形      16位
int         整形        16位
long        长整形      32位
long long   长整形      64位
float       单精度浮点数 6位有效数字
double      双精度浮点数 10位有效数字
long double 扩展精度浮点数 10位有效数字
```

使用 sizeof 函数

```cpp
//example.1
#include <iostream>
int main(int argc, char **argv)
{
    std::cout << "basic type   size(bytes)" << std::endl;
    std::cout << "bool " << sizeof(bool) << std::endl;// bool 1
    std::cout << "char " << sizeof(char) << std::endl;// char 1
    std::cout << "wchar_t " << sizeof(wchar_t) << std::endl;// wchar_t 2
    std::cout << "char16_t " << sizeof(char16_t) << std::endl;// char16_t 2
    std::cout << "char32_t " << sizeof(char32_t) << std::endl;// char32_t 4
    std::cout << "short " << sizeof(short) << std::endl;// short 2
    std::cout << "int " << sizeof(int) << std::endl;// int 4
    std::cout << "long " << sizeof(long) << std::endl;// long 4
    std::cout << "long long " << sizeof(long long) << std::endl;// long long 8
    std::cout << "float " << sizeof(float) << std::endl;// float 4
    std::cout << "double " << sizeof(double) << std::endl;// double 8
    std::cout << "long double " << sizeof(long double) << std::endl;// long double 12
    return 0;
}
```

### 数值类型值范围

可以使用宏或者模板

```cpp
#include <limits>

using namespace std;

int main(int argc, char **argv)
{
    cout << std::numeric_limits<long long>::max() << endl; // 9223372036854775807
    cout << std::numeric_limits<int>::min() << endl;       //-2147483648
    return 0;
}
```

### 带符号类型和无符号类型

除了 bool 和扩展字符类型外，其他基本类型都可以划分为带符号 signed 和无符号 unsigned 两种、signed 可表示正数 0 负数，无符号表示大于等于 0 的数

```cpp
//example2.cpp
#include <iostream>
int main(int argc, char **argv)
{
    int int_var = -1;
    short short_var = 1;
    long long_var = -1;
    long long long_long_var = -1;
    // int\short\long\long long 都是带符号的
    //在前面加上unsigned变为无符号类型
    unsigned int unsigned_int_var = 1;
    unsigned short unsigned_short_var = 1;
    unsigned long unsigned_long_var = 1;
    unsigned long long unsigned_long_long_var = 1;
    unsigned unsigned_var = 1; //为unsigned int类型
    //字符类型 有三种
    char char_var = '1'; // char 是signed 还是 unsigned是由编译器决定的
    signed char signed_char = '1';
    unsigned char unsigned_char = '1';
    // float 与 double 、long double 没有无符号与有符号一说
    return 0;
}
```

### 整形的原码反码补码

不懂的话去看一下计算机组成原理基本的编码知识

```cpp
#include <iostream>
#include <cstdint>

using namespace std;

int main()
{
    // 0xFFFF
    // 2^16 = 65536
    // uint16_t 范围为[0,2^16 -1] 即 [0,65535]
    // 0的原码： 0000 0000 0000 0000
    // 2的原码： 0000 0000 0000 0010
    // 65535的原码: 1111 1111 1111 1111
    // 2的反码： 0000 0000 0000 0010
    // 2的补码： 0000 0000 0000 0010

    std::int16_t n = 0x8000;
    cout << n << endl; //-32768

    // 原码: 1000 0000 0000 0001 ; 0x8001
    // 反码: 1111 1111 1111 1110
    // 补码=反码+1: 1111 1111 1111 1111 => -32767
    //            2^15=32768
    // std::int16_t 表示范围 [-32768,32767]
    // 其中-32768怎么表示的呢
    // 用原码 1000 0000 0000 0000 代替表示
    //   反码 1111 1111 1111 1111
    //   补码=反码+1= 1000 0000 0000 0000 => -0
    //   要什么-0，所以可以代替表示为-32768

    // 像其他的8位，32位，64位 都是同理
    return 0;
}
```

### 类型转换

也就是将一种数据类型转化为另一种数据类型

```cpp
//example3.cpp
#include <iostream>
int main(int argc, char **argv)
{
    bool b = 42;          // 42 !=0 -> true
    int i = b;            // true -> 1
    i = 3.14;             // 3.14->3
    double pi = i;        // 3->3.0
    unsigned char c = -1; //如果char占8比特 c的值为255
    signed char c2 = 256; //如果char占8比特，c2的值是未定义的 超出了它的表示范围
    // warning: overflow in conversion from 'int' to 'signed char' changes value from '256' to '0'
    if (1) // int(1)->bool(true) 类型自动转换
    {
        std::cout << "hello world" << std::endl; // hello world
    }
    return 0;
}
```

### 含有无符号类型的表达式

注：切勿混用带符号类型和无符号类型

```cpp
//example4.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    unsigned u = 10;
    int i = -42;
    cout << i + i << endl; //-84
    cout << i + u << endl; // 4294967264
    //第一个是正确的 第二个就有问题 因为 i被从int变为unsigned int 有一部分数据丢失了
    //也就是表达式有无符号与有符号时 有符号先变为无符号然后再进行计算
    unsigned u1 = 42, u2 = 10;
    cout << u1 - u2 << endl; // 32
    cout << u2 - u1 << endl; // 4294967264
    // u2-u1编译器认为结果还是unsigned int 类型 但结果是个负数 就是结果超出了unsigned的表示范围然后给强制转换了
    //当从无符号数减去一个值时，不管是不是无符号数，都应该保证结果不是负数
    /*
    //会出现死循环 因为u不可能<0
    //当u=0 时 又将u-1 然后使得u=4294967295
    for (unsigned u = 10; u >= 0; --u)
    {
        cout << "hello world" << endl;
    }*/
    return 0;
}
```

### 字面值量

什么是字面值量，通俗点就是我们直接表达出来的例如

```cpp
int x=123;//123就是字面值量
```

字面值

```cpp
//example5.cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    //整形
    cout << 20 << endl;   // 20十进制
    cout << 024 << endl;  // 20八进制
    cout << 0x14 << endl; // 20十六进制
    //浮点型字面值是double
    cout << 3.14159E0 << endl; // 3.14159
    cout << 3.14159 << endl;   // 3.14159
    cout << 0. << endl;        // 0
    cout << 0e0 << endl;       // 0
    cout << .001 << endl;      // 0.001
    //字符与字符串
    cout << '1' << endl;           // 1
    cout << "hello world" << endl; // hello world
    //字符串字面量多行书写
    cout << "hello "
            "world"
         << endl; // hello world
    //转义字符
    cout << "hello\'\n";        // hello'
    cout << "\115\115" << endl; // MM
    // bool类型
    cout << true << endl; // 1
    return 0;
}
```

### 转义字符

```
换行符 \n       横向制表符 \t   报警（响铃）符 \a
纵向制表符 \v   退格符  \b      双引号  \"
反斜线 \\       问号 \?        单引号 \'
回车符 \r       进纸符  \f
```

也可以使用 ASCII 码表达方式

```
\a:\7   \n:\12  \40:空格
\0:空字符    \115:字符M   \0xd:字符M
```

### 指定字面值的类型

```cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    cout << L'a' << endl;     // wchar_t
    cout << u8"hi!" << endl;  // utf-8 8位编码Unicode
    cout << 42ULL << endl;    // unsigned long long
    cout << 42ul << endl;     // unsigned long
    cout << 1E-3F << endl;    // float
    cout << 1.14159L << endl; // long double
    // 97 hi !42 42 0.001 1.14159
    return 0;
}
```

指定规则

1、前缀

```
u   Unicode 16字符  char16_t
U   Unicode 32字符  char32_t
L   宽字符          wchar_t
u8  UTF-8           char
```

2、后缀

```
后缀        最小匹配
u or U      unsigned
l or L      long
ll or LL    long long
f or F      float
l or L      long double
```

### 变量

变量提供一个具名的、可供程序操作的存储空间

### 变量定义

c++是`静态类型语言`(在编译阶段检查类型，检查类型的过程称为类型检查)不想 python、javascript 它们不进行声明就能使用甚至不需要给定类型，而 C++是一个严格的语言

```cpp
//example7.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    //定义整型的sum units_sold
    //声明整型的value
    int sum = 0, value, units_sold = 0;
    std::string book("hello world");
    //定义字符串类型
    cout << book << endl; // hello world
    return 0;
}
```

上面使用了 std 里面的 string 类型、先了解他是存储可变长字符串的就好

### 关于初始化

C++11 列表初始化方式及其初始化类型自动转换。C++11 引入了列表初始化，使用大括号`{}`对变量进行初始化，分为直接初始化和拷贝初始化

```cpp
//example8.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    double price = 10.2, discount = price * 0.6;
    // price先被定义立即被初始化为10.2，然后定义discount并且进行初始化
    // C++11的列表初始化 花括号初始化
    int var_1 = 0;
    int var_2 = {0};
    int var_3{0};
    int var_4(0);
    cout << var_1 << " " << var_2 << " " << var_3 << " " << var_4 << endl;
    // 0 0 0 0

    //列表初始化类型转换 要避免这种用法
    long double ld = 3.1415926;
    int a{ld}, b = {ld};           //会进行警告
    cout << a << " " << b << endl; // 3 3
    int c(ld), d = ld;             //会自动执行类型转换
    cout << c << " " << d << endl; // 3 3
    return 0;
}
```

关于直接初始化与拷贝初始化，在 C++11 中，直接初始化和拷贝初始化是两种不同的初始化对象的方式。

- 直接初始化是通过使用圆括号或花括号来初始化对象，例如：
- 拷贝初始化是通过使用等号来初始化对象

直接初始化和拷贝初始化的区别在于对象的构造方式。直接初始化直接调用对象的构造函数进行初始化，而拷贝初始化则是先创建一个临时对象，然后再通过拷贝构造函数将临时对象的值复制给目标对象。

在 C++11 中，直接初始化和拷贝初始化的性能差异已经很小，因此可以根据个人喜好选择使用哪种方式来初始化对象。

```cpp
#include <iostream>
#include <string>
using namespace std;

class X
{
public:
    X(string a, int b)
    {
        cout << "X(string a, int b)" << endl;
    }
    X(int a)
    {
        cout << "X(int a)" << endl;
    }
    X(const X &x)
    {
        cout << "X(const X &x)" << endl;
    }
};

void foo(X x) {}
X bar()
{
    return {"world", 5};
}

int main(int argc, char **argv)
{
    X x1{9};                // X(int a) 直接初始化
    X x2 = {9};             // X(int a) 拷贝初始化
    foo({9});               // X(int a) 拷贝初始化
    foo({"hello", 9});      // X(string a,int b) 拷贝初始化
    bar();                  // X(string a,int b)
    X *pX = new X{"hi", 4}; // X(string a,int b)
    delete pX;
    return 0;
}
```

### 默认初始化值

当定义变量时没有初始化初值，则变量被默认初始化，初始化为什么由变量类型决定,但是有时候会神奇的发现有些变量没有被默认初始化 原因规则可以看 （你可能不知道的C++ 部分的） （为什么声明的变量没有被默认初始化）

```cpp
//example9.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int a;
    float b;
    double c;
    cout << a << " " << b << " " << c << endl;
    // 4201248 8.9997e-039 1.79166e-307
    //可见充满了不确定性
    std::string empty_string;
    cout << empty_string << endl; //空字符串
    return 0;
}
```

在多数情况下、我们遵循约定，尽可能地在定义变量时就将其初始化为一个值

### 变量声明和定义的关系

在 C++中允许程序进行分离式编译:程序分割为若干个文件、每个文件可被独立编译。C++将定义与声明分开。`声明`使得名字让程序所知，一个文件想使用别处定义的名字必须包含其声明，而`定义`负责创建于名字关联的实体

```cpp
// example10.cpp
int i = 23; //全局变量i
int k = 1;
double pi = 3.1415926;
```

```cpp
//example11.cpp
#include <iostream>
extern int i; //声明int i 但i定义在examlple10.cpp程序内
extern int k;
int j;             //声明并定义
extern int f = 13; //在全局范围内对extern变量初始化则会抵消extern的作用
int main(int argc, char **argv)
{
    // extern double pi = 12.0;
    //在函数内部初始化extern变量会报错
    std::cout << k << std::endl; // 1
    std::cout << i << std::endl; // 23
    std::cout << f << std::endl; // 13
    return 0;
}
```

shell windows

```shell
if ($?) { g++ example11.cpp example10.cpp -o example11 } ; if ($?) { .\example11 }
```

bash linux

```bash
g++ example11.cpp example10.cpp -o example11 & ./example11
```

### 变量的类型转换

可分为强制转换和自动转换

```cpp
//example20.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    //自动转换
    int var_int = 12;
    double var_double = var_int;
    cout << var_double << endl; // 12
    int var_int_1 = var_double;
    cout << var_int_1 << endl; // 12
    //自动转换是一件危险的事情，也可超出表示范围造成精度以及数据丢失

    //强制转换
    double r = 12.21;
    int r_int_part = (int)r;
    cout << r_int_part << endl; // 12
    //强制转换就是啥也不管将原来变量内存中的数据拷贝给目标变量
    //强制转换在后面的void指针就有涉及，你们很快就会见面
    return 0;
}
```

### 标识符

C++的标识符由字母、数字和下划线组成必须由下划线或字母开头

```cpp
int _a=12,your_num=8,_your_num2=12;
//int 2d=12; error
```

### C++变量命名规范

- 标识符要能体现其实际含义
- 变量名一般用小写，如 index，不要使用 Index 或 INDEX（常量除外）
- 用户自定义的类名一般以大写字母开头，如 Sales_item
- 如果标识符有多个单词组成，则单词间应有明显区分,如 student_loan 或 studentLoan，不要使用 studentloan

C++保留关键词

别害怕，这些东西可不是人记的，知道有这么回事就行了

```cpp
alignas      C++11 用于内存对齐相关
alignof      C++11 用于内存对齐相关
asm          C++11 用于在C++代码中直接插入汇编语言代码
auto         C++98,C++11 C++ 98 中，auto 的作用是让变量成为自动变量（拥有自动的生命周期），但是该作用是多余的，变量默认拥有自动的生命周期。在C++11 中，已经删除了该用法，取而代之的作用是：自动推断变量的类型。
bool         C++11 声明布尔类型变量
break        C++98 跳出循环语句
case         C++98 用于switch分支语句
catch        C++11 异常处理，与try一起用于捕获并处理异常
char         C++98 声明字符类型
char16_t     C++11 声明UTF-16字符集表示的字符类型，要求大到足以表示任何 UTF-16 编码单元（16位）。
char32_t     C++11 声明UTF-32字符集表示的字符类型，要求大到足以表示任何 UTF-16 编码单元（32位）。
class        C++98,C++11 声明类;声明有作用域枚举类型(C++11 起);2）在模板声明中，class 可用于引入类型模板形参与模板模板形参;3）若作用域中存在具有与某个类类型的名字相同的名字的函数或变量，则 class 可附于类名之前以消歧义，这时被用作类型说明符
const        C++98 可出现于任何类型说明符中，以指定被声明对象或被命名类型的常量性（constness）。
const_cast   C++11 在有不同 cv 限定(const and volatile)的类型间进行类型转换。
constexpr    C++11,14,17 constexpr 说明符声明可以在编译时求得函数或变量的值。然后这些变量和函数（若给定了合适的函数实参）可用于编译时生成常量表达式。用于对象或非静态成员函数 (C++14 前)声明的constexpr说明符蕴含const。用于函数声明的 constexpr说明符或static 成员变量 (C++17 起)蕴含inline。若函数或函数模板的任何声明拥有constexpr说明符，则每个声明必须都含有该说明符。
continue     C++98 跳出当前循环，开始下一次循环
decltype     C++11,14,17 检查实体的声明类型，或表达式的类型和值类别。对于变量，指定要从其初始化器自动推导出其类型。对于函数，指定要从其return语句推导出其返回类型。(C++14 起)对于非类型模板形参，指定要从实参推导出其类型。(C++17 起)
default      C++98 用于switch分支语句
delete       C++11 解内存分配运算符，与new一起管理动态分配内存；弃置函数，如果取代函数体而使用特殊语法=delete，则该函数被定义为弃置的（deleted）。
do           C++98 do-while循环语句
double       C++98 声明双精度浮点数类型
dynamic_cast C++11 类型转换运算符，沿继承层级向上、向下及侧向，安全地转换到其他类的指针和引用。
else         C++98 if-else条件语句
enum         C++98 声明枚举类型
explicit     C++11,17,20  指定构造函数或转换函数(C++11 起)或推导指引(C++17起)为显式，即它不能用于隐式转换和复制初始化。explicit说明符可以与常量表达式一同使用。当且仅当该常量表达式求值为true时函数为显式(C++20 起)。explicit说明符只可出现于在类定义之内的构造函数或转换函数(C++11 起)的声明说明符序列中。
export       C++98,11,20 用于引用文件外模板声明(C++11 前)。不使用并保留该关键词(C++11 起)(C++20 前)。标记一个声明、一组声明或另一模块为当前模块所导出(C++20 起)。
extern       C++98 具有外部链接的静态存储期说明符,显式模板实例化声明
false        C++11 布尔值假
float        C++98 声明单精度的浮点类型
for          C++98 for循环
friend       C++11 友元声明出现于类体内，并向一个函数或另一个类授予对包含友元声明的类的私有及受保护成员的访问权。
goto         C++98 程序跳转到指定的位置
if           C++98 if条件语句
inline       C++98 声明内联类型
int          C++98 声明整形类型
long         C++98 声明长整型
mutable      C++11 可出现于任何类型说明符（包括声明文法的声明说明符序列）中，以指定被声明对象或被命名类型的常量性（constness）或易变性（volatility）。
namespace    C++11 声明名称空间以避免名称冲突
new          C++11 分配运算符，与delete一起管理动态分配内存。
noexcept     C++11 noexcept运算符,进行编译时检查，若表达式声明为不抛出任何异常则返回true。2）noexcept说明符，指定函数是否抛出异常。
nullptr      C++11 指针字面量，用于表示空指针
operator     C++11 为用户定义类型的操作数重载C++运算符。
private      C++11 访问说明符。在class/struct或union的成员说明中，定义其后继成员的可访问性。
protected    C++11 访问说明符。在class/struct或union的成员说明中，定义其后继成员的可访问性。
public       C++11 访问说明符。在class/struct或union的成员说明中，定义其后继成员的可访问性。
register     C++98,17 自动存储期说明符(弃用)。(C++17 前)register关键字请求编译器尽可能的将变量存在CPU内部寄存器中，而不是通过内存寻址访问，以提高效率。不使用并保留该关键词(C++17 起)。
reinterpret_cast     C++11 类型转换运算符。通过重新解释底层位模式在类型间转换。
return       C++98 函数返回
short        C++98 声明短整型数据类型
signed       C++98 声明带符号的数据类型
sizeof       C++98 返回指向的数据对象或类型所占空间的大小，以字节(byte)为单位
static       C++98 声明具有静态存储期和内部链接的命名空间成员,定义具有静态存储期且仅初始化一次的块作用域变量,声明不绑定到特定实例的类成员
static_assert    C++11 声明编译时检查的断言
static_cast      C++11 类型转换运算符。用隐式和用户定义转换的组合在类型间转换。
struct       C++98 声明结构体变量类型
switch       C++98 switch分支语句
template     C++11 声明模板类型
this         C++11 关键字this是一个纯右值表达式，其值是隐式对象形参（在其上调用非静态成员函数的对象）的地址。它能出现于下列语境：在任何非静态成员函数体内，包括成员初始化器列表；在非静态成员函数的声明中，（可选的）cv 限定符（const and volatile）序列之后的任何位置，包括动态异常说明(弃用)、noexcept 说明(C++11)以及尾随返回类型(C++11 起) 在默认成员初始化器中。(C++11 起)
thread_local C++11 声明属于创建线程私有的线程局部数据变量
throw        C++11 抛出异常
true         C++11 布尔值真
try          C++11 异常处理，与catch一起用于捕获并处理异常
typedef      C++98 创建能在任何位置替代（可能复杂的）类型名的别名。
typeid       C++11 查询类型的信息。用于必须知晓多态对象的动态类型的场合以及静态类型鉴别。
typename     C++11,17 在模板声明中，typename可用作class的代替品，以声明类型模板形参和模板形参(C++17 起)。在模板的声明或定义内，typename可用于声明某个待决的有限定名类型。
union        C++98 声明联合体类型变量
unsigned     C++98 声明无符号类型变量
using        C++11 对命名空间的using指令及对命名空间成员的using声明;对类成员的using声明;类型别名与别名模板声明。(C++11 起)
virtual      C++11 说明符指定非静态成员函数为虚函数并实现运行时多态。用于声明虚基类。
void         C++98 声明无(void)类型的变量,无形参函数的形参列表。
volatile     C++98 可出现于任何类型说明符中，以指定被声明对象或被命名类型的易变性（volatility）。
wchar_t      C++11 宽字符类型。要求大到足以表示任何受支持的字符编码。
while        C++98 do-while循环语句
```

代替标识符，有些运算符可以使用英文标识符代替

```cpp
and &&
and_eq &=
bitand &
bitor |
compl ~
not !
not_eq !=
or ||
or_eq |=
xor ^
xor_eq ^=
```

### 名字的作用域

- 全局作用域
- 函数作用域
- 块作用域
- 嵌套作用域

```cpp
// example12.cpp
#include <iostream>
using namespace std;
int i = 10;    //全局作用域
void printI(); //声明printI函数
int main(int argc, char **argv)
{
    printI(); //调用printI函数
    return 0;
}
void printI()
{
    cout << "i " << i << endl;
    int j = 5; //函数作用域
    //块作用域 for内的i在for下面的花括号内有效也就是代码块
    for (int i = 0; i < j; i++)
    {
        cout << i << endl; // 0 1 2 3 4
    }
    cout << i << endl; // 10
    //嵌套作用域
    if (true)
    {
        int p = 1;
        for (int i = 0; i < p; i++)
        {
            cout << p << endl; // 1
            //子具有父代码块的作用域内的变量作用域
        }
    }
}
```

到这里还没有接触过编写自定义的函数、再此我们认为会调用 printI 函数内的代码就好了

### 复合类型

复合类型是指基于其他类型定义的类型，下面我们来学习引用和指针

### 引用

引用即别名，引用在定义时必须被初始化

```cpp
//example13.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int var1 = 12;
    int &var2 = var1;
    cout << var2 << endl; // 12
    var2 = 13;
    cout << var2 << endl; // 13
    cout << var1 << endl; // 13
    //可见var1与var2是同一个东西，var2只是变量var1的别名
    // int &var3; error 引用必须被初始化否则报错编译不通过
    return 0;
}
```

引用定义方式及其引用间的相互赋值

```cpp
//example14.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int a = 1, &refer_a = a;
    cout << a << endl;       // 1
    cout << refer_a << endl; // 1
    double b = 1;
    // int &refer_b = b; error 二者类型不同

    //引用可以赋值给引用吗 yes
    float c = 12;
    float &refer_c = c;
    float &refer_c_2 = refer_c;
    cout << c << endl;         // 12
    cout << refer_c << endl;   // 12
    cout << refer_c_2 << endl; // 12

    //引用赋值给数值类型呢 yes
    float d = refer_c_2;
    cout << d << endl; // 12

    //总结：引用即别名
    return 0;
}
```

### 指针

指针是 C/C++的精髓,指针是一个存储内存地址的变量

### 取地址、指针存地址、已知地址读数据

```cpp
//example15.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int a = 12;
    int *a_address = &a;
    //&a获取a变量的内存地址，然后让一个int类型的指针存起来
    cout << a_address << endl; // 0x61ff08 是一个内存地址
    //怎么利用指针存储的地址读取变量值呢
    int a_value = *(a_address);
    //我们知道int为4字节 *(a_address)的操作就是
    //从a_address开始向后的四个字节大小的内存中的内容
    //按照int形式读取出来，然后将值赋值给a_value
    cout << a_value << endl; // 12
    //指针类型与变量类型要匹配
    return 0;
}
```

使用 `&变量名` 取地址，使用 `*指针变量名` 形式取值

### 指针的四种状态

1、指向一个对象 2、指向紧邻对象所占空间的下一个位置 3、空指针，意味着指针没有存储任何地址 4、无效指针，存的地址没有意义

### 指针变量本身也有大小

```cpp
//example16.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int *a;
    cout << sizeof(a) << endl; // 4
    double *b;
    cout << sizeof(b) << endl; // 4
    void *c;
    cout << sizeof(c) << endl; // 4
    //等
    return 0;
}
```

### 空指针

也就指针变量没有存储任何内存地址

```cpp
//example17.cpp
#include <iostream>
#include <cstdlib>
using namespace std;
int main(int argc, char **argv)
{
    int *p1;
    cout << *p1 << endl; //乱码
    //为什么呢？因为p1没有被初始化，它自动默认值是随机的
    //也就是存储的内存地址是随机的
    //当*p1取出内存向后按4字节整形的数据读取时，读到的东西是也是未知的
    int *p2 = nullptr;
    cout << p2 << endl; // 0
    int *p3 = NULL;
    cout << p3 << endl; // 0
    //我们使用nullptr 或 NULL 进行初始化
    //代表其没有存储任何地址，但其实是存储了0
    // cout << *p3 << endl; 会卡住
    return 0;
}
/*
nullptr是C++支持的
NULL是C语言的内容，使用NULL尽可能引入头文件
#include<cstdlib> 但大多数编译器允许不引入
*/
```

### C++的 NULL 与 nullptr

在 C 中，NULL 通常被定义为下面内容

```cpp
#define NULL ((void *)0)
```

C 中的 NULL 实际为一个空指针，下面的代码编译是没有问题的，会把空指针赋给 int 和 char 指针的时候，发生了隐式类型转换，把 void 指针转换成了相应类型的指针。

```cpp
int *pi = NULL;
char *pc = NULL;
```

在C++标准中有一条特殊的规则,即0是一个整型常量，又是一个空指针常量，0作为空指针常量还能隐式地转换为各种指针类型

```cpp
char *p = NULL;
int x = 0;
```

这里的NULL是一个宏,在C++11标准之前其本质就是0

```cpp
#ifndef NULL
    #ifdef __cpluscplus
        #define NULL 0
    #else
        #define NULL ((void*)0)
    #endif
#endif
```

C++将NULL定义为0,而C语言将NULL定义为`(void *)0`,之所以有区别，是因为C++和C的标准定义不同

- C++标准中定义空指针常量是评估为0的整数类型的常量表达式右值。
- C标准中定义0为整型常量或者类型为`void*`的空指针常量。

用 NULL 代替 0 表示空指针在函数重载时会出现问题

```cpp
#include <iostream>

using namespace std;

void func(void* i)
{
    cout << "func1" <<endl;
}

void func(int i)
{
    cout << "func2" <<endl;
}

int main()
{
    func(NULL);
    func(nullptr);
    func(reinterpret<void*>(NULL)); // 调用void func(void* i)不是void func(int i)
    return 0;
}

```

上面代码 C++编译会报错

```bash
[dream@localhost 10:16:34 tmp]$ g++ main.cpp -o main.exe --std=c++11
main.cpp: 在函数‘int main()’中:
main.cpp:17:14: 错误：调用重载的‘func(NULL)’有歧义
     func(NULL);
              ^
main.cpp:17:14: 附注：备选是：
main.cpp:5:6: 附注：void func(void*)
 void func(void* i)
      ^
main.cpp:10:6: 附注：void func(int)
 void func(int i)
```

下面的例子看起来更加奇怪了

```cpp
std::string s1(false);
std::string s2(true);
```

s1可以编译成功，s2失败，原因是false被隐式转为了0，而0又能作为空指针常量转换为`const char* const`所以s1成功，
true没有这样的待遇。如果使用`C++ -std=c++11`及其以后的标准来编译，两条均会报错。

现代 C++尽量用 nullptr 来代表空指针，C++中的 NULL 只是一个数字 0 的宏定义

`std::nullptr_t`类型的纯右值。nullptr的用途非常单纯，就是用来指示空指针，
它不允许运用在算术表达式中或者与非指针类型进行比较（除了空指针常量0）。
它还可以隐式转换为各种指针类型，但是无法隐式转换到非指针类型。
注意，0依然保留着可以代表整数和空指针常量的特殊能力，保留这一点是为了让C++11标准兼容以前的C++代码。

```cpp
// 全都可以编译
char* ch = nullptr;
char* ch2 = 0;
assert(ch == 0);
assert(ch == nullptr);
assert(!ch);
assert(ch2 == nullptr);
assert(nullptr == 0);
```

虽然nullptr可以和0进行比较，但这并不代表它的类型为整型，同时它也不能隐式转换为整型：

```cpp
int n1 = nullptr; // 错误 nullptr不是int类型
char* ch2 = true ? 0 : nullptr; // 错误 0与nullptr类型不一致
int n2 = true ? nullptr : nullptr; // 错误 nullptr不是int类型
int n3 = true ? 0 : nullptr; // 错误 0与nullptr类型不一致
```

nullptr的类型`std::nullptr_t`，它并不是一个关键字，而是使用decltype将nullptr的类型定义在代码中，
C++标准规定该类型的长度和`void *`相同：

```cpp
namespace std
{
    using nullptr_t = decltype(nullptr);
    // 等价于
    typedef decltype(nullptr) nullptr_t;
}
static_assert(sizeof(std::nullptr_t) == sizeof(void*));
```

我们可以使用`std::nullptr_t`创建自己的nullptr，并且有与nullptr相同的功能,

```cpp
std::nullptr_t null1,null2;
char* ch = null1;
char* ch2 = null2;
assert(ch == 0);
assert(ch == nullptr);
assert(ch == null2);
assert(null1 == null2);
assert(nullptr == null1);
```

虽然这段代码中null1、null2和nullptr的能力相同，但是它们还是有很大区别的。首先，nullptr是关键字，而其他两个是声明的变量。其次，nullptr是一个纯右值，而其他两个是左值

```cpp
std::nullptr_t null1,null2;
std::cout << &null1 << std::endl;
std::cout << &null2 << std::endl;
// null1和null2是左值，可以成功获取对象指针
// 并且指针指向的内存地址不同

std::cout << &nullptr << std::endl; // 错误 nullptr是一个右值
```

nullptr可以解决 `void f(int)` 与 `void f(char *)`调用问题，因为nullptr可以隐式转换为`char*`不能转换为int。

除此之外，可以为函数模板或者类设计一些空指针类型的特化版本。在C++11以前这是不可能实现的，因为0的推导类型是int而不是空指针类型

```cpp
#include <iostream>
using namespace std;

template <class T>
struct widget
{
    widget()
    {
        std::cout << "template" << std::endl;
    }
};

template <>
struct widget<std::nullptr_t>
{
    widget()
    {
        std::cout << "nullptr" << std::endl;
    };
};

template <class T>
widget<T> *make_widget(T)
{
    return new widget<T>();
}

int main(int argc, char **argv)
{
    auto w1 = make_widget(0);       // template
    auto w2 = make_widget(nullptr); // nullptr
    return 0;
}
```

### 赋值和指针

```cpp
//example18.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    //将字面量赋值给指针变量
    int *p1 = 0; //只允许0 也就是初始化为空指针

    char ch = 'a';
    char *ch_ptr = &ch;      //初始化为ch变量的地址
    cout << *ch_ptr << endl; //'a'

    //已知地址改变其相应内存存储的数据
    *ch_ptr = 'b';
    cout << ch << endl; // b

    ch_ptr = nullptr; //使得ch_ptr指针变量不存储任何地址

    return 0;
}
```

### 多维指针

现在我们知道变量是一块内存、内存有头地址，那么指针本身也是变量，那么指针变量的地址可以用指针变量存起来吗

```cpp
//example19.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    float a = 12.32;
    float *a_ptr = &a;
    float **a_ptr_ptr = &a_ptr;
    cout << a << endl;           // 12.32
    cout << *a_ptr << endl;      // 12.32
    cout << **a_ptr_ptr << endl; // 12.32
    return 0;
}
```

其实理解了，指针就是存储相应类型变量的内存的头地址的最跟根本的道理，这里并不难理解

### void 指针

我们现在知道指针变量是由类型的，但有没有通用的呢

```cpp
//example21.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int a = 12;
    int *a_ptr = &a;
    void *void_ptr = a_ptr;
    // cout << *void_ptr << endl; 报错 虽然void_ptr存储了a_ptr存储的地址
    //但是当我们从其内存读取数据时void不知道要读取多长，也不知道要按照什么数据类型读取
    //所以我们要进行强制转换,然后在进行使用
    int *void_ptr_to_int = (int *)void_ptr;
    cout << *void_ptr_to_int << endl; // 12
    return 0;
}
```

void 指针有什么用，不要急他会在在后面的函数传递指针变量以及函数指针运用中大放光彩

### 理解复合类型的声明

有时同时声明普通变量、指针变量、引用变量会使得我们有点难理解

```cpp
//example22.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int a, *b;
    // a为普通变量 b为指针变量
    int *c, d;
    // c为指针变量 d为普通变量
    int *e, *f;
    // e 和 f都是指针变量
    int &i = a, *k, l;
    // i为引用变量 k为指针变量 l为普通变量
    return 0;
}
//总之* &都是指对一个有效、要声明多个就要写多次
```

### 指针的引用

变量有引用类型，那么指针也是变量，它的引用怎么使用

```cpp
//example23.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int a = 13;
    int *a_ptr = &a;
    int *&refer_a_ptr = a_ptr;
    cout << *refer_a_ptr << endl; // 13
    *refer_a_ptr = 15;
    cout << *refer_a_ptr << endl; // 15
    return 0;
}
```

分别懂了指针和引用，理解指针的引用是很简单的

我们发现引用和指针有点类似，但是有不同。指针是 C 的内容，引用是 C++特有的，引用更像是指针的语法糖，我们暂且认为有 C++背后在支持为我们自动使用\* &就好了，这样引用对于指针就有些能说通了对吧

### const 限定符

有时我们需要定义一个变量，其一旦被初始化后就不能被改变

```cpp
// example24.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    const int const_num = 12;
    cout << const_num << endl; // 12
    //尝试改变
    // const_num = 3;
    // error: assignment of read-only variable 'const_num'
    int a = const_num;
    cout << a << endl; // 12
    const int const_num_2 = a;
    cout << const_num_2 << endl; // 12
    return 0;
}
```

这也代表 const 变量在定义的时候就应该进行初始化

### const 对象仅在文件内有效

这个怎么理解呢，我们上面有接触到两个 cpp 文件分辨编译然后链接的情况，如果不同的文件需要公用同一个 const 变量应该怎么做呢

```cpp
//example25.cpp
extern const int bufSize = 888;
```

```cpp
//example26.cpp
#include<iostream>
extern const int bufSize;
using namespace std;
int main(int argc,char**argv){
    cout<<bufSize<<endl;//888
    return 0;
}
```

```bash
g++ example25.cpp example26.cpp -o example25.exe
./example25.exe
```

### const 的引用

我们知道引用被初始化后是可以改变的，也就是换一个变量进行绑定 const 引用使得其初始化后不能改变目前我们学到的引用为左值引用，左值引用能分为非常量左值引用和常量左值引用，非常常量引用只能引用到左值，而常量左值引用既可以引用到左值也能引用到有右值上。

```cpp
//example28.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int a = 4;
    const int &refer_a = a;     //绑定a
    const int &const_num = 888; //绑定为常量
    cout << refer_a << " | " << const_num << endl;
    // 4 | 888
    const int &const_num_1 = const_num * 2;
    cout << const_num_1 << endl; // 1776

    // const_num_1 = 999;
    // assignment of read-only reference 'const_num_1'

    return 0;
}
```

背后发生了什么，当我们为 const 的引用初始化为一个常量是时，编译器生成相对应的数据类型变量，用生成的这个变量来存储这个常量，然后将引用绑定为生成的那个变量。

进阶原理，这个的话可能要学完 C++你才能看得懂，这属于 C++的进阶了,常量左值引用与非常量左值引用

```cpp
// 关闭返回值优化，因为GCC的RVO(函数返回值优化)会减少复制构造函数的调用
// g++ main.cpp -o main -O0 -fno-elide-constructors
#include <iostream>
using namespace std;

class X
{
public:
    X()
    {
        cout << "X()" << endl;
    }
    X(const X &x)
    {
        cout << "X(const X &x)" << endl;
    }
    X &operator=(const X &x)
    {
        cout << "X &operator=(const X &x)" << endl;
        return *this;
    }
    ~X()
    {
        cout << "~X()" << endl;
    }

public:
    int n;
};

X fun()
{
    X x;
    x.n = 100;
    return x;
}

int main(int argc, char **argv)
{
    {
        // X &x_ref = fun(); // 编译错误，非常量引用的初始值必须为左值
        const X &x_ref = fun(); // X() X(const X&x) ~X()
        // 常量左值引用初始值可以为右值,执行两次构造是因为在fun中构造了变量x，x为左值其将用拷贝构造函数拷贝一份作为右值进行返回
        const X &x1_ref = x_ref;
        cout << x_ref.n << endl;                          // 100
        cout << boolalpha << (&x_ref == &x1_ref) << endl; // true
        // ~X()
    }
    const X &x_ref = fun(); // X() X(const X &x) ~X()
    X x1 = x_ref;           // X(const X &x)
    const X &x2_ref = x1;   // 常量左值引用引用左值
    //~X() ~X()
    // 析构则是x1变量与fun返回的右值的析构
    return 0;
}
```

### 指针和 const

与 const 引用类似、指针变量也有 const

### 指向常量的指针

```cpp
//example29.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int a = 888;
    int *a_ptr = &a;
    a_ptr = nullptr; // a_ptr存储的地址可以被改变

    //有两种情况一种是指向常量的指针
    const int const_num = 999;
    const int *const_num_ptr = &const_num;//const_num_ptr是指针指向const int类型
    // int *num_ptr = &const_num;
    // error: invalid conversion from 'const int*' to 'int*'

    //需要注意的是 无法改变const_num变量的值
    //*const_num_ptr = 888;
    // error: assignment of read-only location '* const_num_ptr'

    //但能改变const_num_ptr的地址
    const_num_ptr = &a;
    cout << *const_num_ptr << endl; // 888

    return 0;
}
```

### const 指针

使得指针变量存储的地址一旦被初始化、就不能在被改变

```cpp
//example30.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int a = 999;
    int *const refer_a = &a;//refer_a是const的，类型为int*
    cout << *refer_a << endl; // 999
    int b = 888;

    // refer_a = &b;
    // error: assignment of read-only variable 'refer_a'

    //但其存储的地址相应的变量值可以被改变
    *refer_a = 888;
    cout << a << endl; // 888

    return 0;
}
```

### 顶层 const

现在我们知道了，有一种限制是对相应地址内存操作进行了限制，也就是常量的指针，我们可以改变指针存储的地址，但不能改变相应地址变量存储的数据，这种 const 被称为底层 const(low-level const)

顶层 const(top-level const) 则是，一个指针本身也是一个变量，const 作用为一旦指针存储的地址被初始化，则不能再被改变。

### 为什么需要 constexpr

C++11提供了constexpr，但是为什么C++需要constexpr呢，以下从`常量的不确定性`说起。

在C++11标准以前，没有一种方法能高效要求一个变量或者函数在编译阶段就计算出结果。应用场景主要有
case语句、数组长度、枚举成员的值以及非类型的模板参数。

```cpp
#include <iostream>
#include <tuple>
using namespace std;

const int index0 = 0;
#define index1 1
const int x_size = 5 + 8;
#define y_size 6 + 7

// 数组长度
char buffer[x_size][y_size] = {0};

// 枚举成员
enum
{
    enum_index0 = index0,
    enum_index1 = index1,
};

int main(int argc, char **argv)
{
    // case 语句
    switch (argc)
    {
    case index0:
        std::cout << "index0" << std::endl;
        break;
    case index1:
        std::cout << "index1" << std::endl;
        break;
    default:
        std::cout << "none" << std::endl;
    }

    // 非类型的模板参数
    std::tuple<int, char> tp = std::make_tuple(4, '3');
    int x1 = std::get<index0>(tp);
    char x2 = std::get<index1>(tp);

    return 0;
}
```

上面的代码可以顺利编译成功，const定义的常量和宏都能在要求编译阶段确定值得语句中使用。其实这种方式不是很完美，C++程序员应该尽量少使用宏，预处理器对于宏只是简单的字符替换，完全没有类型检查，宏使用不当很难排查。而且对于const定义的常量可能是运行时常量，这种情况无法再case语句以及数组长度等语句中使用。

```cpp
#include <iostream>
#include <tuple>
using namespace std;

int get_index0()
{
    return 0;
}

int get_index1()
{
    return 1;
}

int get_x_size()
{
    return 5 + 8;
}

int get_y_size()
{
    return 6 + 7;
}

const int index0 = get_index0();
#define index1 get_index1()

const int x_size = get_x_size();
#define y_size get_y_size()
char buffer[x_size][y_size] = {0};
// 变量 "x_size" (已声明 所在行数:27) 的值不可用作常量
// 无法调用非 constexpr 函数 "get_y_size" (已声明 所在行数:19)

enum
{
    enum_index0 = index0, // 变量 "index0" (已声明 所在行数:24) 的值不可用作常量
    enum_index1 = index1, // 无法调用非 constexpr 函数 "get_index1" (已声明 所在行数:9)
};

std::tuple<int, char> tp = std::make_tuple(4, '3');
int x1 = std::get<index0>(tp);  // 没有与参数列表匹配的 重载函数 "std::get" 实例
char x2 = std::get<index1>(tp); // 没有与参数列表匹配的 重载函数 "std::get" 实例

int main(int argc, char **argv)
{
    int i = 0;
    switch (argc)
    {
    case index0: // 变量 "index0" (已声明 所在行数:24) 的值不可用作常量
        std::cout << "index0" << std::endl;
        break;
    case index1: // 无法调用非 constexpr 函数 "get_index1" (已声明 所在行数:9)
        std::cout << "index1" << std::endl;
        break;
    default:
        std::cout << "none" << std::endl;
    }
    return 0;
}
```

这种情况不仅仅可能出现在我的自己的代码中，标准库也有这种情况，对于limits

```cpp
// C语言中有头文件<limits.h> 中用宏定义了各个整型类型的最大值和最小值
#define UCHAR_MAX 0xff // unsigned char类型的最大值
// 我们可以用宏代替数字
char buffer[UCHAR_MAX] = {0};
// C++标准库为我们提供了 <limits>
char buffer[std::numeric_limits<unsigned char>::max()] = {0}; // 编译不过 函数返回值必须在运行时计算 但是后面STL有了constexpr函数 所以numeric_limits::max()会返回constexpr支持了数组长度初始化
```

所以为了以上的常量无法确定问题，C++11标准中提供了新的关键字 constexpr。

### constexpr 和常量表达式

常量表达式为在编译过程中就能得到计算结果的表达式，字面值属于常量表达式，常量表达式初始化的 const 对象也是常量表达式。constexpr不仅仅可以作用于值还可以作用于函数，可以看第6章函数 constexpr函数。

### 常量表达式

```cpp
//example31.cpp
#include <iostream>
using namespace std;

int getANumber(){
    return 1;
}

int main(int argc, char **argv){
    const int a = 888;
    //值888是一个常量表达式 其为字面值
    // a因为是const变量其也是常量表达式
    int b = a;
    //编译时等价于 int b=888;
    const int c = a + 2; // a+2是常量表达式
    // 则c也是常量表达式
    const int d = getANumber();
    // d不是常量表达式 因为当程序运行的时候才能确定d的值
    return 0;
}
```

### constexpr 变量

可见写代码时很难确定是不是常量表达式，C++11 为我们提供了一种机制，将变量定义为 constexpr 变量其被定义的时候需要初始化，且右值必须为常量表达式，也就是我们提供了判断常量表达式的方式。constexpr是一个加强版的const，不仅要求常量表达式是常量，并且要求是一个编译阶段就够确定其值的常量。

```cpp
//example32.cpp
#include <iostream>
using namespace std;
int getNumber()
{
    return 888;
}
int main(int argc, char **argv)
{
    constexpr int int_sz = sizeof(int); // yes

    // constexpr int a = getNumber();
    // error: call to non-'constexpr' function 'int getNumber()'
    // 编译的时候可以判断等号右边不是常量表达式
    return 0;
}
```

使用规则：如果你认为一个变量是常量表达式，那就把它声明成 constexpr 类型

```cpp
#include <iostream>
using namespace std;

constexpr int x = 42;
char buffer[x] = {0};
const int x1 = 42;
char buffer1[x1] = {0};

int main(int argc, char **argv)
{
    return 0;
}
```

上面的constexpr与const变量都能正确的初始化数组长度,但是const并没有确保编译期常量的特性

```cpp
#include <iostream>
using namespace std;

int x1 = 42;
const int x2 = x1;     // 运行时x2才被初始化
char buffer[x2] = {0}; // error: size of array ‘buffer’ is not an integral constant-expression

int main(int argc, char **argv)
{
    return 0;
}
```

而将const换为constexpr，会有不同的情况发生

```cpp
#include <iostream>
using namespace std;

int x1 = 42;
constexpr int x2 = x1; // error: the value of ‘x1’ is not usable in a constant expression
char buffer[x2] = {0}; // error: size of array ‘buffer’ is not an integral constant-expression

int main(int argc, char **argv)
{
    return 0;
}
```

### 使用 constexpr 的好处

constexpr 是一个关键字，用于声明能够在编译时求值的常量表达式，有以下好处

1、编译时求值：constexpr 变量的值在编译时就能够确定，而不是在运行时计算。这意味着编译器可以在编译期间对 constexpr 变量进行优化，从而提高程序的性能。

2、常量折叠：constexpr 变量可以用于进行常量折叠。在编译时，对于多个 constexpr 变量的组合和运算，编译器会将它们合并为一个单独的常量表达式，从而减少运行时的计算开销。

3、值的确定性：constexpr 变量的值在编译时就确定了，因此它们是不可变的。这提供了更强的类型安全性，防止在运行时意外修改变量的值。

4、作为常量表达式的要求：在某些上下文中，需要使用常量表达式，如数组大小、模板参数等。通过将变量声明为 constexpr，可以确保其在这些上下文中可用。

```cpp
#include <iostream>

constexpr int factorial(int n) {
//  std::cout << "factorial" << std::endl;//如果有这条语句，tag a处无法调用
    if (n <= 1)
        return 1;
    else
        return n * factorial(n - 1);
}

int main() {
    constexpr int num = 5;
    constexpr int result = factorial(num);//tag a
    std::cout << "Factorial of " << num << " is " << result << std::endl;
    return 0;
}
```

### 字面值类型

常量表达式值需要在编译时就能得到计算，我们把它们称为“字面值类型”(literal type)

### 指针和 constexpr

如果指针变量声明时前面加了 constexpr,则仅对指针变量本身有效，与指针的指向无关

```cpp
//example33.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    const int *p = nullptr;     //存储int常量的变量的地址
    constexpr int *k = nullptr; //代表等号的右边必须是一个常量表达式
    int a = 888;

    // constexpr int *m = &a;
    // error: '& a' is not a constant expression
    // 因为只有在运行阶段a变量的内存地址才能被确定,*a不是一个常量表达式

    int b = 12;
    // k = &b;
    // error: assignment of read-only variable 'k'
    // exstexpr 变量是一个顶层const

    constexpr int c = 1;
    // c = 32;
    // error: assignment of read-only variable 'c'
    // 对于普通变量则是其存储的值不能被改变 道理还是顶层const的概念

    return 0;
}
```

最容易弄混的地方

```cpp
//example34.cpp
#include <iostream>
using namespace std;
// 全局变量的内存地址在编译时就被确定了
const int i = 10;
int j = 0;
int main(int argc, char **argv)
{
    constexpr int *np = nullptr;
    constexpr int k = 42;
    // 等号右边必须为常量表达式，且加上了顶层const显示

    constexpr const int *p = &i;
    // 等号右边比须为常量表达式，且i须为const int变量

    constexpr int *p1 = &j; // 等号右边必须为常量表达式
    cout << *p1 << endl;    // 0
    cout << "over" << endl; // over
    return 0;
}
```

新的知识，全局变量在编译时就确定了其内存地址。

### constexpr 对浮点的支持

constexper引入前，C++开发经常用enum hack使得编译器在编译阶段计算常量表达式的值。但是enum只支持整形，所以无法用于浮点类型的编译期计算。 constexpr支持浮点类型的常量表达式值，标准规定其精度必须至少和运行时的精度相同。

```cpp
#include <iostream>
#include <stdint.h>
constexpr double sum(double x)
{
    return x > 0 ? x + sum(x - 1) : 0;
}

int main()
{
    constexpr double n = sum(10.10);
    std::cout << n << std::endl; // 56.1
    return 0;
}
```

### 处理类型

数据类型的名称可能有时候差强人意，难以记忆，再在 C/C++内提供了强大处理类型的方式

### 类型别名 typedef 与 using

作用为为已有的类型起一个别名, 比如`std::map<int, std:: string>::const_iterator`。为了让代码看起来更加简洁，往往会使用typedef为较长的类型名定义一个别名，例如：

```cpp
typedef std::map<int, std::string>::const_iterator map_const_iter;
map_const_iter iter;
```

```cpp
//example35.cpp
#include <iostream>
using namespace std;
typedef int age;
typedef int *age_p;            // age_p等价于int*
typedef age my_age, *my_age_p; // my_age等价于int my_age_p等价于int*
typedef const int const_int;   // const_int等价于const int

int main(int argc, char **argv)
{
    age a = 12;
    cout << a << endl; // 12
    age_p a_ptr = &a;
    cout << *a_ptr << endl; // 12
    const_int c = a * 3;
    cout << c << endl; // 36
    // c=999; error: assignment of read-only variable 'c'
    my_age_p age_p = &a;
    cout << *age_p << endl; // 12
    return 0;
}
```

可见我们能够玩的非常花里胡哨，但是在实际的开发中我们要根据自己的需要来使用 typeof，而不是一昧的追求新颖

### 用 using 起别名

C++11标准提供了一个新的定义类型别名的方法，该方法使用using关键字，具体语法如

```cpp
using identifier = type-id
```

这种表达式在定义函数指针类型的别名时会显得格外清晰，而typedef有些鸡肋。

```cpp
typedef void(*func1)(int ,int);
using func2 = void(*)(int,int);
```

如果一定要找出typdef在定义类型别名上的一点优势，那应该只有对C语言的支持了。

```cpp
//example36.cpp
#include <iostream>
using namespace std;
using Price = int;
using Price_p = int *;
int main(int argc, char **argv)
{
    Price price = 12;
    Price_p price_ptr = &price;
    cout << price << " " << *price_ptr << endl; // 12 12
    return 0;
}
```

### 指针、常量和类型别名

让你直喊 cao 的功能

```cpp
//example37.cpp
#include <iostream>
using namespace std;
typedef int *int_p;
int main(int argc, char **argv)
{
    int a = 12;
    const int_p ptr = &a; // ptr是指向int的指针类型，且有const
    cout << *ptr << endl; // 12
    *ptr = 999;
    // ptr = nullptr; error: assignment of read-only variable 'ptr'
    // ptr是一个指向int的常量指针

    const int_p *p = &ptr; // const (int*)* p是一个指针类型，指向const (int*)类型
    cout << **p << endl;   // 999
    //*p = nullptr; // error: assignment of read-only location '* p'
    // 可见这个const是一个底层const 也就是 const (int*)*的效果
    p = nullptr;
    // p是一个指向const char的指针
    // 真实tmd屁股里放鞭炮开了眼了
    return 0;
}
```

到底怎么回事？这真是一个鸡肋的东西，像我这种菜鸡我选择在实际应用中避免使用这种写法

### auto 类型说明符

编译器自动为我们判断类型，auto 变量定时必须被初始化,C++11 赋予 auto 新的含义，声明变量时根据初始化表达式自动推断该变量的类型、声明函数时函数返回值的占位符。

```cpp
#include <iostream>
using namespace std;

auto sum(int a1, int a2) -> int
{
    return a1 + a2;
}

int main(int argc, char **argv)
{
    auto a = 32 + 23.0; // double a
    cout << a << endl;  // 55
    a = 23.33;
    cout << a << endl;         // 23.33
    cout << sizeof(a) << endl; // 8
    // 可见32+23.是一个double字面量 编译时自动为我们判断类型

    auto b = 3 + 3;
    b = 23.4;
    cout << b << endl;         // 23
    cout << sizeof(b) << endl; // 4 可见b为一个int变量

    // auto c = 2, c = 3.f; error: inconsistent deduction for 'auto': 'int' and then '<type error>'
    // 在编译阶段时本质是判断右边为什么类型然后将auto进行替换
    // 可见auto只能被一个类型替换，当定义多个不同类型变量的时候将会报错

    auto d = 33, *p = &b; // 相当于 int d = 33, *p = &b;
    cout << *p << endl;   // 23
    // 也就是auto只能被一个类型进行替换

    auto i = 5;                // 推断为 int
    auto str = "hello auto";   // 推断为const char*
    cout << sum(i, i) << endl; // 10

    // 使用条件表达式初始化auto声明的变量时，编译器总是使用表达能力更强的类型
    auto i1 = true ? 5 : 2.3; // double i1

    return 0;
}
```

但是在实际使用的时候尽量还是使用 IDE，然后将鼠标放到变量上看一看 auto 自动推导的类型是否符合预期

### 复合类型、常量和 auto

用引用变量初始化 auto 变量会是怎样的情况

```cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int i = 10, &r = i;
    auto a = r;        // int a
    cout << a << endl; // 10
    // a是引用变量还是int变量
    a = 99;
    cout << i << endl; // 10
    cout << a << endl; // 99
    // a是一个int类型变量
    return 0;
}
```

### auto 与 const 的爱恨情仇

```cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int i = 0;
    const int ci = i, &cr = ci; // cr为const int类型变量的引用
    auto b = ci;                // int b ,忽略ci的顶层const
    auto c = cr;                // int c ,cr为ci的别名，忽略顶层const
    auto d = &i;                // int *d
    auto e = &ci;               // const int *e

    // 如果希望加上顶层const
    const int g = 34;
    const auto k = g; // const int k
    // k = 99; error: assignment of read-only variable 'k'
    auto v = g; // int v, v无顶层const
    v = 33;

    const int num = 999;
    const int *const num_ptr = &num; // const int *const num_ptr
    auto num_ptr_auto = num_ptr;     // const int *num_ptr_auto
    // 去掉了顶层const，保留底层const
    return 0;
}
```

### auto 引用

除此简单的用法之外，auto 还可以在使用右值引用时进行使用

```cpp
//example41.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    const int ci = 23;
    auto &g = ci;       // const int & g
    const auto &h = 65; // const int & h
    cout << h << endl;  // 65

    // auto在声明多个变量时需要多次声明& * ，每个符合只作用于单个变量
    int a = 23, b = 54;
    auto *p = &a, &refer_a = a, c = b;                // auto is int
    cout << *p << " " << refer_a << " " << c << endl; // 23 23 54

    return 0;
}
```

### auto 与多态

```cpp
#include <iostream>
using namespace std;

class Base
{
public:
    inline virtual void func()
    {
        cout << "Base::func" << endl;
    }
};

class Derived : public Base
{
public:
    inline virtual void func() override
    {
        cout << "Derived::func" << endl;
    };
};

int main(int argc, char **argv)
{
    Base *obj = new Derived;
    auto obj_ptr = *obj;  // Base obj_ptr,因为obj为Base类型的指针,拷贝构造基类部分
    obj_ptr.func();       // Base::func
    auto &obj_ref = *obj; // Base &obj_ref
    obj_ref.func();       // Derived::func
    delete obj;
    return 0;
}
```

### auto 在 C++中演进

C++11 支持 auto 在静态成员变量用 auto 声明并初始化，前提是 auto 必须是 const 的

```cpp
#include <iostream>
using namespace std;

struct A
{
    static const auto i = 999;
};

int main(int argc, char **argv)
{
    cout << A::i << endl; // 999
    return 0;
}
```

C++14 支持对类型返回类型声明为 auto

```cpp
#include <iostream>
using namespace std;

// int sum1(int a1, int a2)
// auto sum1(int a1, int a2)
// {
//     return a1 + a2;
// }

// 错误
// auto sum2(long a1, long a2)
// {
//     if (a1 > 0)
//     {
//         return a1 + a2;
//     }
//     return 0; // error:推导出的返回类型 "int" 与之前推导出的类型 "long" 冲突
// }

// lambda
auto sum3 = [](auto a1, auto a2)
{
    return a1 + a2;
};

auto retval = sum3(5, 5.0); // double retval=sum3(int ,double);

// int &ref(int &i)
auto ref = [](int &i) -> auto &
{
    return i;
};

int main(int argc, char **argv)
{
    cout << retval << endl; // 10
    int a1 = 1;
    auto &a1_ref = ref(a1);
    cout << boolalpha << (&a1_ref == &a1) << endl; // true
    return 0;
}
```

C++17 支持 auto 非 const 的静态成员变量初始化(不建议使用，可能引起问题)，除此之外还支持了初始化列表中的使用

```cpp
#include <iostream>
using namespace std;

struct A
{
    static inline auto i = 999; // inline static成员变量多个源文件共享不会重复定义
};

int main(int argc, char **argv)
{
    A::i = 19;
    cout << A::i << endl; // 19

    // std::initializer_list<int> init1
    auto init1 = {1, 2, 3, 4};
    // std::initializer_list<int> init2
    auto init2 = {1};
    // int init3
    auto init3{1};

    return 0;
}
```

C++17 支持在非类型模板形参用 auto 做占位符,C++11 就要指定

```cpp
// g++-11 -std=c++17 main.cpp -o main
#include <iostream>
#include <string>
using namespace std;

template <int a>
void print()
{
    cout << a << endl;
}

// C++17
template <auto a>
void print2()
{
    cout << "print2 " << a << endl;
}

// C++11
template <typename T, T a>
void print2_1()
{
    cout << "print2_1 " << a << endl;
}

int main(int argc, char **argv)
{
    int num = 999;
    print<2>();    // 2
    print2<1>();   // print2 1
    print2<'1'>(); // print2 1
    // print2<5.0>();
    print2_1<int, 1>(); // print2_1 1
    return 0;
}
```

C++20 更离谱，支持了 auto 形参，在 C++14 中，auto 可以为 lambda 表达式声明形参,在 C++20 中感觉看见了未来的曙光

```cpp
#include <iostream>
using namespace std;

auto sum(auto a1, auto a2)
{
    return a1 + a2;
}

int main(int argc, char **argv)
{
    cout << sum(1, 2.3) << endl; // 3.3 double sum<int, double>(int a1, double a2)
    sum<int, double>(1, 1.2);
    //++，C++还能这样用越来越离谱了
    // 更离谱的
    auto i = new auto(5);   // int *i
    auto *j = new auto(10); // int *j
    delete i;
    delete j;
    return 0;
}
```

### assert 运行时断言

运行时断言只有在程序运行时才能检查被触发，在 Release 版本通常会忽略断言(头文件 cassert 通过宏 NDEBUG 对 Debug 与 Release 做了区分)。assert 会直接显示错误信息并终止程序。

```cpp
#include <iostream>
#include <cassert>
using namespace std;

void func(void *ptr)
{
    assert(ptr);
    cout << ptr << endl;
}

int main(int argc, char **argv)
{
    int p;
    func(&p);
    return 0;
}
```

### static_assert 静态断言

在 C++11 标准之前， 没有一个标准方法来达到这个目的，我们需要利用其他特性来模拟。 下面给出几个可行的方案：

```cpp
#include <iostream>
using namespace std;

#define STATIC_ASSERT_CONCAT_IMP(x, y) x##y
#define STATIC_ASSERT_CONCAT(x, y) STATIC_ASSERT_CONCAT_IMP(x, y)

// 方案1
#define STATIC_ASSERT(expr)                   \
     do                                       \
     {                                        \
          char STATIC_ASSERT_CONCAT(          \
              static_assert_var, __COUNTER__) \
              [(expr) != 0 ? 1 : -1];         \
     } while (0);

int main(int argc, char **argv)
{
     STATIC_ASSERT(1 == 1);
     STATIC_ASSERT(1 * 2 == 3);
     return 0;
}
/*
main.cpp: 在函数‘int main(int, char**)’中:
main.cpp:13:36: 错误：数组‘static_assert_var1’的大小为负
               [(expr) != 0 ? 1 : -1];         \
                                    ^
main.cpp:19:6: 附注：in expansion of macro ‘STATIC_ASSERT’
      STATIC_ASSERT(1 * 2 == 3);
*/
```

其中`STATIC_ASSERT_CONCAT`实现将两个宏拼接, `__COUNTER__` 是 C++预处理器的内置宏，用于生成一个唯一的整数值。每次使用 `__COUNTER__` 时，它会自增一次，确保在同一范围内的不同地方使用时生成不同的值。这样也以来每次使用`STATIC_ASSERT`背后原理其实是

```cpp
do
{
     char static_asser_var_n [(expr) != 0 ? 1 : -1];
}while(0);
```

保证了代码块没作用域封闭，而且当 expr 为假时定义了长度为`-1`的数组，编译时就会报错。`do while`可以使得`STATIC_ASSERT`可以不以`;`结尾。

方案 2 使用模板特化

```cpp
#include <iostream>
using namespace std;

// 模板特化声明
template <bool>
struct static_assert_st;

// 模板偏特化
template <>
struct static_assert_st<true>
{
};

#define STATIC_ASSERT(expr) static_assert_st<(expr) != 0>();

int main(int argc, char **argv)
{
     STATIC_ASSERT(1 == 1)
     return 0;
}

/*
main.cpp:13:59: 错误：对不完全的类型‘struct static_assert_st<false>’的非法使用
 #define STATIC_ASSERT(expr) static_assert_st<(expr) != 0>()
                                                           ^
main.cpp:17:6: 附注：in expansion of macro ‘STATIC_ASSERT’
      STATIC_ASSERT(1 == 2);
      ^
main.cpp:6:8: 错误：‘struct static_assert_st<false>’的声明
 struct static_assert_st;
*/
```

第 3 种可以将上面两种结合起来

```cpp
#define STATIC_ASSERT(expr)         \
    static_assert_st<(expr) != 0>   \
    STATIC_ASSERT_CONCAT(           \
    static_assert_var, __COUNTER__);
```

方案 2 会构造临时对象，这让它无法出现在类和结构体的定义当中。而方案 3 则声明了一个变量，可以出现在结构体和类的定义中，但是它最大的问题是会改变结构体和类的内存布局。

这些方案都是不是完美方案。

静态断言什么时候有需求呢，例如想要在模板实例化的时候对模板参数进行约束。 static_assert 声明是 C++11 标准引入的，用于程序编译阶段评估常量表达式对返回 false 的表达式断言。

1. 处理在编译期间执行，不会有空间或时间上的运行时成本
2. 具有简单的语法
3. 断言失败可以显示丰富的错误诊断信息
4. 可以在命名空间、类、代码块内使用
5. 失败的断言会在编译阶段报错

```cpp
#include <iostream>
#include <type_traits>
using namespace std;

class A
{
};

class B : public A
{
};

class C
{
};

template <class T>
class E
{
     static_assert(std::is_base_of<A, T>::value, "T is not base of A");
};

int main(int argc, char **argv)
{
     // static_assert(argc > 0, "argc>0");
     // 使用错误, argc>0 不是常量表达式

     // E<C> x; // A不是C的基类，触发静态断言
     /*
     main.cpp:20:6: 错误：static assertion failed: T is not base of A
     static_assert(std::is_base_of<A, T>::value, "T is not base of A")
     */

     // 断言通过
     static_assert(sizeof(int) >= 4, "sizeof(int)>=4");

     // 断言通过
     E<B> y;

     return 0;
}
```

### C++17 单参数 static_assert

可以忽略 static_assert 的第二个错误信息参数

```cpp
#include <type_traits>

class A {
};

class B : public A {
};

class C {
};

template<class T>
class E {
  static_assert(std::is_base_of<A, T>::value);
};

int main(int argc, char *argv[])
{
  E<C> x;                         // 使用正确，但由于A不是C的基类，会触发失败断言
  static_assert(sizeof(int) < 4); // 使用正确，但表达式返回false，会触发失败断言
}
```

不过在 GCC 上，即使指定使用 C++11 标准，GCC 依然支持单参数的 static_assert。 MSVC 则不同，要使用单参数的 static_assert 需要指定 C++17 标准。

如果没有 C++17 环境也可以使用宏来解决单参数问题

```cpp
#include <iostream>
#include <type_traits>
using namespace std;

#define LAZY_STATIC_ASSERT(B) static_assert(B, #B)

class A
{
};

class C
{
};

template <class T>
class E
{
     LAZY_STATIC_ASSERT((std::is_base_of<A, T>::value));
};

int main(int argc, char **argv)
{
     LAZY_STATIC_ASSERT(sizeof(int) >= 4);
     // static_assert(sizeof(int) >= 4, "sizeof(int) >= 4")

     E<C> y;

     return 0;
}

/*
main.cpp:5:31: 错误：static assertion failed: (std::is_base_of<A, T>::value)
 #define LAZY_STATIC_ASSERT(B) static_assert(B, #B)
                               ^
main.cpp:22:6: 附注：in expansion of macro ‘LAZY_STATIC_ASSERT’
      LAZY_STATIC_ASSERT((std::is_base_of<A, T>::value));
*/
```

### 什么时候使用 auto

每个人可能对 auto 的理解，以及理解程度不一样，所以在实际多人合作项目中要慎重使用

1、一眼就能看出声明变量的初始化类型时使用 auto

```cpp
#include <iostream>
#include <map>
#include <string>
using namespace std;

std::map<std::string, int> str2int;

int main(int argc, char **argv)
{
    for (auto it = str2int.cbegin(); it != str2int.cend(); ++it)
    {
        // std::map<std::string, int>::const_iterator it
    }
    for (auto &it : str2int)
    {
        // std::pair<const std::string, int> &it
    }
    return 0;
}
```

2、复杂类型，如 lambda 表达式、bind 使用 auto

```cpp
#include <iostream>
#include <functional>
using namespace std;

int sum(int a1, int a2)
{
    cout << "a1 + a2 = " << a1 << "+" << a2 << "=" << a1 + a2 << endl;
    return a1 + a2;
}

int main(int argc, char **argv)
{
    auto func = [](int a1, int a2)
    {
        return a1 + a2;
    };
    function<int(int, int)> func1 = func;
    cout << func1(1, 2) << endl; // 3

    auto b = std::bind(sum, 5, std::placeholders::_1);
    cout << b(1) << endl; // a1 + a2 = 5+1=6
    // 6
    return 0;
}
```

### decltype 类型指示符

C++11 特性、作用为选择并返回操作数的数据类型，decltype 并没有 auto 那样变化多端、auto 与 const 引用 指针配和起来很容易把开发者搞晕，decltype(e) 所推导的类型会同步 e 的 cv 限定符

```cpp
#include <iostream>
using namespace std;

static int num = 999;

int getInt()
{
    return 1;
}

// int sum(int a1, int a2)
auto sum(decltype(num) a1, decltype(a1) a2) -> decltype(num)
{
    cout << a1 << " " << a2 << endl;
    return a1 + a2;
}

int main(int agrc, char **argv)
{
    // 重点：并没有运行函数 而是看函数返回的类型 是在编译阶段完成的
    decltype(getInt()) i = 23; // int i
    cout << i << endl;         // 23

    // decltype不改变原来类型的任何状态包括顶层const而auto则会忽略
    const int b = 32;
    decltype(b) c = b; // const int c = 32
    const int *ptr = &b;
    decltype(ptr) ptr2; // const int *ptr2
    auto &ref = b;
    decltype(ref) ref2 = ref; // const int &ref2
    const int *const ptr3 = &b;
    decltype(ptr3) ptr4 = ptr3; // const int *const ptr4
    // 是什么就是什么

    const int &cj = 11;
    // decltype(cj) k; error ,const int & 必须被初始化

    cout << sum(1, 2) << endl; // 1 2 3
    return 0;
}
```

### decltype 推导规则

decltype(e) e 类型为 T

1、如果 e 是一个未加括号的标识符表达式(结构化绑定除外)或者未加括号的类成员访问，则 decltype(e)判断出的类型是 e 的类型 T,如果并不存在这样的类型，或 e 是一组重载函数，则无法进行推导\
2、如果 e 是一个函数调用或仿函数调用，decltype(e)推断出的类型是其返回值类型\
3、如果 e 是一个类型为 T 的左值，则 decltype(e)是 T&\
4、如果 e 是一个类型为 T 的将忘值，则 decltype(e)是 T&&\
5、除去以上情况，decltype(e)是 T

```cpp
#include <iostream>
using namespace std;

const int &&foo();

struct A
{
    double n;
};

const A *a = new A;

int main(int argc, char **argv)
{
    decltype(foo()) t1 = 1;  // const int &&t1
    decltype(foo) *t2;       // const int &&(*t2)()
    decltype(foo) t3;        // const int &&t3()
    decltype(a) t4;          // const A *t4
    decltype(a->n) t5;       // double t5
    decltype((a->n)) t6 = 0; // const double &t6
    //(a->n) 是带括号 左值 又带const 故推导为const double &t6
    delete a;
    return 0;
}
```

会发现，这些东西很鸡肋，偏偏会增加开发者们的负担，而不是简化了开发，代码可读性也会下降

### decltype 和引用

当 decltype 参数表达式有解引用操作，则类型是引用类型

```cpp
//example43.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int i = 42, *p = &i, &r = i;
    decltype(r + 0) b; // int b ,因为 r+0为int类型
    // decltype(*p) c;    //error int&c 必须被初始化,对指针使用*返回引用
    //*p 是解引用操作、decltype得到的是引用类型
    //因为我们可以*p=232;为p存的地址赋值则*p则相当于引用
    return 0;
}
```

### decltype 和 auto 的重要区别

decltype 得到的类型与其参表达式密切相关

```cpp
//example44.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    //参数表达式加括号则变成了相应引用变量
    int i = 999;
    // decltype((i)) d; int &i必须初始化

    decltype(i) e; // int e

    auto a = i;

    return 0;
}
```

### decltype 简写模板返回值类型

只能说，It's so fucking cool.

```cpp
#include <iostream>
using namespace std;

template <class R, class T1, class T2>
R func1(T1 t1, T2 t2)
{
    return t1 + t2;
}

template <class T1, class T2>
auto func2(T1 t1, T2 t2) -> decltype(t1 + t2)
{
    return t1 + t2;
}

// 但是C++14已经支持自动推导auto返回值类型了
template <class T1, class T2>
auto func3(T1 t1, T2 t2)
{
    return t1 + t2;
}

int main(int argc, char **argv)
{
    cout << func1<int, int, int>(1, 2) << endl; // 3
    cout << func2<int, int>(1, 2) << endl;      // 3
    cout << func3<int, int>(1, 2) << endl;      // 3
    return 0;
}
```

但是用 auto 自动推导还是用 decltype 配置要根据实际场景选择

```cpp
#include <iostream>
#include <type_traits>
using namespace std;
// env1
template <typename T>
auto get_ref1(T &t)
{
    return t;
}
// env2
template <typename T>
auto get_ref2(T &t) -> decltype(t)
{
    return t;
}

int main(int argc, char **argv)
{
    int n = 9;
    static_assert(std::is_reference<decltype(get_ref2(n))>::value, "get_ref2 must return a reference type");
    static_assert(std::is_reference<decltype(get_ref1(n))>::value, "get_ref1 must return a reference type");
    // 编译报错
    //      main.cpp:21:61: error: static assertion failed: get_ref1 must return a reference type
    //     21 |     static_assert(std::is_reference<decltype(get_ref1(n))>::value, "get_ref1 must return a reference type");
    return 0;
}
```

### decltype(auto)

在 C++11 中引入了 auto 关键字，用于在编译时自动推导变量的类型。而在 C++14 中引入了 decltype(auto)，它与 auto 有一些区别,decltype(auto)在 auto 基础上保留引用性与 cv 限定符。

```cpp
#include <iostream>
using namespace std;

template <typename T>
decltype(auto) get_ref(T &t)
{
    return t;
}

int main(int argc, char **argv)
{
    auto n = 43;             // int n
    auto x1 = n;             // int x1
    auto x2 = (n);           // int x2
    decltype(auto) x3 = n;   // int x3
    decltype(auto) x4 = (n); // int &x4
    const int i = 999;
    auto x5 = i;                       // int x5
    decltype(auto) x6 = i;             // const int x6 = 999
    decltype(auto) ref_n = get_ref(n); // int &get_ref<int>(int &t)
    ref_n = 999;
    cout << n << endl; // 999
    return 0;
}
```

### decltype(auto)作非类型模板形参占位符

不同可以跳过哦，当你学完 C++再来看，这个知识点不是给小白看的，而且还是 C++17 中的,下面的用法也太 tm 魔幻了，吐了，让我说就是直接不用，自找麻烦，可能造通用函数库的大神能用到，但是用这些特性写库，确定能有好的兼容性？

```cpp
#include <iostream>
using namespace std;

template <decltype(auto) N>
void fun()
{
    cout << N << endl;
}

static const int x = 11;
static int y = 78;

int main(int argc, char **argv)
{
    fun<x>(); // N为const int
    // fun<y>(); 编译错误 N不能为可变的int 因为y不是一个常量
    fun<(x)>(); // 11 N为const int&
    fun<(y)>(); // 78 N为int&
    static int n = 999;
    fun<(n)>(); // 999
    return 0;
}
// 为什么func<(y)>没问题，(y)被推断为int&,静态对象而言内存地址是固定的，所以能顺利编译，最终N被推导为int&
```

经过复合类型、const、auto、decltype 肯定有曾经充满自信的小伙子要弃坑了，心里想 C++怎么这么多花里胡哨的东西，如果用过其他的语言比如 javascript、python 等动态语言或者 java 会发现它们是调 api 玩的花里胡哨，而 c++是基础语法本身乱如麻，总之这些东西非常有难度，而且有些写法我们平时用不到以至于我们忘记他，但是可能将来工作面试就要知道，然后我们去看什么八股文去了，所以平时我们还是要把基础打好，一步一个脚印，把这些难点用好就超过了很多的开发者。

### 自定义数据结构

struct 结构体允许我们构建复杂的数据结构

### 定义与使用自定义的类型

```cpp
//example45.cpp
#include <iostream>
using namespace std;
struct Person
{
    std::string name{"null"};
    unsigned age;
    double weight{0.};
} me, he; // 自定义类型时，同时定义变量

int main(int argc, char **argv)
{
    cout << me.name << endl;   // null
    cout << he.weight << endl; // 0
    Person you;
    you.name = "gaowanlu";
    you.age = 19;
    // name gaowanlu age 19
    cout << "name " << you.name << " age " << you.age << endl;
    return 0;
}
```

结构体变量直接 变量名.属性名 对其各种操作与普通变量相同、运算以及判断、赋值等等。

### 编写自己的头文件

```cpp
//example46.h
#ifndef __EXAMPLE46_H__
#define __EXAMPLE46_H__
#include <string>
struct Person
{
    std::string name = "null";
    unsigned age;
    double weight = 0.;
} me, he; //自定义类型时，同时定义变量
#endif
```

头文件里的#ifndef #define #endif 什么作用呢?

当源程序文件 include 一个头文件时，会将头文件整体替换掉#include"./example46.h" 但是我们知道一个程序可以有多个源文件，但是我们多次 include 那个头文件怎么办，那不就多次重复定义了吗，#ifndef 检测如果没有被 define 过则将#ifndef 至#endif 中间的代码生效，否则则直接跳过#ifndef 至#endif 的内容

```cpp
//example46.cpp
#include <iostream>
#include "./example46.h"
#include "./example46.h" //多次include,在同一个cpp内只引入了一次
using namespace std;
int main(int argc, char **argv)
{
    cout << me.name << endl; // null
    Person you;
    you.name = "all night";
    cout << you.name << endl; // all night
    return 0;
}
```

### 写程序的正确姿势

```cpp
//example47.h
#ifndef __EXAMPLE47_H__
#define __EXAMPLE47_H__
#include <string>
struct Person
{
    std::string name = "null";
    unsigned age;
    double weight = 0.;
};
void printPerson(Person person);
const int i = 0;
const std::string auth = "gaowanlu";//const变量仅在源文件内有效
#endif
```

```cpp
//example47.cpp
#include "./example47.h"
#include <iostream>
using namespace std;
void printPerson(Person person)
{
    cout << i << endl;    // 0
    cout << auth << endl; // gaowanlu
    cout << " name " << person.name << " age " << person.age << " weight " << person.weight << endl;
}
```

```cpp
//example48.cpp
#include <iostream>
#include "./example47.h"
using namespace std;
int main(int argc, char **argv)
{
    Person person;
    printPerson(person); // name null age 4199120 weight 0
    cout << i << endl;
    cout << auth << endl;
    return 0;
}
```

使用 g++构建程序

```bash
g++ example47.cpp example48.cpp -o main
./main
```

头文件到底干嘛用的，在编译器编译多源程序文件程序时，它们会一个一个单独进行编译，最后编译器对其一个个编译生成的中间代码,最后连接到一块形成一个可执行文件

> 注：当我们在一个头文件内定义一个变量，然后被 include 到多个 cpp 内，编译时则会报错提示我们定义冲突，多次重复定义？。为什么呢，在编译时多个 cp 被单独编译，则它们每个 cpp 都有了一个自己的变量（全局），则将他们连接时，编译器遇到多个名字一样的全局变量，则不知道用哪一个。总之，如果一个头文件定义了全局变量，且被多个 cpp include，那么则会定义冲突,但是如果那个变量是不可变的，则不会冲突。

头文件干嘛用的，就是写声明的,要定义全局变量就定义常量。

### pragma once

`#pragma once` 是一个预处理指令，用于在 C++ 中确保头文件只被编译一次。它是一种非标准的、编译器特定的指令，但被广泛支持，并且成为了常用的头文件保护机制。

使用 `#pragma once` 的好处包括：

简洁性：相对于传统的头文件保护方式（使用条件编译指令，如 `#ifndef`、`#define`、`#endif`），`#pragma once` 更加简洁和清晰。只需在头文件的开头加上一行 `#pragma once`，就能确保该头文件只被编译一次。

可读性：`#pragma once` 的语义清晰明确，易于阅读和理解。它表达了对头文件的唯一性要求，避免了头文件重复包含可能引发的问题。

性能：由于 `#pragma once` 在编译器级别执行头文件的唯一性检查，省去了条件编译的开销。这可以提高编译速度，尤其对于大型项目和包含多个头文件的源文件来说。

需要注意的是，尽管 `#pragma once` 在大多数主流编译器上都能正常工作，但它并非 C++ 标准的一部分，因此并不保证在所有编译器和平台上都被支持。为了确保最大的可移植性，有些项目仍然使用传统的条件编译方式。

总之，`#pragma once` 是一种方便且常用的头文件保护方式，它能确保头文件只被编译一次，提高编译速度并简化头文件管理。在大多数情况下，使用 `#pragma once` 是一个不错的选择。
