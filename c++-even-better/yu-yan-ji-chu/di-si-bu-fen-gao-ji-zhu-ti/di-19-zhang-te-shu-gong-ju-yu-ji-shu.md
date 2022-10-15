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
    A():num(0){}
    virtual void test() = 0;
protected:
    int num;
};

class B : public A
{
public:
    void test() override {}
    void show() {
        cout << ++num << endl;
    }
};

class C : public A
{
public:
    void test() override {}
    void hello()
    {
        cout << "hello world" << endl;
    }
    void show() {
        cout << ++num << endl;
    }
};

int main(int argc, char** argv)
{
    B* b = new B();
    A* a = b;

    B* b1 = dynamic_cast<B*>(a); // A至少要有一个虚函数
    b1->show();//1

    C* c = dynamic_cast<C*>(a); //去a的基类部分构造c
    //通过c只能访问基类的部分
    c->hello();//hello
    //c->show();错误

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

### 右值引用dynamic\_cast

```cpp
//example5.cpp
#include <iostream>
#include <stdexcept>
using namespace std;

class A {
public:
    virtual ~A(){}
    void run() {
        cout << "hello world" << endl;
    }
};

class B:public A {
public:
    B(){}
    ~B(){}
    void run() {
        cout << "bbb" << endl;
    }
};


int main(int argc, char** argv)
{
    A&& a = B();
    a.run();//hello world
    B&& b = dynamic_cast<B&&>(a);
    b.run();//bbb
    return 0;
}
```

### RTTI实战

编写自定义类的equal方法

```cpp
//example7.cpp
#include <iostreadym>
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

### 数据成员指针

成员指针(pointer to member)是指向类的非静态成员的指针\
大白话来讲到底是什么玩意呢？通俗的理解，有一种指针只能指向特定数据成员的属性

```cpp
//example19.cpp
class A
{
public:
    string content;
};

int main(int argc, char **argv)
{
    const string A::*ptr; // ptr可以指向A的对象中的string成员
    ptr = &A::content;    //进一步指定指向content属性
    //简单点就是 auto prt=&A::content
    
    A aObj;
    aObj.content = "hello";
    
    auto s = aObj.*ptr; //通过.获取aObj中的content成员
    A *aptr = &aObj;
    
    s = aptr->*ptr;    //通过指针->获取成员
    
    cout << s << endl; // hello
    s = "oop";
    cout << aObj.content << endl; // hello
    return 0;
}
```

### 返回数据成员指针的函数

可以将数据成员指针抽象为类的静态方法

```cpp
//example20.cpp
#include <iostream>
using namespace std;

class A
{
public:
    string contents;
    static const std::string A::*getContentsPointer()
    {
        return &A::contents;
    }
};

int main(int argc, char **argv)
{
    A a;
    A b;
    a.contents = "hello";
    b.contents = "world";
    const string A::*ptr = A::getContentsPointer();
    cout << a.*ptr << endl; // hello
    cout << b.*ptr << endl; // world
    return 0;
}
```

### 成员函数指针

有数据类型的指针，有函数类型的指针。那么也为成员函数的指针

```cpp
//example21.cpp
#include <iostream>
using namespace std;

class A
{
public:
    void test() const
    {
        cout << "hello world" << endl;
    }
    int test1(int a, double b)
    {
        return 0;
    }
};

int main(int argc, char **argv)
{
    auto ptr = &A::test; // void (A::*ptr)()
    // ptr指向A中返回void没有函数参数的成员函数
    auto ptr1 = &A::test1;
    // int (A::*ptr1)(int a, double b)
    void (A::*ptr2)() const = &A::test;
    return 0;
}
```

### 使用成员函数指针

与成员指针的适用方式是类似的

```cpp
//example22.cpp
class A
{
public:
    void test()
    {
        cout << "hello world" << endl;
    }
};

int main(int argc, char **argv)
{
    A a, *ap = &a;
    auto test_ptr = &A::test;
    (a.*test_ptr)();   // hello world
    (ap->*test_ptr)(); // hello world
    // a.*test_ptr();     //错误 根据优先级等价于 a.*(test_ptr())
    return 0;
}
```

### 使用成员指针的类型别名

由于成员指针的类型名称长度比较长，可以适用using为其起别名处理

```cpp
//example23.cpp
class A
{
public:
    string content;
    void test() const
    {
        cout << content << endl;
    }
};

using test = void (A::*)() const;
using content = string A::*;

int main(int argc, char **argv)
{
    content ptr1 = &A::content;
    test ptr2 = &A::test;
    A a;
    a.*ptr1 = "sd";
    (a.*ptr2)(); // sd
    return 0;
}
```

### 成员指针函数表

这是一种管理类方法的一种编程技巧，看起来下面的程序非常高级，C++菜鸟是看不懂的，想成为大牛像这种demo一定要学习到然后转化为自己的知识

```cpp
//example24.cpp
class A
{
public:
    using Action = A &(A::*)(); //为A的成员函数指针起别名
    enum Flag
    {
        UP,
        DOWN,
        LEFT,
        RIGHT
    };
    A &move(Flag f);
    A &up()
    {
        cout << "UP" << endl;
        return *this;
    }
    A &down()
    {
        cout << "DOWN" << endl;
        return *this;
    }
    A &left()
    {
        cout << "LEFT" << endl;
        return *this;
    }
    A &right()
    {
        cout << "RIGHT" << endl;
        return *this;
    }

private:
    static Action Menu[];
};

A::Action A::Menu[] =
    {
        &A::up,
        &A::down,
        &A::left,
        &A::right};

A &A::move(A::Flag f)
{
    return (this->*Menu[f])();
}

int main(int argc, char **argv)
{
    A a;
    a.move(A::UP);    // UP
    a.move(A::DOWN);  // DOWN
    a.move(A::LEFT);  // LEFT
    a.move(A::RIGHT); // RIGHT
    return 0;
}
```

### 将成员函数用作可调用对象

学习过函数指针可以赋值给可调用对象，成员函数也是可以的

```cpp
//example25.cpp
#include <iostream>
#include <string>
#include <functional>
using namespace std;

int main(int argc, char **argv)
{
    auto ptr1 = &string::empty; // bool (std::string::*ptr1)() const noexcept
    string str;
    cout << boolalpha << (str.*ptr1)() << endl; // true
    //使用function生成一个可调用对象
    function<bool(const string &)> fn = &string::empty;
    cout << fn(str) << endl; // true
    // mem_fn生成一个可调用对象
    auto empty = mem_fn(&string::empty);
    // std::_Mem_fn<bool (std::string::*)() const noexcept> empty
    cout << empty(str) << endl; // true
    return 0;
}
```

### 使用function生成一个可调用对象

可以将函数的地址赋给function对象

```cpp
#include <iostream>
#include <string>
#include <functional>
using namespace std;

int main(int argc, char **argv)
{
    auto ptr1 = &string::empty; // bool (std::string::*ptr1)() const noexcept
    string str;
    cout << boolalpha << (str.*ptr1)() << endl; // true
    //使用function生成一个可调用对象
    function<bool(const string &)> fn = &string::empty;
    cout << fn(str) << endl; // true
    // mem_fn生成一个可调用对象
    auto empty = mem_fn(&string::empty);
    // std::_Mem_fn<bool (std::string::*)() const noexcept> empty
    cout << empty(str) << endl; // true
    return 0;
}
```

### 使用mem\_fn生成一个可调用对象

可以将成员函数的地址传递给mem\_fn然后返回可调用对象

```cpp
//example26.cpp
#include <iostream>
#include <string>
#include <functional>
using namespace std;

int main(int argc, char **argv)
{
    auto ptr1 = &string::empty; // bool (std::string::*ptr1)() const noexcept
    string str;
    cout << boolalpha << (str.*ptr1)() << endl; // true
    //使用function生成一个可调用对象
    function<bool(const string &)> fn = &string::empty;
    cout << fn(str) << endl; // true
    // mem_fn生成一个可调用对象
    auto empty = mem_fn(&string::empty);
    // std::_Mem_fn<bool (std::string::*)() const noexcept> empty
    cout << empty(str) << endl; // true
    return 0;
}
```

### 使用bind生成一个可调用对象

在前面泛型算法章节有过学习

```cpp
//example26.cpp
#include <iostream>
#include <functional>
using namespace std;

class A
{
public:
    static void test(int n)
    {
        cout << n << endl;
    }
};

int main(int argc, char **argv)
{
    auto f = bind(&A::test, placeholders::_1);
    f(1); // 1
    return 0;
}
```

### 嵌套类

一个类可以被定义在一个类的内部，前者被称为嵌套类或嵌套类型

### 声明一个嵌套类

与普通类的声明类似，只不过声明在一个类的声明作用域内

```cpp
//example27.cpp
#include <iostream>
using namespace std;

class A
{
public:
    class B; //访问权限为public
};

class A::B
{
};

int main(int argc, char **argv)
{
    A a;
    A::B b;
    return 0;
}
```

### 在外层类之外定义一个嵌套类

嵌套类的作用域内，可以直接使用外层类的成员，无须对成员的名字进行限定

```cpp
//example28.cpp
#include <iostream>
#include <string>
using namespace std;

class A
{
public:
    class B;

private:
    using NAME = string;
    static const string name;
};

const string A::name = "A";

class A::B
{
public:
    B &test()
    {
        NAME str = "hello ";
        cout << str << name << endl; // hello A
        return *this;
    }
};

int main(int argc, char **argv)
{
    A a;
    A::B b;
    b.test(); // hello A
    return 0;
}
```

### 定义嵌套类的成员

理应当将嵌套类的成员函数与其声明分开定义

```cpp
//example29.cpp
#include <iostream>
#include <string>
using namespace std;

class A
{
public:
    class B;

private:
    using NAME = string;
    static const string name;
};

const string A::name = "A";

class A::B
{
public:
    B &test();
};

A::B &A::B::test()
{
    NAME str = "hello ";
    cout << str << name << endl; // hello A
    return *this;
}

int main(int argc, char **argv)
{
    A a;
    A::B b;
    b.test(); // hello A
    return 0;
}
```

### 嵌套类的静态成员定义

静态属性的定义与常规做法相似

```cpp
//example30.cpp
#include <iostream>
using namespace std;

class A
{
public:
    class B;
    using name_type = string;
};

class A::B
{
public:
    static const name_type name;
    void test();
};

const A::name_type A::B::name = "hello world";

void A::B::test()
{
    cout << name << endl;
}

int main(int argc, char **argv)
{
    A::B b;
    b.test(); // hello world
    return 0;
}
```

### 嵌套类作用域中的名字查找

嵌套类本身可以在外层类中使用,嵌套类内部也可以访问外层类中的类型,可以访问外层的嵌套类类型和静态成员

```cpp
//example31.cpp
#include <iostream>
using namespace std;

class A
{
public:
    class B;
    class C;

private:
    string name = "a";
};

class A::C
{
public:
    string name = "c";
};

class A::B
{
public:
    C c; //找不到回去外层寻找
    void test();
};

void A::B::test()
{
    A a;
    cout << a.name << endl; //嵌套类可以访问外层类的私有成员
}

int main(int argc, char **argv)
{
    A::B b;
    cout << b.c.name << endl; // c
    b.test();                 // a
    return 0;
}
```

### 嵌套类和外层类是相互独立的

嵌套类的嵌套是嵌套类被放在了外部类中，更像为嵌套类加了一个外层类的限定，但定义外层类类型变量是并不会将在其中定义外层类的对象与成员，二者之间的成员是独立的\
二者之间的成员访问权限又互相影响

### union联合体

union联合体是C语言中的内容，它是一种特殊的类，一个union可以有多个数据成员，但在任意时刻只有一个数据成员有值，当给某个成员赋值之后，其他成员变为未定义状态，分配给union对象的存储空间至少为能容纳最大的数据成员

C++11中，可以有构造函数和析构函数，可以指定public、protected和private等保护标记，默认是public的。union不能继承其他类，也不能被继承，其内不能有虚函数

### 定义union

语法与定义class类型类似

```cpp
//example32.cpp
#include <iostream>
using namespace std;

union T
{
    char ch;
    float fl;
    double dl;
};

int main(int argc, char **argv)
{
    T t;
    t.ch = 'p';
    cout << t.dl << endl; // 1.79168e-307
    cout << t.fl << endl; // 8.99968e-039
    cout << t.ch << endl; // p
    t.dl = 232;
    cout << t.ch << endl; //
    cout << t.fl << endl; // 0
    cout << t.dl << endl; // 232
    return 0;
}
```

### 使用union类型

union可以使用花括号显式初始化

```cpp
//example33.cpp
#include <iostream>
using namespace std;

union T
{
    int in;
    double dl;
    char ch;
};

int main(int argc, char **argv)
{
    T t1 = {'p'};
    T t2 = {12};
    T *t3 = new T;
    t3->ch = 'p';
    delete t3;
    return 0;
}
```

### 匿名union

匿名union是未命名的union，一旦定义了匿名union，编译器会自动地创建一个未命名地对象

匿名union的定义所在的作用域内该union的成员都是可以直接访问的，不能包含受保护的成员或私有成员，也不能定义成员函数

```cpp
//example34.cpp
#include <iostream>
using namespace std;

//必须静态声明全局或命名空间范围的匿名联合

static union
{
    char ch;
    double dl;
};

int main(int argc, char **argv)
{
    ch = 'p';
    cout << ch << endl; // p
    cout << dl << endl; //乱码
    return 0;
}
```

### 含有类类型成员的unino

```cpp
//example35.cpp
#include <iostream>
#include <string>
using namespace std;

union A
{
    string str;
    int a;
};

int main(int argc, char **argv)
{
    A a1("p"); //错误
    A a2("s"); //错误
    return 0;
}
```

为什么是错误的呢？union的成员只有普通内置成员时，可以进行拷贝，赋值等操作。当内部拥有复杂数据类型时，且数据类型有默认构造构造函数或拷贝控制成员时，union默认构造函数为delete的，默认析构函数也是delete的，解决方法显式定义union的默认构造函数和析构函数

```cpp
//example36.cpp
#include <iostream>
#include <string>
using namespace std;

union A
{
    string str;
    int a;
    A(const string &s)
    {
        new (&str) std::string(s);
    }
    A(const int &n)
    {
        a = n;
    }
    A &operator=(const A &a)
    {
        str = a.str;
        return *this;
    }
    ~A()
    {
        str.~string();
    }
};

int main(int argc, char **argv)
{
    A a(12);
    cout << a.a << endl; // 12
    A a1(string("dd"));
    cout << a1.str << endl; // dd
    return 0;
}
```

### C++中正确使用union的风格

在C++基于OOP思想，可以对union及其操作进行封装抽象，但通常使用union更多的是使用基本数据类型，进而可以省去很多麻烦

只是用普通数据类型

```cpp
//example37.cpp
#include <iostream>
using namespace std;

union T
{
    int n;
    double dl;
};

int main(int argc, char **argv)
{
    T t1;
    t1.n = 12;
    T t2 = t1;
    cout << t2.n << endl; // 12
    return 0;
}
```

C++使用类进行管理

```cpp
//example38.cpp
#include <iostream>
using namespace std;

class Token
{
public:
    //默认将联合体存放int
    Token() : tok(INT), ival{0} {}
    //拷贝构造
    Token(const Token &t) : tok(t.tok) { copyUnion(t); }
    Token &operator=(const Token &t)
    {
        if(t.tok==STR&&this->tok==STR){
            this->sval=t.sval;
        }else{
            tok = t.tok;
            copyUnion(t);
        }
        return *this;
    }
    ~Token()
    {
        if (tok == STR)
            sval.~string(); //显式调用析构函数
    }
    Token &operator=(const std::string &);
    Token &operator=(char);
    Token &operator=(int);
    Token &operator=(double);

private:
    union
    {
        char cval;
        int ival;
        double dval;
        std::string sval;
    }; //匿名类 成员作用域
    enum
    {
        INT,
        CHAR,
        DBL,
        STR
    } tok; //判别式
    void copyUnion(const Token &);
};

void Token::copyUnion(const Token &t)
{
    if (this->tok == Token::STR)
        this->sval.~string();
    switch (t.tok)
    {
    case Token::INT:
        this->operator=(t.ival);
        break;
    case Token::CHAR:
        this->operator=(t.cval);
    case Token::DBL:
        this->operator=(t.dval);
    case Token::STR:
        this->operator=(t.sval);
    default:
        break;
    }
}

Token &Token::operator=(const std::string &str)
{
    if (this->tok == Token::STR)
        this->sval.~string();
    new (&this->sval) string(str);
    return *this;
}

Token &Token::operator=(char ch)
{
    if (this->tok == Token::STR)
        this->sval.~string();
    this->cval = ch;
    return *this;
}

Token &Token::operator=(int in)
{
    if (this->tok == Token::STR)
        this->sval.~string();
    this->ival = in;
    return *this;
}

Token &Token::operator=(double dl)
{
    if (this->tok == Token::STR)
        this->sval.~string();
    this->dval = dl;
    return *this;
}

int main(int argc, char **argv)
{
    Token token;
    token = "string";
    token = 23;
    token = 'c';
    token = 23.4;
    Token token_copy = token;
    return 0;
}
```

可见这种设计已经违背了出中，这些方法本身所占用的内存已经超过了数据本身的大小，这是非常不值得的一件事。

### 局部类

名字好熟悉，因为刚学习了嵌套类，类可以定义在某个函数内部，成这样的类为局部类，局部类定义的类型只在它的作用域内可见，和嵌套类不同，局部类收到严格限制

重点：局部类的所有成员(包括函数在内)都必须完整定义在类的内部，布局类不允许声明static数据成员,因为无法定义这样的成员

### 局部类不能使用函数作用域中的变量

局部类对外部作用域的内容的访问有很大限制，只能访问外部定义的类型名，静态变量，枚举类型，普通局部变量不允许访问

```cpp
//example39.cpp
#include <iostream>
using namespace std;

void func()
{
    struct A
    {
        int a;
        int b;
        ostream &operator<<(ostream &os) const
        {
            os << a << " " << b << endl;
            return os;
        }
    };
    class B
    {
    public:
        int a;
        int b;
        ostream &operator<<(ostream &os)
        {
            os << a << " " << b << endl;
            return os;
        }
    };
    A a;
    a.a = 1, a.b = 2;
    B b;
    b.a = 1, b.b = 2;
    a << cout; // 1 2
    b << cout; // 1 2
}

int main(int argc, char **argv)
{
    func();
    return 0;
}
```

### 常规的访问保护规则对局部类同样适用

对于局部类内部的类成员的访问权限，都适用，如public、private、protected

### 局部类中的名字查找

与其他类似，首先在局部类内部寻找，找不到则取外部作用域查找，没找到则依次向外找

### 嵌套的局部类

嵌套的局部类就是在局部类中定义嵌套类,嵌套类必须定义在于局部类相同的作用域中，局部类内的嵌套类也是一个局部类

```cpp
//example40.cpp
#include <iostream>
using namespace std;

void func()
{
    struct A
    {
        class B;
    };
    class A::B
    {
    public:
        int n;
    };
    A::B b;
    b.n = 999;
    cout << b.n << endl; // 999
};

int main(int argc, char **argv)
{
    func();
    return 0;
}
```

### 固有的不可移植的特性

不可移植的特性是指，因为机器不同的特性，将含有不可移植特性的程序从一台机器转移到另一台机器通常会重新编写程序\
主要有从C语言继承的特性，位域和volatile，还有C++的特性 链接指示

### 位域

什么是位域？如果你是一位嵌入式工程师可能会更熟悉，类或结构体可以将非静态数据成员定义为位域，每个位域含有一定的二进制位，通常用于串口通信等，位域在内存的布局与机器相关

```cpp
//example41.cpp
#include <iostream>
using namespace std;

//位域的类型必须为整形或者枚举类型
typedef unsigned int Bit;
class Block
{
public:
    Bit mode : 2; //占两个二进制位
    Bit modified : 1;
    Bit prot_owner : 3;
    Bit prot_group : 3;
    Bit prot_world : 3;
};

int main(int argc, char **argv)
{
    Block block;
    &block.modified;
    // error: attempt to take address of bit-field
    return 0;
}
```

取址运算符&,不能作用于位域，任何指针都不能指向位域

### 使用位域

位域的访问方式，与其他数据成员类似

```cpp
//example42.cpp
#include <iostream>
using namespace std;

//位域的类型必须为整形或者枚举类型
typedef unsigned int Bit;
class Block
{
public:
    Bit mode : 2;     //占两个二进制位 存储的大小范围为[0,3]
    Bit modified : 1; //存储的大小范围为[0,1]
    enum modes
    {
        READ = 1,
        WRITE = 2,
        EXECUTE = 3
    };
    Block &open(modes);
    bool isRead();
    void setWrite();
    void write();
};

void Block::write()
{
    modified = 1;
}

Block &Block::open(Block::modes mode_)
{
    mode |= READ;
    if (mode_ & WRITE)
        setWrite();
    return *this;
}

bool Block::isRead()
{
    return mode & READ;
}

void Block::setWrite()
{
    mode |= WRITE;
}

int main(int argc, char **argv)
{
    Block block;
    block.setWrite();
    cout << block.mode << endl;
    return 0;
}
```

### volatile限定符

volatile的最重要的作用是，读取数据时都使用指令从新从内存中读取最新数据，不考虑缓存机制，如下面的情景

```cpp
//example43.cpp
int main(int argc, char **argv)
{
    volatile int flag = 0;
    int a = flag;
    //没有改变过flag
    int b = flag;
    return 0;
}
```

如果flag不是volatile的，则在a与b之间编译器认为flag并没有改变，则会做出优化，将在a=flag读出的flag值赋给b。使用volatile之后，每次读取flag值，都是使用从新从内存读取值

volatile的关键字使用有点类似于const

```cpp
//example44.cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    volatile int v;
    int *volatile vip; // volatile指针 指向int
    volatile int *ivp; //指向volatile int的指针
    volatile int *volatile vivp;
    //指向volatile int的指向volatile指针

    // int *p1 = &v;
    //"volatile int *" 类型的值不能用于初始化 "int *" 类型的实体

    ivp = &v;
    vivp = &v;

    // int &i = *ivp;
    //错误

    volatile int &i = *ivp; //正确

    return 0;
}
```

### 合成的拷贝对volatile对象无效

合成的拷贝/移动构造函数及赋值运算符不能默认接收volatile对象，因为默认合成的函数接收const Name\&name形式，并不是volatile,进而也不可能将volatile对象绑定到引用，方法就是重载相关操作符

```cpp
//example45.cpp
#include <iostream>
using namespace std;

class T
{
public:
    T() = default;
    T &operator=(const T &) = default;
    //将volatile赋给非volatile
    T &operator=(volatile const T &t)
    {
        cout << "1" << endl;
        return *this;
    }
    //将volatile赋给volatile
    volatile T &operator=(volatile const T &t) volatile
    {
        cout << "2" << endl;
        return *this;
    }
};

int main(int argc, char **argv)
{
    T t;
    T t1 = t;
    volatile T t2;
    t = t2; // 1
    volatile T t3;
    t3 = t2; // 2
    return 0;
}
```

### 链接指示extern "C"

C++使用链接指示(linkage directive)指出任意非C++函数所用的语言

### 声明一个非C++的函数

链接指示有两种形式，单个的和复合的

```cpp
//example46.cpp
#include <iostream>
using namespace std;

// C++头文件<cstring>中的链接指示
// 以下声明的函数是使用C语言实现的
extern "C" size_t strlen(const char *);
extern "C"
{
    int strcmp(const char *, const char *);
    char *strcat(char *, const char *);
}

int main(int argc, char **argv)
{
    int size = strlen("dscs");
    cout << size << endl; // 4
    return 0;
}
```

有的编译器还支持Ada、FORTRAN等

### 链接指示与头文件

相当于将string.h内的C头文件声明，使用C语言链接指示

```cpp
//example47.cpp
#include <iostream>
using namespace std;

extern "C"
{
#include <string.h>
}

int main(int argc, char **argv)
{
    cout << strlen("sds") << endl; // 3
    return 0;
}
```

### 指向extern "C" 函数的指针

对于函数指针可以加extern "C"对函数指针的指向加以约束

```cpp
//example48.cpp
#include <iostream>
using namespace std;

extern "C"
{
    void test();
}

void test()
{
    cout << "hello world" << endl;
}

extern "C"
{
    void (*ptr2)();
}

void test_other()
{
}

int main(int argc, char **argv)
{
    test(); // hello world
    void (*ptr)() = test;
    ptr(); // hello world

    ptr2 = test; // ptr2指向C函数
    ptr2();      // hello world
    void (*ptr3)() = ptr2;
    ptr3(); // hello world
    return 0;
}
```

### 链接指示对整个声明都有效

```cpp
//example49.cpp
#include <iostream>
using namespace std;

extern "C"
{
    void test()
    {
        cout << "hello world" << endl;
    }
    void func(void (*)());
    //给func传递的void(*)()也应该是C函数
    //链接指示对整个声明都有效
}

void func(void (*test)())
{
    test();
}

void test_other()
{
    cout << "hello world" << endl;
}

int main(int argc, char **argv)
{
    test();           // hello world
    func(test_other); // hello world
    func(test);       // hello world
    return 0;
}
```

### 导出C++函数到其他语言

```cpp
//example50.cpp
#include <iostream>
using namespace std;

extern "C" void test()
{
}
// test函数可被C程序调用

int main(int argc, char **argv)
{
    test();
    return 0;
}
```

c++条件编译 \_\_cplusplus宏

```cpp
//example51.cpp
#include <iostream>
using namespace std;

#ifdef __cplusplus
extern "C"
#endif
    int
    strcmp(const char *, const char *);

int main(int argc, char **argv)
{
    cout << strcmp("a", "b") << endl; //-1
    return 0;
}
```

### 重载函数与链接指示

C语言中没有函数重载的特性

```cpp
//example52.cpp
#include <iostream>
using namespace std;

extern "C" int strcmp(const char *, const char *);
void strcmp()
{
    cout << "hello world" << endl;
}

int main(int argc, char **argv)
{
    cout << strcmp("a", "b") << endl; //-1
    strcmp();                         // hello world
    return 0;
}
```
