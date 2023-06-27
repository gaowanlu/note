---
cover: >-
  https://images.unsplash.com/photo-1650170496638-b05030a94005?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI1MzAzMzQ&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 🕵 第 4 章 表达式

## 第 4 章 表达式

什么是表达式？我可以简单地认为是需要运算的式子，官方的解释为表达式由一个或多个运算对象组成，对表达式求值将得到一个结果，字面值和变量是最简单的表达式，其结果就是字面值和变量的值。

### 基础

我们不必钻牛角尖，我们要通过实践向前看，通过实践一步步向前，当我们对整体有了解之后然后再回头来钻牛角尖、研究背后的道理。

### 基本概念

C++定义了一元运算符、二元运算符、三元运算符

```cpp
//example1.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    //运算符举例
    int i = 3;
    int *ip = &i;  //一元运算符&
    int j = i * 3; //二元运算符
    bool flag = false;
    i = flag ? 23 : 43; //因为falg为false则右边表达式计算结果为43
    cout << i << endl;  // 43
    /*
    state?return if state is true:return if state if false
    */
    return 0;
}
```

来其他运算，下面列举的有些我们已经在前面学过了，有些没有学习过

### 运算对象转换

也就是从一种类型转换到另一种类型，我们现在知道的有自动转换与强制转换，如果记得不太清楚可以翻到前面的章节进行回顾。

### 重载运算符

我们使用的 cout<<中的<<就是对<<运算符的一种重载，但是我们现在不进行讨论，不然初学者或者小白肯定会懵逼的哦，后面我们会慢慢接触到的。

### 左值和右值

表达式可以分为左值和右值，左值可以位于赋值语句的左侧，右值不能。

### 优先级与结合律

复合表达式是指含有两个或者多个运算符的表达式，表达式通过运算方式连接在一起

```cpp
//example2.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int i = 6 + 3 * 4 / 2 + 2;
    cout << i << endl; // 14
    //程序上是怎样处理的呢
    int j = (6 + ((3 * 4) / 2) + 2);
    //这是上面复合表达式中运算符中的运算优先级
    cout << j << endl; // 14

    //我们可以自己使用括号来达到我们特定的效果
    int k = 1 + 2 * 3;
    cout << k << endl; // 7
    k = (1 + 2) * 3;
    cout << k << endl; // 9

    //应用举例
    int arr[] = {9, 1, 2, 3, 4};
    cout << *(arr + 4) << endl; // 4
    cout << *arr + 4 << endl;   // 13
    //在*arr+4中 *先于arr结合使用然后得到结果在参与+的运算
    return 0;
}
```

### 求值顺序

运算符的优先级规定了运算对象的组合方式，但还有一点就是一个复合表达式中它们的计算顺序是怎样的

对于

```cpp
f()+g()*h()+j()
```

对其规范地解释为，优先级规定 g()与 h()相乘，结合律规定，f()的返回值先与 g()和 h()的乘积相加，所得结果再与 j()的返回值相加，对这些函数调用顺序没有明确规定。

C++没有明确指明大多数二元运算符左右表达式的运算顺序，但是在大多数编译器中都是从左到右的

举例代码

```cpp
//example3.cpp
#include <iostream>
using namespace std;
int f1();
int f2();

int global_int = 1;

int main(int argc, char **argv)
{
    int i = f1() + f2(); // 3 + 6
    //在初始化i是右边的表达式f1()+f2()它们的执行顺序是怎样的呢
    cout << i << endl;
    // f1 excute gloal->2
    // f2 excute gloal->4
    // 9
    //可见是从左到右执行，当f1执行得到结果后才会向后计算

    cout << (f1() * 3 + (f2() * 3)) << endl;
    // f1 excute gloal->5
    // f2 excute gloal->7
    // 45
    //为什么?因为在此表达式中f1()*3的优先级与(f2()*3)相同
    //二者会按照谁在前谁先执行

    cout << f1() + f2() * 3 << endl;
    // f1 excute gloal->8
    // f2 excute gloal->10
    // 45
    //同理f1()与f2()*3同优先级，按照现后顺序执行
    cout << f2() * 3 + f1() << endl;
    // f2 excute gloal->12
    // f1 excute gloal->13
    // 56
    //但是C++没有明确指明大多数二元运算符左右表达式的运算顺序，但是在大多数编译器中都是从左到右的
    //也就是从C++的规定上，我们不知道f2()*3先执行还是f1()先执行
    return 0;
}
int f1()
{
    global_int += 1;
    cout << "f1 excute gloal->" << global_int << endl;
    return 1 + global_int;
}
int f2()
{
    global_int += 2;
    cout << "f2 excute gloal->" << global_int << endl;
    return 2 + global_int;
}
```

### 算数运算符

算术运算符有

```cpp
+   一元正号     + expr
-   一元负号     - expr
*   乘法         expr * expr
/   除号         expr / expr
%   求余         expr % expr
+   加号         expr + expr
-   减法         expr - expr
```

关于它们的优先级，一元运算符优先级最高，其次是乘法和除法，优先级最低的为加减法，算术运算符满足结合律，当优先级相同时按照从左向右的顺序进行组合

```cpp
//example4.cpp
#include <iostream>
#include <climits>
using namespace std;
int main(int argc, char **argv)
{
    int num1 = -199;
    bool num2 = NULL; // NULL等价于0，false等价于0
    int num3 = -num2;
    cout << num1 << " " << num2 << " " << num3 << endl; //-199 0 0

    //我们要注意在算数运算时要注意防止数据溢出的情况
    int num4 = INT_MAX;
    cout << num4 << endl; // 2147483647
    num4 = num4 + 1;
    cout << num4 << endl; //-2147483648
    return 0;
}
```

### limits 头文件

可见我们上面有用到一个新的头文件，climits 在 C 语言中为 limits.h,其内有宏定义各个基本类型的标识范围,不要恐惧，这些玩意根本不是让人记忆的，我们要知道有这么回事，在由于语法提示的编辑器内写代码，一敲不就出来了吗，但是我们要知道它们是做什么的，随着我们对知识的掌握，我们在回过头研究它们的表示范围为什么是这样，这就是计算机编码的范畴了同样也属于计算机组成原理内的重要知识

```cpp
//example5.cpp
#include <iostream>
#include <climits>
using namespace std;
int main(int argc, char **argv)
{
    // char
    cout << CHAR_MIN << endl; // -128
    cout << CHAR_MAX << endl; // 127

    // signed char
    cout << SCHAR_MIN << endl; // -128
    cout << SCHAR_MAX << endl; // 127

    // unsigned char
    cout << UCHAR_MAX << endl; // 255

    // short
    cout << SHRT_MIN << endl; // -32768
    cout << SHRT_MAX << endl; // 32767

    // unsigned short
    cout << USHRT_MAX << endl; // 65535

    // int
    cout << INT_MAX << endl; // 2147483647
    cout << INT_MIN << endl; //-2147483648

    // unsigned int
    cout << UINT_MAX << endl;

    // long
    cout << LONG_MAX << endl; // 2147483647
    cout << LONG_MIN << endl; //-2147483648

    // unsigned long
    cout << ULONG_MAX << endl; // 4294967295

    // unsigned long long
    cout << ULONG_LONG_MAX << endl; // 18446744073709551615

    // longlong
    cout << LONG_LONG_MAX << endl; // 9223372036854775807
    cout << LONG_LONG_MIN << endl; //-9223372036854775808

    // float
    cout << __FLT_MANT_DIG__ << endl;   // 24 尾数
    cout << __FLT_DIG__ << endl;        // 6 最少有效数字位数
    cout << __FLT_MIN_10_EXP__ << endl; //-37 带有全部有效数的float类型的负指数的最小值（以10为底）
    cout << __FLT_MAX_10_EXP__ << endl; // 38 float类型的正指数的最大值（以10为底）
    cout << __FLT_MIN__ << endl;        // 1.17549e-038　保留全部精度的float类型正数最小值
    cout << __FLT_MAX__ << endl;        // 3.40282e+038 float类型正数最大值
    return 0;
}
```

### 除法与求余

下面我们在看一看我们不太熟悉的算术运算符\
在注意的一点是求余运算不支持左右表达式为浮点型，也就是只支持整数求余算数运算

```cpp
//example6.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    //对于加减法在此不再举例，我们在上面小结已经有了了解
    //我们来看两个比较特殊的算数 除法与求余
    int num1 = 21 % 5;
    int num2 = 3 % 2;
    int num3 = 9 % 3;
    cout << num1 << " " << num2 << " " << num3 << endl; // 1 1 0
    //明白怎么回事了吧，就是我们计算整数除法，那个余数啊，不会怕这都不知道这是小学的只是啊
    //没关系我们把它学会的就好了

    //还有特殊的地方为整数的除法
    float num4 = 4 / 3;
    cout << num4 << endl;         // 1
    cout << (float)4 / 3 << endl; // 1.33333
    cout << 4.f / 3 << endl;      // 1.33333
    //可见在整数除法中，除到不可除就不再计算了，也就是得到了整数部分 剩下的余数进行了舍弃
    //解决办法就是将expr / expr 上下的数值至少一个为浮点型，然后用浮点型变量存储起来
    return 0;
}
```

### 负数求余

被除数与除数有负数时进行求余运算时，结果是怎样的呢？

- m%(-n) 等于 m%n
- (-m)%n 等于 -(m%n)
- (-m)%(-n)=-(m%n)

简单可以记住，求余的结果的正负号有%符号左边的正负号决定

代码举例

```cpp
//example7.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    cout << -4 % 3 << endl;  //-1
    cout << 4 % -3 << endl;  // 1
    cout << -4 % -3 << endl; //-1
    //这都是怎么回事
    //计算规则是这样的
    // m%(-n) 等于 m%n
    //(-m)%n 等于 -(m%n)
    //对于(-m)%(-n)怎么解释呢
    //(-m)%(-n) 等于 -(m%(-n))
    //又(m%(-n))等于m%n
    //则(-m)%(-n)=-(m%n)
    return 0;
}
```

### 逻辑和关系运算符

这些东西的话小学生都会哦

```
逻辑非 !
小于 <
小于等于 <=
大于 >
大于等于 >=
相等 ==
不相等 !=
逻辑与 &&
逻辑或 ||
```

```cpp
//example8.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int i = 0, j = 1, k = 2;
    bool t = false;
    std::cout << !j << std::endl;       // 0
    std::cout << (j < k) << std::endl;  // 1
    std::cout << (j > k) << std::endl;  // 0
    std::cout << (j <= k) << std::endl; // 1
    std::cout << (j >= k) << std::endl; // 0
    std::cout << (i == 0) << std::endl; // 1
    std::cout << (t == i) << std::endl; // 1
    std::cout << (i != j) << std::endl; // 1
    std::cout << (j || t) << std::endl; // 1
    return 0;
}
```

### 赋值运算符

赋值运算符我们现在已经运用的非常熟练了,但要知道赋值运算符的左侧对象必须是一个可修改的左值，如果右边与左边的数据类型不同，则会先将右边转换为左边类型，然后进行赋值操作。

```cpp
//example9.cpp
#include <iostream>
#include <vector>
#include <string>
using namespace std;
int main(int argc, char **argv)
{
    int k = 3.14;
    cout << k << endl; // 3
    // 4=3;//错误因为4不是左值

    // C++ 11 允许使用花括号括起来初始化列表
    vector<double> vec;
    vec = {2.3, 23.2, 2};
    for (auto &item : vec)
    {
        cout << item << endl; // 2.3 23.2 2
    }

    //初始值满足右结合律
    int i = k = 12;
    cout << i << " " << k << endl; // 12 12
    string s1, s2;
    s1 = s2 = "HELLO C++";
    cout << s1 << endl;          // HELLO C++
    cout << s2 << endl;          // HELLO C++
    cout << (s1 = "HI") << endl; // HI
    //赋值运算当被复制后会返回赋的内容

    //大忌
    //切勿混淆 == 与 = 的使用，否则半天的BUG找不出来
    return 0;
}
```

### 复合赋值运算符

left_value operator=right_value 等价于 left_value=left_value operator right_value

```cpp
//算术运算
+= 、-= 、*=、/=、%=
//位运算
<<=、>>=、&=、^=、|=
```

```cpp
//example10.cpp
#include <iostream>
int main(int argc, char **argv)
{
    int i = 1;
    i *= 4;
    std::cout << i << std::endl; // 4
}
```

### 递增和递减运算符

\++ 与 --

```cpp
//example11.cpp
#include <iostream>
int main(int argc, char **argv)
{
    int i = 0;
    std::cout << i++ << std::endl; // 0
    //因为++在i后面，所以先以i原始值，参与运算，运算结束后再进行自增
    std::cout << i << std::endl; // 1

    std::cout << --i + 4 << std::endl; // 4
    //因为--在i前面所以i参与运算前将其先进行自减操作
    std::cout << i + 4 << std::endl; // 4
    //同理i-- 与 ++i 情况与二者类似
    return 0;
}
```

### 指针与迭代器的自增自减

```cpp
//example12.cpp
#include <iostream>
#include <vector>
using namespace std;
int main(int argc, char **argv)
{
    char *str = "0123456";
    char *ptr = str;
    // ptr先于*结合参与运算后才进行自加
    cout << *ptr++ << endl; // 0
    cout << *ptr << endl;   // 1
    // ptr现进行自加后再与*结合参与运算
    cout << *++ptr << endl; // 2

    vector<int> vec{1, 2, 3, 4};
    auto vec_iterator = vec.begin();
    for (; vec_iterator != vec.end();)
    {
        cout << *vec_iterator << endl; // 1 2 3 4
        ++vec_iterator;
    }
    return 0;
}
```

### 成员访问运算符

实例用 `.` ,迭代器或者指针用 `->`

```cpp
//example13.cpp
#include <iostream>
#include <string>
#include <vector>
using namespace std;
int main(int argc, char **argv)
{
    string s = "hiyou";
    string *p = &s;
    //--对象实例用.访问
    cout << s.c_str() << endl; // hiyou

    //--迭代器或者指针则用->访问
    cout << p->c_str() << endl; // hiyou
    vector<string> strs{"HELLO"};
    vector<string>::iterator iter = strs.begin();
    cout << iter->c_str() << endl;   // HELLO
    cout << (*iter).c_str() << endl; // HELLO

    return 0;
}
```

### 条件运算符

也可以称为三目运算符\
`expr?a:b`当表达式 expr 为真正时返回 a，否则返回 b ,同时 a 与 b 也可以为表达式、比如算式以及其也是三目运算表达式（即嵌套使用）

```cpp
//example14.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    bool t = false;
    cout << (t ? "NIHAO" : "WANLU") << endl; // WANLU
    int i = 1, j = 3;
    bool res = i > j ? true : false;
    cout << res << endl; // 0

    //嵌套使用
    string res1 = (i > j) ? ">" : i == j ? "=="
                                         : "<";
    cout << res1 << endl; //<

    return 0;
}
```

### 位运算符

位运算符作用于整数类型的运算对象，并把运算对象看成二进制位的集合，位运算符提供检查和二进制位的功能。

```cpp
~ 位求反
<< 左移
>> 右移
& 位与
^ 位异或
| 位或
```

### 移位运算符

左移运算符在右侧插入值位 0 的二进制位。\
右移运算符左侧，如果是带符号类型，则插入符号位，否则插入 0，具体情况视环境而定。

```cpp
//example15.cpp
#include <iostream>
#include <cstdio>
using namespace std;
int main(int argc, char **argv)
{
    // 10011011 char占8位 int占32位
    unsigned char bits = 0233; //八进制
    printf("%d\n", bits);      // 155
    printf("%o\n", bits);      // 233
    //在对非整形做为运算时，会先将其转变为整形
    int res = bits << 8; //左移8位
    // 00000000 00000000 10011011 00000000
    printf("%d\n", res); // 39680

    //左移31位
    bits << 31;
    // 10000000 00000000 00000000 00000000
    //右移3位
    bits >> 3;
    // 00000000 00000000 00000000 00010011
    return 0;
}
```

### 位求反运算符

即将二进制位，1 置为 0，0 置为 1

```cpp
//example16.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    // 10010111
    unsigned char bits = 0227;
    int res = ~bits;
    // 11111111 11111111 11111111 01101000
    cout << res << endl;//-152
    return 0;
}
```

### 与、或、异或

三者满足 a operstor b==b operator a\
`与`：1&1->1 1&0->0 0&0->0\
`或`: 1|1->1 1|0->1 0|0->0\
`异或`:1^1->0 0^0->1 1^0->1

它们还有 &=、|=、^=的自运算缩写形式

```cpp
//example17.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    // 01100101
    unsigned char b1 = 0145;
    // 10101111
    unsigned char b2 = 0257;
    b1 &b2;
    // 24个0 00100101
    b1 | b2;
    // 24个0 11101111
    b1 ^ b2;
    // 24个0 11001010
    return 0;
}
```

### IO 运算符的左结合律

我们可见在我们使用 cout<<时、cin>>时也是用了移位运算符，这是怎么回事呢，原理以后再说、现在要知道移位运算符满足左结合律

```cpp
//example18.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    cout << "Hi"
         << "you" << endl;
    //等价于
    ((cout << "Hi") << "you") << endl;
    cout << 4 + 1;     // 5
    cout << (10 < 42); // 1
    // cout << 10 < 42;//error 因为<<优先级比<优先级搞
    //导致一个cout对象与数值42进行比较
    return 0;
}
```

### sizeof 运算符

前面我们已经见过 sizeof 函数的使用了，但是它有什么使用规则呢，返回值有代表着什么？\
sizeof 返回的是一条表达式或一个类型名字所占的字节数，返回值类型为 size_t

使用规则:

- char 或者类型为 char 的表达式执行 sizeof，返回 1
- 对引用类型执行 sizeof 得到被引用对象所占空间
- 对指针执行 sizeof 得到指针本身所占空间
- 对引用指针执行得到指针指向的对象空间的大小，指针不需要有效
- 对数组执行 sizeof 得到整个数组的大小，等价于对每个元素执行 sizeof 求和，注意，sizeof 不会把数组转换为指针处理
- string 对象或 vector，返回该类型固定部分的大小、不会计算对象中元素占了多少空间

```cpp
//example19.cpp
#include <iostream>
#include <string>
using namespace std;
struct User
{
    int age;
    int weight;
    int height;
    char name[100];
};

int main(int argc, char **argv)
{
    //数组
    int arr[10];
    cout << sizeof arr << endl; // 40 即10*4byte

    //复合类型
    User user;
    cout << sizeof(user) << endl;   // 112 1*100+4*3=112
    cout << sizeof(string) << endl; // 24

    // string
    string str = "njfkvdkfvbdnjvdkfnvkdnfkvjdfnvnkkvbkdsdcsdfvd";
    cout << sizeof(str) << endl; // 24
    //这里输出了24 为什么，因为string是一个复合类型 其本身的大小为sizeof(string)
    //而字符串可能由内部的指针指向一个地址来进行存储了

    // type
    cout << sizeof(double) << endl; // 8

    int arr1[5] = {1, 2, 3, 4, 5};
    cout << sizeof(arr1) / sizeof(int) << endl;         // 5
    constexpr auto size = sizeof(arr1) / sizeof(*arr1); //*类型值
    int arr2[size];

    // sizeof不会把数组当指针处理
    int *ptr = arr1;
    cout << sizeof(ptr) << endl;   // 4 即sizeof(int*)
    cout << sizeof(int *) << endl; // 4
    cout << sizeof(*ptr) << endl;  // 4 即sizeof(int)

    auto &arr3 = arr2;            //数组的引用
    int(&arr4)[size] = arr2;      // int &arr[4] 是什么鬼 是存引用的数组，错，C++不允许创建引用的数组
    cout << sizeof(arr3) << endl; // 20
    cout << sizeof(arr4) << endl; // 20

    int brr[3][3] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    int((&s)[3])[3] = brr; //数组的引用
    s[1][1] = 999;
    cout << brr[1][1] << endl;  // 999
    cout << sizeof brr << endl; // 36 byte*4*4=36
    return 0;
}
```

### 逗号运算符

逗号运算符是什么呢？其实我们已经不知不觉地已经有使用过它了，逗号运算符含有两个运算对象，按照从左向右的顺序一次求值。

```cpp
//example20.cpp
#include <iostream>
#include <string>
using namespace std;
int main(int argc, char **argv)
{
    //使用逗号定义多个变量
    int i = 0, j = 0;
    int k = --i;
    cout << k << endl; //-1

    //执行多个表达式
    i--, j++;
    cout << i << endl;
    cout << j << endl;

    //通常会运用到for循环内
    string str = "himoyou";
    int loop_count = 0;
    for (size_t i = 0; i < str.length(); i++, loop_count++)
    {
        cout << str[i] << " ";
    }
    cout << endl;
    // h i m o y o u
    cout << loop_count << endl; // 7
    return 0;
}
```

### 类型转换

类型转换分为两种，一种是隐式转换，一种显式转换

### 隐式转换

```cpp
//example21.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int int_value = 3.14 + 4;
    cout << int_value << endl; // 7
    // C++不会直接将两个类型不同的值相加，而是想办法是它们转变为相同的类型
    // 上述的转换是自动处理的，不需要我们介入
    // 首先将4变为了double 4.0 然后与3.14相加后得到double 7.14
    // 将其转换为int类型，造成精度丢失
    return 0;
}
```

什么时候会发生隐式转换?

- 在大多数表达式中，比 int 类型小的整形数值首先提升为较大的整数类型
- 在条件中，非布尔值转换成布尔类型
- 初始化过程中，初始值转换成变量的类型
- 在赋值语句中，右侧运算对象转换成左侧运算对象的类型
- 如果算数运算或者关系运算表达式中有多个类型，需要先转换成同一种类型
- 函数传参时

### 算数转换

- 整形转换 将小整数转换成较大的整数类型

```cpp
//example22.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    char ch = -23;
    unsigned int i = 9;
    int j = 343;
    int up1_cast = ch;
    cout << up1_cast << endl; // -23
    long up2_cast = i;
    cout << up2_cast << endl; // 9

    //因为unsigned char 容不下 char
    //会造成精度丢失或者数据丢失
    unsigned char ch2 = ch;
    cout << (int)ch2 << endl; // 233
    return 0;
}
```

在一个算术运算时，当左右的值类型不同时，往往会将大小较小的哪一个值转换为另一个的数据类型

### 其他隐式类型转换

数组转指针、指针的转换、转换为布尔值、转换成常量、类类型转换

```cpp
//example23.cpp
#include <iostream>
int main(int argc, char **argv)
{
    //数组转指针
    int arr[10];
    int *arr_ptr = arr; // arr即数组的头地址

    //指针的转换
    char *ch_ptr = nullptr;
    void *ch_ptr1 = nullptr;
    //整数0 或者 nullptr可转换成任意指针类型

    //转换成布尔类型
    //在C++中非数值零的数在做逻辑判断时，都会为1即true
    if (ch_ptr1)
    {
        std::cout << "ch_ptr1 not equal nullptr and 0" << std::endl;
    }

    int i = 23, j = 342;
    const int &k = i; //非常量转换成cosnt int的引用
    // k = j; error
    const int *p = &i; //非常量的地址换成const的地址
    // int &m = k; int*q=p;
    //不允许从const转换成非常量
    return 0;
}
```

### 显示转换

显式地将对象强制转换成另一种类型。

### C 语言的强制类型转换

```cpp
//example24.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int i = 3, j = 7;
    double q = (double)i / j;
    cout << q << endl; // 0.428571
    q = i / j;
    cout << q << endl; // 0
    //先按照整数除法得到了0，然后转为double类型
    double p = (double)i;
    //即使用(target-type)variablename进行强制类型转换
    return 0;
}
```

而在 C++中，它提供了另一种方案，它们其实知识语法上的不同，我们选一个喜欢的就好。

### static_cast

相当于 C 语言的强制转换方案

```cpp
//example25.cpp
#include <iostream>
#include <typeinfo>
using namespace std;
int main(int argc, char **argv)
{
    int i = 23;
    double double_var = static_cast<double>(i);
    const int j = 54;
    const double double_var1 = static_cast<const double>(j);
    cout << i << endl; // 23
    cout << j << endl; // 54

    int *p = &i;
    void *i_void_ptr = p;
    int *q = static_cast<int *>(i_void_ptr);
    cout << *q << endl;                    // 23
    cout << typeid(i).hash_code() << endl; // 3616029859
    cout << typeid(i).name() << endl;      // i

    //不能转换底层const?
    int &g = i;
    int &f = static_cast<int &>(g);
    cout << f << endl; // 23
    const int &v = i;
    const int &h = static_cast<const int &>(v); // right
    // int &m = static_cast<int &>(v); //error
    //如果要去掉底层const则要使用const_cast
    return 0;
}
```

### const_cast

只能改变运算对象的底层 const\
const_cast 中的类型必须是指针、引用或指向对象类型成员的指针

```cpp
//example26.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    char i = '3';
    const char *pc = &i;
    //*pc = 'd';  error: assignment of read-only location '* pc'
    //如果我们想要去掉底层const怎么办
    char *pc1 = const_cast<char *>(pc);
    *pc1 = ']';
    cout << i << endl; //]
    //惊天了 还有这种操作

    int c = 23;
    const int &j = i;
    // j = 23; assignment of read-only reference 'j'
    int &m = const_cast<int &>(j);
    m = 666;
    cout << c << endl; // 23
    //简直逆天了好吧，要避免使用这种玩意，我们有目的的加底层cosnt
    //又去除指针或引用的底层const，有病啊，要避免这种用法
    //以免把自己搞晕，使用成本比较高
    return 0;
}
```

### reinterpret_cast

提供了一种切换从内存解释的方法,怎么理解呢?

```cpp
//example27.cpp
#include <iostream>
#include <cstring>
#include <cstdio>
using namespace std;
int main(int argc, char **argv)
{
    int arr[1];
    int *arr_ptr = arr;
    char *chs = reinterpret_cast<char *>(arr_ptr);
    chs[0] = '1';
    chs[1] = '2';
    chs[2] = '3';
    chs[3] = '4';
    // chs[4] = '5'; error 因为arr内存大小为1*4byte
    // 一个字符大小为1yte
    //则原来内存可以存储4个字符
    for (std::size_t i = 0; i < 4; i++)
    {
        cout << chs[i] << endl;
    }
    // 16进制输出
    printf("%x\n", arr[0]); // 34333231
    cout << arr[0] << endl; // 875770417
    // HEX 34333231
    // BIN 0011 0100 0011 0011 0011 0010 0011 0001
    // OCT 6 414 631 061
    // DEC 875,770,417

    // FIRST 8BIT 0011 0100
    // HEX 34
    // DEC 52
    // OCT 64

    // BIN 0011 0100 0011 0011 0011 0010 0011 0001
    // ASCII  52         51       50        49
    // CHAR   '4'        '3'      '2'       '1'

    //为什么是反着存储的呢
    //因为对于int的内存使用都是从低位开始使用的，也就是内存的起始地址在右边
    return 0;
}
```

### dynamic_cast

dynamic_cast 支持运行时类型识别，将在后面 第 19 章 特殊工具与技术中运行时类型识别部分学习

### 运算符优先级表

不是人记的，了解即可。越往下的层优先级越低，同层的优先级相同

```cpp
--------------------------------------------------
结合律和运算符          功能        用法
左 ::               全局作用域     ::name
左 ::               类作用域       class::name
左 ::               命名空间作用域  namespace::name
--------------------------------------------------
左 .                成员选择        object.member
左 ->               成员选择        pointer->member
左 []               下标            expr[expr]
左 ()               函数调用        name(expr_list)
左 ()               类型构造        type(expr_list)
--------------------------------------------------
右 ++               后置递增运算    lvalue++
右 –                后置递减运算    lvalue–
右 typeid           类型ID          typeid(type)
右 typeid           运行时类型ID    typeid(type)
右 explicit cast    类型转换        cast_name(expr)
--------------------------------------------------
右 ++               前置递增运算    ++lvalue
右 ==               前置递减运算    –lvalue
右 ~                位求反          ~expr
右 !                逻辑非          !expr
右 -                一元负号        -expr
右 +                一元正号        +expr
右 *                解引用          *expr
右 &                取地址          &lvalue
右 ()               类型转换        (type)expr
右 sizeof           对象的大小      sizeof expr
右 sizeof           类型的大小      sizeof(type)
右 sizeof           参数包的大小    sizeof…(name)
右 new              创建对象        new type
右 new[]            创建数组        new type[size]
右 delete           释放对象        delete expr
右 delete[]         释放数组        delete [] expr
右 noexcept         能否抛出异常    noexcept(expr)
--------------------------------------------------
左 ->*              指向成员选择的指针 ptr->*ptr_to_member
左 .*               指向成员选择的指针 obj.*ptr_to_member
--------------------------------------------------
左 *                乘法            expr * expr
左 /                除法            expr / expr
左 %                取模            （取余） expr % expr
--------------------------------------------------
左 +                加法            expr + expr
左 -                减法            expr - expr
--------------------------------------------------
左 <<               向左移位        expr << expr
左 >>               向右移位        expr >> expr
--------------------------------------------------
左 <                小于            expr < expr
左 <=               小于等于         expr <= expr
左 >                大于            expr > expr
左 >=               大于等于         expr >= expr
--------------------------------------------------
左 ==               相等            expr == expr
左 !=               不相等          expr != expr
--------------------------------------------------
左 &                位与            expr & expr
--------------------------------------------------
左  ^               位异或            expr ^ expr
--------------------------------------------------
左 |                位或            expr | expr
--------------------------------------------------
左 &&               逻辑与          expr && expr
--------------------------------------------------
左 ||               逻辑或          expr || expr
--------------------------------------------------
右 ? :              条件            expr ? expr : expr
--------------------------------------------------
右 =                赋值            lvalue = expr
右*=，/=，%=        复合赋值         lvalue+=expr
右 +=，-==          复合赋值         lvalue+=expr
右 <<=, >>=         复合赋值         lvalue+=expr
右 &=, =, ^=        复合赋值
--------------------------------------------------
右                  throw 抛出异常  throw expr
--------------------------------------------------
左 ,                逗号            expr, expr
--------------------------------------------------
```
