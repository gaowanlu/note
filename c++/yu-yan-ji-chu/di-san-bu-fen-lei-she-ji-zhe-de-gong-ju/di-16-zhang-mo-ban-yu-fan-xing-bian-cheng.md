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
