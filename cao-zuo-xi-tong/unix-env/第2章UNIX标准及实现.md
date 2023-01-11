---
coverY: 0
---

# 第2章 UNIX标准及实现

## UNIX标准及实现

### 系统限制

* UNIX标准化在C的标准上ISOC、POSIX标准提供了头文件以及库函数  
* 了解不同类UNIX种类，如FreeBSD、Linux、MacOSX等  
* UNIX系统通常有许多的限制，两种类型的限制是必须的，编译时的限制、运行时的限制。有三种方法，编译时限制使用头文件通常有很多宏、与文件或目录无关运行时限制使用sysconf、与文件或目录相关限制hi用pathconf、fpathconf函数  
* ISOC限制：定义在头文件limits.h中，例如宏定义CHAR_BIT char的位数、ULONG_MAX unsigned long的最大值等等、stdio.h里面也有限制但通常也用不到  
* POXIS限制：POSXIS提供了其标准限制，在limits.h中，例如_POXIS_PATH_MAX路径的最大长度等等  
* sysconf、pathconf、fpathconf函数  

```cpp
#include<unistd.h>
long sysconfig(int name);
long pathconfig(const char*pathname,int name);
long fpathconfig(int fd,int name);
//出错返回-1
```

name为系统提供的一堆宏，sysconf相关的name是与文件无关的，pathconf和fpathconfg的name是与文件或者目录相关的限制  
这玩意怎么能记得住呢，知道就好了，用到的时候再查  

* 大致了解怎样使用这三个函数，这怎么能记得住呢，总之知道就行  
* 不确定的运行时限制，没有提前定义到limits头文件中，要再运行时进行获取,具体的还是使用pathconf和sysconf的使用  
* 选项：与限制不太一样，通常代表的意思是，是否支持什么什么，编译时的选项定义在unistd头文件、与目录文件无关运行时选项用sysconf、与文件目录有则用pathconf和fpathconf的  
* 具体的内容可以查看 man手册,有非常详细的程序调用接口,这些东西了解即可  

```bash
man sysconf
```

### 编译时定义宏

```cpp
#include<iostream>
int main(){
#ifdef _DEBUG
    std::cout<<"hello world"<<std::endl;
#endif
    return 0;
}
//g++ -D_DEBUG=1 main.cpp -o main 运行则会输出内容
//g++ main.cpp -o main cout<< 并没有被编译
```

* 基本系统数据类型:头文件中sys/types定义了某些与实现有关的数据类型，称为基本系统数据类型,如clock_t进程滴答时间 dev_t设备号 mode_t文件类型，文件创建模式，pid_t进程号等，都以_t结尾  

> 我暂且认为的学习方法，库函数博大精深，根本记不住但是我们怎么学习呢，当我们没有系统学习过可能遇到自己想做的功能，但是连搜什么都不知道，但是我们系统学习过之后起码知道，哦我知道，应该用什么什么函数，大大减轻了临时学习的成本，提高工作效率  
