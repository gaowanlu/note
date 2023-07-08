---
cover: >-
  https://images.unsplash.com/photo-1533561052604-c3beb6d55b8d?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHw5fHx0b3VyJTIwZGUlMjBmcmFuY2V8ZW58MHx8fHwxNjU3MzM2MDg4&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🧸 第 16 章 模板与泛型编程

## 第 16 章 模板和泛型编程

已经学习了标准容器，我们就会产生好奇，为什么它可以存储任意类型呢?向自定义的函数的形参与实参都是有着严格的类型匹配，面向对象编程和泛型编程都能处理在编写程序时不知道类型的情况，不同之处在于，OOP 能处理类型在程序运行之前都未知的情况，而泛型编程中，在编译时就能获知类型了，在 OOP 总我们知道利用虚函数与动态绑定机制可以做到

### 为什么使用泛型编程

有时某种算法的代码实现是相同的，只有变量类型不同，如下面的情况

```cpp
int compare(const string& s1,const string& s2){
    if(s1<s2)return -1;
    if(s2<s1)return 1;
    return 0;
}
int compare(const double& d1,const double& d2){
    if(s1<s2)return -1;
    if(s2<s1)return 1;
    return 0;
}
```

泛型编程就是为解决这种问题而生的

### 函数模板

函数模板就是一个公式，可以来生成针对特定类型的函数版本\
编译器生成的版本通常被称为模板的实例

```cpp
//example1.cpp
//模板定义以template关键词开始，后面跟模板参数列表，是一个逗号隔开一个或多个模板参数的列表
template <typename T>
int compare(const T &v1, const T &v2)
{
    if (v1 < v2)
        return -1;
    if (v2 < v1)
        return 1;
    return 0;
}

int main(int argc, char **argv)
{
    //编译器背后生成 int compare(const int& v1,const int& v2)
    cout << compare(10, 13) << endl; //-1
    //生成 int compare(const string& v1,const string& v2)
    cout << compare(string{"hello"}, string{"asd"}) << endl; // 1
    return 0;
}
```

### typename 与 class

泛型参数的类型确定是编译器时检测被调用时的实参的类型确定的\
`template<class ...>`与`template<typename ...>`两种方式都是可以的，但是现代 C++更推荐 typename 即后者

```cpp
template<class T,typename U>
T func(T*ptr,U*p){
    T& tmp=*p;
    //...
    return tmp;
}
```

但 func 被调用时，编译器根据 T 的类型，将模板中的 T 类型替换为实参类型

### 非类型模板参数

在形参中有些值类型是我们已经确定的，但是不能确定是多少或具体内容，这是可以使用非类型模板参数\
编译器会使用字面常量的大小代替 N 和 M,实例化模板

```cpp
//example2.cpp
template <unsigned N, unsigned M>
int compare(const char (&p1)[N], const char (&p2)[M])
{
    cout << N << " " << M << endl; // 6 4
    return strcmp(p1, p2);
}

int main(int argc, char **argv)
{
    cout << compare("hello", "abc") << endl; // 1
    //在此实际传的实参为 char[6] char[4]
    return 0;
}
```

上面编译器会实例出`int compare(const char (&p1)[6], const char (&p2)[4])`

重点：非类型模板参数的模板实参必须是常量表达式,只能使用编译时常量（包括整数常量、枚举常量等），而不能使用运行时的变量。

### inline 和 constexpr 的函数模板

inline 与 constexpr 普通函数关键词的位置没什么区别

- inline 函数模板

```cpp
template <typename T>
inline int compare(const T&a,const T&b){
    return 1;
}
```

- constexpr 函数模板

```cpp
template <typename T>
constexpr int compare(const T&a,const T&b){
    return 1;
}
constexpr int num=compare(19,19);
cout<<num<<endl;//1
```

### 编写类型无关的代码

标准函数对象的内容在第 14 章 操作重载与类型转换\
在模板编程中，我们力求编写类型无关的代码，尽可能减少对实参的依赖,`总之模板程序应该尽量减少对实参类型的要求`

在上面的代码是有两个特殊的处理

- 模板中的函数参数是 const 的引用(保证可处理不能拷贝的类型)
- 函数体中的判断条件仅使用`<`比较(使得类型仅支持<比较即可)

还有更优雅的写法，使用标准函数对象

```cpp
//example3.cpp
template <typename T>
int compare(const T &v1, const T &v2)
{
    if (less<T>()(v1, v2))
        return -1;
    if (less<T>()(v1, v2))
        return 1;
    return 0;
}

int main(int argc, char **argv)
{
    cout << compare(string{"121"}, string{"dsc"}) << endl; //-1
    return 0;
}
```

### 函数模板通常放在头文件

我们通常将类的定义与函数声明放在都文件，因为使用他们时，编译器只需掌握其形式即可即返回类型，函数形参类型等，但是函数模板不同，为了生成一个实例化版本，编译器需要掌握函数模板或类模板成员函数的定义，模板的头文件通常包括声明与定义

### 编译错误过程

对于函数模板的错误，通常编译器会在三个阶段报告错误

1、编译模板本身，例如定义模板本身的语法等\
2、遇到模板被使用时，通常检查实参数目、检查参数类型是否匹配\
3、编译用函数模板产生的函数代码，与编译实际的函数一样，依赖于编译器如何管理实例化，这类错误可能在链接时才报告

如下面的情况

```cpp
Person a,b;
compare(a,b);
```

compare 中使用了`<`,但是 Person 类并没有`<`操作，那么这样的错误在第三阶段才会报告

### 类模板

经过上面的学习，函数模板是用来生成函数的蓝图的。那么类模板有是怎样的呢，类模板(class template)是用来生成类的蓝图的，不像函数模板一样可以推算类型，类模板使用时在名字后使用尖括号提供额外的类型信息，正如我们使用过的 list、vector 等一样，它们都是类模板

### 定义类模板

下面是一个定义类模板的简单例子，无须解释即可学会

```cpp
//example4.cpp
template <typename T>
class Data
{
public:
    T info;
    Data(const T &t) : info(t)
    {
    }
};

int main(int argc, char **argv)
{
    Data<int> data1(19);
    cout << data1.info << endl; // 19
    Data<string> data2("hello");
    cout << data2.info << endl; // hello
    return 0;
}
```

### 实例化类模板

在使用一个类模板是，必须提供额外的信息，在 example4.cpp 中提供的 int 就是显式模板实参，它们被绑定到模板参数\
每一个类模板的每个实例都形成一个独立的类，`Data<int>`与其他的 Data 类型直接没有关联，也不会对其他 Data 类型的成员有特殊访问权限

### 模板类型做实参

类模板的类型实参可以为普通类型或者自定义类型，同时也可以为模板类型\
例如用 vector<>来做实参类型

```cpp
//example5.cpp
template <typename T>
class Data
{
public:
    T info;
    Data(const T &t) : info(t)
    {
    }
};

int main(int argc, char **argv)
{
    Data<vector<int>> data({1, 2, 3, 4});
    for (const int &item : data.info)
    {
        cout << item << endl; // 1 2 3 4
    }
    return 0;
}
```

### 类模板的成员函数

在类外定义的类模板的成员函数必须添加 template 在函数定义前，在类内定义在与普通类一样其被定义为隐式的内联函数

```cpp
//example6.cpp
template <typename T>
class Data
{
public:
    T info;
    Data(const T &t) : info(t)
    {
    }
    void print()
    {
        cout << "print" << endl;
    }
    T sayHello(const T &t); //类内声明
};

//类外定义
template <typename T>
T Data<T>::sayHello(const T &t)
{
    info = t;
    cout << "hello" << endl;
    return this->info;
}

int main(int argc, char **argv)
{
    Data<int> data(19);
    data.print();                // print
    int res = data.sayHello(18); // hello
    cout << res << endl;         // 18
    return 0;
}
```

### 模板参数视为已知类型

在类模板中像在函数模板中一样，将模板参数视为已知就好，以至于可以进行复杂的情况使用\
在类模板中使用其他类模板时，可以使用自己的模板类型参数作为参数传给其他类模板，例如下面的`vector<T>、initializer_list<T>`等。

```cpp
//example7.cpp
template <typename T>
class Data
{
public:
    shared_ptr<vector<T>> vec;
    Data(const initializer_list<T> &list) : vec(make_shared<vector<T>>(list))
    {
    }
    vector<T> &get()
    {
        return *vec;
    }
};

int main(int argc, char **argv)
{
    Data<int> data({1, 2, 3, 4, 5});
    vector<int> &vec = data.get();
    for (auto item : vec)
    {
        cout << item << endl; // 1 2 3 4 5
    }
    return 0;
}
```

默认情况下，对于一个实例化了的类模板，其成员只有在使用时才被实例化

### 类模板内使用自身

类模板类在类外定义的函数成员中，使用自己时的类型时可以不提供模板参数，但是如果作为方法参数或者反回值类型，则需要写尖括号，在函数体内不用写尖括号\
在类内定义的成员中，则可以省略写尖括号

最佳实践：都写上尖括号就好了，也会使得看代码的人更容易理解

```cpp
//example8.cpp
template <typename T>
class Data
{
public:
    T info;
    Data(const T &t) : info(t)
    {
    }
    Data print(const T &t) //类内定义成员方法
    {
        Data data(t);
        return data;
    }
    Data<T> sayHello(const T &t); //类内声明
};

//类外定义
template <typename T>
Data<T> Data<T>::sayHello(const T &t)
{
    Data d(t); //与Data<T> t(t)等价
    info = t;
    return d;
}

int main(int argc, char **argv)
{
    Data<int> data(19);
    Data<int> data1 = data.print(20);
    Data<int> data2 = data.print(18);
    cout << data1.info << endl;              // 20
    cout << data2.sayHello(18).info << endl; // 18
    return 0;
}
```

### 类模板和友元

当类模板有一个非模板友元，则这个类模板的所有实例类对此友元友好

```cpp
//example9.cpp
template <typename T>
class Data
{
private:
    T t;

public:
    Data(const T &t) : t(t) {}
    friend void print();
};

void print()
{
    Data<int> data(19);
    Data<string> data1("oop");
    cout << data.t << " " << data1.t << endl; // 19 oop
}

int main(int argc, char **argv)
{
    print();
    return 0;
}
```

### 一对一友好关系

类模板与另一个（类或函数）模板间友好关系的常见形式为建立对应实例及其友元间的友好关系

```cpp
//example10.cpp
#include <iostream>
using namespace std;

//模板类与函数模板声明
template <typename>
class A;
template <typename>
class B;
template <typename T>
void print(T t);

template <typename T>
class A
{
public:
    void test()
    {
        B<T> b;
        b.b = 888;
        cout << b.b << endl;
        // B<string> b1;//错误与B<string>不是友元关系
        // b1.b = "oop";
    }
};

template <typename T>
class B
{
public:
    T b;
    friend class A<T>; //将A<T>称为B<T>的友元
    friend void print<T>(T t);
};

template <typename T>
void print(T t)
{
    B<T> b;
    cout << b.b << endl;
    B<string> b1; //为什么是B<stirng>的友元
    //因为在此使用B<string>时，B内生成了friend void print(string t);
    b1.b = "oop";
    cout << b1.b << endl;
}

int main(int argc, char **argv)
{
    A<int> a;
    a.test();  // 888
    print(19); // 888 oop
    return 0;
}
```

### 通过和特定的模板友好关系

让另一个类模板的所有实例都都称为友元\
下面的代码比较长，总之最重要的就是形如一下两种友元声明

```cpp
friend class B<A>;
template<typename T> friend class B;
```

的区别

```cpp
//example11.cpp
template <typename T>
class B;
template <typename X>
class C;

class A
{
    friend class B<A>; //声明 B<A>为A的友元
    template <typename T>
    friend class B; // B模板的所有实例都是A的友元
    A(int a) : n(a) {}

private:
    int n;
};

template <typename T>
class B
{
    friend class A; //声明A为B的友元
    template <typename X>
    friend class C;
    // 所有实例之间都是友元关系 B<int> 与 C<string>之间也是友元
    // friend class B<T>;
    //与上一句截然不同 此作用只是如B<int>与C<int>之间为友元
private:
    T t;

public:
    B(T t) : t(t) {}
    void test()
    {
        A a(19);
        cout << a.n << endl; // B<T>为A的友元
    }
};

template <typename X>
class C
{
public:
    void test()
    {
        B<int> b1(19); //所有B<T>实例的友元都包括C<X>
        B<string> b2("oop");
        cout << b1.t << " " << b2.t << endl;
    }
};

int main(int argc, char **argv)
{
    C<int> c;
    c.test(); // 19 oop

    B<int> b1(0);
    B<string> b2("oop");
    b1.test(); // 19
    b2.test(); // 19
    return 0;
}
```

### 令模板自己的类型参数成为友元

在新标准中，可以将模板类型参数声明为友元，当然只有其模板实参为复合自定义类型时才显得有意义

```cpp
//example12.cpp
template <typename Type>
class A;
class Data;

template <typename Type>
class A
{
    friend Type; //重点
public:
    A(int n) : n(n) {}

private:
    int n;
};

//A必须放在Data前面否则会出现不玩增类型因为在遇见A<Data>时编译器需要知道A<T>的定义
class Data
{
public:
    void test(A<Data> *p);
};

void Data::test(A<Data> *p)
{
    cout << p->n << endl;
}

int main(int argc, char **argv)
{
    Data data;
    A<Data> a(19);
    data.test(&a); // 19
    return 0;
}
```

### 模板类型别名

1、为类模板实例起别名

```cpp
typedef A<string> AString;
AString a;//等价于A<string> a;
```

2、不能为类模板本身起别名，因为模板不是一个类型\
3、为类模板定义类型别名

```cpp
template<typename T> using twin=pair<T,T>;
twin<string> data;//等价于 pair<string,string> data;

template<typename T> using m_pair=pair<T,usigned>;
m_pair<int> a;//等价于 pair<int,unsigned>a;
```

### 类模板的 static 成员

对于类模板的 static 成员，每种模板实例有自己的 static 实例

```cpp
//example13.cpp
template <typename T>
class Data
{
public:
    T t;
    Data(T t) : t(t)
    {
        i++;
    }
    static size_t i;
    static std::size_t get_i()
    {
        return i;
    }
};

template <typename T>
size_t Data<T>::i = 0;

int main(int argc, char **argv)
{
    cout << Data<int>::i << endl; // 0
    Data<int> d1(10);
    cout << d1.i << endl;            // 1
    cout << Data<string>::i << endl; // 0
    Data<string> d2("ui");
    cout << Data<string>::i << endl; // 1

    cout << d1.get_i() << endl;         // 1
    cout << d2.get_i() << endl;         // 1
    cout << Data<int>::get_i() << endl; // 1
    // Data::get_i();//错误 不知道调用哪一个Data实例中的get_i
    return 0;
}
```

### 模板参数

一个模板参数的名字没有什么内在含义，我们通常在一个模板参数的情况下，将参数命名为 T

```cpp
template<typename T> void func(const T&t){

}
```

### 模板参数与作用域

模板参数的作用域在其声明之后，至模板声明或定义结束之前\
模板参数名不能重用，一个模板参数名在特定模板参数列表中只能出现一次

```cpp
//example14.cpp
double T;

template <typename T, typename F>
void func(const T &t, const F &f) // typename T覆盖double T
{
    cout << t << " " << f << endl;
    T t1;
}
```

### 模板声明

模板内容的声明必须包括模板参数\
一个给定模板的每个声明和定义必须拥有相同的数量和种类的参数

```cpp
//example15.cpp
//声明函数模板
template <typename T>
void func(const T &t);

//声明类模板
template <typename T>
class A;

//模板定义
template <typename F>
void func(const F &f)
{
    cout << f << endl;
}

//类模板定义
template <typename T>
class A
{
public:
    void func(const T &t);
};

template <typename T>
void A<T>::func(const T &t)
{
    cout << t << endl;
}

int main(int argc, char **argv)
{
    func(19);            // 19
    func("hello world"); // hello world
    A<int> a;
    a.func(19); // 19
    return 0;
}
```

### 使用类的类型成员

再掉用类静态成员时，因为类的类型为一个模板类型参数时\
编译器不知道是调用函数名为`T::mem`的函数还是`T`类的静态成员`mem`,如果需要使用模板参数类型的静态成员，需要进行显式的声明，使用关键字 typename

```cpp
T::mem();//错误
typename T::mem();//正确
```

```cpp
//example16.cpp
template <typename T>
class A
{
public:
    typename T::size_type func(const T &t)
    {
        typename T::size_type size; //正确
        // T::size_type size;//错误
        size = t.size();

        return size;
    }
    static void hi()
    {
        cout << "hi" << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> vec{1, 2, 3, 4};
    A<vector<int>> a;
    cout << a.func(vec) << endl; // 4

    A<std::vector<int>>::hi(); // hi
    return 0;
}
```

### 默认模板实参

如同函数参数一样，也可以像模板参数提供默认实参，但实参不知值而是类型\
如下面代码样例，首先在 compare 被调用时，编译器通过实参类型与模板函数形参类型匹配，将能够推算出的模板参数推算出来，然后将模板参数列表内的全部 typename 进行初始化，然后确定了所有模板参数类型，然后进行实参的初始化，要知道这些操作都是在编译阶段完成的

```cpp
//example17.cpp
template <typename T, typename F = less<T>>
int compare(const T &t1, const T &t2, F f = F())
{
    if (f(t1, t2)) // v1<v2
        return -1;
    if (f(t2, t1)) // v2<v1
        return 1;
    return 0;
}

int main(int argc, char **argv)
{
    cout << compare(1, 3) << endl; //-1
    cout << compare(3, 1) << endl; // 1
    cout << compare(1, 1) << endl; // 0
    return 0;
}
```

### 模板默认实参与类模板

与函数模板默认参数同理，在参数列表内进行类型赋值

```cpp
//example18.cpp
template <typename T = int>
class A
{
public:
    void func(const T &t) const
    {
        cout << t << endl;
    }
};

int main(int argc, char **argv)
{
    A<> a;
    a.func(19); // 19
    // a.func("dcs"); //错误
    A<string> a_s;
    a_s.func("hello world"); // hello world
    return 0;
}
```

### 成员模板

一个类（无论是普通类还是类模板），本身可以含有模板的成员函数，这总成员称为成员模板(member template),成员模板不能是虚函数

### 普通类的成员模板

将成员函数直接定义为函数模板

```cpp
//example19.cpp
class A
{
public:
    template <typename T>
    void func(const T &t) const
    {
        cout << t << endl;
    }
    template <typename T>
    void operator()(T *p) const
    {
        delete p;
    }
};

int main(int argc, char **argv)
{
    A a;
    a.func(12);    // 12
    a.func("oop"); // oop
    //类A本身拥有了 func(const int&t)与func(const string&)的两个重载
    unique_ptr<int, A> num1(new int(19), a);
    unique_ptr<float, A> num2(new float(19.0), a);
    return 0;
}
```

### 类模板的成员模板

类模板与成员模板二者拥有自己的模板参数，当存在 typename 的名字相同时会产生冲突编译不通过，因为在一个范围内相同名字 typename 只能用一次

如下样例中，函数成员在类作用域下，类的模板参数名不能与内部的冲突，但是 hello 与 hi 是两个独立的作用域，二者之间不会影响

```cpp
//example20.cpp
template <typename T>
class A
{
public:
    static void func(const T &t)
    {
        cout << t << endl;
    }

    template <typename F>
    void hello(const F &f)
    {
        cout << f << endl;
    }

    template <typename F>
    void hi(const F &f)
    {
        cout << f << endl;
    }
};

int main(int argc, char **argv)
{
    A<int> a;
    a.func(19); // 19
    // a.func("oop");//错误

    a.hello("sds"); // sds
    a.hello(19);    // 19

    a.hi(19);    // 19
    a.hi("oop"); // oop
    return 0;
}
```

### 实例化与成员模板

成员模板的具体应用，最熟悉的就是容器的列表初始化操作中，有时不能提前知道初始化列表中存储的那种类型的数据，或者根据迭代器范围进行初始化时，只要它们内置的元素可以向目标容器的数据类型转换就可以实现这种操作，在容器的初始化中有学习到

```cpp
//example21.cpp
int main(int argc, char **argv)
{
    initializer_list<int> list = {1, 2, 3, 4, 5};
    int arr[] = {1, 1};
    //为什么不能用{1.0,1.0}因为float到int需要进行强制转换，不能自动转换
    cout << arr[0] << " " << arr[1] << endl; // 1 1
    vector<float> vec = {1, 2, 3, 4};
    //背后的构造原理就是使用了initializer_list<T> 在未知具体类型下定义模板成员
    //由编译器自动生成
    for (const auto &item : vec) // 1 2 3 4
    {
        cout << item << endl;
    }

    vector<int> vec1{1, 2, 3};
    vector<float> vec2(vec1.begin(), vec1.end());
    //这种背后也是模板成员的应用 接收vector迭代器 但用模板参数解决vector中的数据类型
    for (const auto &item : vec2) // 1 2 3
    {
        cout << item << endl;
    }
    return 0;
}
```

背后是怎样的呢，大致原理是什么？

```cpp
//example22.cpp
class A
{
public:
    vector<float> vec;
    template <typename T>
    A(const initializer_list<T> &t)
    {
        vec.assign(t.begin(), t.end());
    }
    void print()
    {
        for (const auto &item : vec)
        {
            cout << item << " ";
        }
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    initializer_list<int> m_list = {1, 2, 3, 4};
    A a(m_list);
    A b({1.0, 2.0, 3.0, 4.0}); // A b(initializer_list<float>)
    a.print();                 // 1 2 3 4
    b.print();                 // 1 2 3 4
    return 0;
}
```

### 控制实例化

当模板被使用时才会被进行实例化，则相同的实例可能出现在多个对象文件中，两多个独立编译的源文件中使用了相同的模板，并提供相同的模板参数时，每个文件中都会有该模板的一个实例，这样的开销可能非常严重，在 C++11 中可以通过显式实例化(explicit instantiation)来避免这种开销

```cpp
extern template declaration;//实例化声明
template declaration;       //实例化定义
```

```cpp
//example23/main.cpp
#include <iostream>
#include <string>
#include "main.h"
using namespace std;

template class A<string>;         //定义模板实例
template void func(const int &t); //定义模板实例

extern void m_func();

int main(int argc, char **argv)
{
    m_func();
    return 0;
}
// g++ -c main2.cpp
// g++ -c main.cpp
// g++ main.o main2.o -o main.exe
// ./main.exe
```

编译器遇见定义模板实例时会生成代码，所以 A 的 func 实例在 main.o 内

```cpp
//example23/main.h
#ifndef main_h
#define main_h
#include <iostream>
void m_func();
//定义类模板
template <typename T>
class A
{
public:
    void func(const T &t)
    {
        using namespace std;
        cout << t << endl;
    }
};

//定义函数模板
template <typename T>
void func(const T &t)
{
    using namespace std;
    cout << t << endl;
}
#endif
```

extern 表示其定义在其他源文件定义，想要程序完整必须进行链接

```cpp
//example23/main2.cpp
#include "main.h"
#include <string>
#include <iostream>
using namespace std;
extern template class A<string>;
extern template void func(const int &t);

void m_func()
{
    A<string> a;
    a.func("hello world"); // hello world
    func(12);              // 12
}
```

> 重点概念：与普通的模板实例化不同，实例化定义会实例化所有成员，普通的使用实例化仅仅实例化我们有使用到的成员，而在显式实例化中，编译器不知道我们需要使用哪些成员，所以它直接会将所有成员进行实例化，包括内联的成员 。 进而在一个类模板的显式实例化定义中，提供的模板类型参数必须能用于模板的所有成员函数

### shared_ptr 与 unique_ptr 中的模板知识

已经学习过 shared_ptr 与 unique_ptr,它们提供了自定义删除器的方法

1、shared_ptr 可以在定义是提供删除器，例如下面格式

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
```

shared_ptr 也可以在 reset 时提供删除器，可见 shared_ptr 是在运行时绑定删除器的

```cpp
del?del(p):delete p;
```

2、unique_ptr 只能在定义时在见括号内提供自定义删除器

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

void func()
{
    unique_ptr<Person, decltype(deletePerson) *> u2(new Person(), deletePerson);
}
```

shared_ptr 是将删除器的指针或引用等存储到了对象内部，当删除是需判断，而 unique 则是使用了类模板参数，并且为删除器提供了默认参数为 delete，可见二者删除器的绑定原理是不一样的，前者是运行时绑定，后者是使用模板编译器在编译阶段进行了代码级别的绑定

### 模板实参推断

在函数模板中，编译器利用调用中地函数地实参类型来确定模板参数，这一过程称为`模板实参推断`。在类模板中是通过尖括号进行初始化模板参数列表

### 类型转换与模板类型参数

当使用模板时提供地模板实参之间可以进行类型转换时，只有有限地几种类型会自动地应用于这些实参，编译器通常不是对实参进行类型转换、而是生成一个新的模板实例

可以进行类型转换的情况有两种\
1、const 转换：非 const 对象的引用或指针，传递给一个 const 的引用或指针形参\
2、数组或函数指针转换：如果函数形参不是引用类型、则可以对数组或函数类型的实参应用正常的指针转换，一个数组实参可以转换为一个指向其首元素的指针、一个函数实参可以转换为一个该函数类型的指针、而不是不同长度的数组或者不同函数传递时都会产生新的模板实例

```cpp
//example24.cpp
//拷贝
template <typename T>
T f1(T t1, T t2)
{
    return t1;
}
//引用
template <typename T>
const T &f2(const T &t1, const T &t2)
{
    return t1;
}
//接收可调用对象
template <typename T>
void f3(const T &f)
{
    f();
}

void func()
{
    cout << "hello world" << endl;
}

int main(int argc, char **argv)
{
    string s1("oop");
    const string &s2 = f2(s1, s1);
    cout << s2 << endl; // oop
    s1 = "hello world";
    cout << s2 << endl; // hello world

    int a[10], b[20];
    int *arr_a = f1(a, b); //按照首地址指针处理
    arr_a[0] = 999;
    cout << a[0] << endl; // 999

    //错误 按照数组的引用处理错误 const T &t1, const T &t2
    //实参 t1 t2类型不同 因为a与b的大小不同
    // const int *arr_a_ptr = f2(a, b);
    // cout << arr_a_ptr[0] << endl; // 999

    //函数到函数指针的转换
    f3(func); // hello world
    return 0;
}
```

> 重点:将实参传递给带模板类型的函数形参时，能够自动进行类型转换只有 const 转换与(数组或函数)到指针的转换

### 使用相同的模板参数类型

当形参列表中多次使用了模板参数类型时，在传递实参时这些位置的实参的类型在不进行类型转换的情况下，应该相同

```cpp
//example25.cpp
template <typename T>
void func(T t1, T t2)
{
    cout << t1 * t2 << endl;
}

int main(int argc, char **argv)
{
    // func(long(12), int(12));
    // no matching function for call to 'func(long int, int)'

    float num = 99.0;
    // func(num, 12);
    // no matching function for call to 'func(float&, int)'

    func(long(19), long(32)); // 608
    return 0;
}
```

### 非模板类型参数可正常类型转换

在函数模板形参中，如果有非模板参数类型的形参，则其正常类型转换不会受到影响

```cpp
//example26.cpp
template <typename T>
void func(float num, ostream &os, const T &t)
{
    os << num << " " << t << endl;
}

int main(int argc, char **argv)
{
    func(int(19), cout, 12); // 19 12
    ofstream f("output.iofile");
    func(unsigned(12), f, 12); //在文件output.iofile内 12 12
    f.close();
    return 0;
}
```

可见 func 函数模板的形参中 float num 与 ostream\&os 都可以进行正常的类型转换，追溯原理还要从模板编译说起，在编译器检测到模板被调用时，先检测实参列表是否匹配，对于非模板参数类型还要进行是否可以进行类型转换，而不是简单的类型匹配

### 函数模板显式实参

有没有想过当函数模板参数类型中，有些没有被使用到函数形参内，编译器就不能自动推断出类型，这样的情况应该怎样处理，所以允许用户进行使用函数模板显式实参

```cpp
//example27.cpp
template <typename T1, typename T2, typename T3>
T1 sum(T2 t1, T3 t2)
{
    return t1 + t2;
}

int main(int argc, char **argv)
{
    // sum(12, 32);// couldn't deduce template parameter 'T1'
    long long res = sum<long long>(12332, 23);
    cout << res << endl; // 12355
    return 0;
}
```

那么尖括号中提供的显式实参与模板参数类型的匹配机制是怎样的呢？

显式模板实参按左至右顺序与对应模板参数匹配，第一个显式实参与第一个参数匹配、第二个与第二个，以此类推，只有最右的显式模板实参才能忽略

```cpp
//example28.cpp
//糟糕的用法
template <typename T1, typename T2, typename T3>
T3 func(T2 t2, T1 t1)
{
    return t1 * t2;
}
//需要用户显式为T3提供实参
//因为想要为T3提供实参就必须为其前面的模板参数提供实参

int main(int argc, char **argv)
{
    auto res = func<int, int, int>(12, 21);
    cout << res << endl; // 252
    // func<int>(21, 32);//couldn't deduce template parameter 'T3'
    return 0;
}
```

最佳实践就是，将模板参数列表中需要显式提供实参的参数放到列表前面去

### 类型转换应用于显式指定的实参

与非模板参数类型一样，提供显式类型实参的参数也支持正常的类型转换

```cpp
//example29.cpp
template <typename T1>
T1 mul(T1 t1, T1 t2)
{
    return t2 * t1;
}

int main(int argc, char **argv)
{
    // mul(long(122), 12);
    // error:deduced conflicting types for parameter 'T1' ('long int' and 'int')

    auto res = mul<int>(long(122), 12);
    cout << res << endl; // 1464

    auto res1 = mul<double>(23, 32);
    cout << res1 << endl; // 736
    return 0;
}
```

### 尾置返回类型与类型转换

有时需要返回未知的数据类型，但是使用参数类型推断并不能很好解决问题，使用显式模板实参又显得负担很重，那么尾置返回类型就要显现出其作用了

```cpp
//example30.cpp
template <typename Res, typename T>
Res &func(T beg, T end)
{
    return *beg;
}

int main(int argc, char **argv)
{
    vector<int> vec = {1, 2, 3};
    auto res = func<int>(vec.begin(), vec.end());
    cout << res << endl; // 1
    return 0;
}
```

有没有更好的办法解决问题呢，yes！使用尾置返回(在第 6 章 函数时就有接触到)

```cpp
#include <iostream>
#include <vector>
using namespace std;

template <typename T>
auto func(T beg, T end) -> decltype(*beg)
{
    return *beg;
}

// 错误写法，因为编译器decltype时还看不见函数参数呢
// template <typename T1, typename T2>
// decltype(t1 + t2) mysum(T1 t1, T2 t2)
// {
//     return t1 + t2;
// }

// 正确
template <typename T1, typename T2>
auto mysum(T1 t1, T2 t2) -> decltype(t1 + t2)
{
    return t1 + t2;
}

int main(int argc, char **argv)
{
    vector<int> vec = {1, 2, 3};
    auto res = func(vec.begin(), vec.end());
    // auto func<std::vector<int>::iterator>(std::vector<int>::iterator beg, std::vector<int>::iterator end)->int &
    cout << res << flush; // 1

    decltype(vec) r;              // std::vector<int> vec
    decltype(vec.begin()) t;      // std::vector<int>::iterator t
    decltype(0 + 1) y;            // int y
    decltype(*vec.begin() + 1) u; // int u

    return 0;
}
```

### 类型转换模板

在上面我们发现了，还是我有解决问题，只能获得再怎么操作都也只能使用引用类型，怎样获得元素类型呢，这就要使用标准库的`类型转换模板`

```cpp
//example32.cpp
template <typename T>
auto func(T beg, T end) -> typename remove_reference<decltype(*beg)>::type
{
    return *beg;
}

int main(int argc, char **argv)
{
    vector<int> vec = {1, 2, 3};
    vector<int>::value_type res = func(vec.begin(), vec.end());
    cout << res << endl; // 1

    int num = 999;
    int &num_ref = num;
    //脱去引用
    remove_reference<decltype(num_ref)>::type num_copy = num_ref;
    // int num_copy=num_ref;
    return 0;
}
```

类似的模板类有很多，其都在头文件`type_traits`内

![标准类型转换模板](<../.gitbook/assets/屏幕截图 2022-07-16 212018.jpg>)

```cpp
//example33.cpp
int main(int argc, char **argv)
{
    //脱引用
    remove_reference<int &>::type t1;  // int t1
    remove_reference<int &&>::type t2; // int t2
    remove_reference<int>::type t3;    // int t3

    //加const
    int num = 1;
    add_const<int &>::type t4 = num;     // int &t4
    add_const<const int>::type t5 = num; // const int t5
    add_const<int>::type t6 = num;       // const int t5

    //加左值引用
    add_lvalue_reference<int &>::type t7 = num;  // int &t7
    add_lvalue_reference<int &&>::type t8 = num; // int &t8
    add_lvalue_reference<int>::type t9 = num;    // int &t8

    //还有如
    // add_rvalue_reference加右值引用
    // remove_pointer 移除指针（从指针类型退出值类型）
    // make_signed 去unsigned
    // make_unsigned 从带符号类型退出相应的unsgined
    // remove_extent 根据数组类型得到元素类型
    // remove_all_extents 根据多维数组推断

    remove_extent<int[10]>::type item1;          // int item1
    remove_all_extents<int[10][10]>::type item2; // int item2
    return 0;
}
```

先知道有这么个东西吧，其实很少用到的，除非想要开发一个高复用的库可能会用到

### 函数模板与函数指针

函数模板可以与函数指针进行操作时，也会涉及模板参数类型的推断问题

```cpp
//example34.cpp
template <class T>
T big(const T &t1, const T &t2)
{
    return t1 > t2 ? t1 : t2;
}

int main(int argc, char **argv)
{
    int (*pf1)(const int &t1, const int &t2) = big;
    auto res = (*pf1)(12, 32);
    cout << res << endl; // 32
    return 0;
}
```

函数模板在赋给函数指针时，相关的模板参数推断是根据左边的函数指针类型进行推断的

当作为函数模板作为函数参数传递时可能会遇见的问题

```cpp
//example35.cpp
template <typename T>
T big(const T &t1, const T &t2)
{
    return t1 > t2 ? t1 : t2;
}

void func(int (*p)(const int &t1, const int &t2))
{
    cout << (*p)(12, 32) << endl;
}

void func(string (*p)(const string &s1, const string &s2))
{
    cout << (*p)("23", "dsc") << endl;
}

int main(int argc, char **argv)
{
    // func(big); // error: call of overloaded 'func(<unresolved overloaded function type>)' is ambiguous
    //可见func传递big在确定重载时是模棱两可的

    //如何解决，使用显式模板参数
    func(big<int>);    // 32
    func(big<string>); // dsc
    return 0;
}
```

### 从左值引用函数参数推断类型

主要讨论的就是，T&与 const T&在使用中的类型推断

```cpp
//example36.cpp
// T&
template <typename T>
void func1(T &t)
{
    cout << t << endl;
}

// const T&
template <typename T>
void func2(const T &t) // t具有底层const
{
    cout << t << endl;
}

int main(int argc, char **argv)
{
    // func1(12);//错误12不是左值引用
    int num = 19;
    func1(num); // 19
    const int num1 = 999;
    // T 按const int处理
    func1(num1); // void func1<const int>(const int &t)

    func2(18);   // 18
    func2(num);  // void func2<int>(const int &t)
    func2(num1); // 999

    return 0;
}
```

### 从右值引用函数参数推断类型

讨论 T&&用作右值引用时的情况

```cpp
//example37.cpp
template <typename T>
void func(T &&t)
{
    t = 999;
    cout << t << endl;
}

int main(int argc, char **argv)
{
    // void func<int>(int &&t)
    func(11); // 999

    int num = 888;
    func(num); // 999，话说num不是左值吗，t右值引用怎么绑到num了
    // void func<int &>(int &t)
    cout << num << endl;  // 999
    func(std::move(num)); // void func<int>(int &&t)

    func(12.0f); // void func<float>(float &&t)
    func(23.32); // void func<double>(double &&t)

    return 0;
}
```

### 万能引用

常量左值引用既可以引用左值又可以引用右值，几乎是一个万能引用，但是由于其常量性，导致使用受到限制。但是从 C++11 开始，确实有被称为“万能”的引用，看似是一个右值引用，但区别很大。

万能引用既可以绑定左值也可以绑定右值，甚至 const 和 volatile 的值也可以绑定。可以看下面的例子，真实盖了帽了。

```cpp
#include <iostream>
#include <string.h>
using namespace std;

class X
{
public:
    X() : ptr(new char[1024])
    {
        cout << "X()" << endl;
    }
    X(const X &x) : ptr(new char[1024])
    {
        cout << "X(const X &x)" << endl;
        memcpy(ptr, x.ptr, 1024);
    }
    X &operator=(const X &x)
    {
        cout << "operator=(const X &x)" << endl;
        if (this != &x)
        {
            if (!ptr)
                ptr = new char[1024];
        }
        memcpy(ptr, x.ptr, 1024);
        return *this;
    }
    X(X &&x) noexcept
    {
        cout << "X(X &&x)" << endl;
        ptr = x.ptr;
        x.ptr = nullptr;
    }
    X &operator=(X &&x) noexcept
    {
        cout << "operator=(X &&x)" << endl;
        ptr = x.ptr;
        x.ptr = nullptr;
        return *this;
    }
    ~X()
    {
        cout << "~X()" << endl;
        if (ptr)
            delete[] ptr;
    }

public:
    char *ptr{nullptr};
};

X func()
{
    X x;
    return x;
}

template <typename T>
void bar(T &&t) // t为万能引用
{
}

int main(int argc, char **argv)
{
    X &&x1 = func(); // x1为右值引用,X() X(X&&) ~X()
    // X &&x2
    auto &&x2 = func(); // x2为万能引用,X() X(X&&) ~X()
    int i = 100;
    int &i_ref = i;
    const int j = 100;
    bar(i);     // void bar<int &>(int &t)
    bar(i_ref); // void bar<int &>(int &t)
    bar(j);     // void bar<const int &>(const int &t)
    bar(100);   // void bar<int>(int &&t)
    //~X() ~X()
    auto &&k = 11; // int &&k
    auto &&k1 = i; // int &k1
    auto &&k3 = j; // const int &k3
    return 0;
}
```

### 右值引用折叠与模板参数

在上面代码 example37.cpp 中可以发现，为什么普通的 int num 可以传递给 func，而且推断出的 T&&实际为 int&,这是怎么回事呢？

1、将一个左值传递给函数的右值引用参数，且右值引用指向模板类型参数时，编译器推断类型参数实参为左值引用类型，如传递 int 类型的 num,则 T 为 int&\
2、不能直接定义引用的引用，但是如果间接创建了引用的引用，则会折叠，如 int& &&则实际为 int&,int&& &,int& &都会折叠为 int &, 类型 int&& &&折叠为 int &&

```cpp
//example38.cpp
template <typename T>
void func(T &&t)
{
    cout << t << endl;
}

/*void f(int &&&num){}不允许直接使用引用的引用*/

int main(int argc, char **argv)
{
    int num = 999;
    func(num); // T被推断为int& ,int& &&折叠为int&
    const int n1 = 888;
    func(n1); // T被推断为 const int& ,const int& &&折叠为 cosnt int&
    func(88); //正常右值引用 int&&

    func<int>(12);    // void func<int>(int &&t) T推断为int
    func<int &>(num); // void func<int &>(int &t) 折叠 int& &&
    func<int &&>(12); // void func<int &&>(int &&t) 折叠 int&& &&
    return 0;
}
```

因为有这个特性，当我们在 func 中使用 T 关键词时，它又会代表着怎样的特性呢？

```cpp
//example39.cpp
template <typename T>
void func(T &&t)
{
    T t1 = t;
    t1 = 888;
    cout << (t1 == t ? "true" : "false") << endl;
}

void f(const int &t)
{
    cout << "const int & " << t << endl;
}

void f(int &&t)
{
    cout << "&& " << t << endl;
}

int main(int argc, char **argv)
{
    int num = 999;
    func<int>(12);    // false T被推断为 int
    func<int &>(num); // true T被推断为int& ，t实际类型为int&
    // func<int &&>(12); //错误 T被推断为 int&& 不能将左值t赋给int&&t1

    const int i = 888;
    // func(i);//错误 T被推断为 const int，t1=888发生错误

    int &&j = 999;
    f(j); // const int& 999
    j = 888;
    f(j); // const int& 888

    f(99); //&& 99
    return 0;
}
```

### 理解 std::move

回顾一下 std::move

```cpp
//example40.cpp
int main(int argc, char **argv)
{
    int &&i = 999;
    int num = 999;
    // int &&j = num;//错误 不能将左值绑到右值引用上

    int &&j = std::move(num); //使用move
    cout << j << endl;        // 999
    num = 888;
    cout << j << endl; // 888

    return 0;
}
```

std::move 可以使得传入的实参作为右值，绑定到右值引用，背后的原理是怎样的呢？下面将进行学习相关知识

### std::move 是如何定义的

```cpp
//example41.cpp
template <typename T>
typename remove_reference<T>::type &&func(T &&t)
{
    return static_cast<typename remove_reference<T>::type &&>(t);
}

int main(int argc, char **argv)
{
    int num = 999;
    int &&i = func(num);
    num = 888;
    cout << i << endl; // 888
    return 0;
}
```

其中使用了 remove_reference 移除引用获取数据类型，返回其相应数据类型的右值引用，返回值使用 static_cast 进行强制转换得到

### std::move 是如何工作的

总之就是背后 remove_reference 与 static_cast 的功劳

```cpp
//example42.cpp
int main(int argc, char **argv)
{
    int num = 999;
    int &&i = move(num);
    // T推断为int&
    // remove_reference返回int 确定函数返回类型为 int&&

    int &&j = move(88);
    // T推断为int
    // remove_reference返回int 确定函数返回类型为 int&&
    j = 666.;
    cout << j << endl; // 666
    return 0;
}
```

### static_cast 左值转右值引用

通常 static_cast 只能用在如 float->int 等其他合法的类型转换，但是有一个特殊的规则\
static_cast 可以将一个左值转换为一个右值引用

```cpp
//example43.cpp
int main(int argc, char **argv)
{
    int num = 999;
    // int &&i = num; // error
    int &&i = static_cast<int &&>(num);
    i = 888;
    cout << num << endl; // 888
    return 0;
}
```

---

以上的内容确实是相当无趣的，可能过几天就会忘记，在开发中也会用得很少，但是别忘记有这样得操作，时不时得回来看一看

### 转发

首先我们先了解一下在此得“转发”是什么意思呢？\
当在函数模板内使用形参作为调用函数时的实参，即需要将其中一个或多个实参连同类型不变地转发给其他函数

```cpp
//example44.cpp
void fi(int v1, int &v2)
{
    cout << v1 << " " << ++v2 << endl;
}

//接收可调用对象f和其他两个参数
//翻转参数调用给定的调用对象
template <typename F, typename T, typename N>
void func(F f, T t, N n)
{
    f(n, t);
}

int main(int argc, char **argv)
{
    func(fi, 12, 21); // 21 13
    int num1 = 99, num2 = 88;
    func(fi, num1, num2);                // 88 100
    cout << num1 << " " << num2 << endl; // 99 88

    const int n1 = 999;
    func(fi, n1, n1); // 999 1000
    // void func<void (*)(int v1, int &v2), int, int>(void (*f)(int v1, int &v2), int t, int n)
    // 在此出现了顶层const被忽略的情况

    return 0;
}
```

如何尽可能保持参数的类型呢

### 保持类型信息的函数参数

使用右值引用做参数即可实现，本质上是利用了万能引用（引用折叠）

```cpp
//example45.cpp
void fi(int v1, int &v2)
{
    cout << v1 << " " << ++v2 << endl;
}

void fir(int v1, const int &v2)
{
    cout << v1 << " " << v2 << endl;
}

//接收可调用对象f和其他两个参数
//翻转参数调用给定的调用对象
template <typename F, typename T, typename N>
void func(F f, T &&t, N &&n)
{
    f(n, t);
}

int main(int argc, char **argv)
{
    const int num1 = 1, num2 = 2;

    // func(fi, num1, num2);//错误 fi(int v1,int&v2); 不能用num1对v2初始化
    //  void func<void (*)(int v1, int &v2), const int &, const int &>
    //         (void (*f)(int v1, int &v2), const int &t, const int &n)
    // T与N被推断为 const int&类型 然后进行了引用折叠 为 const int&
    // const int&不能初始化int&

    func(fir, num1, num2); // 2 1
    //使用右值引用可以保证const得以保留
    //在传递 常量表达式如123 时为 int&&
    // const int时 为 const int&
    // int 时 为 int&
    // int& 时折叠为 int&
    // const int& 时折叠为const int&

    return 0;
}
```

### 完美转发

虽然上面见识了保持类型信息的函数参数，但是学习还不够系统，现代 C++他们说有一种完美转发

```cpp
#include <iostream>
using namespace std;

template <class T>
void show_type(T t)
{
    cout << typeid(t).name() << endl;
}

template <class T>
void value_forwarding(T t)
{
    show_type(t);
}

int main(int argc, char **argv)
{
    string s = "hello world";
    value_forwarding(s);
    return 0;
}
```

上面虽然能达到目的，但是性能看右，引用进行了一次构造、两次拷贝构造。那就有人说用左值引用不就可以了吗

```cpp
#include <iostream>
using namespace std;

template <class T>
void show_type(T t)
{
    cout << typeid(t).name() << endl;
}

template <class T>
void value_forwarding(T &t)
{
    show_type(t);
}

int func()
{
    return 2;
}

int main(int argc, char **argv)
{
    string s = "hello world";
    value_forwarding(s);
    // value_forwarding(1);//编译错误
    // value_forwarding(func());//编译错误
    return 0;
}
```

但是就会又有问题，如果是传递给 value_forwarding 的实参是右值，则会编译错误。那么有有人说用常量左值引用啊，虽然是更有优越性，但是有限制啊是 const 的，有没有完美的方案呢。可以使用右值引用解决。

```cpp
#include <iostream>
using namespace std;

template <class T>
void show_type(T t)
{
    cout << typeid(t).name() << endl;
}

template <class T>
void value_forwarding(T &&t)
{
    show_type(static_cast<T &&>(t));
}

int main(int argc, char **argv)
{
    string s = "hello world";
    value_forwarding(s); // void value_forwarding<std::string &>(std::string &t),T为string,则static_cast折叠后为string&类型
    value_forwarding(1); // void value_forwarding<int>(int &&t),T为int,则static_cast折叠后为int类型
    int i = 100;
    const int j = 100;
    int &i_ref = i;
    auto &j_ref = j;                    // const int &j_ref
    value_forwarding(i);                // void value_forwarding<int &>(int &t),T为int,则static_cast折叠后为int&类型
    value_forwarding(j);                // void value_forwarding<const int &>(const int &t),T为const int,则static_cast折叠后为int&类型
    value_forwarding(i_ref);            // void value_forwarding<int &>(int &t),T为int&,则static_cast折叠后为int&类型
    value_forwarding(j_ref);            // void value_forwarding<const int &>(const int &t)，T为int&,则static_cast折叠后为const int&类型
    value_forwarding(std::move(i));     // void value_forwarding<int>(int &&t)，T为int&&,则static_cast折叠后为int&&类型
    value_forwarding(std::move(j_ref)); // void value_forwarding<const int>(const int &&t)，T为const int&&,则static_cast折叠后为const int&&类型
    return 0;
}
```

不得不佩服，所以称得上“完美转发”这个称号,因为不管穿什么类型，都会保留引用类型、const 转发给目标，还有更优雅的写法，使用`std::forward`,`std::forward`内部也是用`std::static_cast<T&&>`

```cpp
#include <iostream>
using namespace std;

template <class T>
void show_type(T t)
{
    cout << typeid(t).name() << endl;
}

template <class T>
void value_forwarding(T &&t)
{
    show_type(std::forward<T>(t));
}
```

### 在调用中使用 std::forward 保持类型信息

至此还是没有解决问题，在传递右值时会出错,为了解决问题，在 func 中传递参数时使用 forard 或者 move 获得临时右值对目标函数形参初始化

```cpp
//example46.cpp
template <typename T, typename F>
void fi(T &&v1, F &&v2)
{
    cout << v1 << " " << v2 << endl;
}

template <typename F, typename T, typename N>
void func(F f, T &&t, N &&n)
{
    f(std::forward<N>(n), std::forward<T>(t));
    // f(t, n);
    // 当 t n为右值引用时 fi的形参也被推断为右值引用类型
    // 可见右值引用是不能初始化右值引用的
}

int main(int argc, char **argv)
{
    func(fi<int &&, int &&>, 12, 32); // 32 12
    //  func=>(void (*f)(int &&, int &&), int &&t, int &&n)
    //  void fi<int &&, int &&>(int &&v1, int &&v2)
    //  func使用forward得以转发右值引用

    const int &&num1 = 888;
    const int &&num2 = 999;
    func(fi<const int, const int>, std::forward<const int>(num1), std::forward<const int>(num2)); // 999 888
    // void fi<const int, const int>(const int &&v1, const int &&v2)
    // func=>(void (*f)(const int &&, const int &&), const int &&t, const int &&n)

    // std::move与std::forward最主要的区别 forward为显式指定类型
    std::move(12);
    int &&i = std::forward<int>(12);
    const int &&j = std::forward<const int &&>(12);
    cout << j << endl; // 12
    // j = 888;//错误
    i = 888;
    cout << i << endl; // 888

    return 0;
}
```

到此，可能脑袋要爆了！不知道你怎么样，反正我快崩溃了，在中文翻译版的书籍，我认为描述的是非常模糊的。甚至我认为翻译得不流畅，没有生动得描述出知识。是在太难了，先坚持吧！后面再进行回顾与复习，与阅读其他书籍或资料进行深入学习

### forward 与 move 区别

`std::move`和`std::forward`的区别，move 一定会将实参转换为一个右值引用，move 使用不用指定模板实参，模板实参是由函数调用推导出来的，forward 会根据左值和右值的实际实际情况进行转发，使用时需要制定模板实参。

### 重载与模板

函数模板可以被另一个普通模板或普通函数重载，名字相同的函数必须具有不同数量或类型的参数

```cpp
//example47.cpp
template <typename T>
string debug_rep(const T &t)
{
    ostringstream ret;
    ret << t;
    return ret.str();
}

template <typename T>
string debug_rep(T *p)
{
    ostringstream ret;
    if (p)
    {
        ret << debug_rep(*p); //调用string debug_rep(const T &t)
    }
    else
    {
        ret << " null pointer";
    }
    return ret.str();
}

int main(int argc, char **argv)
{
    cout << debug_rep("hello world") << endl;         // h std::string debug_rep<const char>(const char *p)
    cout << debug_rep(string("hello world")) << endl; // hello world std::string debug_rep<std::string>(const std::string &t)
    cout << debug_rep(1) << endl;                     // 1 std::string debug_rep<int>(const int &t)
    int num = 999;
    cout << debug_rep(num) << endl;  // 999 std::string debug_rep<int>(const int &t)
    cout << debug_rep(&num) << endl; // 999 std::string debug_rep<int>(int *p)
    return 0;
}
```

### 多个可行模板

再对模板重载匹配时可能存在多个匹配都是符合要求的

```cpp
const int *ptr = &num;
debug_rep(ptr);       // std::string debug_rep<const int>(const int *p)
```

理论上可以匹配为 debug_rep(const string\*&)或 debug_rep(const string\*),但根据重载函数模板的特殊规则，此调用被解析为后者，因为后者更特例化

```cpp
//example48.cpp
template <typename T>
string debug_rep(const T &t)
{
    ostringstream ret;
    ret << t;
    return ret.str();
}

template <typename T>
string debug_rep(T *p)
{
    ostringstream ret;
    if (p)
    {
        ret << debug_rep(*p); //调用string debug_rep(const T &t)
    }
    else
    {
        ret << " null pointer";
    }
    return ret.str();
}

int main(int argc, char **argv)
{
    int num = 999;
    const int *ptr = &num;
    int *const ptr1 = &num;
    *ptr1 = 888;
    cout << *ptr << endl; // 888
    debug_rep(ptr);       // std::string debug_rep<const int>(const int *p)
    return 0;
}
```

> Note: 当有多个重载模板对一个调用提供同样好的匹配时，应选择最特例化的版本

### 模板与非模板重载

完全可以存在与函数模板相同名称的普通函数

```cpp
//example49.cpp
template <typename T>
string debug_rep(const T &t)
{
    ostringstream ret;
    ret << t;
    return ret.str();
}

string debug_rep(const string &t)
{
    cout << "debug_rep(const string &t)\n";
    return t;
}

int main(int argc, char **argv)
{
    cout << debug_rep(string("cd")) << endl; // debug_rep(const string &t) cd
    cout << debug_rep("ds") << endl;         // ds
    //能够匹配到普通函数就不会使用模板
    return 0;
}
```

> Note: 对于一个调用，如果一个非函数模板与一个函数模板提供同样好的匹配，则选择非模板版本

### 重载模板和类型转换

对于 debug_rep("hello world"),存在多个匹配都是可行的

```cpp
debug_rep(const T&);
debug_rep(T*);
debug_rep(const string&);
```

```cpp
//example50.cpp
// 1
template <typename T>
void debug_rep(const T &t)
{
    cout << t << endl;
}

// 2
template <typename T>
void debug_rep(T *t)
{
    cout << t << endl;
}

// 3
void debug_rep(const string &t)
{
    cout << t << endl;
}

int main(int argc, char **argv)
{
    // 1 2 3 存在
    debug_rep("oop"); // oop void debug_rep<const char>(const char *t)
    // 1 3存在
    debug_rep("oop"); // oop void debug_rep<char [4]>(const char (&t)[4])
    // 3存在
    debug_rep("oop"); // oop void debug_rep(const std::string &t)
    //发生 const char* 到 const char&的转换

    return 0;
}
```

### 缺少声明可能导致程序行为异常

现在已经学习，再对重载进行匹配时，如果非模板匹配成功则会调用非模板，但是，如果调用函数前并没有非模板的声明，则会使用模板进行生成实例,有时可能会出现预料之外的结果

```cpp
//example51.cpp
template <typename T>
void func(const T &t)
{
    cout << "1 " << t << endl;
}

// TAG::声明
//  void func(const string &t);

int main(int argc, char **argv)
{
    func("hello world");
    // 1 hello world
    // void func<char[12]>(const char(&t)[12])

    func(string("hello world")); // 2 hello world
    //如果 TAG::声明被注释掉将会输出1 hello world
    //采用模板实例而不是非模板

    return 0;
}

void func(const string &t)
{
    cout << "2 " << t << endl;
}
```

> Note: 在定义任何函数前，记得声明所有重载的函数版本，这样就不用担心编译器由于未遇到你希望调用的函数而用模板实例化一个并非你所需的版本。

### 可变参数模板

可变参数模板为解决接收未知的参数类型未知的参数数量问题而生，进一步可以提高程序的复用性\
`可变参数模板(variadic template)`就是一个接收可变数目参数的模板函数或模板类。\
可变数目的参数被称为`参数包(parameter packet)`,`模板参数包(template parameter packet)`表示零个或多个模板参数。`函数参数包(function parameter packet)`,表示零个或多个函数参数

```cpp
//example52.cpp
//  foo为可变参数模板
//  Args为模板参数包
//  rest为函数参数包
template <typename T, typename... Args>
void foo(const T &t, const Args &...rest)
{
}

int main(int argc, char **argv)
{
    // void foo<int, double, std::string>
    foo(int(12), double(23), string("wew")); //模板参数包中有两个参数 double string

    // void foo<double, int>
    foo(double(23), int(3232)); //模板参数包中有一个参数int

    // void foo<double, int, int, int>
    foo(double(232), int(323), int(343), int(4334)); //模板参数包中有三个参数int

    // void foo<std::string>
    foo(string("dscs")); //模板参数包为空

    // void foo<char [4]>
    foo("oop"); //模板参数包为空

    return 0;
}
```

拥有这样的特性，存在着巨大的潜在能力

### sizeof...运算符

使用 sizeof...运算符可以知道参数包内有多少个参数

```cpp
//example53.cpp
template <typename T, typename... Args>
void func(const T &t, Args... args)
{
    cout << sizeof...(Args) << " " << sizeof...(args) << endl;
}

int main(int argc, char **argv)
{
    func(12, 32, 43);         // 2 2
    func(12);                 // 0 0
    func(23, 43, 43.f, 78.f); // 3 3
    return 0;
}
```

### 包扩展

之前有接触过 initializer_list 用于接收未知数量但类型相同的参数

```cpp
//example54.cpp
void func(initializer_list<int> m_list)
{
    for (auto &item : m_list)
    {
        cout << item << " ";
    }
    cout << endl;
}

int main(int argc, char **argv)
{
    func({12, 32, 43}); // 12 32 43
    return 0;
}
```

已经学习了怎么接收参数包，但是怎样利用参数包内的内容呢\
扩展一个包就是将其分解为构成的元素，对每个元素应用模式，获得扩展后的列表

```cpp
//example55.cpp
// 1
template <typename T>
void print(const T &t)
{
    cout << t << " ";
}

// 2
template <typename T, typename... Args>
void print(const T &t, const Args&... args)
{
    cout << t << " ";
    print(args...); //解构参数包
}

int main(int argc, char **argv)
{
    print(12, 32, 43, 23.f, 43); // 12 32 43 23 43
    //调用过程
    /*
    print(12,32,43,23.f,43) 使用2
    print(32,43,23.f,43) 使用2
    print(43,23.f,43) 使用2
    print(23.f,43) 使用2
    print(43) 使用1
    */
    //如果没有定义1会怎样呢
    /*
    在print(43)时只能调用2，此时Args与args为空包，然后函数内部再次调用了print(args...)
    造成错误 print() 即没有相匹配的函数
    */
    return 0;
}
```

再来看个简单的例子吧

```cpp
//example56.cpp
void print(int n, int i, float j, double k)
{
    cout << n << " " << i << " " << j << " " << k << endl;
}

template <typename T, typename... Args>
void func(const T &t, const Args &...args)
{
    print(t, args...);
}

int main(int argc, char **argv)
{
    func(12, 23, 23.f, 23.43); // 12 23 23 23.43
    return 0;
}
```

### 高级包扩展

认识`func(args...)`与`func(args)...`的区别

```cpp
//example57.cpp
template <typename T>
T addOne(const T &t)
{
    return t + 1;
}

template <typename T, typename Y, typename U, typename I>
void print(const T &t, const Y &y, const U &u, const I &i)
{
    cout << t << " " << y << " " << u << " " << i << endl;
}

template <typename... Args>
void func(const Args &...args)
{
    print(addOne(args)...);
    //等价于 print(addOne(arg1),addOne(arg2),addOne(arg3),addOne(arg4))
}

int main(int argc, char **argv)
{
    func(1, 2, 3, 4); // 2 3 4 5
    return 0;
}
```

### 转发参数包

转发参数包就是将接收到的参数包，调用另一个函数时将包传递出去\
在标准容器中 emplace_back 方法就利用了转发参数包的特性

```cpp
//example58.cpp
class A
{
public:
    int a;
    string b;
    A(int a, string b) : a(a), b(b)
    {
    }
};

int main(int argc, char **argv)
{
    list<A> m_list;
    m_list.emplace_back(19, "hi");
    cout << m_list.size() << endl; // 1
    return 0;
}
```

可见 emplace_back 接收参数包，然后将内容转发到了调用 A 的构造函数\
转发就要保证实参中的类型信息，所以其模板类型参数应该为右值引用\
而且使用 std::forward 对内容进行转发

```cpp
//example59.cpp
void func(int i, int j, float k)
{
    cout << i << " " << j << " " << k << endl;
}

void func(int &i, int j)
{
    cout << i << " " << j << " " << endl;
    i++;
}

template <typename... Args>
void emplace_back(Args &&...args) //相当于 T1&&arg1,T2&&arg2...
{
    func(std::forward<Args>(args)...);
    //相当于std::forward<T1>(arg1),std::forward<T2>(arg2)...
}

int main(int argc, char **argv)
{
    emplace_back(12, 32, 34.f); // 12 32 34
    int n = 999;
    emplace_back(n, 12);
    cout << n << endl; // 1000
    return 0;
}
```

到此是不是更懵逼了，不要慌慢慢学，在实际项目中尝试使用就好了，要记得多回来翻一翻，多复习。

### 模板特例化

一个模板使其对所有模板实参都最合适，这部总是能办到，当不是（不希望）使用模板时，可以定义类或函数模板地一个特例化版本

```cpp
//example60.cpp
template <typename T>
int m_compare(const T &t1, const T &t2)
{
    if (t1 < t2)
    {
        return -1;
    }
    else if (t1 > t2)
    {
        return 1;
    }
    return 0;
}

int main(int argc, char **argv)
{
    cout << m_compare(1, 2) << endl;                         //-1
    cout << m_compare(string("abc"), string("abc")) << endl; // 0
    cout << m_compare("oop", "fop") << endl;                 //错误 字符数组不能用< > ==直接比较
    // int m_compare<char [4]>(const char (&t1)[4], const char (&t2)[4])
    return 0;
}
```

怎样可以解决这样地问题呢，有多种办法可以解决

```cpp
//example61.cpp

template <size_t N, size_t M>
int m_compare(const char (&arr1)[N], const char (&arr2)[M])
{
    return strcmp(arr1, arr2);
}

int main(int argc, char **argv)
{
    cout << m_compare("oop", "fop") << endl; // 1
    return 0;
}
```

还可以进行定义函数模板特例化，如下

### 定义函数模板特例化

`template<>`为原模板的所有模板参数提供实参，进行定义函数模板特例化

```cpp
//example62.cpp
template <typename T>
int m_compare(const T &t1, const T &t2)
{
    if (t1 < t2)
    {
        return -1;
    }
    else if (t1 > t2)
    {
        return 1;
    }
    return 0;
}

template <> //<>表示我们将为原模板的所有模板参数提供实参
int m_compare(const char *const &p1, const char *const &p2)
{
    return strcmp(p1, p2);
}

int main(int argc, char **argv)
{
    cout << m_compare(1, 2) << endl;                         //-1
    cout << m_compare(string("abc"), string("abc")) << endl; // 0

    //  cout << m_compare("oop", "fop") << endl;//当没有特例化模板时使用模板实例化
    //  int m_compare<char [4]>(const char (&t1)[4], const char (&t2)[4])

    const char *str1 = "oop", *str2 = "oop";
    cout << m_compare(str1, str2) << endl; // 0 使用模板特例化
    // template<> int m_compare<const char *>(const char *const &p1, const char *const &p2)
    return 0;
}
```

### 函数重载与模板特例化

本质：特例化的本质是实例化一个模板，而非重载它。因此，特例化不影响函数匹配

```cpp
//example63.cpp
template <typename T>
int m_compare(const T &t1, const T &t2)
{
    if (t1 < t2)
    {
        return -1;
    }
    else if (t1 > t2)
    {
        return 1;
    }
    return 0;
}

template <> //<>表示我们将为原模板的所有模板参数提供实参
int m_compare(const char *const &p1, const char *const &p2)
{
    return strcmp(p1, p2);
}

int main(int argc, char **argv)
{
    m_compare("wdw", "cds");
    // 此时模板与其特例化二者都是可行的，提供同样好的匹配
    // 但接收数组参数的版本更特例化，编译器会选择
    // int m_compare<char [4]>(const char (&t1)[4], const char (&t2)[4])
    return 0;
}
```

如果还存在非模板函数，调用情况又会不同

```cpp
//example64.cpp
template <typename T>
int m_compare(const T &t1, const T &t2)
{
    if (t1 < t2)
    {
        return -1;
    }
    else if (t1 > t2)
    {
        return 1;
    }
    return 0;
}

template <> //<>表示我们将为原模板的所有模板参数提供实参
int m_compare(const char *const &p1, const char *const &p2)
{
    return strcmp(p1, p2);
}

int m_compare(const char *const &p1, const char *const &p2)
{
    cout << "it's not template" << endl;
    return strcmp(p1, p2);
}

int main(int argc, char **argv)
{
    m_compare("wdw", "cds"); // it's not template
    return 0;
}
```

当模板、模板特例化、非模板交杂在一起程序变得复杂起来，可阅读性也会大大下降\
还有关于模板特例的作用域问题，想要使用模板特例就要在调用模板函数前，存在模板特例的声明，否则编译器会使用模板进行实例的生成\
最佳实践：模板及其特例化版本应该声明在同一个头文件中，所有同名模板的声明应该放在前面，然后是模板的特例化版本。

### 类模板特例化

类模板特例化与函数模板特例化类似

```cpp
//example65.cpp
//声明
template <typename T>
class A;
template <>
class A<int>;

template <typename T>
class A
{
public:
    T t;
    A(const T &t) : t(t)
    {
        cout << "template<typename T>" << endl;
    }
};

//类模板特例化定义
template <>
class A<int>
{
public:
    int t;
    A(const int &t) : t(t)
    {
        cout << "template <>" << endl;
    }
};

int main(int argc, char **argv)
{
    A<int> a(12); // template <>
    return 0;
}
```

### 实战类模板特例化

下面来做些有趣的事情，我们对标准库内的模板进行特例化

```cpp
//example66.cpp
class A
{
public:
    int a;
    float b;
    unsigned int c;
    A(int a, float b, unsigned int c, int d) : a(a), b(b), c(c), d(d)
    {
    }
    friend class std::hash<A>;

private:
    int d;
};

//打开std命名空间 以便特例化std::hash
namespace std
{
    template <>
    class hash<A>
    {
    public:
        typedef size_t result_type;
        typedef A argument_type;
        size_t operator()(const A &a) const;
    };
    size_t hash<A>::operator()(const A &a) const
    {
        return hash<int>()(a.a) ^ hash<float>()(a.b) ^ hash<double>()(a.c) ^ hash<int>()(a.d);
    }
}

int main(int argc, char **argv)
{
    A a(1, 2.f, 4, 6);
    std::hash<A>::result_type res = std::hash<A>()(a);
    cout << res << endl; // 1000015520
    A b(2, 4.f, 5, 7);
    cout << std::hash<A>()(b) << endl; // 672367880
    return 0;
}
```

定义 hash 有什么用呢，当使用 A 作为容器的关键字类型时，编译器就会自动使用此特例化版本，而不是编译器自动生成的

```cpp
//example67.cpp
class A
{
public:
    int a;
    float b;
    unsigned int c;
    A(int a, float b, unsigned int c, int d) : a(a), b(b), c(c), d(d)
    {
    }
    friend class std::hash<A>;
    bool operator==(const A &other) const
    {
        return other.a == a && other.b == b && other.c == c && other.d == d;
    }

private:
    int d;
};

//打开std命名空间 以便特例化std::hash
namespace std
{
    template <>
    class hash<A>
    {
    public:
        typedef size_t result_type;
        typedef A argument_type;
        size_t operator()(const A &a) const;
    };
    size_t hash<A>::operator()(const A &a) const
    {
        cout << "m_hash" << endl;
        return std::hash<int>()(a.a) ^ std::hash<float>()(a.b) ^ std::hash<double>()(a.c) ^ std::hash<int>()(a.d);
    }
}

int main(int argc, char **argv)
{
    A a(1, 2.f, 4, 6);
    unordered_multiset<A> m_set; // m_hash 可见使用了特例化的std::hash
    m_set.insert(a);
    return 0;
}
```

### 类模板部分特例化

与函数模板不同的是，类模板的特例化不必为所有模板参数提供实参，可以只提供一部分而非所有模板参数，被称为部分特例化

```cpp
//example68.cpp
template <typename T>
struct A
{
    A(T t)
    {
        cout << "T" << endl;
    }
};

template <typename T>
struct A<T &>
{
    A(T &t)
    {
        cout << "T&" << endl;
    }
};

template <typename T>
struct A<T &&>
{
    A(T &&t)
    {
        cout << "T&&" << endl;
    }
};

int main(int argc, char **argv)
{
    A<decltype(42)> a1(12); // T
    int i = 999;
    int &n = i;
    A<decltype(n)> a2(n);                       // T&
    A<decltype(std::move(i))> a3(std::move(i)); // T&&
    return 0;
}
```

### 特例化类成员

在参数列表实参符合一定条件下，可以对这个条件下的类的部分成员进行特例化，而不是整合类

```cpp
//example69.cpp
template <typename T>
struct A
{
    A(const T &t = T()) : mem(t)
    {
    }
    T mem;
    void func();
};

//通用型定义
template <typename T>
void A<T>::func()
{
    cout << "A<T>" << endl;
}

//成员特例化
template <>
void A<int>::func()
{
    cout << "A<int>" << endl;
}

int main(int argc, char **argv)
{
    A<float> a1(float(234));
    a1.func(); // A<T>

    A<int> a2(23);
    a2.func(); // A<int>

    A<string> a3(string("scsd"));
    a3.func(); // A<T>
    return 0;
}
```

### 小结

到此模板编程的基础知识会先告一段落了，与此同时第三部分 类设计者的工具也将结束。我想经过控制拷贝、操作重载与类型转换、面向对象程序设计、模板与泛型编程几个章节，我们已经对面向对象有了更进一部的认识，总之学习要坚持，而不是一腔热血转眼就放弃了。
