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

一个派生类本身也可以作为基类，则继承则是从最顶层的基类、一层一层向下继承\
对与派生类调用基类构造函数对基类部分初始化，重点是`派生类构造函数只初始化它的直接基类`，直接基类又是其他类的派生类，向上套娃下去

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

### 虚函数

前面看见某些方法使用了virtual关键词修饰，当使用基类调用一个虚成员函数时会执行动态绑定，每一个虚函数都应提供定义，不管是否被用到，直到运行时才知道到底调用了那个版本的虚函数

当一个类中有virtual成员方法时，但是其没有定义那么这个类是不能用来创建对象的，只有其内virtual全部都有一定是才可以

```cpp
//example12.cpp
class Person
{
public:
    string name;
    int age;
    Person(const int &age, const string &name) : age(age), name(name) {}
    virtual void print();//错误 virtual成员没有被定义
};

int main(int argc, char **argv)
{
    Person person(19, "me");
    return 0;
}
```

当使用指针或者引用调用虚函数时，将会发生动态绑定

```cpp
//example12.cpp
class Person
{
public:
    string name;
    int age;
    Person(const int &age, const string &name) : age(age), name(name) {}
    virtual void print() const
    {
        cout << "Person " << age << " " << name << endl;
    }; //错误 virtual成员没有被定义
};

class Mom : public Person
{
public:
    Mom() : Person(19, "mom") {}
    void print() const override
    {
        cout << "Mom " << age << " " << name << endl;
    }
};

class Son : public Person
{
public:
    Son() : Person(19, "son") {}
    void print() const override
    {
        cout << "Son " << age << " " << name << endl;
    }
};

void func(Person &person)
{
    person.print(); //发生动态绑定
    //调用哪一个print完全取决于person绑定的实际对象
}

void execute(Person person)
{
    person.print(); // Person 19 son
    //不会发生动态绑定
    //因为person不是指针类型或者引用类型
    //他仅仅是一个person对象
}

int main(int argc, char **argv)
{
    Mom mom;
    Son son;
    Person person(19, "me");
    func(mom);    // Mom 19 mom
    func(son);    // Son 19 son
    func(person); // Person 19 me
    execute(son);
    return 0;
}
```

### 派生类中的虚函数

当派生类override了某个虚函数，可以再次使用virtual关键字指出函数性质，但是可以省略，因为一旦某个类方法被声明为虚函数，则在所有派生类中它都是虚函数

```cpp
//example14.cpp
class Person
{
public:
    string name;
    int age;
    Person(const int &age, const string &name) : age(age), name(name) {}
    virtual void print() const
    {
        cout << "Person " << age << " " << name << endl;
    }; //错误 virtual成员没有被定义
    virtual Person *self()
    {
        return this;
    }
};

class Mom : public Person
{
public:
    Mom() : Person(19, "mom") {}
    //即使不显式指定virtual其也是virtual的
    virtual void print() const override
    {
        cout << "Mom " << age << " " << name << endl;
    }
    // 特殊的情况
    // override本应返回类型 函数名 参数列表都应相同
    // 但是仅当但会自己的指针或者引用时特殊,因为会可以发生动态绑定
    Mom *self() override
    {
        return this;
    }
};

int main(int argc, char **argv)
{
    Mom mom;
    mom.self()->print(); // Mom 19 mom
    return 0;
}
```

### final和override说明符

当派生类中定义一个名称与基类相同但是参数列表不同的方法，这是完全合法的，但是写代码就会出现些问题，目的就是覆盖掉基类的方法，但是不知道覆盖是否正确，这也正是override的作用

```cpp
//example15.cpp
class Person
{
public:
    string name;
    int age;
    Person(const int &age, const string &name) : age(age), name(name) {}
    virtual void f1(){};
    virtual void f2() const {};
};

class Mom : public Person
{
public:
    //当Person内的virtual全部有定义是才能使用Person构造函数
    Mom() : Person(19, "mom") {}
    /*
    void f1(int age) override //错误 override失败编译不通过
    {
        cout << "Mom f1" << endl;
    }*/
    void f1() override {}    // override正确
    void f2() const override // override正确
    {
    }
    void f2(string message) //方法重载但与override无关
    {
        cout << message << endl;
    }
};

int main(int argc, char **argv)
{
    Mom mom;
    mom.f1();
    mom.f2();
    mom.f2("hello world"); // hello world
    return 0;
}
```

final关键词作用域类则是禁止一个类作为基类，作用于类方法则是禁止派生类对其进行重写,重要的是final只能作用于virtual成员函数

```cpp
//example16.cpp
class Person
{
public:
    string name;
    int age;
    Person(const int &age, const string &name) : age(age), name(name) {}
    // final只能作用于virtual成员
    virtual void f1() final
    {
        cout << "f1" << endl;
    }
    void f2()
    {
        cout << "Person f2" << endl;
    }
};

class Mom : public Person
{
public:
    Mom() : Person(19, "mom") {}
    // void f1(){}//错误 void f1()禁止被重写
    void f2()
    {
        cout << "Mom f2" << endl;
    }
};

int main(int argc, char **argv)
{
    Mom mom;
    mom.f1(); // f1
    mom.f2(); // Mom f2
    return 0;
}
```

### 虚函数默认参数

虚函数直接的重写关系，只关注函数的返回类型与函数参数类型与个数以及顺序，而不关注有无参数默认值

重点：如果某次函数调用使用了默认参数，则该实参值由本次调用的静态类型决定，简单点说就是，如果是通过基类的引用或者指针调用函数，则使用基类中定义的默认实参，然后执行基类指针或者引用指向的实际对象中的此方法的函数体代码

最佳实践：虚函数使用默认实参，则基类和派生类中定义的默认参数最好一致

```cpp
//example17.cpp
class Person
{
public:
    string name;
    int age;
    Person(const int &age, const string &name) : age(age), name(name) {}
    virtual void f1(int n = 1)
    {
        cout << "f1 " << n << endl;
    }
};

class Mom : public Person
{
public:
    Mom() : Person(19, "mom") {}
    void f1(int n = 3) override
    {
        cout << "Mom f1 " << n << endl;
    }
};

class Son : public Person
{
public:
    Son() : Person(19, "son") {}
    void f1(int n) override
    {
        cout << "Son f1 " << n << endl;
    }
};

void func(Person &person)
{
    person.f1();
}

int main(int argc, char **argv)
{
    Mom mom;
    mom.f1(); // Mom f1 3
    Person person(19, "me");
    person.f1(); // f1 1

    Son son;
    son.f1(5); // Son f1 5 必须提供实参

    //神奇的一幕 func中没有提供f1实参 没有报错
    //而是匹配到了基类的f1有默认值
    //进而使用了基类f1的默认值 然后执行了派生类的f1
    func(son); // Son f1 1
    return 0;
}
```

### 回避虚函数机制

例如在链式继承中，一个底部的派生类赋给了基类的引用或者指针，有时想要明确指定调用谁的虚函数，而不是默认的动态绑定，则可以使用作用域运算符实现\
格式为 `object.BaseClassName::Method()`或者`objectPtr->BaseClassName::Method()`\
在C++继承中，继承链上的每个类的内容都是真实存在的，因为创建一个派生类，默认会调用继承链上基类的构造函数

```cpp
//example18.cpp
class Person
{
public:
    const int code = 1;
    virtual void printCode()
    {
        cout << "Person code " << code << endl;
    }
};

class Woman : public Person
{
public:
    const int code = 2;
    void printCode() //重写
    {
        cout << "Woman code " << code << endl;
    }
};

class Mom : public Woman
{
public:
    const int code = 3;
    void printCode() //重写
    {
        cout << "Mom code " << code << endl;
    }
};

int main(int argc, char **argv)
{
    Mom mom;
    mom.printCode();         // Mom code 3
    mom.Person::printCode(); // Person code 1
    mom.Woman::printCode();  // Woman code 2
    Mom *const ptr = &mom;
    ptr->Person::printCode(); // Person code 1
    return 0;
}
```

### 抽象类与纯虚函数

有些类只是用来在中间做基类，其中有一些方法，但是只创建一个此对象是没有意义的，很类似java里面的抽象类，抽象类不能被创建对象实例，其实际的意义就是给别人做基类\
纯虚函数在类内声明时后面添加`=0`,纯虚函数也可以被定义，但是其定义只能在类外定义，只能在类内声明

含有（或者未经覆盖直接继承）纯虚函数的类是抽象基类，抽象基类负责定义接口，而后续的其他类可以覆盖该接口。\
不能直接创建一个抽象基类的对象，派生类必须给出纯虚函数覆盖定义，否则它仍是抽象基类

```cpp
//example19.cpp
class Person
{
public:
    const int code = 1;
    virtual void printCode()
    {
        cout << "Person code " << code << endl;
    }
};

// Woman含有纯虚函数 为抽象类
class Woman : public Person
{
public:
    const int code = 2;
    void printCode() = 0; //纯虚函数 Woman对象不能被创建
};

//纯虚函数也可以被定义
void Woman::printCode()
{
    cout << this->Person::code << endl;
}

class Mom : public Woman
{
public:
    void printCode() override
    {
        cout << this->code << endl; // 2
        this->Woman::printCode();   // 1
    }
};

int main(int argc, char **argv)
{
    Mom mom;
    mom.printCode(); // 2 1
    // Woman woman;     //错误 不允许使用抽象类类型 "Woman" 的对象:
    return 0;
}
```

### 访问控制

每个类分别控制自己的成员初始化过程，每个类分别控制着其成员对于派生类来说是否可访问

`受保护的成员 protected`

1、和private类似，protected成员对于类的用户来说不可访问\
2、和public成员类似，protected成员对于派生类的成员和友元来说可以访问\
3、派生类的成员或友元只能通过派生类对象访问基类的protected成员，派生类对基类对象中的protected对象无访问权

```cpp
//example20.cpp
class Person
{
public:
    const int code = 1;
    virtual void printCode() = 0;

protected:
    string message = "protected message";
};

class Woman : public Person
{
public:
    const int code = 2;
    void printCode()
    {
        cout << this->message << endl;
    }
    friend void func(Woman &woman);
    friend void funcp(Person &person);
};

void func(Woman &woman)
{
    cout << woman.message << endl;
    //友元函数说着成员函数可以访问protected成员
}

void funcp(Person &person)
{
    // cout << person.message << endl; //错误 只能通过派生类对象访问
    //或者在Person内添加friend void funcp(Person &person);
}

int main(int argc, char **argv)
{
    Woman woman;
    woman.printCode(); // protected message
    // woman.message;//错误message是protected成员
    func(woman); // protected message
    funcp(woman);
    return 0;
}
```

### 重新控制继承内容

上面已经学习过，派生类从基类继承的public、protected成员\
但是可以在以前的继承代码中，在派生类后面的继承列表中，基类名称前还加了控制访问限定符

形如 `class Woman:public Person`，其作用是控制从Person继承而来的内容对于Woman外部是怎样的，也就是Woman派生类可以重新修饰从Person继承而来的属性与方法\
`public`表示对继承内容public的仍为public,protected变为public,private依旧不能访问\
`private`表示对继承内容，全部修改为private,进而其派生类将无法直接访问些内容\
`protected`表示将继承的内容,public的改为protected,protected保持protected,private保持不可直接访问

```cpp
//example21.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}

protected:
    void func()
    {
        cout << age << " " << name << endl;
    }
};

//从Person继承的内容修饰为protected的
class Woman : private Person
{
public:
    Woman() : Person(19, "me")
    {
        func(); // func在Woman内是private的
    };
};

class Mom : public Woman
{
public:
    void run()
    {
        // func(); //错误 func为基类的私有成员
    }
};

int main(int argc, char **argv)
{
    Woman woman; // 19 me
    // woman.func();
    //  错误 func为woman中的private成员 return 0;
}
```

### 派生类向基类转换的可访问性

* 对于用户代码 用户代码只有在public继承时才能将派生类转换到基类指针或引用
* 对于派生类成员以及其友元 无论是private public protected继承，成员友元都可使用转换

```cpp
//example22.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}

protected:
    void func()
    {
        cout << age << " " << name << endl;
    }
};

class Woman : private Person
// class Woman : public Person
{
public:
    Woman() : Person(19, "me")
    {
        func(); // func在Woman内是private的
    };
    void hello()
    {
        Person *ptr = this;
    }
    friend void func();
};

void func()
{
    Woman woman;
    Person *ptr = &woman;
}

int main(int argc, char **argv)
{
    /***对于用户代码****/
    Woman woman;
    // Person &ref = woman;
    // 错误 不允许对不可访问的基类 "Person" 进行转换,Woman:private Person

    /***对于派生类成员或友元****/
    func();
    woman.hello();
    //无论是private public protected继承，成员友元都可使用转换
    //用户代码只有在public继承时才能转换

    return 0;
}
```

### 友元与继承

总之记住一句话：友元关系不能被继承

```cpp
//example23.cpp
class Person
{
public:
    int age;
};

class Woman : public Person
{
public:
    friend void func(const Woman &woman);

private:
    string bra = "d";
};

class Mom : public Woman
{
public:
    string message = "mom";
    friend class Son;

private:
    int height = 176;
};

class Son : public Person
{
public:
    string message = "son";
    void lookMom(const Mom &mom)
    {
        cout << mom.height << endl;
    }
};

// Q没有对Mom的友元能力 友元关系不能继承
class Q : public Son
{
public:
    void lookMom(const Mom &mom)
    {
        // cout << mom.height << endl;//错误 Q不是Mom的友元
    }
};

// func是Woman的友元 不是 Mom的友元
void func(const Woman &woman)
{
    cout << woman.bra << endl;
    Mom mom;
    cout << mom.bra << endl; // bra是由Woman继承而来可以访问
}

int main(int argc, char **argv)
{
    Mom mom;
    func(mom); // d d
    return 0;
}
```

### 重新控制部分继承内容

现在已经直到有三种继承方式，private、public、protected ，但是有时并不需要使得继承的全部内容统一的用同一个方式继承，所以有了改变个别成员的可访问性

```cpp
//example24.cpp
class Person
{
public:
    int age = 19;
    void cage() const
    {
        cout << age << endl;
    }

protected:
    size_t n = 999;
};

class Mom : private Person
{
public:
    using Person::n; //以public方式继承n
protected:
    using Person::cage; //以protected方式继承cage
};                      //其余的成员则以声明的private的方式继承

int main(int argc, char **argv)
{
    Mom mom;
    // cout << mom.age << endl;//错误Mom以private继承age
    // mom.cage();//错误 Mom以protected方式继承cage
    cout << mom.n << endl; // Mom以public继承n
    return 0;
}
```

### 默认继承方式

经过前面学习，可以直到struct成员默认为public的，class的成员默认为private。在继承中仍然可以选择struct或者class，但是二则默认继承方式不同，class以private方式继承，struct以public方式继承

```cpp
//example25.cpp
class A
{
public:
    int n = 999;
};

class B : A
{
public:
    void f()
    {
        cout << n << endl;
    }
};

struct C : A
{
public:
    void f()
    {
        cout << n << endl;
    }
};

int main(int argc, char **argv)
{
    B b;
    C c;
    // cout << b.n << endl;//class以private方式继承n
    cout << c.n << endl; // 999 struct以public方式继承n
    return 0;
}
```
