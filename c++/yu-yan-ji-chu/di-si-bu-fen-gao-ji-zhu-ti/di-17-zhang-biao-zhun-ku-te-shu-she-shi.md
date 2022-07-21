---
cover: >-
  https://images.unsplash.com/photo-1584114161426-b5f10850272a?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHw1fHxtZXJpZGF8ZW58MHx8fHwxNjU4Mzg5Nzc3&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🏍 第17章 标准库特殊设施

## 第17章 标准库特殊设施

如果你已经从第一章按部就班的学到了第17章，我相信你所认识的C++知识已经超过了很多人，因为有学习的同学并没有耐心慢慢全面地学完C++11的全部知识，从17章 标准库特殊设施以及第18章 用于大型程序的工具、第19章 特殊工具与技术这三个单元被统称为高级主题，这些内容往往在大型工程中意义重大

### tuple类型

```cpp
#include<tuple>
```

tuple与pair有些类似，但是tuple支持多个元素，多种元素类型，在希望将一些数据组合成单一对象，但不想麻烦地自定义数据结构表示时很有用,tuple是一个“快速而随意”的数据结构

![tuple支持的操作](<../../../.gitbook/assets/屏幕截图 2022-07-21 131108.jpg>)

### 定义和初始化tuple

定义格式为`tuple<T1,T2,T3...>name;`,使用构造函数初始化，或者在tuple内元素类型相同时使用参数列表进行初始化、或者使用`make_tuple`初始化tuple类型

```cpp
int main(int argc, char **argv)
{
    //成员被默认初始化
    tuple<size_t, int, string> threeData;
    //参数列表初始化内部容器类型
    tuple<string, vector<double>, int, list<int>> s("hi", {12.0, 32., 43.}, 9, {2, 3});
    //参数列表初始化tuple
    // tuple<int, int, int> s1 = {1, 2, 3};//错误 tuple构造函数是explicit的
    tuple<int, int, int> s2{1, 2, 3};

    // make_tuple
    auto s3 = make_tuple("12", 32, 34.f, 34.5);
    // class std::tuple<const char *, int, float, double>

    return 0;
}
```

### 访问tuple成员

需要使用get模板，`get<size_t>(tuple)`对成员进行访问，`tuple_size模板`获取tuple内元素的个数、`tuple_element模板`可以获取tuple内元素的数据类型

```cpp
//example2.cpp
int main(int argc, char **argv)
{
    tuple<int, string, double> m_tuple{1, "12", 34.};
    //取值
    auto item1 = get<0>(m_tuple);
    auto item2 = get<1>(m_tuple) + "[]";
    auto item3 = get<2>(m_tuple) * 5;
    cout << item1 << " " << item2 << " " << item3 << endl;
    // 1 12[] 170
    //赋值
    get<0>(m_tuple) = 999;
    cout << get<0>(m_tuple) << endl; // 999

    // tuple_size模板
    size_t size = tuple_size<decltype(m_tuple)>::value;
    cout << size << endl; // 3

    // tuple_element模板
    tuple_element<1, decltype(m_tuple)>::type el = get<1>(m_tuple);
    cout << el << endl; // 12

    return 0;
}
```

### 关系和相等运算符

tuple之间允许使用关系比较运算符==、<、>,本质为两个tuple中的元素相同位置的元素与另一个tuple相同位置元素比较，两两元素之间必须为可比较的

```cpp
//example3.cpp
int main(int argc, char **argv)
{
    tuple<int, int, int> t1{1, 2, 3};
    tuple<int, int, int> t2{1, 2, 3};
    tuple<int, int, int> t3{0, 1, 2};
    tuple<string, int, int> t4{"hi", 2, 3};
    // 错误 string与int不能比较
    // cout << (t4 < t2) << endl;
    cout << (t1 == t2) << endl; // 1
    cout << (t1 > t3) << endl;  // 1
    cout << (t3 < t1) << endl;  // 1
    cout << (t3 == t1) << endl; // 0
    return 0;
}
```

### 返回多个tuple

可以借助容器或者数组实现

```cpp
//example4.cpp
struct Pack
{
    tuple<int, int> res[3];
};

Pack func1()
{
    Pack pack;
    tuple<int, int>(&res)[3] = pack.res;
    get<0>(res[0]) = 1;
    get<1>(res[0]) = 2;
    get<0>(res[1]) = 1;
    get<1>(res[1]) = 2;
    get<0>(res[2]) = 1;
    get<1>(res[3]) = 2;
    return pack;
}

vector<tuple<int, int>> func2()
{
    vector<tuple<int, int>> vec;
    for (int i = 0; i < 3; i++)
    {
        vec.push_back(make_tuple(i, i + 1));
    }
    return vec;
}

int main(int argc, char **argv)
{
    Pack pack = func1();
    decltype(pack.res) &res = pack.res;
    cout << get<0>(res[0]) << " " << get<1>(res[0]) << endl;
    // 1 2
    vector<tuple<int, int>> &&res1 = func2();
    cout << get<0>(res1[0]) << " " << get<1>(res1[0]) << endl;
    // 0 1
    return 0;
}
```

### 返回tuple与tuple做参数

与标准容器一样，用tuple做参数时默认为拷贝

```cpp
//example5.cpp
tuple<int, string> func1(const tuple<string, int> &m_tuple)
{
    tuple<int, string> res;
    get<0>(res) = get<1>(m_tuple);
    get<1>(res) = get<0>(m_tuple);
    return res;
}

int main(int argc, char **argv)
{
    auto temp = make_tuple("hello", 10);
    const auto &&res = func1(temp);
    cout << get<0>(res) << " " << get<1>(res) << endl;
    // 10 hello
    return 0;
}
```
