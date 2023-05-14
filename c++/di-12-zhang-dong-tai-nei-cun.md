---
cover: >-
  https://images.unsplash.com/photo-1652599196956-248431eb0386?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTUyODQ1Mjg&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 😆 第 12 章 动态内存

## 第 12 章 动态内存

动态内存的动态体现在哪里，还要从我们前面所知道的全局变量，局部变量，以及 static 变量进行对比，全局变量的生命周期横穿整个程序运行时知道程序运行结束，局部变量随着调用栈上下文的离开进行释放，static 初始化在第一次被运行时变量被定义，知道程序运行结束才释放，而动态内存就是编码人员手动显式的申请的内存，只有显式地进行释放才会被释放，否则知道程序运行结束

C 语言也有动态内存，而其也是一件非常危险地是事情，经验不足的开发人员可能编码造成内存泄露。在 C++中，标准库定义了两个智能指针类型来管理动态分配的对象，当一个对象应该被释放时，指向它的智能指针可以确保自动地释放它

### 两种智能指针

新的标准库提供两种智能指针类型来管理动态对象，智能指针与普通指针类似，但区别在于它负责自动释放所指向的对象\
两种指针的区别之处在于管理底层指针的方式：shared_ptr 允许多个指针指向同一个对象；unique_ptr 则“独占”所指对象，不能再有其他指针指向其指的对象\
标准库还定义了 weak_ptr 的伴随类，是一种弱引用，指向 shared_ptr 所管理的对象，它们都在头文件`memory`中

### shared_ptr 和 unique_ptr 都支持的操作

![shared_ptr和unique_ptr都支持的操作](<../.gitbook/assets/屏幕截图 2022-06-15 120951.jpg>)

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

### shared_ptr 独有的操作

![shared_ptr独有的操作](<../.gitbook/assets/屏幕截图 2022-06-15 121014.jpg>)

### make_shared 函数

`make_shared<T>(args)`函数就是申请可以由 shared_ptr 管理的内存,args 为 T 的构造函数参数

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

### shared_ptr 的拷贝和赋值

shared_ptr 在拷贝或赋值时，每个 shared_ptr 都会记录有多少个其他 shared_ptr 指向相同的对象

shared_ptr 采用引用计数，当我们拷贝一个 shared_ptr，计数器就会加一，当 shared_ptr 被赋予新的值时或者 shared_ptr 离开作用域，则会将计数器减一

一旦一个 shared_ptr 的计数器变为 0，他就会释放自己所管理的对象的内存

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

### shared_ptr 自动销毁所管理的对象

因为 shared_ptr 被销毁时会先执行其析构函数，析构函数内判断所指向的对象的引用计数，如果只剩自己本身指向它，则会将对象释放掉

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

我们会发现，合理利用智能指针 C++也可以像 Java 一样拥有优秀的内存管理，而且是直接操纵内存级别

### 为什么要用动态内存

程序使用动态内存出于一下三种原因之一

- 程序不知道自己需要使用多少对象
- 程序不知道所需对象的准确类型
- 程序需要在多个对象间共享数据

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

学过 C 语言的话可以知道在 stdlib 头文件中，有 malloc 函数与 realloc 函数

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
free(int_arr);
```

在 C++中定义了两个运算符来显式地配分和释放内存，运算符 new 用于分配内存，delete 释放 new 分配的内存

### 使用 new 动态分配和初始化对象

`Type* ptr=new Type(args)` 动态分配内存

1、new 基本类型与自定义数据类型，总之使用构造函数

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

2、new 顺序容器

```cpp
//不仅仅可以new基本数据类型
vector<int> *p7 = new vector<int>{1, 2, 3, 4, 5};
for (auto &item : *p7)
{
    cout << item << " "; // 1 2 3 4 5
}
cout << endl;
```

3、auto 接收指针

```cpp
//使用auto
auto p8 = new string("3232"); // p8的类型是通过"3232"类型推断出来的
auto p9 = new vector<int>{1, 2, 3, 4, 5};
```

4、auto 推断要 new 的数据类型

```cpp
//更厉害的auto用法,尽量不要用，C++可是非弱类型语言
auto p10 = new auto(1); //根据1的类型自动推断
// auto p11 = new auto{1, 2, 3, 4};//括号只能有单个初始化器
auto p12 = new auto{string("1")}; //括号单个初始化 std::initializer_list<string>
auto str = (*p12).begin();
cout << *str << endl; // 1
// delete p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p12;//错误 写法 delete优先级比，高
delete p1, delete p2, delete p3, delete p4, delete p5, delete p6, delete p7, delete p8, delete p9, delete p10, delete p12;
```

### 动态分配的 const 对象

使用 new 分配 const 对象是被允许的

```cpp
//example8.cpp
const int *int_ptr = new const int(666); //必须被初始化
//*int_ptr = 999;// error: assignment of read-only location '* int_ptr'
cout << *int_ptr << endl; // 666
const string *str_ptr = new const string(10, 'p');
cout << *str_ptr << endl; // pppppppppp
delete int_ptr, delete str_ptr;
```

### 内存耗尽

我们知道计算机的内存是有限的，操作系统对某个进程可能也存在内存的大小限制，在显式动态分配内存时，可能会分配失败，当分配失败，有两种选择

1、`new Type(args)`抛出 std::bad_alloc 异常\
2、在使用 new 时`new (nothrow) Type(args)`形式进行，则分配失败时返回空指针

bad_alloc 和 nothrow 都定义在头文件 new 中

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

delete 表达式用来将动态内存归还给系统 `delete ptr;` ptr 必须指向一个动态分配的对象或一个空指针

delete 执行两个动作，如果对象有析构函数则会执行析构函数销毁对象，然后释放对应的内存

### 指针值和 delete

重要的是，delete 释放的内存必须是我们申请的动态内存，栈内存可不能手动释放

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

所以尽量在 delete 之后，将指针指向 nullptr 即空指针

```cpp
int *p=new int;
delete p;
p=nullptr;
```

### shared_ptr 和 new 结合使用

如果不初始化一个 shared_ptr 则将会是一个空指针，除了 make_shared 还以使用以下其他方法定义和改变 shared_ptr

![定义和改变shared_ptr的其他方法](<../.gitbook/assets/屏幕截图 2022-06-17 090038.jpg>)

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

由 shared_ptr 接管的 new 出来的内存，如果 share_ptr 自动释放了它，但我们又使用普通指针使用它，则会出现错误

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

为什么会这样呢，因为 shared_ptr 是按照值传递的，在`func(shared_ptr<int>)(ptr2)`时引用数为 1，当赋值给 func 的形参后引用数为 2，然后传参临时变量销毁引用数变为 1，随着 func 运行结束形参 ptr 被销毁，引用数变为 0，内存也会被释放

### 不要使用 get 初始化另一个智能指针或智能指针赋值

确定 shared_ptr.get()出来的指针不会被 delete 再使用 get，永远不要用 get 初始化另一个智能指针或另一个智能指针赋值

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

### 其他 shared_ptr 操作

常用的有 reset、unique 方法，shared_ptr 的 reset 方法用于 shared_ptr 去掉对其指向对象的引用，如果 reset 后对象内存引用数为 0 则对象内存会被释放，unique 方法用于检测 shared_ptr 指向的对象的内存引用数是否为 1，为 1 则返回 true 否则反之。

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

### 智能指针和异常

最常见的情况

```cpp
//example16.cpp
void func()
{
    int *p = new int(111);
    throw std::logic_error("logic_error"); //抛出异常 导致delete无法被执行
    //进而造成内存泄露
    delete p;
}

int main(int argc, char **argv)
{
    try
    {
        func();
    }
    catch (std::logic_error e)
    {
        cout << e.what() << endl; // logic_error
    }
    cout << "over" << endl; // over
    return 0;
}
```

当自定义类没有析构函数时，但是在其内部存储了 new 的内存的地址的指针，但是在析构函数时并没有对其进行释放操作，在使用 shared_ptr 管理时，当对象内存释放，内部指针指向的内存无法被释放

```cpp
//example17.cpp
class Person
{
public:
    string *ptr;
    explicit Person()
    {
        ptr = new string("");
    }
    ~Person()
    {
        cout << "release" << endl;
        // delete ptr;
    }
};

void func()
{
    shared_ptr<Person> ptr = make_shared<Person>();
} //内存泄露 new的string没有被释放

int main(int argc, char **argv)
{
    func();
    return 0;
}
```

### 自定义删除器

通过 example7.cpp 我们可以出有时会 C++也会使用 C 的一些库，在 C 语言中是没有析构函数，有时候将需要对对象内部释放的操作，写为一个函数，在 delete 时进行使用

- `shared_ptr<T>p(q,d)` q 为 T\*,d 为自定义删除器
- `shared_ptr<T>p(q,d)` q 为 shared_ptr\<T>类型，d 为自定义删除器
- `p.reset(q,d)` q 为 T\*，d 为自定义删除器

在 C 语言中常见的操作

```cpp
//example18.cpp
struct Person
{
    int *ptr;
};

Person *createPerson()
{
    Person *p = (Person *)malloc(sizeof(Person));
    p->ptr = (int *)malloc(sizeof(int));
    return p;
}

void deletePerson(Person **ptr)
{
    Person *p = *ptr;
    free(p);
    *ptr = nullptr;
}

int main(int argc, char **argv)
{
    Person *p = createPerson();
    deletePerson(&p); //传递二维指针以至于deletePerson可以修改p
    return 0;
}
```

shared_ptr 的设计者替我们想到会面临这样的问题，程序员可以在定义 shared_ptr 时传递删除器(deleter),也就是自定义函数代替 delete

```cpp
//example19.cpp
struct Person
{
    int *ptr;
    Person()
    {
        ptr = new int(888);
    }
};

void deletePerson(Person *ptr)
{
    if (ptr->ptr)
    {
        delete ptr->ptr;
        ptr->ptr = nullptr;
        cout << "delete ptr->ptr;" << endl;
    }
    delete ptr;
}

void func()
{
    shared_ptr<Person> ptr(new Person(), deletePerson); //释放时使用deletePerson
    cout << ptr.unique() << endl;                       // 1
    Person *p = new Person;
    // delete ptr->ptr;
    ptr.reset(p, deletePerson); // 释放p时使用deletePerson
    // delete ptr->ptr;
}

int main(int argc, char **argv)
{
    func();                 // delete ptr->ptr
    cout << "over" << endl; // over
    return 0;
}
```

### unique_ptr

从名字上面就能知道 unique_ptr 与 shared_ptr 的区别，unique_ptr 指向的对象只能有一个 unique_ptr 指向一个给定对象，当 unique_ptr 销毁时其所指向的对象也会被释放

![unique_ptr操作](<../.gitbook/assets/屏幕截图 2022-06-19 080936.jpg>)

与 shared_ptr 最大区别就是其有 release 方法，其定义时必须被初始化，不能进行拷贝或者赋值，没有 make_shared 类似的函数使用只能配和 new 和指针使用

```cpp
//example20.cpp
struct Person
{
    int *ptr;
    Person()
    {
        ptr = new int(888);
    }
};

void deletePerson(Person *ptr)
{
    if (ptr->ptr)
    {
        delete ptr->ptr;
        ptr->ptr = nullptr;
        cout << "delete ptr->ptr;" << endl;
    }
    delete ptr;
}

void func1(unique_ptr<Person, decltype(deletePerson) *> u2)
{
}

void func()
{
    unique_ptr<int> u(new int(999));
    // unique_ptr<Person, decltype(deletePerson) *> u1;//错误 unique_ptr必须被初始化
    unique_ptr<Person, decltype(deletePerson) *> u2(new Person(), deletePerson);
    // unique_ptr<Person, decltype(deletePerson) *> u3 = u2; //错误 不允许赋值
    // func1(u2); 错误 //不允许拷贝
    u2 = nullptr;             // u2指向对象内存被释放
    cout << "point1" << endl; // delete ptr->ptr; point1
    u2.reset(new Person());
    Person *person = u2.release();                                         //让u2放弃管理权 但不释放内存 返回作为返回值返回
    unique_ptr<Person, decltype(deletePerson) *> u3(person, deletePerson); //新的unique_ptr接管
    // reset
    cout << *(u3->ptr) << endl; // 888
    u3.reset(nullptr);          //释放并赋为nullptr
    cout << "point2" << endl;   // delete ptr->ptr; point2
    person = new Person();
    u3.reset(person); // reset释放原内存指向新内存 当u3被销毁时输出 delete ptr->ptr;
}

int main(int argc, char **argv)
{
    func();
    return 0;
}
```

### unique_ptr 作为函数返回类型

有种情况是被允许进行拷贝的，就是函数的返回值类型是 unique_ptr 类型

编译器知道要返回的对象将要被销毁，在此情况下，编译器执行一种特殊的“拷贝”

```cpp
//example21.cpp
unique_ptr<string> func()
{
    unique_ptr<string> p(new string("hello"));
    return p;
}

int main(int argc, char **argv)
{
    unique_ptr<string> p = func();
    cout << *p << endl; // hello
    return 0;
}
```

### weak_ptr

有时对于 shared_ptr 我们可能只是想让另一个指针指向其内存，但不进行内存管理，还是由原来的指向内存的 shared_ptr 进行协调管理\
将一个 weak_ptr 绑定到一个 shared_ptr 不会改变 shared_ptr 的引用计数

![weak_ptr](<../.gitbook/assets/屏幕截图 2022-06-19 084419.jpg>)

```cpp
//example22.cpp
int main(int argc, char **argv)
{
    shared_ptr<int> ptr(new int(888));
    weak_ptr<int> weak(ptr);   //构造weak_ptr
    weak_ptr<int> weak1 = ptr; //赋值构造
    // shared_ptr引用数
    cout << weak.use_count() << " " << weak1.use_count() << endl; // 1 1
    //指空
    weak1.reset();
    cout << weak.expired() << endl; // false usecount不为0
    // expired为true则返回一个shared_ptr
    cout << *weak.lock() << endl; // 888
    //但是在shared_ptr自动释放后再次使用weak_ptr则expired返回true use_count为0
    return 0;
}
```

### new 和数组

动态内存数组不能不是一个数组类型，不能使用 begin 与 end 获取迭代器，进而也不能使用范围 for 循环

```cpp
//example23.cpp
int main(int argc, char **argv)
{
    int *ptr = new (nothrow) int[10];
    delete ptr;
    //使用tyedef
    typedef int arrT[100];
    ptr = new arrT;
    delete[] ptr;
    return 0;
}
```

### 初始化动态数组

可以不显式调用构造函数会默认调用，可以使用列表进行初始化

```cpp
//example24.cpp
int main(int argc, char **argv)
{
    int *p1 = new int[10];         // 10个未初始化的int
    int *p2 = new int[10]();       // 10个初始化为0的int
    string *p3 = new string[10];   // 10个空string
    string *p4 = new string[10](); // 10个空string
    int *p5 = new int[10]{1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    //初始化前三个元素
    string *p6 = new string[10]{"aaa", "bbb", string(3, 'c')};
    int *p7 = nullptr;
    try
    {
        int *p7 = new int[3000]{1, 2, 3};
    }
    catch (std::bad_array_new_length e) //分配内存失败将会抛出异常
    {
        cout << e.what() << endl;
    }
    delete[] p1, delete[] p2, delete[]  p3, delete[]  p4, delete[]  p5, delete[]  p6, delete[]  p7;
    return 0;
}
```

### 动态分配空数组

没什么用知道有这种就行

```cpp
//example25.cpp
int main(int argc, char **argv)
{
    char arr[0];
    char *ptr = new char[0];
    //二者都不能解引用
    cout << to_string((size_t)ptr) << endl;
    delete[] ptr;
    return 0;
}
```

### 智能指针和动态数组

- 动态数组可以使用 unique_ptr 进行内存管理

![指向数组的unique_ptr](<../.gitbook/assets/屏幕截图 2022-06-20 093304.jpg>)

```cpp
//example26.cpp
int main(int argc, char **argv)
{
    unique_ptr<int[]> ptr(new int[10]);
    ptr[0] = 1;
    cout << ptr[0] << endl;
    //可以手动释放
    ptr.reset();
    return 0;
}
```

- shared_ptr 不能直接管理动态数组，如果需要则需要自定义删除器

```cpp
//example27.cpp
int main(int argc, char **argv)
{
    shared_ptr<int> ptr(new int[10], [](int *p)
                        { delete[] p; });
    // shared_ptr未定义下标运算符 可以使用get获取真实的首地址
    ptr.get()[9] = 666;
    cout << ptr.get()[9] << endl; // 666
    return 0;
}
```

合理使用 unique_ptr 与 shared_ptr 管理动态数组，可以大大降低写代码的忧虑

### allocator 类

使用动态内存数组容易出现什么问题呢，就是例如可能需要接近 50 个左右 int 的空间，我们可能会申请 60 个，但是有些内存空间我们始终没有再进行使用，造成资源浪费，new 与对象的构造联系在一起，delete\[]与对象的析构函数联系在一起，allocator 就是解决类似的问题而生的

![标准库allocator类及其算法](<../.gitbook/assets/屏幕截图 2022-06-20 094756.jpg>)

简单上手

```cpp
//example28.cpp
int main(int argc, char **argv)
{
    allocator<int> a;
    int const *p = a.allocate(10); //分配10个int空间
    for (int i = 0; i < 10; i++)
    {
        a.destroy(p + i); //销毁每个对象执行析构函数
    }
    a.deallocate((int *)p, 10);
    return 0;
}
```

### allocator 分配未构造的内存

allocator 就作用就是将内存申请与对象的构造分开，delete 与析构函数的调用也分开，有利于更好的利用内存空间

```cpp
//example29.cpp
// allocate.construct(ptr,args...)
int main(int argc, char **argv)
{
    allocator<int> allocate;
    int *ptr = allocate.allocate(10);
    allocate.construct(ptr, 888); //利用申请的第一个内存构造
    allocate.construct(ptr, 999); //再次构造
    cout << *ptr << endl;         // 999
    //调用对象的析构函数
    allocate.destroy(ptr); //调用第一个内存存放的对象的析构
    //将10个内存进行释放
    allocate.deallocate(ptr, 10); //释放申请的10个内存
    return 0;
}
```

### 拷贝和填充未初始化内存

![allocator算法](<../.gitbook/assets/屏幕截图 2022-06-20 103037.jpg>)

```cpp
//example30.cpp
void print(int arr[], int n);

int main(int argc, char **argv)
{
    allocator<int> allocate;
    constexpr int n = 10;
    int *p1 = allocate.allocate(n);
    int *p2 = allocate.allocate(n);
    for (int i = 0; i < 10; i++)
    {
        p1[i] = i;
    }

    //此拷贝是内存级的拷贝
    uninitialized_copy(p1, p1 + n, p2); //拷贝到p2
    print(p2, 10);                      // 0 1 2 3 4 5 6 7 8 9
    uninitialized_copy_n(p1, 10, p2);   //从p1拷贝10个内存单位到p2

    // fill填充
    uninitialized_fill(p1, p1 + 10, 666);
    print(p1, 10); // 666 666 666 666 666 666 666 666 666 666
    uninitialized_fill_n(p2, 5, 666);
    print(p2, 10); // 666 666 666 666 666 5 6 7 8 9

    //对象析构
    for (int i = 0; i < 10; i++)
    {
        allocate.destroy(p1 + i);
        allocate.destroy(p2 + i);
    }

    //内存释放
    allocate.deallocate(p1, n);
    allocate.deallocate(p2, n);
    cout << "end" << endl; // end

    // copy函数的返回值 返回最后一个构造的对象的后一个位置的地址
    p1 = allocate.allocate(10);
    p2 = allocate.allocate(10);
    p1[0] = 0, p1[1] = 2, p1[2] = 3, p1[3] = 4;
    int *temp = uninitialized_copy_n(p1, 3, p2);
    *temp = 999;
    cout << p2[3] << endl; // 999 可见是拷贝过去的后面一个位置地址

    return 0;
}

void print(int arr[], int n)
{
    for (int i = 0; i < n; i++)
    {
        cout << arr[i] << " ";
    }
    cout << endl;
}
```
