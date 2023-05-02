---
coverY: 0
---

# 🚜 你可能不知道的C++

## 小技巧&#x20;

### 当C函数与成员函数重名时 ::name() 的作用

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

C++中的虚函数表（Virtual Function Table）是用于实现多态性的一种机制，也称为虚函数表或VTBL。

每个包含虚函数的类都有一个对应的虚函数表，该表是一个由指向虚函数地址的指针构成的数组。当一个对象被创建时，会为它分配一块内存空间，其中包含了一个指向虚函数表的指针，这个指针称为虚指针（VPointer）。

当一个对象被调用其虚函数时，C++编译器会根据对象的虚指针找到对应的虚函数表，并在表中查找与函数名匹配的函数地址，然后调用该函数。这个查找过程保证了程序能够正确地调用正确的虚函数，即使对象的实际类型在运行时才能确定。

虚函数表的存在使得C++中的多态性得以实现。当一个派生类对象被当做其基类对象来使用时，调用基类的虚函数会自动地调用派生类的重写函数，这样可以实现基类接口的扩展和灵活性。

### delete void*

我们可能在动态内存中delete void*，来释放内存，要知道其操作是不会执行对象的析构函数的,如果需要执行析构函数需要将void*转换为其他数据类型

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

### delete与free的区别

delete是C++中的操作符，用于释放使用new运算符分配的动态内存，它不仅仅只是释放内存，还会调用析构函数，对对象进行一些清理工作，从而避免内存泄漏和资源泄漏等问题。

free是C语言中的函数，用于释放使用malloc函数分配的动态内存，它只是释放内存，不会调用对象的析构函数，因此不适用于C++中的对象。

### new与malloc的区别

new是C++中的操作符，用于在堆上分配动态内存，并调用对象的构造函数进行初始化，返回一个指向该对象的指针。使用new运算符分配的内存可以使用delete运算符来释放。

malloc是C语言中的函数，用于在堆上分配指定大小的内存块，并返回一个指向该内存块的指针。由于malloc函数不会调用构造函数，因此它不能用于分配对象，而只适用于分配内存块。使用malloc函数分配的内存块可以使用free函数来释放。同时，malloc返回的指针类型是void*，需要显式转换为所需类型的指针。
