---
cover: >-
  https://images.unsplash.com/photo-1650170496638-b05030a94005?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI1MzAzMzQ&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 🚗 第1章 开始

## 第1章 开始

### 简介

C++是C的超集、通俗的说可以在C++程序内写C语言代码，而在C程序内不能使用C++的特性、可见C++有很大的包袱，背负着许多的任务。如果您没有学习过C语言那么则可以在学习过C++后然后学习C与C++的对比，如果学习过C语言也会使得学习C++非常快。

编写一个最简单的C++程序

```cpp
//example1.cpp
int main(){
    return 0;
}
```

C++的程序入口为main函数，会从执行main函数内的代码开始我们的程序,main函数返回的内容必须为int类型

### 如何编译我们的程序

* 程序源文件命名约定 常见的有 .cc、.cxx、.cpp、.cp、.c。

### 安装linux C++编译环境

```bash
sudo apt install g++
```

或者

```bash
sudo yum install g++
```

### 使用g++将源文件编译为可执行文件

```bash
g++ -o main main.cpp
```

or

```bash
g++ main.cpp -o main
```

多文件分离编译

```bash
g++ main.cpp calc.cpp -o app
```

运行程序

```bash
./main
```

### 初识输入与输出

程序的最大特点在于程序是解决一类问题

再C++中提供了标准库 iostream库，其包含了两个基础类型，istream、ostream 分别为输入流与输出流。一个流就是一个字符序列，是从IO设备读出或者写入的。流表达的是随着时间推移、字符的顺序生成或消耗的。

标准输入输出对象 4个IO对象

cin 标准输入、cout 标准输出、ceer 输出警告、clog 输出程序运行时一般性信息。

```
//example2.cpp
#include<iostream>
int main(int argc,char**argv){
   std::cout<<"Enter two numbers"<<std::endl;
   int var1=0,var2=0;
   std::cin>>var1>>var2;
   std::cout<<var1<<"  "<<var2<<std::endl;
   return 0;
}
```

'<<'操作符：左侧为io对象，右侧要流到此io对象的内容 std::endl 为操纵符的特殊值、写入endl效果为结束当前行、并将与设备关联的缓冲区的内容刷新的设备中。

std::endl std::是什么玩意、它是C++中的命名空间知识、现在不必了解。

'>>'操纵符：左侧为io对象，从istream读取数据，存到指定的对象中，输入运算符返回其左侧运算对象作为计算结果

```cpp
std::cin>>var1>>var2;
//等价于
(std::cin>>var1)>>var2;
//因为std::cin>>var1 返回std::cin
```

### C++中的注释

```cpp
//单行注释

/*多行注释
  2022-4-14
 */
 int main(){
     return 0
 }
```

### 玩个while

```cpp
//example3.cpp
#include <iostream>
int main(int argc, char **argv)
{
    int sum = 0, val = 1;
    while (val <= 10) //循环条件
    {
        sum += val;
        val++; //等价于 val=val+1
    }
    std::cout << sum << std::endl; // 55
}
```

pro版本

```cpp
//example4.cpp
#include <iostream>
int main(int argc, char **argv)
{
    int sum = 0, value = 0;
    //读取数据指导遇到文件尾部，计算所有读入的值的和
    while (std::cin >> value)
    {
        sum += value;
    }
    std::cout << sum << std::endl;
    return 0;
}
```

当使用istream对象作为条件时，其效果时检测流的状态，当遇到文件结束符end-of-file,或者遇见一个无效的输入时，istream对象的状态会变得无效，是一个类假值

### 玩个if

```cpp
//example5.cpp
#include <iostream>
int main(int argc, char **argv)
{
    int val = 0;
    int cnt = 0;
    if (std::cin >> val)
    {
        cnt++;
        while (std::cin >> val)
        {
            if (val == 0)
            {
                break;
            }
            cnt++;
        }
    }
    std::cout << "cnt " << cnt << std::endl;
    return 0;
}
/**
 * @brief 测试样例
 *   1 2 3 4 5
 *   0
 *   cnt 5
 */
```

### C++面向对象

我们指导C++是一个C的超集、它支持多种编程范式如面向对象、泛型编程、函数编程等。

在面向对象里，有个重要的东西叫做类，例如我们有自己定义一个People类,C++允许我们定义其>>输入操作符、<<输出操作符，= 赋值操作符、'+'、'-'、'\*'、 '/' 、'+=' 、'-=' 、'\*=' 、'/=' 允许我峨嵋你自定定义它在People对象上的行为，总之C++是非常强大的,同时提供了成员函数也就是方法。

### 不要慌慢慢来

如果接触过C++会感觉很简单、但也会学到一些新的内容，例如istream对象做判断条件。但是如果你是一个程序小白的话，可能会感觉这是什么啊，学它比登天还难，我们知道一个道理心急吃不了热豆腐，熬粥还得慢慢来，所以静下心来不要急躁，在第1章看过这些只要你觉得喔！这么厉害，我想这就够了，后面会严格遵循C++ Primer 第5版的目录顺序进行
