---
coverY: 0
---

# 🥳 第10章 泛型算法

## 第10章 泛型算法

标准库为我们提供了容器，同时为开发者提供了许多算法，这些算法中大多数都独立于任何特定的容器，也就是说这些算法是通用的(generic,或者称为泛型的)：它们可用于不同类型的容器和不同类型的元素，本章主要学习泛型算法与对迭代器更加深入的讨论

### 概述

大多数算法在头文件`algorithm`，`numeric`中定义了一组数值泛型算法\
下面简单使用find算法

```cpp
//example1.cpp
vector<int> vec = {1, 2, 3, 4, 5};
auto target = find(vec.begin(), vec.end(), 3);
if (target != vec.cend())
{
    cout << "finded " << *target << endl; // finded 3
}

//泛型算法是一种通用算法
string str = "abcde";
auto ch = find(begin(str), end(str), 'c');
if (ch != str.cend())
{
    cout << "fined " << *ch << endl; // fined c
}
```

可见迭代器令算法不依赖于容器、不同的容器可以使用相同的算法\
算法依赖于元素类型的操作，如find就依赖于元素类型间的==操作，其他算法可依赖>、<等等

关键概念：算法永远不会执行容器的操作，因为这样就会对特定容器产生依赖，不是真正的泛型算法，它们只会运行在迭代器上

### 初识泛型算法

标准库提供了超过100个算法，虽然很多但它们大部分有类似的接口

### 只读算法

只读算法就是像find一样，使用算法时只读取数据而不进行修改数据的操作

### accumulate求和

其在声明在numeric头文件内

```cpp
//example2.cpp
vector<int> vec = {1, 2, 3, 4, 5};
int sum = accumulate(vec.begin(), vec.end(), 0);//求和初始值为0
cout << sum << endl; // 15
```

accumulate算法和元素类型,因为string之间定义了`+`运算

```cpp
//example2.cpp
vector<string> vec1 = {"hello", "ni"};
string str = accumulate(vec1.begin(), vec1.end(), string(""));
cout << str << endl; // helloni
```

### equal比较

确定两个序列中是否保存着相同的值,返回布尔类型值

```cpp
//example3.cpp
vector<int> seq1 = {1, 2, 3, 4, 5};
list<int> seq2 = {1, 2, 3, 4, 5};
vector<int> seq3 = {2, 3, 4, 5, 6};
// 1
cout << equal(seq1.begin(), seq1.end(), seq2.begin(), seq2.end()) << endl;
// 0
cout << equal(seq2.begin(), seq2.end(), seq3.begin(), seq3.end()) << endl;
```

### 写容器元素的算法

将新值赋予序列中的元素，使用这类算法要注意各种迭代器范围以及长度大小不能超过容器原大小

### fill赋值

fill(begin,end,value) \[begin,end) 赋值为value

```cpp
//example4.cpp
vector<int> vec(10, 999);
printVec(vec); // 999 999 999 999 999 999 999 999 999 999
fill(vec.begin(), vec.end(), 8);
printVec(vec); // 8 8 8 8 8 8 8 8 8 8
fill(vec.begin() + vec.size() / 2, vec.end(), 666);
printVec(vec);
// 8 8 8 8 8 666 666 666 666 666
```

### fill\_n赋值

fill(begin,n,value) 从begin开始n个位置赋值为value

```cpp
//example5.cpp
vector<int> vec1 = {1, 2, 3, 4, 5};
fill_n(vec1.begin() + 1, 4, 666);
printVec(vec1); // 1 666 666 666 666
```

### back\_inserter

back\_inserter是定义在头文件iterator中的一个函数，插入迭代器是一种向容器中添加元素的迭代器，通常情况下通过迭代器向元素赋值时，值被赋予迭代器指向的元素

```cpp
//example6.cpp
vector<int> vec = {1, 2, 3};
std::back_insert_iterator<std::vector<int>> iter = back_inserter(vec);
*iter = 4;
printVec(vec); // 1 2 3 4
*iter = 5;
printVec(vec); // 1 2 3 4 5
//配和fill_n
fill_n(iter, 3, 666);
printVec(vec); // 1 2 3 4 5 666 666 666
```

### 拷贝算法

主要有copy、replace、replace\_copy等

### copy

```cpp
//example7.cpp
void print(int (&vec)[7])
{
    auto iter = begin(vec);
    while (iter != end(vec))
    {
        cout << *iter << " "; // 0 1 2 3 4 5
        iter++;
    }
    cout << endl;
}
int main(int argc, char **argv)
{
    int a1[] = {0, 1, 2, 3, 4, 5};
    int a2[sizeof(a1) / sizeof(*a1) + 1];
    int *ret = copy(begin(a1), end(a1), a2);
    // ret指向拷贝到a2的尾元素之后的位置
    *ret = 999;
    print(a2); // 0 1 2 3 4 5 999
    return 0;
}
```

### replace

将指定范围内的为目标元素的值进行替换

```cpp
//example7.cpp
print(a2); // 0 1 2 3 4 5 999
//将[begin,end)内为值3的元素替换为333
replace(begin(a2), end(a2), 3, 333);
print(a2); // 0 1 2 333 4 5 999
```

### replace\_copy

replace\_copy为也是replace，只不过不再原序列内修改，而是修改后添加到新的序列中

```cpp
//example8.cpp
    vector<int> vec1 = {};
    vector<int> vec2 = {3, 4, 5, 4, 5, 3, 2};
    // replace到vec1序列中
    replace_copy(vec2.cbegin(), vec2.cend(), back_inserter(vec1), 4, 444);
    for (auto &item : vec1)
    {
        cout << item << " "; // 3 444 5 444 5 3 2
    }
    cout << endl;
```

此时vec2并没有被改变，vec1包含vec2的一份拷贝，然后进行了replace
