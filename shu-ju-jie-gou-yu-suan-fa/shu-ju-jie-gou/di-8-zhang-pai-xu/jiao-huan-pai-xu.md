# 😃 交换排序

## 交换排序

### 冒泡排序

1、算法步骤

* 设待排序的记录存储在数组r\[1\~n]中，首先第一个记录和第二个记录关键词比较，若逆序则交换，然后第一个记录和第二个记录关键词比较...,依次类推，直到第n-1个记录和第n个记录关键词比较完毕为止，第一趟排序结束，关键字最大的记录在最后一个位置。
* 第二趟排序，对前n-1个元素进行冒泡排序，关键字次大的记录在n-1位置
* 重复上述过程，直到某一趟排序中没有进行交换为止。

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
void BubbleSort(vector<T> &vec)
{
    bool flag = true;
    size_t i = vec.size() - 1;
    while (i > 0 && flag) //有交换且还有元素没有确定有序时所在位置
    {
        flag = false;
        for (size_t j = 0; j < i; j++)
        {
            if (vec[j] > vec[j + 1])//非递减
            {
                flag = true;
                std::swap(vec[j], vec[j + 1]);
            }
        }
        i--;
    }
}

int main(int argc, char **argv)
{
    vector<int> vec = {6, 5, 4, 3, 2, 5, 6, 2, 5};
    BubbleSort<int>(vec);
    printVec<vector<int>>(vec);
    // 2 2 3 4 5 5 5 6 6
    return 0;
}

```

3、复杂度分析

* 时间复杂度：（1）最好只需一趟排序，n-1次比较，没有交换操作，即O(n)。（2）最坏时序列本身为逆序，需要n-1趟排序，每趟排序i-1次比较，比较的总次数为\`n(n-1)/2\`,即O(n^2)
* 平均时间复杂度：在所有待排序序列出现各种情况概率均等，则可取最好情况和最坏情况的平均值，O(n^2)
* 空间复杂度：O(1)
* 稳定性：冒泡排序是稳定的排序方法。

### 快速排序

