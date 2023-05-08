# C++必知必会

## RAII

RAII 是 Resource Acquisition Is Initialization（资源获取即初始化）的缩写，是一种 C++编程技巧。RAII 技巧基于一个很简单的理念：在对象的构造函数中分配资源，而在析构函数中释放资源。这个理念看起来简单，但却具有强大的功能和好处。

最为代表性的就是 C++中的智能指针。

```cpp
#include <iostream>
using namespace std;

class RAII
{
public:
    char *buffer;

public:
    RAII();
    ~RAII();
};

RAII::RAII()
{
    buffer = new char[1024];
    cout << "RAII::RAII" << endl;
}

RAII::~RAII()
{
    delete buffer;
    cout << "RAII::~RAII" << endl;
}

int main(int argc, char **argv)
{
    RAII raii;
    return 0;
}
// RAII::RAII
// RAII::~RAII
```

## pimpl 惯用法

写 C++都知道，如果我们封装一个类，然后封装为库给第三方调用，同时需要提供头文件，但是类中有许多成员变量暴露了太多细节，这一问题有没有办法处理呢  
Pimpl（Pointer to implementation）是 C++编程中的一种惯用法，也称为“编译期实现”。它通过将类的实现细节从公共接口中分离出来，从而使类的实现变得更加抽象，提高了代码的可维护性、可扩展性和安全性。

```cpp
//main.cpp
#include <iostream>
#include <memory>
#include "main2.h"
using namespace std;

int main(int argc, char **argv)
{
    shared_ptr<Person> ptr = make_shared<Person>();
    ptr->print(); // 1 b 2 3
    return 0;
}
```

```cpp
//main2.h
#include <memory>
class Person
{
public:
    Person();
    ~Person();
    void print();

private:
    class Impl; // 内部类
    std::unique_ptr<Impl> m_pImpl;
};
```

```cpp
//main2.cpp
#include "main2.h"
#include <iostream>

using std::cout;
using std::endl;

class Person::Impl
{
public:
    Impl();
    ~Impl() = default;
    int a;
    char b;
    float c;
    double d;
};

Person::Impl::Impl() : a(1), b('b'), c(2.0), d(3.0)
{
}

Person::Person()
{
    m_pImpl.reset(new Impl());
}

Person::~Person()
{
}

void Person::print()
{
    cout << m_pImpl->a << " " << m_pImpl->b << " " << m_pImpl->c << " " << m_pImpl->d << endl;
}
```

## 编译时 C++版本

```cpp
//g++
g++ -g -o test test.cpp -std=c++11
//makefile
make CXXFLAGS="-g -O0 -std=c++11"
//cmake
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -g -Wall -O0 -Wno-unused-variable")
//-Wno-unused-variable 表示禁止编译器对未使用的变量发出警告。
```

## 类成员声明初始化

```cpp
#include <iostream>
#include <string>
using namespace std;

// 需要写在声明中，在头文件内
class Person1
{
public:
    int arr[5] = {1, 2, 3, 4, 5};
    int number{999};
    string str{"hello world"}; // c++11支持用花括号对任意类型的变量初始化
};

// 写到cpp文件中
class Person2
{
public:
    Person2() : arr{1, 2, 3, 4, 5}
    {
    }
    int arr[5];
};

// 写到cpp文件中
class Person3
{
public:
    Person3()
    {
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        arr[3] = 4;
        arr[4] = 5;
    }
    int arr[5];
};

int main(int argc, char **argv)
{
    Person1 person1;
    cout << person1.arr[0] << " " << person1.arr[4] << person1.number << " " << person1.str << endl; // 1 5 9999 hello world
    Person2 person2;
    cout << person2.arr[0] << " " << person2.arr[4] << endl; // 1 5
    Person3 person3;
    cout << person3.arr[0] << " " << person3.arr[4] << endl; // 1 5
    string str{"hello"};
    int number{1};
    cout << str << " " << number << endl; // hello 1
    return 0;
}
```

## initializer_list

详细内容可以看本笔记的 c++部分

```cpp
#include <iostream>
#include <string>
#include <initializer_list>
using namespace std;

class Person
{
public:
    Person(initializer_list<int> m_list);
};

Person::Person(initializer_list<int> m_list)
{
    for (const int &n : m_list)
    {
        cout << n << endl;
    }
}

int main(int argc, char **argv)
{
    Person person{1, 2, 3, 4, 5}; // 1 2 3 4 5
    return 0;
}
```

## C++ 17 注解标签(attributes)

注解标签语法,C++11 支持任意类型、函数或 enumeration，从 c++17 支持了命名空间、enumerator

```cpp
[[attribute]] types/functions/enums/etc
```

常见

```cpp
[[noreturn]]：指定函数不会返回，可以用于提示编译器在函数返回之前不必生成清理代码。
[[nodiscard]]：指定函数的返回值不应该被忽略。
[[deprecated("reason")]]：指定程序实体已经被弃用，并且提供了一个理由。
[[maybe_unused]]：指定程序实体可能未被使用，用于消除编译器的“未使用变量”的警告。
[[fallthrough]]：指定在 switch 语句中，如果一个 case 语句中没有 break 语句，允许掉落到下一个 case 语句中。
[[nodiscard("reason")]]：C++20 引入的，用于给 [[nodiscard]] 添加一个理由。
```

样例

```cpp
#include <iostream>
#include <string>
#include <initializer_list>
using namespace std;

[[nodiscard]] int fun()
{
    return 1;
}

int main(int argc, char **argv)
{
    fun();
    return 0;
}
/*警告信息
note: declared here
    6 | [[nodiscard]] int fun()
*/
```

## enumeration 与 enumerator

C++98/03 enumeration  
C++11 enumerator

```cpp
#include <iostream>
#include <string>
#include <initializer_list>
using namespace std;

// 不限定作用域的枚举，外部可以访问
enum
{
    RED,
    BLACK,
    BLUE
};
enum
{
    ORANGE,
    DARK
};
enum Type
{
    TEACHER,
    STUDENT
};
// c++11 enumberator
enum class Person
{
    men = 0,
    women
};

int main(int argc, char **argv)
{
    int n1 = RED;
    cout << n1 << endl;     // 0
    cout << ORANGE << endl; // 0
    n1 = TEACHER;
    // n1 = Person::men;//错误
    // cout << Person::men << endl;//错误
    Person person = Person::men; // 正确
    // Person person1 = 0;          // 错误
    // cout << person << endl;//错误
    cout << (person == Person::men) << endl; // 1
    int men = 0;                             // 合法作用域，不与枚举冲突
    return 0;
}
```

## final、override、default、delete

1、final

final 关键字修饰一个类，不允许被继承

```cpp
class A final{

};
class B:public A;//error
```

2、override

在父类中加了 virtual 关键字的方法可以被子类重写，子类重写该方法时可以加或者不加 virtual，默认为 virtual 的

可能存在两种问题

- 无论子类重写的方法是否添加了 virtual 关键字，都无法直观地确定该方法是否是重写的父类方法
- 如果在子类中写错了需要重写的方法的函数签名（参数类型、个数、返回值），那么方法变成了独立方法，违背初衷，编译时并不会检测到错误

```cpp
#include <iostream>
using namespace std;

// 抽象类型A
class A
{
public:
    virtual void run(int n) = 0;
    virtual void fun(double n);
};

void A::fun(double n)
{
}

// 必须实现void run(int n) 不然B也是抽象类
class B : public A
{
public:
    void run(int n) {}
    // void fun(float n) // 其实没有成功重写void func(double n),编译不会报错
    // {
    // }
    void fun(float n) override // 会报错
    {
    }
};

int main(int argc, char **argv)
{
    B b;
    return 0;
}
```

3、=default

如果一个 C++类没有显式给出构造函数、析构函数、拷贝构造函数、operator=这几个类函数的实现，则在需要时编译器会自动生成。但是在给出这些函数的声明时却没有给实现，则会在编译器链接时报错，如果用了=default 标记编译器会给出默认实现

```cpp
class Person{
public:
    Person(int n);
    Person()=default;
};
//只在cpp实现Person(int n) 即可
```

4、delete

禁止编译器生成构造函数、析构函数、拷贝构造函数、operator=

```cpp
#include <iostream>
using namespace std;

class Person
{
public:
    Person() = default;
    ~Person() = default;
    Person &operator=(const Person &o) = delete;
    Person(const Person &p) = delete;
};

int main(int argc, char **argv)
{
    Person person1;
    // Person person2 = person1; // 错误
    Person person3;
    // person1 = person3;//错误
    return 0;
}
```

其实还有些骚操作,对于函数的重载而言

```cpp
#include <iostream>
using namespace std;

void func(double f)
{
}
void func(float f) = delete;
void func(int f) = delete;

int main(int argc, char **argv)
{
    func(21.0);  // 正确
    func(12.3f); // 报错
    func(12);    // 报错
    return 0;
}
```

## 5.8 阅读 OK
