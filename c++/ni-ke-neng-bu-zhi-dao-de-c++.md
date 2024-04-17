---
coverY: 0
---

# 🚜 你可能不知道的 C++

## 你可能不知道的 C++

各种超级骚操作

### 当 C 函数与成员函数重名时 ::name() 的作用

```cpp
#include<iostream>
using namespace std;

void func(){
    cout<<"void func()"<<endl;
}

class A{
public:
    void func(){
        ::func();// void func() class C function
        //this->func(); //class member function
        //func(); //class member function
    }
};

```

### 为什么通常把基类的析构函数写为虚函数

在进行动态绑定时，可能造成内存泄露

```cpp
#include <iostream>
using namespace std;

class Base
{
public:
    Base()
    {
    }
    ~Base()
    {
        cout << "Base" << endl;
    }
};

class A : public Base
{
public:
    A()
    {
    }
    ~A()
    {
        cout << "A" << endl;
    }
};

int main(int argc, char **argv)
{
    {
        Base base; // Base
        A a;       // A Base

        A *a_ptr = new A();
        Base *p = a_ptr;
        delete p; // Base

        //~A并没有被调用
        //如果A内申请了堆内存 则没有调用析构函数释放 则会造成内存泄露
    }
    return 0;
}
```

使用虚函数解决问题

```cpp
#include <iostream>
using namespace std;

class Base
{
public:
    Base()
    {
    }
    virtual ~Base()
    {
        cout << "Base" << endl;
    }
};

class A : public Base
{
public:
    A()
    {
    }
    virtual ~A()
    {
        cout << "A" << endl;
    }
};

class B : public A
{
public:
    ~B()
    {
        cout << "B" << endl;
    }
};

int main(int argc, char **argv)
{
    {
        Base base; // Base
        A a;       // A Base

        B *b_ptr = new B();
        Base *p = b_ptr;
        delete p; // B A Base
        //调用析构函数时析构函数如果为虚函数则从继承链向下找到不是虚函数为止
        //然后依次沿着继承链向上调用
    }
    return 0;
}
```

### 虚函数表

C++中的虚函数表（Virtual Function Table）是用于实现多态性的一种机制，也称为虚函数表或 VTBL。

每个包含虚函数的类都有一个对应的虚函数表，该表是一个由指向虚函数地址的指针构成的数组。当一个对象被创建时，会为它分配一块内存空间，其中包含了一个指向虚函数表的指针，这个指针称为虚指针（VPointer）。

当一个对象被调用其虚函数时，C++编译器会根据对象的虚指针找到对应的虚函数表，并在表中查找与函数名匹配的函数地址，然后调用该函数。这个查找过程保证了程序能够正确地调用正确的虚函数，即使对象的实际类型在运行时才能确定。

虚函数表的存在使得 C++中的多态性得以实现。当一个派生类对象被当做其基类对象来使用时，调用基类的虚函数会自动地调用派生类的重写函数，这样可以实现基类接口的扩展和灵活性。

### delete void\*

我们可能在动态内存中 delete void*，来释放内存，要知道其操作是不会执行对象的析构函数的,如果需要执行析构函数需要将 void*转换为其他数据类型

```cpp
#include <iostream>
using namespace std;

class Person
{
public:
    char *data;
    Person();
    ~Person();
};

Person::Person()
{
    data = new char[10];
}

Person::~Person()
{
    cout << "~Person" << endl;
    delete[] data;
}

int main(int argc, char **argv)
{
    Person *person = new Person();
    void *person_ptr = person;
    // delete person_ptr;//不会执行析构函数，造成内存泄露
    delete static_cast<Person *>(person_ptr); //~Person
    return 0;
}
```

### delete 与 free 的区别

delete 是 C++中的操作符，用于释放使用 new 运算符分配的动态内存，它不仅仅只是释放内存，还会调用析构函数，对对象进行一些清理工作，从而避免内存泄漏和资源泄漏等问题。

free 是 C 语言中的函数，用于释放使用 malloc 函数分配的动态内存，它只是释放内存，不会调用对象的析构函数，因此不适用于 C++中的对象。

### new 与 malloc 的区别

new 是 C++中的操作符，用于在堆上分配动态内存，并调用对象的构造函数进行初始化，返回一个指向该对象的指针。使用 new 运算符分配的内存可以使用 delete 运算符来释放。

malloc 是 C 语言中的函数，用于在堆上分配指定大小的内存块，并返回一个指向该内存块的指针。由于 malloc 函数不会调用构造函数，因此它不能用于分配对象，而只适用于分配内存块。使用 malloc 函数分配的内存块可以使用 free 函数来释放。同时，malloc 返回的指针类型是 void\*，需要显式转换为所需类型的指针。

### 为什么声明的变量没有被默认初始化

真是个好问题，但是和 `placement new(A*ptr=new(addr)A;)` 机制关系不大，

有这样一种说法，C++栈变量不会被默认初始化 就连基础类型也不行,
因为栈上初始化每个变量会带来一定性能开销(这么以来编译器为了性能优化居然这么变态)。

在 C++ 中，当定义变量时，会根据以下规则进行默认值初始化：

1. 如果变量是一个非静态的局部变量，且未进行初始化，则其将不会被默认初始化，其值是未定义的。
2. 如果变量是一个静态的局部变量，或者是一个全局变量(包括全局静态变量)，则会被默认初始化为其类型的默认值。例如，整型变量将被初始化为0，浮点型变量将被初始化为0.0，指针变量将被初始化为nullptr，而对象将被调用默认构造函数。
3. 如果变量是一个数组，则每个元素都将按照上述规则进行初始化。

需要注意的是，C++11 之前，如果变量是一个非静态的局部变量，且未进行初始化，则其将不会被默认初始化，其值是未定义的。因此，在定义变量时，最好显式地进行初始化，以确保其值是可预测的。

C++中的默认值初始化规则并不一致，需要根据变量的定义方式和位置来确定其是否会被默认初始化。

如果要使用`placement new`需要在构造函数初始化列表中显式初始化，变量后使用 `= 或者 {}` 初始化。

如果执行的构造函数有初始化列表 且也初始化了其已经使用 `= 或 {}`,则使用初始化列表中的忽略 `= 或 {}` 提供的默认值。

使用`placement new` 就在构造函数中或初始化列表中 或使用 `= {}`  为成员变量进行初始化。

总之在C++项目中 自定义类 一定要为成员变量显式初始化，不然可能有各种意想不到的结果。

在C项目中 struct 一般都会用一下 `bzero()` 或者 memset 或者 写一个newfunction 内部对各个字段初始化一下。

对于这种操作内存的语言，有一丝丝相信编译器都是犯罪。

```cpp
#include <iostream>
#include <cstdlib>
#include <cstring>

using namespace std;

class A
{
public:
    A()
    {
    }
    ~A()
    {
    }
    int n;
    int n1;
};

int main()
{
    void *mem = ::malloc(sizeof(A));
    if (!mem)
    {
        exit(EXIT_FAILURE);
    }

    memset(mem, 1, sizeof(A));

    A *ptrA = new (mem) A;
    cout << ptrA->n << endl;
    cout << ptrA->n1 << endl;

    ptrA->~A();
    free(mem);

    return 0;
}

// 会发现 输出了 16843009 和 16843009

// class A
// {
// public:
//     A() : n(99)
//     {
//     }
//     ~A()
//     {
//     }
//     int n{9};
//     int n1 = 100;
// };
// // 会输出 n=99 n1=100
```

### 成员指针运算符`::*`

`::*` 是 C++ 中的成员指针运算符，它用于声明指向类成员的指针。其实这种骚操作尽量不要用，不要用。

1、 指向成员变量的指针

```cpp
int MyClass::*ptr = &MyClass::memberVariable;
```

这里 `MyClass::*` 声明了一个指向 MyClass 类中的成员变量的指针。ptr 就是指向 memberVariable 的指针。

2、指向成员函数的指针

```cpp
int (MyClass::*ptr)() = &MyClass::memberFunction;
```

这里 `int (MyClass::*)()` 声明了一个指向 MyClass 类中的成员函数的指针。ptr 就是指向 memberFunction 成员函数的指针。

成员变量使用样例

```cpp
#include <iostream>
using namespace std;

struct A
{
    int a;
};

int main(int argc, char **argv)
{
    int(A::*ptr_a) = &A::a;
    A obj{.a = 23};
    std::cout << (obj.*ptr_a) << std::endl; // 23
    A obj1{.a = 999};
    std::cout << obj1.a << std::endl; // 999
    obj1.*ptr_a = 888;
    std::cout << obj1.a << std::endl; // 888
    return 0;
}
```

成员函数使用样例

```cpp
#include <iostream>
using namespace std;

class Shape
{
public:
    virtual void draw() const = 0;
    int gid{0};
};

class Circle : public Shape
{
public:
    void draw() const override
    {
        std::cout << "Drawing Circle" << std::endl;
    }
};

class Square : public Shape
{
public:
    void draw() const override
    {
        std::cout << "Drawing Square" << std::endl;
    }
};

void drawAllShapes(const Shape *shapes[], size_t numShapes, void (Shape::*drawFunction)() const)
{
    for (size_t i = 0; i < numShapes; ++i)
    {
        (shapes[i]->*drawFunction)();
    }
}

int main(int argc, char **argv)
{
    Circle circle;
    Square square;
    const Shape *ptr_arr[] = {&circle, &square};
    auto arr_ptr = &ptr_arr; // const Shape *(*arr_ptr)[2]
    drawAllShapes(*arr_ptr, 2, &Shape::draw);
    drawAllShapes(*arr_ptr, 2, &Shape::draw);
    drawAllShapes(*arr_ptr, 2, &Shape::draw);
    // Drawing Circle
    // Drawing Square
    // Drawing Circle
    // Drawing Square
    // Drawing Circle
    // Drawing Square
    auto circle_draw = &Circle::draw;
    ((Circle *)ptr_arr[0]->*circle_draw)();
    // Drawing Circle
    return 0;
}
```
