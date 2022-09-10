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

快速排序由Hoare于1962年提出，它的基本思想就是通过一组待排序的序列分割成两个独立的部分，其中一部分的所有数据比另外一部分的所有数据小，用此方法一直分割下去，整个排序过程可以递归进行。

1、算法步骤

* 首先取数组的第一个元素作为基准元素pivot=R\[low],i=low,j=high。
* 从右向左扫描，找小于等于pivot的数，如果找到，则R\[i]和R\[j]交换，i++。
* 从左向右扫描，找大于pivot的数，如果找到，则R\[i]和R\[j]交换，j--。
* 重复第2步和第3步，直到i和j重合，返回该位置mid=i,该位置的数正好是pivot元素
* 至此完成一趟排序，此时以mid为界，将原序列分为两个子序列，左侧子序列元素雄安与pivot,右侧子序列元素小于pivot,再分别对这两个子序列进行快速排序

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
size_t Partition(vector<T> &vec, size_t low, size_t high)
{
    size_t i = low, j = high;
    T pivot = vec[low]; //选第一个元素作为基准元素
    while (i < j)
    {
        //向左扫描 找到右边比基准元素小的
        while (i < j && vec[j] > pivot)
            j--;
        if (i < j)
        {
            std::swap(vec[i], vec[j]);
            ++i;
        }
        //向右扫描 找到左边比基准元素大的
        while (i < j && vec[i] <= pivot)
            i++;
        if (i < j)
        {
            std::swap(vec[i], vec[j]);
            --j;
        }
    }
    return i;
}

template <typename T>
void QuickSort(vector<T> &vec, size_t low, size_t high)
{
    size_t mid;
    if (low < high)
    {
        mid = Partition<T>(vec, low, high);
        QuickSort(vec, low, mid - 1);
        QuickSort(vec, mid + 1, high);
    }
}

int main(int argc, char **argv)
{
    vector<int> vec = {6, 5, 4, 3, 2, 5, 6, 2, 5};
    QuickSort<int>(vec, 0, vec.size() - 1);
    printVec<vector<int>>(vec);
    // 2 2 3 4 5 5 5 6 6
    return 0;
}
```

3、复杂度分析

* 时间复杂度

（1）最好情况 O(nlogn)

&#x20; (2)  平均情况 O(nlogn)

&#x20; (3)  最坏情况 O(n^2)

* 空间复杂度

递归调用所使用的栈空间为递归树的深度n，空间复杂度为O(n)

* 稳定性

因为前后两个方向扫描并交换，相等的两个元素有可能出现排序前后位置不一致的情况，所以快速排序是不稳定的排序方法

4、划分函数的改进

```cpp
template <typename T>
size_t PartitionPro(vector<T> &vec, size_t low, size_t high)
{
    size_t i = low, j = high;
    T pivot = vec[low]; //选第一个元素作为基准元素
    while (i < j)
    {
        while (i < j && vec[j] > pivot)
            j--; //向左扫描找到一个比基准小的
        while (i < j && vec[i] <= pivot)
            i++;
        if (i < j)
        {
            std::swap(vec[i++], vec[j--]);
        }
    }
    //将基准元素放到相应位置
    if (vec[i] > pivot)
    {
        std::swap(vec[i - 1], vec[low]);
        return i - 1;
    }
    std::swap(vec[i], vec[low]); // pivot<=vec[i]
    return i;
}
```
