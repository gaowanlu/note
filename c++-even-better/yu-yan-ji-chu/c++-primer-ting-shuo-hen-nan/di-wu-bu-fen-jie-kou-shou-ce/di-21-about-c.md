---
cover: >-
  https://images.unsplash.com/photo-1657682041053-cf8f17f96c86?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NjAwNjA2OTg&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🚴 第 21 章 关于 C 的补充

## 第 21 章 关于 C 的补充

### define 宏

- 常量

```cpp
#define PI 3.14
main(){
  float a=PI;
  exit(0);
}
//预处理 gcc -E main.c > main.i，只是对宏名替换不进行语法检查
main(){
  float a=3.14;
  exit(0);
}
#define ADD 2+3
```

- 带参数的宏

```cpp
如
#define MAX(a,b) a>b?a:b
//C源码
#include <stdio.h>
#define MAX(a, b) a > b ? a : b
int main(int argc, char **argv)
{
    MAX(1, 2);
    return 0;
}
//预编译后
# 3 "main.cpp"
int main(int argc, char **argv)
{
    1 > 2 ? 1 : 2;
    return 0;
}
```

要明确一点，宏定义的预处理指示简单的替换，它就是替换

```cpp
//这居然是正确的
#include <stdio.h>
int main(int argc, char **argv)
{
    int a = ({ int a = 1, b = 2; (a>b?a:b); });
    printf("%d\n", a); // 2
    return 0;
}
```

改为宏

```cpp
#include <stdio.h>
#define ME \
    ({ int a = 1, b = 2; (a>b?a:b); })

int main(int argc, char **argv)
{
    int a = ME;
    printf("%d\n", a); // 2
    return 0;
}
```

最后修改

```cpp
#include <stdio.h>
#define MAX(a, b) \
    ({ typeof(a) A = a, B = b; (A>B?A:B); })

int main(int argc, char **argv)
{
    int a = MAX(3, 4);
    printf("%d\n", a); // 4
    return 0;
}
//预编译后
# 5 "main.cpp"
int main(int argc, char **argv)
{
    int a = ({ typeof(3) A = 3, B = 4; (A>B?A:B); });
    printf("%d\n", a);
    return 0;
}
```

### 存储类型

- auto 默认，自动分配空间
- static 静态型，自动初始化为 0，变量具有继承性
- register 寄存器类型，只能定义局部变量，大小有限制，寄存器大小
- extern(说明型) ，意味着不能改变被说明的变量的值或类型

对于 static 的全局变量，作用域是针对单个源文件而言的，同时 static 可以修饰函数，可以防止被其他源文件的直接调用，这么一来还可以搞闭包

为什么说 extern 是说明型呢，因为在声明时不能初始化

```cpp
extern int i=100;//错误
//正确
extern int i;
main(){
  i=100;
}
```

### 函数与指针

- 指针函数：返回指针
- 函数指针：存储函数地址的指针
- 函数指针数组：存储函数指针的数组

总之不要用着些玩意了，好好的现代的 C++不写，用这些干嘛，考古吗

### 宏与枚举的注意事项

```cpp
#include <iostream>
using namespace std;

#define WORK 0
enum job
{
    WORK = 1,
    HOME
};

int main(int argc, char **argv)
{
    enum job j = WORK;
    switch (j)
    {
    case WORK:
        break;
    case HOME:
        break;
    default:
        break;
    }
    return 0;
}
```

预处理后

```cpp
# 2 "main.cpp"
using namespace std;


enum job
{
    0 = 1,
    HOME
};

int main(int argc, char **argv)
{
    enum job j = 0;
    switch (j)
    {
    case 0:
        break;
    case HOME:
        break;
    default:
        break;
    }
    return 0;
}
```

### 动态内存管理

```cpp
#include <stdlib.h>

void *malloc(size_t size);//申请size大小内存
void free(void *ptr);//释放手动申请的内存
void *calloc(size_t nmemb, size_t size);//nmemb个成员，每个成员的大小为size
void *realloc(void *ptr, size_t size);//ptr必须为malloc或calloc返回的
void *reallocarray(void *ptr, size_t nmemb, size_t size);//calloc与realloc的结合
```

### typedef

typedef：为已有的数据类型改名  

typdef 已有的数据类型 新名字;  
