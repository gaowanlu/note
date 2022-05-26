---
cover: >-
  https://images.unsplash.com/photo-1651794926550-3490fb583fd0?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTM1NDg3MjI&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🏭 第9章 顺序容器

## 第9章 顺序容器

顺序容器为开发者提供了控制元素存储和访问顺序的能力，顺序不依赖元素的值，而是元素加入元素容器时的位置相对应

### 顺序容器概述

如list、forward\_list是链式存储结构，而vector、deque、array、string为顺序存储结构，在增删改等操作上它们会有不同的特性

### 构造函数

### 默认构造

```cpp
//example1.cpp
list<int> m_list;//默认构造函数构造空容器
vector<int> m_vector;
```

### 拷贝构造

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

#### const\_pointer

容器存储类型const指针类型

```cpp
//example3.cpp
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
