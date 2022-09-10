# ☺ 选择排序

## 选择排序

### 简单选择排序

1、算法步骤

* 设待排序的记录存储在数组r\[1..n]中，首先从r\[1..n]中选择关键字最小的记录r\[k],r\[k]与r\[1]交换。
* 第二趟排序，从r\[2..n]中选择一个关键字最小的记录r\[k],r\[k]与r\[2]交换。
* 重复上述过程，经过n-1趟排序，得到有序序列

2、代码实现

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

template <typename T>
void printVec(const T &t)
{
    for (size_t i = 0; i < t.size(); i++)
    {
        cout << t[i] << " ";
    }
    cout << endl;
}

template <typename T>
void SimpleSelectSort(vector<T> &vec)
{
    size_t i, j, k;
    T temp;
    for (i = 0; i < vec.size(); i++)
    {
        k = i; //初始化最小值所在位置
        // find min
        for (j = i + 1; j < vec.size(); j++)
        {
            if (vec[j] < vec[k])
            {
                k = j;
            }
        }
        if (k != i)
        {
            std::swap(vec[k], vec[i]);
        }
    }
}

int main(int argc, char **argv)
{
    vector<int> vec = {6, 5, 4, 3, 2, 5, 6, 2, 5};
    SimpleSelectSort<int>(vec);
    printVec<vector<int>>(vec);
    // 2 2 3 4 5 5 5 6 6
    return 0;
}
```

3、算法分析

(1) 时间复杂度：需要n-1趟排序，每趟排序n-i次比较，总比较次数为\`n(n-1)/2\`,时间复杂度为O(n^2)

(2) 空间复杂度：O(1)

(3) 稳定性：不稳定

### &#x20;堆排序

