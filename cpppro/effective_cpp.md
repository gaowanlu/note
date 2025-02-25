# Effective C++

改善程序与设计的55个具体做法

## 让自己习惯 C++

### 1、视 C++为一个语言联邦

C++是一个多重范型编程语言，支持过程形式、面向对象形式、函数形式、泛型形式、元编程形式，C++高效编程守则视状况而变化，取决于使用C++哪一个部分，在合适的场景选择使用合适的功能

### 2、尽量以 const、enum、inline 替换 define

C开发中以前都在使用宏定义define,但是往往难以维护而且难以调试

* 对于单纯常量，最好以const对象或enums替换define
* 对于形似函数的宏，最好改用inline函数替换define

```cpp
#define ASPECT_RATIO 1.653
//使用const替换
const double AspectRatio = 1.653;
```

const的底层const与顶层const要知道

```cpp
const char* const authorName = "Scott Meyers";//字符串用const代替宏
//cpp等推荐使用string,更加抽象
const std::string authorName("Scott Meyers");
```

对于类内的可以使用静态成员变量

```cpp
class A{
private:
    static const int Num = 5;//常量声明式
    int scores[Num];
};
```

如果不使用A::Num的地址，那么只使用声明式即可，如果要用地址则需要定义式在源文件中

```cpp
const int A::Num;//Num定义，声明时已经提供初值，定义式不再需要提供初值
//如果编译器不支持声明式初始化，则要在定义式提供初值
```

类内的enum更像define，不能取值

```cpp
class A
{
public:
    enum
    {
        Num = 4
    };
    int arr[Num];
};

int main(int argc, char **argv)
{
    cout << A::Num << endl; // 4
    return 0;
}
```

关于define写函数形式的一些问题，尽量使用inline，一般inline函数写在头文件中，因为源文件编译时需要将函数展开

```cpp
#define MAX(a, b) (a) > (b) ? (a) : (b)

int main(int argc, char **argv)
{
    int n = MAX(1, 2);
    cout << n << endl; // 2
    // int n1 = MAX(n++, ++n); 这种问题容易混乱
    return 0;
}
//尽可能使用inline函数，也可以使用模板进行扩展
//函数也能展开，而且利于开发维护
template <typename T>
inline T mymax(const T &a, const T &b)
{
    return a > b ? a : b;
}
```

### 3、尽可能使用 const

* 将某些东西声明为const可帮助编译器侦测出错误用法，const可以被施加于任何作用域内的对象、函数参数、函数返回类型、成员函数本体
* 虽然方法内禁止修改对象属性，但是可以返回属性的引用，如果方法为const的里应当返回const类型
* 当const和non-const成员函数有着等价的实现时，令non-const版本调用const版本可以避免代码重复，用static_cast和const_cast解决

const有顶层const（一般为指针不能修改）与底层const（数据不能修改），

```cpp
char greeting[] = "hello"; 
char *p = greeting;//none-const pointer,non-const data
const char* p =greeting;//non-const pointer,const data
char* const p = greeting;//const pointer,non-const data
const char* const p = greeting;//const pointer,const data
```

有两种形式的表达的意思是相同的,都是data const

```cpp
void func(char const *p);
void func(const char*p);
```

函数返回常量值的作用

```cpp
class A
{
public:
    A(const int &n) : num(n)
    {
    }
    int num;
    const A operator*(const A &o)
    {
        return A(this->num * o.num);
    }
};

int main(int argc, char **argv)
{
    A a(1);
    A b(2);
    A c = a * b;
    //(a * b) = 3;           // 错误：操作数类型为: const A = int，如果返回的不是const值则不报错
    cout << c.num << endl; // 2
    return 0;
}
```

const成员函数

```cpp
class A
{
public:
    static const int num{9};
    char arr[num] = {0};
    const char &operator[](std::size_t position) const
    {
        return arr[position];
    }
    char &operator[](std::size_t position)
    {
        return arr[position];
    }
};

int main(int argc, char **argv)
{
    A a;
    const A b;
    cout << a[0] << endl; // 调用char &A::operator[]
    cout << b[0] << endl; // 调用 const char &A::operator[]
    // b[0] = '1'; 错误
    a[0] = 'a';
    cout << a[0] << endl; // a
    return 0;
}
```

在const和non-const成员函数中避免重复,可以让non-const调用const成员函数

```cpp
class A
{
public:
    static const int num{9};
    char arr[num] = {0};
    const char &operator[](std::size_t position) const
    {
        //...
        // ...
        return arr[position];
    }
    char &operator[](std::size_t position)
    {
        return const_cast<char &>(static_cast<const A &>(*this)[position]);
    }
};
```

### 4、确定对象被使用前已经被初始化

* 为内置型对象进行手工初始化，因为C++不保证初始化它们
* 构造函数最好使用成员初值列，而不是在构造函数本体使用赋值操作，初值列列出的成员变量，其排列次序应该和它们在class中的声明次序相同
* 为免除“跨编译单元之初始化次序”问题，请以local static对象替换non-local static对象

```cpp
int n;
cout << n << endl;
```

会输出什么，大部分都会说0，但是不一定，有随机性，不能相信机器与编译器，加上个初始值不会杀了你

为什么要使用初始化列表，而不是在构造函数内赋值

```cpp
class A
{
public:
    A()
    {
        cout << "A()" << endl;
    }
    A(const int &n)
    {
        cout << "A(const int &n)" << endl;
    }
    const A &operator=(const int &n)
    {
        cout << "const A &operator=(const int &n)" << endl;
        return *this;
    }
};

class B
{
public:
    B()
    {
        a = 1; // 这是赋值不是初始化
    }
    A a;
};

int main(int argc, char **argv)
{
    B b;
    // A()
    // const A &operator=(const int &n)
    return 0;
}
```

如果使用构造函数列表,It's fucking cool.特别注意的是初始化列表为什么要与在类内声明的顺序相同，这是因为它们构造的现后顺序并不取决于在初始化列表中的顺序而是在类内声明的顺序所以我们写代码直接把二者顺序同步好了。

```cpp
class B
{
public:
    B() : a(1)
    {
    }
    A a;
};

int main(int argc, char **argv)
{
    B b;
    // A(const int &n)
    return 0;
}
```

什么是local-static对象和non-local static对象，栈内存与堆内存对象都不是static对象。像全局对象、定义在命名空间作用域内的、在class内的、在函数内的、以及在源文件作用域内的被声明为static的对象。其中在函数内的为local-static其他为non-local static。程序结束时static会被自动销毁，析构函数在main返回前调用

可能有时会使用extern访问在其他源文件定义的对象,如果一个源文件中某个non-local static对象初始化时用到了另一个源文件中的non-local static对象，可能会出现赋值操作右边的变量没有初始化过的情况，因为C++中：对于“定义于不同源文件内的non-local static对象”的初始化次序并无明确定义

```cpp
//mian.cpp
extern int n;
int n1=n;
//main1.cpp
int n;
```

怎样解决这一问题,推荐使用local static代替non-local static

```cpp
//main.cpp
int n1=n();
//main1.cpp
int& n(){
    static int v=100;
    return v;
}
```

上面例子可能还不清楚看下面这个

```cpp
//main.cpp
#include <iostream>
#include "main1.h"
#include "main2.h"
using namespace std;

int main(int argc, char **argv)
{
    return 0;
}
//main1.h
#pragma once

class main1
{
public:
    main1();
};
//main1.cpp
#include "main1.h"
#include <iostream>

main1 main1Object;

main1::main1()
{
    std::cout << "main1" << std::endl;
}
//main2.h
#pragma once
#include "main1.h"

class main2
{
private:
    /* data */
public:
    main2(/* args */);
};
//main2.cpp
#include "main2.h"
#include <iostream>

main2 main2Object;

main2::main2(/* args */)
{
    std::cout << "main2" << std::endl;
}
```

请问main1和main2谁先输出，答案是不确定的,所以总之记住全局变量之间不要互相引用初始化，特别是在不同源文件中的不同全局变量。

```cpp
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ g++ -c main1.cpp
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ g++ -c main2.cpp
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ g++ -c main.cpp
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ g++ main.o main1.o main2.o -o main.exe
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ ./main.exe
main1
main2
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ g++ main.o main2.o main1.o -o main.exe
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ ./main.exe
main2
main1
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ 
```

还心存执念，那你循环引用下，初始化肯定有问题吧，n1在main.cpp,n2在main1.cpp,n1用n2初始化，n2用n1初始化。这样虽然能编译，能运行，但它们的初始化确实有问题。

## 构造析构赋值运算

### 5、了解 C++默默编写并调用哪些函数

* 编译器可以暗自为class创建default构造函数、copy构造函数、copy assignment操作符、析构函数，默认生成为inline的。

默认生成这些函数是C++的基础知识，应该问题不大，当程序中使用这些函数时编译器才会生成，如果自己声明了自定义的相关函数则编译器不再自动生成默认的对应函数

```cpp
class A
{
public:
    A() {}
    ~A() {}
    A(const A &a)
    {
        this->num = a.num;
    }
    A &operator=(const A &a)
    {
        this->num = a.num;
        return *this;
    }
    int num;
};
```

### 6、若不想使用编译器自动生成的函数应明确拒绝

* 为驳回编译器自动提供的机能，可将相应的成员函数声明为private并且不予实现，使用像Uncopyable这样的基类也是一种办法。

```cpp
//写为private,只声明不定义
class A
{
public:
    A() {}
    ~A() {}

private:
    A(const A &a); // 只声明不定义
    A &operator=(const A &a);
};
//使用delete关键词
class B
{
public:
    B() {}
    ~B() {}
    B(const B &b) = delete;
    B &operator=(const B &b) = delete;
};
int main(int argc, char **argv)
{
    A a;
    A b;
    // a = b; 错误
    return 0;
}
```

还可以使用Uncopyable基类的方式,在基类进行拷贝构造和赋值时，会先执行基类的相关函数

```cpp
class A
{
public:
    A() {}
    A(const A &a)
    {
        cout << "A(const A&a)" << endl;
    }
    A &operator=(const A &a)
    {
        cout << "A& operator=(const A&a)" << endl;
        return *this;
    }
    virtual ~A() = default;
};

class B : public A
{
public:
    B() {}
    B(const B &b) : A(b)
    {
        cout << "B(const B&b)" << endl;
    }
    B &operator=(const B &b)
    {
        if (&b != this)
        {
            A::operator=(b);
        }
        cout << "B &operator=(const B &b)" << endl;
        return *this;
    }
    ~B() = default;
};

int main(int argc, char **argv)
{
    B b1;
    B b2 = b1;
    // A(const A&a)
    // B(const B &b)
    return 0;
}
```

那么就可以写一个Uncopyable基类

```cpp
class A
{
public:
    A() {}
    virtual ~A() = default;

private:
    A(const A &a);
    A &operator=(const A &a);
};

class B : public A
{
public:
    B() {}
    ~B() = default;
    // 理应当自动生成拷贝构造和赋值操作函数，但是由于不能访问基类部分，所以不能自动生成
};

int main(int argc, char **argv)
{
    B b1;
    // B b2 = b1;
    // 无法引用 函数 "B::B(const B &)" (已隐式声明) -- 它是已删除的函数
    return 0;
}
```

### 7、为多态基类声明 virtual 析构函数

* 带有多态性质的基类(polymorphic base classes)应该声明一个virtual析构函数，如果class带有任何virtual函数，它就应该拥有一个virtual析构函数
* 如果类的设计目的不是作为基类使用，或不是为了具备多态性，就不该声明virtual析构函数

先看以下有什么搞人的事情，深入理解此部分要对虚函数表以及C++多态机制有一定了解,下面的代码只执行了基类的析构函数只是释放了基类中buffer的动态内存，而派生类部分内存泄露，这是因为`A*a`,a被程序认为其对象只是一个A,而不是B,如果将基类析构函数改为virtual的，那么会向下找，找到~B执行，然后再向上执行如果虚函数有定义的话

```cpp
class A
{
public:
    A() : buffer(new char[10])
    {
    }
    ~A()
    {
        cout << "~A()" << endl;
        delete buffer;
    }

private:
    char *buffer;
};

class B : public A
{
public:
    B() : buffer(new char[10])
    {
    }
    ~B()
    {
        cout << "~B()" << endl;
        delete buffer;
    }

private:
    char *buffer;
};

int main(int argc, char **argv)
{
    A *a = new B;
    delete a;
    //~A()
    return 0;
}
```

所以要修改为这样，即可

```cpp
class A
{
public:
    A() : buffer(new char[10])
    {
    }
    virtual ~A()
    {
        cout << "~A()" << endl;
        delete buffer;
    }

private:
    char *buffer;
};
```

如果想让基类为抽象类，可以改为纯虚函数,与前面不同的时拥有纯虚函数的类为抽象类不允许实例化，纯虚函数不用定义。而虚函数是需要有定义的。

```cpp
class A
{
public:
    A() {}
    virtual ~A() = 0;
};

A::~A() {}

class B : public A
{
};

int main(int argc, char **argv)
{
    // A a; 错误A为抽象类型
    B b;
    return 0;
}
```

### 8、别让异常逃离析构函数

* 析构函数绝对不要吐出异常，如果一个被析构函数调用的函数可能抛出异常，析构函数应该捕捉任何异常，然后吞下它们或结束程序
* 如果客户需要对某个操作函数运行期间抛出的异常做出反应，那么类应该提供一个普通函数（而非在析构函数中）执行该操作

例如以下情况

```cpp
void freeA()
{
    throw runtime_error("freeA() error");
}

class A
{
public:
    A() {}
    ~A()
    {
        try
        {
            freeA();
        }
        catch (...)
        {
            // std::abort();//生成coredump结束
            // 或者处理异常
            //...
        }
    }
};

int main(int argc, char **argv)
{
    A *a = new A;
    delete a;
    return 0;
}
```

如果外部需要对某些在析构函数内的产生的异常进行操作等，应该提供新的方法，缩减析构函数内容

```cpp
void freeA()
{
    throw runtime_error("freeA() error");
}

class A
{
public:
    A() {}
    ~A()
    {
        if (!freeAed)
        {
            try
            {
                freeA();
            }
            catch (...)
            {
                // std::abort();//生成coredump结束
                // 或者处理异常
                //...
            }
        }
    }
    void freeA()
    {
        ::freeA();
        freeAed = true;
    }

private:
    bool freeAed = {false};
};

int main(int argc, char **argv)
{
    A *a = new A;
    try
    {
        a->freeA();
    }
    catch (const runtime_error &e)
    {
        cout << e.what() << endl;
    }
    delete a;
    return 0;
}
```

### 9、绝不在构造和析构函数过程中调用 virtual 函数

* 在构造和析构期间不要调用virtual函数，因为这类调用从不下降至derived class(比起当前执行构造函数和析构函数的那一层)

1、构造函数中调用虚函数：

当在基类的构造函数中调用虚函数时，由于派生类的构造函数尚未执行，派生类对象的派生部分还没有被初始化。这意味着在基类构造函数中调用的虚函数将无法正确地访问或使用派生类的成员。此外，派生类中覆盖的虚函数也不会被调用，因为派生类的构造函数尚未执行完毕。

2、析构函数中调用虚函数：

当在基类的析构函数中调用虚函数时，如果正在销毁的对象是一个派生类对象，那么派生类的部分已经被销毁，只剩下基类的部分。此时调用虚函数可能会导致访问已被销毁的派生类成员，从而引发未定义行为。

以下程序是没问题的

```cpp
class A
{
public:
    A()
    {
        func();
    }
    virtual ~A()
    {
        func();
    }
    virtual void func()
    {
        cout << "A::func" << endl;
    };
};

class B : public A
{
public:
    B()
    {
        func();
    }
    ~B()
    {
        func();
    }
    void func() override
    {
        cout << "B::func" << endl;
    }
};

int main(int argc, char **argv)
{
    B b;
// A::func 此时只有A::func 无B::func
// B::func 此时在执行B构造函数故执行B::func
// B::func 此时在执行B析构函数故执行B::func
// A::func 此时在执行A析构函数只有A::func 无B::func
    return 0;
}
```

### 10、令 operator=返回一个 reference to \*this

* 令赋值操作符返回一个reference to *this

像+=、-=、*=操作符函数可以没有返回值，但是如果想有赋值连锁形式就要返回引用

```cpp
class A
{
public:
    A()
    {
    }
    virtual ~A()
    {
    }
    void operator=(const A &a)
    {
        cout << "=" << endl;
    }
};

int main(int argc, char **argv)
{
    A a1;
    A a2;
    a1 = a2; //=
    return 0;
}
```

赋值连锁形式,如果想要支持这种形式就要返回引用

```cpp
int x1, x2, x3;
x1 = x2 = x3 = 1;
cout << " " << x1 << " " << x2 << " " << x3 << endl; // 1 1 1
//自定义为
A &operator=(const A &a)
{
    cout << "=" << endl;
    return *this;
}
```

### 11、在 operator=中处理自我赋值

* 确保当对象自我赋值时operator=有良好行为，其中技术包括比较"来源对象"和"目标对象"的地址，精心周到的语句顺序，以及copy-and-swap
* 确定任何函数如果操作一个以上的对象，而其中多个对象是同一个对象时，其行为仍然确定。

```cpp
Object obj;
obj=obj;//这不是有病吗
```

如何判断与解决此问题呢，或者定义使用std::swap（需要定义swap方法或重写operator=）

```cpp
class A
{
public:
    virtual ~A()
    {
    }
    A &operator=(const A &a)
    {
        if (this == &a)
        {
            cout << "self" << endl;
            return *this;
        }
        cout << "other" << endl;
        //----------------------------------------------------
        A temp(a); // 临时副本，一面在复制期间a修改了导致数据不一致
        // 赋值操作
        //...
        //----------------------------------------------------
        return *this;
    }
};

int main(int argc, char **argv)
{
    A a;
    a = a; // self
    A a1;
    a = a1; // other
    return 0;
}
```

### 12、复制对象时勿忘其每一个成分

* Copying函数应该确保复制“对象内的所有成员变量”及“所有base class成分”
* 不要尝试以某个copying函数实现另一个copying函数，应该将共同机能放在第三个函数中，并由两个coping函数共同调用

可能一开始的业务是这样,但后来加上了isman属性，但是你却忘了加到拷贝构造和赋值函数中，那么这是异常灾难，可能你还找不出来自己错在哪里

```cpp
class A
{
public:
    A() {}
    A(const A &a) : num(a.num)
    {
    }
    A &operator=(const A &a)
    {
        this->num = a.num;
    }
    int num;
    //bool isman;
};
```

还有更恐怖的风险，在存在继承时，你可能忘记了基类部分，所以千万不能忘记

```cpp
class A
{
public:
    A() {}
    virtual ~A(){};
    A(const A &a) : num(a.num)
    {
    }
    A &operator=(const A &a)
    {
        this->num = a.num;
        return *this;
    }
    int num;
};

class B : public A
{
public:
    B() : A()
    {
    }
    ~B() {}
    B(const B &b) : A(b), priority(b.priority) // 不要忘记
    {
    }
    B &operator=(const B &b)
    {
        A::operator=(b); // 不要忘记
        this->priority = b.priority;
        return *this;
    }
    int priority;
};
```

## 资源管理

### 13、以对象管理资源

* 获得资源后立刻放进管理对象内，“以对象管理资源”的观念常被成为“资源取得时机便是初始化实际(Resource Acquisition Is Initialization RAII)”
* 管理对象运用析构函数确保资源被释放
* 可以使用stl智能指针管理在堆上的对象

下面的就是风险较大的情况

```cpp
void func()
{
    int *ptr = new int(5);
    // ...
    // ... 做许多事情，中间可能会return,措施delete执行
    delete ptr;
}
```

### 14、在资源管理类中小心 copying 行为

* 禁止复制，许多时候允许RAII对象被复制并不合理，如果复制动作对RAII class并不合理，便应该禁止。可以将copying操作声明为private。
* 对底层资源祭出引用计数法，有时候我们希望保有资源，直到它的最后一个使用者(某对象)被销毁，这种情况下复制RAII对象时，应该将资源的“被引用数”递增。
* 复制底部资源，需要“资源管理类”的唯一理由是，当你不再需要某个复件时确保它被释放，在此情况下复制资源管理对象，应该同时也复制其所包覆的资源，复制资源管理对象时，进行的是“深度拷贝”。
* 转移底部资源的所有权，有些场景可能希望永远只有一个RAII对象指向一个未加工资源，即使RAII对象被复制依然如此。此时资源的拥有权会从被复制物转移到目标物。

请记住：

1. 复制RAII对象必须一并复制它所管理的资源，所以资源的copying行为决定RAII对象的copying行为。
2. 普遍常见的RAII class copying行为是：抑制copying、施行引用计数法。

### 15、在资源管理类中提供对原始资源的访问

* API往往要求访问原始资源，所以每一个RAII class应该提供一个“取得其所管理之资源”得方法。
* 对原始资源得访问可能经由显式转换或隐式转换，一般而言显式转换比较安全，但隐式转换对客户比较方便。

```cpp
#include <iostream>
using namespace std;

class RAII
{
public:
    RAII(int *ptr)
    {
        m_ptr = ptr;
    }
    ~RAII()
    {
        if (m_ptr)
        {
            delete m_ptr;
        }
    }

    int *get()
    {
        return m_ptr;
    }

    operator int()
    {
        if (m_ptr)
        {
            return *m_ptr;
        }
        return 0;
    }

    operator int *()
    {
        return m_ptr;
    }

private:
    int *m_ptr{nullptr};
};

int main(int argc, char **argv)
{
    RAII ptr(new int(9));
    *ptr.get() = 323;
    std::cout << (*ptr.get()) << std::endl; // 323

    int *resource = ptr;
    std::cout << *resource << std::endl; // 323

    return 0;
}
```

### 16、成对使用 new 和 delete 时要采取相同形式

* 如果你在new表达式中使用`[]`,必须在相应得delete表达式中也使用`[]`。如果你在new表达式中不使用`[]`,一定不要在相应delete表达式中使用`[]`

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    int *arr = new int[100];
    int *ptr = new int;

    delete[] arr;
    delete ptr;

    return 0;
}
```

### 17、以独立语句将 newed 对象置入智能指针

* 独立语旬将newed对象存储千（置入）智能指针内。如果不这样做，一旦异常被抛出，有可能导致难以察觉的资源泄漏。

这句话什么意思呢？

```cpp
void function(RAII raii, int i)
{
    // do something
}

function(RAII(new int(1)), otherFunction(199));
```

这样可能存在内存泄露的风险，因为可能出现下面的情况

1. 执行new int
2. 调用otherFunction
3. 调用RAII的构造函数

万一中间调用otherFunction出现异常就完蛋了，所以请遵守规则，独立创建RAII

```cpp
RAII raii(new int(1));
function(raii, otherFunction(199));
```

## 设计与声明

### 18、让接口容易被正确使用，不易被误用

设计一个组件，那么设计外部接口是非常重要的，正常使用的情况下，还应该做到不易用错，例如

```cpp
class Date
{
public:
    Date(int month, int day, int year);
};
```

外部调用Date很容易将三个参数写错，或者写反，造成目的与实际效果不同，很难排查。上面的例子，可以为每类参数设计一个类，如

```cpp
struct Day
{
    explicit Day(int d) : val(d)
    {
    }
    int val;
}
struct Month()
{
    static Month Jan() { return Month(1); }
    ...
};
struct Year()...
class Date
{
public:
    Date(const Month& month, const Day& day, const Year& year);
};
```

例如工厂函数

```cpp
Investment* createInvestment();
void getRidOfInvestment(Investment);
```

这样很容易内存泄露，所以要使用智能指针

```cpp
std::shared_ptr<Investment> createInvestment();
```

关于使用智能指针则可以为智能指针指定销毁函数，解决跨DLL问题(例如再某个申请的内存指针地址传到另一个DLL使用了另一个DLL的delete,我们尽可能遵循那个DLL申请的内存则由那个DLL的销毁函数进行释放)

```cpp
std::shared_ptr<Investment> createInvestment()
{
    Investment *ptr = new Investment;
    std::shared_ptr<Investment> ret(ptr, [](Investment *ptr) -> void
                                    { delete ptr; });
    return ret;
}
```

请记住

* 好的接口很容易被正确使用，不容易被误用。你应该在你的所有接口中努力达成这些性质。
* "促进正确使用”的办法包括接口的一致性，以及与内置类型的行为兼容。
* "阻止误用”的办法包括建立新类型、限制类型上的操作，束缚对象值，以及消除客户的资源管理责任。
* 智能指针支持定制型删除器，可防范DLL问题。

### 19、设计 class 犹如设计 type

设计新的class应该带着“语言设计者当初设计语言内置类型时”一样的严谨来讨论class的设计。

* 新type的对象应该如何被创建和销毁?  
构造函数和析构函数以及内存分配函数和释放函数`operator new`、`operator new[]`、`operator delete`、`operator delete[]`。

* 对象的初始化和对象的赋值该有什么样的差别?  
决定构造函数和赋值操作符的行为。
* 对象如果被以值传递，意味着什么？
* 什么是新type的和法值?
构造函数，赋值操作符，setter等。
* 新类型需要配合某个继承图系吗？  
受到函数是virtual或non-virtual的影响，如果允许其他class继承，则会影响所声明的函数尤其是析构函数，是否为virtual。
* 新类型需要什么样的转换？  
写转换函数`operator TYPE`或者写non explicit one argument构造函数等。
* 什么样的操作符和函数对新类型是合理的？  
应该声明哪些函数，操作符成员函数del 自定义功能等等。
* 什么样的标准函数应该驳回？
声明为private。
* 谁该取用新类型的成员？  
决定合理设计成员的public、protected、private。
* 什么是新类型读的未声明接口？
* 新class有多么一般化？  
合理使用模板编程。
* 你真的需要一个新class吗？  
根据功能实际情况合理设计。

### 20、宁以 pass-by-reference-to-const 替换 pass-by-value

* C++ 尽量以pass-by-reference-to-const替换pass-by-value。前者通常比较高效(尽可能少发生拷贝、构造函数与析构函数调用)，并可避免切割问题(slicingproblem)。
* 以上规则并不适用内置类型，以及STL的迭代器和函数对象。对它们而言，pass-by-value往往比较适当。

```cpp
#include <iostream>
using namespace std;

class A
{
public:
    // big content...
};

void dosomething(const A &a)
{
}

int main(int argc, char **argv)
{
    A a;
    dosomething(a);
    return 0;
}
```

切割问题

```cpp
#include <iostream>
using namespace std;

class A
{
public:
    virtual void run()
    {
        std::cout << "A::run" << std::endl;
    }
};

class B : public A
{
public:
    void run() override
    {
        std::cout << "A::run" << std::endl;
    }
};

int main(int argc, char **argv)
{
    A a;
    // B *b_ptr = dynamic_cast<B *>(&a); // 会报错
    B *b_ptr = (B *)&a; // 不会报错
    b_ptr->run();       // 产生切割问题 输出A::run
    B b_instance;
    A a_copy_from_b = b_instance; // 产生切割问题 只拷贝了基类部分
    a_copy_from_b.run();          // A::run
    return 0;
}
```

### 21、必须返回对象时，别妄想返回其 reference

* 绝对不要返回pointer或reference指向一个local stack对象，或返回reference指向一个heap-allocated对象，或返回pointer或reference指向一个local static对象而有可能同时需要多个这样对象。

如下面的场景返回值类型就挺好的

```cpp
#include <iostream>
using namespace std;

class Rational;
const Rational operator*(const Rational &lhs, const Rational &rhs);

class Rational
{
public:
    Rational(int numberator = 0, int denominator = 1);

private:
    int n, d;
    friend const Rational operator*(const Rational &lhs, const Rational &rhs);
};

Rational::Rational(int numberator, int denominator) : n(numberator), d(denominator)
{
}

// 比较好的方式
const Rational operator*(const Rational &lhs, const Rational &rhs)
{
    return Rational(lhs.n * rhs.n, lhs.d * rhs.d);
}

int main(int argc, char **argv)
{
    return 0;
}
```

下面返回了local stack 的引用，则会core

```cpp
#include <iostream>
using namespace std;

class Rational;
const Rational &operator*(const Rational &lhs, const Rational &rhs);

class Rational
{
public:
    Rational(int numberator = 0, int denominator = 1);

private:
    int n, d;
    friend const Rational &operator*(const Rational &lhs, const Rational &rhs);
};

Rational::Rational(int numberator, int denominator) : n(numberator), d(denominator)
{
}

const Rational &operator*(const Rational &lhs, const Rational &rhs)
{
    Rational ret(lhs.n * rhs.n, lhs.d * rhs.d);
    return ret;
}

int main(int argc, char **argv)
{
    Rational r1, r2;
    Rational r3 = r1 * r2;
    return 0;
}
```

返回local static的引用，也会存在一定问题

```cpp
#include <iostream>
using namespace std;

class Rational;
const Rational &operator*(const Rational &lhs, const Rational &rhs);

class Rational
{
public:
    Rational(int numberator = 0, int denominator = 1);
    bool operator==(const Rational &other) const
    {
        return this->n == other.n && this->d == other.d;
    }

private:
    int n,
        d;
    friend const Rational &operator*(const Rational &lhs, const Rational &rhs);
};

Rational::Rational(int numberator, int denominator) : n(numberator), d(denominator)
{
}

// 比较好的方式
const Rational &operator*(const Rational &lhs, const Rational &rhs)
{
    static Rational ret;
    ret.n = lhs.n * rhs.n;
    ret.d = lhs.d * rhs.d;
    return ret;
}

int main(int argc, char **argv)
{
    Rational r1(1, 2), r2(3, 4);
    Rational r3(5, 6), r4(7, 9);
    std::cout << boolalpha << ((r1 * r2) == (r3 * r4)) << std::endl; // 总是返回true因为比较的是同一个Rational对象当然总是相等
    return 0;
}
```

### 22、将成员变量声明为 private

* 切记将成员变量声明为private。这可赋予客户访问数据的一致性、可细微划分访问控制、允诺约束条件获得保证，并提供class作者以充分的实现弹性。
* protected并不比public更具封装性, 派生类使用基类的字段，基类想要轻松改字段可不是那么容易的。

假设我们有一个public成员变量，而我们最终取消了它。多少代码可能会被破坏呢？所有使用它的客户代码都会被破坏，而那是一个不可知的大量。因此public成员变量完全没有封装性。

假设我们有一个protected成员变量，而我们最终取消了它，有多少代码被破坏？
所有使用它的derived classes都会被破坏，那往往也是个不可知的大量。

因此，protected成员变量就像public成员变量一样缺乏封装性，

因为在这两种情况下，如果成员变量被改变，都会有不可预知的大量代码受到破坏。
一旦你将一个成员变量声明为public或protected而客户开始使用它，就很难改变那个成员变量所涉及的一切。太多代码需要重写、重新测试、重新编写文档、重新编译。

从封装的角度观之，其实只有两种访问权限：private（提供封装）和其他（不提供封装）。

### 23、宁以 non-member、non-friend 替换 number 函数

* 宁可拿non-member non-friend 函数替换member函数。这样做可以增加封装性、包裹弹性(packaging flexibility)和技能扩充性。

```cpp
class WebBrowser
{
public:
    // ...
    void clearCache();
    void clearHistory();
    void removeCookies();
    void clearEveryhing()
    {
        clearCache();
        clearHistory();
        removeCookies();
    }
    // ...
};
```

不如写为

```cpp
namespace WebBrowserStuff
{
    class WebBrowser
    {
    public:
        // ...
        void clearCache();
        void clearHistory();
        void removeCookies();
        // ...
    };

    void clearBrowser(WebBrowser &wb)
    {
        wb.clearCache();
        wb.clearHistory();
        wb.removeCookies();
    }
}
```

还可以根据功能划分与重要成都写到不同的头文件中

```cpp
// webbrowser.h
namespace WebBrowserStuff
{
 class WebBrowser{...};
 // ... 核心机能，如几乎所有客户端需要的non-member函数
}
// webbrowserbookmarks.h
namespace WebBrowserStuff
{
 // ... 与书签相关的便利函数
}
// 头文件 webbrowsercookies.h
namspace WebBrowserStuff
{
 // ... 与cookie相关的便利函数
}
```

### 24、若所有参数皆需要类型转换，请为此采用 non-member 函数

* 如果你需要位某个函数的所有参数（包括被this指针所指的那个隐喻参数）进行类型转换，那么这个函数必须是个non-member。

只看描述是很难理解的，看代码的例子，就好很多。

```cpp
class Rational
{
public:
 Rational(int numerator = 0,
    int denominator = 1); // 构造函数刻意不位explicit 允许int-to-Rational隐式转换
 int numerator() const;
 int denominator() const;
 
private:
 ...
};
```

自定义乘法运算符

```cpp
class Rational
{
public:
 ...
 const Rational operator* (const Rational& rhs) const;
};
```

```cpp
Rational oneEighth(1, 8);
Rational oneHalf(1, 2);
Rational result = oneHalf * oneEighth;
result = result * oneEighth;
result = oneHalf.operator*(2);
result = 2.operator*(oneHalf); // 错误
result = operator*(2, oneHalf); // 错误
```

上面的`oneHalf.operator*(2)`相当于做了隐式转换

```cpp
const Rational temp(2);
result = oneHalf * temp; // Rational 构造函数是非explicit的
```

想要支持混合式算术运算，让`operator*`成为一个non-member函数，允许编译器在每一个实参上执行隐式类型转换：

```cpp
class Rational
{
 ... // 不包括operator*
};
// 定义为non-member函数
const Rational operator*(const Rational& lhs, const Rational& rhs)
{
 return Rational(lhs.numberator() * rhs.numberator(), lhs.denominator() * rhs.denominator());
}
Rational oneFourth(1, 4);
Rational result;
result = oneFourth * 2;
result = 2 * oneFourth;
```

### 25、考虑写出一个不抛异常的 swap 函数

* 当`std::swap`对你的类型效率不高时，提供一个swap成员函数，并确定这个函数不抛出异常。
* 如果你提供了一个member swap,也应提供一个non-member swap用来调用前者。对于classes(而非templates),也请特化`std::swap`。
* 调用swap时应针对`std::swap`使用using生命，然后调用swap并且不带任何“命明空间资格修饰”
* 为用户定义类型 进行 std templates 全特化是好的，但千万不要尝试在`std`内加入某些对std而言全新的东西。

所谓swap（置换）两个对象值，意思是将两对象的值彼此赋予对方。缺省情况下swap动作可由标准程序库提供的swap算法完成。

```cpp
namespace std
{
    template <typename T>
    void swap(T &a, T &b)
    {
        T temp(a);
        a = b;
        b = temp;
    }
}
```

只要类型T支持copying(通过拷贝构造函数和拷贝赋值操作符完成)。

```cpp
#include <iostream>
#include <vector>
using namespace std;

class AImpl
{
public:
    int a, b, c;
    std::vector<int> vec;
};

class A
{
public:
    A()
    {
        implPtr = new AImpl;
    }
    ~A()
    {
        if (implPtr)
        {
            delete implPtr;
        }
    }
    A(const A &a)
    {
  implPtr = new AImpl(*a.implPtr);
    }
    A &operator=(const A &a)
    {
        // 深拷贝 不然默认只拷贝地址有问题
        *implPtr = *a.implPtr;
        return *this;
    }
    AImpl *implPtr;
};

int main(int argc, char **argv)
{
    A a1;
    A a2 = a1;
    return 0;
}
```

如上面的例子，因为需要拷贝我们必须写深拷贝，不然默认进行地址拷贝会出问题。但是使用`std::swap`时就显得有些鸡肋，明明只交换二者的
implPtr存储的地址即可，却使用的拷贝。但是我们对`std::swap`针对A进行特化。

```cpp
namespace std
{
    template <>
    void swap<A>(A &a, A &b)
    {
        swap(a.implPtr, b.implPtr);
    }
}
```

上面可以实现，是因为implPtr属性是public的，如果为私有的时应该怎么做

```cpp
#include <iostream>
#include <vector>
using namespace std;

class A;
class AImpl;
void swap(A &a, A &b) noexcept;

class AImpl
{
public:
    int a, b, c;
    std::vector<int> vec;
};

class A
{
public:
    A()
    {
        implPtr = new AImpl;
    }
    ~A()
    {
        if (implPtr)
        {
            delete implPtr;
        }
    }
    A(const A &a)
    {
  implPtr = new AImpl(*a.implPtr);
    }
    A &operator=(const A &a)
    {
        // 深拷贝 不然默认只拷贝地址有问题
        *implPtr = *a.implPtr;
        return *this;
    }

public:
    friend void swap(A &a, A &b) noexcept;
    void swap(A &b) noexcept
    {
        ::swap(*this, b);
    }

private:
    AImpl *implPtr;
};

void swap(A &a, A &b) noexcept
{
    std::cout << "my swap" << std::endl;
    std::swap(a.implPtr, b.implPtr);
}

namespace std
{
    template <>
    void swap<A>(A &a, A &b) noexcept
    {
        ::swap(a, b);
    }
}

int main(int argc, char **argv)
{
    A a1;
    A a2 = a1;
    std::swap(a1, a2); // my swap
    swap(a1, a2);      // my swap
    return 0;
}
```

如果A是一个模板类是，情况则有些麻烦。在C++中，模板的特例化不能放在std命名空间中，除非标准库特意允许。因为直接在std命名空间中特例化会导致不确定行为。

```cpp
#include <iostream>
#include <vector>
using namespace std;

namespace ASpace
{

    template <typename T>
    class A;

    class AImpl;

    template <typename T>
    void swap(A<T> &a, A<T> &b) noexcept;

    class AImpl
    {
    public:
        int a, b, c;
        std::vector<int> vec;
    };

    template <typename T>
    class A
    {
    public:
        A()
        {
            implPtr = new AImpl;
        }
        ~A()
        {
            delete implPtr;
        }
        A(const A &a)
        {
            implPtr = new AImpl(*a.implPtr);
        }
        A &operator=(const A &a)
        {
            if (this == &a)
            {
                return *this; // nothing todo
            }
            // 深拷贝 不然默认只拷贝地址有问题
            *implPtr = *a.implPtr;
            return *this;
        }

    public:
        friend void swap<>(A<T> &a, A<T> &b) noexcept;

        void swap(A &b) noexcept
        {
            std::swap(implPtr, b.implPtr);
        }

    private:
        AImpl *implPtr;
    };

    template <typename T>
    void swap(A<T> &a, A<T> &b) noexcept
    {
        std::cout << "my swap" << std::endl;
        a.swap(b);
    }

} // ASpace

int main(int argc, char **argv)
{
    ASpace::A<ASpace::AImpl> a1;
    ASpace::A<ASpace::AImpl> a2 = a1;
    swap(a1, a2); // my swap // 触发（argument-dependentlookup或Koenig lookup法则）
    // std::swap(a1,a2);//error

    {
        using std::swap;
        swap(a1, a2); // ADL（Argument Dependent Lookup，参数依赖查找） 调用ASpace::swap
    }
    return 0;
}
```

## 实现

### 26、尽可能延后变量定义式的出现时间

* 尽可能延后变量定义式的出现，这样做可增加程序的清晰度并改善程序效率。

只要定义了一个变量其类型带有一个构造函数或析构函数，当程序控制流到达这个变量定义式时就得承受构造成本。
离开作用域时就得承受析构成本 即使变量最终并未被使用。

```cpp
#include <iostream>
#include <string>

constexpr int MinimumPasswordLength = 10;

std::string encryptPassword(const std::string& password)
{
    using namespace std;
    std::string encrypted;
    if(password.length()<MinimumPasswordLength)
    {
        throw logic_error("Password is too short");
    }
    //..
    return encrypted;
}

int main()
{
    return 0;
}
```

下面方式更好

```cpp
#include <iostream>
#include <string>

constexpr int MinimumPasswordLength = 10;

std::string encryptPassword(const std::string& password)
{
    using namespace std;
    if(password.length()<MinimumPasswordLength)
    {
        throw logic_error("Password is too short");
    }
    std::string encrypted;
    //..
    return encrypted;
}

int main()
{
    return 0;
}
```

例如下面的循环场景

```cpp
// 方法A
Widget w;
for(int i=0;i<n;i++)
{
	// w=i;
}
// 方法B
for(int i=0;i<n;++i)
{
	Widget w(i);
}
```

A:1个构造函数+1个析构函数+n个赋值操作
B:n个构造函数+n个构造函数

具体用那种方法，要根据具体情况评估。

### 27、尽量少做转型动作

回顾C风格的转型

```cpp
(T)expression // 将expression转型为T
T(expression) // 将expression转型为T
```

两种形式并无差别，存粹是小括号的摆放位置不同而已。称此为旧式转型 old-style casts.

C++还提供了四种新式转型

```cpp
const_cast<T>(expression)
dynamic_cast<T>(expression)
reinterpret_cast<T>(expression)
static_cast<T>(expression)
```

1. const_cast 通常被用来将对象的常量性转除(castaway the constness)。
2. dynamic_cast 主要用来执行“安全向下转型”(safe downcasting)。 dynamic_cast调用会进行字符串比较，需要考虑效率成本。
3. reinterpret_cast 意图执行低级转型，实际动作（及结果）可能取决千编译器，这也就表示它不可移植。
4. static_cast用来强迫隐式转换。

- 如果可以，尽量避免转型，特别是在注重效率的代码中避免dynarnic_cas七s。如果有个设计需要转型动作，试着发展无需转型的替代设计。
- 如果转型是必要的，试着将它隐藏千某个函数背后。客户随后可以调用该函数，而不需将转型放进他们自己的代码内。
- 宁可使用C++-style（新式）转型，不要使用旧式转型。前者很容易辨识出来，而且也比较有着分门别类的职掌。

### 28、避免返回 handles 指向对象内部成分

- 避免返回handles 包括 引用、指针、迭代器，指向对象内部。遵守这个条款可以增加封装性，帮助const成员函数的行为像个const，并将发生“虚吊号码牌” 
（dangling handles）的可能性降至最低。

```cpp
class A
{
public:
    int n1;
    int n2;
};

class B
{
public:
    B()
    {
        a = make_shared<A>();
    }
    inline int &Getn1() const // 这里封装性被破坏，外部可以修改n1
    {
        return a->n1;
    }
    inline int &Getn2() const // 这里封装性被破坏，外部可以修改n2
    {
        return a->n2;
    }

private:
    std::shared_ptr<A> a;
};
```

虽然Getn1与Getn2有限制const,但是返回值不是const的

```cpp
class B
{
public:
    B()
    {
        a = make_shared<A>();
    }
    inline const int &Getn1() const
    {
        return a->n1;
    }
    inline const int &Getn2() const
    {
        return a->n2;
    }

private:
    std::shared_ptr<A> a;
};
```

还有一种是，返回了随时可能被销毁的资源

```cpp
#include <iostream>
#include <memory>
using namespace std;

class A
{
public:
    A(int n1, int n2) : n1(n1), n2(n2) {};
    int n1;
    int n2;
};

class B
{
public:
    B(int n1, int n2)
    {
        a = make_shared<A>(n1, n2);
    }
    inline const int &Getn1() const
    {
        return a->n1;
    }
    inline const int &Getn2() const
    {
        return a->n2;
    }

    void destoryA()
    {
        a.reset();
    }

private:
    std::shared_ptr<A> a;
};

int main(int argc, char **argv)
{
    B b(1, 2);
    const int &n1 = b.Getn1();
    const int &n2 = b.Getn2();
    std::cout << n1 << " " << n2 << std::endl; // 1 2
    b.destoryA();

    *const_cast<int *>(&n1) = 100;
    // Segmentation fault (core dumped)
    std::cout << b.Getn1() << std::endl;

    return 0;
}
```

### 29、为异常安全而努力是值得的

- 异常安全函数(Exception-safefunctions)即使发生异常也不会泄漏资源或允许任何数据结构败坏。这样的函数区分为三种可能的保证：基本型、强烈型、不抛异常型。
- "强烈保证”往往能够以copy-and-swap实现出来，但“强烈保证”并非对所有函数都可实现或具备现实意义。
- 函数提供的“异常安全保证“通常最高只等千其所调用之各个函数的“异常安全保证”中的最弱者。

1. 基本保证

即使函数在执行中抛出异常，程序的状态仍然是有效的（不会造成资源泄漏或数据结构损坏），但可能无法保证状态是原始状态。

示例：资源的简单释放

假设一个函数在处理动态内存分配，尽管抛出异常，也确保释放了已分配的资源。

```cpp
#include <iostream>
#include <stdexcept>

void basicGuaranteeExample() {
    int* resource = new int[10]; // 动态分配资源

    try {
        // 模拟某些可能抛出异常的操作
        throw std::runtime_error("Something went wrong!");
    } catch (...) {
        // 捕获异常并确保释放资源
        delete[] resource;
        std::cout << "Basic guarantee: Resource cleaned up." << std::endl;
        throw; // 重新抛出异常
    }
}
```

结果：即使函数抛出异常，动态分配的资源仍然会被释放，程序状态有效。

2. 强烈保证

函数提供强烈保证：若函数抛出异常，程序的状态会回到调用函数之前的状态，不会有任何更改。
可以通过 copy-and-swap 技术实现。

示例：swap 技术在容器的异常安全中应用

```cpp
#include <vector>
#include <stdexcept>

class ExceptionSafeVector {
    std::vector<int> data;

public:
    void addElement(int element) {
        // 创建临时副本，保证异常发生时不会修改原数据
        std::vector<int> temp(data);
        temp.push_back(element); // 操作可能抛出异常

        // 若无异常，完成 swap 替换
        data.swap(temp); // 强烈保证：要么成功，要么不修改 data
    }

    void print() const {
        for (int val : data) {
            std::cout << val << " ";
        }
        std::cout << std::endl;
    }
};

int main() {
    ExceptionSafeVector vec;
    try {
        vec.addElement(1);
        vec.addElement(2);
        vec.addElement(3); // 无异常时更新数据
    } catch (...) {
        std::cout << "Strong guarantee: No changes to the original state!" << std::endl;
    }

    vec.print(); // 打印已添加的元素
}
```

结果：如果 addElement 抛出异常，data 保持调用前的状态。

3. 不抛异常保证

函数绝对不会抛出异常，通常用于析构函数或一些保证不会失败的操作。

示例：提供强制的 noexcept 保证

```cpp
#include <iostream>
#include <utility>

class NoThrowClass {
    int* resource;

public:
    NoThrowClass() : resource(new int(42)) {}

    // noexcept 保证函数不会抛出异常
    ~NoThrowClass() noexcept {
        delete resource; // 确保资源被释放，不抛异常
    }

    // noexcept 移动操作：在发生资源转移时，确保不抛异常
    NoThrowClass(NoThrowClass&& other) noexcept : resource(nullptr) {
        resource = other.resource;
        other.resource = nullptr;
    }

    // 赋值操作符 noexcept
    NoThrowClass& operator=(NoThrowClass&& other) noexcept {
        if (this != &other) {
            delete resource; // 释放已有资源
            resource = other.resource;
            other.resource = nullptr;
        }
        return *this;
    }
};

int main() {
    NoThrowClass obj1;
    NoThrowClass obj2 = std::move(obj1); // 不抛异常

    std::cout << "No-throw guarantee: Successful resource transfer without exceptions!" << std::endl;
}
```

结果：析构函数和移动操作通过 noexcept 保证不会抛出异常。

假设有三个函数 A、B 和 C，它们分别提供不同级别的异常安全保证：

- 函数 A 提供 强烈保证。
- 函数 B 提供 基本保证。
- 函数 C 调用 A 和 B，它尝试提供 强烈保证。
- 由于 B 只能提供 基本保证，因此 C 的最高异常安全保证只能是 基本保证。

### 30、透彻了解 inlining 的里里外外

- 将大多数inlining限制在小型、被频繁调用的函数身上。这可使日后的调试过程和二进制升级(binary upgradability)更容易，也可以使潜在的代码膨胀问题最小化，使程序的速度提升机会最大化。
- 不要只因为function templates出现在头文件，就将它们声明为inline，二者是两码事。

inline函数，动作像函数，比宏好用得多，可以调用它们又不需要蒙受函数调用所招致得额外开销。
没有白吃得午餐，inline函数背后得整体观念是，将“对此函数得每一个调用”都以函数本体替换之。一台内存有限得机器上，过度热衷inlining会造成程序体积太大（对可用空间而言）。即使拥有虚内存，inline造成的代码膨胀亦会导致额外得换页行为，降低指令高速缓存装置得击中率，带来效率损失。

```cpp
class Person
{
public:
    ...
    int age() const { return theAge; } // 一个隐喻的inline申请
    ...
private:
    int theAge;
};
```

使用inline函数的函数指针，并不是inlined。

```cpp
inline void f() {...}
void (*pf)() = f;
f(); // 是inline调用
pf(); // 不是inline调用
```

构造函数和析构函数往往是inlining的糟糕候选人。

1. 构造函数和析构函数通常不是“小而简单”的函数

- 内联函数的最佳候选： 内联函数通常适用于小型、简单的函数（例如访问器或简单数学运算），因为内联化后可以避免函数调用开销，从而提升性能。
- 构造函数和析构函数的复杂性： 构造函数和析构函数虽然看起来很简单，但实际上它们会隐式调用许多代码：
  - 构造函数通常需要初始化成员变量，可能还会调用基类的构造函数。
  - 析构函数通常需要释放资源，可能会调用基类的析构函数。
  - 在这些过程中，编译器生成的代码量可能很大，远超出预期。

```cpp
class Example {
    int a;
    double b;
    std::string c;

public:
    Example() : a(0), b(0.0), c("default") {} // 构造函数看似简单，但实际上初始化了多个成员
};
```

即使这个构造函数只有一行，实际上它要调用 std::string 的构造函数，还可能涉及动态内存分配。将这样的函数内联会生成大量代码，增加可执行文件的大小（代码膨胀）。

2. 内联化可能导致代码膨胀（Code Bloat）

- 构造函数和析构函数通常会被频繁调用（例如在创建或销毁对象时）。如果它们被内联化，每次调用都会直接将函数体展开到调用点。
- 如果构造函数或析构函数涉及大量逻辑，则内联会导致可执行文件的大小显著增加（代码膨胀）。
- 膨胀的代码会增加 CPU 指令缓存的压力，从而降低性能。

3. 调试和维护的复杂性

- 内联函数无法在调试时以普通函数调用的方式清晰地查看调用栈。对于构造函数和析构函数这样重要的函数，内联会让调试变得更加困难。
- 构造函数和析构函数往往是程序中逻辑错误的集中点（比如未正确初始化成员变量或未正确释放资源），将它们内联可能让问题难以追踪。

4. 可能影响虚函数行为

- 如果一个类有虚函数，那么它的构造函数和析构函数需要执行一些隐式操作（如设置或清理虚函数表 vtable）。
- 虽然这些操作对用户不可见，但编译器生成的代码可能非常复杂。
- 内联这些操作可能导致额外的性能开销，并且会让代码行为难以预测。

### 31、将文件间的编译依存关系降到最低

- 支持“编译依存性最小化”的一般构想是：相依于声明式，不要相依于定义式。基于此构想的两个手段是Handle classes 和 Interface classes。
- 程序库头文件应该以“完全且仅有声明式”的形式存在。这种做法不论是否涉及templates都适用。

如A.h内定义了class A, class A中使用了 class B和class C,class B定义在 B.h class C在 C.h,如果 A.h include了B.h C.h,那么修了B.h或者C.h A的实现需要重新编译，因为A.h也发生了变化。所有可以在A.h中使用前置声明。

```cpp
// A.h
#include "B.h"
#include "C.h"
class A{
public:
    A(B&b,C&c);
};
```

上面代码依存密切，容易引起编译灾难。

```cpp
// A.h
class B;
class C;
class A{
public:
   A(B&b,C&c);
};
```

想要使用某个类型就需要知道分配多少内存，如

```cpp
int main()
{
    int x; // 定义一个int
    Person p; // 定义一个Person对象，需要include到Person的定义式，不然编译不过
    ...
}
```

有一种 pointer to implementation的骚操作。

```cpp
// A.h
class AImpl;
class B;
class C;
class A
{
public:
    A(B&b, C&c);
    // ...
private:
    std::shared_ptr<AImpl> pImpl;
};
```

这样的设计之下，Person的客户完全与A,B以及A的实现细目分离了。include了A.h的cpp，即使B.h C.h修改了东西，也不会令include A.h的源代码重新编译。

1. 如果使用 object references或object pointers可以完成任务，就不要使用objects。你可以只靠一个类型声明式就定义出指向该类型的references和pointers；但如果定义某类型的objects，就需要用到该类型的定义式。
2. 如果能够，尽量以class声明式替换class定义式。
3. 为声明式和定义式子提供不同的头文件。

注意，当你声明一个函数而它用到某个class时，你并不需要该class的定义；纵使函数以byvalue方式传递该类型的参数（或返回值）亦然：

```cpp
// A.h
#include "Bfwd.h"
#include "Cfwd.h"
B bfunc();
void showC(C c);
```

```cpp
#include "A.h"
#include "AImpl.h"
A::A(const B&b,const C&c,const std::string&str):AImpl(new AImpl(b,c,str))
{}
std::string A::name() const
{
    return pImpl->name();
}
```

## 继承与面向对象设计

三种继承方式

1. public继承表示派生类"is-a"基类，这意味着派生类应该能完全替代基类使用（里氏替换原则 LSP）。

```cpp
class Animal {
public:
    virtual void makeSound() { std::cout << "某种声音" << std::endl; }
protected:
    int age;
private:
    std::string dna;
};

class Dog : public Animal {
    // Animal的public成员在Dog中仍然是public
    // Animal的protected成员在Dog中仍然是protected
    // Animal的private成员在Dog中不可访问
};
```

2. private继承表示"根据某物实现出"，"has-a",是一种实现技术而非设计关系。它通常用于实现复用，而不是表达类之间的概念关系。

```cpp
class Engine {
public:
    void start() { std::cout << "引擎启动" << std::endl; }
    void stop() { std::cout << "引擎停止" << std::endl; }
protected:
    void inject_fuel() {}
private:
    void internal_process() {}
};

class Car : private Engine {  // private继承
    // Engine的public和protected成员在Car中变成private
    // Engine的private成员在Car中不可访问
public:
    void start_car() {
        start();  // 可以访问Engine的方法，但只能在Car的内部使用
    }
};

int main() {
    Car car;
    // car.start();  // 错误：Engine的方法对外不可见
    car.start_car(); // 正确：通过Car的公共接口访问
}
```

3. protected继承介于public继承（is-a）和private继承（has-a）之间，它表示一种"在实现中是一种"（implemented-in-terms-of）的关系。

```cpp
class Base {
public:
    void publicFunc() {}
protected:
    void protectedFunc() {}
private:
    void privateFunc() {}
};

class Derived : protected Base {
    // Base的public成员在Derived中变成protected
    // Base的protected成员在Derived中保持protected
    // Base的private成员在Derived中不可访问
};

class Further : public Derived {
    void func() {
        publicFunc();     // 可以访问，因为在Derived中是protected
        protectedFunc();  // 可以访问，因为在Derived中是protected
        // privateFunc(); // 不能访问
    }
};
```

### 32、确定你的 public 继承塑膜出 is-a 关系

- "public继承“意味is-a。适用千baseclasses身上的每一件事情一定也适用千derived classes身上，因为每一个derivedclass对象也都是一个baseclass对象。

如果你令 class D以public形式继承class B，那么当你看到class D的某个对象时，你便知道它也是个class B。反之不成立。

我来用一个简单的例子来解释"public继承"中的is-a关系。

```cpp
class Animal {
public:
    virtual void makeSound() {
        std::cout << "动物发出声音" << std::endl;
    }
    
    void eat() {
        std::cout << "动物在进食" << std::endl;
    }
};

class Dog : public Animal {  // Dog "是一个" Animal
public:
    void makeSound() override {  // 重写基类的方法
        std::cout << "汪汪汪！" << std::endl;
    }
    
    void fetchBall() {
        std::cout << "狗狗去捡球" << std::endl;
    }
};

int main() {
    Dog dog;
    Animal* animal_ptr = &dog;  // 这是合法的，因为 Dog "是一个" Animal
    
    // 下面这些操作都是合法的
    dog.makeSound();      // 输出："汪汪汪！"
    dog.eat();           // 输出："动物在进食"
    
    animal_ptr->makeSound();  // 输出："汪汪汪！"
    animal_ptr->eat();       // 输出："动物在进食"
}
```

让我解释这个例子：

1. `Animal` 是基类，定义了所有动物共有的行为：`makeSound()` 和 `eat()`。

2. `Dog` 通过 `public` 继承自 `Animal`，这表明"狗是一个动物"（is-a关系）。
   - 狗继承了动物的所有特性（`makeSound` 和 `eat`）
   - 狗可以重写某些行为（这里重写了 `makeSound`）
   - 狗还可以添加自己特有的行为（`fetchBall`）

3. 因为存在 is-a 关系：
   - 任何需要 `Animal` 的地方都可以使用 `Dog`
   - 可以把 `Dog` 对象的指针赋值给 `Animal` 指针（向上转型）
   - 所有适用于 `Animal` 的操作都适用于 `Dog`

这就是为什么说"适用于基类的每一件事情一定也适用于派生类"。因为派生类对象在任何情况下都可以被当作基类对象来使用，这是 public 继承的核心特性。

相反，如果这种关系不成立，就不应该使用 public 继承。例如，"房子有一个门"这种关系就不应该用 public 继承，而应该用组合（composition）来实现，因为门不是房子的一种类型。

### 33、避免遮掩继承而来的名称

- derived classses 内的名称会遮掩base classes内的名称。在public继承下从来没有人希望如此。
- 为了让被遮掩的名称在见天日，可使用using声明式或转交函数(forwarding functions)

C++有种现象为名字遮掩。在C++中，当派生类声明了一个与基类同名的函数时，基类中所有同名函数（无论参数如何）都会被遮掩，只要原因有：

名称查找规则:

- C++的名称查找遵循最近作用域优先的规则
- 一旦在派生类中找到了某个名称，就会停止在基类中继续查找
- 这种机制是为了避免命名冲突合确保代码的可预测性

```cpp
#include <iostream>

class Base
{
private:
    int x;

public:
    virtual void mf1() = 0;
    virtual void mf1(int);
    virtual void mf2();
    void mf3();
    void mf3(double);
    virtual ~Base();
};

Base::~Base() {}
void Base::mf1(int x)
{
    std::cout << "Base::mf1(int x)" << std::endl;
}
void Base::mf2()
{
    std::cout << "Base::mf2()" << std::endl;
}
void Base::mf3()
{
    std::cout << "Base::mf3()" << std::endl;
}
void Base::mf3(double x)
{
    std::cout << "Base::mf3(double x)" << std::endl;
}

class Derived : public Base
{
public:
    virtual void mf1();
    void mf3();
    void mf4();
};

void Derived::mf1()
{
    std::cout << "Derived::mf1()" << std::endl;
}

void Derived::mf3()
{
    std::cout << "Derived::mf3()" << std::endl;
}

void Derived::mf4()
{
    std::cout << "Derived::mf4()" << std::endl;
}

int main()
{
    Derived d;
    d.mf1(); // Derived::mf1()
    // d.mf1(12); // 错误：Derived::mf1(int) 遮掩了 Base::mf1(int)
    d.mf2(); // Base::mf2()
    d.mf3(); // Derived::mf3()
    // d.mf3(1);// 错误：Derived::mf3遮掩了Base::mf3
    return 0;
}
```

解决方法 

1. 使用using声明式

```cpp
class Derived : public Base
{
public:
    using Base::mf1; // 在Base class内名为mf1和mf3的所有东西
    using Base::mf3; // 在Derived作用域内都可看见 并且public
    virtual void mf1();
    void mf3();
    void mf4();
};
```

2. 通过作用域解析运算符显式调用

```cpp
Derived d;
d.Base::mf1(12);
```

3. 转交函数

- private继承的主要目的是实现"has-a"关系，基类的公有成员在派生类中默认变成私有成员
- 使用using声明无法改变继承来的函数的访问级别
- 而转交函数可以精确控制哪些函数对外可见，以及它们的访问级别

```cpp
// 不好的方式：using声明在private继承中
class Derived : private Base {
private:
    using Base::mf1;  // 这样无法将mf1暴露为public接口
};

// 好的方式：使用转交函数
class Derived : private Base {
public:
    // 可以选择性地只转发某些重载版本
    void mf1() { Base::mf1(); }  // 显式转发到基类版本
    void mf1(int x) { Base::mf1(x); }  // 可以控制访问级别为public
};
```

### 34、区分接口继承和实现继承

### 35、考虑 virtual 函数以外的其他选择

### 36、绝不重新定义继承而来的 non-virtual 函数

### 37、绝不重新定义继承而来的缺省参数值

### 38、通过复合塑膜出 has-a 或“根据某物实现出”

### 39、明智而审慎地使用 private 继承

### 40、明智而审慎地使用多重继承

## 模板与泛型编程

### 41、了解隐式接口和编译期多态

### 42、了解 typename 的双重意义

### 43、学习处理模板化基类内的名称

### 44、将于参数无关的代码抽离 templates

### 45、运用成员函数模板接受所有兼容类型

### 46、需要类型转换时请为模板定义非成员函数

### 47、请使用 traits classes 表现类型信息

### 48、认识 template 编程

## 定制 new 和 delete

### 49、了解 new-handler 的行为

### 50、了解 new 和 delete 的合理替换时机

### 51、编写 new 和 delete 时需固守常规

### 52、写了 placement new 也要写 placement delete

## 杂项讨论

### 53、不要轻易忽略编译器警告

### 54、让自己熟悉包括 TR1 在内的标准程序库

### 55、让自己熟悉 Boost
