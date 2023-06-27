---
cover: >-
  https://images.unsplash.com/photo-1651794926550-3490fb583fd0?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTM1NDg3MjI&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🏭 第 9 章 顺序容器

## 第 9 章 顺序容器

顺序容器为开发者提供了控制元素存储和访问顺序的能力，顺序不依赖元素的值，而是元素加入元素容器时的位置相对应

### 顺序容器概述

![顺序容器类型](../.gitbook/assets/屏幕截图%202022-05-26%20114318.jpg)

如 list、forward_list 是链式存储结构，而 vector、deque、array、string 为顺序存储结构，在增删改等操作上它们会有不同的特性

### 构造函数

容器是 C++对数据结构的一种封装，器本质是面向对象的设计，掌握相关的构造是一件理所当然的事情

### 默认构造

默认构造相关的空容器

```cpp
//example1.cpp
list<int> m_list;//默认构造函数构造空容器
vector<int> m_vector;
```

### 拷贝构造

将 m_vector 拷贝一份到 m_vector_copy

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

迭代器的范围是\[begin,end),当容器为空时 begin 等于 end

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

每个容器都定义了多个类型，如 size_type、iterator、const_iterator

### size_type

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

### const_iterator

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

### const_reference

const 引用

```cpp
//example3.cpp
list<int>::const_reference m_const_list_reference = *(m_list.begin());//const int &m_const_list_reference
//m_const_list_reference = 888;
//error:: readonly
for(vector<int>::const_reference item:m_list){//迭代器for循环
    cout << item << endl;//1 2 3
}
```

### value_type

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

### const_pointer

容器存储类型 const 指针类型

```cpp
//example3.cpp
list<int>::const_pointer const_ptr;//const int *const_ptr
```

### difference_type

迭代器之间的距离

```cpp
//example3.cpp
vector<int> vec = {1, 2, 3};
vector<int>::difference_type distance=end(vec) - begin(vec);
cout << distance << endl;//3
```

### begin 和 end 成员

我们以前接触到的 begin 和 end，分别指向第一个元素与最后一个元素的下一个位置，begin 和 end 有多个版本\
r 开头的返回反向迭代器，c 开头的返回 const 迭代器

### reverse_iterator 与 rend 与 rbegin

```cpp
//example4.cpp
vector<int> vec = {1, 2, 3, 4};
vector<int>::reverse_iterator iter = vec.rbegin();
while(iter!=vec.rend()){
    cout << *iter << endl;//4 3 2 1
    iter++;
}
```

### cbegin 和 cend

```cpp
//example4.cpp
vector<int>::const_iterator const_iter = vec.cbegin();
//*const_iter = 999;
```

### crbegin 和 crend

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

![容器定义和初始化](../.gitbook/assets/屏幕截图%202022-05-27%20233201.jpg)

在前面的构造函数内容中我们已经过实践，可以进行复习与在此学习

### 存储不同类型元素的容器的转换

是没有这样的转换的，如将 vector\<int>转换为 vector\<float>,C++中并没有相关的直接操作，但是允许我们使用迭代器范围方式初始化，迭代器相关元素类型必须有相关的构造函数

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

### 标准库 array

array 具有固定大小

除了 C 风格的数组之外，C++提供了 array 类型，其也是一种顺序容器

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

### 赋值与 swap

![容器赋值运算](../.gitbook/assets/屏幕截图%202022-05-27%20235933.jpg)

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

容器具有成员函数 size,其返回类型为相应容器的 size_type,以及 empty 成员函数

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

运算规则与 string 的关系运算类似

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

![向顺序容器添加元素的操作](../.gitbook/assets/屏幕截图%202022-05-28%20133030.jpg)

### push_back

在尾部创建一个值为 t 的元素返回 void,除了 array 和 forward_list 之外，每个顺序容器都支持 push_back

```cpp
//example10.cpp
list<int> m_list = {1, 2, 3};
vector<int> m_vector = {1, 2, 3};
m_list.push_back(4);
m_list.push_back(4);
//forward_list不支持push_back
```

### push_front

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

在指定位置添加新的元素,vector、deque、list、string 都支持 insert，forward_list 提供了特殊版本的 insert

- 在容器中的特定位置添加元素

```cpp
//example14.cpp
list<int> m_list = {1, 2, 3};
m_list.insert(m_list.begin(), 0);//添加到begin()的前面
m_list.insert(m_list.end(), 4);//添加到end前面
for(auto&item:m_list){
    cout << item << endl;//0 1 2 3 4
}
```

- 插入范围内元素

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

emplace 主要有三种，emplace、emplace_back、emplace_front 分别对应 insert、push_back、push_front,二者的区别是后者直接拷贝到容器内，前者则是将参数传递给元素类型的构造函数

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

### emplace_front

```cpp
//example13.cpp
m_list.emplace_front(19,"she");
m_list.emplace_front();//使用默认构造函数
```

### emplace_back

```cpp
//example11.cpp
list<Person> m_list;
//创建临时变量 push_back其拷贝后的副本
m_list.push_back(Person(19,"gaowanlu"));
m_list.emplace_back(19,"she");//传递元素构造参数
```

### 访问元素

![在顺序容器中访问元素的操作](<../.gitbook/assets/屏幕截图%202022-05-29%20112914%20(2)%20(1).jpg>)

### at(n)

适用于 string、vector、deque、array ,下标访问越界时将会抛出 out_of_range 异常

```cpp
//example16.cpp
string str = "hello";
char &ch = str.at(0);
ch = 'p';
cout << str << endl;//pello
```

### back()

back 不适用于 forward_list ，当容器为空时，函数行为没有定义将会卡住

```cpp
vector<int> vec1 = {1, 2, 3, 4};
int &last_el = vec1.back();//最后一个元素的引用
```

### front()

返回第一个元素的引用 ，当容器为空时，函数行为没有定义将会卡住

```cpp
int &first = vec1.front();
```

### c\[n]

当容器为空时，函数行为没有定义将会卡住

```cpp
int &num = vec1[0];
num = 999;
cout << vec1[0] << endl;//999
```

### 删除元素

删除元素会改变容器的大小，标准库提供的删除操作不支持 array

![顺序容器的删除操作](../.gitbook/assets/屏幕截图%202022-05-29%20114149.jpg)

### pop_front 和 pop_back

pop_front()为删除首元素，pop_back 为删除尾元素，vector 与 string 不支持 push_front 与 pop_front,forward_list 不支持 pop_back,同时不能对一个空容器操作

```cpp
//example17.cpp
list<int> m_list = {1, 2, 3, 8, 9, 4};
print_list(m_list);//1 2 3 8 9 4
m_list.pop_front();
print_list(m_list);//2 3 8 9 4
m_list.pop_back();
print_list(m_list);//2 3 8 9
```

### erase 从容器内部删除一个元素

erase 返回指向删除的元素之后位置的迭代器

```cpp
//example17.cpp
print_list(m_list);//2 3 8 9
m_list.erase((++m_list.begin()));
print_list(m_list);//2 8 9
```

### erase 删除多个元素

```cpp
//example17.cpp
print_list(m_list);//2 8 9
auto iter = m_list.begin();
iter++;
m_list.erase(iter,m_list.end());
cout << "erase all" << endl;
print_list(m_list);//2
```

### clear 清除所有元素

```cpp
//example17.cpp
//清除全部元素
print_list(m_list);//2
m_list.clear();
print_list(m_list);//nothing
//等价于
m_list.erase(m_list.begin(), m_list.end());
```

### 特殊的 forward_list 操作

forward_list 就是我们在数据结构中所学习的单向链表，因此就有了对于 forward_list 中插入或者元素删除的特殊操作

![在forward_list中插入或删除元素的操作](<../.gitbook/assets/屏幕截图%202022-05-29%20142535%20(1).jpg>)

### before_begin 与 cbefore_begin

```cpp
//example18.cpp
//获取链表头结点
forward_list<int>::iterator head = m_list.before_begin();
const auto head1 = m_list.cbefore_begin();
```

### insert_after 与 emplace_after

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

### erase_after

同理分为，删除一个指定位置的元素，与迭代器范围内的元素

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

### 改变容器大小

除 array 之外顺序容器可以使用 resize 修改容器的大小，resize 的重载有下面两种形式

如果当前实际大小大于所要求的大小，容器后部的元素会被删除\
如果当前实际大小小于新大小，会将新元素添加到容器后部

![顺序容器大小操作](../.gitbook/assets/屏幕截图%202022-05-30%20090211.jpg)

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

- `vector、string`如果存储空间被重新分配，则指向容器的迭代器、指针和引用都失效，如果空间未重新分配，指向插入插入位置之前的迭代器、指针、和引用仍有效，但指向插入位置后的迭代器、指针、引用将失效
- `deque`插入到除首尾位置之外的任何位置将会使迭代器、指针、引用失效，如果在首尾位置插入，迭代器会失效，但引用和指针不会失效
- `list、forward_list`指向容器的迭代器(包括尾后迭代器和首前迭代器)、指针、引用仍有效

删除容器中的元素

- `list、forward_list`指向容器的迭代器(包括尾后迭代器和首前迭代器)、指针、引用仍有效
- `deque`在首尾之外任何位置删除元素，指向被删除元素外其他元素的迭代器、引用、指针失效。删除尾元素，则尾后迭代器 end()失效,但其他迭代器、引用、指针不受影响。删除首元素，这些也不会受影响
- `vector、string`指向被删元素之前元素的迭代器、引用、指针仍有效，当删除元素时，尾后迭代器总会失效

### 合理使用 insert 和 erase 的返回值

学过 insert 返回插入元素的第一个位置的迭代器，erase 返回删除元素之后的元素

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

### 不保存 end 返回的迭代器

当删除/添加 vector 或 string 中的元素，或者在 deque 中首元素之外位置添加/删除元素，原来的 end 返回的迭代器总会失效，总是在我们保存 end，而是随用随取就好了

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

### vector 对象是如何增长的

vector 每次扩展会增添空余的新元素空间，而不是增加一个时只增加一个空间

### 管理 vector 容量的成员函数

capacity 返回不扩展内存的情况下，现在最多能容纳多少元素，reserve 操作允许通知容器应该准备多少个存储元素的空间

![容器大小管理操作](../.gitbook/assets/屏幕截图%202022-05-30%20101120.jpg)

当 reserve 的需求大小超过 capacity 时才会改变 capacity，分配的大小至少与 reserve 的一样多甚至超过它 ，当 reserve 需求还没有 capacity 大时，增不做操作

对于 shrink_to_fit 只是一个请求，标准库并不保证退还内存

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

> 只有执行 insert 操作 size 与 capacity 相等，或者调用 resize 或 reserve 时给定的大小超过当前 capacity,vector 才可能重新分配内存空间，分配多少取决于编译器的具体实现

### 额外的 string 操作

C 字符串与 string 之间的操作

![构造string的其他方法](../.gitbook/assets/屏幕截图%202022-05-31%20223118.jpg)

```cpp
//example23.cpp
const char *c_str = "hello world";

string str1(c_str, 3);
cout << str1 << endl;//hel

//string str2(str1, 4);//卡住因为str1中没有4个字符
//cout << str2 << endl;

string str3(c_str, 0, 7);
cout << str3 << endl;//hello w
//从下标0开始 向后7个字符
```

### substr 操作

用于截取子串

![子字符串操作](../.gitbook/assets/屏幕截图%202022-05-31%20223714.jpg)

```cpp
//example24.cpp
string str1 = "hello world";
//s.substr(pos,n)

//从下标4开始后面的字符
cout << str1.substr(4) << endl;//o world

//从下标4开始后面的4个字符
cout << str1.substr(4, 4) << endl;//o wo

//n过长则到字符串末尾但pos超出范围则会抛出out_of_range异常
cout << str1.substr(4, 100) << endl;//o wo

try{
    cout << str1.substr(100, 9) << endl;
}catch(out_of_range error){
    cout <<"ERROR "<< error.what() << endl;
    //ERROR basic_string::substr: __pos (which is 100) > this->siz() (which is 11)
}
```

### 改变 string 的其他方法

包括 insert、erase、assign 以及 string 特有的 append 与 replace 等操作

下面只是对于 string 特殊的操作，string 同样有顺序容器的接口如 insert 的各种插入形式，需要结合前面的接口进行学习，下面有列举 replace 与 insert 的重载表格可以参考对比

![修改string的操作](../.gitbook/assets/屏幕截图%202022-05-31%20225113.jpg)

### string.insert(pos,args)

string 的 insert 居然有 7 个重载，怎么记忆？别做梦了，记住怎么可能，有些功能不是只有利用不同的 insert 的才能解决问题，熟记自己喜欢且常用的 insert 进行记忆，在闲暇之余多尝试其他 api，慢慢经验丰富时结合 IDE 的提示，才能发挥好的作用

```cpp
//example25.cpp
string str1 = "hello world";
const char *c_str = "you";

//在下标2前插入c_str
str1.insert(2,c_str);//c_str是一个指针哦
cout << str1 << endl;//heyoullo world

//在下标str1.size()前插入5个感叹号
str1.insert(str1.size(), 5, '!');
cout << str1 << endl;//heyoulo world!!!!!

//限制下标范围
string str2 = "ABCDEF";
string str3 = "YOU";
str3.insert(0,str2,1,2);//str2下标1开始2个字符插入str3下标0前面
cout << str3 << endl;//BCYOU

//迭代器
string str4 = "ABCDEF";
str4.insert(str4.begin()++,3,'r');
cout << str4 << endl;//rrrABCDEF
```

### string.erase(pos,len)

用于删除字符串中的部分片段

```cpp
//example26.cpp
string str1 = "abcdefgh";

//从下标0开始删除2个字符
str1.erase(0,2);
cout << str1 << endl;//cdefgh

//删除从下标3之后的字符
str1.erase(3);
cout << str1 << endl;//cde

//使用迭代器 删除某个迭代器位置的字符
str1.erase(++str1.begin());
cout << str1 << endl;//ce
```

### string.assign(args)

用于对字符串赋值,string 的 assign 高达 8 个重载，我们自己把握着用 IDE 慢慢研究吧

```cpp
//example27.cpp
string str1 = "abced";
string str2;
str2.assign(str1.c_str(),4);//前4个字符
cout << str2 << endl;//abce

str2.assign(str1);
cout << str2 << endl;//abced

str2.assign(str1.c_str());
cout << str2 << endl;//abced
```

### string.append(args)

append 即在原字符串末尾添加内容，其是 insert 的简写版本,append 有约 6 个重载

```cpp
//example28.cpp
string str1 = "hello";
str1.insert(str1.size(),"io");
cout << str1 << endl;//helloio

str1 = "hello";
str1.append("io");
cout << str1 << endl;//helloio
```

### string.replace(range,ergs)

其是 erase 与 insert 的简写，即用新的字符串替换原来位置的子字符串，replace 约有 14 个重载

```cpp
//example29.cpp
string str1 = "abcdef";
//将cd替换为cc
str1.erase(2,2);
str1.insert(2,"cc");
cout << str1 << endl;//abccef

str1 = "abcdef";
str1.replace(2,2,"cc");//从下标2开始替换2个字符
cout << str1 << endl;//abccef

str1 = "abcdef";
//替换迭代器范围[start,end)内的字符
str1.replace(str1.begin(),str1.begin()+2,"oo");
cout << str1 << endl;//oocdef
```

### 改变 string 的多种重载函数

可见其每个方法的重载非常多，要多探究

### string 搜索操作

string 类提供了 6 各不同的搜索函数、每个函数都有 4 个重载

![string搜索操作](../.gitbook/assets/屏幕截图%202022-06-01%20231700.jpg)

### string.find

查找 s 中第一次出现的位置,有四种重载

```cpp
//example30.cpp
string str = "abcdefg";
std::size_t pos=str.find("cdef");
cout << pos << endl;//2
//没有搜索到返回string::npos
cout << (string::npos==str.find("rre")) << endl;//1
```

### string.rfind

查找 s 中 args 最后一次出现的位置,有四种重载

```cpp
//example30.cpp
//string.rfind
str = "abcdefgggg";
cout << str.rfind("gg") << endl;//8
```

### string.find_first_of

在 s 中查找任意一个字符第一次出现的位置,有四种重载

```cpp
//example30.cpp
//string.find_first_of
str = "abcdefhgcb";
cout << str.find_first_of("de") << endl;//3
```

### string.find_last_of

在 s 中查找任意一个字符最后一次出现的位置,有四种重载

```cpp
//example30.cpp
//string.find_last_of
str = "abcdefhgcb";
cout << str.find_last_of("gec")<<endl;//8
```

### string.find_first_not_of

在 s 中查找第一个不在 args 中的字符,有四种重载

```cpp
//example30.cpp
//string.find_first_not_of
str = "abcdefhgcb";
cout << str.find_first_not_of("acde") << endl;//1
```

### string.find_last_not_of

在 s 中查找最后一个不再 args 中的字符,有四种重载

```cpp
//example30.cpp
//string.find_last_not_of
str = "abcdefhgcb";
cout << str.find_last_not_of("gcfb") << endl;//6 h
```

### compare 函数

类似于 C 语言中的 strcmp，同样等于、大于、小于情况分别返回 0、整数、负数

![compare的几种参数形式](../.gitbook/assets/屏幕截图%202022-06-01%20233504.jpg)

```cpp
//example31.cpp
string str = "abcdef";
cout << str.compare("bcde") << endl;//-1
cout << str.compare("aabcd") << endl;//1
cout << str.compare("abcdef") << endl;//0
```

其重载可以在使用时进行翻阅，用得次数多个自然就记住了

### 数值转换

新标准库引入了多个函数，可以实现数值数据与标准库 string 之间的转换

![string和数值之间的转换](../.gitbook/assets/屏幕截图%202022-06-02%20154255.jpg)

### to_string

将数字转换为字符串

```cpp
//example32.cpp
int num1 = 11;
cout << to_string(num1)<<endl;
unsigned num2 = 22;
cout << to_string(num2) << endl;//低于int则会进行提升
string str = to_string(45.66);
cout << str << endl;//45.660000
```

### stoi

字符串转 int

```cpp
//example32.cpp
//stoi
int num3 = stoi("2343", 0, 10);
cout << num3 << endl;//2343
```

### stol

字符串转 long

```cpp
//example32.cpp
//stol
long num4 = stol("-4354", 0, 10);
cout << num4 << endl;//-4354
```

### stoul

字符串转 unsigned long

```cpp
//example32.cpp
//stoul
unsigned long num5 = stoul("342");
cout << num5 << endl;//342
```

### stoll

字符串转 long long

```cpp
//example32.cpp
//stoll
long long num6 = stoull("48374384");
cout << num6 << endl;//48374384
```

### stoull

字符串转 unsigned long long

```cpp
//example32.cpp
//stoull
unsigned long long num7 = stoull("784378");
cout << num7 << endl;//784378
```

### stof

字符串转 float

```cpp
//example32.cpp
//stof
float num8 = stof("43.542");
cout << num8 << endl;//43.542
```

### stod

字符串转 double

```cpp
//example32.cpp
//stod
double num9 = stod("45.232");
cout << num9 << endl;//45.232
```

### stold

字符串转 long double

```cpp
//example32.cpp
//stold
long double num10 = stold("8439.543");
cout << num10 << endl;//8439.54
```

### 容器适配器

适配器是啥，学过数据结构，例如栈和队列它们都有不同的实现方式，比如顺序栈、链栈，顺序队列、链队列等等，标准库中我们们提供了 stack、queue、priority_queue 适配器，这是一个通用概念

![所有容器适配器都支持的操作和类型](../.gitbook/assets/屏幕截图%202022-06-02%20160547.jpg)

### 定义一个适配器

默认情况下，stack 和 queue 是基于 deque 实现的，priority_queue 是在 vector 之上实现的

- `stack`要求 push_back、pop_back 和 back 操作，因此可以用除了 array、forward_list 之外的任何容器构造
- `queue`要求 back、push_back、front、push_front，可以构造于 list 或 deque 之上，但不能基于 vector 构造
- `priority_queue`除了 front、push_back、pop_back 操作之外还要求随机访问能力，则可以构造于 vector、deque 之上

```cpp
//example33.cpp
deque<int> deq = {1, 2, 3};
//之间使用stack
stack<int> stk(deq);
//在vector上实现空栈
stack<int, vector<int>> int_stack_base_vector;
stack<string, vector<string>> string_stack_base_vector;
```

### stack

![栈的特殊操作](../.gitbook/assets/屏幕截图%202022-06-02%20161843.jpg)

```cpp
//example34.cpp
stack < int, vector<int>> m_stack({1,2,3});
cout << m_stack.top() << endl;//3
m_stack.pop();
m_stack.push(5);//将5压入栈顶
while(!m_stack.empty()){
    //栈顶元素
    cout << m_stack.top() << " ";//5 2 1
    //弹出栈顶元素
    m_stack.pop();
}
```

### queue 与 priority_queue

![队列的特殊操作](../.gitbook/assets/屏幕截图%202022-06-02%20162001.jpg)

priority_queue 允许为队列中的元素建立优先级，新加入的元素会被安排在所有优先级比它低的已有元素之前，默认情况下，标准库在元素类型上使用`<`运算符来确定优先级 ，也就是谁越大谁优先级就越高，到后面还会详细学习，先不要慌

```cpp
//example34.cpp
//queue
queue<int> m_queue({1,2,3});
m_queue.push(4);
while(!m_queue.empty()){
    cout << m_queue.front() <<" ";//1 2 3 4
    m_queue.pop();
}
cout << endl;

//priority_queue
priority_queue<int> m_priority_queue;
m_priority_queue.push(1);
m_priority_queue.push(2);
m_priority_queue.push(3);
m_priority_queue.push(4);
while(!m_priority_queue.empty()){
    cout << m_priority_queue.top() <<" ";//4 3 2 1
    m_priority_queue.pop();
}
cout << endl;
```
