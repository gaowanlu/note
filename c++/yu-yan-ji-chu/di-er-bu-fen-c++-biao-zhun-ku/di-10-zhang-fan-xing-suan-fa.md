---
cover: >-
  https://images.unsplash.com/photo-1653212373184-0acac93dbb3e?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTQzOTAwOTE&ixlib=rb-1.2.1&q=80
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

### 重排容器元素的算法

最常用的就是sort进行对数字序列进行排序

### sort与unique

用于消除重复项

```cpp
//example9.cpp
vector<int> vec = {1, 2, 3, 4, 1, 2, 3, 4};
//排序
sort(vec.begin(), vec.end());
printVec(vec); // 1 1 2 2 3 3 4 4
//使用unique重新排列返回夫重复序列的下一个位置
auto end_unique = unique(vec.begin(), vec.end());
auto iter = vec.begin();
while (iter != end_unique)
{
    cout << *iter << " "; // 1 2 3 4
    iter++;
}
cout << endl;
//使用erase删除重复项
vec.erase(end_unique, vec.end());
printVec(vec); // 1 2 3 4
```

### 定制操作

如果有学过java或者javascript，都知道java有一种定义接口对其实现内部类或者使用lambda表达式，javascript则是传递函数或者使用箭头函数，比如它们中的sort都提供了函数传递的机制，在C++中也是有这种功能的

### sort自定义比较函数

```cpp
//example10.cpp
//将s1想象为前面的元素s2为后面的，像排序后满足怎样的性质，就return什么
//此处为后面的长度大于前面的长度
bool shortCompare(const string &s1, const string &s2)
{
    return s1.length() < s2.length();
}

int main(int argc, char **argv)
{
    vector<string> vec = {"dscss", "aaaaaa", "ll"};
    printVec(vec); // dscss aaaaaa ll
    sort(vec.begin(), vec.end(), shortCompare);
    printVec(vec); // ll dscss aaaaaa
    return 0;
}
```

### stable\_sort稳定排序算法

不知道排序算法的稳定性？好好去学下数据结构吧！

```cpp
//example10.cpp
//stable_sort
vec = {"dscss", "aaaaaa", "ll"};
printVec(vec); // dscss aaaaaa ll
stable_sort(vec.begin(), vec.end(), shortCompare);
printVec(vec); // ll dscss aaaaaa
```



### lambda表达式

形式 `[capture list](parameter list)->return type{function body}`

```cpp
//example11.cpp
auto f1 = []() -> int{ return 42; };
auto f2 = []{ return 42; };
cout << f1() << endl; // 42
cout << f2() << endl; // 42
```

### 向lambda传递参数

```cpp
//example12.cpp
vector<string> vec = {"sdcs", "nvfkdl", "acndf"};
printVec(vec); // sdcs nvfkdl acndf
sort(vec.begin(), vec.end(), [](const string &s1, const string &s2) -> bool
     { return s1.length() < s2.length(); });
printVec(vec); // sdcs acndf nvfkdl
```

### 使用捕获列表

在javascript中因为有this的指向，在箭头函数内部可以使用定义它时外部的作用域的变量，C++也能实现功能，就是使用捕获列表

```cpp
//example13.cpp
int count = 0, sum = 1, k = 100;
auto f = [count, sum]()
{
    cout << count << " " << sum << endl;
    // count = 3;//error count readonly
    // cout << k << endl; // error: 'k' is not captured
};
f(); // 0 1
count++;
f(); // 0 1 可见捕获列表只是只拷贝
```

### find\_if

查找第一个满足条件的元素

```cpp
//example14.cpp
vector<int> vec = {1, 2, 3, 7, 5, 6};
auto target = find_if(vec.begin(), vec.end(), [](const int &item) -> bool
                      { return item >= 6; });
if (target != vec.end()) //找到了满足要求的元素的位置的迭代器
{
    cout << *target << endl; // 7
}
```

### for\_each算法

遍历算法

```cpp
//example15.cpp
vector<int> vec = {1, 2, 3, 4, 5, 6};
for_each(vec.begin(), vec.end(), [](int &item) -> void
         { cout << item << " ";item++; });
cout << endl; // 1 2 3 4 5 6

for_each(vec.begin(), vec.end(), [](int &item) -> void
         { cout << item << " "; });
cout << endl; // 2 3 4 5 6 7
```

### lambda捕获和返回

捕获分为值捕获与引用捕获

![lambda捕获列表](<../../../.gitbook/assets/屏幕截图 2022-06-06 095133.jpg>)

```cpp
//example16.cpp
int count = 0;
//值捕获 也就是值拷贝到捕获列表的变量
auto f1 = [count]()
{
    cout << count << endl;
    // count = 999; readonly
};
//引用捕获
auto f2 = [&count]() -> void
{
    cout << count << endl;
    count++;
};
f1();                  // 0
f2();                  // 0
cout << count << endl; // 1
//编译器自动推断 都使用引用型
auto f3 = [&]() -> void
{
    count = 666;
};
```

### mutable可变lambda

刚才我们发现在lambda表达式函数体内部不能修改值捕获的变量的值，使用mutable使得值捕获的值可以改变

```cpp
//example17.cpp
int i, j, k;
i = j = k = 0;
auto f1 = [i, j, k]() mutable -> void
{
    i = j = k = 999;
    cout << i << " " << j << " " << k << endl; // 999 999 999
};
f1();
cout << i << " " << j << " " << k << endl; // 0 0 0
```

### transform

将所在位置修改为lambda表达式返回的内容

前两个参数为遍历的范围，第三个参数为将transform后的值从哪里开始存储

```cpp
//example18.cpp
transform(vec.begin(), vec.end(), vec.begin(), [](int item) -> int{
    if(item>=4){
        return 666;
    }
    return item; 
});
printVec(vec); // 1 2 3 666 666
```

### count\_if

统计满足条件的元素个数

```cpp
//example18.cpp
printVec(vec); // 1 2 3 666 666
// count_if
int sum = count_if(vec.begin(), vec.end(), [](int &item) -> bool
                   { return item >= 666; });
cout << sum << endl; // 2
```
