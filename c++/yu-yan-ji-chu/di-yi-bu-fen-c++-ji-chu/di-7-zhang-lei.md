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
struct Person
{
    string name;
    int age;
    Person() = default;
    //初始化属性列表
    Person(string name) : name(name), age(20)
    {
        cout << this->name << " " << this->age << endl;
    }
};
int main(int argc, char **argv)
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
