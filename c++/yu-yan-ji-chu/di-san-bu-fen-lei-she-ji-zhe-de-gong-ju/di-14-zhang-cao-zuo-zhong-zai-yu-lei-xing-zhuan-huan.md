---
cover: >-
  https://images.unsplash.com/photo-1612735369300-f2d96e6eaeb4?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHwxfHx0ZXN8ZW58MHx8fHwxNjU2MjE0ODc4&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 📺 第14章 操作重载与类型转换

## 第14章 操作重载与类型转换

C++语言定义了大量运算符以及内置类型的自动转换规则，当运算符被用于类类型的对象时，C++语言允许我们为其指定新的含义，但无权发明新的运算符号

### 基本概念

可以被重载的运算符

![运算符](<../../../.gitbook/assets/屏幕截图 2022-06-26 104310.jpg>)

例重载+运算符的

```cpp
//example1.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}
    Person operator+(Person &person);
    void print()
    {
        cout << age << " " << name << endl;
    }
};

Person Person::operator+(Person &person)
{
    return Person(age + person.age, name + " " + person.name);
}

int main(int argc, char **argv)
{
    Person person1(19, "me");
    Person person2(19, "she");

    Person person3 = person1 + person2; //隐式调用
    person3.print();                    // 38 me she

    Person person4 = person1.operator+(person2); //显式调用
    person4.print();                             // 38 me she
    return 0;
}
```

### 某些运算符不应被重载

例如取址运算符与逗号运算符，它们本就有它们的存在的意义，重载它们使得规则变得混乱，一般来说它们不应被重载\
而逻辑与、逻辑或涉及到短路求值问题,通常情况下，不应重载逗号、取地址、逻辑与、逻辑或运算符

### 重载的返回值类型

重载运算符得返回类型通常情况应该与其内置版本得返回类型兼容：逻辑运算符和关系运算符返回bool、算数运算符返回一个类类型的值，赋值运算符和复合赋值运算符则应该返回左侧运算符对象的一个引用

```cpp
//example2.cpp
class Person
{
public:
    int age;
    Person(const int &age) : age(age){};
    bool operator<(const Person &person)
    {
        return age < person.age;
    }
    Person &operator+=(const Person &person)
    {
        age += person.age;
        return *this;
    }
};

//写为非成员函数 判断 person2>person1关系
bool operator>(const Person &person1, const Person &person2)
{
    return person2.age > person1.age;
}

int main(int argc, char **argv)
{
    Person person1(1);
    Person person2(2);
    cout << (person1 < person2) << endl; // 1
    person1 += person2;
    cout << person1.age << endl; // 3

    cout << (person1 > person2) << endl; // 0
    //显式调用
    cout << operator>(person1, person2) << endl; // 0

    return 0;
}
```

### 选择作为成员或者非成员

可见在`example2.cpp`中，语言允许直接重载operator相关函数，或者重载类的成员方法，那么什么时候作为成员函数，什么时候作为非成员函数呢

* 赋值(=)、下标(\[])、调用(())和成员访问箭头(->)运算符必须是成员
* 复合赋值一般作为成员
* 改变对象状态的运算符如递增、递减、解引用通常是成员
* 具有对成性的运算符，如算数、相等性、关系、位运算符，通常为普通的非成员函数

重点：当把运算符定义成成员函数时，它的左侧运算对象必须是运算符所属类的一个对象

```cpp
//example3.cpp
class Person
{
public:
    int age;
    Person(const int &age) : age(age) {}
    // Person+Person
    Person operator+(int a)
    {
        return Person(age + a);
    }
};

//支持Person-int
Person operator-(const Person &a, int n)
{
    return Person(a.age - n);
}

//支持 int-Person
Person operator-(int n, const Person &a)
{
    return Person(n - a.age);
}

int main(int argc, char **argv)
{
    Person person1(19);
    Person person2 = person1 + 1;
    // Person person3 = 1 + person1;//错误： 因为是调用+前面对象的operator+进行计算
    cout << person2.age << endl; // 20

    cout << person1.age << endl;       // 19
    cout << (person1 - 1).age << endl; // 18
    cout << (1 - person1).age << endl; //-18
    return 0;
}
```

### 重载输出运算符<<

也就是向某些IO类使用<<时右边对象的类型是我们自定义的类型\
第一个形参通常为IO对象的引用，第二个形参const对象的引用,可见输入输出运算符必须是非成员函数，如果是成员函数则因该是ostream与istream的方法，而不是我我们自定义类本身里的重载

```cpp
//example4.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name), num(rand() % 10) {}
    friend ostream &operator<<(ostream &os, const Person &person); //声明为Person的友元函数

private:
    int num;
};

ostream &operator<<(ostream &os, const Person &person)
{
    os << person.age << " " << person.name << " " << person.num;
    return os;
}

int main(int argc, char **argv)
{
    srand(time(NULL));
    Person person(19, "me");
    cout << person << endl; // 19 me 7
    return 0;
}
```

### 重载输入运算符>>

方法与<<运算符类似

```cpp
//example5.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}
};

istream &operator>>(istream &is, Person &person)
{
    is >> person.age >> person.name;
    if (is.fail())
    {
        person = Person(19, "me");
        throw runtime_error("error:input format of person error");
    }
    return is;
};

int main(int argc, char **argv)
{
    Person person1(19, "me");
    try
    {
        cin >> person1; // 20 she
    }
    catch (runtime_error e)
    {
        cout << e.what() << endl;
    }
    cout << person1.age << " " << person1.name << endl; // 20 she
    return 0;
}
```

### 算术运算符

形参通常为常量的引用，返回一个新的结果对象\
其他算数运算定义方法都是类似的

```cpp
//example6.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}
    Person operator*(const int &mul)
    {
        return Person(age * mul, name);
    }
    //复合赋值运算符
    Person &operator*=(const int &mul)
    {
        age *= mul;
        return *this;
    }
};

Person operator*(const Person &a, const Person &b)
{
    return Person(a.age * b.age, a.name);
}

int main(int argc, char **argv)
{
    Person a(19, "me");
    Person b(20, "as");
    cout << (a * b).age << endl;  // 380
    cout << (a * 10).age << endl; // 190
    a *= 11;
    cout << a.age << endl; // 209
    return 0;
}
```

### 相等运算符

参数为常量引用，返回值类型为布尔型

```cpp
//example7.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name)
    {
    }
    bool operator==(const Person &b)
    {
        return this == &b || (age == b.age && name == b.name);
    }
    bool operator!=(const Person &b)
    {
        return age != b.age || name != b.name;
    }
};

int main(int argc, char **argv)
{
    Person a(19, "me");
    Person b(19, "me");
    cout << (a != b) << endl; // 0
    cout << (a == b) << endl; // 1
    return 0;
}
```

如果某个类在逻辑上有相等性的含义，则改类应该定义operator==,这样做可以使得用户更容易使用标准库算法来处理这个类

### 关系运算符

特别是，关联容器和一些算法要用到小于运算符等，我们通常约定规范，当<或>成立时，==不成立、!=成立，同理==成立时<=与>=成立

```cpp
//example8.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name)
    {
    }
    bool operator<(const Person &b)
    {
        return age < b.age;
    }
};

int main(int argc, char **argv)
{
    Person a(19, "a");
    Person b(20, "b");
    cout << (a < b) << endl; // 1
    cout << (b < a) << endl; // 0
    return 0;
}
```

### 赋值运算符

函数参数为等号右侧对象，返回值通常为对象本身的引用\
复合赋值运算在example6.cpp已经涉及，再次不再描述

```cpp
//example9.cpp
class Person
{
public:
    vector<int> list;
    Person &operator=(initializer_list<int> init_list)
    {
        list.clear();
        list = init_list;
        return *this;
    }
    Person &operator=(const Person &b)
    {
        list = b.list;
        return *this;
    }
    friend ostream &operator<<(ostream &o, const Person &p);
};

ostream &operator<<(ostream &o, const Person &p)
{
    for (auto item : p.list)
    {
        o << item << " ";
    }
    return o;
}

int main(int argc, char **argv)
{
    Person person;
    person = {1, 2, 3, 4, 5};
    cout << person << endl; // 1 2 3 4 5
    initializer_list<int> list = {1, 2, 3, 4, 5};
    // Person b = list; //错误：赋值运算不是赋值构造哦
    //当Person有以list类型做参数的构造函数时可以调用，即类型转换构造函数

    Person b = person; //赋值拷贝构造只是特殊的情况
    cout << b << endl; // 1 2 3 4 5
    return 0;
}
```

### 下标运算符

下标运算符必须是成员函数,通常返回对象内部数的引用，参数为size\_t类型表示下标

```cpp
//example10.cpp
class Person
{
public:
    int *arr;
    Person(size_t n) : arr(new int[n])
    {
        for (size_t i = 0; i < n; i++)
        {
            arr[i] = i;
        }
    }
    //当对象不是const时
    int &operator[](const size_t &n)
    {
        return arr[n];
    }
    //当对象是const时
    const int &operator[](const size_t &n) const
    {
        return arr[n];
    }
    ~Person()
    {
        delete[] arr;
    }
};

int main(int argc, char **argv)
{
    Person person(10);
    person[0] = 100;
    cout << person[0] << endl; // 100
    const Person b(10);
    // b[0] = 99;
    // error: assignment of read-only location 'b.Person::operator[](0)'
    // cout << b[0] << endl;
    cout << b[0] << endl; // 0
    return 0;
}
```

### 递增和递减运算符

分为前置版本与后置版本，在C++中并不要求递增和递减运算符必须为类的成员

* 前置版本

```cpp
//example11.cpp
class Person
{
public:
    int age;
    Person(const int &age) : age(age)
    {
    }
    Person &operator++(); //前置版本
    Person &operator--();
};

Person &Person::operator++()
{
    ++age;
    return *this;
}

Person &Person::operator--()
{
    --age;
    return *this;
}

int main(int argc, char **argv)
{
    Person person(19);
    --person; // 18
    cout << person.age << endl;
    ++person;
    cout << person.age << endl; // 19
    
    cout << person.operator++().age << endl; // 20 显式调用
    return 0;
}
```

* 后置版本

重点在于如何区分前置版本与后置版本\
为了解决这个问题，后置版本接受一个额外的（不被使用）int类型形参，当使用后置运算符时编译器自动传递实参0

```cpp
//example12.cpp
class Person
{
public:
    int age;
    Person(const int &age) : age(age)
    {
    }
    Person operator++(int); //后置版本
    Person operator--(int);
    friend ostream &operator<<(ostream &os, const Person &person);
};

Person Person::operator++(int)
{
    //拷贝一份
    Person person = *this;
    ++age;
    return person; //返回原值
}

Person Person::operator--(int)
{
    Person person = *this;
    --age;
    return person;
}

ostream &operator<<(ostream &os, const Person &person)
{
    os << person.age;
    return os;
}

int main(int argc, char **argv)
{
    Person person(19);
    cout << person-- << endl; // 19
    cout << person << endl;   // 18
    cout << person++ << endl; // 18
    cout << person << endl;   // 19
    
    cout << person.operator++(0) << endl; // 19 显式调用
    cout << person << endl;               // 20
    return 0;
}
```

### 成员访问运算符

迭代器以及智能指针和普通指针等常常用到解引用\*与箭头运算符->

```cpp
//example13.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}
    string *operator->()
    {
        return &this->operator*();
    }
    string &operator*()
    {
        return name;
    }
};

int main(int argc, char **argv)
{
    Person person(19, "me");
    cout << person->c_str() << endl; // me
    (*person).assign("she");
    cout << person.name << endl; // she
    return 0;
}
```

### 箭头运算符返回值的限定

operator\*与operator->有区别，operator\*可以完成任何像完成的事情，其返回值不受限制，而operator->的目的是访问某些成员，其返回值类型有限定，箭头函数获取成员这个事实规则永远不变

```cpp
//example14.cpp
class Person
{
public:
    int age;
    string name;
    Person(const int &age, const string &name) : age(age), name(name) {}
    string *operator->()
    {
        return &this->operator*();
    }
    string &operator*()
    {
        return name;
    }
};

int main(int argc, char **argv)
{
    Person person(19, "me");
    cout << (*person).c_str() << endl; // me
    //下面两个操作是等价的
    cout << person.operator->()->c_str() << endl; // me
    cout << person->c_str() << endl;              // me
    return 0;
}
```
