---
cover: >-
  https://images.unsplash.com/photo-1493238792000-8113da705763?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHw5fHxjYXJ8ZW58MHx8fHwxNjUyMjU0MzI0&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 🥂 第7章 类

## 第7章 类

类的基本思想是数据抽象和封装，数据抽象是一种依赖于接口和实现分离的编程技术。封装实现了类的接口和实现额分离，封装后的类隐藏了它的实现细节。\
类要想实现数据抽象和封装，需要首先定义一个抽象数据类型。

### 定义抽象数据类型

### 结构体

C语言中没有类的概念，但是有struct结构体供我们定义抽象的数据类型，但是本身不支持封装、以及类方法。

```cpp
#include <iostream>
#include <cstring>
using namespace std;
struct Person
{
    char name[512];
    unsigned age;
};

int main(int argc, char **argv)
{
    Person person;
    cout << sizeof(person) << endl; // 512+4=516
    const char *name = "gaowanlu";
    strcpy(person.name, name);
    person.age = 19;
    cout << person.name << endl; // gaowanlu
    cout << person.age << endl;  // 19
    return 0;
}
```

如果结构体大小是定长时，结构体的实例内部内存是连续的，那么则会有许多的用途，比如串口协议等。

```cpp
//example2.cpp
#include <iostream>
#include <cstring>
using namespace std;
struct Person
{
    char name[512];
    unsigned age;
};
int main(int argc, char **argv)
{
    Person person;
    person.age = 999;
    char *store = new char[sizeof(person)];
    memcpy(store, &person, sizeof(person));
    Person *ptr = (Person *)store;
    cout << ptr->age << endl; // 999
    delete store;
    //有点像对象的序列化是吧，在理想情况下可以通过传输介质传输内存中的二进制数据，进而达成一定的用户协议
    return 0;
}
```

### 方法、this

```cpp
//example3.cpp
#include <iostream>
#include <string>
using namespace std;
struct Person
{
    string name;
    unsigned age;
    //定义在类内部的函数为隐式的inline函数
    void print() const
    {
        // this是一个常量指针，不允许我们改变this中保存的地址，this永远指向对象实例本身
        std::cout << "name " << name << " age " << this->age << endl;
    }
    int getAge(); //在类的内部声明
};

//外部定义类的方法
int Person::getAge()
{
    return this->age;
}

int main(int argc, char **argv)
{
    Person person; //定义Person类的对象实例
    person.age = 19;
    person.name = "gaowanlu";
    person.print();                  // name gaowanlu age 19
    cout << person.getAge() << endl; // 19
    return 0;
}
```

this的数据类型就是,Person\*,他是一个相应类数据类型的常量指针

### const成员函数

我们发现刚刚的成员函数的代码块前怎么加了const呢，有什么作用呢？

这里的const的作用是修改隐式this指针的类型，

简单点说就是当对象是const的时候，只能调用对象的const成员函数，如果成员函数为const成员函数，但是在函数内修改非mutable成员，则会编译不通过

```cpp
//example4.cpp
#include <iostream>
using namespace std;
struct Person
{
    int age;
    void setAge(int age) const
    {
        // 即const Person *this
        // this->print();//不能通过常量的指针调用函数
        // this->age = age;//不能修改对象的属性
    }
    void print()
    {
        cout << "person" << endl;
    }
};
int main(int argc, char **argv)
{
    const Person person;
    const Person *ptr = &person;
    // ptr->print(); //同理类似const Person*this 不允许调用方法
    // ptr->age = 23;//不允许修改属性
    return 0;
}
```

### 类作用域和成员函数

类本身就是一个作用域，编译器先编译成员的声明、然后到成员函数体，所以成员函数体可以随意使用类中的其他成员而无需在意它们出现的次序。

### 在类的外部定义成员函数

```cpp
//example5.cpp
#include <iostream>
using namespace std;
struct Person
{
    int age;
    void print() const;
};

void Person::print() const
{
    cout << this->age << endl;
}

int main(int argc, char **argv)
{
    Person person;
    person.age = 666;
    person.print(); // 666
    return 0;
}
```

### 返回this的函数

对于类的方法，也可以返回其对象本身的this

```cpp
//example6.cpp
#include <iostream>
using namespace std;
struct Person
{
    int age;
    Person *add()
    {
        ++(*this).age;//this的解引用
        return this;
    }
};

int main(int argc, char **argv)
{
    Person person;
    person.age = 1;
    person.add()->add()->add(); //链式调用
    cout << person.age << endl; // 4
    return 0;
}
```

### 定义类相关的非成员函数

即定义普通函数，但其使用类对象做形参或者做返回值

```cpp
//example7.cpp
#include <iostream>
using namespace std;
struct Person
{
    int age;
};

//按值传递
Person add(Person person)
{
    person.age++;
    return person;
}

//按引用传递
Person &sub(Person &person)
{
    person.age--;
    return person;
}

int main(int argc, char **argv)
{
    Person person;
    person.age = 0;
    Person person1 = add(person);
    cout << person.age << " " << person1.age << endl; // 0 1
    sub(person1);
    cout << person1.age << endl; // 0
    return 0;
}
```

### 构造函数

构造函数在创建类的对象实例时被执行\
当我们没有定义构造函数时，会使用默认的构造函数，默认构造函数无需参数，也就是说只有当类没有声明任何构造函数时，编译器才会自动地生成默认构造函数

```cpp
//example8.cpp
#include <iostream>
using namespace std;

struct Person
{
    int age;
    Person() = default; //保留默认构造函数
    Person(int age)//在类内部定义地函数是隐式的inline函数
    {
        this->age = age;
    }
};

int main(int argc, char **argv)
{
    Person person1; //使用默认构造函数
    Person person2(19);
    cout << person2.age << endl; // 19
    return 0;
}
```

### 构造函数初始化列表

首先传入实参到构造函数、执行属性初始化列表，然后再执行构造函数体

```cpp
//example9.cpp
#include <iostream>
#include <string>
using namespace std;

struct Person {
    string name;
    int age;
    Person() = default;
    Person(string name);//定义处不用写初始化列表
    //因为声明是给别人看的
};

//初始化列表与定义有关，而不用给别人声明
//通常将初始化列表写在定义,写在声明处会编译出错
Person::Person(string name) : name(name), age(20)
{
    cout << this->name << " " << this->age << endl;
}

int main(int argc, char** argv)
{
    Person person("gaowanlu");  // gaowanlu 20
    cout << person.age << endl; // 20
    return 0;
}
```

### 在类的外部定义构造函数

与普通的成员函数的操作没什么区别

```cpp
//example10.cpp
#include <iostream>
#include <string>
using namespace std;
struct Person
{
    string name;
    int age;
    Person();
    //初始化属性列表
    Person(string name);
};

Person::Person() = default;

Person::Person(string name) : name(name),
                              age(20)
{
    cout << this->name << " " << this->age << endl;
}

int main(int argc, char **argv)
{
    Person person("gaowanlu");  // gaowanlu 20
    cout << person.age << endl; // 20
    return 0;
}
```

### 拷贝、赋值和析构

除了构造阶段，类还需要其他的控制如拷贝、赋值、销毁对象时的行为，在后面的还有详细的相关学习

```cpp
//example11.cpp
#include <iostream>
#include <cstring>
using namespace std;

struct String
{
    char *ptr;
    String()
    {
        this->ptr = new char[512];
    }
    void set(const char *str)
    {
        strcpy(ptr, str);
    }
    ~String()
    {
        if (this->ptr)
        {
            cout << "delete String ptr memory\n";
            delete this->ptr; //释放内存
        }
    }
};

void func()
{
    String str;//当栈内存被释放时 析构函数同样会被触发
}

int main(int argc, char **argv)
{
    String *str = new String();
    str->set("hello");
    cout << str->ptr << endl; // hello
    delete str;               // delete String ptr memory
    func();                   // delete String ptr memory
    return 0;
}

```



### 访问控制与封装

目前位置，我们并没有方法禁止某些情况不能访问到类内部的某些方法或者属性。C++语言中，我们使用访问说明符加强类的封装性。

* private 的成员可以被类内的成员函数访问，但是不能被使用该类的代码访问到，private实现了隐藏细节暴露接口即封装的一部分
* public 的成员在整个程序内可被访问，public成员定义类的接口

```cpp
//example12.cpp
#include <iostream>
using namespace std;
struct Person
{
private:
    int age;

public:
    Person() = default;
    Person(int age)
    {
        this->age = age;
    }
    int getAge()
    {
        return this->age;
    }
    void setAge(int age)
    {
        this->age = age;
    }
};

int main(int argc, char **argv)
{
    Person person(19);
    person.setAge(20);
    cout << person.getAge() << endl; // 20
    // person.age;//error 访问不到
    return 0;
}
```

### class与struct关键字

我们一直在使用struct也就是结构体，但是我们将其称为类，有点奇怪，其实C++支持关键词struct,而支持struct是因为要兼容C代码

二者的区别是，如果没有声明private或者public，class默认为private而struct默认为public

```cpp
//example13.cpp
#include <iostream>
using namespace std;
class Dog
{
    int age;

public:
    void setAge(int age)
    {
        this->age = age;
    }
    int getAge()
    {
        return this->age;
    }
};
struct Cat
{
    int age;
};
int main(int argc, char **argv)
{
    Dog dog;
    Cat cat;
    // dog.age;//访问不到
    cat.age = 1;
    dog.setAge(1);
    cout << cat.age << endl;      // 1
    cout << dog.getAge() << endl; // 1
    return 0;
}
```

### 友员

有些函数并不是类的成员方法，但是我们仍然想要允许它访问类的私有成员，这种情况我们可以将这个函数定义为类的友元函数。

```cpp
//example14.cpp
#include <iostream>
using namespace std;
class Dog
{
    int age;
    friend void printDog(Dog &dog);

public:
    auto setAge(int age) -> void
    {
        this->age = age;
    }
    auto getAge() -> int
    {
        return this->age;
    }
};

void printDog(Dog &dog)
{
    cout << dog.age << endl; //可以访问私有成员
}
int main(int argc, char **argv)
{
    Dog dog;
    dog.setAge(1);
    // dog.age;
    printDog(dog); // 1
    return 0;
}
```

一般来说、最好在类定义开始或结束前的位置集中声明友元。

### 封装的益处

* 确保用户代码不会无意间破坏封装对象的状态
* 被封装的类具体实现细节可以随时改变，指向外部提供public的接口，而无须调整接口代码



### 类的其他特性

### 类内的typedef与using

在类的内部可以使用typedef与using以至于只在类内有效，对外不隐藏细节

* private别名不能做public方法的参数与返回值
* 可以在public方法内使用private别名
* 同理不能定义private别名的public属性
* 而private则没有限制可以使用public与private别名

```cpp
//example15.cpp
#include <iostream>
#include <string>
#include <vector>
using namespace std;
class Person
{
public:
    typedef std::string String;
    using StrSize = std::string::size_type;
    void setName(String name)
    {
        this->name = name;
        this->name_size = name.size();
    }
    StrSize name_size;
    // mList list();//error mList is private
    // void printList(mList list);//error

private:
    using mList = std::vector<int>;
    String name;
    mList list;
};
int main(int argc, char **argv)
{
    Person person;
    person.setName("gaowanlu");
    cout << person.name_size << endl; // 8
    // String str = "";//error: 'String' was not declared in this scope
    Person::String str = "name";
    cout << str << endl;
    return 0;
}
```

### 内联方法

共有三种情况

* 隐式内联
* 显式内联
* 声明不指定内联、定义时指定为内联

```cpp
//example16.cpp
#include <iostream>
#include <string>
using namespace std;
class Person
{
public:
    Person(int age, string name) : age(age), name(name)
    {
    }
    string getName() const //隐式内联
    {
        return this->name;
    }
    inline int getAge() //显式内联
    {
        return this->age;
    }
    void setAge(int age); //可在定义出指定内联

private:
    int age;
    string name;
};

//定义时指定为内联
inline void Person::setAge(int age)
{
    this->age = age;
}

int main(int argc, char **argv)
{
    Person person(18, "gaowanlu");
    cout << person.getName() << endl; // gaowanlu
    cout << person.getAge() << endl;  // 18
    person.setAge(19);
    cout << person.getAge() << endl; // 19
    return 0;
}
```

虽然不需要在声明和定义处同时说明inline，但是那样是合法的，不过最好只在类的外部定义的地方说明inline,这样使得其更加容易理解。

### 方法重载

和函数的从在一样，类的方法也可以进行重载\
其概念与函数的重载基本相同，如参数与类型的区别、匹配过程等

```cpp
//example17.cpp
#include <iostream>
#include <string>
using namespace std;

class Person
{
private:
    int age;
    string name;

public:
    void set(int age, string name);
    void set(string name, int age);
    int getAge()
    {
        return this->age;
    }
    string getName()
    {
        return this->name;
    }
    void print()
    {
        cout << "age " << age << " name " << name << endl;
    }
};

void Person::set(int age, string name)
{
    this->age = age;
    this->name = name;
}

void Person::set(string name, int age)
{
    this->set(age, name);
}

int main(int argc, char **argv)
{
    Person person;
    person.set(string("gaowanlu"), 18);
    person.print(); // age 18 name gaowanlu
    person.set(19, string("gaowanlu"));
    person.print(); // age 19 name gaowanlu
    return 0;
}
```

### 可变数据成员mutable

对于结构体而言，如果一个结构体变量为const，则它的属性也是不可变的

```cpp
//example18.cpp
#include <iostream>
#include <string>
using namespace std;
struct Person
{
    int age;
    string name;
};
int main(int argc, char **argv)
{
    Person person;
    person.age = 19; // mutable
    const Person he;
    // he.age = 19; // error: assignment of member 'Person::age' in read-only object
    return 0;
}
```

但是有些情况下，即使结构体变量是const的，但是我们想允许更改其某些内部属性、则使用mutable\
要注意的是cosnt对象实例不能访问非const方法

```cpp
//example19.cpp
#include <iostream>
#include <string>
using namespace std;
class Person
{
private:
    mutable int age; // mutable属性必须被初始化

public:
    // mutable int age;
    Person() = default;
    Person(int age) : age(age) {}
    string name;
    void setAge(int _age) const; // const成员函数也可以改变mutable成员值
    int getAge() const
    {
        return this->age;
    }
    int addAge() const
    {
        this->age++;
        return this->age;
    }
};

void Person::setAge(int _age) const
{
    age = _age;
}

int main(int argc, char **argv)
{
    Person person;
    person.setAge(19);
    const Person she(19); // const实例不允许访问非const方法
    // mutable
    she.setAge(19);
    cout << person.getAge() << " " << she.getAge() << endl;
    cout << she.addAge() << endl; // 20
    return 0;
}
```

### 类数据成员的初始值

C++11可以直接在类内设置初始值

```cpp
//example20.cpp
#include <iostream>
#include <vector>
#include <string>
using namespace std;
class Person
{
public:
    int age = 19;
    string name = "gaowanlu";
    vector<string> parents = {"father", "mother"};
};

int main(int argc, char **argv)
{
    Person person;
    cout << person.name << endl; // gaownalu
    return 0;
}
```

### 返回\*this的成员函数

关于this的返回，常用的有返回\*this，this

```cpp
//example21.cpp
#include <iostream>
#include <string>
using namespace std;
class Person
{
public:
    int age;
    Person copy()
    {
        return *this;
    }
    Person &self()
    {
        return *this;
    }
    Person *ptr()
    {
        return this;
    }
};

int main(int argc, char **argv)
{
    Person person;
    person.age = 19;
    Person person1 = person.copy();
    person1.age = 18;
    cout << person.age << " " << person1.age << endl; // 19 18
    Person &person_ = person.self();
    person_.age = 18;
    cout << person.age << endl; // 18
    Person *ptr = person.ptr();
    if (ptr == &person_)
    {
        cout << "get ptr success" << endl; // get ptr success
    }
}
```

### 从const成员函数返回\*this

从const成员函数返回\*this,则返回的新对象是const的

```cpp
//example22.cpp
#include <iostream>
using namespace std;
class Person
{
public:
    mutable int age = 0;
    Person getConstCopy() const
    {
        return *this;
    }
    const Person &getConstSelf() const
    {
        return *this;
    }
};
int main(int argc, char **argv)
{
    Person person;
    person.age = 19;
    Person person1 = person.getConstCopy(); //相当于一个const的对象赋值给person1

    const Person person2; // const对象 其内部的属性必须全部被初始化
    Person person3 = person2.getConstCopy();
    cout << person3.age << endl; // 0
    person3.age = 19;

    const Person &self = person2.getConstSelf();
    self.age = 18;
    cout << person2.age << endl; // 18

    // Person &person4 = person1.getConstSelf();
    // binding reference of type 'Person&' to 'const Person' discards qualifiers
    return 0;
}
```

### 基于const的重载

当对象是const时使用const方法、非const对象使用非const方法

```cpp
//example23.cpp
#include <iostream>
#include <string>
using namespace std;
class Person
{
public:
    Person(int age) : age(age) {}
    const Person &print() const
    {
        cout << age << " const Person &print() const" << endl;
        return *this;
    }
    Person &print()
    {
        cout << age << " Person &print()" << endl;
        return *this;
    }

private:
    int age;
};
int main(int argc, char **argv)
{
    Person person1(1);
    person1.print();         // 1 Person &print()
    person1.print().print(); // 1 Person &print() 1 Person &print()
    const Person person2 = person1;
    person2.print();         // 1 const Person &print() const
    person2.print().print(); // 1 const Person &print() const 1 const Person &print() const
    return 0;
}
```

### 类类型

不同的类对象之间是不能直接相互赋值的，因为就像一个自行车要赋值给汽车类型

### 类声明

类的声明同理向，函数一样可以进行前向声明，然再声明的后面定义类

```cpp
class Person;
int main(int argc,char**argv){
    Person person;
    return 0;
}
class Person{
public:
    int age;
}
```

### 类之间的友元关系

```cpp
//example24.cpp
#include <iostream>
using namespace std;
class Person
{
    friend class Room;

private:
    int age;
    void setAge(int age)
    {
        this->age = age;
    }

public:
    Person(int age) : age(age) {}
    Person() = default;
};

class Room //在Room内的方法可以访问Person的私有内容
{
public:
    Person person;
    int getHostAge()
    {
        person.setAge(19);
        return person.age;
    }
};

int main(int argc, char **argv)
{
    Room room;
    cout << room.getHostAge() << endl; // 19
    return 0;
}
```

### 其他类的函数成员作友元

有时不需要指定某个类全部方法可以访问、支持我们为某个类的特定的方法设置友元关系\
这个功能有些鸡肋，一下面的例子不允许在Room内定义Person类型的属性，因为无定义因为

* 首先定义Room类，其中声明getHostAge函数，但不能定义它，在getHostAge使用Room成员之前必须先声明Person
* 定义Person,包括getHostAge友元声明
* 最后定义getHostAge，此时才可以使用Person的成员

```cpp
//example25.cpp
#include <iostream>
using namespace std;

class Person;

class Room
{
public:
    int getHostAge(Person &person); //在Room内的此方法可以访问Person的私有内容
};

class Person
{
    friend int Room::getHostAge(Person &person);

private:
    int age;
    void setAge(int age)
    {
        this->age = age;
    }

public:
    Person(int age) : age(age) {}
    Person() = default;
};

int Room::getHostAge(Person &person)
{
    person.setAge(19);
    return person.age;
}

int main(int argc, char **argv)
{
    Room room;
    Person person;
    cout << room.getHostAge(person) << endl; // 19
    return 0;
}
```

太鸡肋了，尽量不要用、但要知道有这么回事

### 函数重载与友元

如上面的例子

```cpp
friend int Room::getHostAge(Person &person);
//只是对 int Room::getHostAge(Person &person); 声明了友元
//如果想要将getHostAge的其他重载形式也作为友元则需要为每条重载声明友元
```

### 友元声明和作用域

在声明友元时，并不需要其函数在friend之前声明，但是在此函数被使用之前必须被声明。

```cpp
//example26.cpp
#include <iostream>
using namespace std;

class Person
{
    friend int func(Person &ptr);

public:
    Person()
    {
        // func(*this); 在此之前func()没有被声明，因此不能使用
    }
    void a();
    void b();

private:
    int age;
};

void Person::a()
{
    // func(*this);  在此之前func()没有被声明，因此不能使用
}

int func(Person &ptr);

void Person::b()
{
    func(*this); //在此之前已经声明了func
}

int func(Person &ptr)
{
    ptr.age = 11;
    return ptr.age;
}

int main(int argc, char **argv)
{
    Person person;
    person.b();                   //由person.b 内掉用 func 操纵age
    cout << func(person) << endl; // 11
    return 0;
}
```



### 类的作用域

一个类就是一个作用域，每个类都会定义它自己的作用域，在类的作用域之外，普通的数据和函数成员只能由对象、引用、指针使用成员访问运算符来访问，对于类类型成员则使用作用域运算符。

```cpp
//example27.cpp
#include <iostream>
using namespace std;
class Person
{
private:
    int age;

public:
    struct Info
    {
        int age;
        void print()
        {
            cout << "Info:: age=" << age << endl;
        }
    };

    Person(int age) : age(age) {}
    Person() = default;
    Info setAddAge(int num);
    int getAge();
};

Person::Info Person::setAddAge(int num)
{
    this->age += num;
    Info info;
    info.age = num;
    return info;
}

int main(int argc, char **argv)
{
    Person person(18);
    Person::Info info = person.setAddAge(1);
    info.print(); // Info:: age=1
    return 0;
}
```

### 名字查找与类的作用域

目前我们写的程序，名字查找的规则为

* 首先，在名字所在的块中寻找其声明语句，只考虑在名字的使用之前出现的声明
* 如果没找到，继续查找外层作用域
* 如果最终没有找到匹配的声明，则程序报错

对于类内部的成员函数而言，解析其中名字的方式与上面有不同之处

* 首先先编译成员的声明
* 知道类全部可见后才编译函数体

也就出现我们可以在任何方法内使用类的任何属性，不管声明的顺序，因为先编译成员声明，后编译函数体

```cpp
//example28.cpp
#include <iostream>
using namespace std;
int age = 666;
class Person
{
private:
    int age;

public:
    Person(int age) : age(age) //这里会现在Person块作用域内找变量声明age
    {
    }
    void setAge(int age);
    int getAge();
};

void Person::setAge(int age)
{
    this->age = age;
}

int Person::getAge()
{
    return age; //现在Person class块作用域内找age声明
}

int main(int argc, char **argv)
{
    Person person(19);
    cout << person.getAge() << endl; // 19
    cout << age << endl;             // 666
    return 0;
}
```

### 不能重复typedef与using

如果在类的外部已经进行了typedef某个类型别名，则不能在类的内部重复typedef某个名称

```cpp
//example29.cpp
#include <iostream>
using namespace std;
typedef int Age;
class Person
{
public:
    Person(Age age) : age(age) {}
    int getAge()
    {
        return age;
    }

private:
    // typedef int Age;//Perosn使用了外部的Age,则不能在此作用域重新重复typedef
    Age age;
};
//因为Person内已经使用了外层作用域的Age,则不能在类中重新定义该名字
//但有些编译器仍然允许顺利编译
int main(int argc, char **argv)
{
    Person person(19);
    cout << person.getAge() << endl; // 19
    return 0;
}
```

### 成员定义中的普通块作用域

* 首先在成员函数内查找该名字的声明，只有在函数使用之前出现的声明才被考虑
* 如果在成员函数内没有找到，则在类内继续查找。这时的类的所有成员都可以被考虑
* 如果类内也没找到该名字的声明，在成员函数定义之前的作用域内继续查找

```cpp
//example30.cpp
#include <iostream>
using namespace std;
void print();
class Person
{
private:
    void print();

public:
    void excute(bool flag);
};

void Person::excute(bool flag)
{
    if (flag)
    {
        print();
        //现在if内找
        //再在excute内找
        //再在Person内找 找到了
        //执行Person::print
    }
}

void Person::print()
{
    cout << "Person::print" << endl;
}

void print()
{
    cout << "hello world" << endl;
}
int main(int argc, char **argv)
{
    Person person;
    person.excute(true); // Person::print
    return 0;
}
```

> 但是在实际编码中，我们想要调用对象的内部成员，尽量使用this关键词访问，那样我们直接明了的看出是调用内部成员

### 构造函数再探

如果没在构造函数的初始值列表中显式地初始化成员，则成员将在构造函数体之前执行默认初始化

```cpp
//example31.cpp
#include <iostream>
#include <string>
using namespace std;
class Person
{
public:
    string name;
    Person()
    {
        cout << name << endl;
    }
};
int main(int argc, char **argv)
{
    Person person; //输出空字符串
    return 0;
}
//也就是说在执行构造函数前，属性进行了默认初始化
```

### 构造函数初始化const属性

如果class内有const属性，我们知道const变量必须被定义时初始化，否则就不能再被更改，但是对象内怎么进行初始化呢，我们不想令其为常量，我们想要传参进行初始化，就要使用构造函数初始化列表

```cpp
//example32.cpp
#include <iostream>
#include <string>
using namespace std;
class Person
{
public:
    const string name;
    Person(string name) : name(name)
    {
    }
};
int main(int argc, char **argv)
{
    Person person("gaowanlu");
    cout << person.name << endl; // gaowanlu
    return 0;
}
```

下面这种方式是错误的

```cpp
Person(string name){
    this->name=name;
}
```

因为在执行构造函数前，const string name被初始化为空字符串，进而在构造函数中已经不能改变其值了

> 如果成员属性是const、引用，或者属于某种未提供默认构造函数的类类型，我们必须通过构造函数初始列表为这些成员提供初始值

### 初始化列表初始化顺序

构造函数初始化列表只说明用于初始化成员的值，而不限定初始化的具体执顺序\
成员初始化顺序与它们在类中定义出现顺序一致

```cpp
//example33.cpp
#include <iostream>
using namespace std;
class Edge
{
public:
    int i;
    int j;
    Edge(int val) : j(val), i(j)
    {
    }
};
int main(int argc, char **argv)
{
    Edge edge(2);
    cout << edge.i << endl; //乱码
    cout << edge.j << endl; // 2
    //因为在初始化列表时先执行了i(j) 后执行 j(val)
    return 0;
}
```

> 在我们实际书写中，初始化列表的顺序与属性定义顺序一致

### 默认实参与构造函数

如果一个构造函数为所有参数都提供了默认实参，则它实际上也定义了默认的无参构造函数

```cpp
//example34.cpp
#include <iostream>
using namespace std;
class Person
{
public:
    unsigned age;
    Person(int age = 1) : age(age)
    {
    }
};
int main(int argc, char **argv)
{
    Person person;
    cout << person.age << endl; // 1
}
```

### 委托构造函数

啥是委托构造函数，是C++11的新增特性，一个委托构造函数使用它所属类的其他构造函数执行自己的初始化过程，或者说它把自己的一些职责委托给了其他构造函数，在构造函数初始化列表调用其他构造函数

```cpp
//example35.cpp
#include <iostream>
using namespace std;
class Person
{
public:
    const unsigned age;
    Person() : Person(19)
    {
        cout << "Person() : Person(19)" << endl;
    }
    Person(int age) : age(age)
    {
        cout << "Person(int age) : age(age)" << endl;
    }
};
int main(int argc, char **argv)
{
    Person person;
    // Person(int age) : age(age)
    // Person() : Person(19)
    cout << person.age << endl; // 19
    return 0;
}
```

### 默认构造函数的作用

来看一个有趣的例子

```cpp
//example36.cpp
#include <iostream>
using namespace std;
class Person
{
public:
    Person(int age, string name)
    {
    }
};
struct A
{
    Person person;
};
int main(int argc, char **argv)
{
    A a; // error A内的person不能被构造，缺少默认构造函数
    return 0;
}
```

这种问题怎么解决呢，使用默认构造函数

```cpp
//example37.cpp
#include <iostream>
using namespace std;
class Person
{
public:
    Person(int age = 19, string name = "gaowanlu")
    {
    }
};
struct A
{
    Person person;
};
int main(int argc, char **argv)
{
    A a;
    return 0;
}
```

### 使用默认构造函数

在使用默认构造函数时，不要闹笑话

```cpp
Person person();//这是使用默认构造函数吗
//这是声明了一个函数person空参数，返回Person类型数据
```

正确方式

```cpp
Person person;
```

### 转换构造函数

也就是我们可以利用构造函数指定为此类对象赋值，赋值等号右边可以为哪些类型，并且还可以在构造函数内进行一系列操作

```cpp
//example38.cpp
#include <iostream>
using namespace std;
class Person
{
private:
    int age;

public:
    Person(int age) : age(age)
    {
        cout << this->age << endl;
    }
    Person() = default;
    int getAge()
    {
        return age;
    }
};

void print(Person person)
{
    cout << person.getAge() << endl;
}

int main(int argc, char **argv)
{
    Person person = 19; // 19
    person = 18;        // 18
    person = 1.33;      // 1
    person = '1';       // 49
    print(1);           // 1
    //编译器只会自动地执行一步类型转换
    return 0;
}
```

### explicit抑制转换构造函数

有个一个参数的构造函数我们不想让他具有转换构造函数的特性，在列内函数生命或者定义的时候加上 explicit即可，explicit只能在类内使用，成员函数在类外定义是不能使用explicit

```cpp
//example39.cpp
#include <iostream>
using namespace std;
class Person
{
private:
    int age;

public:
    explicit Person(int age);
    Person() = default;
};

Person::Person(int age) : age(age)
{
    cout << this->age << endl;
}

int main(int argc, char **argv)
{
    // Person person = 19; // error 不存在从 "int" 转换到 "Person" 的适当构造函数
    Person person(19); // 19
    return 0;
}
```

explicit其实时抑制了隐式转换构造函数，我们仍然可是使用显式调用构造函数来进行转换。

```cpp
void print(Person person){
}
print(Person(1));
```

### 标准库有显式构造函数的类

标准库中有些类有单参数的构造函数

* 接收一个单参数的const char\*的string构造函数，不是explicit的

```cpp
//以至于我们可以这样对其直接赋值或者初始化
string str1("hello");
string str2="hello";
```

* 接收一个容量参数的vector构造函数是explicit的

```cpp
vector<int> vec(10);//10个int
```

### 聚合类

什么是聚合类？聚合类使得用户可以直接访问其成员，并且具有特殊的初始化语法形式

聚合条件

* 所有成员都是public
* 没有定义任何构造函数
* 没有类内初始值
* 没有基类，没有virtual函数

```cpp
//example40.cpp
#include <iostream>
using namespace std;
struct Person
{
    int age;
    string name;
    void print()
    {
        cout << "age " << age << endl;
        cout << "name " << name << endl;
    }
};
int main(int argc, char **argv)
{
    Person person = {19, "gaowanlu"};
    person.print();
    // age 19
    // name gaowanlu
    return 0;
}
```

列表参数值的顺序必须和类内属性定义顺序严格相同

### 字面量常量类

我们定义的类的实例也可以是字面值

数据成员都是字面值类型的聚合类是字面值常量类，如果不是聚合类，但复合下述要求，也是字面值常量类

* 数据成员都必须是字面值类型
* 类必须至少含有一个constexpr构造函数
* 如果一个数据成员含有类内初始值，则内置类型成员的初始化值必须是一个常量表达式，或者如果成员属于某种类类型，则初始值必须使用成员自己的constexpr构造函数
* 类必须使用析构函数的默认定义，该成员负责销毁类的对象

### constexpr构造函数

constexpr构造函数必须初始化所有数据成员\
constexpr的对象可以调用const的方法，如果此方法有返回值，则返回值的类型必须为constexpr

```cpp
//example41.cpp
#include <iostream>
using namespace std;

class Debug
{
public:
    constexpr Debug(bool b = true) : hw(b), io(b), other(b)
    {
    }
    constexpr Debug(bool h, bool i, bool o) : hw(h), io(i), other(o)
    {
    }
    //除了构造函数其他方法如果返回constexpr则为const函数
    constexpr bool any() const
    {
        return hw || io || other;
    }
    void set_hw(bool h)
    {
        hw = h;
    }
    void set_io(bool i)
    {
        io = i;
    }
    void set_other(bool o)
    {
        other = o;
    }

private:
    bool hw;
    bool io;
    bool other;
};

int main(int argc, char **argv)
{
    constexpr Debug debug(false);
    // debug是const的又是constexpr
    cout << (debug.any() ? "true" : "false") << endl; // false
    // debug.set_hw(false);//debug是constexpr不允许调用非const方法
    //编译时会直接展开debug.any()
    Debug d = debug;
    d.set_hw(true);                                   //非constexpr实例可以调用非const方法
    cout << (d.any() ? "true" : "false") << endl;     // true
    cout << (debug.any() ? "true" : "false") << endl; // false
    return 0;
}
```

### 类的静态成员

有时候类需要它的一些成员与类本身直接相关，而不是与对象保持联系，也就是说类的静态成员属于类而非类的实例

### 声明静态成员

在静态方法中不能使用this，同理static方法不能是const的,对于类的实例对象可以通过成员访问符对静态成员进行访问

```cpp
//example42.cpp
#include <iostream>
#include <string>
using namespace std;

class Person{
public:
    static int age;//static属性声明
    Person()=default;
    static void className(){
        cout<<"Person"<<endl;
    }
private:
    string name;
};

//static属性定义与初始化
int Person::age;

int main(int argc, char **argv)
{
    Person person1;
    Person person2;
    Person::age=18;
    cout<<Person::age<<endl;//18
    person1.className();//Person
    person2.className();//Person
    cout<<person1.age<<endl;//18
    person1.age=19;
    cout<<Person::age<<endl;//19
    cout<<person2.age<<endl;//19
    return 0;
}
```

### 静态属性的类内初始化

上面我们对于类的静态属性，在类中声明，在外部定义。通常情况下静态属性不应在类内部初始化【要注意的是无论怎样写初始化，其初始化器本质上都是在类内作用域进行的，如第二个代码例子】，但const静态成员成员可以类内初始化，不过要求初始值其是constexpr

静态成员可以做普通成员不能做到的事情，如可以使用不完全类型作为属性类型，即声明这个类型时，这个类型还没有被编译器扫描完，也就是类型不完全

```cpp
//example43.cpp
#include<iostream>
#include<string>
using namespace std;

class Person{
public:
    static const unsigned age=19;
    static constexpr int weight=75;
    static const string name;
    static Person* ptr;//静态成员可以是不完全类型
    Person* person;//指针成员可以为不完全类型
    //Person personInstance;//数据成员必须是完全类型
};

Person* Person::ptr=nullptr;
const string Person::name="gaownanlu";

int main(int argc,char**argv){
    Person person;
    cout<<Person::age<<endl;
    cout<<Person::weight<<endl;
    cout<<Person::name<<endl;
    Person::ptr=&person;
    cout<<Person::ptr->name<<endl;//gaowanlu
    return 0;
}
```

全局作用域可以访问私有构造函数? 不是的，不应该那样理解，静态成员初始化器是在类内进行的

```cpp
#include<iostream>
using namespace std;

class A{
public:
	void name() {
		cout << "A" << endl;
	}
	static A* ptr;
private:
	A() = default;
};

//A a; //“A::A”: 无法访问 private 成员(在“A”类中声明)
A* A::ptr = new A;//本质上初始化器在类内进行

int main() {
	A::ptr->name();//A
	delete A::ptr;
	return 0;
}
```

### 静态属性做默认实参

静态属性可以作为方法的默认实参，而普通属性不可以，因为普通属性属于对象本身而非类

```cpp
//example44.cpp
#include<iostream>
using namespace std;

class Person{
public:
    int age;
    Person(int age=defaultAge):age(age){
        cout<<this->age<<endl;
    }
private:
    static const int defaultAge=19;
};

int main(int argc,char**argv){
    Person person1;//19
    Person person2;//19
    return 0;
}
```
