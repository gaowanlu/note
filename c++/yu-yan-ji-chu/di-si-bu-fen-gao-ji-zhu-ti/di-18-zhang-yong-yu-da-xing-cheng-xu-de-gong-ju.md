---
cover: >-
  https://images.unsplash.com/photo-1486247496048-cc4ed929f7cc?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHw5fHx0b3VyJTIwZGUlMjBmcmFuY2UlMjAyMDIyfGVufDB8fHx8MTY1OTE5NTAxMQ&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🇨🇳 第18章 用于大型程序的工具

## 第18章 用于大型程序的工具

此章节的主要内容分为三个部分，分别为进一步深入异常处理、命名空间、多重继承与虚继承

### 抛出异常

C++通过抛出(throwing)一条表达式来引发异常，当执行一个throw时，跟在throw后面的语句不再被执行，程序控制权将转移到与之匹配的catch模块。沿着调用链的函数可能会提早退出，一旦程序开始执行异常代码，则沿着调用链创建的对象将被销毁

### 异常捕获栈展开

如果在try内进行throw异常，则会寻找此try语句的catch是否有此异常与之匹配的捕获，如果没有将会转到调用栈的上一级，即函数调用链的上一级，try的作用域内可以有try，会向上级一层一层的找，如果到main还是不能捕获则将会除法标准库函数terminate,即程序终止

```cpp
//example1.cpp
void func2()
{
    try
    {
        throw overflow_error(" throwing a error");
        cout << "3 hello world" << endl;
    }
    catch (range_error &e)
    {
        cout << "1 " << e.what() << endl;
    }
}

void func1()
{
    try
    {
        func2();
    }
    catch (overflow_error &e)
    {
        cout << "2 " << e.what() << endl;
    }
}

int main(int argc, char **argv)
{
    func1(); // 2 throwing a error
    return 0;
}
```

如果异常没有被捕获，则它将终止当前的程序

### 栈展开与内存销毁

在栈展开时，即当throw后离开某些块作用域时，能够自动释放的栈内存将会被释放，但是要保证申请的堆内存释放，推荐使用shared\_ptr与unique\_ptr管理内存

```cpp
//example2.cpp
class Person
{
public:
    int age;
    Person(const int &age) : age(age)
    {
    }
    ~Person()
    {
        cout << "dis Person" << endl;
    }
};

int main(int argc, char **argv)
{
    try
    {
        shared_ptr<Person> p(new Person(1));
        throw runtime_error("m_error");
    }
    catch (runtime_error &e)
    {
        cout << e.what() << endl;
    }
    cout << "end" << endl;
    //程序输出 dis Person m_error end
    return 0;
}
```

### 析构函数与异常

可见在try作用域离开时，其内部的对象的析构函数将会被调用，但是在析构函数中也是可能存在抛出异常的情况。约定俗成，构造函数内应该仅仅throw其自己能够捕获的异常，如果在栈展开的过程中析构函数抛出了异常，并且析构函数本身没有将其捕获，则程序将会被终止

```cpp
//example3.cpp
class Person
{
public:
    ~Person()
    {
        throw runtime_error("");
    }
};

int main(int argc, char **argv)
{
    try
    {
        Person person;
    }
    catch (runtime_error e)
    {
        cout << e.what() << endl;
    }
    //程序出发了terminate标准函数程序终止运行
    return 0;
}
```

### 异常对象

编译器使用异常抛出表达式来对异常对象进行拷贝初始化，其确保无论最终调用的哪一个catch子句都能访问该空间，当异常处理完毕后，异常对象被销毁\
如果一个throw表达式解引用基类指针，而指针实际指向派生类对象，则抛出的对象系那个会被切掉，只有基类部分被抛出

```cpp
//example4.cpp
void func1()
{
    try
    {
        runtime_error e("1");
        throw e; //发生构造拷贝
    }
    catch (runtime_error &e)
    {
        cout << e.what() << endl; // 1
    }
}

void func2()
{
    try
    {
        runtime_error e("2");
        throw &e; ////没有被处理之前其内存不会被释放
    }
    catch (runtime_error *e)
    {
        cout << e->what() << endl; // 2
    }
}

void func3()
{
    try
    {
        runtime_error e("3");
        exception *p = &e;
        throw p; //只抛出基类部分
    }
    catch (exception *e)
    {
        cout << e->what() << endl;
    }
}

int main(int argc, char **argv)
{
    func1();               // 1
    func2();               // 2
    func3();               // 3
    cout << "end" << endl; // end
    return 0;
}
```

### 异常捕获

使用catch子句对异常对象进行捕获，如果catch无须访问抛出的表达式，则可以忽略形参的名字，捕获形参列表可以为值类型、左值引用、指针，但不可为右值引用\
抛出的派生类可以对catch的基类进行初始化、如果抛出的是非引用类型、则异常对象将会切到派生类部分，最好将catch的参数定义为引用类型

### catch子句的顺序

如果在多个catch语句的类型之间存在继承关系，则应该把继承链最底端的类放在前面，而将继承链最顶端的类放在后面

```cpp
//example5.cpp
void func1()
{
    try
    {
        throw runtime_error("1");
    }
    catch (exception &e)
    {
        cout << "1 exception" << endl;
    }
    catch (runtime_error &e)
    {
        cout << "1 runtime_error" << endl;
    }
} //输出 1 exception

void func2()
{
    try
    {
        throw runtime_error("2");
    }
    catch (runtime_error &e)
    {
        cout << "2 runtime_error" << endl;
    }
    catch (exception &e)
    {
        cout << "2 exception" << endl;
    }
} // 2 runtime_error

int main(int argc, char **argv)
{
    func1(); // 1 exception
    func2(); // 2 runtime_error
    return 0;
}
```

### 重新抛出异常

重新抛出就是在catch内对捕获的异常对象又一次抛出，有上一层进行捕获处理,重新抛出的方法就是使用throw语句，但是不包含任何表达式，空的throw只能出现在catch作用域内

```cpp
//example6.cpp
void func1()
{
    try
    {
        throw runtime_error("error");
    }
    catch (runtime_error &e)
    {
        throw; //重新抛出
    }
}

void func2()
{
    try
    {
        func1();
    }
    catch (runtime_error &e)
    {
        cout << "2 " << e.what() << endl;
    }
}

int main(int argc, char **argv)
{
    func2(); // 2 error
    return 0;
}
```

### 捕获所有异常

有时在try代码块内有不同类型的异常对象可能被抛出，但是当这些异常发生时所需要做出的处理行为是相同的，则可以使用catch对所有类型的异常进行捕获

```cpp
//example7.cpp
void func()
{
    static default_random_engine e;
    static bernoulli_distribution b;
    try
    {
        bool res = b(e);
        if (res)
        {
            throw runtime_error("error 1");
        }
        else
        {
            throw range_error("error 2");
        }
    }
    catch (...)
    {
        throw;
    }
}

int main(int argc, char **argv)
{
    for (size_t i = 0; i < 10; i++)
        try
        {
            func();
        }
        catch (range_error &e)
        {
            cout << e.what() << endl;
        }
        catch (...)
        {
            cout << "the error is not range_error" << endl;
        }
    //  the error is not range_error
    //  the error is not range_error
    //  the error is not range_error
    //  error 2
    //  error 2
    //  error 2
    //  the error is not range_error
    //  error 2
    //  the error is not range_error
    //  the error is not range_error
    return 0;
}
```

### try与构造函数

构造函数中可能抛出异常，构造函数分为两个阶段，一个为列表初始化过程，和函数体执行的过程，但是列表初始化时产生的异常怎样进行捕获呢？\
需要写成函数try语句块（也成为函数测试块，function try block）的形式\
要注意的是，函数try语句块catch捕获的是列表中的错误，而不是成员初始化过程中的错误

```cpp
//example8.cpp
class A
{
public:
    shared_ptr<int> p;
    A(int num)
    try : p(make_shared<int>(num)) //当初始化列表中的语句执行抛出异常时
    {
        //或者函数体抛出异常时 下方catch都可以将其捕获
    }
    catch (bad_alloc &e)
    {
        cout << e.what() << endl;
    }
};

int main(int argc, char **argv)
{
    A a(12);
    return 0;
}
```

构造函数try语句会将异常重新抛出

```cpp
//example9.cpp
class A
{
public:
    A()
    try
    {
        throw runtime_error("error1");
    }
    catch (runtime_error &e)
    {
        cout << e.what() << endl;
    }
};

int main(int argc, char **argv)
{
    try
    {
        A a; // error1
    }
    catch (runtime_error &e)
    {
        cout << "main " << e.what() << endl; // main error1
    }
    return 0;
}
```

同样可以用于析构函数

```cpp
//example10.cpp
int func()
{
    throw runtime_error("func");
    return 1;
}

class A
{
public:
    int num;
    A()
    try : num(func())
    {
    }
    catch (runtime_error &e)
    {
        cout << e.what() << endl; // func
    }
    ~A() //可用于析构函数，捕获函数体内的异常
    try
    {
    }
    catch (...)
    {
        cout << "~A error" << endl;
    }
};

int main(int argc, char **argv)
{
    try
    {
        A a;
    }
    catch (runtime_error &e)
    {
        cout << "main " << e.what() << endl; // main func
    }
    return 0;
}
```

### noexcept异常说明

noexcept可以提前说明某个函数不会抛出异常，可以在函数指针的声明、定义中指定noexcept。不能在typedef或类型别名中出现noexcept。在成员函数中，noexcept跟在const及引用限定符之后、在final、overrride或虚函数的=0之前

虽然指定noexcept，但是仍可以违反说明，如果违反则会触发terminate

```cpp
//example11.cpp
void func() noexcept
{
    throw runtime_error(""); // warning: throw will always call terminate()
}

int main(int argc, char **argv)
{
    func();//会触发terminate
    return 0;
}
```

### 为noexcept提供参数

noexcept(true)表示不会抛出异常、noexcept(false)表示可能抛出异常

```cpp
//example12.cpp
void func() noexcept(true)
{
}

void func1() noexcept(false)
{
}

int main(int argc, char **argv)
{
    func();
    func1();
    return 0;
}
```

### noexcept运算符

noexcept是一个一元运算符，返回值为bool类型右值常量表达式

```cpp
//example13.cpp
void func1() noexcept
{
}

void func2() noexcept(true)
{
}

void func3() noexcept(false)
{
    throw runtime_error("");
}

void func4() noexcept
{
    func1();
    func2();
};

void func5(int i)
{
    func1();
    func3();
}

//混合使用
void func6() noexcept(noexcept(func5(9)))
{
}

int main(int argc, char **argv)
{
    cout << noexcept(func1()) << endl; // 1
    cout << noexcept(func2()) << endl; // 1
    cout << noexcept(func3()) << endl; // 0

    cout << noexcept(func4()) << endl; // 1
    //当func4所调用的所有函数都是noexcept,且本身不含有throw时返回true 否则返回false
    cout << noexcept(func5(1)) << endl; // 0
    return 0;
}
```

### noexcept与函数指针、虚函数

函数指针

```cpp
//example14.cpp
void func() noexcept
{
}

void func1() noexcept(false)
{
    throw runtime_error("");
}

void (*ptr1)() noexcept = func; // func与ptr都承诺noexcept
void (*ptr2)() = func;          // func为noexcept ptr不保证noexcept

int main(int argc, char **argv)
{

    ptr1 = func1; //不能像except的赋给nnoexcept函数指针
    ptr2 = func1;
    return 0;
}
```

虚函数,如果基类虚方法为noexcept则派生类派生出的也为noexcept,如果基类为except的则派生类可以指定非noexcept或者noexcept

```cpp
//example15.cpp
class A
{
public:
    virtual void f1() noexcept;
    virtual void f2() noexcept(false);
    virtual void f3(); //默认为noexcept(false)
};

class B : public A
{
public:
    void f1() noexcept override
    {
    }
    void f2() noexcept override
    {
    }
    void f3() noexcept override
    {
    }
};

int main(int argc, char **argv)
{
    B b;
    b.f1(), b.f2(), b.f3();
    return 0;
}
```

### 合成noexcept

当编译器合成拷贝控制成员时，同时会生成一个异常说明，如果该类成员和其基类所有操作都为noexcept,则合成的成员为noexcept的。不满足条件则合成noexcept(false)的。\
在析构函数没有提供noexcept声明，编译器将会为其合成。合成的为与编译器直接合成析构函数提供的noexcept说明相同

### 常见异常类继承关系

![标准exception类层次](<../../../.gitbook/assets/屏幕截图 2022-07-30 230439.jpg>)

exception只定义了拷贝构造函数、拷贝赋值运算符、虚析构函数、what的虚成员，what返回const char\* 字符数组，其为noexcept(true)的\
exception、bad\_cast、bad\_alloc有默认构造函数、runtime\_error、logic\_error无默认构造函数，可以接收C字符数组

### 编写自己的异常类

编写的异常类其的根基类为exception

```cpp
//example16.cpp
class MException : public std::runtime_error
{
public:
    int number;
    MException(const string &s) : runtime_error(s), number(0)
    {
    }
};

int main(int argc, char **argv)
{
    try
    {
        MException e("oop");
        e.number = 999;
        throw e;
    }
    catch (MException &e)
    {
        cout << e.number << endl; // 999
        cout << e.what() << endl; // oop
    }
    return 0;
}
```

### 命名空间

当多个不同的库在一起使用时，及那个名字放置在全局命名空间中将引起命名空间污染，还有可能造成重复定义等。在C中往往使用命名加前缀从定义的名称上来解决，C++中引入了命名空间的概念\
可以使得一个库中的内容更加封闭，不会与其他的内容出现名字冲突

### 命名空间定义

关键词`namespace`，随后为命名空间的名称，然后为花括号。花括号内主要包括，类、变量(及其初始化操作)、函数(及定义)、模板、其他命名空间

```cpp
//example17.cpp
namespace me
{
    class Person
    {
    public:
        int age;
        Person(int age) : age(age) {}
    };
    int num = 999;
    void func()
    {
        cout << num << endl;
    }
}

int main(int argc, char **argv)
{
    me::func();              // 999
    cout << me::num << endl; // 999
    me::Person person(me::num);
    cout << person.age << endl; // 999
    return 0;
}
```

要注意的是，命名空间作用域后面无须分号

### 命名空间一个作用域

每个命名空间是一个独立的作用域，作用域与作用域之间不会产生命名冲突

```cpp
//example18.cpp
namespace A
{
    int num = 999;
}

namespace B
{
    int num = 888;
}

int main(int argc, char **argv)
{
    cout << A::num << " " << B::num << endl; // 999 888
    return 0;
}
```

### 命名空间可以是不连续的

namespace是可以进行重新打开的，并不需要在一个花括号内定义或声明namespace的全部内容

```cpp
//example19.cpp
namespace A
{
    int n1 = 999;
}

namespace A
{
    int n2 = 888;
}

int main(int argc, char **argv)
{
    cout << A::n1 << " " << A::n2 << endl; // 999 888
    return 0;
}
```

通常头文件中命名空间中定义类以及声明作为类接口的函数及对象，命名空间成员的定义置于源文件中

### 正确的定义命名空间

与类的声明定义规范非常相似

```cpp
//example20/main.hpp
#pragma once
namespace A
{
    class Data
    {
    public:
        int num;
        Data(const int &num) : num(num)
        {
        }
        void print();
    };
}
```

```cpp
//example20/main.cpp
#include <iostream>
#include "main.hpp"
using namespace std;

namespace A
{
    void Data::print()
    {
        cout << num << endl;
    }
}

int main(int argc, char **argv)
{
    A::Data data(21);
    data.print(); // 21
    return 0;
}
```

### 定义命名空间成员

完全允许在namespace作用域外定义命名空间成员，但是要显式指出命名空间

```cpp
//example21.cpp
namespace A
{
    void print();
}

void A::print()
{
    cout << "hello world" << endl;
}

int main(int argc, char **argv)
{
    A::print(); // hello world
    return 0;
}
```

或者重新打开命名空间等

```cpp
//example22.cpp
namespace A
{
    void print();
}

namespace A
{
    void print()
    {
        cout << "hello world" << endl;
    }
}

int main(int argc, char **argv)
{
    A::print(); // hello world
    return 0;
}
```

### 模板特例化

在模板章节中，已经有使用过定义模板特例化，模板特例化必须定义在原始模板所属的命名空间中

```cpp
//example23.cpp
class Person
{
public:
    int num;
};

//打开命名空间std
namespace std
{
    template <>
    struct hash<Person>;
}

//定义
template <>
struct std::hash<Person>
{
    size_t operator()(const Person &p) const
    {
        return std::hash<int>()(p.num);
    }
};

int main(int argc, char **argv)
{
    Person p;
    p.num = 888;
    cout << std::hash<Person>()(p) << endl; // 888
    return 0;
}
```

### 全局命名空间

全局命名空间也就是整个全局作用域，全局作用域是隐式的，所以它没有自己的名字

```cpp
//example24.cpp
int num = 999;

void func()
{
    cout << num << endl;
}

int main(int argc, char **argv)
{
    ::num = 888;
    ::func(); // 888
    return 0;
}
```

### 嵌套命名空间

命名空间里面可以有命名空间，也就形成了命名空间的嵌套

```cpp
//example25.cpp
namespace A
{
    namespace B
    {
        int num = 888;
    }
    namespace C
    {
        void print();
    }
}

void A::C::print()
{
    cout << B::num << endl;
}

int main(int argc, char **argv)
{
    A::B::num = 666;
    A::C::print(); // 666
    return 0;
}
```

### 内联命名空间

内联命名空间(inline namespace)是C++11引入的一种新的嵌套命名空间

```cpp
//example26.cpp
inline namespace A
{
    int num = 999;
}

namespace A
{
    void print()
    {
        cout << num << endl;
    }
}

int main(int argc, char **argv)
{
    //通过namespaceA的外层空间的名字即可访问A的num
    cout << ::num << endl; // 999
    A::print();
    //但仍可以指定A::
    cout << A::num << endl; // 999
    ::print();              // 999
    return 0;
}
```

重点：关键字inline必须出现在命名空间第一次定义的地方，后续再次打开可以些inline也可以不写

一种骚操作的写法

```cpp
//example27/A.hpp
#pragma once

inline namespace A
{
    int num = 999;
    string name = "gaowanlu";
}
```

```cpp
//example27/B.hpp
#pragma once
inline namespace B
{
    int num = 888;
}
```

```cpp
//example27/main.cpp
#include <iostream>
using namespace std;

namespace C
{
#include "A.hpp"
#include "B.hpp"
}

int main(int argc, char **argv)
{
    cout << C::A::num << endl; // 999
    cout << C::B::num << endl; // 888
    // cout << C::num << endl;//错误
    cout << C::name << endl; // gaowanlu
    return 0;
}
```

### 未命名的命名空间

未命名的命名空间(unnamed namespace)定义的变量拥有静态生命周期，在第一次使用前创建，并且 直到程序结束才销毁

重点：未命名的命名空间仅在特定的文件内部有效，其作用范围不会横跨多个不同的文件

```cpp
//example28.cpp
#include <iostream>
using namespace std;

int i = 999; //此i是跨文件作用域的

namespace
{
    int i = 888; //此i只在此cpp中有效
}

//在C中往往使用static达到此目的,但C++标准中已经取消了，推荐使用未命名的命名空间
static int num = 666; // num仅在此文件有效

namespace A
{
    namespace
    {
        int i; //在命名空间A中
    }
}

int main(int argc, char **argv)
{
    // cout << i << endl;//错误 出现二义性 编译器不知道是哪一个i
    cout << num << endl; // 666
    A::i = 888;
    cout << A::i << endl; // 888
    return 0;
}
```

### 使用命名空间成员

使用命名空间的成员就要显式在前面指出命名空间，这样的操作往往会显得繁琐，例如使用标准库中的string每次都要在前面指定std::,这样将会过于麻烦，我们已经知道有using这样的操作，下面将会深入学习using

### 命名空间的别名

可以将namespace当做数据类型来为namespace定义新的名字

```cpp
//example29.cpp
namespace AAAAA
{
    int num = 666;
    namespace B
    {
        int num = 999;
    }
}

namespace
{
    namespace A = AAAAA;
    namespace AB = AAAAA::B;
}

int main(int argc, char **argv)
{
    A::num = 888;
    cout << A::num << endl;  // 888
    cout << AB::num << endl; // 999
    return 0;
}
```

### using声明：扼要概述

using声明语句可以出现在全局作用域、局部作用域、命名空间作用域以及类的作用域中\
一条using声明语句一次只能引入命名空间的一个成员

```cpp
//example30.cpp
namespace A
{
    using std::string;
    string name;
}

int main(int argc, char **argv)
{
    A::name = "gaowanlu";
    std::cout << A::name << std::endl; // gaowanlu
    {
        using std::cout;
        using std::endl;
        cout << A::name << endl; // gaowanlu
    }
    return 0;
}
```

### using指示

using namespace xx,using指示一次引入命名空间全部成员\
using指示可以出现在全局作用域、局部作用域、命名空间作用域中，不能出现在类的作用域中

```cpp
//example31.cpp
#include <iostream>
using namespace std;

int i = 999;

namespace A
{
    using namespace std;
    int i = 888;
    string name;
    void print()
    {
        cout << name << endl;
    }
}

int main(int argc, char **argv)
{
    A::name = "gaowanlu";
    A::print(); // gaowanlu

    using namespace A;
    // cout << i << endl;//二义性
    cout << A::i << endl; // 888
    cout << ::i << endl;  // 999
    return 0;
}
```

### 头文件与using声明或指示

在前面的章节我们也有提到，不应该再头文件中的全局作用域部分使用using，因为头文件会被引入到源文件中，造成源文件不知不觉的使用了using\
所以头文件最多只能在它的函数或命名空间内使用using指示或using声明

### 类、命名空间与作用域

在namespace嵌套的情况下，往往容易混淆对作用域的理解

```cpp
//example32.cpp
namespace A
{
    int i = 666;
    namespace B
    {
        int i = 777;
        void print1()
        {
            cout << i << endl;
        }
        void print2()
        {
            int i = 999;
            cout << i << endl;
        }
    }
    void print1()
    {
        // cout << h << endl;//// error: 'h' was not declared in this scope
    }
    void print2();
    int h = 999;
}

void A::print2()
{
    cout << h << endl;
}

int main(int argc, char **argv)
{
    A::B::print1(); // 777
    A::B::print2(); // 999
    A::print2();    // 999
    return 0;
}
```

当namespace中定义类时

```cpp
//example33.cpp
namespace A
{
    int i = 888;
    class B
    {
    public:
        int i = 999;
        void print()
        {
            cout << i << endl;
            // cout << h << endl;// error: 'h' was not declared in this scope
        }
    };
    void print1()
    {
        // cout << h << endl;// error: 'h' was not declared in this scope
    }
    int h = 555;
    void print2()
    {
        cout << h << endl;
    }
}

int main(int argc, char **argv)
{
    A::B b;
    b.print();   // 999
    A::print2(); // 555
    return 0;
}
```

可见namespace中的定义的现后顺序会影响其使用，在使用前必须要已经定义过了

### 实参相关的查找与类累心形参

```cpp
//example34.cpp
#include <iostream>

int main(int argc, char **argv)
{
    {
        std::string s;
        std::cin >> s; //等价于
        std::cout << s << std::endl;
        operator>>(std::cin, s);
        std::cout << s << std::endl;
    }
    return 0;
}
```

这里面有什么关于using的知识呢?operator>>在std命名空间内，为什么没有显式指出std就可以调用了呢，因此除了普通的命名空间作用域查找，还会查找其实参所在的命名空间，所以实参cin在std内，所以会在std中查找时找到，所以调用了std::operator>>

当然可以依旧显式的指出

```cpp
//example35.cpp
#include <iostream>
int main(int argc, char **argv)
{
    {
        using std::operator>>;
        std::string s;
        operator>>(std::cin, s);
    }
    {
        std::string s;
        std::operator>>(std::cin, s);
    }
    return 0;
}
```

### 查找std::move和std::forward

在千前面有提到，使用move与forward时要使用std::move与std::forward，而不省略std。这是因为涉及到实参命名空间推断的问题，如果实参的命名空间中有move或者forward可能会造成意想不到的结果\
约定，总是用std::move与std::forard就好了

### 友元声明与实参相关的查找

一个另外的未声明的类或函数如果第一次出现在友元声明中，则认为它是最近的外层命名空间的成员

```cpp
//example37.cpp
#include <iostream>
using namespace std;

void f2();

namespace A
{
    class C
    {
    private:
        int age = 999;

    public:
        //下面的友元隐式成为A的成员,编译器认为f f2定义在命名空间A中
        friend void f2();
        friend void f(const C &);
    };
    void f(const C &c)
    {
        cout << "f " << c.age << endl;
    }
    // void f2(){
    //     cout << "f2" << endl;
    // }
}

void f2()
{
    A::C c;
    // cout << "f2 " << c.age << endl;
    // error: 'int A::C::age' is private within this context
}

int main(int argc, char **argv)
{
    A::C c;
    A::f(c); // f 999
    // A::f2();//error: 'f2' is not a member of 'A'
    f2();
    return 0;
}
```

### 与实参相关的查找与重载

不仅会向实参的命名空间查找，还会向实参基类所在的命名空间查找

```cpp
//example38.cpp
namespace A
{
    class B
    {
    };
    void print(const B &b)
    {
        cout << "print" << endl;
    }
}

class C : public A::B
{
};

int main(int argc, char **argv)
{
    C c;
    print(c); // print
    return 0;
}
```

### 重载与using声明

using声明关注的是名字，而不关注参数列表

```cpp
//example39.cpp
namespace A
{
    void print()
    {
        cout << "print()" << endl;
    }
    void print(int n)
    {
        cout << "print(n)" << endl;
    }
}

int main(int argc, char **argv)
{
    // using A::print(int);//错误
    using A::print; //正确
    A::print();     // print()
    A::print(12);   // print(n)
    return 0;
}
```

### 重载与using指示

using namespace使得相应命名空间内的成员加入到候选集中

```cpp
//example40/main.cpp
#include <iostream>
using namespace std;

namespace A
{
    extern void print(int);
    extern void print(double);
}

void print(string s)
{
    cout << s << endl;
}

int main(int argc, char **argv)
{
    A::print(10);    // 10
    A::print(23.32); // 23.32
    using namespace A;
    print(10);    // 10
    print(23.32); // 23.32
    print("sds"); // sds
    return 0;
}
// g++ main.cpp other.cpp -o example40.exe
```

当main使用using namespace A;后在main中print有了三个候选项

```cpp
//example40/other.cpp
#include <iostream>
namespace A
{
    void print(int n)
    {
        std::cout << n << std::endl;
    }
    void print(double n);
}

void A::print(double n)
{
    std::cout << n << std::endl;
}
```

### 跨越多个using指示的重载

在一个作用域下，using指示多个命名空间

```cpp
//example41.cpp
#include <iostream>
using namespace std;

void print()
{
}
void print(int n)
{
    cout << "global" << endl;
}

namespace A
{
    int print(int n)
    {
        cout << n << endl;
        return n;
    }
}

namespace B
{
    double print(double d)
    {
        cout << d << endl;
        return d;
    }
}

int main(int argc, char **argv)
{
    {
        using namespace A;
        using namespace B;
        print(); //
        // print(12);   // 二义性
        ::print(12);  // global
        A::print(12); // 12
        print(34.2);  // 34.2
    }
    return 0;
}
```

### 多重继承

多重继承是指从多个直接基类中产生派生类的能力。

```cpp
//example42.cpp
class A
{
public:
    int a;
};

class B
{
public:
    int b;
};

class C : public A, public B
{
public:
    int c;
};

int main(int argc, char **argv)
{
    C c;
    c.a = c.b = c.c = 999;
    cout << c.a << " " << c.b << " " << c.c << endl; // 999 999 999
    return 0;
}
```

实际工程运用中并没有像这样简单

### 使用基类构造函数

与单继承相同，在派生类构造函数初始化列表中可以使用基类的构造函数对相应基类进行初始化

```cpp
//example43.cpp
class A
{
public:
    int age;
    string name;
    A(const int &age, const string &name) : age(age), name(name) {}
};

class B
{
public:
    B(const int &b) : b(b) {}
    int b;
};

class C : public A, public B
{
public:
    C(const int &age, const string &name, const int &b) : A(age, name), B(b)
    {
        //先初始化第一个直接基类A 然后初始化第二个直接基类B
    }
    void print();
};

void C::print()
{
    cout << age << " " << name << " " << b << endl;
}

int main(int argc, char **argv)
{
    C c(20, "gaowanlu", 1);
    c.print(); // 20 gaowanlu 1
    return 0;
}
```

### 继承构造函数

在OOP章节学习过单继承的继承构造函数，在C++11中，允许从多个直接基类继承构造函数

```cpp
//example44.cpp
#include <iostream>
using namespace std;

class A
{
public:
    string s;
    double n;
    A() = default;
    A(const string &s) : s(s)
    {
    }
    A(double n) : n(n) {}
};

class B
{
public:
    B() = default;
    B(const string &s)
    {
    }
    B(int n) {}
};

class C : public A, public B
{
public:
    using A::A;
    using B::B;
};

int main(int argc, char **argv)
{
    C c;
    // C c("s");//错误不知道使用继承的哪一个构造函数A与B都是const string&
    return 0;
}
```

怎样解决这样的构造函数继承冲突，当自身定义了此形式的构造函数时，这个形式的构造函数就不会被继承

```cpp
//example45.cpp
#include <iostream>
using namespace std;

class A
{
public:
    string s;
    double n;
    A() = default;
    A(const string &s) : s(s)
    {
    }
    A(double n) : n(n) {}
};

class B
{
public:
    B() = default;
    B(const string &s)
    {
    }
    B(int n) {}
};

class C : public A, public B
{
public:
    using A::A;
    using B::B;
    C(const string &s) : B(s), A(s) {}
    C() = default;
};

int main(int argc, char **argv)
{
    C c("s");
    cout << c.A::s << endl; // s
    return 0;
}
```

### 构造函数与析构函数执行顺序

当多继承时构造函数的执行顺序与析构函数执行顺序相反

```cpp
//example46.cpp
#include <iostream>
using namespace std;

class A
{
public:
    A()
    {
        cout << "A" << endl;
    }
    ~A()
    {
        cout << "~A" << endl;
    }
};

class B
{
public:
    B()
    {
        cout << "B" << endl;
    }
    ~B()
    {
        cout << "~B" << endl;
    }
};

class C : public A, public B
{
public:
    C()
    {
        cout << "C" << endl;
    }
    ~C()
    {
        cout << "~C" << endl;
    }
};

class D : public B, public A
{
public:
    D()
    {
        cout << "D" << endl;
    }
    ~D()
    {
        cout << "~D" << endl;
    }
};

int main(int argc, char **argv)
{
    {
        C c; // A B C
        D d; // B A D
    }
    //从栈顶依次释放
    //~D ~A ~B
    //~C ~B ~A
    return 0;
}
```

### 多重继承派生类的拷贝与移动

如果派生类没有自定义拷贝与移动操作，编译器将会进行自动合成。并且其基类部分在拷贝或移动时会被基类部分使用基类的相关拷贝与移动操作。\
同理如果自定义了相关操作，编译器则不再为其自动合成

```cpp
//example47.cpp
#include <iostream>
using namespace std;

class A
{
public:
    int a;
    A(const int &a) : a(a)
    {
    }
};

class B
{
public:
    int b;
    B(const int &b) : b(b) {}
};

class C : public A, public B
{
public:
    int c;
    C(int a, int b, int c) : A(a), B(b), c(c)
    {
    }
    void print()
    {
        cout << a << " " << b << " " << c << endl;
    }
};

int main(int argc, char **argv)
{
    C c(1, 2, 3);
    C c1 = c;
    c.print(); // 1 2 3
    return 0;
}
```

### 类型转换与多个基类

基类的指针或引用可以直接指向一个派生类对象

```cpp
//example48.cpp
int main(int argc, char **argv)
{
    // class C : public A, public B
    C c(1, 2, 3);
    //引用
    C &cref = c;
    B &bref = c;
    A &aref = c;
    cout << bref.b << " " << aref.a << endl; // 2 1
    //指针
    B *bptr = &c;
    A *aptr = &c;
    cout << bptr->b << " " << aptr->a << endl; // 2 1
    //值
    B b = c; //只保留基类部分进行拷贝
    A a = c;
    cout << b.b << " " << a.a << endl; // 2 1
    return 0;
}
```

当函数重载遇见多继承可能出现的问题

```cpp
//example49.cpp
void print(A &a)
{
}

void print(B &b)
{
}

int main(int argc, char **argv)
{
    // class C : public A, public B
    C c(1, 2, 3);
    // print(c);//二义性
    B &b = c;
    print(b);
    A &a = c;
    print(a);
    return 0;
}
```

### 多重继承下的类作用域

在单继承中，派生类部分找不到将会去往基类寻找按照继承链向上上找。在多重继承中派生类部分找不到，将会在其直接基类中同时查找，如果找到多个则出现二义性

```cpp
//example50.cpp
class A
{
public:
    int num;
    A(const int &num) : num(num)
    {
    }
};

class B
{
public:
    int num;
    B(const int &num) : num(num) {}
};

class C : public A, public B
{
public:
    C(int num) : A(num), B(num)
    {
    }
    void print()
    {
        cout << A::num << " " << B::num << endl;
    }
};

int main(int argc, char **argv)
{
    C c(12);
    // cout << c.num << endl;//二义性
    //解决方案
    cout << c.A::num << endl; // 12 显式指定
    cout << c.B::num << endl; // 12
    c.print();                // 12 12
    return 0;
}
```

### 虚继承

什么是虚继承？以上的这种多重继承方式，会出现一种问题，对然在直接基类中一个类只能出现依次，但是在整个继承链中，一个类可能会出现多次

```cpp
//example51.cpp
class Person
{
public:
    int age;
};
class Student : public Person
{
};
class Girl : public Person
{
};
class GirlFriend : public Girl, public Student
{
};

int main(int argc, char **argv)
{
    GirlFriend she;
    // she.age;//二义性
    she.Girl::age = 23;
    she.Student::age = 43;
    cout << she.Girl::age << endl;//23
    cout << she.Student::age << endl;//43
    return 0;
}
```

虚继承就是为了解决这种问题的

### 使用虚基类

虚继承的目的就是当出现example51.cpp中的问题时，怎样将在继承链中怎样将Person何为一个实例，而不是Girl部分与Student部分分别继承两个不同的Person实例

虚继承的使用方式就是在派生列表中添加virtual关键字

```cpp
class A:public virtual B;
class A:virtual public B;
```

解决example51.cpp中的问题

```cpp
//example52.cpp
class Person
{
public:
    int age;
};
class Student : public virtual Person
{
};
class Girl : public virtual Person
{
};
class GirlFriend : public Girl, public Student
{
};

int main(int argc, char **argv)
{
    GirlFriend she;
    she.age = 23;
    cout << she.age << endl;
    //只有一个Person实例
    she.Girl::Person::age = 43;
    cout << she.Student::Person::age << endl; // 43
    return 0;
}
```

### 虚继承向基类的常规类型转换

虚继承中派生类向基类的类型转换并不会受到影响

```cpp
//example53.cpp
class Person
{
public:
    int age;
};
class Student : public virtual Person
{
};
class Girl : public virtual Person
{
};
class GirlFriend : public Girl, public Student
{
};

int main(int argc, char **argv)
{
    Student student;
    Person &p1 = student;
    p1.age = 12;
    cout << p1.age << endl; // 12
    GirlFriend she;
    Person *ptr = &she;
    ptr->age = 20;
    cout << ptr->age << endl; // 20
    return 0;
}
```

### 虚基类成员的可见性

在单继承中，查找只当成员时，会从派生类本身部分查找，查找不到就沿着继承链向上查找。但使用了虚继承后，查找到同一个成员的路径不可不止一条，如在example52.cpp中，GirlFriend部分找不到age,向上查找有Student部分、Girl部分，二者都又继承同一个Person实例，总之无论从哪一个查找age最终都是统一个实例

### 构造函数与虚继承

虚继承，虚基类只有一个实例，但是在其派生类的构造函数构造时调用了其构造函数，如果派生类使用构造函数不是相同的时候会怎样呢

```cpp
//example54.cpp
class Person
{
public:
    int age;
    string name;
    Person() = default;
    Person(int age) : age(age) {}
    Person(string name) : name(name) {}
};
class Student : public virtual Person
{
public:
    Student() : Person(12) {}
};
class Girl : public virtual Person
{
public:
    Girl() : Person("sdc") {}
};
class GirlFriend : public Girl, public Student
{
};

int main(int argc, char **argv)
{
    GirlFriend she;
    cout << she.age << endl;  //乱码
    cout << she.name << endl; //""
    //为什么两个构造都没有被成功执行
    return 0;
}
```

因为这样，不仅仅编译器蒙圈了，恐怕我们自己都有点蒙圈。以边让使用Person(12)构造Person实例，一边让用Person("sdc")构造Person实例，那么有没有解决办法呢？

```cpp
//example55.cpp
class Person
{
public:
    int age;
    string name;
    Person() = default;
    Person(int age) : age(age)
    {
        cout << "Person" << endl;
    }
    Person(string name) : name(name)
    {
        cout << "Person" << endl;
    }
};
class Student : public virtual Person
{
public:
    Student() : Person(12)
    {
        cout << "Student" << endl;
    }
};
class Girl : public virtual Person
{
public:
    Girl() : Person("sdc")
    {
        cout << "Gril" << endl;
    }
};
class GirlFriend : public Girl, public Student
{
public:
    GirlFriend() : Student(), Girl(), Person(12)
    {
        cout << "GrilFriend" << endl;
    }
};

int main(int argc, char **argv)
{
    GirlFriend she;
    cout << she.age << endl;  // 12
    cout << she.name << endl; //""
    /*
    Person
    Gril
    Student
    GrilFriend
    */
    //派生类显式调用虚基类的构造函数后就创建了Person实例，在创建Stduent与Gril时不再构造Person
    //直接将继承已经创建的Person实例
    return 0;
}
```

> Note: 虚基类总是先于非虚基类构造，与它们在继承体系中的次序和位置无关

### 构造函数与析构函数的次序

一个类可以继承多个虚基类,它们的构造顺序按照直接基类的声明顺序对其依次检查，确定其中是否含有虚基类，如有则先构造虚基类，然后按照声明顺序依次构造非虚基类

```cpp
//example56.cpp
class A
{
public:
    int a;
    A(const int &a) : a(a)
    {
        cout << "A" << endl;
    }
    ~A()
    {
        cout << "~A" << endl;
    }
};

class B : public virtual A
{
public:
    B() : A(12)
    {
        cout << "B" << endl;
    }
    ~B()
    {
        cout << "~B" << endl;
    }
};

class C
{
public:
    C()
    {
        cout << "C" << endl;
    }
    ~C()
    {
        cout << "~C" << endl;
    }
};

class D : public B, public virtual C
{
public:
    D() : A(13)
    {
        cout << "D" << endl;
    }
    ~D()
    {
        cout << "~D" << endl;
    }
};

int main(int argc, char **argv)
{
    {
        D d; // A C B D
    }        //~D ~B ~C ~A
    return 0;
}
```

总之就是先构造虚基类，虚基类的构造顺序与在继承列表的顺序有关

### 小结

至此我们学习完了第18章 用于大型程序的工具，主要为异常、命名空间、多重继承、虚继承。从第1章到第18章经历了千辛万苦，非常不容易。C++基础，基本剩余第19章 特殊工具与技术了，还有相关泛型算法的查阅表等附录内容。要坚持哦！
