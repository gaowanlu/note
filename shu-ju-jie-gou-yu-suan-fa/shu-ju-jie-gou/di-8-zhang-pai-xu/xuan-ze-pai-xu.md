---
coverY: 0
---

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

堆排序是一种树形选择排序算法，简单选择排序选出最小记录为O(n),而堆排序选择最小的记录只需要O(logn)

堆是一个完全二叉树，且如果每个节点的值都大于等于左右孩子的值，称为最大堆。如果每个节点的值都小于等于左右孩子的值，称为最小堆。

<figure><img src="../../../.gitbook/assets/image (3).png" alt=""><figcaption><p>大根堆</p></figcaption></figure>

1、算法步骤

（1）构建初始堆

（2）堆顶和最后一个记录交换，即r\[1]与r\[n]交换，将r\[1..n-1]重新调整

（3）堆顶和最后一个记录交换，即r\[1]和r\[n-1]交换，将r\[1..n-2]重新调整为堆

（4）循环n-1次，得到一个有序序列

2、代码实现

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

template <typename T>
void printVec(const T& t)
{
    for (size_t i = 0; i < t.size(); i++)
    {
        cout << t[i] << " ";
    }
    cout << endl;
}

//下沉操作
void Sink(vector<int>& vec, size_t now,size_t size)
{
    //如果vec[i]有孩子，则左孩子为2k+1(root下标1则2k),右孩子为2k+2(root下标1则2k)
    while (2 * now + 1 < size) //有左孩子
    {
        size_t left = 2 * now + 1;                              //左孩子下标
        if (left + 1 < size && vec[left] < vec[left + 1]) //有右孩子且左孩子小于右孩子
        {
            left++;
        }
        //现在left指向了左右孩子中比较值较大的那一个
        if (vec[now] > vec[left]) //满足堆条件
        {
            break;
        }
        else //下沉到left位置
        {
            std::swap(vec[now], vec[left]);
        }
        //更新此时的位置
        now = left;
    }
}

//初始化堆
void CreateHeap(vector<int>& vec)
{
    //完全二叉树从最后一个有孩子的节点进行调整
    int mid = vec.size()+1 / 2;
    mid = mid - 1;
    for (int i = mid; i >= 0; i--)
    {
        Sink(vec, i,vec.size()); //下沉vec[i]
    }
}

void HeapSort(vector<int>& vec,vector<int>&sortedVec)
{
    cout <<"size of vec "<< vec.size() << endl;
    CreateHeap(vec); //构建初始堆
    cout << "init tree" << endl;
    printVec(vec);
    int n = vec.size()-1;//最后一个节点
    while (n >= 0) // n-1 twice
    {
        sortedVec.push_back(vec[0]);
        std::swap(vec[0], vec[n]);//将最后一个节点移动到根节点
        --n;//堆中剩余节点
        Sink(vec, 0,n+1); //堆下沉 root节点
    }

}

int main(int argc, char** argv)
{
    vector<int> vec = { 12, 16, 2, 30, 28, 20, 16, 6, 10, 18 };
    vector<int> sortedVec;
    HeapSort(vec,sortedVec);
    cout << "sorted Vec" << endl;
    printVec<vector<int>>(sortedVec);
    /*
    size of vec 10
    init tree
    30 28 20 16 18 2 16 6 10 12
    sorted Vec
    30 28 20 18 16 16 12 10 6 2
    */
    return 0;
}
```

3、算法分析

(1) 时间复杂度：

&#x20;        初始化一个堆，最后一个分支节点(n/2)到第一个节点进行下沉，下沉最大深度logn,所以构建堆上界为O(nlogn)，大部分节点下沉小于O(nlogn),构建n个记录的堆，只需要少于2n次的比较和少于n次的交换，构建堆时间复杂度为O(n)。排序时，树的深度为logn,一共n-1次排序，总时间复杂度为O(nlogn)。

(2) 空间复杂度：O(1)

(3) 稳定性：堆排序时多次交换关键字，可能发生排序前后位置不一致情况，排序是非稳定排序方法。
