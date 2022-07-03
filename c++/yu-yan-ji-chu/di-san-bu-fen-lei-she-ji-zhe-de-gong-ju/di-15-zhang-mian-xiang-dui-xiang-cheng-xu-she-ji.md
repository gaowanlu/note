---
cover: >-
  https://images.unsplash.com/photo-1470470558828-e00ad9dbbc13?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHwyfHxUb3VyJTIwZGUlMjBGcmFuY2V8ZW58MHx8fHwxNjU2NzQ0MzE5&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🌽 第15章 面向对象程序设计

## 第15章 面向对象程序设计

学习本章将会得到，面向对象程序设计的三个基本概念，数据抽象、继承、动态绑定（多态）\
通过使用数据抽象，我们可以将类的接口与实现分离；\
使用继承可以定义类似的类型并对其相似关系建模；\
使用动态绑定，可以在一定程度上忽略类似类型的区别，而以统一的方式使用它们

### 继承

通常在层次关系的根部有一个基类即被继承的类，其他类则直接或简介地从基类继承而来，这些继承得来的类称为派生类

```cpp
//example1.cpp
class Person
{
public:
    virtual void print() const; //派生类必须实现virtual声明
};

class Mom : public Person
{
public:
    Mom() = default;
    void print() const override; //重写基类的方法
};

void Mom::print() const
{
    cout << "hello print" << endl;
}

int main(int argc, char **argv)
{
    Mom mom;
    mom.print(); // hello print
    return 0;
}
```

### 动态绑定

在有些地方下面的这种操作叫做面向对象里面的多态，在此我们暂且称其为动态绑定

```cpp
//example2.cpp
/**
 * @brief 基类人
 *
 */
class Person
{
public:
    virtual void print() const; //派生类必须实现virtual声明
};

/**
 * @brief 派生类母亲
 *
 */
class Mom : public Person
{
public:
    Mom() = default;
    void print() const override; //重写基类的方法
};
void Mom::print() const
{
    cout << "I am a mom\n"
         << flush;
}

/**
 * @brief 派生类儿子
 *
 */
class Son : public Person
{
public:
    Son() = default;
    void print() const override;
};
void Son::print() const
{
    cout << "I am a son\n"
         << flush;
}

//使用动态绑定
void cute(const Person &person)
{
    person.print();
}

int main(int argc, char **argv)
{
    Mom mom;
    Son son;
    cute(mom); // I am a mom
    cute(son); // I am a son
    return 0;
}
```

### 定义基类

```cpp
//example3.cpp
class Person
{
public:
    Person() = default;
    Person(const int &age, const string &name) : age(age), name(name)
    {
    }
    virtual ~Person() = default; //暂且记住就好
    virtual void print() const
    {
        cout << age << " " << name << endl;
    }

private:
    int age;
    string name;

protected:
    int code;
};

int main(int argc, char **argv)
{
    Person person(19, "me");
    person.print(); // 19 me
    return 0;
}
```

上面出现的新事物为

* virtual析构函数，暂且我们认为都要在基类中定义virtual析构函数好了，后面学习后就会知道为什么，除构造函数外的非静态函数都可以为虚函数
* protected访问控制，对于类本身protected的属性或方法相当于private的，有时需要派生类有权限访问但是其他禁止访问，就可以用protected控制
* virtual函数必须被派生类重新override

### 定义派生类

派生类要通过使用类派生列表指定从那些基类继承，每个基类前面可以有三种访问说明符的一个：public、protected、private，虽然C++支持从多个基类继承，但是这是面向对象编程极为不推荐的，通常我们约定只继承自一个类，称作为“单继承”

```cpp
//example4.cpp
//基类
class Person
{
public:
    Person() = default;
    Person(const int &age, const string &name) : age(age), name(name)
    {
    }
    virtual ~Person() = default; //暂且记住就好
    virtual void print() const
    {
        cout << age << " " << name << endl;
    }

private:
    int age;
    string name;

protected:
    int code;
};

//派生类
class Son : public Person
{
public:
    Son(int code = 0) : Person(19, "me")
    {
        this->code = code;
        // Son中可以访问基类的protected成员private的不可以
    }
    void print() const override
    {
        cout << code << endl;
        Person::print(); //调用基类的print方法
    }
};

int main(int argc, char **argv)
{
    Son son1;
    son1.print();
    // 0
    // 19 me
    return 0;
}
```

### 派生类向基类的转换

因为派生了对象中含有与基类对应的组成部分，所以我们能把派生类对象当成基类对象来使用，可以将基类的指针或者引用绑定到派生类对象中的基类的部分

```cpp
//example5.cpp
//基类
class Person
{
public:
    Person() = default;
    Person(const int &age, const string &name) : age(age), name(name)
    {
    }
    virtual ~Person() = default; //暂且记住就好
    virtual void print() const
    {
        cout << age << " " << name << endl;
    }

private:
    int age;
    string name;

protected:
    int code;
};

//派生类
class Son : public Person
{
public:
    Son(int code = 0) : Person(19, "me")
    {
        this->code = code;
        // Son中可以访问基类的protected成员private的不可以
    }
    void print() const override
    {
        cout << code << endl;
        Person::print(); //调用基类的print方法
    }
};

int main(int argc, char **argv)
{
    Person person;        //基类对象
    Son son(1);           //派生类对象
    Person *p = &son;     //基类型指针指向派生类的基类部分
    p->print();           // 1 19 me
    Person &ref = son;    //基类引用绑定到派生类的基类部分
    Person person1 = son; //将派生类的基类部分进行拷贝
    person1.print();      // 19 me
    return 0;
}
```

### 派生类的构造函数

在派生类的初始化列表中，除了可以初始化派生类在基类基础上添加的成员，还可以使用基类的构造函数，由基类的构造函数对基类部分进行初始化

```cpp
//example5.cpp
class Son : public Person
{
public:
    Son(int code = 0) : Person(19, "me")
    {
        this->code = code;
        // Son中可以访问基类的protected成员private的不可以
    }
    void print() const override
    {
        cout << code << endl;
        Person::print(); //调用基类的print方法
    }
};
```

如果不使用基类构造函数初始化基类部分，派生类对象的基类部分会像数据成员一样执行默认初始化，否则就要用基类构造函数\
也就是当没有显式调用基类构造函数时，会调用基类的默认构造函数，如果基类没有定义构造函数则会调用其合成默认构造函数\
`如果派生类没有指定使用的基类构造函数，且基类并没有默认构造函数，则会编译错误`\
`派生类构造函数初始化列表首先初始化基类部分，然后按照声明顺序依次初始化派生类成员`

### 派生类使用基类的属性成员

派生类可以访问基类的公有成员和受保护成员\
当派生类调用时会先在派生类部分寻找是否有同名称的成员，有则默认为使用派生类成员，如果没有则向基类部分寻找。也可以显式使用基类部分的成员。

```cpp
//example6.cpp
//基类
class Person
{
public:
    Person() = default;
    Person(const int &age, const string &name) : age(age), name(name)
    {
    }
    virtual ~Person() = default; //暂且记住就好
    virtual void print() const
    {
        cout << age << " " << name << endl;
    }

private:
    int age;
    string name;

protected:
    int code;
};

//派生类
class Son : public Person
{
public:
    Son(int mcode = 888) : Person(19, "me")
    {
        this->code = mcode;
        // Son中可以访问基类的protected成员private的不可以
        Person::code = 999;
    }
    void print() const override
    {
        cout << this->code << " " << Person::code << endl;
        //显式使用基类部分的code与派生类本身的code
    }
    int code;
};

int main(int argc, char **argv)
{
    Son s;
    s.print(); // 888 999
    return 0;
}
```

> 约定俗成的关键概念：遵循基类的接口，每个类负责定义各自的接口，要与此类交互必须使用该类的接口，即使这个对象是派生类的基类部分也是如此。派生类不能直接在初始化列表初始化基类部分的成员，尽管可以在基类构造函数体内对public或protected的基类部分赋值进行初始化，但是最好不要这样做。应该使用构造函数来初始化从基类中继承而来的成员

### 继承与static成员

基类中定义了静态成员，则在整个继承体系中只存在唯一一个成员的定义

```cpp
//example7.cpp
class Person
{
public:
    static string message;      //声明
    static const int code = 99; // static const=constexpr
    static void hello()
    {
        cout << message << endl;
    }
};

string Person::message = "hello";

class Son : public Person
{
public:
    Son() = default;
};

int main(int argc, char **argv)
{
    Person person;
    person.hello(); // hello
    Son::hello();   // hello Son继承了静态成员
    Son::message = "QQ";
    Son::hello();   // QQ
    person.hello(); // QQ
    //每个静态成员在继承体系中只有一个实体
    return 0;
}
```

### 派生类的声明

有些情景需要前置声明派生类，派生类的声明无需声明出继承列表，与普通类的声明相同

```cpp
class Son:public Person;//错误
class Son;//正确
```

### 被用作基类的类

被用作基类的类应该被定义而非仅仅声明，因为派生类需要只要继承了哪些内容

```cpp
//example8.cpp
class Person;             //基类声明
class Son : public Person //错误 Person为不完整类型
{
public:
    Son() = default;
};

// class Person
// {
// public:
//     static string message;      //声明
//     static const int code = 99; // static const=constexpr
//     static void hello()
//     {
//         cout << message << endl;
//     }
// };

// string Person::message = "hello";

int main(int argc, char **argv)
{
    Son son;
    return 0;
}
```

### 链式继承

一个派生类本身也可以作为基类，则继承则是从最顶层的基类、一层一层向下继承

```cpp
//example9.cpp
class Person
{
public:
    const int code = 1;
};

class Woman : public Person
{
public:
    const int code = 2;
};

class Mom : public Woman
{
public:
    void print()
    {
        cout << Person::code << " " << Woman::code << endl;
    }
};

int main(int argc, char **argv)
{
    Mom mom;
    mom.print();              // 1 2
    cout << mom.code << endl; // 2
    //沿着继承链向上找code到Mom直接基类Woman找到code命中
    return 0;
}
```

### 禁止类成为基类

有时需要使得一个类不被别的类继承，C++11中提供特性final关键词

```cpp
//example10.cpp
class Person
{
public:
    const int code = 1;
};

class Woman final : public Person // final
{
public:
    const int code = 2;
};

class Mom : public Woman //错误：不能将“final”类类型用作基类
{
public:
    void print()
    {
        cout << Person::code << " " << Woman::code << endl;
    }
};

int main(int argc, char **argv)
{
    Mom mom;
    return 0;
}
```

### 继承链上的析构调用

当一个派生类实例对象被销毁时，触发派生类析构函数，那么继承链上的析构函数也会被执行,是先调用派生类的析构函数，随后自动调用直接基类的析构函数...在执行间接基类析构函数向上进行下去知道根部

```cpp
//example11.cpp
class Person
{
public:
    const int code = 1;
    ~Person()
    {
        cout << "~Person" << endl;
    }
};

class Woman : public Person
{
public:
    const int code = 2;
    ~Woman()
    {
        cout << "~Woman" << endl;
    }
};

class Mom : public Woman
{
public:
    void print()
    {
        cout << Person::code << " " << Woman::code << endl;
    }
    ~Mom()
    {
        cout << "~Mom" << endl;
    }
};

int main(int argc, char **argv)
{
    {
        Mom mom;
    } //~Mom ~Woman ~Person
    return 0;
}
```
