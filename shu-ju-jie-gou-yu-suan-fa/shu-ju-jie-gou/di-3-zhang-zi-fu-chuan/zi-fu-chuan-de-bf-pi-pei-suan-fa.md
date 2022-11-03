---
coverY: 0
---

# ⚾ 字符串的BF匹配算法

## 字符串的BF匹配算法

* 时间复杂度 最好 O(n+m) 最坏 O(n\*m)
* 空间复杂度 O(1)

### 算法流程

1、从S第1个字符开始，与T第1个字符比较，如果相等，继续比较下一个字符，否则转向下一步。\
2、从S第2个字符开始，与T第1个字符比较，如果相等，继续比较下一个字符，否则转向下一步。\
3、从S第3个字符开始，与T第1个字符比较，如果相等，继续比较下一个字符，否则转向下一步。\
...\
4、如果T比较完毕，则返回T在S中第一个字符出现的位置。\
5、如果S比较完毕，则返回0，说明T在S中未出现。

### 代码实现

```cpp
//main.cpp
#include <iostream>
#include <cstring>
using namespace std;

#define Maxsize 100
typedef char SString[Maxsize + 1]; // 0 号单元存放串的长度

/**
 * @brief BF 算法，求 T 在主串 S 中第 pos 个字符之后第一次出现的位置，
 * 其中，T 非空，1≤pos≤s[0],s[0]存放S串的长度
 *
 * @param s 主串
 * @param T 子串
 * @param pos 从pos开始搜索
 * @return int 匹配开始的下标
 */
int Index_BF(SString s, SString T, int pos)
{
    // i为主串指针 初始位置 即从下标pos开始搜索T
    int i = pos, j = 1;
    int sum = 0;
    while (i <= s[0] && j <= T[0]) //子串和父串都没有比较完
    {
        sum++;
        if (s[i] == T[j]) // 如果相等，则继续比较后面的字符
        {
            i++;
            j++;
        }
        else
        {
            i = i - j + 2; // i 符串指针退回到上一轮开始比较的下一个字符
            j = 1;         // j 子串指针退回到第1个字符
        }
    }
    cout << "compare sum " << sum << endl;
    //子串指针遍历完则说明找到了子串
    if (j > T[0])        // 子串匹配完毕
        return i - T[0]; // 返回匹配成功的位置
    else                 //没有匹配成功
        return -1;
}

//生成一个其值等于chars的串T
bool StrAssign(SString &T, char *chars)
{
    int i;
    if (strlen(chars) > Maxsize)
        return false;
    else
    {
        T[0] = strlen(chars); //用第一个字节存放字符串的长度
        for (i = 1; i <= T[0]; i++)
        {
            T[i] = *(chars + i - 1);
            cout << T[i] << "  ";
        }
        cout << endl;
        return true;
    }
}

int main()
{
    SString S, T;
    char str[100];
    cout << "S:";
    cin >> str; // aabaaabaaaabea
    StrAssign(S, str);
    cout << "T:";
    cin >> str; // aaaab
    StrAssign(T, str);
    cout << "USE BF" << endl;
    int res = Index_BF(S, T, 1);
    cout << "search at " << res << endl;
    return 0;
}
/*
S:aabaaabaaaabea
a  a  b  a  a  a  b  a  a  a  a  b  e  a
T:aaaab
a  a  a  a  b
USE BF
compare sum 21
search at 8
*/
```
