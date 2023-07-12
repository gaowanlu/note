---
cover: >-
  https://images.unsplash.com/photo-1653212373184-0acac93dbb3e?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTQzOTAwOTE&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🥳 第 10 章 泛型算法

## 第 10 章 泛型算法

标准库为我们提供了容器，同时为开发者提供了许多算法，这些算法中大多数都独立于任何特定的容器，也就是说这些算法是通用的(generic,或者称为泛型的)：它们可用于不同类型的容器和不同类型的元素，本章主要学习泛型算法与对迭代器更加深入的讨论

### 概述

大多数算法在头文件`algorithm`，`numeric`中定义了一组数值泛型算法\
下面简单使用 find 算法

```cpp
//example1.cpp
vector<int> vec = {1, 2, 3, 4, 5};
auto target = find(vec.begin(), vec.end(), 3);
if (target != vec.cend())
{
    cout << "finded " << *target << endl; // finded 3
}

//泛型算法是一种通用算法
string str = "abcde";
auto ch = find(begin(str), end(str), 'c');
if (ch != str.cend())
{
    cout << "fined " << *ch << endl; // fined c
}
```

可见迭代器令算法不依赖于容器、不同的容器可以使用相同的算法\
算法依赖于元素类型的操作，如 find 就依赖于元素类型间的==操作，其他算法可依赖>、<等等

关键概念：算法永远不会执行容器的操作，因为这样就会对特定容器产生依赖，不是真正的泛型算法，它们只会运行在迭代器上

### 初识泛型算法

标准库提供了超过 100 个算法，虽然很多但它们大部分有类似的接口

### 只读算法

只读算法就是像 find 一样，使用算法时只读取数据而不进行修改数据的操作

### accumulate 求和

其在声明在 numeric 头文件内

```cpp
//example2.cpp
vector<int> vec = {1, 2, 3, 4, 5};
int sum = accumulate(vec.begin(), vec.end(), 0);//求和初始值为0
cout << sum << endl; // 15
```

accumulate 算法和元素类型,因为 string 之间定义了`+`运算

```cpp
//example2.cpp
vector<string> vec1 = {"hello", "ni"};
string str = accumulate(vec1.begin(), vec1.end(), string(""));
cout << str << endl; // helloni
```

### equal 比较

确定两个序列中是否保存着相同的值,返回布尔类型值

```cpp
//example3.cpp
vector<int> seq1 = {1, 2, 3, 4, 5};
list<int> seq2 = {1, 2, 3, 4, 5};
vector<int> seq3 = {2, 3, 4, 5, 6};
// 1
cout << equal(seq1.begin(), seq1.end(), seq2.begin(), seq2.end()) << endl;
// 0
cout << equal(seq2.begin(), seq2.end(), seq3.begin(), seq3.end()) << endl;
```

### 写容器元素的算法

将新值赋予序列中的元素，使用这类算法要注意各种迭代器范围以及长度大小不能超过容器原大小

### fill 赋值

fill(begin,end,value) \[begin,end) 赋值为 value

```cpp
//example4.cpp
vector<int> vec(10, 999);
printVec(vec); // 999 999 999 999 999 999 999 999 999 999
fill(vec.begin(), vec.end(), 8);
printVec(vec); // 8 8 8 8 8 8 8 8 8 8
fill(vec.begin() + vec.size() / 2, vec.end(), 666);
printVec(vec);
// 8 8 8 8 8 666 666 666 666 666
```

### fill_n 赋值

fill(begin,n,value) 从 begin 开始 n 个位置赋值为 value

```cpp
//example5.cpp
vector<int> vec1 = {1, 2, 3, 4, 5};
fill_n(vec1.begin() + 1, 4, 666);
printVec(vec1); // 1 666 666 666 666
```

### back_inserter

back_inserter 是定义在头文件 iterator 中的一个函数，插入迭代器是一种向容器中添加元素的迭代器，通常情况下通过迭代器向元素赋值时，值被赋予迭代器指向的元素

```cpp
//example6.cpp
vector<int> vec = {1, 2, 3};
std::back_insert_iterator<std::vector<int>> iter = back_inserter(vec);
*iter = 4;
printVec(vec); // 1 2 3 4
*iter = 5;
printVec(vec); // 1 2 3 4 5
//配和fill_n
fill_n(iter, 3, 666);
printVec(vec); // 1 2 3 4 5 666 666 666
```

### 拷贝算法

主要有 copy、replace、replace_copy 等

### copy

```cpp
//example7.cpp
void print(int (&vec)[7])
{
    auto iter = begin(vec);
    while (iter != end(vec))
    {
        cout << *iter << " "; // 0 1 2 3 4 5
        iter++;
    }
    cout << endl;
}
int main(int argc, char **argv)
{
    int a1[] = {0, 1, 2, 3, 4, 5};
    int a2[sizeof(a1) / sizeof(*a1) + 1];
    int *ret = copy(begin(a1), end(a1), a2);
    // ret指向拷贝到a2的尾元素之后的位置
    *ret = 999;
    print(a2); // 0 1 2 3 4 5 999
    return 0;
}
```

### replace

将指定范围内的为目标元素的值进行替换

```cpp
//example7.cpp
print(a2); // 0 1 2 3 4 5 999
//将[begin,end)内为值3的元素替换为333
replace(begin(a2), end(a2), 3, 333);
print(a2); // 0 1 2 333 4 5 999
```

### replace_copy

replace_copy 为也是 replace，只不过不再原序列内修改，而是修改后添加到新的序列中

```cpp
//example8.cpp
vector<int> vec1 = {};
vector<int> vec2 = {3, 4, 5, 4, 5, 3, 2};
// replace到vec1序列中
replace_copy(vec2.cbegin(), vec2.cend(), back_inserter(vec1), 4, 444);
for (auto &item : vec1)
{
    cout << item << " "; // 3 444 5 444 5 3 2
}
cout << endl;
```

此时 vec2 并没有被改变，vec1 包含 vec2 的一份拷贝，然后进行了 replace

### 重排容器元素的算法

最常用的就是 sort 进行对数字序列进行排序

### sort 与 unique

用于消除重复项

```cpp
//example9.cpp
vector<int> vec = {1, 2, 3, 4, 1, 2, 3, 4};
//排序
sort(vec.begin(), vec.end());
printVec(vec); // 1 1 2 2 3 3 4 4
//使用unique重新排列返回夫重复序列的下一个位置
auto end_unique = unique(vec.begin(), vec.end());
auto iter = vec.begin();
while (iter != end_unique)
{
    cout << *iter << " "; // 1 2 3 4
    iter++;
}
cout << endl;
//使用erase删除重复项
vec.erase(end_unique, vec.end());
printVec(vec); // 1 2 3 4
```

### 定制操作

如果有学过 java 或者 javascript，都知道 java 有一种定义接口对其实现内部类或者使用 lambda 表达式，javascript 则是传递函数或者使用箭头函数，比如它们中的 sort 都提供了函数传递的机制，在 C++中也是有这种功能的

### sort 自定义比较函数

```cpp
//example10.cpp
//将s1想象为前面的元素s2为后面的，像排序后满足怎样的性质，就return什么
//此处为后面的长度大于前面的长度
bool shortCompare(const string &s1, const string &s2)
{
    return s1.length() < s2.length();
}

int main(int argc, char **argv)
{
    vector<string> vec = {"dscss", "aaaaaa", "ll"};
    printVec(vec); // dscss aaaaaa ll
    sort(vec.begin(), vec.end(), shortCompare);
    printVec(vec); // ll dscss aaaaaa
    return 0;
}
```

### stable_sort 稳定排序算法

不知道排序算法的稳定性？好好去学下数据结构吧！

```cpp
//example10.cpp
//stable_sort
vec = {"dscss", "aaaaaa", "ll"};
printVec(vec); // dscss aaaaaa ll
stable_sort(vec.begin(), vec.end(), shortCompare);
printVec(vec); // ll dscss aaaaaa
```

### lambda 表达式

形式 `[capture list](parameter list) specifiers exception->return type{function body}`

- capture list,捕获列表可以捕获当前函数作用域的零个或多个变量，变量之间用逗号分隔。
- parameter list，可选参数列表
- specifiers,可选限定符，C++11 中可以用 mytable,允许 lambda 表达式函数体内改变按值捕获的变量，或者调用非 const 的成员函数。
- exception，可选异常说明符，可以用 noexcept 指明 lambda 是否会抛出异常
- return type，返回值类型
- function body，函数体

```cpp
//example11.cpp
auto f1 = []() -> int{ return 42; };
auto f2 = []{ return 42; };
cout << f1() << endl; // 42
cout << f2() << endl; // 42
```

### 向 lambda 传递参数

```cpp
//example12.cpp
vector<string> vec = {"sdcs", "nvfkdl", "acndf"};
printVec(vec); // sdcs nvfkdl acndf
sort(vec.begin(), vec.end(), [](const string &s1, const string &s2) -> bool
     { return s1.length() < s2.length(); });
printVec(vec); // sdcs acndf nvfkdl
```

### 使用捕获列表

在 javascript 中因为有 this 的指向，在箭头函数内部可以使用定义它时外部的作用域的变量，C++也能实现功能，就是使用捕获列表。

捕获列表的变量必须是一个自动存储类型，Lambda 表达式中的捕获列表只能捕获局部变量，而不能捕获全局变量或静态变量。

```cpp
//example13.cpp
int count = 0, sum = 1, k = 100;
auto f = [count, sum]()
{
    cout << count << " " << sum << endl;
    // count = 3;//error count readonly
    // cout << k << endl; // error: 'k' is not captured
};
f(); // 0 1
count++;
f(); // 0 1 可见捕获列表只是只拷贝
```

在 lambda 中使用全局变量与静态变量

```cpp
#include <iostream>
using namespace std;

int x = 0;
static int j = 0;

int main(int argc, char **argv)
{
    int y = 0;
    static int z = 0;
    auto fun = [x, y, z, j] {};
    // x z j都无法捕获
    return 0;
}
//============修改后===========
#include <iostream>
using namespace std;

int x = 0;
static int j = 0;

int main(int argc, char **argv)
{
    int y = 0;
    static int z = 0;
    auto fun = [y]() -> int
    {
        return x * y * z * j;
    };
    return 0;
}
```

### find_if

查找第一个满足条件的元素

```cpp
//example14.cpp
vector<int> vec = {1, 2, 3, 7, 5, 6};
auto target = find_if(vec.begin(), vec.end(), [](const int &item) -> bool
                      { return item >= 6; });
if (target != vec.end()) //找到了满足要求的元素的位置的迭代器
{
    cout << *target << endl; // 7
}
```

### for_each 算法

遍历算法

```cpp
//example15.cpp
vector<int> vec = {1, 2, 3, 4, 5, 6};
for_each(vec.begin(), vec.end(), [](int &item) -> void
         { cout << item << " ";item++; });
cout << endl; // 1 2 3 4 5 6

for_each(vec.begin(), vec.end(), [](int &item) -> void
         { cout << item << " "; });
cout << endl; // 2 3 4 5 6 7
```

### lambda 捕获和返回

捕获分为值捕获与引用捕获

![lambda捕获列表](<../.gitbook/assets/屏幕截图 2022-06-06 095133.jpg>)

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    int count = 0;
    // 值捕获 也就是值拷贝到捕获列表的变量
    auto f1 = [count]()
    {
        cout << count << endl;
        // count = 999; readonly
    };
    // 引用捕获
    auto f2 = [&count]() -> void
    {
        cout << count << endl;
        count++;
    };
    count = 99;
    f1(); // 0
    // 可见值捕获的count在lambda定义后，哪怕外部修改了变量值，也不会影响到lambda捕获到的
    // 定义即捕获，捕获即确定
    count = 100;
    f2();                  // 100
    cout << count << endl; // 101
    // 编译器自动推断 都使用引用型
    auto f3 = [&]() -> void
    {
        count = 666;
    };
    f3();
    cout << count << endl; // 666
    return 0;
}
```

但是最新捕获列表还支持

- [this],捕获 this 指针，可以使用 this 类型的成员变量和函数
- [=]，捕获 lambda 表达式定义作用域的全部变量的值，包括 this
- [&]，捕获 lambda 表达式作用域的全部变量的引用，包括 this

```cpp
#include <iostream>
using namespace std;

class X
{
public:
    X() : x(0) {}
    void print()
    {
        cout << "class X.x=" << x << endl;
    }
    void test_this()
    {
        auto fun = [this]
        {
            this->print();
            x = 5;
            print();
        };
        fun();
    }

    void test_val()
    {
        auto fun = [=]
        {
            this->print();
            x = 6;
            print();
        };
        fun();
    }

    void test_ref()
    {
        auto fun = [&]
        {
            this->print();
            x = 7;
            print();
        };
        fun();
    }

private:
    int x;
};

int main(int argc, char **argv)
{
    X x;
    x.test_this();
    x.test_val();
    x.test_ref();
    return 0;
}
/*
class X.x=0
class X.x=5
class X.x=5
class X.x=6
class X.x=6
class X.x=7
*/
```

### mutable 可变 lambda

刚才我们发现在 lambda 表达式函数体内部不能修改值捕获的变量的值，使用 mutable 使得值捕获的值可以改变

```cpp
//example17.cpp
int i, j, k;
i = j = k = 0;
auto f1 = [i, j, k]() mutable -> void
{
    i = j = k = 999;
    cout << i << " " << j << " " << k << endl; // 999 999 999
};
f1();
cout << i << " " << j << " " << k << endl; // 0 0 0
```

### lambda 的实现原理

C++的 lambda 表达式和仿函数非常像

```cpp
#include <iostream>
using namespace std;

class X
{
public:
    X(int x, int y) : x(x), y(y)
    {
    }
    int operator()()
    {
        return x * y;
    }

private:
    int x, y;
};

int main(int argc, char **argv)
{
    int x = 1, y = 2;
    X func(x, y);
    cout << func() << endl; // 2
    auto m_lambda = [=]() -> int
    {
        return x * y;
    };
    cout << m_lambda() << endl; // 2
    return 0;
}
```

m_lambda 是一个 lambda 表达式，func 为一个函数对象，二者都可以在初始化的时候获取 main 函数中变量 x，y 的值，并在调用之后返回相同结果。二者明显不同之处有。

- lambda 不需要显式定义类
- 函数对象可以在初始化时有更丰富的操作，如使用计算表达式，而 lambda 不行，在 func 函数对象初始化时，使用全局、静态局部变量都没问题

重点：lambda 表达式在编译时会自动生成一个闭包类，在运行时由这个闭包类产生一个对象，称为闭包。C++中的闭包可以理解为一个匿名且可以包含定义时作用域上下文的函数对象。lambda 表达式是 C++11 的语法糖，lambda 表达式的功能完全可以手动实现。

### 无状态 lambda 表达式

在 C++中，无状态(lambda)表达式是一种特殊类型的 lambda 表达式，它不捕获任何外部变量。它仅依赖于其参数列表中的参数，并且在执行时不依赖于任何额外的上下文。因此，它被称为"无状态"，因为它不存储或访问任何状态信息。

`无状态 lambda 表达式可以隐式转换为函数指针`，如

```cpp
#include <iostream>
using namespace std;

void func(void (*ptr)())
{
    ptr();
}

int main(int argc, char **argv)
{
    func([]
         { cout << "hello world" << endl; });
    // hello world
    return 0;
}
```

### lambda 广义捕获

C++14 及以上版本支持，支持在捕获列表中自定义新的变量

```bash
g++ main.cpp -o main -std=c++17
```

```cpp
#include <iostream>
#include <string>
using namespace std;

class X
{
public:
    int x{1};
    int y{2};

public:
    void func1()
    {
        //*this并不是广义捕获
        auto lambda = [*this]() mutable
        {
            cout << x << endl;
            cout << y << endl;
            x++;
            y++; // 副本
        };
        lambda();
        cout << x << " " << y << endl;
    }
    void func2()
    {
        //&包含捕获this
        auto lambda = [&]() mutable
        {
            cout << this->x << endl;
            cout << this->y << endl;
            this->x = 666;
            this->y = 666; // 引用
        };
        lambda();
        cout << x << " " << y << endl;
    }
};

int main(int argc, char **argv)
{
    int x = 42;
    // 广义捕获
    // 通过复制或移动语义捕获外部变量
    auto lambda1 = [x = x + 1]()
    {
        cout << x << endl;
    };
    lambda1();         // 43
    cout << x << endl; // 42
    string str = "hello world";
    auto lambda2 = [str = std::move(str)]
    {
        cout << str << endl;
    };
    lambda2();                  // hello world
    cout << str.size() << endl; // 0
    // 在成员函数的lambda中可以使用*this捕获当前对象的引用
    X xobj;
    xobj.func1(); // 1 2 1 2
    xobj.func2(); // 1 2 666 666
    return 0;
}
```

### 泛型 lambda 表达式

C++14 支持让 lambda 表达式具备模板函数的能力，称为泛型 lambda 表达式

auto 型

```cpp
#include <iostream>
#include <string>
using namespace std;

int main(int argc, char **argv)
{
    auto m_lambda = [](auto obj)
    {
        return obj;
    };
    int n = m_lambda(1);
    string str = "hello world";
    string str_cpy = m_lambda(str);
    cout << n << " " << str_cpy << endl;
    return 0;
}
// 1 hello world
```

模板语法型 lambda 表达式 C++20

```cpp
#include <iostream>
#include <vector>
using namespace std;

int main(int argc, char **argv)
{
    auto f = []<typename T>(T t1, T t2)
    {
        T t3 = t1 + t2;
        return t3;
    };
    cout << f(1, 2) << endl; // 3
    cout << f(5, 6) << endl; // 11
    return 0;
}
```

### 可构造可赋值的无状态 lambda

C++20 引入了可构造可赋值的无状态 lambda（Constructible and Assignable Stateless Lambdas），这意味着我们可以声明和定义一个无状态的 lambda，并将其赋值给变量或将其作为函数参数传递，以便在代码中进行重复使用。

在 C++20 之前，lambda 表达式默认是不可构造和不可赋值的，因为它们的类型是匿名的，并且没有默认构造函数或赋值运算符。但是在 C++20 中，如果 lambda 表达式没有捕获任何变量（即无状态），则它可以被构造和赋值。

需要注意的是，如果 lambda 捕获了任何变量，它将不再是无状态的，因此不满足可构造和可赋值的条件。

```cpp
#include <iostream>
using namespace std;

template <typename T>
auto func(T lambda) -> void
{
    lambda();
}

int main(int argc, char **argv)
{
    auto lambda = []()
    {
        cout << "hello world" << endl;
    };
    lambda(); // hello world
    decltype(lambda) lambda_ref = lambda;
    auto lambda_ref1 = lambda;
    lambda_ref();  // hello world
    lambda_ref1(); // hello world
    auto lambda1 = [lambda]()
    {
        lambda();
    };
    lambda1(); // hello world
    decltype(lambda1) lambda1_ref = lambda1;
    lambda1_ref(); // hello world
    int a = 666;
    auto lambda2 = [&a]()
    {
        cout << a << endl;
    };
    func(lambda2); // 666
    return 0;
}
//有状态怎么也可以构造和赋值，不知道阿
/*Chatgpt
有状态的lambda表达式之所以可以构造和赋值，
是因为使用了auto关键字和自动类型推导。
auto关键字可以根据右侧表达式的类型进行类型推导，
并创建相应的lambda表达式副本。
这使得我们可以在代码中使用auto声明和赋值有状态的lambda表达式，
而不需要显式指定其类型。
*/
```

### transform

将所在位置修改为 lambda 表达式返回的内容

前两个参数为遍历的范围，第三个参数为将 transform 后的值从哪里开始存储

```cpp
#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;

void printVec(const vector<int> &vec)
{
    for (auto &item : vec)
    {
        cout << item << " ";
    }
    cout << endl;
}

int main(int argc, char **argv)
{
    vector<int> vec{1, 2, 3, 4, 5};
    transform(vec.begin(), vec.end(), vec.begin(),
              [](int item) -> int
              {
                  if (item >= 4)
                  {
                      return 666;
                  }
                  return item;
              });
    printVec(vec); // 1 2 3 666 666
    return 0;
}
```

### count_if

统计满足条件的元素个数

```cpp
//example18.cpp
printVec(vec); // 1 2 3 666 666
// count_if
int sum = count_if(vec.begin(), vec.end(), [](int &item) -> bool
                   { return item >= 666; });
cout << sum << endl; // 2
```

### lambda 参数绑定

对于 lambda 表达式，如果一个 lammbda 的捕获列表为空，且经常使用，如 sort 算法提供的比较函数，这事往往提供函数比提供 lambda 表达式开发起来更为方便

### 标准库 bind 函数

bind 函数接受一个可调用对象，返回一个新的可调用对象\
`newCallable=bind(callable,arg_list)`callable 为可调用对象，arg_list 是逗号分隔的参数列表，当调用 newCallable 时，newCallable 会调用 callable

```cpp
//example19.cpp
int big(const int &a, const int &b)
{
    return a > b ? a : b;
}

int main(int argc, char **argv)
{
    int a = 1, b = 2;
    auto big_func = bind(big, a, b);
    cout << big_func() << endl; // 2
    return 0;
}
```

### std::placeholders::\_n

用于 bind 传递参数列表时，保留与跳过特定的参数

```cpp
//example20.cpp
bool check(string &str, string::size_type size)
{
    return str.size() >= size;
}

int main(int argc, char **argv)
{
    vector<string> vec = {"vd", "fdvd", "vfdvgfbf", "fvddv"};
    auto iter = find_if(vec.begin(), vec.end(), bind(check, placeholders::_1, 6));
    // bind返回一个以string&str为参数且返回bool类型的可执行对象，且调用check时传递给size的实参为6
    cout << *iter << endl; // vfdvgfbf
    return 0;
}
```

### bind 参数列表顺序

总之 bind 的参数列表参数是与 callable 参数一一对应的，且用 placeholders 使用 newCallable 的形参参数作为其调用 callable 时的实参

```cpp
//example21.cpp
void func(int a, int b, int c, int d)
{
    cout << "a " << a << endl;
    cout << "b " << b << endl;
    cout << "c " << c << endl;
    cout << "d " << d << endl;
}

int main(int argc, char **argv)
{
    int a = 1, b = 2;
    auto func1 = bind(func, a, placeholders::_1, b, placeholders::_2);
    // a1 b3 c2 d4
    func1(3, 4); // func(1,_1,2,_2) 即 func(1,3,2,4)
    //调换placeholders
    auto func2 = bind(func, a, placeholders::_2, b, placeholders::_1);
    func2(3, 4); // a1 b4 c2 d3
    return 0;
}
```

### bind 引用参数

其实就是在 bind 中使用引用捕获，默认 bind 参数列表的值绑定是拷贝而不是引用，要实现引用参数的绑定则要使用`ref函数`,如果并不改变其值，可以使用`cref函数`绑定 const 类型的引用\
如果 bind 的 callable 的参数有引用变量参数，bind 的参数列表是不能直接进行绑定的

```cpp
//example22.cpp
void func(int &a, int &b, int &c, int &d)
{
    cout << "a " << a << endl;
    cout << "b " << b << endl;
    cout << "c " << c << endl;
    cout << "d " << d << endl;
}

int main(int argc, char **argv)
{
    int a = 1, b = 2, c = 3, d = 4;
    auto func1 = bind(func, a, placeholders::_1, b, placeholders::_2);
    func1(c, d);
    a = 666, b = 666;
    func1(c, d); //并不会输出666
    //为什么因为其使用了拷贝，而不是绑定引用
    auto func2 = bind(func, ref(a), placeholders::_1, ref(b), placeholders::_2);
    a = 777, b = 777;
    func2(c, d); //可以使用实时的a与b的值
    return 0;
}
```

### 再探迭代器

除了我们知道的容器迭代器之外，还有几个特殊的迭代器

- `插入迭代器(insert iterator)`:这些迭代器被绑定到一个容器上，可用来向容器插入元素
- `流迭代器(stream iterator)`:被绑定在输入或输出流上，可用来遍历所关联的 IO 流
- `反向迭代器(reverse iterator)`:这些迭代器向后而不是向前移动，除了 forward_list 之外的标准容器都有反向迭代器
- `移动迭代器(move iterator)`:这些专用的迭代器不是拷贝其中的元素，而是移动它们

### 插入迭代器 back_inserter、front_inserter、inserter

![插入迭代器操作](<../.gitbook/assets/屏幕截图 2022-06-08 110947.jpg>)

插入迭代器有三种

- back_inserter 创建一个 push_back 的迭代器
- front_inserter 创建一个使用 push_front 的迭代器
- inserter 创建一个使用 insert 的迭代器，函数接收第二个参数是容器元素的迭代器，元素将会被插入到给定迭代器前面

```cpp
//example23.cpp
vector<int> vec = {1, 2, 3};
// back_inserter
auto back = back_inserter(vec);
*back = 4;
printVec(vec); // 1 2 3 4
list<int> m_list = {1, 2, 3};
// front_inserter
auto front = front_inserter(m_list); // vector没有push_front操作
*front = 0;
printVec(m_list); // 0 1 2 3
// insert
auto inser = inserter(m_list, m_list.end());
*inser = 4;
printVec(m_list); // 0 1 2 3 4
```

泛型算法与迭代器的配和

```cpp
//example24.cpp
//泛型算法与迭代器配和
vector<int> vec1;
copy(vec.begin(), vec.end(), back_inserter(vec1));
printVec(vec1); // 1 2 3 4

list<int> m_list1;
copy(vec.begin(), vec.end(), front_inserter(m_list1));
printVec(m_list1); // 4 3 2 1
```

### iostream 迭代器

iostream 虽然不是容器，但标准库定义了相关迭代器，istream_iterator 读取输入流、ostream_iterator 像一个输出流写数据

### istream_iterator 操作

![istream_iterator操作](<../.gitbook/assets/屏幕截图 2022-06-08 114104.jpg>)

```cpp
//example24.cpp
istream_iterator<int> int_iter(cin);
istream_iterator<int> eof;
vector<int> vec;
while (int_iter != eof)
{
    vec.push_back(*int_iter);
    int_iter++;
}
printVec(vec);
// input 1 2 3 4 5 g
// output 1 2 3 4 5
return 0;
```

使用迭代器范围初始化 vector 以及利用迭代器范围使用泛型算法

```cpp
//example26.cpp
istream_iterator<int> eof;
istream_iterator<int> int_iter1(cin);
int sum = accumulate(int_iter1, eof, 0);
cout << sum << endl;
// input 1 2 3 4 5 g
// output 15
```

### ostream_iterator 操作

![ostream_iterator操作](<../.gitbook/assets/屏幕截图 2022-06-08 131557.jpg>)

```cpp
//example27.cpp
ostream_iterator<string> out(cout);
out = "hello1";
out = "hello2";
out = "hello3";
out = "hello4"; // hello1hello2hello3hello4
cout << endl;
ostream_iterator<int> out1(cout, "\n");
out1 = 1; // 1\n
out1 = 2; // 2\n

vector<int> vec = {1, 2, 3, 4};
copy(vec.begin(), vec.end(), out1); // 1\n2\n3\n4
```

### 反向迭代器

反向迭代器就是++移动到上一个元素，--移动到下一个元素，除了 forward_list 之外，其他的容器都支持反向迭代器，可以通过调用 rbegin、rend、crbegin、crend 成员函数获得反向迭代器

![比较cbegin、cend、crbegin、crend](<../.gitbook/assets/屏幕截图 2022-06-09 080145.jpg>)

### rbegin、rend、cbegin、crend

```cpp
//example28.cpp
vector<int> vec = {1, 2, 3, 4, 5};
//倒序遍历
auto iter = vec.rbegin();
while (iter != vec.crend())
{
    cout << *iter << " ";
    iter++;
}
cout << endl;
//正序遍历
iter = vec.rend();
while (true)
{
    iter--;
    cout << *iter << " "; // 1 2 3 4 5
    if (iter == vec.crbegin())
    {
        break;
    }
}
cout << endl;
```

### reverse_iterator.base 获取普通迭代器

![反向迭代器和普通迭代器间的关系](<../.gitbook/assets/屏幕截图 2022-06-09 082211.jpg>)

重点：关键点在于`[str.crbegin(),rcomma)`的范围与`[rcomma.base(),str.cend())`的范围相同，所以.base()是返回反向迭代器的下一个位置的普通迭代器

看一个有趣的例子

```cpp
//example29.cpp
string str = "hi,hello,world";
auto iter = find(str.cbegin(), str.cend(), ',');
if (iter != str.end())
{
    cout << string(str.cbegin(), iter) << endl; // hi
}
//如果找最后一个单词呢
std::string::const_reverse_iterator target = find(str.crbegin(), str.crend(), ',');
if (target != str.crend())
{
    cout << *target << endl;                       //,
    cout << *target.base() << endl;                // w
    cout << string(str.crbegin(), target) << endl; // dlrow
    //调用reverse_iterator.base()获得普通迭代器
    cout << string(target.base(), str.cend()) << endl; // world
}
```

### 迭代器类别

![迭代器类别](<../.gitbook/assets/屏幕截图 2022-06-10 095931.jpg>)

与容器类似，一些操作所有迭代器都支持，另外一些只有特定类别的迭代器才支持，如 ostream_iterator 只支持递增、解引用、赋值，vector、string、deque 的迭代器另外还支持递减、关系、算数运算

### 输入迭代器(input iterator)

用于读取序列中的元素，输入迭代器必须支持

1、用于比较两个迭代器是否相等和不相等(==、!=)\
2、用于推进迭代器的前置和后置递增运算(++)\
3、用于读取元素的解引用运算符(\*)，解引用只会出现在赋值运算符的右侧\
4、箭头运算符，->,等价于(\*iter).member

输入迭代器只能用于单遍扫描算法，算法 find 和 accumulate 要求输入迭代器，而 istream_iterator 是一种输入迭代器

### 输出迭代器(output iterator)

输入迭代器的补集，只写不读

1、用于推进迭代器的前置和后置递增运算(++)\
2、解引用运算符(\*),只出现在赋值运算符的左侧(也就是只能读取元素，不能写)

输出迭代器只能用于单遍扫描算法，例如 copy 函数的第三个参数就是输出迭代器，ostream_iterator 类型也是输出迭代器

### 前向迭代器(forward iterator)

可以读写元素，只能沿序列一个方向移动，支持所有输入和输出迭代器操作，可以多次读写同一个元素，算法 replace 要求前向迭代器，forward_list 上的迭代器是前向迭代器

### 双向迭代器(bidirectional iterator)

可以正向/反向读写序列元素，支持所有前向迭代器之外，还支持递减运算符(--),算法 reverse 要求双向迭代器，除 forward_list 之外，能提供双向迭代器

### 随机访问迭代器(random-access iterator)

1、用于比较两个迭代器相对位置的关系运算符(<、<=、>和>=)\
2、迭代器和一个整数值的加减运算(+、+=、-、-=)，计算结果是迭代器在序列中前进或后退给定整数个元素的位置\
3、用于两个迭代器上的减法运算符(-),得到两个迭代器的距离\
4、下标运算符(iter\[n]),与\*(iter\[n])等价

算法 sort 要求随机访问迭代器，array、deque、string、vector 的迭代器都是随机访问迭代器，用于访问内置数组元素的指针也是

### 算法形参模式

```cpp
alg(beg,end,other,args);
alg(beg,end,dest,other,args);
alg(beg,end,beg2,other,args);
alg(beg,end,beg2,end2,other,args);
```

`alg`是算法的名字，`end`表示算法所操作的输入范围，`dest`、`beg2`、`end2`,都是迭代器参数，如果需要则承担指定目的位置和第二个范围的角色

### 接收单个目标迭代器的算法

dest 参数是一个表示算法可以写入的目的位置的迭代器，算法假设，按其需要写入数据，不管写入多少个元素都是安全的

### 接收第二个输入序列的算法

如果算法接收 beg、end2，则两个迭代器表示第二个范围，\[beg,end)、\[beg2,end2)表示的第二个范围\
只接受单独的 beg2,将 beg2 作为第二个输入范围中的首元素，此范围的结束位置未指定，这些算法假定从 beg2 开始的范围与 beg、end 表示的范围至少一样大，如 equal 函数

### 可提供自定义谓词的算法

如 unque 的使用

```cpp
//example30.cpp
vector<int> vec = {1, 2, 3, 3, 4, 4};
auto iter = unique(vec.begin(), vec.end());
auto beg = vec.begin();
while (beg != iter)
{
    cout << *beg << " "; // 1 2 3 4
    beg++;
}
cout << endl;
//提供谓词
vec = {1, 2, 3, 3, 4, 4};
iter = unique(vec.begin(), vec.end(), [](int &a, int &b) -> bool
              { return (a == b); });
beg = vec.begin();
while (beg != iter)
{
    cout << *beg << " "; // 1 2 3 4
    beg++;
}
cout << endl;
```

### find_if 函数

find 函数第三个函数为 val，而 find_if 第三个参数为 pred 函数

```cpp
//example31.cpp
struct Person
{
    int age;
    int height;
};

int main(int argc, char **argv)
{
    vector<Person> vec;
    for (int i = 0; i < 10; i++)
    {
        Person person;
        person.age = i;
        person.height = i;
        vec.push_back(person);
    }
    // find_if
    auto iter = find_if(vec.begin(), vec.end(), [](Person &item) -> bool
                        { return (item.age == 3); });
    if (iter != vec.end())
    {
        // height: 3 age: 3
        cout << "height: " << iter->height << " age: " << iter->age << endl;
    }
    return 0;
}
```

### reverse 与 reverse_copy

用于反转指定范围的元素

```cpp
//example32.cpp
vector<int> vec = {1, 2, 3, 4, 5};
reverse(vec.begin(), vec.end());
printVec(vec); // 5 4 3 2 1
vector<int> vec_copy;
reverse_copy(vec.begin(), vec.end(), back_inserter(vec_copy));
printVec(vec_copy); // 1 2 3 4 5
```

### remove_if 与 remove_copy_if

用于删除满足指定条件的元素

```cpp
//example33.cpp
// remove_if
vector<int> vec = {1, 2, 3, 4, 5};
auto iter = remove_if(vec.begin(), vec.end(), [](int &item) -> bool
                      { return (item <= 2); }); //移除小于等于2的元素
auto beg = vec.begin();
while (beg != iter)
{
    cout << *beg << " "; // 3 4 5
    beg++;
}
cout << endl;
// remove_copy_if
vec = {1, 2, 3, 4, 5};
vector<int> vec_copy;
remove_copy_if(vec.begin(), vec.end(), back_inserter(vec_copy), [](int &item) -> bool{ return item <= 2; });
printVec(vec);      // 1 2 3 4 5
printVec(vec_copy); // 3 4 5
```

### list 与 forward_list 特定算法

学过数据结构知道的是，有些算法对于顺序容器非常好操作，对于非顺序结构则需做出特殊的处理操作，如 list 和 forward_list 就不能进行随机访问，它们拥有独特的 sort、merge、remove、reverse、unique。

例

![list和forward_list成员函数版本的算法](<../.gitbook/assets/屏幕截图 2022-06-10 144906.jpg>)

```cpp
//example34.cpp
// unique
list<int> m_list = {1, 2, 3, 3, 3, 6, 6, 6, 6, 7};
printVec(m_list); // 1 2 3 3 3 6 6 6 6 7
m_list.unique();  //删除同一个值得连续拷贝
printVec(m_list); // 1 2 3 6 7
// merge
list<int> m_list1 = {1, 2, 3, 4, 5};
list<int> m_list2 = {1, 2, 3, 4};
m_list1.merge(m_list2);
printVec(m_list1); // 1 1 2 2 3 3 4 4 5
printVec(m_list2); //
```

### list 与 forward_list 的 splice 成员

链表类型还定义了 splice 算法，用于将链表的一部分移动到另一个链表上去，此算法为链表数据结构特有的，并不是完全的泛型算法

![list和forward_list的splice成员函数的参数](<../.gitbook/assets/屏幕截图 2022-06-10 145928.jpg>)

```cpp
//example35.cpp
// list用 splice
list<int> m_list1 = {1, 2, 3, 4, 5};
list<int> m_list2 = {6, 7, 8, 9};
m_list1.splice(++m_list1.begin(), m_list2); //在指定迭代器前添加
printVec(m_list1);                          // 1 6 7 8 9 2 3 4 5
printVec(m_list2);                          //
// forward_list用 splice_after
forward_list<int> m_forwardlist1 = {1, 2, 3, 4, 5};
forward_list<int> m_forwardlist2 = {6, 7, 8, 9};
m_forwardlist1.splice_after(++m_forwardlist1.begin(), m_forwardlist2); //在指定迭代器后添加
printVec(m_forwardlist1);                                              // 1 2 6 7 8 9 3 4 5
printVec(m_forwardlist2);                                              //
```
