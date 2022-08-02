---
cover: >-
  https://images.unsplash.com/photo-1658846702634-da51ac3bad48?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTk0NzQ2MjY&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🚌 第19章 特殊工具与技术

## 第19章 特殊工具与技术

到此你会感觉C++越来越离谱，不好好想着解决问题，语法与特性先成为了一大问题。只能说太复杂了，上手难度较高。

本章分别从，控制内存分配、运行时类型识别、枚举类型、类成员指针、嵌套类、union联合体、局部类、不可移植的特性，入手进行学习

### 重载new和delete

太离谱了吧，new与delete还能重载！先回顾一下new与delete,下面使用到了多维数组的内存动态分配，在C++中new与delete就相当于C中的malloc与free函数

```cpp
//example1.cpp
#include <iostream>
#include <string>
using namespace std;

int main(int argc, char **argv)
{
    string *str = new string();
    delete str;
    int(*m)[5] = new int[5][5];
    m[0][0] = 1;
    m[4][4] = 1;
    cout << m[0][0] << " " << m[4][4] << endl; // 1 1
    delete[] m;
    return 0;
}
```

当用户自定义了new与delete 的operator,则有限使用自定义的，没找到则将寻找new与delete的函数重载，与之前的<,>操作函数类似，否则将会使用标准库中的new、delete

标准库中有4个delete重载、4个new重载

```cpp
void *operator new(size_t);//分配一个对象
void *operator new[](size_t);//分配一个数组
void *operator delete(void*) noexcept;//释放一个对象
void *operator delete[](void*) noexcept;//释放一个数组

void *operator new(size_t,nothrow_t&) noexcept;//分配一个对象
void *operator new[](size_t,nothrow_t&) noexcept;//分配一个数组
void *operator delete(void*,nothrow_t&) noexcept;//释放一个对象
void *operator delete[](void*,nothrow_t&) noexcept;//释放一个数组
```

总之我们左右不了new与delete的行为，我们做的就是写好构造函数与析构函数防止内存泄露

### malloc与free函数

```cpp
#include<cstdlib>
```

例如以下是使用malloc和free编写new与delete的方法

```cpp
//example2.cpp
#include <iostream>
#include <cstdlib>
#include <stdexcept>
using namespace std;

void *operator new(size_t size)
{
    cout << "new memory" << endl;
    if (void *mem = malloc(size))
    {
        return mem;
    }
    else
    {
        throw bad_alloc();
    }
}

void operator delete(void *mem) noexcept
{
    cout << "delete memory" << endl;
    free(mem);
}

int main(int argc, char **argv)
{
    {
        int *num = new int();
        *num = 100;
        cout << *num << endl; // new memory 100
        delete num;
    }
    return 0;
}
```

### 定位new表达式

与allocator类的allocate(size)与deallocate(p,size)的功能有异曲同工之妙。定位new允许在一个特定的、预先分配的内存地址上构造对象

```cpp
new (place_address) type
new (place_address) type (initializers)
new (place_address) type [size]
new (place_address) type [size] {braced initializer list}
```

```cpp
//example3.cpp
#include <iostream>
using namespace std;

int main(int argc, char **argv)
{
    char *buffer = new char[12];
    int *p1 = new ((void *)buffer) int;
    *p1 = 1;
    cout << (int)buffer[0] << " " << (int)buffer[1] << " " << (int)buffer[2] << " " << (int)buffer[3] << endl;
    //        10000000                  00000000                00000000                00000000
    char *p2 = new ((void *)buffer) char[12]{1, 2, 3, 4};
    cout << (int)p2[0] << (int)p2[1] << (int)p2[2] << (int)p2[3] << endl;
    //        1               2              3           4
    return 0;
}
```

### 显式调用析构函数

构造函数的调用都是在使用栈内存定义变量时或者使用动态内存分配时进行调用，但是以前我们默认认为在内存释放时，析构函数自动调用，但是C++允许显式调用析构函数的操作

显式调用析构函数与allocator的destory(p)方法类似,调用后析构函数被执行，但是内存并没有被释放掉，内存可以重新进行使用

```cpp
//example4.cpp
#include <iostream>
#include <string>
using namespace std;

int main(int argc, char **argv)
{
    string *p1 = new string();
    p1->~string(); //调用构造函数并不释放内存
    *p1 = "dss";
    delete p1;
    // cout << *p1 << endl;//错误 乱码
    int(*m)[5] = new int[4][5];
    return 0;
}
```
