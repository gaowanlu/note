---
cover: >-
  https://images.unsplash.com/photo-1658846702634-da51ac3bad48?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTk0NzQ2MjY&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🚌 第19章 特殊工具与技术

## 第19章 特殊工具与技术

到此你会感觉C++越来越离谱，不好好想着解决问题，语法与特性先成为了一大问题。只能说太复杂了，上手难度较高。

本章分别从，控制内存分配、运行时类型识别、枚举类型、类成员指针、嵌套类、union联合体、局部类、不可移植的特性，入手进行学习

### 重载new和delete

太离谱了吧，new与delete还能重载！先回顾一下new与delete,下面使用到了多维数组的内存动态分配，在C++中new与delete就相当于C中的malloc与free函数

```cpp
//example1.cpp
#include <iostream>
#include <string>
using namespace std;

int main(int argc, char **argv)
{
    string *str = new string();
    delete str;
    int(*m)[5] = new int[5][5];
    m[0][0] = 1;
    m[4][4] = 1;
    cout << m[0][0] << " " << m[4][4] << endl; // 1 1
    delete[] m;
    return 0;
}
```

当用户自定义了new与delete 的operator,则有限使用自定义的，没找到则将寻找new与delete的函数重载，与之前的<,>操作函数类似，否则将会使用标准库中的new、delete

标准库中有4个delete重载、4个new重载

```cpp
void *operator new(size_t);//分配一个对象
void *operator new[](size_t);//分配一个数组
void *operator delete(void*) noexcept;//释放一个对象
void *operator delete[](void*) noexcept;//释放一个数组

void *operator new(size_t,nothrow_t&) noexcept;//分配一个对象
void *operator new[](size_t,nothrow_t&) noexcept;//分配一个数组
void *operator delete(void*,nothrow_t&) noexcept;//释放一个对象
void *operator delete[](void*,nothrow_t&) noexcept;//释放一个数组
```

总之我们左右不了new与delete的行为，我们做的就是写好构造函数与析构函数防止内存泄露

### malloc与free函数

```cpp
#include<cstdlib>
```

例如以下是使用malloc和free编写new与delete的方法

```cpp
//example2.cpp
#include <iostream>
#include <cstdlib>
#include <stdexcept>
using namespace std;

void *operator new(size_t size)
{
    cout << "new memory" << endl;
    if (void *mem = malloc(size))
    {
        return mem;
    }
    else
    {
        throw bad_alloc();
    }
}

void operator delete(void *mem) noexcept
{
    cout << "delete memory" << endl;
    free(mem);
}

int main(int argc, char **argv)
{
    {
        int *num = new int();
        *num = 100;
        cout << *num << endl; // new memory 100
        delete num;
    }
    return 0;
}
```

### 定位new表达式

与allocator类的allocate(size)与deallocate(p,size)的功能有异曲同工之妙。定位new允许在一个特定的、预先分配的内存地址上构造对象

```cpp
new (place_address) type
new (place_address) type (initializers)
new (place_address) type [size]
new (place_address) type [size] {braced initializer list}
```

```cpp
//example3.cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    char *buffer = new char[12];
    int *p1 = new ((void *)buffer) int;
    *p1 = 1;
    cout << (int)buffer[0] << " " << (int)buffer[1] << " " << (int)buffer[2] << " " << (int)buffer[3] << endl;
    //        10000000                  00000000                00000000                00000000
    char *p2 = new ((void *)buffer) char[12]{1, 2, 3, 4};
    cout << (int)p2[0] << (int)p2[1] << (int)p2[2] << (int)p2[3] << endl;
    //        1               2              3           4
    return 0;
}
```

### 显式调用析构函数

构造函数的调用都是在使用栈内存定义变量时或者使用动态内存分配时进行调用，但是以前我们默认认为在内存释放时，析构函数自动调用，但是C++允许显式调用析构函数的操作

显式调用析构函数与allocator的destory(p)方法类似,调用后析构函数被执行，但是内存并没有被释放掉，内存可以重新进行使用

```cpp
//example4.cpp
#include <iostream>
#include <string>
using namespace std;

int main(int argc, char **argv)
{
    string *p1 = new string();
    p1->~string(); //调用构造函数并不释放内存
    *p1 = "dss";
    delete p1;
    // cout << *p1 << endl;//错误 乱码
    int(*m)[5] = new int[4][5];
    return 0;
}
```

### 运行时类型识别

在开发中在程序运行时，有时有需求判断一个变量是那种数据类型\
运行时类型识别(run-time type identification,RTTI),主要有两种方式

1、typeid运算符，返回表达式的类型\
2、dynamic\_cast运算符，将基类指针或引用安全地转为派生类指针或引用

### dynamic\_cast运算符

dynamic\_cast使用形式

```cpp
dynamic_cast<type*>(e);
dynamic_cast<type&>(e);
dynamic_cast<type&&>(e);
//e为nullptr时则返回nullptr
```

### 指针类型dynamic\_cast

指针型dynamic\_cast转换失败时会返回空指针

```cpp
//example5.cpp
#include <iostream>
#include <stdexcept>
using namespace std;

class A
{
public:
    virtual void test() = 0;
};

class B : public A
{
public:
    void test() override {}
};

class C : public A
{
public:
    void test() override {}
    void hello()
    {
        cout << "hello world" << endl;
    }
};

int main(int argc, char **argv)
{
    B *b = new B();
    A *a = b;
    B *b1 = dynamic_cast<B *>(a); // A至少要有一个虚函数

    C *c = dynamic_cast<C *>(a); //去a的基类部分构造c
    c->hello();
    delete c;
    delete b;
    return 0;
}
```

### 引用类型dynamic\_cast

引用类型转换失败则会抛出std::bad\_cast异常

```cpp
//example6.cpp
class A
{
public:
    virtual void test() = 0;
};

class B : public A
{
public:
    void test() override
    {
        cout << "test" << endl;
    }
};

class C : public A
{
public:
    void test() override
    {
        cout << "C" << endl;
    }
};

int main(int argc, char **argv)
{
    B b;
    A &a = b;
    B &b1 = dynamic_cast<B &>(a);
    b1.test(); // test

    try
    {
        C c;
        A &a = c;
        dynamic_cast<B &>(a);
    }
    catch (bad_cast e)
    {
        cout << e.what() << endl; // std::bad_cast
    }
    return 0;
}
```

### RTTI实战

编写自定义类的equal方法

```cpp
//example7.cpp
#include <iostream>
using namespace std;

class A
{
public:
    bool operator==(A &other)
    {
        return typeid(*this) == typeid(other) && this->equal(other);
    }

protected:
    virtual bool equal(A &other)
    {
        return true;
    }
};

class B : public A
{
public:
    int num;
    B(int num) : num(num)
    {
    }

protected:
    bool euqal(A &other)
    {
        auto r = dynamic_cast<B &>(other);
        return num == r.num;
    }
};

class C : public A
{
protected:
    bool euqal(A &other)
    {
        auto r = dynamic_cast<B &>(other);
        return true;
    }
};

int main(int argc, char **argv)
{
    B b(12);
    A &a1 = b;
    A &a2 = b;
    cout << (a1 == a2) << endl; // 1
    C c;
    A &a3 = c;
    cout << (a1 == a3) << endl; // 0 派生类类型不同
    return 0;
}
```

### typeid运算符

typeid运算符返回type\_info对象

```cpp
//example8.cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    int a;
    const type_info &info1 = typeid(a);
    cout << info1.name() << endl; // i

    double d_num;
    const type_info &info2 = typeid(d_num);
    cout << info2.name() << endl; // d

    cout << (info1 == info2) << endl; // 0
    return 0;
}
```

### type\_info类

type\_info的定义可能根据编译器的不同而不同

```cpp
#include<typeinfo>
```

其没有默认构造函数，它的拷贝和移动构造函数、赋值运算符都被定义成了删除的，创建type\_info的唯一途径就是使用typeid操作

![type\_info的操作](<../../../.gitbook/assets/屏幕截图 2022-08-03 171825.jpg>)

```cpp
//example9.cpp
class A
{
public:
    virtual void test(){

    };
};

class B : public A
{
public:
    void test() override
    {
    }
};

int main(int argc, char **argv)
{
    B b;
    cout << typeid(b).name() << endl; // 1B
    A a;
    cout << typeid(a).name() << endl; // 1A
    A &a_ref_b = b;
    cout << typeid(a_ref_b).name() << endl; // 1B
    A *a_ptr_b = &b;
    cout << typeid(a_ptr_b).name() << endl;  // P1A
    cout << typeid(*a_ptr_b).name() << endl; // 1B
    return 0;
}
```

### 枚举类型

C++中有两种枚举：限定作用域和不限定作用域的

1、限定作用域的

```cpp
//example10.cpp
#include <iostream>
using namespace std;

enum class m_enum
{
    a,
    b,
    c,
    d
};

int main(int argc, char **argv)
{
    bool res = m_enum::a == m_enum::b;
    cout << res << endl;                      // 0
    cout << (m_enum::a == m_enum::a) << endl; // 1
    return 0;
}
```

2、不限定作用域的

```cpp
//example11.cpp
#include <iostream>
using namespace std;

enum color //不限作用域
{
    red,
    blue
};

enum //未命名且不限作用域
{
    yellow,
    pink
};

int main(int argc, char **argv)
{
    cout << (red == blue) << endl; // 0
    // cout << (red == yellow) << endl;//warning: comparison between 'enum color' and 'enum<unnamed>'
    // 1
    return 0;
}
```

### 枚举成员

默认情况下枚举值从0开始，依次加1

```cpp
//example12.cpp
#include <iostream>
using namespace std;

enum
{
    red,
    pink
};

enum color
{
    /// red, //冲突
    // pink
    black
};

enum class person
{
    man,
    woman
};

int main(int argc, char **argv)
{
    color c1 = black;
    person p1 = person::man;
    // color c2 = red;//错误
    return 0;
}
```

### 自定义枚举成员的值

默认从0依次加1，但允许用户自定义值

```cpp
//example13.cpp
#include <iostream>
using namespace std;

enum class color
{
    pink,
    red = 12,
    black,
    blue = 3
};

int main(int argc, char **argv)
{
    color c1 = color::black;
    color c2 = color::red;
    cout << (int)c1 << endl;          // 13
    cout << (int)c2 << endl;          // 12
    cout << (int)color::pink << endl; // 0
    return 0;
}
```

### 枚举成员与常量表达式

枚举成员为const，所以在初始化枚举成员时提供的初始值必须为常量表达式，每个枚举成员本身就是一条常量表达式

```cpp
//example14.cpp
#include <iostream>
using namespace std;

enum class color
{
    red,
    pink
};

int main(int argc, char **argv)
{
    const int n = 100;
    constexpr int num = n;
    cout << num << endl; // 100

    constexpr color c1 = color::pink;
    color c2 = color::red;
    c2 = color::pink;
    return 0;
}
```

### 枚举类型转换

非限定作用域与限定作用域二者有些区别

```cpp
//example15.cpp
#include <iostream>
using namespace std;

enum class color
{
    red,
    pink
};

enum
{
    black
};

enum m
{
    blue
};

int main(int argc, char **argv)
{
    int n1 = blue;
    cout << n1 << endl; // 0
    int n2 = black;

    // int n3 = color::red;//错误
    m m1 = blue;

    return 0;
}
```

### 指定enum的类型

默认枚举值的类型都是整形,但可以自己指定类型

```cpp
//example16.cpp
#include <iostream>
using namespace std;

enum color : unsigned long long
{
    red = 4343ULL,
    black = 4343
};

int main(int argc, char **argv)
{
    color::black;
    return 0;
}
```

### 枚举类型前置声明

和函数一样，枚举类型可以进行前置声明

```cpp
//example17.cpp
#include <iostream>
using namespace std;

//前置声明
enum class color; //限定作用域型默认使用int
// enum m;//错误 非限定作用域必须指定类型成员
enum m : int;

void func()
{
    // black;//错误
    // m::blue; //错误 error: 'blue' is not a member of 'm'
    // color::pink;//错误 error: 'pink' is not a member of 'color'
} //使用枚举成员前应该已经定义

enum class color
{
    red,
    pink
};

enum
{
    black
};

enum m : int
{
    blue
};

int main(int argc, char **argv)
{
    func();
    return 0;
}
```

### 形参匹配与枚举类型

枚举成员值也可以作为函数参数，要注意的细节就是枚举类型与数值类型的转换，其中涉及到函数的重载匹配问题

```cpp
//example18.cpp
#include <iostream>
using namespace std;

enum Color : int
{
    red,
    pink
};

void func(int num)
{
    cout << "num " << num << endl;
}

void func(Color color)
{
    cout << "color " << (int)color << endl;
}

void func_num(int func_num)
{
    cout << "func_num " << func_num << endl;
}

int main(int argc, char **argv)
{
    Color c1 = Color::red;
    func(c1);          // color 0
    func(0);           // num 0
    func(Color::pink); // color 1

    func_num(0);           // func_num 0
    func_num(Color::pink); // func_num 1

    //限定作用域型则严格遵守类型，不会进行向数值类型的自动转换，形参必须为相应的枚举类型
    //而不是数值类型，因为非限定型可以向数值类型自动转换
    return 0;
}
```
