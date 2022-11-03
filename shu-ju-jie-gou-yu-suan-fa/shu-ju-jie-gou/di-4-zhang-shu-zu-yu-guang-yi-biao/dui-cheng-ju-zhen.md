---
coverY: 0
---

# 😈 对称矩阵

## 对称矩阵

对称矩阵即满足a\[i]\[j]=a\[j]\[i],由此可见我们只需要存储上三角或者下三角就可以推出整个矩阵，所以我们可以利用对称矩阵的特性进行压缩存储。

```cpp
1 2 3 4
2 5 6 7
3 6 8 9
4 7 9 6
//存储下三角
1 2 5 3 6 8 4 7 9 6
//存储上三角
1 2 3 4 5 6 7 8 9 6 
```

那么其中的下标对应方式是怎样的呢?\
可以先自己思考一下哦!

注：矩阵存储我们是从(1,1)对矩阵进行编号的

### 存储下三角

对于下三角(i<=j)的元素a(i,j),前面则有元素数量为 (1-1 + 2-1 + 3-1 + ... + i-1)+j-1、则`LOC(aij)=LOC(a00)+(j-1+(i-1)*i/2)*L`

```cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int n;
    cin >> n;
    if (n <= 0)
        return -1;
    int sum = n * (1 + n) / 2;
    cout << sum << endl;
    int *matrix = new int[sum];
    for (int i = 1; i <= n; i++)
    {
        for (int j = 1; j <= n; j++)
        {
            int v;
            cin >> v;
            if (i <= j)
                *(matrix + (j - 1 + (i - 1) * i / 2)) = v;
            // LOC(aij) = LOC(a00) + (j - 1 + (i - 1) * i / 2) * L
        }
    }
    cout << "[\n";
    for (int i = 1; i <= n; i++)
    {
        for (int j = 1; j <= n; j++)
        {
            if (i <= j)
            {
                cout << *(matrix + (j - 1 + (i - 1) * i / 2)) << " ";
            }
            else
            {
                cout << *(matrix + (i - 1 + (j - 1) * j / 2)) << " ";
            }
        }
        cout << endl;
    }
    cout << "]\n";
    delete matrix;
    /*
    3
    6
    1 2 3
    2 3 1
    3 1 2
    [
    1 2 3
    2 3 1
    3 1 2
    ]
    */
    return 0;
}
```

### 存储上三角存储

对于上三角(i>j)的元素a(i,j)直接兑换i与j就好了,则`LOC(aij)=LOC(a00)+(i-1+(j-1)*j/2)*L`

```cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    int n;
    cin >> n;
    if (n <= 0)
        return -1;
    int sum = n * (1 + n) / 2;
    cout << sum << endl;
    int *matrix = new int[sum];
    for (int i = 1; i <= n; i++)
    {
        for (int j = 1; j <= n; j++)
        {
            int v;
            cin >> v;
            if (i >= j)
                *(matrix + (i - 1 + (j - 1) * j / 2)) = v;
            //`LOC(aij)=LOC(a00)+(i-1+(j-1)*j/2)*L`
        }
    }
    cout << "[\n";
    for (int i = 1; i <= n; i++)
    {
        for (int j = 1; j <= n; j++)
        {
            if (i >= j)
                cout << *(matrix + (i - 1 + (j - 1) * j / 2)) << " ";
            else
                cout << *(matrix + (j - 1 + (i - 1) * i / 2)) << " ";
        }
        cout << endl;
    }
    cout << "]\n";
    delete matrix;
    /*
    3
    6
    1 2 3
    2 3 1
    3 1 2
    [
    1 2 3
    2 3 1
    3 1 2
    ]
    */
    return 0;
}
```
