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

### 直接管理内存

学过C语言的话可以知道在stdlib头文件中，有malloc函数与realloc函数

```cpp
//example6.cpp
int *int_arr = (int *)malloc(sizeof(int) * 10);
for (int i = 0; i < 10; i++)
{
    int_arr[i] = i;
}
int_arr = (int *)realloc(int_arr, sizeof(int) * 20);
for (int i = 10; i < 20; i++)
{
    int_arr[i] = i;
}
for (int i = 0; i < 20; i++)
{
    cout << int_arr[i] << " ";
}
// 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19
cout << endl;
```

在C++中定义了两个运算符来显式地配分和释放内存，运算符new用于分配内存，delete释放new分配的内存

### 使用new动态分配和初始化对象

`Type* ptr=new Type(args)` 动态分配内存

1、new基本类型与自定义数据类型，总之使用构造函数

```cpp
//example7.cpp
int *p1 = new int; //未初始化的int
*p1 = 999;
cout << *p1 << endl;       // 999
int *p2 = new int(1);      //初始化为1
cout << *p2 << endl;       // 1
string *p3 = new string;   //初始化为空的string
string *p4 = new string(); //初始化为空的string
string *p5 = new string("hello");
string *p6 = new string(10, 'p'); //初始化为10个p的字符串
```

2、new顺序容器

```cpp
//不仅仅可以new基本数据类型
vector<int> *p7 = new vector<int>{1, 2, 3, 4, 5};
for (auto &item : *p7)
{
    cout << item << " "; // 1 2 3 4 5
}
cout << endl;
```

3、auto接收指针

```cpp
//使用auto
auto p8 = new string("3232"); // p8的类型是通过"3232"类型推断出来的
auto p9 = new vector<int>{1, 2, 3, 4, 5};
```

4、auto推断要new的数据类型

```cpp
//更厉害的auto用法,尽量不要用，C++可是非弱类型语言
auto p10 = new auto(1); //根据1的类型自动推断
// auto p11 = new auto{1, 2, 3, 4};//括号只能有单个初始化器
auto p12 = new auto{string("1")}; //括号单个初始化 std::initializer_list<string>
auto str = (*p12).begin();
cout << *str << endl; // 1
delete p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p12;
```

### 动态分配的const对象

使用new分配const对象是被允许的

```cpp
//example8.cpp
const int *int_ptr = new const int(666); //必须被初始化
//*int_ptr = 999;// error: assignment of read-only location '* int_ptr'
cout << *int_ptr << endl; // 666
const string *str_ptr = new const string(10, 'p');
cout << *str_ptr << endl; // pppppppppp
```

### 内存耗尽

我们知道计算机的内存是有限的，操作系统对某个进程可能也存在内存的大小限制，在显式动态分配内存时，可能会分配失败，当分配失败，有两种选择

1、`new Type(args)`抛出std::bad\_alloc异常\
2、在使用new时`new (nothrow) Type(args)`形式进行，则分配失败时返回空指针

bad\_alloc和nothrow都定义在头文件new中

```cpp
//example9.cpp
int *p1 = new (nothrow) int; //分配失败异常 返回空指针
if (p1 == nullptr)
{
    assert("内存分配失败");
}
else
{
    cout << "内存分配成功" << endl; //内存分配成功
    delete p1;
    p1 = nullptr;
}
try
{
    p1 = new int; //分配失败时则抛出异常
}
catch (std::bad_alloc e)
{
    cout << e.what() << endl;
}
if (p1)
{
    delete p1;
    p1 = nullptr;
}
```

### 释放动态内存

delete表达式用来将动态内存归还给系统 `delete ptr;` ptr必须指向一个动态分配的对象或一个空指针

delete执行两个动作，如果对象有析构函数则会执行析构函数销毁对象，然后释放对应的内存

### 指针值和delete

重要的是，delete释放的内存必须是我们申请的动态内存，栈内存可不能手动释放

```cpp
//example10.cpp
int *num = new int(99);
cout << *num << endl; // 99
delete num;
delete num;           //未定义 因为num指向的内存已经被释放
cout << *num << endl; // 17211320
int *ptr = nullptr;
delete ptr; //释放一个空指针没有错误
int stack_num = 100;
delete &stack_num;         //未定义 因为&statck_num为栈内存
cout << stack_num << endl; // 100

const int *const_ptr = new const int(99);
delete const_ptr;
```

### 动态对象的生存周期

什么是内存泄露，简单地说就是我们申请了内存，我们都是动过其内存地址进行访问的，但如果内存没有释放，但是我们无法获取其地址了，那么内存就会白白被占着，知道程序停止运行

容易出现的错误

```cpp
//example11.cpp
int *p = new int;
p = nullptr; //内存泄露 再也找不回那块内存的地址

//被释放后又使用
p = new int;
int *p1 = p;
delete p1;
*p = 999;
//卡住因为二者指向同一块内存但是已经被释放过了
//不能在被使用
```

所以尽量在delete之后，将指针指向nullptr即空指针

```cpp
int *p=new int;
delete p;
p=nullptr;
```

### shared\_ptr和new结合使用

如果不初始化一个shared\_ptr则将会是一个空指针，除了make\_shared还以使用以下其他方法定义和改变shared\_ptr

![定义和改变shared\_ptr的其他方法](<../../../.gitbook/assets/屏幕截图 2022-06-17 090038.jpg>)

```cpp
//example12.cpp
//返回返回
shared_ptr<int> func()
{
    // return new int(1);//错误：因为shared_ptr的构造函数是explicit的
    return shared_ptr<int>(new int(1)); //正确
}

int main(int argc, char **argv)
{
    int *p = new int(999);
    shared_ptr<int> ptr1(p); //接管p所指向的对象
    shared_ptr<int> ptr2(new int(1));
    shared_ptr<int> ptr3 = func();
    cout << *ptr3 << endl; // 1
    return 0;
}
```

### 不要混合使用普通指针和智能指针

由shared\_ptr接管的new出来的内存，如果share\_ptr自动释放了它，但我们又使用普通指针使用它，则会出现错误

```cpp
//example13.cpp
void func(shared_ptr<int> ptr)
{
    // use ptr
}

int main(int argc, char **argv)
{
    shared_ptr<int> ptr1 = make_shared<int>(999);
    func(ptr1);            //地址进行值传递
    cout << *ptr1 << endl; // 999
    int *ptr2(new int(666));
    func(shared_ptr<int>(ptr2));
    cout << *ptr2 << endl; // 17080272 换码 可见new出来的对象被释放掉了
    //ptr2变成为悬空指针
    return 0;
}
```

为什么会这样呢，因为shared\_ptr是按照值传递的，在`func(shared_ptr<int>)(ptr2)`时引用数为1，当赋值给func的形参后引用数为2，然后传参临时变量销毁引用数变为1，随着func运行结束形参ptr被销毁，引用数变为0，内存也会被释放

### 不要使用get初始化另一个智能指针或智能指针赋值

确定shared\_ptr.get()出来的指针不会被delete再使用get，永远不要用get初始化另一个智能指针或另一个智能指针赋值

```cpp
//example14.cpp
int main(int argc, char **argv)
{
    shared_ptr<int> ptr1 = make_shared<int>(999);
    int *ptr2 = ptr1.get(); //获取对象内存的普通地址
    {
        shared_ptr<int>(ptr2);
        //因为在构造函数中 ptr2只是被认为是new出来的普通的内存地址
        //不知道是已经被shared_ptr接管的
    } //随着作用域消失ptr3被销毁 内存也会被释放
    *ptr2 = 888;
    cout << *ptr2 << endl;
    cout << *ptr1 << endl;
    //但有些编译器这些操作是没错误的
    return 0;
}
```

### 其他shared\_ptr操作

常用的有reset、unique方法，shared\_ptr的reset方法用于shared\_ptr去掉对其指向对象的引用，如果reset后对象内存引用数为0则对象内存会被释放，unique方法用于检测shared\_ptr指向的对象的内存引用数是否为1，为1则返回true否则反之。

```cpp
//example15.cpp
int main(int argc, char **argv)
{
    shared_ptr<int> ptr1 = make_shared<int>(888);
    shared_ptr<int> ptr2 = ptr1;
    //指向对象内存引用数是否为1
    cout << ptr1.unique() << endl; // 0
    ptr1.reset();
    cout << *ptr2 << endl;
    *ptr2 = 999;
    cout << *ptr2 << endl; // 999
    //可见reset就是将shared_ptr对指向对象内存引用数减1
    //同时如果引用数变为0也会被释放
    cout << ptr2.unique() << endl; // 1

    shared_ptr<int> ptr3(new int(999));
    int *ptr4 = ptr3.get();
    ptr3.reset();
    cout << *ptr4 << endl; //指针悬空
    return 0;
}
```
