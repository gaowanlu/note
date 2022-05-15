---
coverY: 0
---

# 🥲 字符串的基本操作

## 字符串的基本操作

学过C语言或者C++可以指导，我们可以对字符串进行许多操作,有一点值得注意的时，C字符串需要以\0结尾，使用时也需要我们注意防止溢出。

* 赋值
* 复制
* 判空
* 比较
* 串长
* 求子串
* 串联结
* 子串定位
* 清空
* 销毁串

在这上面的内容中、重头戏在于串的定位，即我们后面要求的子串搜索算法。\
在此先大致了解其他操作

### 赋值

无论C还是C++的字符串初始化与赋值都有多种方式，我们先了解最常用的方式即可，有兴趣可以去学习C++

```cpp
//main1.cpp
#include <iostream>
#include <string>
#include <cstring>
int main(int argc, char **argv)
{
    std::string str1 = "hello";
    char str2[512] = "hello";
    // str2 = "jij"; error:str2不是左值
    // 如果数组性字符串想要重新赋值则通常用strcpy
    strcpy(str2, "gaowanlu");
    const char *str3 = "hello";
    std::cout << str1 << std::endl; // hello
    std::cout << str2 << std::endl; // gaowanlu
    std::cout << str3 << std::endl; // hello
    return 0;
}
```

### 复制

```cpp
//main2.cpp
#include <iostream>
#include <string>
#include <cstring>
int main(int argc, char **argv)
{
    // C语言
    char str1[512] = "ndsjkc";
    char str2[512];
    strcpy(str2, str1);
    std::cout << str2 << std::endl; // ndsjkc
    // C++
    std::string str3 = "ndsjkc";
    std::string str4 = str3;        // copy assign
    std::cout << str4 << std::endl; // ndsjkc
    return 0;
}
```

### 判空

当然除了下面这些，还有很多中方式，但都是通过字符串的长度来进行判断的。

```cpp
//main3.cpp
#include <iostream>
#include <string>
#include <cstring>
using namespace std;
int main(int argc, char **argv)
{
    string str1 = "io";
    const char *str2 = "io";
    // str1 false
    cout << "str1 " << (str1.empty() == true ? "true" : "false") << endl;
    // str2 false
    cout << "str2 " << (strlen(str2) == 0 ? "true" : "false") << endl;
    return 0;
}
```

### 比较

通常为字典比较

```cpp
//main4.cpp
#include <iostream>
#include <string>
#include <cstring>
using namespace std;
int main(int argc, char **argv)
{
    const char *str1 = "nihoa";
    const char *str2 = "nihoa";
    string str3 = "ab";
    string str4 = "a";
    cout << strcmp(str1, str2) << endl;                 // 0 则代表相等 1则str1>str2 -1 则str<str2
    cout << (str3 == str4) << endl;                     // 0
    cout << (str3 < str4) << endl;                      // 0
    cout << (str3 > str4) << endl;                      // 1
    cout << strcmp(str3.c_str(), str4.c_str()) << endl; // 1
    return 0;
}
```

### 串长

std::string一般使用length()或者size()方法，C使用strlen

```cpp
//main5.cpp
#include <iostream>
#include <string>
#include <cstring>
using namespace std;
int main(int argc, char **argv)
{
    const char *str1 = "nihoa";
    char str2[512] = "vbdhfj";
    cout << strlen(str1) << endl; // 5
    cout << strlen(str2) << endl; // 6
    string str3 = "hello";
    cout << str3.size() << endl;   // 5
    cout << str3.length() << endl; // 5
    return 0;
}
```

### 求子串

就是截取字符串的一部分.

```cpp
//main6.cpp
#include <iostream>
#include <string>
#include <cstring>
using namespace std;
int main(int argc, char **argv)
{
    const char *str1 = "1234567";
    char str2[10];
    //从下标3向后截取2个字节
    memcpy(str2, str1 + 3, sizeof(char) * 2);
    str2[2] = '\0';
    cout << str2 << endl; // 45

    std::string str3 = "1234567";
    std::string str4 = str3.substr(3, 2);
    cout << str4 << endl; // 45
    return 0;
}
```

### 串联结

就是字符串的拼接.

```cpp
//main7.cpp
#include <iostream>
#include <string>
#include <cstring>
using namespace std;
int main(int argc, char **argv)
{
    char str1[512] = "nihao";
    const char *str2 = "tail";
    strcat(str1, str2);
    cout << str1 << endl; // nihaotail

    std::string str3 = "nihao";
    std::string str4 = "tail";
    str3 += str4;
    cout << str3 << endl; // nihaotail
    return 0;
}
```

### 子串定位

就是在字符串中搜索字串了，现在有很多算法提供我们学习，在基础的书籍内有两种一种是暴力搜索，一种是KMP算法。

### 清空

清空就显得很容易了

```cpp
//main8.cpp
#include <iostream>
#include <string>
#include <cstring>
using namespace std;
int main(int argc, char **argv)
{
    char str1[10] = "nihao";
    char str2[10] = "tail";
    cout << str1 << endl; // nihao
    cout << str2 << endl; // tail
    str1[0] = '\0';
    str2[0] = '\0';
    cout << str1 << endl; //
    cout << str2 << endl; //
    return 0;
}
```

### 销毁串

字符串的销毁一般都是释放申请的堆内存而言的，因为栈内存是连着我们的执行上下文的。

```cpp
//main9.cpp
#include <iostream>
#include <string>
#include <cstring>
using namespace std;
int main(int argc, char **argv)
{
    string str1 = "fdvdf";
    cout << str1 << endl; // fdvdf
    str1.clear();

    const char *str2 = new char[512];
    str2 = "dsfv";
    cout << str2 << endl; // dsfv
    delete str2;
    return 0;
}
```
