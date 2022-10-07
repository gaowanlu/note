---
cover: >-
  https://images.unsplash.com/photo-1652598113005-a75ff204263b?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI4MzkwOTI&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 😝 第6章 函数

## 第6章 函数

在前面我们已经使用过定义main函数，以及也见过其他的自定义函数，`函数`是一个命名了的代码块，我们通过调用函数执行相应的代码，函数可以有0个或多个参数，而且通常产生一个结果，C++可以重载函数，也就是说，同一个名字可以对应几个不同的函数

### 函数基础

函数的实参的类型要与函数的形参类型匹配，后者实参赋值给形参可以进行类型转换。

```cpp
//example1.cpp
#include <iostream>
using namespace std;

//编写函数 返回类型为int
int double_(int num)
{
    return 2 * num;
}

int main(int argc, char **argv)
{
    //调用函数
    cout << double_(3) << endl; //实参为3
    //形参为num
    return 0;
}
```

### 函数参数列表

函数的形参可以为多个，形成函数的形参列表

```cpp
//example2.cpp
#include <iostream>
using namespace std;

int mul(int num1, int num2)
{
    return num1 * num2;
}

int main(int argc, char **argv)
{
    cout << mul(2, 3) << endl; // 6
    return 0;
}
```

### 局部对象

在C++中，名字是有作用域的，对象有生命周期，形参和函数内部定义的变量统称为`局部变量`，其作用域在函数内部，且一旦函数执行完毕，相应内存资源被释放即栈内存。分配的栈内存将会保留，直到我们调用free或者delete。

```cpp
//example3.cpp
#include <iostream>
using namespace std;
int &func()
{
    int i = 999;
    return i;
}

int *func1()
{
    int *i = new int(999);
    return i;
}

int main(int argc, char **argv)
{
    int *num = func1();
    cout << *num << endl; // 999
    delete num;
    int &i = func();
    cout << i << endl;
    //程序会报错，为什么，因为func调用完毕后其内的i变量内存被释放，所以相应的引用是无效的
    return 0;
}
```

### 局部静态组件

局部静态对象在程序的执行路径第一次经过对象定义语句时进行初始化，并且直到程序终止才被销毁，在此期间即使对象所在的函数结束执行也不会对它有影响。

```cpp
//example4.cpp
#include <iostream>
using namespace std;
int count()
{
    static int num = 0;
    ++num;
    return num;
}
int main(int argc, char **argv)
{
    cout << count() << endl; // 1
    cout << count() << endl; // 2
    for (int i = 0; i < 4; i++)
    {
        cout << count() << endl; // 3 4 5 6
    }
    return 0;
}
```

### 函数声明

函数的名字必须在使用前声明，与变量类似，函数只能定义一次，但可以声明多次。

```cpp
//example5.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    // func();// error: 'func' was not declared in this scope
    //在每调用前没有声明或者定义
    return 0;
}

void func()
{
    cout << "hello function" << endl;
}
```

### 声明提升

```cpp
//example6.cpp
#include <iostream>
using namespace std;

void func(); //函数声明

int main(int argc, char **argv)
{
    func();
    return 0;
}

//函数定义
void func()
{
    cout << "hello function" << endl;
}
```

### 在头文件中进行函数声明

```cpp
//example7.cpp
#include "example7.h"
#include <iostream>
int main(int argc, char **argv)
{
    func(); // hello world
    return 0;
}

void func()
{
    std::cout << "hello world" << std::endl;
}
```

自定义头文件

```cpp
//example7.h
#ifndef __EXAMPLE7_H__
#define __EXAMPLE7_H__

void func(); //函数声明

#endif
```

### 分离式编译

一个程序可以分为多个cpp文件，也就是将程序的各个部分分别存储在不同文件中。\
大致原理是，对多个cpp分别编译，然后将多个编译后的部分进行链接操作形成了整体的程序，虽然在多个cpp中编写，但是我们只有一个全局命名空间，也就是说在多个cpp内定义相同名字的变量这是不被允许的。

example8.cpp

```cpp
//example8.cpp
#include <iostream>
#include "func.h"
using namespace std;
// int i = 999;
//出错因为func.cpp已经定义了int i,不能有重复定义，全局命名空间只有一个
int main(int argc, char **argv)
{
    func(); // hello world
    return 0;
}
```

func.cpp

```cpp
//func.cpp
#include "func.h"
#include <iostream>
using namespace std;
int i = 999;
void func()
{
    cout << "hello world" << endl;
}
```

func.h

```cpp
#ifndef __FUNC_H__
#define __FUNC_H__
void func();
#endif
```

分别编译并且最后链接

```bash
g++ -c example8.cpp
g++ -c func.cpp
g++ example8.o func.o -o example8.exe
./example8.exe
```

或者编译并链接

```bash
g++ example8.cpp func.cpp -o example8.exe
./example8.exe
```

### 参数传递

调用函数时参数的传递分为传引用调用(引用传递)和传值调用(值传递)

### 传引用

```cpp
//example9.cpp
#include <iostream>
using namespace std;
void func(int &i, int *j)
{
    i -= 1;
    *j -= 1;
}
int main(int argc, char **argv)
{
    int i = 0, j = 0;
    func(i, &j);//传递i的引用与j的内存地址
    cout << i << " " << j << endl; //-1 -1
    return 0;
}
```

### 为什什么要提供引用传递呢

对拷贝大的类类型对象或者容器对象，甚至有的类类型对象不支持拷贝，只能通过引用形参支持在其他函数内调用对象，例如有字符串非常长，我们根据操作情况，可以选择引用传递，因为那样省略去了字符串拷贝，节约了内存资源，使得程序效率更高。

```cpp
//example10.cpp
#include <iostream>
#include <string>
#include <vector>
using namespace std;

void func(string &str, vector<int> &vec)
{
    cout << str << endl;
    for (auto &item : vec)
    {
        cout << item << " ";
        item++;
    }
    cout << endl;
}

int main(int argc, char **argv)
{
    vector<int> v{1, 2, 3, 4, 5};
    string str = "hello c++";
    func(str, v);
    // hello c++ 1 2 3 4 5
    func(str, v);
    // hello c++ 2 3 4 5 6
    return 0;
}
```

### 使用引用形参返回额外的信息

```cpp
//exaple11.cpp
#include <iostream>
#include <string>
using namespace std;

int func(int i, string &message)
{
    if (i < 0)
    {
        message = "i<0";
        return i < 0;
    }
    message = "i>=0";
    return i < 0;
}

int main(int argc, char **argv)
{
    string message;
    func(-1, message);
    cout << message << endl; // i<0
    return 0;
}
```

### const形参和实参

### 关于顶层const的回顾

```cpp
const int ci = 42;//ci不能被赋值改变，const是顶层const
int i=ci;//i可以被赋值，拷贝ci时忽略其顶层const
int *const p=&i;//const是顶层的，不能给p赋值
*p=0;//正确，可以改变p的内容，但不能改变p本身存储的内存地址
```

### 形参的底层const与顶层const

```cpp
//example12.cpp
#include <iostream>
using namespace std;
// p同时加底层const与顶层const
void func(int i, const int *const p)
{
    cout << i << endl;  // 23
    cout << *p << endl; // 23
    //*p = 99; error: assignment of read-only location '*(const int*)p'
    // p = nullptr; error: assignment of read-only parameter 'p'
}
int main(int argc, char **argv)
{
    const int i = 23;
    func(i, &i);
    return 0;
}
```

### 为什么说当实参初始化形参时会忽略掉顶层const?

```cpp
//example13.cpp
#include <iostream>
using namespace std;

void func(const int j)
{
    cout << j << endl; // 999
}

// void func(int j)
// {
// }
// 'void func(int)' previously defined here
// 因为顶层const是相对于函数内部作用而言的，对函数外部都是进行了拷贝

int main(int argc, char **argv)
{
    int num = 999;
    func(num);
    //对于外部的调用将忽略形参的顶层const因为有没有const外部都是进行对形参赋值
    return 0;
}
```

### 指针或引用形参与const

```cpp
//example14.cpp
#include <string>
#include <iostream>
using namespace std;

// const int *p=&num; const string &str=mstr;
// p是有顶层const的int指针 str为常量引用
void func(const int *p, const string &str)
{
    string new_str = "hello";
    // str = new_str; //错误 因为str为常量的引用
    //  str = "hello";//错误 因为str为常量的引用
    int num = 999;
    p = &num;
    cout << str << endl;
}

//引用常量 底层const
//虽然有这种写法 但是我们好像从不用这种，没有引用常量
// void func(string const &str)
// {
//     cout << str << endl;
//     str = "hello";
// }

int main(int argc, char **argv)
{
    int num = 100;
    const string mstr = "hi";
    func(&num, mstr); // hi
    string name = "gaowanlu";
    func(&num, "oop"); // oop
    return 0;
}
```

总之 关于const与引用、指针的配和往往会使得我们头大，所以我们还是要多回顾复习以前的变量章节的const的知识

### 数组的传递

总之传递数组就是在传递内存地址

```cpp
//example15.cpp
#include <iostream>
using namespace std;
void func(int arr[])
{
    for (int i = 0; i < 5; i++)
    {
        cout << arr[i] << " ";
        arr[i]++;
    } // 1 2 3 4 5
    cout << endl;
}

//重载失败 因为int*p与int arr[]等效

// void func(int *p)
// {
//     cout << sizeof(p) << endl;
// }

// void func(int arr[5])
// {
// }

void print(const int *begin, const int *end)
{
    while (begin != end)
    {
        cout << *begin << " ";
        begin++;
    }
    cout << endl;
}

int main(int argc, char **argv)
{
    int arr[5] = {1, 2, 3, 4, 5};
    func(arr);                   // 1 2 3 4 5
    func(arr);                   // 2 3 4 5 6
    print(begin(arr), end(arr)); // 3 4 5 6 7
    return 0;
}
```

### 数组形参与const

```cpp
//example16.cpp
#include <iostream>
using namespace std;

// const int arr[]等价于const int *arr
// 底层const可以改变arr存储的地址 不能通过arr改变内存地址上的数据
// 即const int 的指针类型 const int * ，也就是数组的每个数据都是const int
void func(const int arr[], size_t size)
{
    size /= sizeof(int);
    for (int i = 0; i < size; i++)
    {
        cout << arr[i] << " ";
    }
    // arr[0] = 12; 错误不能改变数组的值
    cout << endl;
    int num = 999;
    arr = &num;
    //*arr = 1000;//error: assignment of read-only location '* arr'
}

int main(int argc, char **argv)
{
    const int arr[] = {1, 2, 3, 4};
    // arr[0] = 1;//error: assignment of read-only location 'arr[0]'
    func(arr, sizeof(arr)); // 1 2 3 4

    int num = 0;
    int const *p = &num; //底层const
    //*p = 999;//error 底层const
    cout << *p << endl; // 0
    return 0;
}
```

### 数组引用形参

```cpp
//example17.cpp
#include <iostream>
using namespace std;

void func(int (&arr)[5])
{
    for (auto item : arr)
    {
        cout << item << endl;
    }
}

//错误 因为数组的引用必须指定数组的长度
void func1(int (&arr)[], int size)
{
    for (int i = 0; i < size; i++)
    {
        cout << arr[i] << " ";
    }
    cout << endl;
}

int main(int argc, char **argv)
{
    int arr[] = {1, 2, 3, 4, 5};
    func(arr);
    int arr1[] = {1, 2, 3};
    // func(arr1);//error 数组长度不是5
    // func1(arr1, 3); //error 形参没有指定数组的长度 数组的引用必须指定长度

    // int(&arr2)[] = arr1;//同理这里也是错误的
    // cout << arr2[0] << endl;
    return 0;
}
```

### 传递多维数组

总之简单的办法就是传递指针,然后也可以使用数组的引用

```cpp
//example18.cpp
#include <iostream>
using namespace std;

// int *matrix[10] 10个指针构成的数组
// int (*matrix)[10] 指向含有10个整数的数组的指针
void func1(int (*arr)[5], int size)
{
    cout << size / sizeof(int) / 5 << endl; // 2
}

void func2(int arr[][5], int size)
{
    size = size / sizeof(int) / 5;
    for (int i = 0; i < size; i++)
    {
        for (int j = 0; j < sizeof(arr[i]) / sizeof(int); j++)
        {
            cout << arr[i][j] << " ";
        }
        cout << endl;
    }
}

int main(int argc, char **argv)
{
    int arr[][5] = {
        {1, 2, 3, 4, 5},
        {1, 2, 3, 4, 5}};
    func1(arr, sizeof(arr));
    func2(arr, sizeof(arr)); // 1 2 3 4 5 1 2 3 4 5
    return 0;
}
```

### main函数的形参

提供了在运行程序时赋值指定实参的功能

```cpp
//example19.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    for (int i = 0; i < argc; i++)
    {
        cout << argv[i] << endl;
    }
    return 0;
}
//输出 aaa bbb ccc
```

```bash
g++ example19.cpp -o example19.exe
./example19.exe aaa bbb ccc
```

### 可变形参

C++11有新特性，在我们无法提前预知向函数传递几个实参，在C++11中，如果所有的实参类型相同，可以传递initializer\_list类型，如果实参的类型不相同可以编写特殊的函数，所谓的可变参数模板。

还有一种特殊的形参类型即省略符，可以用来传递可变数量的实参，不过一般这种功能只用于C函数交互的接口程序。

### initializer\_list形参

```cpp
initializer_list<T> lst; 
    默认初始化；T类型元素的空列表
initializer_list<T> lst{a,b,c};
    lst的元素数量和初始值一样多：lst的元素是对应初始值的副本，列表中的元素是const
lst2(lst)
lst2=lst
    拷贝或赋值一个initializer_list对象不会拷贝列表中的元素；拷贝后，原始列表和副本共享元素
lst.size()
    列表中的元素数量
lst.begin()
    返回指向lst中首元素的指针
lst.end()
    返回指向lst中尾元素下一位置的指针
```

使用样例

```cpp
//example20.cpp
#include <iostream>
#include <string>
#include <initializer_list>
using namespace std;

void mfun(initializer_list<string> list)
{
    for (auto beg = list.begin(); beg != list.end(); beg++)
    {
        cout << beg << " " << *beg << " ";
    }
    cout << endl;
}

int main(int argc, char **argv)
{
    mfun({"1", "2", "3"}); // 0x61feb0 1 0x61fec8 2 0x61fee0 3
    initializer_list<string> params{"1", "2", "3", "4"};
    mfun(params); // 0x61fe48 1 0x61fe60 2 0x61fe78 3 0x61fe90 4
    // params[0];//error initializer_list不支持下标访问
    auto list1(params); //拷贝params对象 但是它们的元素的内存是共用的
    mfun(list1);        // 0x61fe48 1 0x61fe60 2 0x61fe78 3 0x61fe90 4
    auto list2 = list1;
    mfun(list2); // 0x61fe48 1 0x61fe60 2 0x61fe78 3 0x61fe90 4
    //总之initializer_list的元素是只读的
    return 0;
}
```

### 省略符形参

省略符形参只能出现在形参列表的最后一个位置\
总之它的作用就是可以当用户输入参数多的时候我们可以省略，但不影响函数的正常运行。

```cpp
//example21.cpp
#include <iostream>
using namespace std;

void fun1(int num1, int num2, ...)
{
    cout << num1 << " " << num2 << endl;
}

void fun2(...)
{
    cout << "fun2" << endl;
}

int main(int argc, char **argv)
{
    fun2(1, 2, 3, 4); // fun2
    fun1(1, 2);       // 1 2
    return 0;
}
```

### 返回类型和return语句

return有两种形式，用于终止当前执行的函数并将控制权返回到调用函数的地方。

```cpp
return;
return expression;
```

### 无返回值的函数

无返回值的函数返回值即为void，无需要我们显式的return;但是允许使用return;提前终止函数的执行。

```cpp
//example22.cpp
#include <iostream>
using namespace std;
void func(int num)
{
    if (num == 0)
    {
        cout << "num==0" << endl;
        return;
    }
    //此处无需显式的return语句
}
int main(int argc, char **argv)
{
    func(1);
    func(0); // num==0
    return 0;
}
```

### 有返回值的函数

有一点要确定，一个函数的返回值类型是唯一确定的，不能声明函数时的返回值类型与实际返回值类型不同，否则编译阶段会报错。

要注意的是，有返回值的函数，必须要保证函数执行结束时，有return语句返回相应类型的值

```cpp
//example23.cpp
#include <iostream>
#include <vector>
#include <string>
using namespace std;

vector<string> func()
{
    // return 1;// error: could not convert '1' from 'int' to 'std::vector<std::__cxx11::basic_string<char> >'
    return {"dscs", "csdcd"};
}

int main(int argc, char **argv)
{
    vector<string> vec = func();
    for (auto &str : vec)
    {
        cout << str << endl;
    } // dscs csdcd
    return 0;
}
```

### 返回值类型

```cpp
//example24.cpp
#include <iostream>
#include <string>
using namespace std;

string func(string &str)
{
    return str; //返回str的拷贝
}

int main(int argc, char **argv)
{
    string str = "hello";
    string back = func(str);
    cout << str << " " << back << endl; // hello hello
    str = "apple";
    cout << str << " " << back << endl; // apple hello
    return 0;
}
```

### 返回引用类型

```cpp
//example25.cpp
#include <iostream>
#include <string>

using namespace std;

string &func(string &str)
{
    return str;
}

int main(int argc, char **argv)
{
    string str1 = "hello";
    string &str2 = func(str1);
    cout << str1 << " " << str2 << endl; // hello hello
    str2 = "nike";
    cout << str1 << " " << str2 << endl; // nike nike
    return 0;
}
```

### 不要返回内部对象的引用或指针

为什么这么说呢？知道函数内部的对象是存储在栈内存的，当上下文离开此函数返回调用它的函数时，此函数所使用的栈内存将会被释放，也就是其内部的变量所用的存储空间也将会消失，使用值返回类型，或者堆内存地址，或者此函数外部的资源，在外部才可以访问到。

```cpp
//example26.cpp
#include <iostream>
using namespace std;

//返回内部对象的地址
int *func1()
{
    int num = 999;
    return &num;
}

//返回内部对象的引用
int &func2()
{
    int num = 999;
    return num;
}

int main(int argc, char **argv)
{
    int *num1 = func1();                 //警告
    int &num2 = func2();                 //警告
    cout << num1 << " " << num2 << endl; //出错
    return 0;
}
```

### 返回类类型的函数和调用运算符

什么意思？简单的说我们可以把函数调用的整体视为一个其返回值类型的变量。

```cpp
//example27.cpp
#include <iostream>
#include <string>
using namespace std;

string func()
{
    return string("hello");
}

int main(int argc, char **argv)
{
    cout << func().length() << endl; // 5
    cout << func().empty() << endl;  // 0
    return 0;
}
```

### 引用返回左值

函数的返回类型决定函数调用是否是左值（即可以放在等号左边和右边）

```cpp
//example28.cpp
#include <iostream>
#include <string>
using namespace std;

char &func(string &str, size_t at)
{
    return str[at];
}

int main(int argc, char **argv)
{
    string str = "hello";
    char &ch = func(str, 0);
    ch = 'A';
    // func(str, 0) = 'A';
    cout << str << endl; // Aello
    return 0;
}
```

### 列表初始化vector并返回

C++11中，支持花括号初始化vector

```cpp
//example29.cpp
#include <iostream>
#include <string>
#include <vector>
using namespace std;
vector<string> func(int num)
{
    switch (num)
    {
    case 1:
        return {"a", "b", "c"};
    case 2:
        return {"d", "e", "f"};
    default:
        return {};
    }
}
int main(int argc, char **argv)
{
    vector<string> vec1 = func(1);
    for (auto &str : vec1)
    {
        cout << str << endl; // a b c
    }
    cout << func(3).size() << endl; // 0
    return 0;
}
```

### main函数的返回值

main函数的返回值可以看做是状态指示器，返回0表示执行成功，返回其他值表示执行失败。在cstdlib头文件中定义了两个预处理变量。

```cpp
//example30.cpp
#include <iostream>
#include <cstdlib>
using namespace std;
int main(int argc, char **argv)
{
    int num = 0;
    if (num)
        return EXIT_SUCCESS;
    return EXIT_FAILURE;
}
```

### 递归

如果一个函数调用了它自身，不管这种调用是直接的还是间接的，都称该函数为递归函数。

如下面一个求首项为1，差为1的等差数列的和

```cpp
//example31.cpp
#include <iostream>
using namespace std;

int sum(int num)
{
    if (num <= 1)
        return num;
    return num + sum(num - 1);
}

int main(int argc, char **argv)
{
    cout << sum(4) << endl; // 1+2+3+4=10
    cout << sum(0) << endl; // 0
    cout << sum(2) << endl; // 3
    return 0;
}
```

### 返回数组指针

遇到一个问题，数组应该怎么返回呢？因为数组不能被拷贝，所以函数不能返回数组，但函数可以返回数组的首地址或引用。

### 返回数组的头地址，即返回指针类型

```cpp
//example32.cpp
#include <iostream>
using namespace std;
typedef int Array[10];

int *func(int (&arr)[10])
{
    return arr;
}

int main(int argc, char **argv)
{
    int arr[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0};
    int *ptr = func(arr);
    for (int i = 0; i < 10; i++)
    {
        cout << *(ptr + i) << " ";
    } // 1 2 3 4 5 6 7 8 9 0
    cout << endl;
    return 0;
}
```

### 返回数组的指针

```cpp
//example33.cpp
#include <iostream>
using namespace std;

int (*func())[5]
{
    int(*arr)[5] = (int(*)[5]) new int[5];
    for (int i = 0; i < 5; i++)
        *arr[i] = i;
    return arr;
}

int main(int argc, char **argv)
{
    int arr[5] = {1, 2, 3, 4, 5};
    int(*arr_ptr)[5] = &arr; //数组的指针
    cout << arr_ptr << endl; // 0x61fef8
    cout << arr << endl;     // 0x61fef8
    cout << *arr << endl;    // 1 本质都是第一个元素的地址

    int(*arr_back)[5] = func();
    for (int i = 0; i < sizeof(arr_back); i++)
    {
        cout << *arr_back[i] << " ";
    } // 0 1 2 3
    cout << endl;
    delete arr_back;
    return 0;
}
```

### 使用尾置返回类型

C++11有新特性，尾置返回类型

```cpp
//example34.cpp
#include <iostream>
using namespace std;

//看来有点强啊看着就很舒服对吧,看起来不像C++
auto func() -> int (*)[5]
{
    int(*arr)[5] = (int(*)[5]) new int[5];
    for (int i = 0; i < 5; i++)
    {
        *arr[i] = i * 2;
    }
    return arr;
}

auto main(int argc, char **argv)->int
{
    int(*arr)[5] = func();
    for (int i = 0; i < 5; i++)
    {
        cout << *arr[i] << " ";
    } // 0 2 4 6 8
    cout << endl;
    delete arr;
    return 0;
}
```

### 使用decltype

解决返回数组指针函数的声明

```cpp
//example35.cpp
#include <iostream>
using namespace std;

int arr_int_10[10];

decltype(arr_int_10) *func()
{
    return (int(*)[10]) new int[10];
}

int main(int argc, char **argv)
{
    decltype(arr_int_10) *arr = func();
    for (int i = 0; i < sizeof(arr_int_10) / sizeof(int); i++)
    {
        *arr[i] = i * 3;
        cout << *arr[i] << " ";
    } // 0 3 6 9 12 15 18 21 24 27
    cout << endl;
    delete arr;
    return 0;
}
```

### 函数重载

如果一个作用域内的几个函数名字相同但参数列表不同，称为重载(overloaded)函数

```cpp
//example36.cpp
#include <iostream>
using namespace std;
static void print()
{
    std::printf("print()\n");
}
void print(const char *str)
{
    std::printf("print(\"%s\")\n", str);
}

int main(int argc, char **argv)
{
    print();        // print()
    print("hello"); // print("hello")
    return 0;
}
```

在上面的例子中，有个函数加了static是怎么么回事呢，这样这个函数仅仅在这个cpp文件内有效，也就是说它的作用域仅仅在这个cpp内，而不是我们可执行程序的全局作用域

### 重载和const形参

### 指针const形参

```cpp
//example37.cpp
#include <iostream>
#include <string>
using namespace std;
struct Person
{
    string name;
    int age;
};

//相当于void print(const Person *ptr) ptr拥有底层const
//函数声明时无视指针的顶层const
void print(Person const *ptr)
{
    // ptr->age = 99;//error ptr有底层const
    ptr = nullptr;
    cout << "print Person const*ptr" << endl;
}

// error:: 重复定义void print(Person const *ptr)
// void print(const Person *ptr)
// {
//     cout << "print const Person *ptr" << endl;
// }

void print(Person *ptr)
{
    cout << "print Person*ptr" << endl;
}

int main(int argc, char **argv)
{
    Person person;
    const Person *ptr = &person;
    Person const *ptr1 = &person;
    print(ptr1);    // print Person const *ptr
    print(ptr);     // print Person const *ptr
    print(&person); // print Person*ptr
    return 0;
}
```

### 引用const形参

有一点我们要清楚、指针与引用的最大区别其实是指针不用定义时就初始化，而引用必须被初始化，且引用初始化以后无法更改其绑定的变量，而指针可以更换其绑定的变量。

```cpp
//example38.cpp
#include <iostream>
#include <string>
using namespace std;

void func(string &str)
{
    cout << "func(string &str)" << endl;
}

// void func(const string &str)
// {
//     // str[0] = 'o';//error:: str拥有底层const
//     cout << "func(const string &str)" << endl;
// }

void func(string const &str)
{
    const string str1 = "cd";
    // str = str1;
    // error:: str有底层const 要知道一个非引用类型赋给引用类型是赋值，而非更换引用的绑定
    cout << "func(string const &str)" << endl;
}

int main(int argc, char **argv)
{
    string str = "hello world";
    func(str); // func(string &str)
    const string str1 = "const string str1";
    func(str1); // func(const string &str)
    return 0;
}
```

### const\_cast在函数重载中的用途

什么是const\_cast是不是已经忘记了，他在《第四章 表达式》类型转换内容中，是显式转换

`const_cast`只能改变运算对象的底层const,const\_cast 中的类型必须是指针、引用或指向对象类型成员的指针。

const\_cast回顾

```cpp
//example39.cpp
#include <iostream>
#include <string>
using namespace std;

struct Person
{
    string name;
};

int main(int argc, char **argv)
{
    const int i = 999;
    const int *ptr = &i;
    // int const转非const
    int *j = const_cast<int *>(ptr);
    *j = 1000;
    cout << i << endl;  // 999
    cout << *j << endl; // 1000

    //非const转const
    const int *ptr1 = const_cast<const int *>(j);
    //*ptr1 = 999; //error readonly

    const string str1 = "str1";
    const string &str2 = str1;
    string &str3 = const_cast<string &>(str2);
    cout << str2 << endl; // str1
    cout << str3 << endl; // str1
    str3 = "dscs";
    cout << str2 << endl; // dscs
    cout << str3 << endl; // dscs

    const string const_str = "you";
    const string *const_str1_ptr = &const_str;
    cout << *const_str1_ptr << endl; // you
    string *str1_ptr_casted = const_cast<string *>(const_str1_ptr);
    *str1_ptr_casted = "hello";
    cout << *str1_ptr_casted << endl; // hello
    cout << *const_str1_ptr << endl;  // hello

    const Person person;
    const Person *person_ptr = &person;
    Person *person_ptr_casted = const_cast<Person *>(person_ptr);
    person_ptr_casted->name = "ppp";
    cout << person.name << endl; // ppp

    //对于复合类型在const type*用const_cast转为type*时是解除const
    //对于基本类型如上面的int 转换时 是将其值复制了一份 内存并不共用
    return 0;
}
```

const\_cast在函数重载中的用途

```cpp
//example40.cpp
#include <iostream>
#include <string>
using namespace std;

const string &shorter(const string &s1, const string &s2)
{
    return s1.length() < s2.length() ? s1 : s2;
}

string &shorter(string &s1, string &s2)
{
    //不进行const_cast则会造成递归而不会调用shorter(const string &s1, const string &s2)
    auto &shot = shorter(
        const_cast<const string &>(s1),
        const_cast<const string &>(s2));
    return const_cast<string &>(shot);
}

int main(int argc, char **argv)
{
    string s1 = "abc";
    string s2 = "n";
    string &shot = shorter(s1, s2);
    cout << shot << endl; // n
    return 0;
}
```

### 关于定义冲突与匹配调用

常见冲突

* 指针

```cpp
//1
void calc(int *num, int *c)
{
}
//2
void calc(const int *num, const int *c)
{
}
//3
void calc(int const *num,int const*c){

}
//1 2不冲突 ,1 3 不冲突， 2 3 冲突
```

* 值

```cpp
//1
void calc(int num,int c){

}
//2
void calc(const int num,const int c){

}
//1 2 冲突
```

* 引用 与指针情况类似

当调用重载函数时有三种可能的结果

1、编译器找到一个与实参最佳匹配的函数，并生成调用函数该函数的代码\
2、找不到任何一个函数与调用的实参匹配，此时编译器发出误匹配错误\
3、有多于一个函数可以匹配，但是每一个都不是明显的最佳选择，此时发生错误，称为二义性调用，也就是函数重载重复定义

### 重载与作用域

在C++中重载并不影响作用域，但是还有一种局部函数作用域的情况

```cpp
//example41.cpp
#include <iostream>
using namespace std;

void func(int num);
void func(float num);

int main(int argc, char **argv)
{
    func(1.1f);         // float 1.1
    func(1);            // int 1
    void func(int num); //局部函数声明
    func(1.1f);         // int 1
    //为什么呢？因为其这保留了void func(int num);
    void func(float num);
    func(1);    // int 1
    func(1.1f); // float 1.1
    if (true)
    {
        void func(int num); //局部函数声明作用域为块作用域
        func(1.1f);         // int 1
    }
    return 0;
}

void func(int num)
{
    std::cout << "int " << num << endl;
}

void func(float num)
{
    std::cout << "float " << num << endl;
}
```

为什么要有这种操作呢?这明显不是一种优雅的操作，当想在某个块只允许使用某个函数的重载的一部分时，它往往会有其较好作用，但是我们应该尽量避免这种操作

### 特殊用途语言特性

### 默认实参

只能省略函数尾部形参对应的实参，也就是说实参列表与形参列表是从左面一个一个匹配的

默认实参是从调用者的角度来考虑的，如果调用者直到目标函数的声明里有默认实参，而且开发者并没有提供相应参数，则编译器将会在调用处使用默认实参来充当实际实参传递给目标函数。而不是站在目标函数本身来考虑，有没有实参传过来。

```cpp
//example42.cpp
#include <iostream>
using namespace std;

int func1(int a, int b = 8, int c);

int func(int num = 1, int c = 3)
{
    return num * c;
}

int func1(int a, int b, int c)
{
    return a * b * c;
}

int main(int argc, char **argv)
{
    cout << func() << endl;     // 3
    cout << func(5, 2) << endl; // 10
    cout << func(2) << endl;    // 6
    // func(, 2);//error 只能省略尾部的实参
    // cout << func1(1, 2);//error 只能省略尾部的实参
    return 0;
}
```

### 默认参数初始化

默认参数的初始化是在调用函数时进行的

```cpp
//example43.cpp
#include <iostream>
#include <string>
using namespace std;

int num = 99;

int double_num()
{
    return num * 2;
}

//声明
string func(int a = double_num(),int b = num,char c = '*');

//定义
string func(int a , int b , char c)
{
    cout << a << " " << b << " " << c << endl;
    return "hi";
}

int main(int argc, char **argv)
{
    num++;
    cout << func() << endl; // 200 100 * hi
    return 0;
}
```

### 内联函数和constexpr函数

什么是内联函数？内联函数可以避免函数调用的开销，将函数指定为内联函数，通常将它在每个调用点上“内联地”展开

```cpp
//example44.cpp
#include <iostream>
using namespace std;

inline int &max(int &i, int &j)
{
    return i > j ? i : j;
}

int main(int argc, char **argv)
{
    //在实际程序编译中 max(3,4)被max函数内地内容替代
    cout << max(3, 4) << endl; // 4
    //相当于
    int i = 3;
    int j = 4;
    cout << (i > j ? i : j) << endl;
}
```

增加了程序的大小，但提高了效率

### constexpr函数

也就是返回值为字面值的函数

```cpp
//example45.cpp
#include <iostream>
using namespace std;

constexpr char *func1()
{
    return "hello wrold";
}

constexpr float version()
{
    return 1.12;
}

//返回的不一定是常量，是常量表达式
constexpr int code(int c)
{
    if (c > 0)
    {
        return c * 5;
    }
    return c * 2;
}

constexpr int index(int num)
{
    return num;
}

int main(int argc, char **argv)
{
    cout << func1() << endl; // hello world
    constexpr char *str = func1();
    cout << str << endl;       // hello world
    cout << version() << endl; // 1.12
    int version_ = version();
    cout << version_ << endl; // 1
    cout << code(1) << endl;  // 5
    cout << code(-1) << endl; //-2

    constexpr int length = 10;
    int arr1[length];
    int arr2[index(10)];
    int arr3[index(length)];
    int size = 99;

    int arr4[index(size)]; //虽然没报错，但本质是错误的，index(size)不是常量表达式
    //当constexpr 函数返回值利用形参，当实参传入的也是consexpr时函数才会返回constexpr
    arr4[0] = 322;
    cout << arr4[0] << endl; // 322

    return 0;
}
```

### 内联函数与constexpr函数放在头文件内

与其他函数不同的是，内联函数和constexpr函数可以在程序中多次定义，因为在每个cpp单独编译时，比如内联函数，他就要将代码填充至调用处了，所以constexpr函数与inline函数通常定义在头文件中

### 调试帮助

主要有两种方式，assert和NDEBUG

### assert预处理宏

```cpp
#include<cassert>
assert(expr)
```

首先对expr求值，如果表达式为假即0，assert输出信息并终止程序的执行，如果为真即非0，assert什么也不做

```cpp
//example46.cpp
#include <iostream>
#include <cassert>
using namespace std;
int main(int argc, char **argv)
{
    assert(1 < 2);
    assert(1 > 2);         
    // Assertion failed: 1 > 2, file example46.cpp, line 7
    cout << "end" << endl; //没有被执行
    return 0;
}
```

### NDEBUG预处理变量

assert的形为依赖于一个名为NDEBUG的预处理变量的状态，如果定义了NDEBUG则assert什么也不做，默认情况下没有定义NDEBUG

```cpp
//example47.cpp
#include <iostream>
#include <cassert>
using namespace std;
#define NDEBUG
int main(int argc, char **argv)
{
    assert(1 < 2);
    cout << "end" << endl; // end
#ifdef NDEBUG
    cout << "NDEBUG" << endl; // NDEBUG
#endif
    return 0;
}
```

使用编译器时决定是否define NDEBU

```cpp
g++ example46.cpp -o example46.exe -D NDEBUG && ./example46.exe  
//example46程序输出则assert什么都没有干
end
```

帮助我们调试的宏定义

```cpp
__func__ 编译器定义的局部静态变量，存放函数的名字
__FILE__ 存放文件名的字符串字面值
__LINE__ 存放当前行号的整形字面值
__TIME__ 存放文件编译日期的字符串字面值
__DATE__ 存放文件编译时期的字符串字面值
```

使用样例

也就是说编译后，无论运行多少次，每次的宏所代表的内容是不变的，它们在编译时就已经确定了

```cpp
//example48.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    cout << __func__ << endl; // main
    cout << __LINE__ << endl; // 6
    cout << __FILE__ << endl; // example48.cpp
    cout << __TIME__ << endl; // 11:44:43
    cout << __DATE__ << endl; // May 15 2022
    return 0;
}
```

### 函数匹配

对于函数的调用，对于函数名的不同，编译器当然知道要确切的选择哪一个函数运行，在大多数情况下，确定某次调用应该选用哪个重载函数，当几个函数形参数量相等以及某些形参类型可以由其他类型转换得来时，就没有那么简单了。

如

```cpp
void f();
void f(int);
void f(int,int);
void f(double,double=3.14);
f(5.6);//调用的重载形式为 void f(double,double=3.14)
```

### 确定候选函数和可行函数

1、`寻找候选函数` 选定本次调用对应的重载函数集，集合中的函数称为候选函数，有两个特点，与被调用的函数同名与其声明在调用点可见。\
2、`寻找可行函数` 考察本次提供的实参，从候选函数中选出能被这组实参调用的函数，称为可行函数，有两个特点，其形参数量与本次调用提供的实参数量相等，每个实参的类型与对应的形参类型相同，或者能转换成形参的类型。\
3、`寻找最佳匹配` 从可行函数中选出本次要调用的函数，逐一比较实参与形参的比较，找出最匹配的可行函数。\
4、`匹配成功`，该函数每个实参的匹配都不劣于其他可行函数需要的匹配、至少每一个实参的匹配优于其他可行函数提供的匹配。最后得到的匹配可能不是唯一的，比如对与两个可行函数的参数匹配个数是相同的，则会冲突。

```cpp
//example49.cpp
#include <iostream>
using namespace std;

void func(int a, int b)
{
    cout << "int " << a << " " << b << endl;
}

void func(double a, double b)
{
    cout << "double " << a << " " << b << endl;
}

int main(int argc, char **argv)
{
    //有多个 重载函数 "func" 实例与参数列表匹配:
    // func(1, 1.2);
    // func(1.1, 2);
    func(1, 1);     // int 1 1
    func(1.1, 2.2); // double 1.1 2.2
    return 0;
}
```

### 实参类型转换

编译器将实参类型到形参类型的转换划分成几个等级，具体排序

1、精确匹配

* 实参类型和形参类型相同
* 实参从数组类型或函数类型转换成对应指针类型
* 向实参添加顶层const或者从实参中删除顶层const

2、通过consr转换实现的匹配\
3、通过类型提升实现的匹配\
4、通过算术类型转换\
5、通过类类型转换实现的匹配

### 类型提升和算数类型转换的匹配

```cpp
//example50.cpp
#include <iostream>
using namespace std;

void func(short num)
{
    cout << "short " << num << endl;
}

void func(int num)
{
    cout << "int " << num << endl;
}

void func(long num)
{
    cout << "long " << num << endl;
}

int main(int argc, char **argv)
{
    func('b'); // int 97 char 提升为 int
    func('a'); // int 97 char 提升为 int
    // func(1.14); //冲突 double可转int 或者 long 二义性调用
    return 0;
}
```

### 函数匹配和const实参

* 引用在形参中的const

```cpp
//example51.cpp
#include <iostream>
#include <string>
using namespace std;

void func(const string &str)
{
    cout << "const string " << str << endl;
}

void func(string &str)
{
    cout << "string " << str << endl;
}

int main(int argc, char **argv)
{
    func("hello world"); // const string hello world
    const string str = "hi";
    func(str); // cosnt string hi
    string name = "wanlu";
    func(name); // string wanlu
    return 0;
}
```

* 指针在形参中的const

```cpp
//example52.cpp
#include <iostream>
using namespace std;

void func(const string *ptr)
{
    cout << "cosnt string * " << *ptr << endl;
    ptr = nullptr;
    //*ptr = "hi";//error 存在底层const
}

void func(string *ptr)
{
    cout << "string * " << *ptr << endl;
}

// 此处以第一个func冲突 因为形参会无视顶层const
// void func(string const *ptr)
// {
//     cout << "string const * " << *ptr << endl;
// }

int main(int argc, char **argv)
{
    string str = "hello";
    func(&str); // string * hello
    const string str1 = "hi";
    func(&str1); // const string *hi
    return 0;
}
```

* 基本类型形参中的const\
  当然它们只能是，实参的拷贝，并且本身有底层与顶层const

### 函数指针

本身是为了解决一种callback即回调函数的机制,函数指针指向某种特定的函数类型，函数的类型由它的返回类型和形参类型共同决定，与函数名无关

```cpp
//example53.cpp
#include <iostream>
using namespace std;

float func(int num, float c)
{
    return num * c;
}

int main(int argc, char **argv)
{
    float (*ptr)(int num, float c); //要加括号 否则为ptr函数返回float* 的函数声明
    ptr = &func;
    cout << (*ptr)(1, 2.2) << endl; // 2.2
    return 0;
}
```

注：不同函数类型的指针不存在转换规则

### 重载函数指针

因为不同类型的指针不存在转换规则，则想要指向那个函数，则返回值与形参列表要写得一致

```cpp
//example54.cpp
#include <iostream>
using namespace std;

void func(int num)
{
    cout << "int " << num << endl;
}

void func(double num)
{
    cout << "double " << num << endl;
}

int main(int argc, char **argv)
{
    void (*ptr1)(int num) = &func;
    (*ptr1)(1.2); // int 1
    // void (*ptr2)(double num) = ptr1; //error: 不存在函数指针的转换
    return 0;
}
```

### 函数指针形参

向函数传递函数

```cpp
//example55.cpp
#include <iostream>
using namespace std;

void func(int num)
{
    cout << num << endl;
}

void process(void (*fun)(int num))
{
    cout << "process ";
    fun(666);
}

//看似传递的是一个函数实体，其实并不是，本质上传递与接收的还是函数指针，只不过提供了这样一种写法
void work(void fun(int num))
{
    cout << "work ";
    fun(999);
}

int main(int argc, char **argv)
{
    process(&func); // process 666
    work(func);     // work 999
    process(func);  // process 666
    return 0;
}
```

### typedef、auto、decltype在函数指针的应用

* typedef 与 decltype

```cpp
//example56.cpp
#include <iostream>
using namespace std;

void func(int num);

typedef void SHOWNUM(int num);
typedef decltype(func) SHOWNUM_DECLTYPE;
typedef void (*SHOWNUM_PTR)(int num);
typedef decltype(func) *SHOWNUM_DECLTYPE_PTR;

void func(int num)
{
    cout << "func " << num << endl;
}

int main(int argc, char **argv)
{
    SHOWNUM *ptr = &func;
    (*ptr)(666); // func666
    SHOWNUM_DECLTYPE *ptr1 = ptr;
    (*ptr1)(999); // func 999
    SHOWNUM_DECLTYPE_PTR ptr2 = ptr1;
    SHOWNUM_PTR ptr3 = ptr2;
    (*ptr2)(999); // func 999
    (*ptr3)(777); // func 777
    return 0;
}
```

* auto

```cpp
//example57.cpp
#include <iostream>
using namespace std;

void func(int num);

decltype(func) *get_func()
{
    return &func;
}

void func(int num)
{
    cout << "func " << num << endl;
}

int main(int argc, char **argv)
{
    auto ptr = get_func();
    (*ptr)(666); // func 666
    return 0;
}
```

### 返回指向函数的指针

```cpp
//example58.cpp
#include <iostream>
using namespace std;

void func(int num);
using F_decl = decltype(func);
using F_PTR_decl = decltype(func) *;
using F = void(int);
using F_PTR = void (*)(int);

F *get_func()
{
    return func;
}

auto get_func1() -> F_PTR_decl
{
    return &func;
}

void func(int num)
{
    cout << "func " << num << endl;
}

int main(int argc, char **argv)
{
    F_PTR_decl ptr1 = get_func1();
    F_PTR ptr2 = get_func();
    (*ptr1)(666); // func 666
    (*ptr2)(999); // func 999
    return 0;
}
```

啊！东西这么多，别怕我们要循序渐进，然后在以后的日子里多回顾多复习，多实践。
