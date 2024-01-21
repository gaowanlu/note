---
cover: >-
  https://images.unsplash.com/photo-1649651244819-79b28e4a9ce1?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHwxfHxzd29ya3N8ZW58MHx8fHwxNjUyNTMwNjMx&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 🥬 第 5 章 语句

## 第 5 章 语句

C++ 中的大多数语句都已分号结尾，如果编码人员忘记，则会在编译时报错

### 简单语句

### 空语句

空语句就是什么也不做的语句，同理也是以分号结尾

```cpp
//example1.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    ; //一个空语句
    int i = 0;
    while (i < 5)
    {
        ;
        i++;
    }
    while (--i > 0)
        ;              //一个空语句
    cout << i << endl; // 0
    return 0;
}
```

### 关于分号

分号我们漏写会报错，多写了则会将多的当做空语句处理,总之不要多写也不要少些，以免出现逻辑上的 BUG，往往是难以寻找的

```cpp
//example2.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int i = 1;
    ;
    ;
    // int j //error 没有分号
    //规范的写法为
    // int i = 1;
    // int j;
    return 0;
}
```

### 复合语句块

复合语句是指用花括号括起来的语句和声明的序列，复合语句也被称作为块，在函数、for、if、while、switch 等语句都会使用到{}

块不以分号作为结束

```cpp
//example3.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv) // main本身也是个复合语句块
{
    {
        int i = 0;
    }
    // cout << i << endl;//error: 'i' was not declared in this scope

    int i = 1;
    while (++i < 5)
    {
        cout << i << endl; // 2 3 4
    }

    //同理可以有空的块
    while (--i > 0)
    {
    }
    return 0;
}
```

### 语句作用域

可以在块内定义变量，定义在控制结构当中的变量只在响应语句的内部可见，一旦跳出此语句，变量就超出作用范围了

```cpp
//example4.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    auto i = 1;
    {
        auto i = 2, j = 666;
        cout << i << " " << j << endl; // 2 666
        {
            auto i = 999;
            cout << i << endl; // 999
        }
        cout << i << endl; // 2
    }
    cout << i << endl; // 1
    return 0;
}
```

### 条件语句

### if 语句

if 语句的结构主要有 if、else、else if 组成

### if 与 else

```cpp
//example5.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    bool flag(true);
    //简单的if语句
    if (flag)
        cout << "1" << endl; // 1
    if (!flag)               // no excute
    {
        cout << "2" << endl;
    }
    // if else
    if (1 > 2)
    {
        cout << "1>2" << endl;
    }
    else
    {
        cout << "1<=2" << endl; // 1<=2
    }
    if (1 < 2)
        cout << "1<2" << endl; // 1<2
    else
        cout << "1>=2" << endl;
    return 0;
}
```

### 嵌套 if 语句

```cpp
//example6.cpp
#include <iostream>
#include <cmath>
#include <time.h>
using namespace std;
int main(int argc, char **argv)
{
    srand((unsigned)time(NULL));
    int i = rand() % 10;
    cout << i << endl;
    if (i < 4)
    {
        cout << "i<4" << endl;
    }
    else if (i >= 4 && i < 7)
    {
        cout << "i>=4&&i<7" << endl;
    }
    else if (i >= 7 && i < 9)
    {
        cout << "i>=7&&i<9" << endl;
    }
    else
    {
        cout << "i>=9" << endl;
    }
    return 0;
}
```

要注意的内容，当 if、else、else if 后面的代码如果没有加{},那么它们默认相当于为后面的一条语句加了花括号，在我们写程序时要格外的注意，以免造成 BUG

### 悬垂 else

在 if 语句嵌套时，它们与 else 是怎样的匹配关系,else 前面如果没有右花括号则它与其上面距离最近的 if 语句匹配，否则花括号强迫 else 与其进行匹配

```cpp
//example7.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    bool flag = true;
    if (flag)
        if (!flag)
            cout << flag << endl;
        else
            cout << "else" << endl; // else
    //输出 else
    // else是与谁进行了匹配呢 else与距离太最近但尚未匹配的if匹配即第2个if

    //如果用了括号,就很明显直到它们的匹配关系了，即花括号指明了else与谁对应
    if (flag)
    {
        if (!flag)
        {
            cout << flag << endl;
        }
        else
        {
            cout << "else" << endl; // else
        }
    }
    else
    {
        cout << "flag is false" << endl;
    }

    //可能还有很多其他情况
    if (flag)
        if (!flag)
        {
            cout << flag << endl;
        }
        else
            cout << "else" << endl; // else
    return 0;
}
```

### C++17 支持初始化语句的 if

语法格式如下

```cpp
if (init; condition) {}
```

其中 init 是初始化语句，condition 是条件语句，它们之间使用分号分隔。 允许初始化语句的 if 结构让以下代码成为可能：

```cpp
#include <iostream>
using namespace std;

// C++17支持初始化语句的if

bool func(int n)
{
    return n > 10;
}

int main(int argc, char **argv)
{
    int n = 11;
    if (bool b = func(n); b)
    {
        cout << "b=" << n << ">10" << endl;
    }
    else
    {
        cout << "b=" << n << "<=10" << endl;
    }
    return 0;
}
// b=11>10
```

if 初始化语句中声明的变量拥有和整个 if 结构一样长的声明周期，所以前面的代码可以等价于：

```cpp
#include <iostream>
bool foo()
{
  return true;
}
int main()
{
  {
       bool b = foo();
       if (b) {
            std::cout << std::boolalpha << "good! foo()=" << b << std::endl;
       }
  }
}
```

也可以在 if else 中使用

```cpp
#include <iostream>
using namespace std;

// C++17支持初始化语句的if

bool func(int n)
{
    return n > 10;
}

int main(int argc, char **argv)
{
    int n = 10;
    if (bool b = func(n); b)
    {
        cout << "b=" << n << ">10" << endl;
    }
    else if (bool b1 = func(n); !b1)
    {
        cout << b << " " << b1 << endl;
    }
    else if (bool b2 = func(n); !b2)
    {
        cout << b << " " << b1 << " " << b2 << endl;
    }
    return 0;
}
// 0 0
```

上面代码等价于

```cpp
#include <iostream>
using namespace std;

bool func(int n)
{
    return n > 10;
}

int main(int argc, char **argv)
{
    int n = 10;
    {
        bool b = func(n);
        if (b)
        {
            std::operator<<(std::operator<<(std::cout, "b=").operator<<(n), ">10").operator<<(std::endl);
        }
        else
        {
            {
                bool b1 = func(n);
                if (!b1)
                {
                    std::operator<<(std::cout.operator<<(b), " ").operator<<(b1).operator<<(std::endl);
                }
                else
                {
                    {
                        bool b2 = func(n);
                        if (!b2)
                        {
                            std::operator<<(std::operator<<(std::cout.operator<<(b), " ").operator<<(b1), " ").operator<<(b2).operator<<(std::endl);
                        }
                    }
                }
            }
        }
    }

    return 0;
}
```

因为 if 初始化语句声明的变量会贯穿整个 if 结构，所以我们可以利用该特性对整个 if 结构加锁，例如：

```cpp
#include <mutex>
std::mutex mx;
bool shared_flag = true;
int main()
{
    if (std::lock_guard<std::mutex> lock(mx); shared_flag)
    {
        shared_flag = false;
    }
}

// 其他样例

#include <cstdio>
#include <string>
int main()
{
  std::string str;
  if (char buf[10]{0}; std::fgets(buf, 10, stdin)) {
       str += buf;
  }
}
```

### switch 语句

什么是 switch 语句，它是 if、else if 的升级版 、第一个 case 相当于 if，其余 if else 相当于后面的 case，default 相当于末尾的 else

```cpp
//example8.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    char ch = 'A';
    switch (ch)
    {
    case 'A':
        cout << "A Block" << endl; // A Block
        break;
    case 'B':
        cout << "B Block" << endl;
        break;
    case 'C':
        cout << "C Block" << endl;
        break;
    default:
        cout << "not found" << endl;
        break;
    }
    //等价于
    if (ch == 'A')
    {
        cout << "A Block" << endl; // A Block
    }
    else if (ch == 'B')
    {
        cout << "B Block" << endl;
    }
    else
    {
        cout << "C Block" << endl;
    }
    return 0;
}
```

### switch 内部的控制流

从第一个匹配成功的 case 开始执行向下执行直到遇见 break 或者执行 default 部分代码块后结束

```cpp
//example9.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    char ch('a');
    switch (ch)
    {
    case 'a':
        cout << 'a' << endl;
    case 'b':
        cout << 'b' << endl;
    case 'c':
        cout << 'c' << endl;
        break;
    default:
        cout << "not found" << endl;
        break;
    }
    //会出现什么情况呢?当ch为a 或 b 或 c时都会执行从其匹配的地方向后执行
    //当 ch=a 输出 a b c
    //当 ch=b 输出 b c
    //当 ch=c 输出 c
    switch (ch)
    {
    case 'a':
        cout << 'a' << endl;
    case 'b':
        cout << 'b' << endl;
    case 'c':
        cout << 'c' << endl;
    default:
        cout << "not found" << endl;
        break;
    }
    // ch=a时 输出a b c not found
    return 0;
}
```

要值得注意的是，case 标签必须为整形常量表达式，任何两个 case 标签的值不能相同，否则会引发错误。 不在每个 case 代码内些 break，本就违反了我们用 switch 的初心，而且没写好就会因漏写 chanshnegBUG。

### switch 内部的变量定义

可以在 case 要执行的代码中定义变量，但其中并没有想象的那么简单

```cpp
//example10.cpp
#include <iostream>
#include <string>
using namespace std;
int main(int argc, char **argv)
{
    int v = 0;
    switch (v)
    {
    case 0:
        // i = 999; 错误i还没有声明
        // cout << i << endl;
    case 1:
        // std::string filename;//错误 控制流可能绕过此初始化语句 string有隐式初始化
        // cout << filename << endl;
        //  int j = 0;错误 控制流可能绕过此初始化语句
        int i;
        break;
    case 2:
        i = 9;
        cout << i << endl; // 9
        break;
    default:
        break;
    }
    //其实相当于在case内声明变量，相当于在此case执行时声明变量，在后面各个case内都能使用
    //为什么不能初始化
    //总之可能被绕开的初始化语句是不正确的写法
    return 0;
}
```

如何解决这种问题呢

在花括号内初始化、仅在花括号内使用

```cpp
//example11.cpp
#include <iostream>
#include <string>
using namespace std;
int main(int argc, char **argv)
{
    int v = 0;
    switch (v)
    {
    case 0:
        // i = 999; 错误i还没有声明
        // cout << i << endl;
    case 1:
    {
        std::string filename = "cdc";
        cout << filename << endl; // cdc
        int j = 0;
    }
        // cout << j << endl; undefined因为filename与j的作用域仅仅在上面的花括号内
        int i;
        // break;
    case 2:
        i = 9;
        cout << i << endl; // 9
        break;
    default:
        break;
    }
    //其实相当于在case内声明变量，相当于在此case执行时声明变量，在后面各个case内都能使用
    //为什么不能初始化
    //总之可能被绕开的初始化语句是不正确的写法
    return 0;
}
//输出 cdc 9
```

### C++17 支持初始化语句的 switch

和 C++17 支持初始化语句的 if 类似

```cpp
#include <iostream>
using namespace std;

// C++17支持初始化语句的switch

bool func(int n)
{
    return n > 10;
}

int main(int argc, char **argv)
{
    int n = 10;
    switch (bool b = func(n); b)
    {
    case false:
        cout << "func(" << n << ")="
             << "false" << endl;
        break;
    default:
        cout << "func(" << n << ")="
             << "true" << endl;
        break;
    }
    return 0;
}
// func(10)=false
```

例如 switch 配和条件变量使用

```cpp
#include <iostream>
#include <condition_variable>
#include <chrono>
#include <mutex>
using namespace std::chrono_literals;

std::condition_variable cv;
std::mutex cv_m;

int main()
{
    switch (std::unique_lock<std::mutex> lk(cv_m); cv.wait_for(lk, 1000ms))
    {
    case std::cv_status::timeout:
    {
        std::cout << "timeout" << std::endl;
    }
        break;
    case std::cv_status::no_timeout:
    {
        std::cout << "no_timeout" << std::endl;
    }
        break;
    }
}

// timeout
```

### 迭代语句

迭代语句在 C++内主要有四大类，while 语句、传统的 for 循环、范围的 for 循环、do while 语句

### while 语句

语法格式

```cpp
while(condition)
    lang;
while(condition){
    code block
}
```

代码样例

```cpp
//example12.cpp
#include <iostream>
#include <string>
#include <vector>
using namespace std;
int main(int argc, char **argv)
{
    vector<int> vecs{1, 2, 3, 4};
    string str = "1234";
    int i = 0;
    auto vec_iter = vecs.begin();
    while (vec_iter != vecs.end() && i < str.size())
    {
        cout << *vec_iter << endl;
        cout << str.at(i) << endl;
        i++;
        vec_iter++;
    }
    // 1 1 2 2 3 3 4 4
    return 0;
}
```

### 传统 for 循环

语法格式

```cpp
for(init-statemen;condition;expression)
    lang;
for(init-statemen;condition;expression){

}
```

代码样例

```cpp
//example13.cpp
#include <iostream>
#include <vector>
using namespace std;
int main(int argc, char **argv)
{
    for (int i = 0; i < 5; i++)
    {
        cout << i << endl;
    } // 0 1 2 3 4

    int count = 0;
    for (int i = 0, j = 0; i < 5; i++, j++)
    {
        cout << i << " " << j << endl;
        count++;
    }                      // 0 0 1 1 2 2 3 3 4 4
    cout << count << endl; // 5

    vector<int> vecs = {1, 2, 3, 4};
    vector<int>::iterator iter;
    for (iter = vecs.begin(); iter != vecs.end(); iter++)
    {
        cout << *iter << endl;
    } // 1 2 3 4
    // init-statemen与expression可以为空，但condition不能为空
    return 0;
}
```

### 范围 for 循环

基于范围的 for 循环语法 C++11 标准引入了基于范围的 for 循环特性，该特性隐藏了迭代器的初始化和更新过程，让程序员只需要关心遍历对象本身，其语法也比传统 for 循环简洁很多：

基于范围的 for 循环不需要初始化语句、条件表达式以及更新表达式，取而代之的是一个范围声明和一个范围表达式。其中范围声明是一个变量的声明，其类型是范围表达式中元素的类型或者元素类型的引用。而范围表达式可以是数组或对象，对象必须满足以下 2 个条件中的任意一个。

1. 对象类型定义了 begin 和 end 成员函数。
2. 定义了以对象类型为参数的 begin 和 end 普通函数。

begin 和 end 函数不必返回相同类型,在 C++11 标准中基于范围的 for 循环相当于以下伪代码：

```cpp
{
  auto && __range = range_expression;
  for (auto __begin = begin_expr, __end = end_expr; __begin != __end; ++__begin) {
       range_declaration = *__begin;
       loop_statement
  }
}
```

其中`begin_expr`和`end_expr`可能是`__range.begin()`和`__range.end()`，或者是`begin(__range)`和`end(__range)`。 当然，如果`__range`是一个数组指针，那么还可能是`__range`和`__range+__count`（其中\*\*count 是数组元素个数）。 这段伪代码有一个特点，它要求`begin_expr`和`end_expr`返回的必须是同类型的对象。 但实际上这种约束完全没有必要，只要`begin != __end`能返回一个有效的布尔值即可， 所以 C++17 标准对基于范围的 for 循环的实现进行了改进，伪代码如下：

```cpp
{
  auto && __range = range_expression;
  auto __begin = begin_expr;
  auto __end = end_expr;
  for (; __begin != __end; ++__begin) {
       range_declaration = *__begin;
       loop_statement
  }
}
```

代码样例

```cpp
//example14.cpp
#include <iostream>
#include <vector>
#include <string>
using namespace std;
int main(int argc, char **argv)
{
    vector<int> vecs{1, 2, 3, 4};
    for (auto &num : vecs)
    {
        cout << num << endl;
        num++;
    } // 1 2 3 4
    for (int &num : vecs)
    {
        cout << num << endl;
        num--;
    } // 2 3 4 5

    string str = "abcd";
    for (char &ch : str)
    {
        cout << ch << endl;
    } // abcd
    return 0;
}
```

### 范围 for 循环的陷阱`auto&&`

无论是 C++11 还是 C++17 标准，基于范围的 for 循环伪代码都是由以下这句代码开始的：

```cpp
auto && __range = range_expression;
```

理解了右值引用的读者应该敏锐地发现了这里存在的陷阱 `auto &&`。对于这个赋值表达式来说， 如果`range_expression`是一个纯右值， 那么右值引用会扩展其生命周期，保证其整个 for 循环过程中访问的安全性。 但如果`range_ expression`是一个泛左值， 那结果可就不确定了，参考以下代码：

```cpp
class T {
  std::vector<int> data_;
public:
  std::vector<int>& items() { return data_; }
  // …
};

T foo()
{
    T t;
    return t;
}
for (auto& x : foo().items()) {} // 未定义行为
```

这里的 for 循环会引发一个未定义的行为，因为`foo().items()`返回的是一个泛左值类型`std::vector&`，于是右值引用无法扩展其生命周期，导致 for 循环访问无效对象并造成未定义行为。 对于这种情况请读者务必小心谨慎，将数据复制出来是一种解决方法：

```cpp
T thing = foo();
for (auto & x :thing.items()) {}
```

在 C++20 标准中，基于范围的 for 循环增加了对初始化语句的支持， 所以在 C++20 的环境下我们可以将上面的代码简化为：

```cpp
for (T thing = foo(); auto & x :thing.items()) {}
```

### 实现支持范围 for 循环的类

此部分为高级进阶内容

1. 该类型必须有一组和其类型相关的 begin 和 end 函数，它们可以是类型的成员函数，也可以是独立函数。
2. begin 和 end 函数需要返回一组类似迭代器的对象，并且这组对象必须支持`operator *`、`operator !=`和`operator ++`运算符函数。

```cpp
#include <iostream>
using namespace std;

// int类型指针迭代器
class IntIter
{
public:
    IntIter(int *p) : p_(p) {}
    bool operator!=(const IntIter &other)
    {
        return (p_ != other.p_);
    }
    const IntIter &operator++()
    {
        p_++;
        return *this;
    }
    int operator*() const
    {
        return *p_;
    }

private:
    int *p_;
};

// 模板容器
template <unsigned int fix_size>
class FixIntVector
{
public:
    FixIntVector(std::initializer_list<int> init_list)
    {
        if (init_list.size() != fix_size)
        {
            return;
        }
        int *cur = data_;
        for (auto e : init_list)
        {
            *cur = e;
            cur++;
        }
    }
    IntIter begin()
    {
        return IntIter(data_);
    }
    IntIter end()
    {
        return IntIter(data_ + fix_size);
    }

private:
    int data_[fix_size]{0};
};

int main(int argc, char **argv)
{
    FixIntVector<10> fix_int_vector{1, 2, 3, 4, 5, 6, 7, 8, 9, 0};
    for (int e : fix_int_vector)
    {
        cout << e << " ";
    }
    // 1 2 3 4 5 6 7 8 9 0
    return 0;
}
```

### do while 循环

do while 语句与 while 语句非常相似，唯一的区别是，do while 语句先执行循环体后检查条件，不管条件值如何，我们都至少执行一次循环。

语法格式

```cpp
do
    statement
while(condition);
```

代码样例

```cpp
//example15.cpp
#include <iostream>
using namespace std;

int get_num()
{
    static int num = 0;
    ++num;
    return num;
}

int main(int argc, char **argv)
{
    int num;
    do
    {
        num = get_num();
        cout << num << endl;
    } while (num < 5);
    // 1 2 3 4 5

    do
        cout << get_num() << endl;
    while (false);
    // 6
    return 0;
}
```

### 跳转语句

主要有三种操作 break 语句、continue 语句、goto 语句

### break 语句

负责终止离它最近的 while、do while、for、switch 语句，并从这些语句之后的第一条语句开始继续执行

```cpp
//example16.cpp
#include <iostream>
#include <string>
using namespace std;
int main(int argc, char **argv)
{
    int i = 0;
    do
    {
        cout << i << endl;
        if (i > 3)
        {
            break; //离开do while循环
        }
        i++;
    } while (i < 10); // 0 1 2 3 4

    string str = "abcd";
    for (char &ch : str)
    {
        if (ch == 'c')
            break; //离开for循环
        switch (ch)
        {
        case 'a':
            cout << ch << endl;
            break; //离开switch语句
        case 'b':
            cout << ch << endl;
            break; //离开switch语句
        default:
            break; //离开switch语句
        }
        int num = 1;
        while (num <= 3)
        {
            if (num == 3)
                break; //离开while循环
            cout << num << endl;
            num++;
        }
    } // a 1 2 b 1 2
    return 0;
}
```

### continue 语句

continue 语句终止最近的循环中的当前迭代并立即开始下一次迭代，continue 只能出现在 for、while、do while 循环内，或嵌套在此类循环里的语句或块的内部。

```cpp
//example17.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int num = 1;
    do
    {
        num++;
        if (num == 2)
        {
            continue;
        }
        cout << num << endl;
    } while (num < 4); // 3 4

    /*
    //下面将会卡死 因为当num为2时将会continue重新执行do内的代码，导致num一直只能为2
    num = 1;
    do
    {
        if (num == 2)
        {
            continue;
        }
        num++;
        cout << num << endl;
    } while (num < 4);
    */
    num = 1;
    while (num < 3)
    {
        num++;
        if (num == 2)
        {
            continue;
        }
        cout << num << endl;
        // num++;//将num++移到此处也将会num停留在2卡死不断地continue
    } // 3

    // for循环不同的一点时，当continue后，先回执行i++然后执行判断i<=4然后再次进行循环
    // 而在do while与while中我们要注意使用continue可能导致死循环
    for (int i = 1; i <= 4; i++)
    {
        if (i == 3)
        {
            continue;
        }
        cout << i << endl; // 1 2 4
    }
    return 0;
}
```

### goto 语句

goto 语句的作用是从 goto 语句无条件跳转到同意函数的内的另一条语句

```cpp
//example18.cpp
#include <iostream>
using namespace std;
void func()
{
    goto L1;
    cout << "C++" << endl;
L1:
    cout << "hello world" << endl;
}
int main(int argc, char **argv)
{
    int i = 0;
    goto L1;
    cout << i << endl; //不执行
    // int j = 999;       //错误：goto语句不能跳过带初始化的变量定义
    int j; //但可以跳过定义但未被初始化的语句
L1:
    cout << ++i << endl; // 1
    // int j = 999; //错误：j已经被定义过了
    cout << j << endl; // undefined
    func();            // hello world
    //标签的作用域在函数内部
    return 0;
}
```

### try 语句块与异常处理

C++有运行时异常处理机制

- throw 表达式，异常检测部分使用 throw 表达式来表示它遇到了无法解决的问题，throw 引发了异常
- try 语句块，异常处理部分使用 try，try 语句块以关键字 try 开始，并以一个多个 catch 子句结束
- 异常类，用于在 throw 表达式和相关的 catch 子句之间传递异常信息

### throw 表达式

抛出异常

```cpp
//example19.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int i = -1;
    if (i != 1)
    {
        throw runtime_error("i!=1");
    }
    /*
    terminate called after throwing an instance of 'std::runtime_error'
    what():  i!=1
    */
    cout << i << endl; //不会被执行
    return 0;
}
```

### try 语句块与 catch 捕获异常

try 语句块至少需要一个 catch 语句块

```cpp
//example20.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int i = -1;
    // try代码块内可能抛出多种类型的异常，如果要进行对有可能出现的异常处理，则使用多个catch
    try
    {
        if (i > 1)
        {
            throw runtime_error("i>1");
        }
        if (i < 0)
        {
            throw logic_error("i<0");
        }
        cout << "try end" << endl; //如果上面有throw抛出异常，则在throw执行后，try内代码停止运行
    }
    catch (runtime_error error)
    {
        cout << error.what() << endl;
        throw runtime_error(error.what());
    }
    catch (logic_error error)
    {
        cout << error.what() << endl; // i<0
    }
    cout << i << endl; //-1
    return 0;
}
```

### 函数的提前停止

```cpp
//example21.cpp
#include <iostream>
using namespace std;
void func()
{
    //抛出runtime_error没有对应的catch，则会停止此函数的执行
    //然后将error对象传递到调用它的函数
    try
    {
        throw runtime_error("func test error");
        cout << "func try end" << endl;
    }
    catch (logic_error error)
    {
        cout << error.what() << endl;
    }
}
int main(int argc, char **argv)
{
    // func();
    //如果调用则会抛出异常，不处理则相当于再次throw了一个error
    //仍旧没有捕获，则main函数停止运行

    //正确方式
    try
    {
        func();
    }
    catch (runtime_error error)
    {
        cout << error.what() << endl;
    }
    cout << "main end" << endl;
    return 0;
}
//程序输出
// func test error
// main end
```

### 标准异常

C++标准库定义类一组类，用于报告标准库函数遇到的问题

```cpp
#include<exception>
定义了最通用的异常类exception,它只报告异常的发生，不提供任何额外信息
exception类是个接口，并不能实例化
```

```cpp
#include<stdexcept>
exception 最常见的问题

runtime_error 继承exception:只有在运行时才能检测出的问题
range_error 运行时错误，生成的结果超出了有意义的值域范围
overflow_error 继承运行时错误：计算上溢
underflow_error 继承运行时错误：计算下溢

logic_error 继承exception:程序逻辑错误
domain_error 继承逻辑错误：参数对应的结果值不存在
invalid_argument 继承逻辑错误：无效参数
length_error 继承逻辑错误：视图创建一个超出该类型最大长度的对象
out_of_range 继承逻辑错误：使用一个超出有效范围的值
```

```cpp
#include<new>//中定义bad_alloc异常类
#include<type_info>//中定义bad_cast异常类
```

```cpp
#include <iostream>
#include <stdexcept>
#include <cmath>
#include <ctime>
#include <new>
using namespace std;
int main(int argc, char **argv)
{
    time_t t;
    srand((unsigned)time(&t));
    int num = rand() % 13;
    num = 7;
    try
    {
        try
        {
            switch (num)
            {
            case 0:
                throw runtime_error("runtime_error");
                break;
            case 1:
                throw logic_error("logic_error");
            case 2:
                throw bad_alloc();
            case 3:
                throw bad_exception();
            case 4:
                throw bad_typeid();
            case 5:
                throw domain_error("domain_error");
            case 6:
                throw invalid_argument("invalid_argument");
            case 7:
                throw length_error("length_error");
            case 8:
                throw out_of_range("out_of_range");
            case 9:
                throw overflow_error("overflow_error");
            case 10:
                throw range_error("range_error");
            case 11:
                throw underflow_error("underflow_error");
            default:
                throw bad_cast();
                break;
            }
        }
        catch (length_error &error)
        {
            cout << "length_error:: " << error.what() << endl;
            throw error;
        }
        catch (exception &error) //所有类型的异常都会被捕获，因为所有异常类继承exception类
        {
            cout << error.what() << endl;
        }
    }
    catch (exception &error)
    {
        cout << "try block throw::" << error.what() << endl;
    }
    cout << "main end" << endl;
    return 0;
    //当num=7时输出
    //length_error:: length_error
    //try block throw::length_error
    //main end
}
```
