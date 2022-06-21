# 🍍 第13章 拷贝控制

## 第13章 拷贝控制

从此章我们即将开始第三部分的学习，之前我们已经学过了两个部分，C++基础和C++标准库，第三部分为类设计者的工具\
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

默认情况下，编译器会定义一个拷贝构造函数，即使在我们提供拷贝构造函数的情况下也仍会自动生成,默认情况下会将每个非static成员拷贝到正在创建的对象中

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
如果不想让一个构造函数具有可以赋值转换的功能，则将其定义为explicit的

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

析构函数与构造函数不同，构造函数初始化对象的非static数据成员，还可能做一些在对象创建时需要做的事情。析构函数通常释放对象的资源，并销毁对象的非static数据成员

`~TypeName();`析构函数没有返回值，没有接收参数，所以其没有重载形式

在构造函数中，初始化部分执行在函数体执行前，析构函数则是首先执行函数体，然后按照初始化顺序的逆序销毁。

构造函数被调用的时机

* 变量在离开其作用域时被销毁
* 当一个对象被销毁时，其成员被销毁
* 容器（无论标准容器还是数组）被销毁时，其元素被销毁
* 动态内存分配，当对它的指针使用delete时被销毁
* 对于临时对象，当创建它的完整表达式结束时被销毁

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

在合成析构函数体执行完毕之后，成员会被自动销毁，对象中的string被销毁时，将会调用string的析构函数，将name的内存释放掉，`析构函数自身并不直接销毁成员`，是在析构函数体之后隐含的析构阶段中被销毁的，整个销毁过程，析构函数体是作为成员销毁步骤之外的并一部分而进行的

如果对象的内部有普通指针记录new动态内存，在对象析构过程默认只进行指针变量指针本身的释放，而不对申请的内存进行释放，则就需要动态内存章节学习的在析构函数体内手动释放他们，或者使用智能指针，随着智能指针的析构被执行，动态内存会被释放

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

在合成拷贝构造函数和合成拷贝赋值运算符，其中的拷贝操作都是简单的指针地址赋值，而不是重新开辟空间，再将原先的name赋值到新的内存空间

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

### =delete阻止拷贝

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

### private拷贝控制

在新标准之前没有，删除的成员，类是通过将其拷贝构造函数和拷贝赋值运算符声明为private的来阻止拷贝的

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

这种虽然类的外部不能使用拷贝构造和拷贝赋值，但是类的友元和成员函数仍可使用二者，同时想要阻止友元函数或者成员函数的使用，则只声明private成员即可不进行定义

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

总之优先使用=delete这种新的规范，delete是从编译阶段直接解决问题
