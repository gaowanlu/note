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
