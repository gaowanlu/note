---
cover: >-
  https://images.unsplash.com/photo-1486247496048-cc4ed929f7cc?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHw5fHx0b3VyJTIwZGUlMjBmcmFuY2UlMjAyMDIyfGVufDB8fHx8MTY1OTE5NTAxMQ&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🇨🇳 第18章 用于大型程序的工具

## 第18章 用于大型程序的工具

此章节的主要内容分为三个部分，分别为进一步深入异常处理、命名空间、多重继承与虚继承

### 抛出异常

C++通过抛出(throwing)一条表达式来引发异常，当执行一个throw时，跟在throw后面的语句不再被执行，程序控制权将转移到与之匹配的catch模块。沿着调用链的函数可能会提早退出，一旦程序开始执行异常代码，则沿着调用链创建的对象将被销毁

### 异常捕获栈展开

如果在try内进行throw异常，则会寻找此try语句的catch是否有此异常与之匹配的捕获，如果没有将会转到调用栈的上一级，即函数调用链的上一级，try的作用域内可以有try，会向上级一层一层的找，如果到main还是不能捕获则将会除法标准库函数terminate,即程序终止

```cpp
//example1.cpp
void func2()
{
    try
    {
        throw overflow_error(" throwing a error");
        cout << "3 hello world" << endl;
    }
    catch (range_error &e)
    {
        cout << "1 " << e.what() << endl;
    }
}

void func1()
{
    try
    {
        func2();
    }
    catch (overflow_error &e)
    {
        cout << "2 " << e.what() << endl;
    }
}

int main(int argc, char **argv)
{
    func1(); // 2 throwing a error
    return 0;
}
```

如果异常没有被捕获，则它将终止当前的程序

### 栈展开与内存销毁

在栈展开时，即当throw后离开某些块作用域时，能够自动释放的栈内存将会被释放，但是要保证申请的堆内存释放，推荐使用shared\_ptr与unique\_ptr管理内存

```cpp
//example2.cpp
class Person
{
public:
    int age;
    Person(const int &age) : age(age)
    {
    }
    ~Person()
    {
        cout << "dis Person" << endl;
    }
};

int main(int argc, char **argv)
{
    try
    {
        shared_ptr<Person> p(new Person(1));
        throw runtime_error("m_error");
    }
    catch (runtime_error &e)
    {
        cout << e.what() << endl;
    }
    cout << "end" << endl;
    //程序输出 dis Person m_error end
    return 0;
}
```

### 析构函数与异常

可见在try作用域离开时，其内部的对象的析构函数将会被调用，但是在析构函数中也是可能存在抛出异常的情况。约定俗成，构造函数内应该仅仅throw其自己能够捕获的异常，如果在栈展开的过程中析构函数抛出了异常，并且析构函数本身没有将其捕获，则程序将会被终止

```cpp
//example3.cpp
class Person
{
public:
    ~Person()
    {
        throw runtime_error("");
    }
};

int main(int argc, char **argv)
{
    try
    {
        Person person;
    }
    catch (runtime_error e)
    {
        cout << e.what() << endl;
    }
    //程序出发了terminate标准函数程序终止运行
    return 0;
}
```

### 异常对象

编译器使用异常抛出表达式来对异常对象进行拷贝初始化，其确保无论最终调用的哪一个catch子句都能访问该空间，当异常处理完毕后，异常对象被销毁\
如果一个throw表达式解引用基类指针，而指针实际指向派生类对象，则抛出的对象系那个会被切掉，只有基类部分被抛出

```cpp
//example4.cpp
void func1()
{
    try
    {
        runtime_error e("1");
        throw e; //发生构造拷贝
    }
    catch (runtime_error &e)
    {
        cout << e.what() << endl; // 1
    }
}

void func2()
{
    try
    {
        runtime_error e("2");
        throw &e; ////没有被处理之前其内存不会被释放
    }
    catch (runtime_error *e)
    {
        cout << e->what() << endl; // 2
    }
}

void func3()
{
    try
    {
        runtime_error e("3");
        exception *p = &e;
        throw p; //只抛出基类部分
    }
    catch (exception *e)
    {
        cout << e->what() << endl;
    }
}

int main(int argc, char **argv)
{
    func1();               // 1
    func2();               // 2
    func3();               // 3
    cout << "end" << endl; // end
    return 0;
}
```

### 异常捕获

使用catch子句对异常对象进行捕获，如果catch无须访问抛出的表达式，则可以忽略形参的名字，捕获形参列表可以为值类型、左值引用、指针，但不可为右值引用\
抛出的派生类可以对catch的基类进行初始化、如果抛出的是非引用类型、则异常对象将会切到派生类部分，最好将catch的参数定义为引用类型

### catch子句的顺序

如果在多个catch语句的类型之间存在继承关系，则应该把继承链最底端的类放在前面，而将继承链最顶端的类放在后面

```cpp
//example5.cpp
void func1()
{
    try
    {
        throw runtime_error("1");
    }
    catch (exception &e)
    {
        cout << "1 exception" << endl;
    }
    catch (runtime_error &e)
    {
        cout << "1 runtime_error" << endl;
    }
} //输出 1 exception

void func2()
{
    try
    {
        throw runtime_error("2");
    }
    catch (runtime_error &e)
    {
        cout << "2 runtime_error" << endl;
    }
    catch (exception &e)
    {
        cout << "2 exception" << endl;
    }
} // 2 runtime_error

int main(int argc, char **argv)
{
    func1(); // 1 exception
    func2(); // 2 runtime_error
    return 0;
}
```

### 重新抛出异常

重新抛出就是在catch内对捕获的异常对象又一次抛出，有上一层进行捕获处理,重新抛出的方法就是使用throw语句，但是不包含任何表达式，空的throw只能出现在catch作用域内

```cpp
//example6.cpp
void func1()
{
    try
    {
        throw runtime_error("error");
    }
    catch (runtime_error &e)
    {
        throw; //重新抛出
    }
}

void func2()
{
    try
    {
        func1();
    }
    catch (runtime_error &e)
    {
        cout << "2 " << e.what() << endl;
    }
}

int main(int argc, char **argv)
{
    func2(); // 2 error
    return 0;
}
```

### 捕获所有异常

有时在try代码块内有不同类型的异常对象可能被抛出，但是当这些异常发生时所需要做出的处理行为是相同的，则可以使用catch对所有类型的异常进行捕获

```cpp
//example7.cpp
void func()
{
    static default_random_engine e;
    static bernoulli_distribution b;
    try
    {
        bool res = b(e);
        if (res)
        {
            throw runtime_error("error 1");
        }
        else
        {
            throw range_error("error 2");
        }
    }
    catch (...)
    {
        throw;
    }
}

int main(int argc, char **argv)
{
    for (size_t i = 0; i < 10; i++)
        try
        {
            func();
        }
        catch (range_error &e)
        {
            cout << e.what() << endl;
        }
        catch (...)
        {
            cout << "the error is not range_error" << endl;
        }
    //  the error is not range_error
    //  the error is not range_error
    //  the error is not range_error
    //  error 2
    //  error 2
    //  error 2
    //  the error is not range_error
    //  error 2
    //  the error is not range_error
    //  the error is not range_error
    return 0;
}
```

### try与构造函数

构造函数中可能抛出异常，构造函数分为两个阶段，一个为列表初始化过程，和函数体执行的过程，但是列表初始化时产生的异常怎样进行捕获呢？\
需要写成函数try语句块（也成为函数测试块，function try block）的形式\
要注意的是，函数try语句块catch捕获的是列表中的错误，而不是成员初始化过程中的错误

```cpp
//example8.cpp
class A
{
public:
    shared_ptr<int> p;
    A(int num)
    try : p(make_shared<int>(num)) //当初始化列表中的语句执行抛出异常时
    {
        //或者函数体抛出异常时 下方catch都可以将其捕获
    }
    catch (bad_alloc &e)
    {
        cout << e.what() << endl;
    }
};

int main(int argc, char **argv)
{
    A a(12);
    return 0;
}
```

构造函数try语句会将异常重新抛出

```cpp
//example9.cpp
class A
{
public:
    A()
    try
    {
        throw runtime_error("error1");
    }
    catch (runtime_error &e)
    {
        cout << e.what() << endl;
    }
};

int main(int argc, char **argv)
{
    try
    {
        A a; // error1
    }
    catch (runtime_error &e)
    {
        cout << "main " << e.what() << endl; // main error1
    }
    return 0;
}
```

同样可以用于析构函数

```cpp
//example10.cpp
int func()
{
    throw runtime_error("func");
    return 1;
}

class A
{
public:
    int num;
    A()
    try : num(func())
    {
    }
    catch (runtime_error &e)
    {
        cout << e.what() << endl; // func
    }
    ~A() //可用于析构函数，捕获函数体内的异常
    try
    {
    }
    catch (...)
    {
        cout << "~A error" << endl;
    }
};

int main(int argc, char **argv)
{
    try
    {
        A a;
    }
    catch (runtime_error &e)
    {
        cout << "main " << e.what() << endl; // main func
    }
    return 0;
}
```

### noexcept异常说明

noexcept可以提前说明某个函数不会抛出异常，可以在函数指针的声明、定义中指定noexcept。不能在typedef或类型别名中出现noexcept。在成员函数中，noexcept跟在const及引用限定符之后、在final、overrride或虚函数的=0之前

虽然指定noexcept，但是仍可以违反说明，如果违反则会触发terminate

```cpp
//example11.cpp
void func() noexcept
{
    throw runtime_error(""); // warning: throw will always call terminate()
}

int main(int argc, char **argv)
{
    func();//会触发terminate
    return 0;
}
```

### 为noexcept提供参数

noexcept(true)表示不会抛出异常、noexcept(false)表示可能抛出异常

```cpp
//example12.cpp
void func() noexcept(true)
{
}

void func1() noexcept(false)
{
}

int main(int argc, char **argv)
{
    func();
    func1();
    return 0;
}
```

### noexcept运算符

noexcept是一个一元运算符，返回值为bool类型右值常量表达式

```cpp
//example13.cpp
void func1() noexcept
{
}

void func2() noexcept(true)
{
}

void func3() noexcept(false)
{
    throw runtime_error("");
}

void func4() noexcept
{
    func1();
    func2();
};

void func5(int i)
{
    func1();
    func3();
}

//混合使用
void func6() noexcept(noexcept(func5(9)))
{
}

int main(int argc, char **argv)
{
    cout << noexcept(func1()) << endl; // 1
    cout << noexcept(func2()) << endl; // 1
    cout << noexcept(func3()) << endl; // 0

    cout << noexcept(func4()) << endl; // 1
    //当func4所调用的所有函数都是noexcept,且本身不含有throw时返回true 否则返回false
    cout << noexcept(func5(1)) << endl; // 0
    return 0;
}
```

### noexcept与函数指针、虚函数

函数指针

```cpp
//example14.cpp
void func() noexcept
{
}

void func1() noexcept(false)
{
    throw runtime_error("");
}

void (*ptr1)() noexcept = func; // func与ptr都承诺noexcept
void (*ptr2)() = func;          // func为noexcept ptr不保证noexcept

int main(int argc, char **argv)
{

    ptr1 = func1; //不能像except的赋给nnoexcept函数指针
    ptr2 = func1;
    return 0;
}
```

虚函数,如果基类虚方法为noexcept则派生类派生出的也为noexcept,如果基类为except的则派生类可以指定非noexcept或者noexcept

```cpp
//example15.cpp
class A
{
public:
    virtual void f1() noexcept;
    virtual void f2() noexcept(false);
    virtual void f3(); //默认为noexcept(false)
};

class B : public A
{
public:
    void f1() noexcept override
    {
    }
    void f2() noexcept override
    {
    }
    void f3() noexcept override
    {
    }
};

int main(int argc, char **argv)
{
    B b;
    b.f1(), b.f2(), b.f3();
    return 0;
}
```

### 合成noexcept

当编译器合成拷贝控制成员时，同时会生成一个异常说明，如果该类成员和其基类所有操作都为noexcept,则合成的成员为noexcept的。不满足条件则合成noexcept(false)的。\
在析构函数没有提供noexcept声明，编译器将会为其合成。合成的为与编译器直接合成析构函数提供的noexcept说明相同

### 常见异常类继承关系

![标准exception类层次](<../../../.gitbook/assets/屏幕截图 2022-07-30 230439.jpg>)

exception只定义了拷贝构造函数、拷贝赋值运算符、虚析构函数、what的虚成员，what返回const char\* 字符数组，其为noexcept(true)的\
exception、bad\_cast、bad\_alloc有默认构造函数、runtime\_error、logic\_error无默认构造函数，可以接收C字符数组

### 编写自己的异常类

编写的异常类其的根基类为exception

```cpp
//example16.cpp
class MException : public std::runtime_error
{
public:
    int number;
    MException(const string &s) : runtime_error(s), number(0)
    {
    }
};

int main(int argc, char **argv)
{
    try
    {
        MException e("oop");
        e.number = 999;
        throw e;
    }
    catch (MException &e)
    {
        cout << e.number << endl; // 999
        cout << e.what() << endl; // oop
    }
    return 0;
}
```
