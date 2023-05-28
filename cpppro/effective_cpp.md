# Effective C++

改善程序与设计的55个具体做法

## 让自己习惯 C++

### 1、视 C++为一个语言联邦

C++是一个多重范型编程语言，支持过程形式、面向对象形式、函数形式、泛型形式、元编程形式，C++高效编程守则视状况而变化，取决于使用C++哪一个部分，在合适的场景选择使用合适的功能

### 2、尽量以 const、enum、inline 替换 define

C开发中以前都在使用宏定义define,但是往往难以维护而且难以调试

* 对于单纯常量，最好以const对象或enums替换define
* 对于形似函数的宏，最好改用inline函数替换define

```cpp
#define ASPECT_RATIO 1.653
//使用const替换
const double AspectRatio = 1.653;
```

const的底层const与顶层const要知道

```cpp
const char* const authorName = "Scott Meyers";//字符串用const代替宏
//cpp等推荐使用string,更加抽象
const std::string authorName("Scott Meyers");
```

对于类内的可以使用静态成员变量

```cpp
class A{
private:
    static const int Num = 5;//常量声明式
    int scores[Num];
};
```

如果不使用A::Num的地址，那么只使用声明式即可，如果要用地址则需要定义式在源文件中

```cpp
const int A::Num;//Num定义，声明时已经提供初值，定义式不再需要提供初值
//如果编译器不支持声明式初始化，则要在定义式提供初值
```

类内的enum更像define，不能取值

```cpp
class A
{
public:
    enum
    {
        Num = 4
    };
    int arr[Num];
};

int main(int argc, char **argv)
{
    cout << A::Num << endl; // 4
    return 0;
}
```

关于define写函数形式的一些问题，尽量使用inline，一般inline函数写在头文件中，因为源文件编译时需要将函数展开

```cpp
#define MAX(a, b) (a) > (b) ? (a) : (b)

int main(int argc, char **argv)
{
    int n = MAX(1, 2);
    cout << n << endl; // 2
    // int n1 = MAX(n++, ++n); 这种问题容易混乱
    return 0;
}
//尽可能使用inline函数，也可以使用模板进行扩展
//函数也能展开，而且利于开发维护
template <typename T>
inline T mymax(const T &a, const T &b)
{
    return a > b ? a : b;
}
```

### 3、尽可能使用 const

* 将某些东西声明为const可帮助编译器侦测出错误用法，const可以被施加于任何作用域内的对象、函数参数、函数返回类型、成员函数本体
* 虽然方法内禁止修改对象属性，但是可以返回属性的引用，如果方法为const的里应当返回const类型
* 当const和non-const成员函数有着等价的实现时，令non-const版本调用const版本可以避免代码重复，用static_cast和const_cast解决

const有顶层const（一般为指针不能修改）与底层const（数据不能修改），

```cpp
char greeting[] = "hello"; 
char *p = greeting;//none-const pointer,non-const data
const char* p =greeting;//non-const pointer,const data
char* const p = greeting;//const pointer,non-const data
const char* const p = greeting;//const pointer,const data
```

有两种形式的表达的意思是相同的,都是data const

```cpp
void func(char const *p);
void func(const char*p);
```

函数返回常量值的作用

```cpp
class A
{
public:
    A(const int &n) : num(n)
    {
    }
    int num;
    const A operator*(const A &o)
    {
        return A(this->num * o.num);
    }
};

int main(int argc, char **argv)
{
    A a(1);
    A b(2);
    A c = a * b;
    //(a * b) = 3;           // 错误：操作数类型为: const A = int，如果返回的不是const值则不报错
    cout << c.num << endl; // 2
    return 0;
}
```

const成员函数

```cpp
class A
{
public:
    static const int num{9};
    char arr[num] = {0};
    const char &operator[](std::size_t position) const
    {
        return arr[position];
    }
    char &operator[](std::size_t position)
    {
        return arr[position];
    }
};

int main(int argc, char **argv)
{
    A a;
    const A b;
    cout << a[0] << endl; // 调用char &A::operator[]
    cout << b[0] << endl; // 调用 const char &A::operator[]
    // b[0] = '1'; 错误
    a[0] = 'a';
    cout << a[0] << endl; // a
    return 0;
}
```

在const和non-const成员函数中避免重复,可以让non-const调用const成员函数

```cpp
class A
{
public:
    static const int num{9};
    char arr[num] = {0};
    const char &operator[](std::size_t position) const
    {
        //...
        // ...
        return arr[position];
    }
    char &operator[](std::size_t position)
    {
        return const_cast<char &>(static_cast<const A &>(*this)[position]);
    }
};
```

### 4、确定对象被使用前已经被初始化

* 为内置型对象进行手工初始化，因为C++不保证初始化它们
* 构造函数最好使用成员初值列，而不是在构造函数本体使用赋值操作，初值列列出的成员变量，其排列次序应该和它们在class中的声明次序相同
* 为免除“跨编译单元之初始化次序”问题，请以local static对象替换non-local static对象

```cpp
int n;
cout << n << endl;
```

会输出什么，大部分都会说0，但是不一定，有随机性，不能相信机器与编译器，加上个初始值不会杀了你

为什么要使用初始化列表，而不是在构造函数内赋值

```cpp
class A
{
public:
    A()
    {
        cout << "A()" << endl;
    }
    A(const int &n)
    {
        cout << "A(const int &n)" << endl;
    }
    const A &operator=(const int &n)
    {
        cout << "const A &operator=(const int &n)" << endl;
        return *this;
    }
};

class B
{
public:
    B()
    {
        a = 1; // 这是赋值不是初始化
    }
    A a;
};

int main(int argc, char **argv)
{
    B b;
    // A()
    // const A &operator=(const int &n)
    return 0;
}
```

如果使用构造函数列表,It's fucking cool.特别注意的是初始化列表为什么要与在类内声明的顺序相同，这是因为它们构造的现后顺序并不取决于在初始化列表中的顺序而是在类内声明的顺序所以我们写代码直接把二者顺序同步好了。

```cpp
class B
{
public:
    B() : a(1)
    {
    }
    A a;
};

int main(int argc, char **argv)
{
    B b;
    // A(const int &n)
    return 0;
}
```

什么是local-static对象和non-local static对象，栈内存与堆内存对象都不是static对象。像全局对象、定义在命名空间作用域内的、在class内的、在函数内的、以及在源文件作用域内的被声明为static的对象。其中在函数内的为local-static其他为non-local static。程序结束时static会被自动销毁，析构函数在main返回前调用

可能有时会使用extern访问在其他源文件定义的对象,如果一个源文件中某个non-local static对象初始化时用到了另一个源文件中的non-local static对象，可能会出现赋值操作右边的变量没有初始化过的情况，因为C++中：对于“定义于不同源文件内的non-local static对象”的初始化次序并无明确定义

```cpp
//mian.cpp
extern int n;
int n1=n;
//main1.cpp
int n;
```

怎样解决这一问题,推荐使用local static代替non-local static

```cpp
//main.cpp
int n1=n();
//main1.cpp
int& n(){
    static int v=100;
    return v;
}
```

## 构造析构赋值运算

### 5、了解 C++默默编写并调用哪些函数

* 编译器可以暗自为class创建default构造函数、copy构造函数、copy assignment操作符、析构函数，默认生成为inline的。

默认生成这些函数是C++的基础知识，应该问题不大，当程序中使用这些函数时编译器才会生成，如果自己声明了自定义的相关函数则编译器不再自动生成默认的对应函数

```cpp
class A
{
public:
    A() {}
    ~A() {}
    A(const A &a)
    {
        this->num = a.num;
    }
    A &operator=(const A &a)
    {
        this->num = a.num;
        return *this;
    }
    int num;
};
```

### 6、若不想使用编译器自动生成的函数应明确拒绝

* 为驳回编译器自动提供的机能，可将相应的成员函数声明为private并且不予实现，使用像Uncopyable这样的基类也是一种办法。

```cpp
//写为private,只声明不定义
class A
{
public:
    A() {}
    ~A() {}

private:
    A(const A &a); // 只声明不定义
    A &operator=(const A &a);
};
//使用delete关键词
class B
{
public:
    B() {}
    ~B() {}
    B(const B &b) = delete;
    B &operator=(const B &b) = delete;
};
int main(int argc, char **argv)
{
    A a;
    A b;
    // a = b; 错误
    return 0;
}
```

还可以使用Uncopyable基类的方式,在基类进行拷贝构造和赋值时，会先执行基类的相关函数

```cpp
class A
{
public:
    A() {}
    A(const A &a)
    {
        cout << "A(const A&a)" << endl;
    }
    A &operator=(const A &a)
    {
        cout << "A& operator=(const A&a)" << endl;
        return *this;
    }
    virtual ~A() = default;
};

class B : public A
{
public:
    B() {}
    B(const B &b) : A(b)
    {
        cout << "B(const B&b)" << endl;
    }
    B &operator=(const B &b)
    {
        if (&b != this)
        {
            A::operator=(b);
        }
        cout << "B &operator=(const B &b)" << endl;
        return *this;
    }
    ~B() = default;
};

int main(int argc, char **argv)
{
    B b1;
    B b2 = b1;
    // A(const A&a)
    // B(const B &b)
    return 0;
}
```

那么就可以写一个Uncopyable基类

```cpp
class A
{
public:
    A() {}
    virtual ~A() = default;

private:
    A(const A &a);
    A &operator=(const A &a);
};

class B : public A
{
public:
    B() {}
    ~B() = default;
    // 里应当自动生成拷贝构造和赋值操作函数，但是由于不能访问基类部分，所以不能自动生成
};

int main(int argc, char **argv)
{
    B b1;
    // B b2 = b1;
    // 无法引用 函数 "B::B(const B &)" (已隐式声明) -- 它是已删除的函数
    return 0;
}
```

### 7、为多态基类声明 virtual 析构函数

* 带有多态性质的基类(polymorphic base classes)应该声明一个virtual析构函数，如果class带有任何virtual函数，它就应该拥有一个virtual析构函数
* 如果类的设计目的不是作为基类使用，或不是为了具备多态性，就不该声明virtual析构函数

先看以下有什么搞人的事情，深入理解此部分要对虚函数表以及C++多态机制有一定了解,下面的代码只执行了基类的析构函数只是释放了基类中buffer的动态内存，而派生类部分内存泄露，这是因为`A*a`,a被程序认为其对象只是一个A,而不是B,如果将基类析构函数改为virtual的，那么会向下找，找到~B执行，然后再向上执行如果虚函数有定义的话

```cpp
class A
{
public:
    A() : buffer(new char[10])
    {
    }
    ~A()
    {
        cout << "~A()" << endl;
        delete buffer;
    }

private:
    char *buffer;
};

class B : public A
{
public:
    B() : buffer(new char[10])
    {
    }
    ~B()
    {
        cout << "~B()" << endl;
        delete buffer;
    }

private:
    char *buffer;
};

int main(int argc, char **argv)
{
    A *a = new B;
    delete a;
    //~A()
    return 0;
}
```

所以要修改为这样，即可

```cpp
class A
{
public:
    A() : buffer(new char[10])
    {
    }
    virtual ~A()
    {
        cout << "~A()" << endl;
        delete buffer;
    }

private:
    char *buffer;
};
```

如果想让基类为抽象类，可以改为纯虚函数,与前面不同的时拥有纯虚函数的类为抽象类不允许实例化，纯虚函数不用定义。而虚函数是需要有定义的。

```cpp
class A
{
public:
    A() {}
    virtual ~A() = 0;
};

A::~A() {}

class B : public A
{
};

int main(int argc, char **argv)
{
    // A a; 错误A为抽象类型
    B b;
    return 0;
}
```

### 8、别让异常逃离析构函数

* 析构函数绝对不要吐出异常，如果一个被析构函数调用的函数可能抛出异常，析构函数应该捕捉任何异常，然后吞下它们或结束程序
* 如果客户需要对某个操作函数运行期间抛出的异常做出反应，那么类应该提供一个普通函数（而非在析构函数中）执行该操作

例如以下情况

```cpp
void freeA()
{
    throw runtime_error("freeA() error");
}

class A
{
public:
    A() {}
    ~A()
    {
        try
        {
            freeA();
        }
        catch (...)
        {
            // std::abort();//生成coredump结束
            // 或者处理异常
            //...
        }
    }
};

int main(int argc, char **argv)
{
    A *a = new A;
    delete a;
    return 0;
}
```

如果外部需要对某些在析构函数内的产生的异常进行操作等，应该提供新的方法，缩减析构函数内容

```cpp
void freeA()
{
    throw runtime_error("freeA() error");
}

class A
{
public:
    A() {}
    ~A()
    {
        if (!freeAed)
        {
            try
            {
                freeA();
            }
            catch (...)
            {
                // std::abort();//生成coredump结束
                // 或者处理异常
                //...
            }
        }
    }
    void freeA()
    {
        ::freeA();
        freeAed = true;
    }

private:
    bool freeAed = {false};
};

int main(int argc, char **argv)
{
    A *a = new A;
    try
    {
        a->freeA();
    }
    catch (const runtime_error &e)
    {
        cout << e.what() << endl;
    }
    delete a;
    return 0;
}
```

### 9、绝不在构造和析构函数过程中调用 virtual 函数

* 在构造和析构期间不要调用virtual函数，因为这类调用从不下降至derived class(比起当前执行构造函数和析构函数的那一层)

1、构造函数中调用虚函数：

当在基类的构造函数中调用虚函数时，由于派生类的构造函数尚未执行，派生类对象的派生部分还没有被初始化。这意味着在基类构造函数中调用的虚函数将无法正确地访问或使用派生类的成员。此外，派生类中覆盖的虚函数也不会被调用，因为派生类的构造函数尚未执行完毕。

2、析构函数中调用虚函数：

当在基类的析构函数中调用虚函数时，如果正在销毁的对象是一个派生类对象，那么派生类的部分已经被销毁，只剩下基类的部分。此时调用虚函数可能会导致访问已被销毁的派生类成员，从而引发未定义行为。

以下程序是没问题的

```cpp
class A
{
public:
    A()
    {
        func();
    }
    virtual ~A()
    {
        func();
    }
    virtual void func()
    {
        cout << "A::func" << endl;
    };
};

class B : public A
{
public:
    B()
    {
        func();
    }
    ~B()
    {
        func();
    }
    void func() override
    {
        cout << "B::func" << endl;
    }
};

int main(int argc, char **argv)
{
    B b;
// A::func 此时只有A::func 无B::func
// B::func 此时在执行B构造函数故执行B::func
// B::func 此时在执行B析构函数故执行B::func
// A::func 此时在执行A析构函数只有A::func 无B::func
    return 0;
}
```

### 10、令 operator=返回一个 reference to \*this

* 令赋值操作符返回一个reference to *this

像+=、-=、*=操作符函数可以没有返回值，但是如果想有赋值连锁形式就要返回引用

```cpp
class A
{
public:
    A()
    {
    }
    virtual ~A()
    {
    }
    void operator=(const A &a)
    {
        cout << "=" << endl;
    }
};

int main(int argc, char **argv)
{
    A a1;
    A a2;
    a1 = a2; //=
    return 0;
}
```

赋值连锁形式,如果想要支持这种形式就要返回引用

```cpp
int x1, x2, x3;
x1 = x2 = x3 = 1;
cout << " " << x1 << " " << x2 << " " << x3 << endl; // 1 1 1
//自定义为
A &operator=(const A &a)
{
    cout << "=" << endl;
    return *this;
}
```

### 11、在 operator=中处理自我赋值

* 确保当对象自我赋值时operator=有良好行为，其中技术包括比较"来源对象"和"目标对象"的地址，精心周到的语句顺序，以及copy-and-swap
* 确定任何函数如果操作一个以上的对象，而其中多个对象是同一个对象时，其行为仍然确定。

```cpp
Object obj;
obj=obj;//这不是有病吗
```

如何判断与解决此问题呢，或者定义使用std::swap（需要定义swap方法或重写operator=）

```cpp
class A
{
public:
    virtual ~A()
    {
    }
    A &operator=(const A &a)
    {
        if (this == &a)
        {
            cout << "self" << endl;
            return *this;
        }
        cout << "other" << endl;
        //----------------------------------------------------
        A temp(a); // 临时副本，一面在复制期间a修改了导致数据不一致
        // 赋值操作
        //...
        //----------------------------------------------------
        return *this;
    }
};

int main(int argc, char **argv)
{
    A a;
    a = a; // self
    A a1;
    a = a1; // other
    return 0;
}
```

### 12、复制对象时勿忘其每一个成分

* Copying函数应该确保复制“对象内的所有成员变量”及“所有base class成分”
* 不要尝试以某个copying函数实现另一个copying函数，应该将共同机能放在第三个函数中，并由两个coping函数共同调用

可能一开始的业务是这样,但后来加上了isman属性，但是你却忘了加到拷贝构造和赋值函数中，那么这是异常灾难，可能你还找不出来自己错在哪里

```cpp
class A
{
public:
    A() {}
    A(const A &a) : num(a.num)
    {
    }
    A &operator=(const A &a)
    {
        this->num = a.num;
    }
    int num;
    //bool isman;
};
```

还有更恐怖的风险，在存在继承时，你可能忘记了基类部分，所以千万不能忘记

```cpp
class A
{
public:
    A() {}
    virtual ~A(){};
    A(const A &a) : num(a.num)
    {
    }
    A &operator=(const A &a)
    {
        this->num = a.num;
        return *this;
    }
    int num;
};

class B : public A
{
public:
    B() : A()
    {
    }
    ~B() {}
    B(const B &b) : A(b), priority(b.priority) // 不要忘记
    {
    }
    B &operator=(const B &b)
    {
        A::operator=(b); // 不要忘记
        this->priority = b.priority;
        return *this;
    }
    int priority;
};
```

## 资源管理

### 13、以对象管理资源

### 14、在资源管理类中小心 copying 行为

### 15、在资源管理类中提供对原始资源的访问

### 16、成对使用 new 和 delete 时要采取相同形式

### 17、以独立语句将 newed 对象置入智能指针

## 设计与声明

### 18、让接口容易被正确使用，不易被误用

### 19、设计 class 犹如设计 type

### 20、宁以 pass-by-reference-to-const 替换 pass-by-value

### 21、必须返回对象时，别妄想返回其 reference

### 22、将成员变量声明为 private

### 23、宁以 non-member、non-friend 替换 number 函数

### 24、若所有参数皆需要类型转换，请为此采用 non-member 函数

### 25、考虑写出一个不抛异常的 swap 函数

## 实现

### 26、尽可能延后变量定义式的出现时间

### 27、尽量少做转型动作

### 28、避免返回 handles 指向对象内部成分

### 29、为异常安全而努力是值得的

### 30、透彻了解 inlining 的里里外外

### 31、将文件间的编译依存关系降到最低

## 继承与面向对象设计

### 32、确定你的 public 继承塑膜出 is-a 关系

### 33、避免遮掩继承而来的名称

### 34、区分接口继承和实现继承

### 35、考虑 virtual 函数以外的其他选择

### 36、绝不重新定义继承而来的 non-virtual 函数

### 37、绝不重新定义继承而来的缺省参数值

### 38、通过复合塑膜出 has-a 或“根据某物实现出”

### 39、明智而审慎地使用 private 继承

### 40、明智而审慎地使用多重继承

## 模板与泛型编程

### 41、了解隐式接口和编译期多态

### 42、了解 typename 的双重意义

### 43、学习处理模板化基类内的名称

### 44、将于参数无关的代码抽离 templates

### 45、运用成员函数模板接受所有兼容类型

### 46、需要类型转换时请为模板定义非成员函数

### 47、请使用 traits classes 表现类型信息

### 48、认识 template 编程

## 定制 new 和 delete

### 49、了解 new-handler 的行为

### 50、了解 new 和 delete 的合理替换时机

### 51、编写 new 和 delete 时需固守常规

### 52、写了 placement new 也要写 placement delete

## 杂项讨论

### 53、不要轻易忽略编译器警告

### 54、让自己熟悉包括 TR1 在内的标准程序库

### 55、让自己熟悉 Boost
