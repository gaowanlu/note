---
coverY: 0
---

# 🥯 数组的存储

## 数组的存储

数组一般采用顺序存储结构，因为存储单元时一维的，而且数组可以是多维的，用连续的内存空间表示一维数组可想而知是非常简单的，但是怎么表示多维的数组呢。 我们熟悉的C/C++、Java都是按照行存储的。

```cpp
m行n列的二维数组
a(0,0) a(0,1) ... a(0,n-1)
a(1,0) a(1,1) ... a(1,n-1)
...           ... a(2,n-1)
...           ... a(3,n-1)
...           ... 
a(m-1,0)          a(m-1,n-1)
```

一般默认从下标0开始

### 按行存储

也就是先存储第1行，再存第2行直到m-1行

如果a(0,0)的地址维Loc(a00),则按照行存储可得，aij 其前面有(i\*n+j)个元素,则 aij 存储单元地址为 `LOC(aij)=LOC(a00)+(i*n+j)*L`,L为每个存储单元的大小。

```cpp
//main1.cpp
#include <iostream>
using namespace std;
int use(int *array, const int i, const int j, const int m, const int n, int *new_value)
{
    if (new_value != nullptr)
    {
        *(array + (i * n) + j) = *new_value;
    }
    return *(array + (i * n) + j);
}
int main(int argc, char **argv)
{
    int m = 10, n = 10;
    int *array = new int[m * n];
    // sotrage
    int new_value = 188;
    use(array, 1, 0, m, n, &new_value);
    cout << use(array, 1, 0, m, n, nullptr); // 188
    delete array;
    return 0;
}
```

### 按列存储

如果a(0,0)的地址维Loc(a00),则按照行存储可得，aij 其前面有(j\*m+i)个元素,则 aij 存储单元地址为 `LOC(aij)=LOC(a00)+(j*m+i)*L`,L为每个存储单元的大小。

```cpp
#include <iostream>
using namespace std;
int use(int *array, const int i, const int j, const int m, const int n, int *new_value)
{
    if (new_value != nullptr)
    {
        *(array + (j * m) + i) = *new_value;
    }
    return *(array + (j * m) + i);
}
int main(int argc, char **argv)
{
    int m = 10, n = 10;
    int *array = new int[m * n];
    // sotrage
    int new_value = 188;
    use(array, 1, 0, m, n, &new_value);
    cout << use(array, 1, 0, m, n, nullptr); // 188
    delete array;
    return 0;
}
```

### 从下标1开始

* 按行存储

`LOC(aij)=LOC(a11)+(n*(i-1)+(j-1))*L`

* 按列存储

`LOC(aij)=LOC(a11)+(m*(j-1)+(i-1))*L`
