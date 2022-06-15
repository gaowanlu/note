---
cover: >-
  https://images.unsplash.com/photo-1652599196956-248431eb0386?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTUyODQ1Mjg&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 😆 第12章 动态内存

## 第12章 动态内存

动态内存的动态体现在哪里，还要从我们前面所知道的全局变量，局部变量，以及static变量进行对比，全局变量的生命周期横穿整个程序运行时知道程序运行结束，局部变量随着调用栈上下文的离开进行释放，static初始化在第一次被运行时变量被定义，知道程序运行结束才释放，而动态内存就是编码人员手动显式的申请的内存，只有显式地进行释放才会被释放，否则知道程序运行结束

C语言也有动态内存，而其也是一件非常危险地是事情，经验不足的开发人员可能编码造成内存泄露。在C++中，标准库定义了两个智能指针类型来管理动态分配的对象，当一个对象应该被释放时，指向它的智能指针可以确保自动地释放它

### 两种智能指针

新的标准库提供两种智能指针类型来管理动态对象，智能指针与普通指针类似，但区别在于它负责自动释放所指向的对象\
两种指针的区别之处在于管理底层指针的方式：shared\_ptr允许多个指针指向同一个对象；unique\_ptr则“独占”所指对象，不能再有其他指针指向其指的对象\
标准库还定义了weak\_ptr的伴随类，是一种弱引用，指向shared\_ptr所管理的对象，它们都在头文件`memory`中

### shared\_ptr和unique\_ptr都支持的操作

![shared\_ptr和unique\_ptr都支持的操作](<../../../.gitbook/assets/屏幕截图 2022-06-15 120951.jpg>)

```cpp
//example1.cpp
shared_ptr<string> str_ptr;      //可以指向string
shared_ptr<vector<int>> vec_ptr; //可以指向vector<int>
//判断指针是否为空
if (str_ptr != nullptr)
{
    *str_ptr = "hello"; //解引用
}
```

### shared\_ptr独有的操作

![shared\_ptr独有的操作](<../../../.gitbook/assets/屏幕截图 2022-06-15 121014.jpg>)

### make\_shared函数

`make_shared<T>(args)`函数就是申请可以由shared\_ptr管理的内存,args为T的构造函数参数

```cpp
//example2.cpp
shared_ptr<string> str_ptr = make_shared<string>("hello");
shared_ptr<string> str_ptr1 = make_shared<string>("world");
if (str_ptr)
{
    cout << *str_ptr << endl; // hello
    // get()方法获得普通指针
    string *ptr = str_ptr.get();
    cout << *ptr << endl; // hello
}
//交换指针
str_ptr1.swap(str_ptr);
cout << *str_ptr << " " << *str_ptr1 << endl; // world hello
//使用swap函数
swap(str_ptr, str_ptr1);
cout << *str_ptr << " " << *str_ptr1 << endl; // hello world
```

### shared\_ptr的拷贝和赋值

shared\_ptr在拷贝或赋值时，每个shared\_ptr都会记录有多少个其他shared\_ptr指向相同的对象

shared\_ptr采用引用计数，当我们拷贝一个shared\_ptr，计数器就会加一，当shared\_ptr被赋予新的值时或者shared\_ptr离开作用域，则会将计数器减一

一旦一个shared\_ptr的计数器变为0，他就会释放自己所管理的对象的内存

```cpp
//example3.cpp
void m_function()
{
    shared_ptr<string> str_ptr = make_shared<string>("dynamic memory");
    //当上下文离开function时 栈内存变量 str_ptr则会被释放销毁 则那块内存的引用计数变为0
    //也会被释放掉
}

int main(int argc, char **argv)
{
    //make_shared申请的内存，内存的引用数量为0
    //str_ptr指向申请的内存，内存的引用数量加1
    shared_ptr<string> str_ptr = make_shared<string>("hello");
    //又有一个新的shared_ptr指向那块内存，则引用计数+1
    shared_ptr<string> str_ptr1 = str_ptr;
    str_ptr1 = nullptr; //引用计数减一
    str_ptr = nullptr;  //引用计数变为0 那块内存的引用计数变为0 则进行释放
    m_function();
    cout << "over" << endl; // over
    return 0;
}
```

### shared\_ptr 自动销毁所管理的对象

因为shared\_ptr被销毁时会先执行其析构函数，析构函数内判断所指向的对象的引用计数，如果只剩自己本身指向它，则会将对象释放掉

更加细节的事情

```cpp
//example4.cpp
shared_ptr<string> m_function()
{
    shared_ptr<string> str_ptr = make_shared<string>("dynamic memory");
    return str_ptr;
    //首先make_shared申请的内存引用数量为0
    // str_ptr指向其对象 则引用数量变为1
    //后面return 即进行了拷贝str_ptr存储到临时变量 引用数量边为2
    //上下文离开str_ptr销毁 引用数量变为1
    //如果调用者接收了返回的参数 则引用数量变为2
    //临时变量被销毁 引用数量变为1
    //如果调用者没有接收返回的参数，则临时变量被销毁，引用数量变为0，对象内存内释放
}

int main(int argc, char **argv)
{
    m_function();                              //内部申请的内存被释放
    shared_ptr<string> str_ptr = m_function(); //内部申请的内存不会被释放，因为有str_ptr指向
    cout << *str_ptr << endl;                  // dynamic memory
    return 0;
}
```

我们会发现，合理利用智能指针C++也可以像Java一样拥有优秀的内存管理，而且是直接操纵内存级别

### 为什么要用动态内存

程序使用动态内存出于一下三种原因之一

* 程序不知道自己需要使用多少对象
* 程序不知道所需对象的准确类型
* 程序需要在多个对象间共享数据

有趣典型的多个对象共享一个对象的例子

```cpp
//example5.cpp
class Person
{
public:
    shared_ptr<string> name;
    Person() = default;
    Person(const Person &person)
    {
        name = person.name;
    }
};

int main(int argc, char **argv)
{
    Person person;
    { //内部作用域
        Person person1;
        person1.name = make_shared<string>("gaowanlu");
        person = person1;
        cout << *person.name << endl; // gaowanlu
        *person.name = "hi";
        cout << *person1.name << endl; // hi
        cout << *person.name << endl;  // hi
    }
    //作用域离开person1被销毁，但申请的内存仍存在引用计数
    cout << *person.name << endl; // hi
    return 0;
}
```
