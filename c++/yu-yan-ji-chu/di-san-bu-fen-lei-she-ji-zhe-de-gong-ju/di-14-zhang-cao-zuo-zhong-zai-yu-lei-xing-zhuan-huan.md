---
cover: >-
  https://images.unsplash.com/photo-1612735369300-f2d96e6eaeb4?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHwxfHx0ZXN8ZW58MHx8fHwxNjU2MjE0ODc4&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 📺 第14章 操作重载与类型转换

## 第14章 操作重载与类型转换

C++语言定义了大量运算符以及内置类型的自动转换规则，当运算符被用于类类型的对象时，C++语言允许我们为其指定新的含义，但无权发明新的运算符号

### 基本概念

可以被重载的运算符

![运算符](<../../../.gitbook/assets/屏幕截图 2022-06-26 104310.jpg>)

例重载+运算符的

```cpp
//example1.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}
    Person operator+(Person &person);
    void print()
    {
        cout << age << " " << name << endl;
    }
};

Person Person::operator+(Person &person)
{
    return Person(age + person.age, name + " " + person.name);
}

int main(int argc, char **argv)
{
    Person person1(19, "me");
    Person person2(19, "she");

    Person person3 = person1 + person2; //隐式调用
    person3.print();                    // 38 me she

    Person person4 = person1.operator+(person2); //显式调用
    person4.print();                             // 38 me she
    return 0;
}
```

### 某些运算符不应被重载

例如取址运算符与逗号运算符，它们本就有它们的存在的意义，重载它们使得规则变得混乱，一般来说它们不应被重载\
而逻辑与、逻辑或涉及到短路求值问题,通常情况下，不应重载逗号、取地址、逻辑与、逻辑或运算符

### 重载的返回值类型

重载运算符得返回类型通常情况应该与其内置版本得返回类型兼容：逻辑运算符和关系运算符返回bool、算数运算符返回一个类类型的值，赋值运算符和复合赋值运算符则应该返回左侧运算符对象的一个引用

```cpp
//example2.cpp
class Person
{
public:
    int age;
    Person(const int &age) : age(age){};
    bool operator<(const Person &person)
    {
        return age < person.age;
    }
    Person &operator+=(const Person &person)
    {
        age += person.age;
        return *this;
    }
};

//写为非成员函数 判断 person2>person1关系
bool operator>(const Person &person1, const Person &person2)
{
    return person2.age > person1.age;
}

int main(int argc, char **argv)
{
    Person person1(1);
    Person person2(2);
    cout << (person1 < person2) << endl; // 1
    person1 += person2;
    cout << person1.age << endl; // 3

    cout << (person1 > person2) << endl; // 0
    //显式调用
    cout << operator>(person1, person2) << endl; // 0

    return 0;
}
```

### 选择作为成员或者非成员

可见在`example2.cpp`中，语言允许直接重载operator相关函数，或者重载类的成员方法，那么什么时候作为成员函数，什么时候作为非成员函数呢

* 赋值(=)、下标(\[])、调用(())和成员访问箭头(->)运算符必须是成员
* 复合赋值一般作为成员
* 改变对象状态的运算符如递增、递减、解引用通常是成员
* 具有对成性的运算符，如算数、相等性、关系、位运算符，通常为普通的非成员函数

重点：当把运算符定义成成员函数时，它的左侧运算对象必须是运算符所属类的一个对象

```cpp
//example3.cpp
class Person
{
public:
    int age;
    Person(const int &age) : age(age) {}
    // Person+Person
    Person operator+(int a)
    {
        return Person(age + a);
    }
};

//支持Person-int
Person operator-(const Person &a, int n)
{
    return Person(a.age - n);
}

//支持 int-Person
Person operator-(int n, const Person &a)
{
    return Person(n - a.age);
}

int main(int argc, char **argv)
{
    Person person1(19);
    Person person2 = person1 + 1;
    // Person person3 = 1 + person1;//错误： 因为是调用+前面对象的operator+进行计算
    cout << person2.age << endl; // 20

    cout << person1.age << endl;       // 19
    cout << (person1 - 1).age << endl; // 18
    cout << (1 - person1).age << endl; //-18
    return 0;
}
```

### 重载输出运算符<<

也就是向某些IO类使用<<时右边对象的类型是我们自定义的类型\
第一个形参通常为IO对象的引用，第二个形参const对象的引用,可见输入输出运算符必须是非成员函数，如果是成员函数则因该是ostream与istream的方法，而不是我我们自定义类本身里的重载

```cpp
//example4.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name), num(rand() % 10) {}
    friend ostream &operator<<(ostream &os, const Person &person); //声明为Person的友元函数

private:
    int num;
};

ostream &operator<<(ostream &os, const Person &person)
{
    os << person.age << " " << person.name << " " << person.num;
    return os;
}

int main(int argc, char **argv)
{
    srand(time(NULL));
    Person person(19, "me");
    cout << person << endl; // 19 me 7
    return 0;
}
```

### 重载输入运算符>>

方法与<<运算符类似

```cpp
//example5.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}
};

istream &operator>>(istream &is, Person &person)
{
    is >> person.age >> person.name;
    if (is.fail())
    {
        person = Person(19, "me");
        throw runtime_error("error:input format of person error");
    }
    return is;
};

int main(int argc, char **argv)
{
    Person person1(19, "me");
    try
    {
        cin >> person1; // 20 she
    }
    catch (runtime_error e)
    {
        cout << e.what() << endl;
    }
    cout << person1.age << " " << person1.name << endl; // 20 she
    return 0;
}
```

### 算术运算符

形参通常为常量的引用，返回一个新的结果对象\
其他算数运算定义方法都是类似的

```cpp
//example6.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}
    Person operator*(const int &mul)
    {
        return Person(age * mul, name);
    }
    //复合赋值运算符
    Person &operator*=(const int &mul)
    {
        age *= mul;
        return *this;
    }
};

Person operator*(const Person &a, const Person &b)
{
    return Person(a.age * b.age, a.name);
}

int main(int argc, char **argv)
{
    Person a(19, "me");
    Person b(20, "as");
    cout << (a * b).age << endl;  // 380
    cout << (a * 10).age << endl; // 190
    a *= 11;
    cout << a.age << endl; // 209
    return 0;
}
```

### 相等运算符

参数为常量引用，返回值类型为布尔型

```cpp
//example7.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name)
    {
    }
    bool operator==(const Person &b)
    {
        return this == &b || (age == b.age && name == b.name);
    }
    bool operator!=(const Person &b)
    {
        return age != b.age || name != b.name;
    }
};

int main(int argc, char **argv)
{
    Person a(19, "me");
    Person b(19, "me");
    cout << (a != b) << endl; // 0
    cout << (a == b) << endl; // 1
    return 0;
}
```

如果某个类在逻辑上有相等性的含义，则改类应该定义operator==,这样做可以使得用户更容易使用标准库算法来处理这个类

### 关系运算符

特别是，关联容器和一些算法要用到小于运算符等，我们通常约定规范，当<或>成立时，==不成立、!=成立，同理==成立时<=与>=成立

```cpp
//example8.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name)
    {
    }
    bool operator<(const Person &b)
    {
        return age < b.age;
    }
};

int main(int argc, char **argv)
{
    Person a(19, "a");
    Person b(20, "b");
    cout << (a < b) << endl; // 1
    cout << (b < a) << endl; // 0
    return 0;
}
```

### 赋值运算符

函数参数为等号右侧对象，返回值通常为对象本身的引用\
复合赋值运算在example6.cpp已经涉及，再次不再描述

```cpp
//example9.cpp
class Person
{
public:
    vector<int> list;
    Person &operator=(initializer_list<int> init_list)
    {
        list.clear();
        list = init_list;
        return *this;
    }
    Person &operator=(const Person &b)
    {
        list = b.list;
        return *this;
    }
    friend ostream &operator<<(ostream &o, const Person &p);
};

ostream &operator<<(ostream &o, const Person &p)
{
    for (auto item : p.list)
    {
        o << item << " ";
    }
    return o;
}

int main(int argc, char **argv)
{
    Person person;
    person = {1, 2, 3, 4, 5};
    cout << person << endl; // 1 2 3 4 5
    initializer_list<int> list = {1, 2, 3, 4, 5};
    // Person b = list; //错误：赋值运算不是赋值构造哦
    //当Person有以list类型做参数的构造函数时可以调用，即类型转换构造函数

    Person b = person; //赋值拷贝构造只是特殊的情况
    cout << b << endl; // 1 2 3 4 5
    return 0;
}
```

### 下标运算符

下标运算符必须是成员函数,通常返回对象内部数的引用，参数为size\_t类型表示下标

```cpp
//example10.cpp
class Person
{
public:
    int *arr;
    Person(size_t n) : arr(new int[n])
    {
        for (size_t i = 0; i < n; i++)
        {
            arr[i] = i;
        }
    }
    //当对象不是const时
    int &operator[](const size_t &n)
    {
        return arr[n];
    }
    //当对象是const时
    const int &operator[](const size_t &n) const
    {
        return arr[n];
    }
    ~Person()
    {
        delete[] arr;
    }
};

int main(int argc, char **argv)
{
    Person person(10);
    person[0] = 100;
    cout << person[0] << endl; // 100
    const Person b(10);
    // b[0] = 99;
    // error: assignment of read-only location 'b.Person::operator[](0)'
    // cout << b[0] << endl;
    cout << b[0] << endl; // 0
    return 0;
}
```

### 递增和递减运算符

分为前置版本与后置版本，在C++中并不要求递增和递减运算符必须为类的成员

* 前置版本

```cpp
//example11.cpp
class Person
{
public:
    int age;
    Person(const int &age) : age(age)
    {
    }
    Person &operator++(); //前置版本
    Person &operator--();
};

Person &Person::operator++()
{
    ++age;
    return *this;
}

Person &Person::operator--()
{
    --age;
    return *this;
}

int main(int argc, char **argv)
{
    Person person(19);
    --person; // 18
    cout << person.age << endl;
    ++person;
    cout << person.age << endl; // 19
    
    cout << person.operator++().age << endl; // 20 显式调用
    return 0;
}
```

* 后置版本

重点在于如何区分前置版本与后置版本\
为了解决这个问题，后置版本接受一个额外的（不被使用）int类型形参，当使用后置运算符时编译器自动传递实参0

```cpp
//example12.cpp
class Person
{
public:
    int age;
    Person(const int &age) : age(age)
    {
    }
    Person operator++(int); //后置版本
    Person operator--(int);
    friend ostream &operator<<(ostream &os, const Person &person);
};

Person Person::operator++(int)
{
    //拷贝一份
    Person person = *this;
    ++age;
    return person; //返回原值
}

Person Person::operator--(int)
{
    Person person = *this;
    --age;
    return person;
}

ostream &operator<<(ostream &os, const Person &person)
{
    os << person.age;
    return os;
}

int main(int argc, char **argv)
{
    Person person(19);
    cout << person-- << endl; // 19
    cout << person << endl;   // 18
    cout << person++ << endl; // 18
    cout << person << endl;   // 19
    
    cout << person.operator++(0) << endl; // 19 显式调用
    cout << person << endl;               // 20
    return 0;
}
```

### 成员访问运算符

迭代器以及智能指针和普通指针等常常用到解引用\*与箭头运算符->

```cpp
//example13.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}
    string *operator->()
    {
        return &this->operator*();
    }
    string &operator*()
    {
        return name;
    }
};

int main(int argc, char **argv)
{
    Person person(19, "me");
    cout << person->c_str() << endl; // me
    (*person).assign("she");
    cout << person.name << endl; // she
    return 0;
}
```

### 箭头运算符返回值的限定

operator\*与operator->有区别，operator\*可以完成任何像完成的事情，其返回值不受限制，而operator->的目的是访问某些成员，其返回值类型有限定，箭头函数获取成员这个事实规则永远不变

```cpp
//example14.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}
    string *operator->()
    {
        return &this->operator*();
    }
    string &operator*()
    {
        return name;
    }
};

int main(int argc, char **argv)
{
    Person person(19, "me");
    cout << (*person).c_str() << endl; // me
    //下面两个操作是等价的
    cout << person.operator->()->c_str() << endl; // me
    cout << person->c_str() << endl;              // me
    return 0;
}
```

### 函数调用运算符

在C++总类可以重载函数调用运算符operator()

```cpp
//example15.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}
    int operator()(const char *templa) const
    {
        printf(templa, age);
        return age;
    }
};

int main(int argc, char **argv)
{
    Person person(19, "me");
    // age is 19
    cout << person("age is %d \n") << endl;
    // 19
    return 0;
}
```

这样的调用更像使用一种有状态的函数，我们把这类的对象称作为函数对象

### lambda是函数对象

当我们写了一个lambda表达式时，编译器将表达式翻译成一个未命名类的未命名对象

* 使用lambda表达式

```cpp
//example16.cpp
int main(int argc, char **argv)
{
    vector<int> vec = {3, 7, 5, 4, 2, 4, 4};
    stable_sort(vec.begin(), vec.end(), [](const int &a, const int &b)
                { return a < b; });
    printVec(vec); // 2 3 4 4 4 5 7
    return 0;
}
```

* 使用函数对象

```cpp
//example17.cpp
class IntSortFunc
{
public:
    bool operator()(const int &a, const int &b)
    {
        return a < b;
    }
};

int main(int argc, char **argv)
{
    IntSortFunc intSortFunc;
    vector<int> vec = {3, 7, 5, 4, 2, 4, 4};
    stable_sort(vec.begin(), vec.end(), intSortFunc);
    printVec(vec); // 2 3 4 4 4 5 7
    return 0;
}
```

二者实际上是等价的，通常我们要合理考虑要使用哪一种方式，定义函数对象可以进行复用但需要维护成本，而lambda随用随定义更加灵活便捷

* lambda及相应捕获行为的类

经过lambda的学习，知道lambda想要操控函数外部的数据需要进行lambda捕获操作,而在函数对象中则是利用对象的属性来进行类似的操作

```cpp
//example18.cpp
//lambda捕获
int main(int argc, char **argv)
{
    vector<int> vec = {7, 4, 5, 2, 31};
    size_t i = 0;
    stable_sort(vec.begin(), vec.end(), [&](const int &a, const int &b) -> bool
                { 
                i++;
                return a < b; });
    cout << i << endl; // 10
    return 0;
}
```

同样可以使用函数对象实现类似捕获的功能

```cpp
//example19.cpp
class IntSortFunc
{
public:
    size_t *i;
    IntSortFunc(size_t *i) : i(i) {}
    bool operator()(const int &a, const int &b)
    {
        ++*i;
        return a < b;
    }
};

int main(int argc, char **argv)
{
    vector<int> vec = {7, 4, 5, 2, 31};
    size_t i = 0;
    IntSortFunc intSortFunc(&i);
    stable_sort(vec.begin(), vec.end(), intSortFunc);
    cout << i << endl; // 10
    return 0;
}
```

至此我们又多了一种在函数之间传递函数的方法，以前我们使用函数指针、lambda表达式现在又可以使用函数对象进行类函数的传递

### 标准定义的函数对象

在C++标准库中定义了一些运算函数对象，其定义在头文件functional中

![标准库函数对象](<../../../.gitbook/assets/屏幕截图 2022-06-30 104551.jpg>)

```cpp
//example20.cpp
#include <iostream>
#include <functional>
#include <vector>
#include <algorithm>
#include "print.h"
using namespace std;

int main(int argc, char **argv)
{
    plus<int> p;
    cout << p(1, 2) << endl; // 3
    vector<int> vec = {6, 7, 3, 4, 5, 2, 3, 0};
    sort(vec.begin(), vec.end(), greater<int>());
    printVec(vec); // 7 6 5 4 3 3 2 0
    sort(vec.begin(), vec.end(), less<int>());
    printVec(vec); // 0 2 3 3 4 5 6 7
    return 0;
}
```

### 可调用对象与function

C++中可调用的对象种类有：函数、函数指针、lambda表达、bind创建的对象，重载了函数调用运算符的类

### 不同类型可能具有相同的调用形式

虽然可能具有相同的调用方式，但类型是不同的

```cpp
//example21.cpp
int add(int i, int j)
{
    return i + j;
}

//当lamba显式声明返回值类型为int时 与add同类型
//如果是自动推算不写->int则与add不是同类型
auto mod = [](int i, int j) -> int
{
    return i % j;
};

class divide
{
public:
    int operator()(int i, int j)
    {
        return i / j;
    }
};

int main(int argc, char **argv)
{
    //三者调用形式为int(int,int)但三者不是一个类型
    divide divideInstance;
    cout << add(1, 2) << " " << mod(5, 2) << " " << divideInstance(9, 3) << endl;
    // 3 1 3
    map<string, int (*)(int, int)> m_map;
    m_map.insert({"+", add});
    m_map.insert({"%", mod}); // mod显式声明了返回值类型
    // m_map.insert({"/", divideInstance});//错误：value类型不匹配
    auto fun = m_map.find("%")->second;
    cout << fun(5, 2) << endl; // 1
    return 0;
}
```

### 标准库function类型

其定义在functional头文件中

![function的操作](<../../../.gitbook/assets/屏幕截图 2022-06-30 111004.jpg>)

其本质为了解决统一调用方式相同的可调用对象

```cpp
//example22.cpp
int add(int i, int j)
{
    return i + j;
}

//当lamba显式声明返回值类型为int时 与add同类型
//如果是自动推算不写->int则与add不是同类型
auto mod = [](int i, int j) -> int
{
    return i % j;
};

class divide
{
public:
    int operator()(int i, int j)
    {
        return i / j;
    }
};

int main(int argc, char **argv)
{
    function<int(int, int)> f = add;
    cout << add(1, 2) << endl; // 3
    f = mod;
    cout << f(3, 2) << endl; // 1
    f = divide();
    cout << f(4, 2) << endl; // 2
    map<string, function<int(int, int)>> m_map;
    m_map.insert({"+", add});
    m_map.insert({"%", mod});
    m_map.insert({"/", divide()});
    cout << m_map["/"](10, 5) << endl; // 2
    return 0;
}
```

目前我们已经有了一种更好地在函数之间传递可调用对象地办法

```cpp
//example23.cpp
int func(function<int(int, int)> f)
{
    return f(100, 3);
}

int main(int argc, char **argv)
{
    int result = func([](int a, int b) -> int
                      { return a + b; });
    cout << result << endl; // 103
    //简直优雅极了是吧
    return 0;
}
```

### 函数的重载与function

在将函数赋给function时，如果函数有多种重载形式，编译器并不能自动推算出要使用哪一种，所以存在二义性，通常会使用下列方法进行解决

```cpp
//example24.cpp
int add(int a, int b)
{
    return a + b;
}

double add(double a, double b)
{
    return a + b;
}

int main(int argc, char **argv)
{
    function<int(int, int)> f = nullptr;
    // f = add; //错误：有重载 不知道使用那一个
    int (*fp)(int, int) = add; //先用函数指针存储指定的函数地址
    f = fp;                    //将函数地址赋给function
    cout << f(9, 5) << endl;   // 14
    
    // function向成员类型
    function<int(int, int)>::result_type a = 12;           // int a
    function<int(int, int)>::first_argument_type b = 100;  // int b
    function<int(int, int)>::second_argument_type c = 200; // int c
    function<int(int)>::argument_type d = 99;              // int d
    cout << a << " " << b << " " << c << " " << d << endl; // 12 100 200 99
    return 0;
}
```

### 类型转换运算符

形式为`operator type() const`,type是任意的，只要可以作为函数的返回值，因此不允许转换成数组或者函数类型

```cpp
//example25.cpp
class Person
{
public:
    int age;
    string name;
    Person(int age, string name) : age(age), name(name) {}
    operator int() const
    {
        return age;
    }
    operator string() const
    {
        return name;
    }
};

int main(int argc, char **argv)
{
    Person person(19, "me");
    int age = person;
    string name = person;
    cout << age << " " << name << endl; // 19 me

    double temp_double = person; //隐式自动转换
    cout << temp_double << endl;
    cout << person + 9.99 << endl; // 28.99
    //强制转换
    cout << (string)person << endl; // me
    return 0;
}
```

### 显式的类型转换运算符

在C++11中引入了显式的类型转换运算符，即定义的类型转换运算符方法只有在进行显式转换时才被调用

```cpp
//example26.cpp
class Person
{
public:
    int age;
    string name;
    Person(int age, string name) : age(age), name(name) {}
    operator int() const
    {
        return age;
    }
    explicit operator string() const
    {
        return name;
    }
};

int main(int argc, char **argv)
{
    Person person(19, "me");
    //隐式转换被禁止
    string name = person + "sx";
    cout << name << endl; // nothing
    //只能进行显式调用
    name = (string)person + "sx";
    cout << name << endl; // mesx
    return 0;
}
```

### IO类型有bool转换规则

IO类型对象的状态为good则会返回真，否则函数返回假

```cpp
//example27.cpp
int main(int argc, char **argv)
{
    ifstream i("./example27.iofile", fstream::app | fstream::in);
    cout << (bool)i << endl; // 1
    i.setstate(std::ios_base::badbit);
    if (i)
    {
        cout << "true" << endl;
    }
    else
    {
        cout << "false" << endl; // false
    }
    return 0;
}
```

### 避免有二义性的类型转换

* 转换构造函数与类型转换运算

最明显的情况就是在`A=B`时，A定义了B的转换构造函数，B定义了A的类型转换运算，则编译器应该用哪一个呢？\
编译器的不同，可能处理方法是不同的，但是在必要时可以使用显式调用

```cpp
//example28.cpp
class B;

class A
{
public:
    A(const B &b)
    {
        cout << "A(const B &b)" << endl;
    }
    A() = default;
};

class B
{
public:
    operator A()
    {
        cout << "operator A()" << endl;
        A a;
        return a;
    }
};
int main(int argc, char **argv)
{
    B b;
    A a = b;            // operator A()
    a = b;              // operator A()
                        //显式调用
    a = b.operator A(); // operator A()
    A a1(b);            // A(const B &b)
    return 0;
}
```

* 算术运算中的二义性

还有一种常见的二义性，如果两个类型转换都转成不同类型的数字，那么在算数运算时应该采用哪一种呢？\
最简单的方法就是使用显式转换调用

```cpp
//example29.cpp
class Person
{
public:
    int age;
    string name;
    Person(int age, string name) : age(age), name(name) {}
    operator double() const
    {
        return age;
    }
    operator long() const
    {
        return age;
    }
};

int main(int argc, char **argv)
{
    Person person(19, "me");
    long a = person;
    cout << a << endl; // 19
    double b = person;
    cout << b << endl; // 19
    // cout << person + 34.3 << endl;//错误：具有二义性 long or double ,ambiguous overloads
    return 0;
}
```

* 函数重载与转换构造函数二义性

下面的例子当传递int给func则会触发转换构造函数，有多个构造函数的参数都是int，所以会产生二义性，不知道何去何从

```cpp
//example30.cpp
class A
{
public:
    A(int n) {}
};

class B
{
public:
    B(int n) {}
};

void func(const A &a)
{
    cout << "void func(const A &a)" << endl;
}
void func(const B &b)
{
    cout << "void func(const B &b)" << endl;
}

int main(int argc, char **argv)
{
    // func(10); // call of overloaded 'func(int)' is ambiguous
    func(A(10)); // void func(const A &a)
    func(B(10)); // void func(const B &b)
    return 0;
}
```

还有一种变形情况，并不是只有当A B的构造函数接收相同的类型时才会冲突，当A与B构造函数的参数类型可以进行转换时就会引起二义性

```cpp
//example31.cpp
class A
{
public:
    A(int n) {}
};

class B
{
public:
    B(double n) {}
};

void func(const A &a)
{
    cout << "void func(const A &a)" << endl;
}
void func(const B &b)
{
    cout << "void func(const B &b)" << endl;
}

int main(int argc, char **argv)
{
    // func(10);    // call of overloaded 'func(int)' is ambiguous
    func(A(10)); // void func(const A &a)
    func(B(10)); // void func(const B &b)
    return 0;
}
```

### 函数匹配与重载运算符

定义运算符方法有两种形式，一种为类方法，一种为直接重载相关操作方法\
运算`a sym b`可能由`a.operatorsym(b)`或者`operatorsym(a,b)`处理，如果两个同时被定义，编译器也不知道要调用那一个

```cpp
//example32.cpp
class Person
{
public:
    int age;
    string name;
    Person(int age, string name) : age(age), name(name) {}
    Person(int age = 0) : age(age), name("") {}
    operator long() const
    {
        return age;
    }
    Person operator+(const Person &person)
    {
        cout << "Person operator+(const Person &person)" << endl;
        Person p(age + person.age, name);
        return p;
    }
};

Person operator+(const Person &a, const Person &b)
{
    cout << "Person operator+(const Person &a, const Person &b)" << endl;
    Person p(a.age + b.age, a.name);
    return p;
}

int main(int argc, char **argv)
{
    Person person1(19, "me");
    Person person2(19, "me");
    person1 + person2; // Person operator+(const Person &person)
    // 二义性
    // 78 + person1; // ambiguous overload for 'operator+' (operand types are 'int' and 'Person')
    //编译器不知道将78使用转换构造函数变为Person还是将person1转换为long类型
    //最简单的解决办法就是显式调用
    78 + person1.operator long(); // int + long
    // Person + Person
    Person(78) + person1; // Person operator+(const Person &person)
    return 0;
}
```

这一节的内容比较多，学习了如何定义运算符规则，有进一步深入了解lambda与函数对象、以及标准库的function对象、讨论了类型转换运算符以及经常出现的二义性问题
