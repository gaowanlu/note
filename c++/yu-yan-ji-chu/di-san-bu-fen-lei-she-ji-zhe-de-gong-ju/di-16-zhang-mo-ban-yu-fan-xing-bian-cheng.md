---
cover: >-
  https://images.unsplash.com/photo-1533561052604-c3beb6d55b8d?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHw5fHx0b3VyJTIwZGUlMjBmcmFuY2V8ZW58MHx8fHwxNjU3MzM2MDg4&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🧸 第16章 模板与泛型编程

## 第16章 模板和泛型编程

已经学习了标准容器，我们就会产生好奇，为什么它可以存储任意类型呢?向自定义的函数的形参与实参都是有着严格的类型匹配，面向对象编程和泛型编程都能处理在编写程序时不知道类型的情况，不同之处在于，OOP能处理类型在程序运行之前都未知的情况，而泛型编程中，在编译时就能获知类型了，在OOP总我们知道利用虚函数与动态绑定机制可以做到

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

### typename与class

泛型参数的类型确定是编译器时检测被调用时的实参的类型确定的\
`template<class ...>`与`template<typename ...>`两种方式都是可以的，但是现代C++更推荐typename即后者

```cpp
template<class T,typename U>
T func(T*ptr,U*p){
    T& tmp=*p;
    //...
    return tmp;
}
```

但func被调用时，编译器根据T的类型，将模板中的T类型替换为实参类型

### 非类型模板参数

在形参中有些值类型是我们已经确定的，但是不能确定是多少或具体内容，这是可以使用非类型模板参数\
编译器会使用字面常量的大小代替N和M,实例化模板

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

重点：非类型模板参数的模板实参必须是常量表达式

### inline和constexpr的函数模板

inline与constexpr普通函数关键词的位置没什么区别

* inline函数模板

```cpp
template <typename T>
inline int compare(const T&a,const T&b){
    return 1;
}
```

* constexpr函数模板

```cpp
template <typename T>
constexpr int compare(const T&a,const T&b){
    return 1;
}
constexpr int num=compare(19,19);
cout<<num<<endl;//1
```

### 编写类型无关的代码

标准函数对象的内容在第14章 操作重载与类型转换\
在模板编程中，我们力求编写类型无关的代码，尽可能减少对实参的依赖,`总之模板程序应该尽量减少对实参类型的要求`

在上面的代码是有两个特殊的处理

* 模板中的函数参数是const的引用(保证可处理不能拷贝的类型)
* 函数体中的判断条件仅使用`<`比较(使得类型仅支持<比较即可)

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

compare中使用了`<`,但是Person类并没有`<`操作，那么这样的错误在第三阶段才会报告

### 类模板

经过上面的学习，函数模板是用来生成函数的蓝图的。那么类模板有是怎样的呢，类模板(class template)是用来生成类的蓝图的，不像函数模板一样可以推算类型，类模板使用时在名字后使用尖括号提供额外的类型信息，正如我们使用过的list、vector等一样，它们都是类模板

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

在使用一个类模板是，必须提供额外的信息，在example4.cpp中提供的int就是显式模板实参，它们被绑定到模板参数\
每一个类模板的每个实例都形成一个独立的类，`Data<int>`与其他的Data类型直接没有关联，也不会对其他Data类型的成员有特殊访问权限

### 模板类型做实参

类模板的类型实参可以为普通类型或者自定义类型，同时也可以为模板类型\
例如用vector<>来做实参类型

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

在类外定义的类模板的成员函数必须添加template在函数定义前，在类内定义在与普通类一样其被定义为隐式的内联函数

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

### 类模板的static成员

对于类模板的static成员，每种模板实例有自己的static实例

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

一个模板参数的名字没有什么内在含义，我们通常在一个模板参数的情况下，将参数命名为T

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
编译器不知道是调用函数名为`T::mem`的函数还是`T`类的静态成员`mem`,如果需要使用模板参数类型的静态成员，需要进行显式的声明，使用关键字typename

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
如下面代码样例，首先在compare被调用时，编译器通过实参类型与模板函数形参类型匹配，将能够推算出的模板参数推算出来，然后将模板参数列表内的全部typename进行初始化，然后确定了所有模板参数类型，然后进行实参的初始化，要知道这些操作都是在编译阶段完成的

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

类模板与成员模板二者拥有自己的模板参数，当存在typename的名字相同时会产生冲突编译不通过，因为在一个范围内相同名字typename只能用一次

如下样例中，函数成员在类作用域下，类的模板参数名不能与内部的冲突，但是hello与hi是两个独立的作用域，二者之间不会影响

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

当模板被使用时才会被进行实例化，则相同的实例可能出现在多个对象文件中，两多个独立编译的源文件中使用了相同的模板，并提供相同的模板参数时，每个文件中都会有该模板的一个实例，这样的开销可能非常严重，在C++11中可以通过显式实例化(explicit instantiation)来避免这种开销

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

编译器遇见定义模板实例时会生成代码，所以A的func实例在main.o内

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

extern表示其定义在其他源文件定义，想要程序完整必须进行链接

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

### shared\_ptr与unique\_ptr中的模板知识

已经学习过shared\_ptr与unique\_ptr,它们提供了自定义删除器的方法

1、shared\_ptr可以在定义是提供删除器，例如下面格式

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

shared\_ptr也可以在reset时提供删除器，可见shared\_ptr是在运行时绑定删除器的

```cpp
del?del(p):delete p;
```

2、unique\_ptr只能在定义时在见括号内提供自定义删除器

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

shared\_ptr是将删除器的指针或引用等存储到了对象内部，当删除是需判断，而unique则是使用了类模板参数，并且为删除器提供了默认参数为delete，可见二者删除器的绑定原理是不一样的，前者是运行时绑定，后者是使用模板编译器在编译阶段进行了代码级别的绑定

### 模板实参推断

在函数模板中，编译器利用调用中地函数地实参类型来确定模板参数，这一过程称为`模板实参推断`。在类模板中是通过尖括号进行初始化模板参数列表

### 类型转换与模板类型参数

当使用模板时提供地模板实参之间可以进行类型转换时，只有有限地几种类型会自动地应用于这些实参，编译器通常不是对实参进行类型转换、而是生成一个新的模板实例

可以进行类型转换的情况有两种\
1、const转换：非const对象的引用或指针，传递给一个const的引用或指针形参\
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

> 重点:将实参传递给带模板类型的函数形参时，能够自动进行类型转换只有const转换与(数组或函数)到指针的转换

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

可见func函数模板的形参中 float num 与 ostream\&os 都可以进行正常的类型转换，追溯原理还要从模板编译说起，在编译器检测到模板被调用时，先检测实参列表是否匹配，对于非模板参数类型还要进行是否可以进行类型转换，而不是简单的类型匹配

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

有没有更好的办法解决问题呢，yes！使用尾置返回(在第6章 函数时就有接触到)

```cpp
//example31.cpp
template <typename T>
auto func(T beg, T end) -> decltype(*beg)
{
    return *beg;
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

![标准类型转换模板](<../../../.gitbook/assets/屏幕截图 2022-07-16 212018.jpg>)

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
```
