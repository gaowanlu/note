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

### 顺序容器操作

主要包括增删改查等操作

### 向顺序容器添加元素

向容器内添加元素的有多种方式，不同的容器也有相应的约束以及仅有的特性

![向顺序容器添加元素的操作](<../../../.gitbook/assets/屏幕截图 2022-05-28 133030.jpg>)

### push\_back

在尾部创建一个值为t的元素返回void,除了array和forward\_list之外，每个顺序容器都支持push\_back

```cpp
//example10.cpp
list<int> m_list = {1, 2, 3};
vector<int> m_vector = {1, 2, 3};
m_list.push_back(4);
m_list.push_back(4);
//forward_list不支持push_back
```

### push\_front

在前面添加元素

```cpp
//example12.cpp
//list forward_list deque容器支持push_front
list<int> m_list = {1, 2, 3};
m_list.push_front(0);
for(auto&item:m_list){
    cout << item << endl;//0 1 2 3
}
```

### insert

在指定位置添加新的元素,vector、deque、list、string都支持insert，forward\_list提供了特殊版本的insert

* 在容器中的特定位置添加元素

```cpp
//example14.cpp
list<int> m_list = {1, 2, 3};
m_list.insert(m_list.begin(), 0);//添加到begin()的前面
m_list.insert(m_list.end(), 4);//添加到end前面
for(auto&item:m_list){
    cout << item << endl;//0 1 2 3 4
}
```

* 插入范围内元素

```cpp
//example14.cpp
//插入范围内元素
vector<int> vec1 = {1, 2, 3};
vector<int> vec2 = {};

//insert(iter,num,element)
vec2.insert(vec2.begin(), 3, 0);
for(auto&item:vec2){
    cout << item << endl;//0 0 0 
}
//迭代器范围
vec2.insert(vec2.begin(),vec1.begin(),vec1.end());
for(auto&item:vec2){
    cout << item << endl;//1 2 3 0 0 0 
}
//列表insert
auto iter=vec2.insert(vec2.begin(), {777, 888, 999});
for(auto&item:vec2){
    cout << item << endl;//777 888 999 1 2 3 0 0 0 
}
//新标准中insert返回插入元素中的第一个元素的迭代器
cout << *iter << endl;//777
```

### emplace

emplace主要有三种，emplace、emplace\_back、emplace\_front分别对应insert、push\_back、push\_front,二者的区别是后者直接拷贝到容器内，前者则是将参数传递给元素类型的构造函数

```cpp
//example15.cpp
class Person{
public:
    int age;
    string name;
    Person() = default;
    Person(int age,string name):age(age),name(name){

    }
};
//emplace 与 insert 异曲同工
m_list.emplace(m_list.begin(), 19, "she");
```

### emplace\_front

```cpp
//example13.cpp
m_list.emplace_front(19,"she");
m_list.emplace_front();//使用默认构造函数
```

### emplace\_back

```cpp
//example11.cpp
list<Person> m_list;
//创建临时变量 push_back其拷贝后的副本
m_list.push_back(Person(19,"gaowanlu"));
m_list.emplace_back(19,"she");//传递元素构造参数
```

### 访问元素

### 访问元素

### at(n)

![在顺序容器中访问元素的操作](<../../../.gitbook/assets/屏幕截图 2022-05-29 112914 (2).jpg>)

适用于string、vector、deque、array ,下标访问越界时将会抛出out\_of\_range异常

### at(n)

```cpp
//example16.cpp
string str = "hello";
char &ch = str.at(0);
ch = 'p';
cout << str << endl;//pello
```

适用于string、vector、deque、array ,下标访问越界时将会抛出out\_of\_range异常

### back()

```cpp
//example16.cpp
string str = "hello";
char &ch = str.at(0);
ch = 'p';
cout << str << endl;//pello
```

back不适用于forward\_list ，当容器为空时，函数行为没有定义将会卡住

### back()

```cpp
vector<int> vec1 = {1, 2, 3, 4};
int &last_el = vec1.back();//最后一个元素的引用
```

back不适用于forward\_list ，当容器为空时，函数行为没有定义将会卡住

### front()

```cpp
vector<int> vec1 = {1, 2, 3, 4};
int &last_el = vec1.back();//最后一个元素的引用
```

返回第一个元素的引用 ，当容器为空时，函数行为没有定义将会卡住

### front()

```cpp
int &first = vec1.front();
```

返回第一个元素的引用 ，当容器为空时，函数行为没有定义将会卡住

### c\[n]

```cpp
int &first = vec1.front();
```

当容器为空时，函数行为没有定义将会卡住

### c\[n]

```cpp
int &num = vec1[0];
num = 999;
cout << vec1[0] << endl;//999
```

当容器为空时，函数行为没有定义将会卡住

### 删除元素

```cpp
int &num = vec1[0];
num = 999;
cout << vec1[0] << endl;//999
```

删除元素会改变容器的大小，标准库提供的删除操作不支持array

### 删除元素

### pop\_front和pop\_back

删除元素会改变容器的大小，标准库提供的删除操作不支持array

pop\_front()为删除首元素，pop\_back为删除尾元素，vector与string不支持push\_front与pop\_front,forward\_list不支持pop\_back,同时不能对一个空容器操作

![顺序容器的删除操作](<../../../.gitbook/assets/屏幕截图 2022-05-29 114149.jpg>)

```cpp
//example17.cpp
list<int> m_list = {1, 2, 3, 8, 9, 4};
print_list(m_list);//1 2 3 8 9 4
m_list.pop_front();
print_list(m_list);//2 3 8 9 4
m_list.pop_back();
print_list(m_list);//2 3 8 9
```

### pop\_front和pop\_back

### erase从容器内部删除一个元素

pop\_front()为删除首元素，pop\_back为删除尾元素，vector与string不支持push\_front与pop\_front,forward\_list不支持pop\_back,同时不能对一个空容器操作

erase返回指向删除的元素之后位置的迭代器

```cpp
//example17.cpp
list<int> m_list = {1, 2, 3, 8, 9, 4};
print_list(m_list);//1 2 3 8 9 4
m_list.pop_front();
print_list(m_list);//2 3 8 9 4
m_list.pop_back();
print_list(m_list);//2 3 8 9
```

```cpp
//example17.cpp
print_list(m_list);//2 3 8 9
m_list.erase((++m_list.begin()));
print_list(m_list);//2 8 9
```

### erase从容器内部删除一个元素

### erase删除多个元素

erase返回指向删除的元素之后位置的迭代器

```cpp
//example17.cpp
print_list(m_list);//2 8 9
auto iter = m_list.begin();
iter++;
m_list.erase(iter,m_list.end());
cout << "erase all" << endl;
print_list(m_list);//2
```

```cpp
//example17.cpp
print_list(m_list);//2 3 8 9
m_list.erase((++m_list.begin()));
print_list(m_list);//2 8 9
```

### clear清除所有元素

### erase删除多个元素

```cpp
//example17.cpp
//清除全部元素
print_list(m_list);//2
m_list.clear();
print_list(m_list);//nothing
//等价于
m_list.erase(m_list.begin(), m_list.end());
```

```cpp
//example17.cpp
print_list(m_list);//2 8 9
auto iter = m_list.begin();
iter++;
m_list.erase(iter,m_list.end());
cout << "erase all" << endl;
print_list(m_list);//2
```

### 特殊的forward\_list操作

### clear清除所有元素

forward\_list就是我们在数据结构中所学习的单向链表，因此就有了对于forward\_list中插入或者元素删除的特殊操作

```cpp
//example17.cpp
//清除全部元素
print_list(m_list);//2
m_list.clear();
print_list(m_list);//nothing
//等价于
m_list.erase(m_list.begin(), m_list.end());
```

### before\_begin与cbefore\_begin

### 特殊的forward\_list操作

```cpp
//example18.cpp
//获取链表头结点
forward_list<int>::iterator head = m_list.before_begin();
const auto head1 = m_list.cbefore_begin();
```

forward\_list就是我们在数据结构中所学习的单向链表，因此就有了对于forward\_list中插入或者元素删除的特殊操作

### insert\_after与emplace\_after

![在forward\_list中插入或删除元素的操作](<../../../.gitbook/assets/屏幕截图 2022-05-29 142535 (1).jpg>)

```cpp
//example18.cpp
m_list.insert_after(head1,0);//值插入
m_list.insert_after(head, 3, 666);//重复值插入
forward_list<int> m_list_1 = {6, 7, 8};
m_list.insert_after(head1,m_list_1.begin(),m_list.end());//迭代器范围插入
m_list.insert_after(head1, {8, 8, 9});//列表插入
m_list.emplace_after(head1, 19.4);//构造函数插入
for(auto&item:m_list){
    cout << item << " ";
    //19 8 8 9 6 7 8 666 666 666 0 1 2 3
}
cout << endl;
```

### before\_begin与cbefore\_begin

### erase\_after

```cpp
//example18.cpp
//获取链表头结点
forward_list<int>::iterator head = m_list.before_begin();
const auto head1 = m_list.cbefore_begin();
```

同理分为，删除一个指定位置的元素，与迭代器范围内的元素

### insert\_after与emplace\_after

```cpp
//example18.cpp
//erase_after
forward_list<int> m_list_2={1,2,3,4,5,6};
m_list_2.erase_after(m_list_2.begin());
for(auto&item:m_list_2){
    cout << item<<",";//1,3,4,5,6,
}
cout << endl;
//删除(begin,end)之间的元素
m_list_2.erase_after(m_list_2.begin(), m_list_2.end());
for(auto&item:m_list_2){
    cout << item<<",";//1,
}
cout << endl;
```

```cpp
//example18.cpp
m_list.insert_after(head1,0);//值插入
m_list.insert_after(head, 3, 666);//重复值插入
forward_list<int> m_list_1 = {6, 7, 8};
m_list.insert_after(head1,m_list_1.begin(),m_list.end());//迭代器范围插入
m_list.insert_after(head1, {8, 8, 9});//列表插入
m_list.emplace_after(head1, 19.4);//构造函数插入
for(auto&item:m_list){
    cout << item << " ";
    //19 8 8 9 6 7 8 666 666 666 0 1 2 3
}
cout << endl;
```

### 改变容器大小

### erase\_after

除array之外顺序容器可以使用resize修改容器的大小，resize的重载有下面两种形式

同理分为，删除一个指定位置的元素，与迭代器范围内的元素

如果当前实际大小大于所要求的大小，容器后部的元素会被删除\
如果当前实际大小小于新大小，会将新元素添加到容器后部

```cpp
//example18.cpp
//erase_after
forward_list<int> m_list_2={1,2,3,4,5,6};
m_list_2.erase_after(m_list_2.begin());
for(auto&item:m_list_2){
    cout << item<<",";//1,3,4,5,6,
}
cout << endl;
//删除(begin,end)之间的元素
m_list_2.erase_after(m_list_2.begin(), m_list_2.end());
for(auto&item:m_list_2){
    cout << item<<",";//1,
}
cout << endl;
```

![顺序容器大小操作](<../../../.gitbook/assets/屏幕截图 2022-05-30 090211.jpg>)

```cpp
//example19.cpp
vector<int> m_vec = {1, 2, 3};
print_vec(m_vec);//1 2 3
m_vec.resize(5);//size变大
print_vec(m_vec);//1 2 3 0 0
m_vec.resize(7, 999);//size变大
print_vec(m_vec);//1 2 3 0 0 999 999
m_vec.resize(3);//size变小
print_vec(m_vec);//1 2 3
```

### 容器操作可能使迭代器、引用、指针失效

向容器添加元素

* `vector、string`如果存储空间被重新分配，则指向容器的迭代器、指针和引用都失效，如果空间未重新分配，指向插入插入位置之前的迭代器、指针、和引用仍有效，但指向插入位置后的迭代器、指针、引用将失效
* `deque`插入到除首尾位置之外的任何位置将会使迭代器、指针、引用失效，如果在首尾位置插入，迭代器会失效，但引用和指针不会失效
* `list、forward_list`指向容器的迭代器(包括尾后迭代器和首前迭代器)、指针、引用仍有效

删除容器中的元素

* `list、forward_list`指向容器的迭代器(包括尾后迭代器和首前迭代器)、指针、引用仍有效
* `deque`在首尾之外任何位置删除元素，指向被删除元素外其他元素的迭代器、引用、指针失效。删除尾元素，则尾后迭代器end()失效,但其他迭代器、引用、指针不受影响。删除首元素，这些也不会受影响
* `vector、string`指向被删元素之前元素的迭代器、引用、指针仍有效，当删除元素时，尾后迭代器总会失效

### 合理使用insert和erase的返回值

学过insert返回插入元素的第一个位置的迭代器，erase返回删除元素之后的元素

```cpp
//example20.cpp
vector<int> vec = {0, 1, 2, 3, 4, 5};
auto iter = vec.begin();
while(iter!=vec.end()){
    if(*iter%2){//奇数
        iter = vec.insert(iter, *iter);//在iter前插入一个*iter
        iter += 2;//将副本和原元素跳过去
    }else{//偶数
        iter = vec.erase(iter);//返回删除元素的下一个位置的迭代器
    }
}
for(auto&item:vec){
    cout << item << " ";//1 1 3 3 5 5
}
cout << endl;
```

### 不保存end返回的迭代器

当删除/添加vector或string中的元素，或者在deque中首元素之外位置添加/删除元素，原来的end返回的迭代器总会失效，总是在我们保存end，而是随用随取就好了

```cpp
//example21.cpp
vector<int> m_vec = {1, 2, 3, 4};
auto iter = m_vec.begin();
while(iter!=m_vec.end()){//end随用随取
    if(*iter%2){//奇数
        iter = m_vec.insert(iter, *iter);
        iter += 2;
    }else{
        iter++;
    }
}
for(auto&item:m_vec){
    cout << item << " ";//1 1 2 3 3 4
}
cout << endl;
```

### vector对象是如何增长的

vector每次扩展会增添空余的新元素空间，而不是增加一个时只增加一个空间

### 管理vector容量的成员函数

capacity返回不扩展内存的情况下，现在最多能容纳多少元素，reserve操作允许通知容器应该准备多少个存储元素的空间

![容器大小管理操作](<../../../.gitbook/assets/屏幕截图 2022-05-30 101120.jpg>)

当reserve的需求大小超过capacity时才会改变capacity，分配的大小至少与reserve的一样多甚至超过它 ，当reserve需求还没有capacity大时，增不做操作

对于shrink\_to\_fit只是一个请求，标准库并不保证退还内存

```cpp
//example22.cpp
vector<int> m_vec = {1, 2, 3, 4};
//capacity
cout << m_vec.capacity() << endl;//4
m_vec.push_back(5);
m_vec.push_back(6);
cout << m_vec.capacity() << endl;//8

//shrink_to_fit
m_vec.shrink_to_fit();
cout << m_vec.capacity() << endl;//6

//reserve
m_vec.reserve(100);
cout << m_vec.capacity() << endl;//100
```

> 只有执行insert操作size与capacity相等，或者调用resize或reserve时给定的大小超过当前capacity,vector才可能重新分配内存空间，分配多少取决于编译器的具体实现
