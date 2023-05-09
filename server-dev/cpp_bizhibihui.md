# C++必知必会

## RAII

RAII 是 Resource Acquisition Is Initialization（资源获取即初始化）的缩写，是一种 C++编程技巧。RAII 技巧基于一个很简单的理念：在对象的构造函数中分配资源，而在析构函数中释放资源。这个理念看起来简单，但却具有强大的功能和好处。

最为代表性的就是 C++中的智能指针。

```cpp
#include <iostream>
using namespace std;

class RAII
{
public:
    char *buffer;

public:
    RAII();
    ~RAII();
};

RAII::RAII()
{
    buffer = new char[1024];
    cout << "RAII::RAII" << endl;
}

RAII::~RAII()
{
    delete buffer;
    cout << "RAII::~RAII" << endl;
}

int main(int argc, char **argv)
{
    RAII raii;
    return 0;
}
// RAII::RAII
// RAII::~RAII
```

## pimpl 惯用法

写 C++都知道，如果我们封装一个类，然后封装为库给第三方调用，同时需要提供头文件，但是类中有许多成员变量暴露了太多细节，这一问题有没有办法处理呢  
Pimpl（Pointer to implementation）是 C++编程中的一种惯用法，也称为“编译期实现”。它通过将类的实现细节从公共接口中分离出来，从而使类的实现变得更加抽象，提高了代码的可维护性、可扩展性和安全性。

```cpp
//main.cpp
#include <iostream>
#include <memory>
#include "main2.h"
using namespace std;

int main(int argc, char **argv)
{
    shared_ptr<Person> ptr = make_shared<Person>();
    ptr->print(); // 1 b 2 3
    return 0;
}
```

```cpp
//main2.h
#include <memory>
class Person
{
public:
    Person();
    ~Person();
    void print();

private:
    class Impl; // 内部类
    std::unique_ptr<Impl> m_pImpl;
};
```

```cpp
//main2.cpp
#include "main2.h"
#include <iostream>

using std::cout;
using std::endl;

class Person::Impl
{
public:
    Impl();
    ~Impl() = default;
    int a;
    char b;
    float c;
    double d;
};

Person::Impl::Impl() : a(1), b('b'), c(2.0), d(3.0)
{
}

Person::Person()
{
    m_pImpl.reset(new Impl());
}

Person::~Person()
{
}

void Person::print()
{
    cout << m_pImpl->a << " " << m_pImpl->b << " " << m_pImpl->c << " " << m_pImpl->d << endl;
}
```

## 编译时 C++版本

```cpp
//g++
g++ -g -o test test.cpp -std=c++11
//makefile
make CXXFLAGS="-g -O0 -std=c++11"
//cmake
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -g -Wall -O0 -Wno-unused-variable")
//-Wno-unused-variable 表示禁止编译器对未使用的变量发出警告。
```

## 类成员声明初始化

```cpp
#include <iostream>
#include <string>
using namespace std;

// 需要写在声明中，在头文件内
class Person1
{
public:
    int arr[5] = {1, 2, 3, 4, 5};
    int number{999};
    string str{"hello world"}; // c++11支持用花括号对任意类型的变量初始化
};

// 写到cpp文件中
class Person2
{
public:
    Person2() : arr{1, 2, 3, 4, 5}
    {
    }
    int arr[5];
};

// 写到cpp文件中
class Person3
{
public:
    Person3()
    {
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        arr[3] = 4;
        arr[4] = 5;
    }
    int arr[5];
};

int main(int argc, char **argv)
{
    Person1 person1;
    cout << person1.arr[0] << " " << person1.arr[4] << person1.number << " " << person1.str << endl; // 1 5 9999 hello world
    Person2 person2;
    cout << person2.arr[0] << " " << person2.arr[4] << endl; // 1 5
    Person3 person3;
    cout << person3.arr[0] << " " << person3.arr[4] << endl; // 1 5
    string str{"hello"};
    int number{1};
    cout << str << " " << number << endl; // hello 1
    return 0;
}
```

## initializer_list

详细内容可以看本笔记的 c++部分

```cpp
#include <iostream>
#include <string>
#include <initializer_list>
using namespace std;

class Person
{
public:
    Person(initializer_list<int> m_list);
};

Person::Person(initializer_list<int> m_list)
{
    for (const int &n : m_list)
    {
        cout << n << endl;
    }
}

int main(int argc, char **argv)
{
    Person person{1, 2, 3, 4, 5}; // 1 2 3 4 5
    return 0;
}
```

## C++ 17 注解标签(attributes)

注解标签语法,C++11 支持任意类型、函数或 enumeration，从 c++17 支持了命名空间、enumerator

```cpp
[[attribute]] types/functions/enums/etc
```

常见

```cpp
[[noreturn]]：指定函数不会返回，可以用于提示编译器在函数返回之前不必生成清理代码。
[[nodiscard]]：指定函数的返回值不应该被忽略。
[[deprecated("reason")]]：指定程序实体已经被弃用，并且提供了一个理由。
[[maybe_unused]]：指定程序实体可能未被使用，用于消除编译器的“未使用变量”的警告。
[[fallthrough]]：指定在 switch 语句中，如果一个 case 语句中没有 break 语句，允许掉落到下一个 case 语句中。
[[nodiscard("reason")]]：C++20 引入的，用于给 [[nodiscard]] 添加一个理由。
```

样例

```cpp
#include <iostream>
#include <string>
#include <initializer_list>
using namespace std;

[[nodiscard]] int fun()
{
    return 1;
}

int main(int argc, char **argv)
{
    fun();
    return 0;
}
/*警告信息
note: declared here
    6 | [[nodiscard]] int fun()
*/
```

## enumeration 与 enumerator

C++98/03 enumeration  
C++11 enumerator

```cpp
#include <iostream>
#include <string>
#include <initializer_list>
using namespace std;

// 不限定作用域的枚举，外部可以访问
enum
{
    RED,
    BLACK,
    BLUE
};
enum
{
    ORANGE,
    DARK
};
enum Type
{
    TEACHER,
    STUDENT
};
// c++11 enumberator
enum class Person
{
    men = 0,
    women
};

int main(int argc, char **argv)
{
    int n1 = RED;
    cout << n1 << endl;     // 0
    cout << ORANGE << endl; // 0
    n1 = TEACHER;
    // n1 = Person::men;//错误
    // cout << Person::men << endl;//错误
    Person person = Person::men; // 正确
    // Person person1 = 0;          // 错误
    // cout << person << endl;//错误
    cout << (person == Person::men) << endl; // 1
    int men = 0;                             // 合法作用域，不与枚举冲突
    return 0;
}
```

## final、override、default、delete

1、final

final 关键字修饰一个类，不允许被继承

```cpp
class A final{

};
class B:public A;//error
```

2、override

在父类中加了 virtual 关键字的方法可以被子类重写，子类重写该方法时可以加或者不加 virtual，默认为 virtual 的

可能存在两种问题

- 无论子类重写的方法是否添加了 virtual 关键字，都无法直观地确定该方法是否是重写的父类方法
- 如果在子类中写错了需要重写的方法的函数签名（参数类型、个数、返回值），那么方法变成了独立方法，违背初衷，编译时并不会检测到错误

```cpp
#include <iostream>
using namespace std;

// 抽象类型A
class A
{
public:
    virtual void run(int n) = 0;
    virtual void fun(double n);
};

void A::fun(double n)
{
}

// 必须实现void run(int n) 不然B也是抽象类
class B : public A
{
public:
    void run(int n) {}
    // void fun(float n) // 其实没有成功重写void func(double n),编译不会报错
    // {
    // }
    void fun(float n) override // 会报错
    {
    }
};

int main(int argc, char **argv)
{
    B b;
    return 0;
}
```

3、=default

如果一个 C++类没有显式给出构造函数、析构函数、拷贝构造函数、operator=这几个类函数的实现，则在需要时编译器会自动生成。但是在给出这些函数的声明时却没有给实现，则会在编译器链接时报错，如果用了=default 标记编译器会给出默认实现

```cpp
class Person{
public:
    Person(int n);
    Person()=default;
};
//只在cpp实现Person(int n) 即可
```

4、delete

禁止编译器生成构造函数、析构函数、拷贝构造函数、operator=

```cpp
#include <iostream>
using namespace std;

class Person
{
public:
    Person() = default;
    ~Person() = default;
    Person &operator=(const Person &o) = delete;
    Person(const Person &p) = delete;
};

int main(int argc, char **argv)
{
    Person person1;
    // Person person2 = person1; // 错误
    Person person3;
    // person1 = person3;//错误
    return 0;
}
```

其实还有些骚操作,对于函数的重载而言

```cpp
#include <iostream>
using namespace std;

void func(double f)
{
}
void func(float f) = delete;
void func(int f) = delete;

int main(int argc, char **argv)
{
    func(21.0);  // 正确
    func(12.3f); // 报错
    func(12);    // 报错
    return 0;
}
```

## auto关键字

用于编译时自动推导数据类型

```cpp
#include<iostream>
#include<string>
#include<vector>
using namespace std;

int main(int argc, char** argv) {
	auto str = "nvdfkv";//const char*
	auto n1 = 12.0;//double
	auto n2 = 12;//int
	auto n3 = 13.3f;//float
	auto str1 = string("dfvd");//string
	vector<int> nums{ 1,2,3,4,5 };
	for (auto iter = nums.begin(); iter != nums.end(); ++iter) {
		cout << *iter << endl;
	}//iter=>std::vector<int>::iterator
	return 0;
}
```

## Range-based循环语法

for-each语法遍历一个数组或集合中的元素

```cpp
#include<iostream>
#include<string>
#include<vector>
using namespace std;

int main(int argc, char** argv) {
	vector<int> nums{ 1,2,3,4,5 };
	for (int n : nums) {//发生拷贝构造
		cout << n << endl;
	}
	for (const int& n : nums) {
		cout << n << endl;//引用
	}
	for (const auto& n : nums) {//const int&
		cout << n << endl;
	}
	return 0;
}
```

## 自定义对象如何支持Range-based

被迭代器的数据结构应该有begin与end方法，二者都返回迭代子，迭代子必须支持operator++、operator!=、operator*

```cpp
#include<iostream>
#include<initializer_list>
using namespace std;

template<typename T,size_t N>
class A {
public:
	A(const initializer_list<T>&list) {
		size_t i = 0;
		for (auto& v : list) {
			m_elements[i++] = v;
		}
	}
	~A() {}
	T* begin() {
		return m_elements;
	}
	T* end() {
		return m_elements + N;
	}
private:
	T m_elements[N];
};

int main(int argc, char** argv) {
	A<int, 10> a{1,2,3,4,5,6,7,8,9,10};
	for (const int& n : a) {
		cout << n << endl;//1 2 3 4 5 6 7 8 9 10
	}
	return 0;
}
```

## C++17结构化绑定

C++17 中引入了结构化绑定（Structured Bindings）的语法，允许我们将一个结构体或者 tuple 类型的对象解构为多个变量。结构化绑定语法的一般形式如下：

```cpp
auto [var1, var2, ...] = expression;
auto [var1, var2, ...] { expression };
auto [var1, var2, ...] ( expression );
```

样例

```cpp
#include<iostream>
#include<map>
#include<string>
#include<tuple>
using namespace std;

struct Point {
	int x;
	string y;
};

int main(int argc, char** argv) {
	//结构体
	Point point;
	point.x = 100;
	point.y = "cpp17";
	auto [x,y] = point;// int x,int y
	cout << x << " " << y << endl;//100 cpp17
	auto& [x_ref, y_ref] = point;
	y_ref = "point";
	cout << point.y << endl;//point
	//tupe
	tuple<int, double>mTupe{ 1,6.66 };
	auto [width, height] = mTupe;
	cout << width <<" "<< height << endl;//1 6.66
	auto& [width_ref, height_ref] = mTupe;//支持const auto&等
	width_ref = 666;
	cout << get<0>(mTupe) << endl;//6666
	//map
	map<string, int>mMap = { {"key1",1},{"key2",2}};
	for (auto& [key, value] : mMap) {//const std::string&key,int&value
		cout << key <<" "<< value << endl;//key1 1 key2 2
	}
	return 0;
}
```

结构化绑定限制

```cpp
auto [first,second]=std::pair<int,int>(1,2);//正常
constexpr auto [first,second]=std::pair<int,int>(1,2);//无法编译
static auto [first,second]=std::pair<int,int>(1,2);//无法编译
```

## stl容器新增使用方法

### 原位构造器与容器的emplace系列函数

有一点要注意的是，使用emplace系列函数，首先会创建对象t（调用一次构造函数），利用对象t拷贝构造函数构造出一个新对象放入集合中，t对象调用析构函数销毁

```cpp
#include<iostream>
#include<map>
#include<string>
#include<list>
using namespace std;

struct Point {
	int x;
	string y;
	Point(const int& x, const string& y) {
		this->x = x;
		this->y = y;
	}
};

int main(int argc, char** argv) {
	list<Point>points;
	points.emplace_back(1, "1");//后插 push_back
	points.emplace_front(2, "2");//前插 push_front
	points.emplace(points.begin(), 3, "3");//原位 push/insert
	for (auto& v : points) {
		cout << v.x << " " << v.y << endl;
	}
	//3 3 2 2 1 1
	return 0;
}
```

### map中的try_emplace与insert_or_assign

try_emplace：键已存在则不添加，不存在则构造添加  
insert_or_assign：键存在则更新，键不存在则添加

```cpp
#include<iostream>
#include<map>
#include<string>
using namespace std;

int main(int argc, char** argv) {
	map <string, int> mMap;
	auto res1=mMap.try_emplace("1",10 );//std::pair<iterator,bool> res1
	if (res1.second) {//添加成功
		cout << res1.first->first <<" "<< res1.first->second<< endl;//1 10
	}
	auto res2=mMap.insert_or_assign("1",11);
	cout << boolalpha<< res2.second << endl;//false,则为赋值成功
	return 0;
}
```

## 智能指针

### auto_ptr

auto_ptr 是 C++98 标准引入的一种智能指针，用于管理动态分配的对象。auto_ptr 对象的特点是在构造时接管一个指针，并在析构时自动释放指针所指向的对象，因此可以避免内存泄漏的问题。

然而，auto_ptr 在使用时存在一些问题，比如它不能正确处理数组对象（只能处理单个对象）、不能传递所有权等。为了解决这些问题，C++11 标准引入了新的智能指针类 unique_ptr 和 shared_ptr，它们分别提供了独占所有权和共享所有权的语义，能够更好地管理动态分配的对象。

由于 auto_ptr 存在的问题以及新智能指针类的引入，C++11 标准已经将 auto_ptr 标记为废弃的，建议使用 unique_ptr 或者 shared_ptr 来替代它。在 C++17 中，auto_ptr 已经被彻底移除，不能再使用了。

### shared_ptr

详细的还是去看C++部分吧

```cpp
#include<iostream>
#include<memory>
#include<string>
using namespace std;

int main(int argc, char** argv) {
	shared_ptr<int> ptr1 = make_shared<int>(1);
	auto ptr2 = ptr1;
	cout << ptr2.use_count() << endl;//2
	ptr2.reset();
	cout << ptr1.use_count() << endl;//1
	int *realPtr=ptr1.get();
	cout << ptr1.use_count() << endl;//1
	return 0;
}
```

### unique_ptr

详细的还是去看C++部分吧

```cpp
#include<iostream>
#include<memory>
#include<string>
using namespace std;

int main(int argc, char** argv) {
	unique_ptr<int> ptr;
	int* n = new int{};
	ptr.reset(n);
	int*real_ptr=ptr.get();
	ptr.release();//取消接管n，但不释放内存，reset即取消接管也释放内存
	//禁止赋值构造与拷贝构造
	//unique_ptr<int>ptr1 = ptr;
	//unique_ptr<int>ptr2(ptr);
	*n = 1000;
	cout << *n << endl;//1000
	delete n;
	return 0;
}
```

### weak_ptr

详细的还是去看C++部分吧，在shared_ptr的使用中可能会出现循环引用的情况，造成内存泄露

```cpp
#include<iostream>
#include<memory>
#include<string>
using namespace std;

class A;

class B {
public:
	shared_ptr<A> sharedA2;
	~B() {
		cout << "B free" << endl;
	}
};

class A {
public:
	shared_ptr<B> sharedB2;
	~A() {
		cout << "A free" << endl;
	}
};

int main(int argc, char** argv) {
	shared_ptr<A> sharedA1 = make_shared<A>();
	shared_ptr<B> sharedB1 = make_shared<B>();
	sharedA1->sharedB2 = sharedB1;
	sharedB1->sharedA2 = sharedA1;
	//会看见完蛋了，两个析构函数都没有执行，如果A，B构造函数内申请了动态内存
	//可能造成内存泄露
	cout << sharedA1.use_count() << endl;//2
	cout << sharedB1.use_count() << endl;//2
	//当sharedA1 sharedB1变量栈内存时，二者引用变为1
	//A B类的对象为动态内存，并不会得到释放
	return 0;
}
```

可以使用weak_ptr,其并不会增加引用数量,可以将上面class A、classB中成员任意一个改为weak_ptr就可解决

```cpp
#include<iostream>
#include<memory>
#include<string>
using namespace std;

int main(int argc, char** argv) {
	shared_ptr<int> ptr1 = make_shared<int>(999);
	weak_ptr<int> ptr2;
	{
		ptr2 = ptr1;
		cout << ptr1.use_count() << endl;//1
		shared_ptr<int>ptr3 = ptr1;
		cout << ptr2.use_count() << endl;//2
	}
	cout << ptr2.lock() << endl;//00000249452F45D0 alive
	ptr1.reset();
	cout << ptr2.lock() << endl;//0000000000000000 dead
	return 0;
}
```

修正循环引用

```cpp
#include<iostream>
#include<memory>
#include<string>
using namespace std;

class A;

class B {
public:
	weak_ptr<A> sharedA2;
	~B() {
		cout << "B free" << endl;
	}
};

class A {
public:
	weak_ptr<B> sharedB2;
	~A() {
		cout << "A free" << endl;
	}
};

int main(int argc, char** argv) {
	shared_ptr<A> sharedA1 = make_shared<A>();
	shared_ptr<B> sharedB1 = make_shared<B>();
	sharedA1->sharedB2 = sharedB1;
	sharedB1->sharedA2 = sharedA1;
	//B free
	//A free
	return 0;
}
```

### enable_shared_from_this

enable_shared_from_this提供了需要在类中的返回包裹当前对象this的一个共享指针对象给外部使用

```cpp
#include<iostream>
#include<memory>
#include<string>
using namespace std;

class A:public enable_shared_from_this<A> {
public:
	A() {
		cout << "A build" << endl;
	}
	~A() {
		cout << "A free" << endl;
	}
	shared_ptr<A> getSelf(){
		return shared_from_this();
		//return shared_ptr<A>(this);//错误
	}
};

int main(int argc, char** argv) {
	shared_ptr<A> ptr1 = make_shared<A>();//A build
	shared_ptr<A> ptr2 = ptr1;
	shared_ptr<A> ptr3 = ptr1->getSelf();
	cout << ptr1.use_count() << " " << ptr2.use_count() <<" "<< ptr3.use_count() << endl;
	//3 3 3
	return 0;
	//A free
}
```

不要这样使用，栈内存对象，调用getSelf()

```cpp
int main(int argc, char** argv) {
	A a;
	auto ptr = a.getSelf();
	return 0;//错误
}
```

不要这样使用，可能存在循环引用的情况

```cpp
#include<iostream>
#include<memory>
#include<string>
using namespace std;

class A:public enable_shared_from_this<A> {
public:
	A() {
		cout << "A build" << endl;
	}
	~A() {
		cout << "A free" << endl;
	}
	void fun(){
		ptr=shared_from_this();
	}
private:
	shared_ptr<A> ptr;
};

int main(int argc, char** argv) {
	//情况1
	//A a;
	//a.fun();//shared_ptr会尝试释放栈内存
	//情况2
	auto ptr = make_shared<A>();
	ptr->fun();//A build,不会析构，循环引用造成内存泄露
	return 0;//错误
}
```

### 智能指针大小

一个unique_ptr的大小与裸指针的大小相同，shared_ptr的大小是unique_ptr的两倍

```cpp
#include<iostream>
#include<memory>
#include<string>
using namespace std;

int main(int argc, char** argv) {
	shared_ptr<int>ptr1;
	shared_ptr<string>ptr2;
	ptr2.reset(new string());
	unique_ptr<int>ptr3;
	weak_ptr<int>ptr4;
	cout << sizeof(ptr1) << endl;//x64:16 x86:8
	cout << sizeof(ptr2) << endl;//x64:16 x86:8
	cout << sizeof(ptr3) << endl;//x64:8 x86:4
	cout << sizeof(ptr4) << endl;//x64:16 x86:8
	return 0;//错误
}
```

### 使用智能指针注意事项

好习惯：

1、一旦使用了智能指针管理一个对象，就不该再用裸指针操作它

2、知道在哪些场合使用哪种类型的智能指针

3、避免操作某个引用资源已经释放的智能指针

4、作为类成员变量，应优先使用前置声明

```cpp
//B.h
class A;//优先使用前置声明，而不是#include"A.h"
class B{
public:
    A a;
}
```

下面同理

```cpp
class A;//优先使用前置声明，而不是#include"A.h"
class B{
public:
    std::shared_ptr<A> a;
}
```