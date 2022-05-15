---
coverY: 0
---

# 🚘 next-KMP匹配算法

## next-KMP匹配算法

* 时间复杂度 最坏的情况扫描整个S串，时间复杂度为O(n)、计算next数组需要扫描T串，时间复杂度为O(m),因此总的时间复杂度为O(n+m)
* 空间复杂度 存储next数组，O(m)

What's the KMP algorithm?

KMP是一种利用动态规划算法思想的匹配算法。

```cpp
//第1次匹配开始
  i
  1 2 3 4 5 6 7 8 9 10 11
S a b a a b a a b e c  a
T a b a a b e
  j
```

```cpp
//第1次匹配不相等
            i
  1 2 3 4 5 6 7 8 9 10 11
S a b a a b a a b e c  a
T a b a a b e
            j
```

```cpp
//BF算法的回退
    i
  1 2 3 4 5 6 7 8 9 10 11
S a b a a b a a b e c  a
T   a b a a b e
    j
```

```cpp
//KMP的回退 将j后退lmax(ab)+1=2+1=3个字符 继续比较
            i
  1 2 3 4 5 6 7 8 9 10 11
S a b a a b a a b e c  a
T       a b a a b e
            j
```

为什么？KMP怎么跳这么快，马老师发生什么事了，难道有人搞偷袭？

T a b a a b e 当e不匹配时，可以见a b a a b 其前缀与后缀相同的部分为 a b ,那我们是不是直接让T开头对准S e前面两个的位置就好了呢？最疑惑的一点是不是，中间可以回退的那些位置都不可能匹配成功吗？S 的 a b a a b 与 T 的 a b a a b 一一匹配，你说让T对准S的b a会匹配吗，二者相同，然后一错位它们是不相等的啊!真的吗？如果二者全部都是一样的字符呢

```cpp
            i
S a a a a a a e b e c a
T a a a a a e
            j
```

KMP怎么办，会跳成下面这样子吗，别慌慢慢来探索吧\~

```cpp
            i
S a a a a a a e b e c a
T   a a a a a e
            j
```

### 求next数组

next数组存储T字符串中，如果在响应位置不匹配时，搜索的串应该回退到哪里重新比较。

```cpp
         --
        |0,j=1
next[j]=|lmax+1,T'的等前缀和后缀的最大长度lmax
        |1,没有相等的前缀后缀
         --
```

但是我们有发现问题了？这个等前缀和后缀的最大长度lmax怎么求呢？难道要暴力求解？\
当然不是，已经有大佬替我们想出了动态规划求解算法。

```cpp
已知 next[j]=k
当t[k]==t[j]时
    则next[j+1]=k+1
当t[k]!=t[j]时
    则回退next[k]=k'
    如果t[k']==t[j] 则 next[j+1]=k'+1,否则继续回退找next[k']=k'' 
    比较t[k'']与t[j]是否相等，不等则继续回退直到相同或者找到next[1]=0
```

### 代码实现

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
            next[j] = k; //当k==0时 next[++j]=1 或者 T[j]==T[k]
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
