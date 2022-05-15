---
coverY: 0
---

# 🐯 next-val-KMP匹配算法

## next-val-KMP匹配算法

可能会口吐芬芳了，刚才next怎么蹦出来个next-val

在next中存在一个问题，如果在t\[j]处不匹配了，next\[j]为k,则j退回到j处，但是当t\[k]与t\[j]相等时，我们是没必要j退回到k的因为，退回去还是不等，还要往前退

能不能在求next数组是就将这个问题解决呢？

### 改进的KMP算法

```cpp
#include <iostream>
#include <cstring>
using namespace std;

#define Maxsize 100
typedef char SString[Maxsize + 1]; // 0 号单元存放串的长度

// 求模式串 T 的 next 函数值
void get_next(SString T, int next[])
{
    int j = 1;
    int k = 0;
    next[1] = 0; // j=1 时 next[j]=0
    //遍历字符串
    while (j < T[0]) // T[0] 为模式串 T 的长度
    {
        if (k == 0 || T[j] == T[k])
        {
            ++j;
            ++k;
            if (T[j] != T[k])
            {
                next[j] = k;
            }
            else
            {
                next[j] = next[k];
            }
        }
        else
        {
            k = next[k]; //利用前缀的前缀部分
        }
    }
    cout << "-----next[]-----" << endl;
    for (j = 1; j <= T[0]; j++)
        cout << next[j] << "  ";
    cout << endl;
}

// KMP 算法
// 利用模式串 T 的next 函数求 T 在主串 S 中第pos个字符之后的位置
// 其中，T 非空，1≤pos≤s[0],s[0]存放S串的长度
int Index_KMP(SString s, SString T, int pos, int next[])
{
    int i = pos, j = 1, sum = 0;
    //字符串字符从下标1开始存放
    while (i <= s[0] && j <= T[0])
    {
        sum++;
        if (j == 0 || s[i] == T[j])
        {
            i++; //主串指针++
            j++; //子串指针++
        }
        else
            j = next[j]; // 模式串向右移动 使得next[j]位置与i对齐 再比较s[i] t[j]
    }
    cout << "compare count " << sum << endl;
    if (j > T[0]) //搜到了目标子串
    {
        return i - T[0];
    }
    else
    {
        return 0;
    }
}

//生成一个其值等于chars的串T
bool StrAssign(SString &T, char *chars)
{
    int i;
    if (strlen(chars) > Maxsize)
        return false;
    else
    {
        T[0] = strlen(chars);
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
    cout << "S" << endl;
    cin >> str; //输入父串
    StrAssign(S, str);
    cout << "T" << endl;
    cin >> str; //输入子串
    StrAssign(T, str);
    //求出T串的next数组
    int *p = new int[T[0] + 1]; // next数组也是从下标1开始存储
    get_next(T, p);
    // KMP求解
    cout << "KMP" << endl;
    int res = Index_KMP(S, T, 1, p);
    cout << "search at " << res << endl;
    return 0;
}
/*
S
aaaaaaebeca
a  a  a  a  a  a  e  b  e  c  a
T
aaaaae
a  a  a  a  a  e
KMP
-----next[]-----
0  1  2  3  4  5
compare count 8
search at 2
*/
```
