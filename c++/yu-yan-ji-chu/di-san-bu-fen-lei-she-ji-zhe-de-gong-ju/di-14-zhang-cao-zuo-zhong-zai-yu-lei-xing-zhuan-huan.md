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