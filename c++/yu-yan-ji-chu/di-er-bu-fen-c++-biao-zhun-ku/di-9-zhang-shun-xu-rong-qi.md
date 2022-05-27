---
cover: >-
  https://images.unsplash.com/photo-1651794926550-3490fb583fd0?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTM1NDg3MjI&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🏭 第9章 顺序容器

## 第9章 顺序容器

顺序容器为开发者提供了控制元素存储和访问顺序的能力，顺序不依赖元素的值，而是元素加入元素容器时的位置相对应

### 顺序容器概述

![顺序容器类型](<../../../.gitbook/assets/屏幕截图 2022-05-26 114318.jpg>)

如list、forward\_list是链式存储结构，而vector、deque、array、string为顺序存储结构，在增删改等操作上它们会有不同的特性

### 构造函数

容器是C++对数据结构的一种封装，器本质是面向对象的设计，掌握相关的构造是一件理所当然的事情

### 默认构造

默认构造相关的空容器

```cpp
//example1.cpp
list<int> m_list;//默认构造函数构造空容器
vector<int> m_vector;
```

### 拷贝构造

将m\_vector拷贝一份到m\_vector\_copy

```cpp
//example1.cpp
vector<int> m_vector_copy(m_vector);
```

### 迭代器范围构造

其范围是\[begin,end)范围内的元素

```cpp
//example1.cpp
vector<int> m_vector_1(m_vector_copy.begin(), m_vector_copy.end());
```

### 列表初始化构造

```cpp
//example1.cpp
list<int> m_list_1{1, 2, 3};
for(auto&item:m_list_1){
    cout << item << endl;//1 2 3
}
```

### 迭代器

迭代器的范围是\[begin,end),当容器为空时begin等于end

```cpp
//example2.cpp
list<int> m_list{1, 2, 3};
list<int>::iterator iter = m_list.begin();
while(iter!=m_list.end()){
    cout << *iter << endl;//1 2 3
    iter++;
}
```

### 容器类型成员

每个容器都定义了多个类型，如size\_type、iterator、const\_iterator

### size\_type

```cpp
//example3.cpp
list<int> m_list{1, 2, 3};
list<int>::size_type size = m_list.size();
cout << size << endl;//3
```

### iterator

```cpp
//example3.cpp
list<int>::iterator iter = m_list.begin();
```

### const\_iterator

```cpp
//example3.cpp
list<int>::const_iterator const_iter = m_list.begin();
//*const_iter = 1;//error readonly
```

### reference

元素引用类型

```cpp
//example3.cpp
list<int>::reference m_list_reference=*(m_list.begin()); // int &m_list_reference;
m_list_reference = 999;
cout << *(m_list.begin()) << endl;//999
```

### const\_reference

const引用

```cpp
//example3.cpp
list<int>::const_reference m_const_list_reference = *(m_list.begin());//const int &m_const_list_reference
//m_const_list_reference = 888;
//error:: readonly
for(vector<int>::const_reference item:m_list){//迭代器for循环
    cout << item << endl;//1 2 3
}
```

### value\_type

容器存储类型的值类型

```cpp
//example3.cpp
list<int>::value_type num = 9;//int num
```

### pointer

容器存储类型的指针类型

```cpp
//example3.cpp
list<int>::pointer ptr;//int *ptr
```

### const\_pointer

容器存储类型const指针类型

```cpp
/i/example3.cpp
list<int>::const_pointer const_ptr;//const int *const_ptr
```

### difference\_type

迭代器之间的距离

```cpp
//example3.cpp
vector<int> vec = {1, 2, 3};
vector<int>::difference_type distance=end(vec) - begin(vec);
cout << distance << endl;//3
```

### begin和end成员

我们以前接触到的begin和end，分别指向第一个元素与最后一个元素的下一个位置，begin和end有多个版本\
r开头的返回反向迭代器，c开头的返回const迭代器

### reverse\_iterator与rend与rbegin

```cpp
//example4.cpp
vector<int> vec = {1, 2, 3, 4};
vector<int>::reverse_iterator iter = vec.rbegin();
while(iter!=vec.rend()){
    cout << *iter << endl;//4 3 2 1
    iter++;
}
```

### cbegin和cend

```cpp
//example4.cpp
vector<int>::const_iterator const_iter = vec.cbegin();
//*const_iter = 999;
```

### crbegin和crend

甚至还有这样的组合，真实离了个大谱了

```cpp
//example4.cpp
vector<int>::const_reverse_iterator const_reverse_iter = vec.crbegin();
while (const_reverse_iter!=vec.crend())
{
    cout << *const_reverse_iter << endl;//4 3 2 1
    const_reverse_iter++;
}
```

### 容器定义和初始化

主要要掌握容器的构造函数的相关重载，以及赋值拷贝等特性

![容器定义和初始化](<../../../.gitbook/assets/屏幕截图 2022-05-27 233201.jpg>)

在前面的构造函数内容中我们已经过实践，可以进行复习与在此学习

### 存储不同类型元素的容器的转换

是没有这样的转换的，如将vector\<int>转换为vector\<float>,C++中并没有相关的直接操作，但是允许我们使用迭代器范围方式初始化，迭代器相关元素类型必须有相关的构造函数

```cpp
//example5.cpp
#include<iostream>
#include<vector>
using namespace std;
int main(int argc,char**argv){
    vector<int> vec1{1, 2, 3};
    //vector<float> vec2(vec1);//没有相关构造函数
    vector<float> vec2(vec1.begin(), vec1.end());//可以用迭代器进行初始化
    int num=float(*vec1.begin());//背后可以使用元素类型的构造函数
    cout << num << endl;//1

    //string与char*
    const char *str1 = "hello";
    const char *str2 = "world";
    vector<const char *> str_vec = {str1, str2};
    vector<string> string_vec(str_vec.begin(),str_vec.end());//可以用迭代器进行初始化
    string str(*str_vec.begin());//背后可以使用元素类型的构造函数
    cout << str << endl;//hello

    return 0;
}
```

### 标准库array

array具有固定大小

除了C风格的数组之外，C++提供了array类型，其也是一种顺序容器

```cpp
//example6.cpp
#include<iostream>
#include<array>
using namespace std;
int main(int argc,char**argv){
    //一维array
    array<int, 10> m_array;
    m_array[0] = 1;
    cout << m_array[0] << endl;
    //二维array
    array<array<int, 10>, 10> matrix;
    matrix[0][0] = 1;
    cout << matrix[0][0] << endl;//1

    //同理可以具有容器的特性
    array<array<int, 10>, 10>::size_type size=matrix.size();//size_type
    array<array<int, 10>, 10> copy = matrix;//拷贝构造
    array<array<int, 10>, 10>::iterator iter = matrix.begin();//迭代器等
    cout << (*iter)[0] << endl;//1

    return 0;
}
```

### 赋值与swap

![容器赋值运算](<../../../.gitbook/assets/屏幕截图 2022-05-27 235933.jpg>)

```cpp
//example7.cpp
vector<int> vec1 = {1, 2, 3};
vector<int> vec2 = {3, 2, 1};
//c1=c2
vec2 = vec1;//拷贝
print_vec(vec1,"vec1");//vec1:1 2 3
print_vec(vec2, "vec2");//vec2:1 2 3

//c={a,b,c...}通过列表赋值
vec1 = {4, 5, 6,7};
print_vec(vec1, "vec1");//vec1:4 5 6 7

//swap(c1,c2) 交换两容器的内容
swap(vec1,vec2);
print_vec(vec1,"vec1");//vec1:1 2 3
print_vec(vec2, "vec2");//vec2:4 5 6 7

//assign操作不适用于关联容器和array
vec1.assign({8,9,10});//列表assign
vec1.assign(vec2.begin(), vec2.end());//迭代器assign
vec1.assign(10, 999);//赋值为10个999
```

### 容器大小操作

容器具有成员函数size,其返回类型为相应容器的size\_type,以及empty成员函数

```cpp
//example8.cpp
vector<int> vec1 {1, 2, 3};
string str1 = "123";
vector<int>::size_type vec1_size = vec1.size();
string::size_type str1_size = str1.size();
cout << "vec1_size " << vec1_size << endl;//vec1_size 3
cout << "str1_size " << str1_size << endl;//str1_size 3
cout << str1.empty() << endl;//0
cout << vec1.empty() << endl;//0
```

### 容器与关系运算符

容器之间也可以使用<、>、==关系运算符进行比较运算

运算规则与string的关系运算类似

1、如果两个容器具有相同大小且所有元素都两两对应相等，则者两个容器相等，否则两个容器不等\
2、如果两个容器大小不同，但较小容器中每个元素都等于较大容器中的对应元素，则较小容器小于较大容器\
3、如果两个容器都不是另一个容器的前缀子序列，则它们的比较结果取决于第一个不相等的元素的比较结果

```cpp
//example9.cpp
int arr1[10]{1, 2, 3, 4, 5};
int arr2[10]{1, 2, 3, 4, 5};
cout << (arr1 == arr2) << endl;//0
//为什么 本质上比较的是头地址哦，忘了的话要去复习数组章节了

//==
array<int, 5>array1{1, 2, 3, 4, 5};
array<int, 5>array2{1, 2, 3, 4, 5};
cout << (array1 == array2) << endl;//1

vector<int> vec1 = {1, 1, 2, 3};
vector<int> vec2 = {
    1,
    1,
    3,
    1
};
cout << (vec1 == vec2) << endl;//0
cout << (vec1 <= vec2) << endl;//1
cout << (vec1 > vec2) << endl;//0
```

> 容器的关系运算符依赖于元素的关系运算符，只有容器的元素支持关系运算时，容器整体才可以进行关系运算
