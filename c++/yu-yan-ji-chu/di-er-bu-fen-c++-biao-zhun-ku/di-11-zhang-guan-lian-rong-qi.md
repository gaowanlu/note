---
cover: >-
  https://images.unsplash.com/photo-1576858574144-9ae1ebcf5ae5?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHw5fHxyb2FkYmlrZXxlbnwwfHx8fDE2NTQ5MzI4MTY&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 😉 第11章 关联容器

## 第11章 关联容器

与顺序容器不同的是，关联容器中的元素是按关键字来保存和访问的，而顺序容器中的元素是按它们在容器中的位置来顺序保存和访问的，那么典型的就是我们常见的map与set数据结构

### 关联容器类型

![关联容器类型](<../../../.gitbook/assets/屏幕截图 2022-06-11 103211.jpg>)

### 使用map

map类型通常被称为关联数组

```cpp
//example1.cpp
#include <iostream>
#include <map>
using namespace std;
int main(int argc, char **argv)
{
    map<string, size_t> m_map;
    m_map["a"] = 4;
    m_map["b"] = 5;
    cout << m_map["a"] << endl; // 4
    cout << m_map["b"] << endl; // 5
    return 0;
}
```

### 使用set

```cpp
//example2.cpp
map<string, size_t> m_map;
vector<string> vec = {"aaa", "bbb", "ccc", "aaa"};
set<string> m_set;
for (auto &item : vec)
{
    m_set.insert(item);
    cout << item << endl; // aaa bbb ccc aaa
    if (m_map.find(item) != m_map.end())
    {
        m_map[item]++;
    }
    else
    {
        m_map[item] = 1;
    }
}
for (auto &item : m_map)
{
    // aaa 1 bbb 1 ccc 1
     cout << item.first << " " << item.second << endl;
}
//遍历set
for (auto &item : m_set)
{
    cout << item << endl; // aaa bbb ccc
}
```

### 定义关联容器

当定义一个map时，必须指明关键字类型与值类型，而定义set只需指明关键字类型

### 初始化map与set

空容器、列表初始化、映射键值对列表初始化

```cpp
//example3.cpp
//空容器
 map<string, size_t> map_1;
//列表初始化
set<string> set_1 = {"aaa", "bbb", "ccc", "aaa", "bbbb"};
// map列表初始化
 map<string, string> map_2 = {
    {"aaa", "vfvdf"},
    {"bbb", "adfdsfs"},
     {"ccc", "vfdvdf"}};
```

### 初始化multimap与multiset

multi的意义就是，map一个关键词可以存储多个值，set也可以存储多个相同的值

```cpp
//example4.cpp
// multiset
vector<string> vec = {"aaa", "aaa", "bbb", "bbb", "ccc"};
multiset<string> m_set(vec.begin(), vec.end());
for (auto &item : m_set)
{
    cout << item << " "; // aaa aaa bbb bbb ccc
}
cout << endl;
cout << m_set.size() << endl; // 5
// multimap
multimap<string, string> m_map = {{"aaa", "ccc"}, {"aaa", "vvv"}};
for (auto &item : m_map)
{
    cout << item.first << " " << item.second << endl;
    // aaa ccc
    // aaa vvv
}
```

### 关键字类型要求

对于有序容器，map、multimap、set、multiset，关键字类型要求必须定义元素比较方法，默认情况下，标准库使用关键字类型的<运算符来比较两个关键字\
算法允许自定义比较操作，与之类似也可以提供自定义的操作代替关键字上的<运算符

比较函数必须满足以下条件

* 两个关键字不能同时“小于等于”对方
* 如果K1“小于等于”K2，且K2“小于等于”K3，则K1必须“小于等于”K3
* 如果存在两个关键字，任何一个都不“小于等于”另外一个，则称者是“等价”的，且等价具有传递性

### 自定义关键字比较函数

形如

* `map<keyType,valueType,函数指针类型>name(函数指针值);`
* `set<keyType,函数指针类型>name(函数指针值);`

```cpp
//example5.cpp
struct Person
{
    int age;
    string name;
};

//关键字比较函数必须满足上面比较函数的条件
bool comparePerson(const Person &a, const Person &b)
{
    return a.age < b.age && a.name < b.name;
}

int main(int argc, char **argv)
{
    // decltype(comparePerson) * 为函数指针
    map<Person, int, bool (*)(const Person &a, const Person &b)> m_map(comparePerson);
    // 或者使用decltype
    // map<Person, int, decltype(comparePerson) *> m_map(comparePerson);
    Person person1;
    person1.age = 19;
    person1.name = "gaowanlu";
    m_map[person1] = 99999;
    auto val = m_map[person1];
    cout << val << endl; // 99999
    return 0;
}
```

### pair类型

pair的标准库类型，定义在utility头文件中\
一个piar保存两个数据成员，类似容器piar是一个用来生成特定类型的模板，大致可以认为是一个键值对

![pair上的操作](<../../../.gitbook/assets/屏幕截图 2022-06-12 112841.jpg>)

```cpp
//example6.cpp
//空初始化
pair<string, int> m_pair1;

//列表初始化
pair<int, string> m_pair2{999, "gaowanlu"};
cout << m_pair2.first << " " << m_pair2.second << endl; // 999 gaowanlu

pair<int, string> m_pair4 = {999, "gaowanlu"};
cout << m_pair4.first << " " << m_pair4.second << endl; // 999 gaowanlu

//构造函数初始化
pair<string, int> m_pair3("gaowanlu", 888);
cout << m_pair3.first << " " << m_pair3.second << endl; // gaowanlu 888

//使用make_piar
m_pair4 = make_pair(888, "hello");

//赋值
m_pair4.first = 666;
m_pair4.second = "gaowanlu";
cout << m_pair4.first << " " << m_pair4.second << endl; // 666 gaowanlu

// <、>、<=、>=比较pair
pair<int, int> m_pair5(2, 3);
pair<int, int> m_pair6(4, 3);
//当first与second同时满足才返回true
cout << (m_pair5 < m_pair6) << endl;  // 1
cout << (m_pair5 <= m_pair6) << endl; // 1
cout << (m_pair5 > m_pair6) << endl;  // 0
cout << (m_pair5 >= m_pair6) << endl; // 0

// ==比较pair
m_pair5 = make_pair(4, 3);
cout << (m_pair5 == m_pair6) << endl; // 1

// !=比较piar
cout << (m_pair5 != m_pair6) << endl; // 0
```
