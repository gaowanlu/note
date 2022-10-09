---
coverY: 0
---

# 你可能不知道的C++

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
