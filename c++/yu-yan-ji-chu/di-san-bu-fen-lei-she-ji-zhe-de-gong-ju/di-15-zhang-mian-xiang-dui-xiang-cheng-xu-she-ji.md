---
cover: >-
  https://images.unsplash.com/photo-1470470558828-e00ad9dbbc13?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHwyfHxUb3VyJTIwZGUlMjBGcmFuY2V8ZW58MHx8fHwxNjU2NzQ0MzE5&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🌽 第15章 面向对象程序设计

## 第15章 面向对象程序设计

学习本章将会得到，面向对象程序设计的三个基本概念，数据抽象、继承、动态绑定（多态）\
通过使用数据抽象，我们可以将类的接口与实现分离；\
使用继承可以定义类似的类型并对其相似关系建模；\
使用动态绑定，可以在一定程度上忽略类似类型的区别，而以统一的方式使用它们

### 继承

通常在层次关系的根部有一个基类即被继承的类，其他类则直接或简介地从基类继承而来，这些继承得来的类称为派生类

```cpp
//example1.cpp
class Person
{
public:
    virtual void print() const; //派生类必须实现virtual声明
};

class Mom : public Person
{
public:
    Mom() = default;
    void print() const override; //重写基类的方法
};

void Mom::print() const
{
    cout << "hello print" << endl;
}

int main(int argc, char **argv)
{
    Mom mom;
    mom.print(); // hello print
    return 0;
}
```

### 动态绑定

在有些地方下面的这种操作叫做面向对象里面的多态，在此我们暂且称其为动态绑定

```cpp
//example2.cpp
/**
 * @brief 基类人
 *
 */
class Person
{
public:
    virtual void print() const; //派生类必须实现virtual声明
};

/**
 * @brief 派生类母亲
 *
 */
class Mom : public Person
{
public:
    Mom() = default;
    void print() const override; //重写基类的方法
};
void Mom::print() const
{
    cout << "I am a mom\n"
         << flush;
}

/**
 * @brief 派生类儿子
 *
 */
class Son : public Person
{
public:
    Son() = default;
    void print() const override;
};
void Son::print() const
{
    cout << "I am a son\n"
         << flush;
}

//使用动态绑定
void cute(const Person &person)
{
    person.print();
}

int main(int argc, char **argv)
{
    Mom mom;
    Son son;
    cute(mom); // I am a mom
    cute(son); // I am a son
    return 0;
}
```

### 定义基类

```cpp
//example3.cpp
class Person
{
public:
    Person() = default;
    Person(const int &age, const string &name) : age(age), name(name)
    {
    }
    virtual ~Person() = default; //暂且记住就好
    virtual void print() const
    {
        cout << age << " " << name << endl;
    }

private:
    int age;
    string name;

protected:
    int code;
};

int main(int argc, char **argv)
{
    Person person(19, "me");
    person.print(); // 19 me
    return 0;
}
```

上面出现的新事物为

* virtual析构函数，暂且我们认为都要在基类中定义virtual析构函数好了，后面学习后就会知道为什么，除构造函数外的非静态函数都可以为虚函数
* protected访问控制，对于类本身protected的属性或方法相当于private的，有时需要派生类有权限访问但是其他禁止访问，就可以用protected控制
* virtual函数必须被派生类重新override

### 定义派生类

派生类要通过使用类派生列表指定从那些基类继承，每个基类前面可以有三种访问说明符的一个：public、protected、private，虽然C++支持从多个基类继承，但是这是面向对象编程极为不推荐的，通常我们约定只继承自一个类，称作为“单继承”

```cpp
//example4.cpp
//基类
class Person
{
public:
    Person() = default;
    Person(const int &age, const string &name) : age(age), name(name)
    {
    }
    virtual ~Person() = default; //暂且记住就好
    virtual void print() const
    {
        cout << age << " " << name << endl;
    }

private:
    int age;
    string name;

protected:
    int code;
};

//派生类
class Son : public Person
{
public:
    Son(int code = 0) : Person(19, "me")
    {
        this->code = code;
        // Son中可以访问基类的protected成员private的不可以
    }
    void print() const override
    {
        cout << code << endl;
        Person::print(); //调用基类的print方法
    }
};

int main(int argc, char **argv)
{
    Son son1;
    son1.print();
    // 0
    // 19 me
    return 0;
}
```
