---
coverY: 0
---

# 😆 字符串的存储结构

## 字符串的存储结构

字符串是由零个或者多个字符组成的有限序列。

在C语言中是没有字符串类型的，C++中标准库提供了std::string.

### 串的存储结构

* 定长顺序存储表示

```cpp
char str[512]="HELLO";//str最长可存储511个字符，因为最后还要存储个\0
```

* 对分配存储表示

```cpp
#include <iostream>
#include <cstdlib>
#include<cstring>
using namespace std;
int main(int argc, char** argv)
{
    char * const str = (char*)malloc(sizeof(char) * 512);
    strcpy_s(str,sizeof("HELLO"), "HELLO");
    cout << str << endl; // HELLO
    free(str);
    return 0;
}

```

* 块链存储表示

块链存储则是，通过链表来进行字符串的存储，而且每个节点可以存储多个字符，也可以使用每个节点只能存储一个字符的节点的链表。但是这样的存储结构往往会使得对字符串的操作变得很复杂。
