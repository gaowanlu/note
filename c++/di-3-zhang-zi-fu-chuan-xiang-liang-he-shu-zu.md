---
cover: >-
  https://images.unsplash.com/photo-1651338520042-9c5d50e4b4ff?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI1NDAxNzQ&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 💪 第3章 字符串、向量和数组

## 第3章 字符串、向量和数组

### 命名空间的using声明

目前为止我们使用的库函数基本都属于命名空间std，如std::cin 、std::cout。其中`::`我们称其为作用域操作符，编译起编译起从操作符左侧名字的作用域寻找右侧那个名字。

但是上面很繁琐、允许我们通过using声明

```cpp
//example1.cpp
#include<iostream>
using std::cout;
using std::endl;
int main(int argc,char**argv){
    const char*name="gaowanlu";
    cout<<name<<endl;//gaowanlu
    std::cout<<name<<std::endl;//gaowanlu
    return 0;
}
```

这样在这个cpp内使用std::cout与std::endl时就可以省略写std::了,但是仍然允许我们显式指定其明明空间

### 头文件不应包含using声明

头文件一般不使用using声明，因为头文件的内容会被拷贝到，include它的cpp去，如果头文件有using声明，则那些cpp内也会有这些using声明，可能会引起明明冲突

```cpp
//example2.h
#ifndef __EXAMPLE2_H__
#define __EXAMPLE2_H__

using std::cout;

#endif
```

当第4行代码不被注释掉时，则会引入using std::cout; 当main函数内使用cout，编译器则不会知道知道我们要使用std::cout还是自定义的cout，进而产生命名出错

总之不要在头文件内使用using声明

```cpp
//example2.cpp
#include<iostream>
#include<cstdio>

//#include"./example2.h"

int cout(){
    printf("printf hallo");
}

int main(int argc,char**argv){
    cout();//printf hallo
    return 0;
}
```

### 标准库类型string

首先要导入 `#include<string>` 其命名空间为 `std::string`

在C语言中是没有字符串类型的，但可以用字符数组进行存储，以 `\0` 表示字符串结束

### 定义和初始化string对象

6种直接初始化方式、1种拷贝初始化方式

```cpp
    1、string s5;          //空串
    2、string s6(s5);      // s6为s5的副本 也就是拷贝s5到s6
    3、string s7 = "ak47"; // s7为字面值的副本
    4、string s8 = s7;
    5、string s9("94");
    6、string s10(1, 'h');
    7、string s11=std::string("hello world");
```

样例程序

```cpp
//example3.cpp
#include <iostream>
#include <string>
using std::cout;
using std::endl;
using std::string;
int main(int argc, char **argv)
{
    string s1; //默认初始化为空字符串
    string s2 = "gaowanlu";
    string s3 = s2; // s3为s2内容的副本
    string s4(4, 'a');
    cout << s2 << endl; // gaowanlu
    cout << s3 << endl; // gaownalu
    cout << s4 << endl; // aaaa

    // string的7种初始化方式
    // 6种直接初始化方式
    string s5;          //空串
    string s6(s5);      // s6为s5的副本 也就是拷贝s5到s6
    string s7 = "ak47"; // s7为字面值的副本
    string s8 = s7;
    string s9("94");
    string s10(1, 'h');
    cout << s5 << endl;  //
    cout << s6 << endl;  //
    cout << s7 << endl;  // ak47
    cout << s8 << endl;  // ak47
    cout << s8 << endl;  // ak47
    cout << s9 << endl;  // 94
    cout << s10 << endl; // h
    // 1种拷贝初始化
    string s11 = std::string("hello world");
    cout << s11 << endl; // hello world
    return 0;
}
```

### 关于字符串长度的大坑

如果我们需要存储含有\0的字符串数据，请勿使用std::string进行存储，因为一旦使用它是从\0后的字符进行了忽略，例如在http的报文内如果请求体或响应体内为二进制数据，那么我们按照字符来读取，极有可能造成大祸，甚至一整天不知道bug在哪里，所以我们应该在学习的时候就知道这回事

```cpp
//example41.cpp
#include <iostream>
#include <string>
int main(int argc, char **argv)
{
    std::string str = "bcjhdf\0fej";
    std::cout << str.length() << std::endl; // 6
    std::string str1 = str + "sc\0ncjsk";
    std::cout << str1 << std::endl; // bcjhdfsc
    return 0;
}
```

#### string对象上的操作

在C++中string是一种标准库里的对象,其支持丰富的操作

```cpp
//example4.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    string s1("hello world");
    string s2 = "hello world";
```

支持写入到输出流 outputstream<\<str

```cpp
    cout << s1 << endl; // hello world
```

同理支持从输入流写入到字符串 inputstream>>s1

```cpp
    // cin>>s1;
```

从输入流中读取一行到字符串getline(inputstream,str)

```cpp
    // getline(cin, s1); //这里我们使用标准输入流
    // cout << s1 << endl;
```

检测字符串是否为空字符串 str.empty()

```cpp
    cout << s1.empty() << endl; // false 则s1不为空
```

获取字符串长度

```cpp
    cout << s1.size() << endl; // 11
```

获取第n个字符的引用 n 0开始为第一个字符

```cpp
    char &ch = s1[0];
    ch = 'p';
    s1[3] = 'k';
    cout << s1 << endl; // pelko world
```

字符串拼接

```cpp
    string s3 = s1 + s2;
    s3+="";//支持+=
    cout << s3 << endl;          // pelko worldhello world
    cout << s3 + "HAHA" << endl; // pelko worldhello worldHAHA
```

字符串复制

```cpp
    string s4 = s3;
```

s4与s3没有关系，只是内容相同，它们的数据存放在不同的内存上面

```cpp
    cout << s4 << endl; // pelko worldhello world
```

字符串的比较

```cpp
    cout << (s3 == s4) << endl; // 1 即true
    cout << (s3 != s4) << endl; // 0 即false
```

字典顺序比较

```cpp
    string s5 = "abcd";
    string s6 = "abda";
    cout << (s5 < s6) << endl;  // 1 abcd abda c<d
    cout << (s5 <= s6) << endl; // 1 abcd abda c<=d
    cout << (s5 > s6) << endl;  // 0 abcd abda c<d
    cout << (s5 >= s6) << endl; // 0 abcd abda c<=d
    return 0;
}
```

### getline函数的返回值

```cpp
//example5.cpp
#include <iostream>
#include <string>
using namespace std;
int main(int argc, char **argv)
{
    string s1;
    while (getline(cin, s1)) // getline返回文件到达末尾也就是cin流的内容是否全部到头
    {
        cout << s1 << endl;
    }
    //只有退出程序时cin才会关闭以至于getline返回false
    //与其类似的操作还有
    /*
    while (cin >> s1)
    {
        cout << s1 << endl;
    }*/
    return 0;
}
```

### std::string::size\_type类型

其字符串size()方法返回值用什么类型存储比较好，C++为我们提供了std::string::sizetype类型

```cpp
//example6.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    std::string s1("hello");
    std::string::size_type s1_length = s1.size();
    cout << s1_length << endl;                      // 5
    cout << sizeof(std::string::size_type) << endl; // 4
    
    // str.size()返回一个无符号整数
    //当然我们可以使用我们前面学到的auto 与 decltype
    auto l1 = s1.size();
    decltype(s1.size()) l2 = s1.size();
    cout << l1 << endl; // 5
    cout << l2 << endl; // 5

    //当然可以用unsigned 或者 int
    unsigned l3 = s1.size();
    int l4 = s1.size();
    cout << l3 << " " << l4 << endl; // 5 5
    return 0;
}
```

### 字符串相加要注意的事

字符串字面值不能与字符串字面值相加、相加对于string对象有效，即+号的左右至少有一个string对象

```cpp
//example7.cpp
#include <iostream>
#include <string>
using namespace std;
int main(int argc, char **argv)
{
    //字符串对象与字符串对象相加返回字符串对象
    //字符串对象与字面值相加返回字符串对象
    //字面值与字面值相加发生错误

    // string s1 = "12" + "sdc";
    //  invalid operands of types 'const char [3]' and 'const char [4]' to binary 'operator+'
    //字面值被作为const char[] 处理

    string s2 = "a";
    s2 = s2 + " b " + "c ";
    //(s2+" b ")+"c "
    cout << s2 << endl; // a b c

    return 0;
}
```

这是为什么呢，C++为了与C语言兼容，所以C++语言中的字符串并不是作为std::stirng对象处理的

### 处理string对象中的字符

`#include<cctype>`

```cpp
isalnum(c);//当c是字母或数字时为真
isalpha(c);//当c是字母时返回真
iscntrl(c);//当c是控制字符时为真
isdigit(c);//当c是数字时为真
isgraph(c);//当c不是空格但可以打印时为真
islower(c);//当c是小写字母时为真
isprint(c);//当c是可打印字符时为真（即c是空格或c具有可视化形式）
ispunct(c);//当c是标点符号时为真（不是控制字符、数字、字母、可打印空白）
isspace(c);//当c是空白时为真（即是空格、横向制表符、纵向制表符、回车符、换行符、进纸符）
isupper(c);//当c为大写字母时为真
isxdigit(c);//当c是十六进制数字时为真
tolower(c);//如果c是大写字母，输出对应的小写字母，否则原样输出c
toupper(c);//如果是小写字母、输出对应的大写字母，否则原样输出
```

如toupper使用

```cpp
//exmaple8.cpp
#include <iostream>
#include <cctype>
using namespace std;
int main(int argc, char **argv)
{
    string s1 = "abc";
    s1[1] = toupper(s1[1]);
    cout << s1 << endl; // aBc
    return 0;
}
```

### 遍历字符串字符

C++对于字符串的遍历支持迭代器模式

```cpp
//example9.cpp
#include <iostream>
#include <string>
#include <cctype>
using namespace std;
int main(int argc, char **argv)
{
    string s1 = "abc";
    for (char &ch : s1)
    {
        cout << ch << endl; // abc
        ch = toupper(ch);
    }
    cout << s1 << endl; // ABC
    //当然我们可以使用auto
    for (auto ch : s1)
    {
        cout << ch << endl; // ABC
        ch = tolower(ch);
    }
    cout << s1 << endl; // ABC
    //可见auto是类型char而不是char&
    return 0;
}
```

### 下标的随机访问

```cpp
//example10.cpp
#include <iostream>
#include <string>
using namespace std;
int main(int argc, char **argv)
{
    string s1 = "abcd";
    //例如访问最后一个字符
    if (s1.empty() == false)
    {
        cout << s1[s1.size() - 1] << endl; // d
    }
    //字符下标索引从0开始
    // a b c d
    // 0 1 2 3
    return 0;
}
```

### 标准库类型vector

std::vector表示对象的集合，其所有元素类型相同，每个集合中对每个对象有唯一的对应索引，用于随机访问，因为vector容纳其他对象，所以也被称为容器。其背后有一个重要的概念叫做类模板的东西在支持着它，类模板是C++特性之一，其非常强大。

std::vector\<T> T可以为任意数据类型

### 定义和初始化vector

七种初始化方式 以T为int为例

```
vector<int> v1;                //空vector
vector<int> v2(v1);            //拷贝v1 v2拥有v1元素的副本
vector<int> v3 = v2;           //拷贝v2 v3拥有v2元素的副本
vector<int> v4(5, 10);         // vector内有5个10
vector<int> v5(5);             // 5个int类型初始默认值元素即有5个0
vector<int> v6 = {1, 2, 3, 4}; // 元素序列为1 2 3 4
vector<int> v7{1, 2, 3, 4};    //等价于vector<int> v6={1, 2, 3, 4}
```

使用样例

```cpp
//example11.cpp
#include <iostream>
#include <vector>
using std::cout;
using std::endl;
using std::vector;
void printIntVector(vector<int> &v);
int main(int argc, char **argv)
{
    vector<int> v1;                //空vector
    vector<int> v2(v1);            //拷贝v1 v2拥有v1元素的副本
    vector<int> v3 = v2;           //拷贝v2 v3拥有v2元素的副本
    vector<int> v4(5, 10);         // vector内有5个10
    vector<int> v5(5);             // 5个int类型初始默认值元素即有5个0
    vector<int> v6 = {1, 2, 3, 4}; // 元素序列为1 2 3 4
    vector<int> v7{1, 2, 3, 4};    //等价于vector<int> v6={1, 2, 3, 4}
    printIntVector(v1);            //
    printIntVector(v2);            //
    printIntVector(v3);            //
    printIntVector(v4);            // 10 10 10 10 10
    printIntVector(v5);            // 0 0 0 0 0
    printIntVector(v6);            // 1 2 3 4
    printIntVector(v7);            // 1 2 3 4
    return 0;
}

/**
 * @brief 打印vector<int>元素
 *
 * @param v vector<int>
 */
void printIntVector(vector<int> &v)
{
    for (int i = 0; i < v.size(); i++)
    {
        cout << v[i] << " ";
    }
    cout << endl;
}
```

### 向vector内添加元素

vector允许我么在定义初始化后，对其内部的元素再进行操作，例如向其后面追加元素

```cpp
//example12.cpp
#include <iostream>
#include <string>
#include <vector>
using namespace std;
void printStringVector(vector<string> &v)
{
    for (int i = 0; i < v.size(); i++)
    {
        cout << v[i] << " ";
    }
    cout << endl;
}
int main(int argc, char **argv)
{
    vector<string> v1 = {"a", "b", "c"};
    printStringVector(v1); // a b c
    v1.push_back("d");
    v1.push_back("e");
    printStringVector(v1);  // a b c d e
    vector<string> v2 = v1; //拷贝v1到v2
    v2[0] = "p";
    printStringVector(v1); // a b c d e
    printStringVector(v2); // p b c d e
    return 0;
}
```

### vector其他操作

vector提供的方法与string提供的方法类似，可以向上翻到string进行对比学习

vector.empty()、vector.size()、vector.push\_back(T)、下标引用、拷贝、列表替换、==、!=、<、<=、>、>=

```cpp
//example13.cpp
#include <iostream>
#include <string>
#include <vector>
using namespace std;
int main(int argc, char **argv)
{
    vector<char> v;
    v.empty();               //如果v不含任何元素，则返回真，否则返回假
    v.size();                //返回元素个数
    v.push_back('a');        //向末尾追加元素
    char &ch_index_0 = v[0]; //获取第n个位置元素的引用
    vector<char> v1;
    v1 = v;               //将v内的元素拷贝给v1
    v1 = {'a', 'b', 'c'}; //使用列表替换vector内存储的内容
    vector<char> v2(v1);
    //当vector二者元素个数相同，且每个位置上一一对应都是相等的则为true否则为false
    cout << (v1 == v2) << endl; // 1
    cout << (v1 != v2) << endl; // 0
    //二者元素数量不同或者对应位置有元素不相等返回true，否则返回false
    v1 = {'a', 'b', 'c'};
    v2 = {'a', 'd'};
    //支持字典顺序比较
    cout << (v1 <= v2) << endl; // 1
    cout << (v1 < v2) << endl;  // 1
    cout << (v1 >= v2) << endl; // 0
    cout << (v1 > v2) << endl;  // 0
    return 0;
}
```

### 遍历vector

关于下标访问，有一点我们必须要知道下标的范围是从0开始到vector.size()-1,无论新开发者还是有经验的大佬，在写程序时预检下标访问越界问题都是很常见的

```cpp
//example14.cpp
#include <iostream>
#include <string>
#include <vector>
using namespace std;
int main(int argc, char **argv)
{
    vector<char> v{'a', 'b', 'c'};
    //下标访问
    for (vector<int>::size_type i = 0; i < v.size(); i++)
    {
        cout << v[i] << endl; // a b c
    }
    // vector<int>::size_type背后是
    // typedef std::size_t std::vector<int>::size_type的功劳

    //迭代器访问
    for (auto &item : v)
    {
        cout << item << endl; // a b c
        item += 1;
    }
    for (auto item : v)
    {
        cout << item << endl; // b c d
    }
    //当然可以不用auto
    for (char item : v)
    {
        cout << item << endl; // b c d
    }
    return 0;
}
```

迭代器是什么，不要慌迭代器在下一小节即将学习

### 不能用下标的形式添加元素

只要知道我们不能在下标访问时发生访问越界就好了

```cpp
//example15.cpp
#include <iostream>
#include <string>
#include <vector>
using namespace std;
int main(int argc, char **argv)
{
    vector<int> v; //空vector
    decltype(v.size()) i = 0;
    //错误方式 向数组添加元素
    // for (; i < 10; i++)
    // {
    //     v[i] = i;
    // }
    //我们会发现其本质还是下标访问越界了

    //要向vector中追加元素就要使用vector.push_back()
    //否则只能使用下标0到vector.size()-1的位置的空间
    for (i = 0; i < 10; i++)
    {
        v.push_back(i);
    }
    for (auto item : v)
    {
        cout << item << endl;
    }
    // 0 1 2 3 4 5 6 7 8 9
    return 0;
}
```

### 多维vector

因为std::vector\<T>可以T可以为任意类型,那么T可以为vector也是情理之中的

```cpp
//example16.cpp
#include <iostream>
#include <string>
#include <vector>
using namespace std;
int main(int argc, char **argv)
{
    vector<vector<int>> v;
    vector<int> v1 = {1, 2, 3};
    vector<int> v2 = {4, 5};
    v.push_back(v1); //将向量添加到vector v
    v.push_back(v2);
    //下标访问vector v内的元素，其元素类型为vector<int>
    vector<int> &item_1 = v[0];
    auto &item_2 = v[1];
    cout << item_1.size() << endl; // 3
    cout << item_2.size() << endl; // 2
    cout << v.size() << endl;      // 2
    return 0;
}
```

vector还有许多有用的操作、我们后学进行学习、慢慢地展开循序渐进学习

### 迭代器介绍

我们学过我们可以通过下标来访问string的字符、vector的元素的引用。有一种更通用的方式叫做迭代器，迭代器不是仅仅限于vector的，其他的容器等也都支持。string是字符串不是容器，但其也支持迭代器的使用。

### 使用迭代器

begin()获取容器第一个位置迭代器\
end()获取容器最后一个元素后面一个位置的迭代器\
\--、++、-、+、+=、-= 等迭代器移动\
\== 迭代器比较\
\= 迭代器赋值\
\-> 使用元素内部成员\
\* 解引用操作

```cpp
//example17.cpp
#include <iostream>
#include <vector>
using namespace std;
int main(int argc, char **argv)
{
    vector<int> v{1, 2, 3, 4};
    std::vector<int>::iterator start = v.begin(); // start指向第一个元素
    auto end = v.end();                           // end指向最后一个元素的下一个位置

    //*iterator获取元素引用
    int &firstEl = *start;   //获取start所在位置元素的引用
    cout << firstEl << endl; // 1
    firstEl = 9;
    cout << v[0] << endl; // 9

    // iter->mem 获取元素的成员
    vector<string> v1 = {"hello", "world", "ok"};
    auto v1_b = v1.begin();
    cout << v1_b->size() << endl;   // 5
    cout << (*v1_b).size() << endl; // 5

    //++iter 让迭代器向后移动一个位置
    v1_b++;
    cout << *v1_b << endl; // world
    //--iter 让迭代器向前移动一个位置
    v1_b--;
    cout << *v1_b << endl;
    //+ 与 - 数值 移动迭代器多少次
    v1_b += 2;
    cout << *v1_b << endl; // ok

    // iter1==iter2 判断迭代器是都相等
    v1_b++;
    cout << (v1_b == v1.end()) << endl; // 1

    // iter1!=iter2 判断迭代器是否不相等
    cout << (v1_b != v1.end()) << endl; // 0

    //遍历
    for (auto b = v1.begin(); b != v1.end(); b++)
    {
        cout << *b << " length " << b->size() << endl;
        // hello length 5 \n world length 5 \n ok length 2
    }
    return 0;
}
```

### 迭代器类型

不同容器有不同类型的迭代器类型，string类型的迭代器为C++为我们指定好的为string::iterator类型，string与vector类似支持begin()与end()方法

```cpp
//example18.cpp
#include <iostream>
#include <vector>
using namespace std;
int main(int argc, char **argv)
{
    //存放int类型的vector
    vector<int> v{1, 2, 3};
    std::vector<int>::iterator b = v.begin();
    //当然可以使用decltype与auto进行自动推断类型
    decltype(v.begin()) b1 = v.begin();
    auto b2 = v.begin();
    cout << *b1 << endl; // 1

    // string迭代器
    string str = "hello";
    string::iterator str_iter = str.begin();
    while (str_iter != str.end())
    {
        cout << *str_iter << endl; // hello
        *str_iter = 'N';
        str_iter++;
    }
    cout << str << endl; // NNNNN
    return 0;
}
```

### const\_iterator

可见iterator允许我们进行\*操作得到相应元素的引用、进而我们可以改变元素的值，有时我们需要const的功能，不允许使用迭代器改变元素，只能读，这时候就要派const\_iterator上场了

```cpp
//example19.cpp
#include <iostream>
#include <vector>
#include <string>
using namespace std;
int main(int argc, char **argv)
{
    vector<int> v{1, 2, 3};
    vector<int>::const_iterator b = v.begin();
    while (b != v.end())
    {
        cout << *b << endl; // 1 2 3
        //*b = 9;
        // assignment of read-only location 'b.__gnu_cxx::__normal_iterator<const int*, std::vector<int> >::operator*()'
        b++;
    }
    string str = "hello";
    string::const_iterator ch = str.begin();
    while (ch != str.end())
    {
        //*ch = 'P';
        // assignment of read-only location 'ch.__gnu_cxx::__normal_iterator<const char*, std::__cxx11::basic_string<char> >::operator*()'
        cout << *(ch++) << endl; // hello
    }
    return 0;
}
```

### const vector 与 cosnt\_iterator

const vector的迭代器类型 const\_iterator，显式获取const\_iterator cbegin()与cend()

```cpp
//example20.cpp
#include <iostream>
#include <vector>
using namespace std;
int main(int argc, char **argv)
{
    const vector<int> v1 = {1, 2, 3};
    vector<int> v2 = {4, 5, 6};
    // v1 = v2;
    // passing 'const std::vector<int>' as 'this' argument discards qualifiers [-fpermissive]
    // v1是不可变的
    const vector<int> v3 = {7, 8, 9};

    // const vector的迭代器
    // vector<int>::iterator b = v3.begin();
    // conversion from '__normal_iterator<const int*,[...]>' to non-scalar type '__normal_iterator<int*,[...]>' requested

    //可见begin与end返回的不是普通的iterator而是const_iterator
    vector<int>::const_iterator b1 = v3.begin();
    //*b1 = 4;
    // assignment of read-only location 'b1.__gnu_cxx::__normal_iterator<const int*, std::vector<int> >::operator*()'
    // cosnt_iterator不允许使用迭代器改变元素

    //如何指定获取const_iterator 可以使用cbegin() 与 cend()
    auto v2_b = v2.cbegin();
    auto v2_e = v2.cend();
    //*v2_b = 1; //error
    return 0;
}
```

### 迭代器失效

改变vector长度的操作会使得迭代器失效,也就是当vector的size发生改变时我们仍要使用迭代器就要重新使用begin或者end方法获取新的迭代器

```cpp
//example21.cpp
#include <iostream>
#include <vector>
using namespace std;
int main(int argc, char **argv)
{
    vector<int> v = {1, 2, 3};
    auto b = v.begin();
    // for (int i = 0; b != v.end(); b++, i++)
    // {
    //     v.push_back(i);
    //     cout << *b << endl;
    // }
    //会输出乱序的数值序列，并且程序崩溃
    // vector的size改变后，原来的迭代会失效
    vector<int> v2 = {5, 6, 7};
    vector<int>::iterator v_b = v.begin();
    v.push_back(8);
    cout << *v_b << endl; // 9674392
    return 0;
}
```

### 迭代器运算

迭代器支持 +、-、+=、-=、<、>、<=、>=等操作 在算数运算中、iterator犹如一个存放当前下标数字类型

```cpp
//example22.cpp
#include <iostream>
#include <vector>
using namespace std;
int main(int argc, char **argv)
{
    vector<int> v = {1, 2, 3};
    auto b = v.begin();
    auto e = v.end();
    cout << e - b << endl; // 3
    cout << b - e << endl; //-1
    /* el    1  2  3
     * index 0  1  2  3
     *       b        e
     */
    // 3-0=3 0-3=-3
    //这样只是辅助我们理解，其背后的元素不是这样的
    //同理iter+=n; iter=iter+n; ++iter; 就是将iterator向右移动几下
    // iter-=n; --iter; iter=iter-n; 就是向左移动
    //迭代器的算术运算返回的是迭代器而不是数字，数字只是辅助我们理解
    //如
    auto r = b + (e - b) / 2;
    cout << *r << endl; // 2  0+(3-0)/2=3/2=1 即得到index=1位置的迭代器

    //同理 比较运算也是类似于index的比较
    cout << (b > e) << endl; // 0 即false
    return 0;
}
```

### 数组

数组是一块连续内存、将这些内存分割成相同的大小、每个大小为数据类型需要的大小。

### 定义和初始化内置数组

```cpp
//example23.cpp
#include <iostream>
#include <string>
using namespace std;
int main(int agrc, char **argv)
{
    int arr[10];   //元素类型为int的大小为10的数组
    int *parr[10]; //元素类型为int*
    constexpr int size = 10;
    int arr1[size];
    //默认情况数组内元素被初始化按照元素类型的默认初始化值
    //显示初始化数组
    int arr1[5] = {0, 1, 2, 3, 4};
    int arr2[] = {0, 1, 2};
    int arr3[5] = {0, 1, 2}; // arr3[0]=1,arr3[1]=1,arr3[2]=2
    std::string arr4[3] = {"hello", "world", "tom"};
    return 0;
}
```

### 字符数组的特殊性

字符数组可以用来存储C风格字符串

在C++规范内，在定义数组时\[]内必须为常量表达式（但有的编译器允许使用变量），当常量表达式为空是定义数组必须使用列表赋值={elements...}进行初始化。

```cpp
//example24.cpp
#include <iostream>
#include <string>
using namespace std;
int main(int agrc, char **argv)
{
    char a3[] = "HELLO"; // a3={'H','E','L','O','\0'}
    a3[1] = 'P';
    cout << a3 << endl; // HPLLO
    const char a4[6] = "HELLO";
    cout << a4 << endl; // HELLO
    // a4 = nullptr; error: assignment of read-only variable 'a4'
    //数组不允许拷贝和对数组赋值
    /*
    int a5[] = {0, 1, 2};
    int a6[] = a;
    a6 = a5;*/
    return 0;
}
```

### 理解复杂的数组声明

值得一提的是引用没有数组，即不存在引用的数组

```cpp
//example25.cpp
#include <iostream>
#include <string>
using namespace std;
int main(int agrc, char **argv)
{
    int *ptrs[10]; //存储10个int*
    // int &refs[10]; //不能使用数组存储int&
    int arr[10]{0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    int(*arr1)[10] = &arr;      // arr1指向一个含有10个整数的数组
    int(&arr2)[10] = arr;       // arr2引用一个含有10个整数的数组
    cout << *(arr1)[0] << endl; // 0
    cout << arr2[1] << endl;    // 1
    int *(&array)[10] = ptrs;   // array是数组的引用、该数组存储10个int类型的指针
    return 0;
}
```

一看到这么多的、肯定学习的同学马上放弃C++、想要理解数组声明的含义，好办法是从数组的名字开始按照由内向外顺序阅读。

### 访问数组元素

```cpp
//example26.cpp
#include <iostream>
#include <string>
#include <stddef.h>
using namespace std;
int main(int agrc, char **argv)
{
    //数组的元素访问方式为下标访问
    //与vector一样下标是从0开始的
    int arr[10] = {1};
    for (int i = 0; i < 10; i++)
    {
        arr[i] = i;
    }
    for (size_t i = 0; i < 10; i++)
    {
        cout << arr[i] << " ";
    }
    cout << endl;
    // 0 1 2 3 4 5 6 7 8 9
    //数组的索引值通常使用 size_t 类型表示
    //其本质为 unsigned long long 类型
    //其定义在<stddef.h>
    //虽然表示的范围比较大、但是它需要的内存空间为4字节
    return 0;
}
```

### 遍历数组

数组在C++同样支持迭代器模式,当然我们仍可使用for循环配和下标访问

```cpp
//example27.cpp
#include <iostream>
#include <string>
#include <stddef.h>
using namespace std;
int main(int agrc, char **argv)
{
    constexpr int size = 5;
    string arr[size] = {};
    for (auto &str : arr)
    {
        cout << str << endl; //输出空字符串
        str = "HELLO";
    }
    for (auto str : arr)
    {
        cout << str << endl; //五个HELLO
    }
    for (int i = 0; i < size; i++)
    {
        cout << arr[i] << endl; //五个HELLO
    }
    return 0;
}
```

### 指针和数组

在C语言中，指针与数组有很大的联系

```cpp
//example28.cpp
#include <iostream>
#include <string>
using namespace std;
int main(int argc, char **argv)
{
    string nums[] = {"1", "2", "3"};
    string *p = nums;
    cout << *p << endl; //
    //本质上nums是数组第一个元素的地址
    //且数组的内存是连续的
    cout << *(p + 1) << endl; // 2
    // p+1即可得到nums数组第二个元素的地址

    //配和auto使用
    // auto p1 = nums;
    auto p1(nums);
    cout << *p1 << endl; // 1

    //&nums[0]与nums等价
    cout << *(&nums[0]) << endl; // 1

    decltype(nums + 0) ptr = nums + 1;
    cout << *ptr << endl; // 2 nums+0返回的是string*类型
    //指针也是迭代器
    ptr++;
    cout << *ptr << endl; // 3

    return 0;
}
```

### 标准库函数begin和end

```cpp
//example29.cpp
#include <iostream>
#include <string>
using namespace std;
int main(int argc, char **argv)
{
    //尽管我们可以通过&array[0]、&array[n-1]获得尾后指针
    //但C++为我们提供了begin和end函数
    int nums[] = {1, 2, 3, 4};
    auto beg = begin(nums);
    int *last = end(nums);
    cout << *beg << endl;        // 1
    cout << *(last - 1) << endl; // 4
    last++;
    return 0;
}
```

### 指针运算与解引用

```cpp
//example30.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    //指针的运算类似于迭代器的运算
    //但是二者也有不同之处
    int nums[4] = {1, 2, 3, 4};
    int *ptr = nums;
    ptr++;                                   //向后移动一个位置
    --ptr;                                   //向左移动
    ptr + 1;                                 //返回ptr右边元素的地址
    ptr - 1;                                 //返回ptr左边元素的地址
    cout << end(nums) - begin(nums) << endl; // 4
    int *beg = begin(nums);
    int *eptr = end(nums);
    cout << (eptr > beg) << endl; // 1

    //解引用要注意的事情
    cout << *nums + 1 << endl;   // 2 为(*nums)+1 即nums[0]+1
    cout << *(nums + 1) << endl; // 2 为*(nums+1) 即 nums[1]
    return 0;
}
```

### 下标和指针

下标本质是一种特殊的指针运算

```cpp
//example31.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int nums[] = {1, 2, 3};
    auto ptr = nums + 1;
    cout << *ptr << endl;    // 2
    cout << ptr[-1] << endl; // 1
    // ptr[-1] 等价于 *(ptr-1)
    cout << ptr[1] << endl; // 3
    // ptr[1] 等价于 *(ptr+1)
    return 0;
}
```

### C语言风格字符串

在C语言中是没有string类型的，而是使用char数组来进行存储字符串，以元素'\0'标志字符串结束。

```cpp
#include<cstring>
1、strlen(p) 返回p的长度，空字符不计算在内
2、strcmp(p1,p2) 返回p1和p2的相等性，如果字符串字典排序比较，相等时返回0、p1>p2 返回正数、p1<p2时返回负数
3、strcat(p1,p2) 将p2附加到p1之后，返回p1
4、strcpy(p1,p2) 将p2拷贝给p1,返回p1
```

样例

```cpp
//example32.cpp
#include <iostream>
#include <cstring>
using namespace std;
int main(int argc, char **argv)
{
    const char *name = "gaowanlu";
    const char name1[] = "gaowanlu";
    cout << name << endl;
    cout << name1 << endl;
    // name[0] = '1'; error name[0]不可变
    // name1[0] = '1'; error name[0]不可变

    char name2[10] = {'1', '2', '3', '4', '\0'};
    char name3[] = {'1', '2', '3', '5', '\0'};
    cout << strlen(name2) << endl;        // 4
    cout << strcmp(name2, name3) << endl; // 0
    strcat(name2, name3);
    cout << name2 << endl; // 12341235
    strcpy(name2, name3);
    cout << name2 << endl; // 1235

    //注：要注意的是如strcat与strcpy，字符串操作结果会存进做第一个参数数组，如果数组存放不下结果则会报错，因为内存根本不够用
    //但对于有些编译器不会报错,总之我们不要使用一下写法
    char kk[6] = {'h', 'e', 'l', 'l', 'o', '\0'};
    char ll[] = "uecdiwhdw";
    strcat(kk, ll);
    cout << kk << endl; // hellouecdiwhdw
    return 0;
}
```

### string.c\_str()与使用数组初始化vector

虽然在C++中我们仍然可使用char数组存储字符串不用string或者不适用vector使用数组、这并不是一个好习惯、因为之所以有C++就是为了增强C里面没有的东西，难道vector和string不香吗

```cpp
//example33.cpp
#include <cstring>
#include <iostream>
#include <string>
#include <vector>
using namespace std;
int main(int agrc, char **argv)
{
    //数组与string
    string s("hello world"); //使用字符串字面量初始化s
    const char *str = s.c_str();
    cout << strlen(str) << endl; // 11
    cout << str[1] << endl;      // e
    // string.c_str()返回const char*

    //数组与vector
    int arr[] = {0, 1, 2, 3, 4};
    vector<int> ivec(begin(arr) + 1, end(arr));
    for (auto e : ivec)
    {
        cout << e << " "; // 1 2 3 4
    }
    cout << endl;
    return 0;
}
```

### 多维数组

多维数组就是数组里面存放数组

```cpp
//example34.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    // mul_arr每个元素都是长度为4的int类型数组
    int mul_arr[3][4];
    // mul_arr_1每个元素都是一个5*5二维数组
    char mul_arr_1[5][5][5] = {0}; //将元素全部初始化为0
    return 0;
}
```

### 多维数组初始化

内嵌花括号可以指定确切的位置，省略内嵌的花括号就是从第一个位置初始化了

```cpp
//example35.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int arr[5][5] = {
        {0, 1, 2, 3, 4},
        {0, 1, 2, 3, 4},
        {0, 1, 2, 3, 4},
        {0, 1, 2, 3, 4},
        {5}}; //花括号初始化

    //还有更简洁的形式，有时候内嵌的花括号不是必须的
    int arr1[5][5] = {
        0, 1, 2, 3, 4,
        0, 1, 2, 3, 4,
        0, 1, 2, 3, 4,
        0, 1, 2, 3, 4,
        5};
    //也就是会从arr[0][0]向后按顺序初始化

    //初始化每行第一个元素
    int arr2[5][5] = {
        {1},
        {2},
        {3},
        {4},
        {5}};
    cout << arr2[4][0] << endl; // 5
    cout << arr2[4][4] << endl; // 0
    return 0;
}
```

### 多维数组的下标引用

多维数组的元素的引用的使用方式与一维数组是类似的

```cpp
//example36.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int arr[3][3] = {{0, 1, 2},
                     {3, 4, 5},
                     {6, 7, 8}};
    cout << arr[0][0] << endl; // 0
    cout << arr[1][0] << endl; // 3
    cout << arr[0][2] << endl; // 2
    cout << arr[2][0] << endl; // 6
    cout << arr[2][2] << endl; // 8

    //数组与引用
    int(&row1)[3] = arr[0];
    cout << row1[2] << endl; // 2
    return 0;
}
```

### 多维数组的遍历

一种是自定义范围配和下标引用，还可以使用数组迭代器

```cpp
//example37.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    //使用迭代器
    int arr[5][5];
    std::size_t count = 0;
    for (auto &row : arr)
    {
        for (auto &item : row)
        {
            item = count++;
        }
    }
    //使用下标访问
    for (int i = 0; i < 5; i++)
    {
        for (int j = 0; j < 5; j++)
        {
            cout << arr[i][j] << " ";
        }
    }
    cout << endl;
    // 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24

    count = 0;
    for (auto row : arr)
    {
        row[0] = 0;
        cout << arr[count++][0] << endl; // 0 0 0 0 0
    }
    //可见没有使用auto&而是使用auto则在遍历数组时row是arr每个元素的拷贝
    //而不是引用

    return 0;
}
```

### 指针和多维数组

非常重要的一句话、当程序使用多维数组的名字时，会自动转换成指向数组首元素的指针

```cpp
//example38.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    //存放指针的多维数组
    int num = 999;
    int *ptr_mul_arr[5][5];
    ptr_mul_arr[0][0] = &num;
    *ptr_mul_arr[0][0] = 222;
    cout << num << endl; // 222

    //指向多维数组的指针
    int(*mul_arr_ptr)[5][5];
    int nums[5][5];
    mul_arr_ptr = &nums;
    (*mul_arr_ptr)[2][2] = 999;
    cout << nums[2][2] << endl; // 999

    //多维数组首个元素的地址
    int(*first)[5] = nums;
    (*first)[0] = 888;
    cout << nums[0][0] << endl; // 888

    //第一个元素地址
    int *p = &nums[0][0];

    //使用指针进行实现下标访问
    int(*first_ptr)[5] = nums; // nums为int(*)[5]即存放int[5]类型的地址
    *(*(first_ptr + 1) + 2) = 123;
    cout << nums[1][2] << endl; // 123
    return 0;
}
```

使用auto、decltype、begin、end

```cpp
//example39.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int arr[3][3] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    auto el = arr[2][2];
    el = 12;
    cout << arr[2][2] << endl; // 9

    auto &el1 = arr[2][2]; //引用即别名
    el1 = 999;
    cout << arr[2][2] << endl; // 999

    auto &el2 = arr[2];     //引用即别名
    cout << el2[2] << endl; // 999

    decltype(begin(arr)) p1 = begin(arr); //返回第一个元素的地址
    (*p1)[2] = 1234;                      //解引用p1，获得二维数组第一个元素的引用
    cout << arr[0][2] << endl;            // 1234

    decltype(end(arr)) p2 = end(arr) - 1;//end获取最后一个元素后面一个位置的地址
    cout << (*p2)[2] << endl; // 999
    return 0;
}
```

### 类型别名简化多维数组指针

typedef、using 与数组

```cpp
//example40.cpp
#include <iostream>
using int_array = int[3]; // int_array等价int[3]
typedef int int_array[3]; // int_array等价int[3]
using namespace std;
int main(int argc, char **argv)
{
    int a[3][3] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    int_array *row = a;                // int_array为指向int[3]数组的指针
    cout << *(*(row + 1) + 1) << endl; // 5
    return 0;
}
```

我们会发现在我们学习的过程中都是一些细节令我们感到困惑、比如引用、指针、auto、const、配和其他类型进行使用的时候往往搞得我们一头雾水、但是自己不要失去自信心，没有人把他们记得一清二楚、多谢代码在实践中运用才能使得我们经验丰富起来
