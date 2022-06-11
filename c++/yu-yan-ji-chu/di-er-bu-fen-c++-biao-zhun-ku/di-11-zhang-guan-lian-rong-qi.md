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
