---
cover: >-
  https://images.unsplash.com/photo-1623864804069-438e36809fc2?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHwxMHx8Y29weXxlbnwwfHx8fDE2NTU3ODk2NTg&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🍍 第 13 章 拷贝控制

## 第 13 章 拷贝控制

从此章我们即将开始第三部分的学习，之前我们已经学过了两个部分，C++基础和 C++标准库，第三部分为类设计者的工具\
也就是我们即将开始传说中的对象对象编程之旅，面向对象程序设计(Object Oriented Programming)

本章进行学习类如何操控该类型的拷贝，赋值，移动或者销毁，有：拷贝构造函数、移动构造函数、拷贝赋值运算符、移动赋值运算符以及析构函数等重要知识

### 拷贝构造函数

定义：如果一个构造函数的第一个参数是自身类类型的引用，且任何额外参数都有默认值，则此构造函数是构造拷贝函数

简单上手

```cpp
//example1.cpp
class Person
{
public:
    int age;
    Person() = default;
    Person(int age) : age(age) {}
    Person(const Person &person)
    {
        //内容拷贝
        this->age = person.age;
    }
};

int main(int argc, char **argv)
{
    Person person1(19);
    Person person2 = person1;
    cout << person2.age << endl; // 19
    return 0;
}
```

### 合成拷贝构造函数

默认情况下，编译器会定义一个拷贝构造函数，即使在我们提供拷贝构造函数的情况下也仍会自动生成,默认情况下会将每个非 static 成员拷贝到正在创建的对象中

```cpp
//example2.cpp
class Person
{
public:
    int age;
    string name;
    Person() = default;
    Person(const Person &);
    Person(const int age, const string name) : age(age), name(name)
    {
    }
};

//直接使用构造函数初始化列表
//此定义与默认合成拷贝函数相同
Person::Person(const Person &person) : age(person.age), name(person.name)
{
}

int main(int argc, char **argv)
{
    Person me(19, "gaowanlu");
    Person other = me;
    // 19 gaowanlu
    cout << other.age << " " << other.name << endl;
    return 0;
}
```

尝试测试一下编译器默认提供的合成拷贝构造函数,可见存在默认合成拷贝构造函数\
如果不想让一个构造函数具有可以赋值转换的功能，则将其定义为 explicit 的

```cpp
//example3.cpp
class Person
{
public:
    string name;
    int age;
    Person(const int age, const string name) : name(name), age(age) {}
};

int main(int argc, char **argv)
{
    Person me(19, "gaowanlu");
    Person other = me;
    // 19 gaowanlu
    cout << other.age << " " << other.name << endl;
    return 0;
}
```

### 重载赋值运算符

重载`operator=`方法进行自定义赋值运算符使用时要做的事情

```cpp
//example4.cpp
class Person
{
public:
    int age;
    string name;
    Person() = default;
    Person(int age, string name) : age(age), name(name) {}
    Person &operator=(const Person &);
};

Person &Person::operator=(const Person &person)
{
    cout << "operator =" << endl;
    this->age = person.age;
    this->name = person.name;
    return *this;
}

int main(int argc, char **argv)
{
    Person person1(19, "me");
    Person person2;
    person2 = person1;                                  // operator =
    cout << person2.age << " " << person2.name << endl; // 19 me
    return 0;
}
```

### 合成拷贝赋值运算符

与合成拷贝构造函数类似，如果没有自定义拷贝赋值运算符，编译器会自动生成

```cpp
//example5.cpp
class Person
{
public:
    int age;
    string name;
    Person() = default;
    Person(int age, string name) : age(age), name(name) {}
};

int main(int argc, char **argv)
{
    Person person1(19, "me");
    Person person2;
    person2 = person1;                                  //使用默认合成拷贝赋值运算符
    cout << person2.age << " " << person2.name << endl; // 19 me
    return 0;
}
```

### 析构函数

析构函数与构造函数不同，构造函数初始化对象的非 static 数据成员，还可能做一些在对象创建时需要做的事情。析构函数通常释放对象的资源，并销毁对象的非 static 数据成员

`~TypeName();`析构函数没有返回值，没有接收参数，所以其没有重载形式

在构造函数中，初始化部分执行在函数体执行前，析构函数则是首先执行函数体，然后按照初始化顺序的逆序销毁。

构造函数被调用的时机

- 变量在离开其作用域时被销毁
- 当一个对象被销毁时，其成员被销毁
- 容器（无论标准容器还是数组）被销毁时，其元素被销毁
- 动态内存分配，当对它的指针使用 delete 时被销毁
- 对于临时对象，当创建它的完整表达式结束时被销毁

```cpp
//example6.cpp
class Person
{
public:
    int age;
    string name;
    Person() = default;
    Person(int age, string name) : age(age), name(name) {}
    ~Person()
    {
        cout << "~Person" << endl;
    }
};

Person func(Person person)
{
    return person;
}

int main(int argc, char **argv)
{
    Person person(19, "me");
    Person person1 = func(person);
    //~Person被打印三次
    //首先将person拷贝给func的形参，然后形参person作为返回值赋值给person1
    //然后func返回值person被销毁
    //随着main执行完毕，main内的两个Person被销毁
    return 0;
}
```

### 合成析构函数

当为自定义析构函数时，编译器会自动提供一个合成析构函数，对于某些类作用为阻止该类型的对象被销毁，如果不是则函数体为空

```cpp
//example7.cpp
class Person
{
public:
    int age;
    string name;
    Person() = default;
    Person(int age, string name) : age(age), name(name) {}
    ~Person() {} //等价于合成析构函数
};

int main(int argc, char **argv)
{
    Person person(19, "gaowanlu");
    cout << person.age << " " << person.name << endl; // 19 gaowanlu
    return 0;
}
```

在合成析构函数体执行完毕之后，成员会被自动销毁，对象中的 string 被销毁时，将会调用 string 的析构函数，将 name 的内存释放掉，`析构函数自身并不直接销毁成员`，是在析构函数体之后隐含的析构阶段中被销毁的，整个销毁过程，析构函数体是作为成员销毁步骤之外的并一部分而进行的

如果对象的内部有普通指针记录 new 动态内存，在对象析构过程默认只进行指针变量指针本身的释放，而不对申请的内存进行释放，则就需要动态内存章节学习的在析构函数体内手动释放他们，或者使用智能指针，随着智能指针的析构被执行，动态内存会被释放

### 三/五法则

有三个基本操作可控制类的拷贝操作：拷贝构造函数、拷贝赋值运算符、析构函数。在新标准下还可以通过定义一个移动构造函数、一个移动赋值运算符\
我们发现有时赋值运算符与拷贝构造函数会执行相同的功能，通常情况下并不要求定义所有这些操作

使用合成拷贝函数和合成拷贝赋值运算符时可能遇见的问题

```cpp
//example8.cpp
class Person
{
public:
    int age;
    string *name;
    Person(const string &name = string()) : name(new string(name)), age(0) {}
    ~Person()
    {
        delete name;
    }
};

int main(int argc, char **argv)
{
    {
        Person person1("me");
        Person person2 = person1; //使用合成拷贝构造函数
        //此时的person1.name与person2.name指向相同的内存地址
        *person1.name = "he";
        cout << *person2.name << endl; // he
    }
    cout << "end" << endl; // end
    return 0;
}
```

在合成拷贝构造函数和合成拷贝赋值运算符，其中的拷贝操作都是简单的指针地址赋值，而不是重新开辟空间，再将原先的 name 赋值到新的内存空间

### 使用=default

使用`=default`可以显式要求编译器生成合成拷贝构造函数和拷贝赋值运算符

```cpp
//example9.cpp
class Person
{
public:
    Person() = default;                //合成默认构造函数
    Person(const Person &) = default;  //合成拷贝构造函数
    Person &operator=(const Person &); //合成拷贝赋值运算
    ~Person() = default;               //合成析构函数
};

//默认在类内使用=default的成员函数为内联的
//如果不希望是内联函数则应在类外部定义使用=default
Person &Person::operator=(const Person &person) = default;

int main(int argc, char **argv)
{
    Person person1;
    Person person2 = person1;
    cout << "end" << endl; // endl
    return 0;
}
```

### =delete 阻止拷贝

`使用=delete`定义删除的函数

```cpp
//example10.cpp
class Person
{
public:
    Person() = default;
    Person(const Person &) = delete;            //禁止拷贝构造函数
    Person &operator=(const Person &) = delete; //阻止拷贝赋值
    ~Person() = default;
};

int main(int argc, char **argv)
{
    Person person1;
    // Person person2 = person1;//错误 不允许拷贝复制赋值
    return 0;
}
```

`析构函数不能是删除的成员`，否则就不能销毁此类型,没有析构函数的类型可以使用动态分配方式创建，但是不能被销毁

```cpp
//example11.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int age, const string name) : age(age), name(name) {}
    ~Person() = delete;
};

int main(int argc, char **argv)
{
    Person *person = new Person(19, "me");
    // delete person;//错误 Person没有析构函数
    return 0;
}
```

### 编译器将成员处理为删除的

对于某些情况，编译器会将合成的成员定义为删除的函数

重点：如果一个类有数据成员不能默认构造、拷贝、复制、销毁，则对应的成员函数将被定义为删除的

### private 拷贝控制

在新标准之前没有，删除的成员，类是通过将其拷贝构造函数和拷贝赋值运算符声明为 private 的来阻止拷贝的

```cpp
//example12.cpp
class Person
{
private:
    Person(const Person &person);
    Person &operator=(const Person &person);

public:
    int age;
    string name;
    Person(const int age, const string name) : age(age), name(name) {}
    ~Person() = default;
    Person() = default;
    void test();
};

Person::Person(const Person &person)
{
}
Person &Person::operator=(const Person &person)
{
    return *this;
}

void Person::test()
{
    Person *person = new Person(19, "me");
    Person person1 = *person; //函数成员或者友元函数可以使用
    delete person;
}

int main(int argc, char **argv)
{
    Person person1(19, "me");
    // Person person2 = person1;
    // error: 'Person::Person(const Person&)' is private within this context
    person1.test();
    return 0;
}
```

这种虽然类的外部不能使用拷贝构造和拷贝赋值，但是类的友元和成员函数仍可使用二者，同时想要阻止友元函数或者成员函数的使用，则只声明 private 成员即可不进行定义

```cpp
//example13.cpp
class Person
{
private:
    Person(const Person &person);            //只声明不定义
    Person &operator=(const Person &person); //只声明不定义

public:
    int age;
    string name;
    Person(const int age, const string name) : age(age), name(name) {}
    ~Person() = default;
    Person() = default;
    void test();
};

int main(int argc, char **argv)
{
    Person person1(19, "me");
    // Person person2 = person1;
    //  error: 'Person::Person(const Person&)' is private within this context
    // 如果函数成员或友元函数使用拷贝构造或者赋值 也会报错
    return 0;
}
```

总之优先使用=delete 这种新的规范，delete 是从编译阶段直接解决问题

### 行为像值的类

有些类拷贝是值操作，是一份相同得副本

```cpp
//example14.cpp
class Person
{
public:
    int *age;
    string *name;
    Person(const int &age, const string &name) : age(new int(age)), name(new string(name)) {}
    Person() : age(new int(0)), name(new string("")) {}
    Person &operator=(const Person &person);
    ~Person()
    {
        delete age, delete name;
    }
};

Person &Person::operator=(const Person &person)
{
    *age = *person.age;
    *name = *person.name;
    return *this;
}

int main(int argc, char **argv)
{
    Person person1(19, "me");
    Person person2(20, "she");
    person1 = person2;
    cout << *person1.age << " " << *person1.name << endl; // 20 she
    cout << *person2.age << " " << *person2.name << endl; // 20 she
    *person1.name = "gaowanlu";
    cout << *person1.age << " " << *person1.name << endl; // 20 gaowanlu
    cout << *person2.age << " " << *person2.name << endl; // 20 she
    //可见之间此类对象像一种值类型
    return 0;
}
```

### 行为像指针的类

有些类拷贝是指针指向的操作，也就是不同的类的成员会使用相同的内存

先来看一种简单使用的情况

```cpp
//example15.cpp
class Person
{
public:
    int *age;
    string *name;
    Person() : age(new int(0)), name(new string) {}
    Person(const int &age, const string &name) : age(new int(age)), name(new string(name)) {}
    Person &operator=(const Person &person);
};

Person &Person::operator=(const Person &person)
{
    if (age)
        delete age;
    if (name)
        delete name;
    age = person.age;
    name = person.name;
    return *this;
}

int main(int argc, char **argv)
{
    Person person1(19, "me");
    Person person2 = person1;
    // person1 person2的内容的内存是相同的
    *person2.age = 20;
    *person2.name = "gaowanlu";
    cout << *person1.age << " " << *person1.name << endl; // 20 gaowanlu
    cout << *person2.age << " " << *person2.name << endl; // 20 gaowanlu
    return 0;
}
```

### 实现引用计数

有意思的例子是我们也可以设计引用计数的机制，通过下面这个例子可以学到很多的编程思想

```cpp
//example16.cpp
class Person
{
public:
    string *name;
    int *age;
    Person(const int &age = int(0), const string &name = string("")) : use(new size_t(1)), age(new int(age)), name(new string(name)) {}
    //拷贝构造时
    Person(const Person &person)
    {
        name = person.name;
        age = person.age;
        use = person.use;
        ++*use; //引用数加一 不能写 *use++哦 因为那是*(use++)
    }
    //赋值拷贝时
    Person &operator=(const Person &person);
    //析构时
    ~Person();
    size_t *use; //引用计数器
};

//拷贝赋值
Person &Person::operator=(const Person &person)
{
    //递增右边对象的引用系数
    ++*person.use;
    //递减本对象引用计数
    --*use;
    if (*use == 0)
    {
        delete age, delete name, delete use;
    }
    age = person.age;
    name = person.name;
    use = person.use;
    return *this;
}

//析构
Person::~Person()
{
    //将引用数减1
    --*use;
    //判断引用数是否为0
    if (*use == 0)
    {
        delete age, delete name, delete use;
    }
}

int main(int argc, char **argv)
{
    Person person1(19, "me");
    cout << *person1.use << endl; // 1
    {
        Person person2(person1);
        cout << *person1.use << endl; // 2
        Person *ptr = new Person(person2);
        cout << *ptr->use << endl; // 3
        delete ptr;
        cout << *person1.use << endl; // 2
    }
    cout << *person1.use << endl; // 1
    //最后当person1销毁时 析构函数内引用计数变为0 随之将内存释放 达到内存管理的效果
    return 0;
}
```

### 编写 swap 函数

可以在类上定义一个自己的 swap 函数重载 swap 默认行为

```cpp
//example17.cpp
class Person
{
    //声明为友元函数可访问类私有成员
    friend void swap(Person &a, Person &b);

public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}
};

//定义函数 void swap(Person &a, Person &b);
inline void swap(Person &a, Person &b)
{
    std::swap(a.age, b.age);
    std::swap(a.name, b.name);
}

int main(int argc, char **argv)
{
    Person person1(19, "me");
    Person person2(19, "she");
    swap(person1, person2);
    cout << person1.age << " " << person1.name << endl; // 19 she
    cout << person2.age << " " << person2.name << endl; // 19 me
    return 0;
}
```

### 拷贝赋值运算中使用 swap

类的 swap 通常用来定义它们的赋值运算符，是一种拷贝并交换的技术

```cpp
//example18.cpp
class Person
{
    friend void swap(Person &a, Person &b);

public:
    int age;
    string name;
    Person &operator=(Person person);
    Person(const int &age, const string &name) : age(age), name(name) {}
};

// person为使用合成拷贝构造函数值复制
Person &Person::operator=(Person person)
{
    swap(*this, person); //二者内容交换
    return *this;
}

// Person的swap行为
inline void swap(Person &a, Person &b)
{
    a.age = b.age;
    a.name = b.name;
}

int main(int argc, char **argv)
{
    Person person1(19, "me");
    Person person2 = person1;
    cout << person2.age << " " << person2.name << endl; // 19 me
    return 0;
}
```

### 对象移动

什么是对象移动，也就是将对象移动到某处，即复制，但复制后就将原来的进行对象销毁了

标准库函数 `std::move`，标准库容器、string、shared_ptr 类即支持移动也支持拷贝，IO 类和 unique_ptr 类可以移动但不能拷贝

```cpp
//example19.cpp
#include <iostream>
#include <utility>
#include <string>
int main(int argc, char **argv)
{
    using namespace std;
    string a1 = "hello";
    string a2 = std::move(a1);
    cout << a1 << endl; // nothing
    cout << a2 << endl; // hello

    int b1 = 999;
    int b2 = std::move(b1); // int不是对象是基本数据类型不适用
    cout << b1 << endl;     // 999
    cout << b2 << endl;     // 999
    return 0;
}
```

### 左值和右值

C++中左值一般是指一个指向特定内存的具有名称的值，它有一个相对稳定的内存地址，有一段较长的生命周期，而右值则是不指向稳定内存地址的匿名值，生命周期短，通常是暂时的。可以简单的认为，可以取到左值的地址，但右值取不到地址

```cpp
int x=1;//x左值 1右值
int y=3;//y左值 3右值
int z=x+y;//z左值 x+y右值
```

有趣的例子,++x 是左值其返回自身，而 x++将 x 拷贝了一份然后才对 x 递增，最后返回临时复制的内容

```cpp
#include <iostream>
using namespace std;

int x;

int main(int argc, char **argv)
{
    x = 0;
    int *p1 = &x;
    // int *p2 = &x++;//错误x++返回的是右值 无法取得地址
    int *p3 = &++x;
    cout << p1 << " " << p3 << endl;
    if (p1 == p3)
    {
        cout << boolalpha << true << endl; // true
    }
    return 0;
}
```

函数的返回值是左值还是右值，不做特殊处理的话是右值

```cpp
#include <iostream>
using namespace std;

int x;

int get_set(int val) // val为左值
{
    x = val;
    return x; // x为左值，但是返回的时候会将x复制一份然后返回，实际返回内容为右值
}

int main(int argc, char **argv)
{
    get_set(888); // 888是右值
    return 0;
}
```

通常字面量为右值，除字符串字面量以外,编译器会将字符串字面量存储到程序的数据段中，程序加载的时候也会为其开辟内存空间，所以可以使用取地址操作符获得字符串字面量的内存地址

```cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    auto str = &"hello world";
    // const char (*str)[12] str
    // str 指向长度12的char的const数组
    cout << str << endl; // 0x406045
    auto str1 = &"hello world";
    cout << str1 << endl; // 0x406045
    return 0;
}
```

### 右值引用

什么是右值引用，右值引用为支持移动操作而生，右值引用就是必须绑定到右值的引用，使用&&而不是&来获得右值引用

左值与右值的声明周期，左值有持久的状态直到变量声明到上下文切换内存释放，右值要么是字面量或者求值过程中的临时对象\
右值引用特性：

- 所引用的对象将要被销毁
- 该对象没有其他用户
- 无法将右值引用绑定到右值引用

```cpp
//example20.cpp
int main(int argc, char **argv)
{
    int num = 666;
    int &ref = num; //引用
    // int &&refref = num; //错误：不能将右值引用绑定到左值上
    // int &ref1 = num * 42; //错误：i*42为右值
    const int &ref2 = num * 42; // const引用可绑定到右值上
    int &&refref1 = num * 10;   // 右值引用可以绑定在右值上
    cout << refref1 << endl;    // 6660
    refref1 = 999;
    cout << refref1 << endl; // 999 而且与使用普通变量没什么区别

    // int &&refref2 = refref1; //错误：无法将右值引用绑定到左值
    return 0;
}
```

### move 与右值引用

虽然不能将右值引用绑定在左值上，但可以通过 std::move 来实现

```cpp
//example21.cpp
int main(int argc, char** argv)
{
    int num = 999;
    // int &&rr1 = num; //错误 无法将右值引用绑定到左值
    string stra = "hello";
    string&& straRef = std::move(stra);
    cout << "1 "<<stra << endl;    // hello
    cout << "2 "<<straRef << endl; // hello

    stra = "world";
    cout << "3 "<<straRef << endl; // world
    //可见straRef绑定定在了stra上
    straRef = "c++";
    cout <<"4 "<< stra << endl;//c++


    string a = "world";
    string b = std::move(a); //move返回一个右值引用，调用string的移动构造函数构造b
    // move函数的表现根据等号左侧的类型的不同随之行为也不同
    cout <<"5 "<< a << endl;       // nothing
    cout <<"6 "<< b << endl;       // world

    return 0;
}
```

### 右值引用做参数

右值引用的最大贡献就是将临时变量的声明周期延长，减少临时变量的频繁销毁，内存的利用效率也会变高，当右值表达式被处理后结果存放在会块临时内存空间，右值引用指向它，则可以利用，直到指向它的右值引用全部被销毁，内存才会被释放

```cpp
//example22.cpp
class Person
{
public:
    string name;
    Person(const string &name) : name(name)
    {
        cout << "string &name" << endl;
    }
    Person(string &&name) : name(name)
    {
        cout << "string &&name" << endl;
    }
};
// const引用与右值引用重载时 传递右值时 右值引用的优先级高

int main(int argc, char **argv)
{
    //创建临时变量"hello"
    Person person1("hello"); // string&&name

    string s = "world";
    Person person2(s); // string &name
    return 0;
}
```

### 右值和左值引用成员函数

在旧标准中，右值可以调用相关成员函数与被赋值

```cpp
//example23.cpp
int main(int argc, char **argv)
{
    string hello = "hello";
    string world = "world";
    cout << (hello + world = "nice") << endl; // nice 右值被赋值
    return 0;
}
```

### &左值限定符

怎样限定赋值时右边只能是可修改的左值赋值，引入了引用限定符(reference qualifier)，使得方法只有对象为左值时才能被使用

```cpp
//example24.cpp
#define USE_LIMIT

class Person
{
public:
    string name;
#ifdef USE_LIMIT
    Person &operator=(const string &) &; //引用限定符 等号左侧必须为可修改的左值
#else
    Person &operator=(const string &);
#endif
    Person(string &&name) : name(name)
    {
    }
    inline void print()
    {
        cout << this->name << endl;
    }
};

#ifdef USE_LIMIT
Person &Person::operator=(const string &name) & //引用限定
#else
Person &Person::operator=(const string &name)
#endif
{
    this->name = name;
    return *this;
}

Person func()
{
    return Person("me");
}

int main(int argc, char **argv)
{
    func() = "hello"; // func()返回右值
    //当define USE_LIMIT时发生错误
    //没有define USE_LIMIT时不会发生错误
    return 0;
}
```

### const 与&左值限定符

一个方法可以同时用 const 和引用限定，引用限定必须在 const 之后

```cpp
//example25.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age = 19, const string &name = "me") : age(age), name(name)
    {
    }
    void print() const &
    {
        cout << age << " " << name << endl;
    }
};

//func返回右值
Person func()
{
    return Person(19, "she");
}

int main(int argc, char **argv)
{
    func().print();
    //当print不是const&时报错,例如只有引用限定符&，只有const不报错
    //很鸡肋没什么卵用
    //当有const时 &限定作用消失了
    return 0;
}
```

### &&右值引用限定符

可以使用`&&`进行方法重载，使其为可改变的右值服务\
当一个方法名字相同 函数参数列表相同时 有一个有引用限定，全部都应该有引用限定或者全部都没有

```cpp
//example26.cpp
class Foo
{
public:
    Foo sort() &&;
    Foo sort() const &;
    //当一个方法名字相同 函数参数列表相同时 有一个有引用限定
    //全部都应该有引用限定或者全部都没有
};

Foo Foo::sort() &&
{
    cout << "&&" << endl;
    return *this;
}

Foo Foo::sort() const &
{
    cout << "const &" << endl;
    return *this;
}

// func返回右值
Foo func()
{
    return Foo();
}

int main(int argc, char **argv)
{
    Foo foo1;
    foo1.sort();   // const &
    func().sort(); //&&
    //如果没有定义Foo Foo::sort() && 二者都会调用 Foo Foo::sort() const &
    return 0;
}
```

### 移动构造函数和移动赋值运算符

资源移动实例，嫖窃其他对象的内存资源,与拷贝构造函数类似，移动构造函数第一个参数也是引用类型，但只不过是右值引用，任何额外参数必须有默认实参

```cpp
//example27.cpp
class Person
{
public:
    int *age;
    string *name;
    Person(const int &age, const string &name) : age(new int(age)), name(new string(name))
    {
    }
    //移动操作不应抛出任何异常
    Person(Person &&person) noexcept //”盗窃“资源 这是个移动构造函数不是 拷贝构造函数
    {
        delete age, delete name;
        age = person.age;
        name = person.name;
        person.age = nullptr;
        person.name = nullptr;
    }
    void print();
};

void Person::print()
{
    if (age && name)
    {
        cout << *age << " " << *name;
    }
    cout << endl;
}

int main(int argc, char **argv)
{
    Person person1(19, "me");
    Person person2 = std::move(person1);
    person1.print(); // nothing
    person2.print(); // 19 me
    return 0;
}
```

### 移动赋值运算符

与拷贝类似，可以也可以重载赋值运算符来实现对象的移动功能

```cpp
//example28.cpp
class Person
{
public:
    int *age;
    string *name;
    Person(const int &age, const string &name) : age(new int(age)), name(new string(name))
    {
        cout << "Person(const int &age, const string &name)" << endl;
    }
    Person &operator=(Person &&person) noexcept;//移动赋值运算符
    Person(const Person &person) : age(person.age), name(person.name)
    {
        cout << "Person(const Person &person)" << endl;
    }
    void print();
};

Person &Person::operator=(Person &&person) noexcept
{
    cout << "Person &Person::operator=(Person &&person)" << endl;
    if (&person != this)
    {
        delete age, delete name;
        age = person.age;
        name = person.name;
        person.age = nullptr;
        person.name = nullptr;
    }
    return *this;
}

void Person::print()
{
    if (age && name)
    {
        cout << *age << " " << *name;
    }
    cout << endl;
}

//返回右值
Person func()
{
    return Person(19, "she"); // Person(const int &age, const string &name) 2
}

int main(int argc, char **argv)
{
    Person person2(18, "oop"); // Person(const int &age, const string &name) 1
    person2 = func();          // Person &Person::operator=(Person &&person)
    person2.print();           // 19 she

    Person person1 = std::move(person2);//person2移动到person1
    cout << *person1.age << " " << *person2.name << endl; // 19 she
    return 0;
}
```

### 合成的移动操作

只有当一个类没有定义任何自己版本的拷贝控制成员时，且所有数据成员都能进行移动构造或移动赋值时，编译器才会合成移动构造函数或移动赋值运算符\
当一定义了拷贝控制成员，如自定义了拷贝构造拷贝拷贝赋值时，将不会提供合成的移动操作

```cpp
//example29.cpp
class X
{
public:
    int i;    //内置类型可以移动
    string s; // string定义了自己的移动操作
};

class HasX
{
public:
    X member; // X有合成的移动操作
};

int main(int argc, char **argv)
{
    X x1;
    x1.i = 100;
    x1.s = "me";
    cout << x1.i << " " << x1.s << endl; // 100 me
    // X移动
    X x2 = std::move(x1);
    cout << x2.i << " " << x2.s << endl; // 100me
    cout << x1.i << " " << x1.s << endl; // 100 nothing
    // HasX移动
    HasX hasx;
    hasx.member.i = 99;
    hasx.member.s = "me";
    HasX hasx1 = std::move(hasx);
    cout << hasx1.member.i << " " << hasx1.member.s << endl; // 99 me
    return 0;
}
```

本质上 move 的使用就是调用了拷贝构造函数，但拷贝构造是值拷贝还是指针拷贝有我们自己定义

```cpp
//example30.cpp
class Y
{
public:
    int age;
    Y() = default;
    Y(const Y &y) //拷贝构造 则 Y没有合成的移动操作
    {
        this->age = age;
    };
    // Y(Y &&y)
    // {
    //     age = y.age;
    //     y.age = 0;
    // }
};

class HasY
{
public:
    HasY() = default;
    Y member;
};

int main(int argc, char **argv)
{
    HasY hasy;
    hasy.member.age = 999;
    HasY hasy1 = std::move(hasy);     //因为Y没有移动操作
    cout << hasy1.member.age << endl; //乱码 hasy为一个新对象,为Y添加自定义移动构造函数则输出999
    cout << "end" << endl;            // end
    return 0;
}
```

### 拷贝构造与移动构造的匹配

当一个类既有移动构造函数，也有拷贝构造函数，当我们使用哪一个，会根据函数匹配规则来确定

```cpp
//example31.cpp
class Person
{
public:
    Person() = default;
    Person(const Person &person)
    {
        cout << "Person(const Person &person)" << endl;
    }
    Person(Person &&person)
    {
        cout << "Person(Person &&person)" << endl;
    }
};

int main(int argc, char **argv)
{
    Person person1;
    Person person2(person1); // Person(const Person &person)

    const Person person3;
    Person person4(person3); // Person(const Person &person)

    //而移动构造只接受右值
    Person person5 = std::move(person4); // Person(Person &&person)

    return 0;
}
```

要注意的是，当有拷贝构造函数没有移动构造函数时，右值也将被拷贝

```cpp
//example32.cpp
class Person
{
public:
    int age;
    string name;
    Person() = default;
    Person(const Person &person) : age(person.age), name(person.name)
    {
        cout << " Person(const Person &person)" << endl;
    }
};

int main(int argc, char **argv)
{
    Person person1;
    // std::move的作用就是将person1作为右值传递
    Person person2(std::move(person1)); // Person(const Person &person)
    //当存在移动构造时则会优先使用移动构造
    return 0;
}
```

### 拷贝并交换赋值运算符和移动操作

当定义了移动构造函数，且定义了赋值运算符，但无定义移动赋值方法，则将一个右值赋给左值时，将会先使用移动构造函数构造新对象，然后将新对象赋值给原左值，类似地隐含了移动赋值

```cpp
//example33.cpp
class Person
{
public:
    int age;
    string name;
    Person() = default;
    Person(const int &age, const string &name) : age(age), name(name){};
    //移动构造函数
    Person(Person &&p) noexcept : age(p.age), name(p.name)
    {
        cout << "Person(Person &&p)" << endl;
        p.age = 0;
        p.name = "";
    }
    //拷贝构造
    Person(const Person &p) : age(p.age), name(p.name)
    {
        cout << "Person(const Person &p)" << endl;
    }
    //赋值运算符 也是 移动赋值运算符 也是拷贝赋值运算符
    Person &operator=(Person p)
    {
        cout << "Person &operator=(Person p)" << endl;
        age = p.age;
        name = p.name;
        return *this;
    }
};

int main(int argc, char **argv)
{
    Person person1(19, "me"); //构造函数
    //显式调用移动构造函数
    Person person2(std::move(person1));                 // Person(Person &&p)
    cout << person1.age << " " << person1.name << endl; // 0 nothing

    Person person3(19, "me");     //构造函数
    Person person4;               //默认构造函数
    person4 = std::move(person3); //先使用移动构造函数生成新对象 将新对象赋值给person4
    // Person(Person &&p) Person &operator=(Person p)
    cout << person4.age << " " << person4.name << endl; // 19 me
    return 0;
}
```

### 移动迭代器

移动迭代器解引用返回一个指向元素的右值引用

通过标准库`make_move_iterator`函数可以将一个普通迭代器转换为移动迭代器返回

```cpp
//example34.cpp
int main(int argc, char **argv)
{
    vector<string> vec = {"aaa", "bbb"};
    auto iter = make_move_iterator(vec.begin());
    // auto std::move_iterator<std::vector<std::string>::iterator>
    allocator<string> allocat;
    string *ptr = allocat.allocate(10);
    uninitialized_copy(make_move_iterator(vec.begin()), make_move_iterator(vec.end()), ptr);
    cout << vec[0] << " " << vec[1] << endl; //空字符串
    cout << ptr[0] << " " << ptr[1] << endl; // aaa bbb
    //可见使用移动迭代器进行了移动操作
    return 0;
}
```

本质上是标准库算法在背后使用了移动迭代器解引用，进而相当于 string*a=std::move(stringb),将 stringb 移动到了 stringa*\
只有当数据类型支持移动赋值时移动迭代器才显得有意义
