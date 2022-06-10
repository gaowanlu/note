---
coverY: 0
---

# 😅 插入排序

## 插入排序

### 有序性

有序通常分为非递增和非递减，递增一般是指严格的递增，即后一个元素必须比前一个元素大，不允许相等，而非递增指后一个元素必须比前一个元素小，允许相等，非递减同理

### 稳定性

排序的稳定性是指当前关键字相等时，排序前后的位置变化,在C++标准库中泛型算法为我们提供了容器的排序算法，sort为不稳定排序，stable\_sort为稳定排序

```cpp
//main1.cpp
array<int, 10> m_array;
for (int i = 0; i < 10; i++)
{
    m_array[i] = 10 - i;
}
printArray(m_array); // 10 9 8 7 6 5 4 3 2 1
sort(m_array.begin(), m_array.end(), [](const int &a, const int &b) -> bool
     { return (a < b); });
printArray(m_array); // 1 2 3 4 5 6 7 8 9 10
//稳定排序
stable_sort(m_array.begin(), m_array.end(), [](const int &a, const int &b) -> bool{ return (a > b); });
printArray(m_array); // 10 9 8 7 6 5 4 3 2 1
```

### 内部排序和外部排序

内部排序是数据在内存中进行排序，外部排序是因排序的数据很大，内存不能一次容纳全部数据，在排序过程中需要访问外存

### 直接插入排序

1、算法思想\
直接插入排序是最简单的排序方法，每次将一个待排序的记录，插入到已经排好序的数据序列中，得到一个新的长度增1的有序表

2、算法步骤

* 设待排序的记录存储在数组r\[1..n]中，可以把第一个记录r\[1]看作一个有序序列。
* 依次将r\[i]\(i=2,...,n)插入到已经排好序的序列r\[1...i-1],并保持有序性。

3、代码实现

```cpp
//main2.cpp
//直接插入排序 升序
void straightInsertSort(int array[], int n)
{
    //从下标1处理到下标n
    for (int i = 1; i <= n; i++)
    {
        //寻找插入位置
        int j = i - 1;
        int val = array[i];
        while (j >= 0 && array[j] > val)
        {
            array[j + 1] = array[j];
            cout << "[" << i << "] " << array[0] << " " << array[1] << " " << array[2] << " " << array[3] << " " << array[4] << endl;
            j--;
        }
        if (i - 1 != j) //原来array[i]需要进行移动
        {
            array[++j] = val;
        }
    }
}

void printArray(int m_array[5])
{
    for (int i = 0; i < 5; i++)
    {
        cout << m_array[i] << " ";
    }
    cout << endl;
}

int main(int argc, char **argv)
{
    int array[] = {1, 3, 4, 2, 5};
    straightInsertSort(array, 4);
    printArray(array); // 1 2 3 4 5
    int array1[] = {5, 4, 3, 2, 1};
    straightInsertSort(array1, 4);
    printArray(array1); // 1 2 3 4 5
    return 0;
}
```

4、时间复杂度分析\
直接插入排序根据排序序列的不同，找插入位置的时间复杂度是不同的，可分为最好、最坏、平均情况分析

* 最好情况，本身是正序的，每个记录只需要和前一个记录比较，不小于前一个记录，则什么都不做，总的比较次数为

![最好情况](<../../../.gitbook/assets/屏幕截图 2022-06-10 234220.jpg>)

* 最坏情况，待排序序列本身是逆序的，每个记录都要比较i次，包括前i-1记录比较，如(5,4,3,2,1)比较次数为(0,1,2,3,4)，等差数列求和

![最坏情况](<../../../.gitbook/assets/屏幕截图 2022-06-10 234711.jpg>)

* 平均情况，若待排序序列出现的概率相等，则可取最好情况和最坏情况的平均值，为O(n^2)

5、空间复杂度\
常量空间，O(1)

6、稳定性\
此算法是稳定的，但是与比较运算符息息相关，如在寻找插入位置时如果元素相等时还向前找，则变成了不稳定的排序算法

```cpp
void straightInsertSort(int array[], int n)
{
    //从下标1处理到下标n
    for (int i = 1; i <= n; i++)
    {
        //寻找插入位置
        int j = i - 1;
        int val = array[i];
        while (j >= 0 && array[j] >= val)
        {
            array[j + 1] = array[j];
            cout << "[" << i << "] " << array[0] << " " << array[1] << " " << array[2] << " " << array[3] << " " << array[4] << endl;
            j--;
        }
        if (i - 1 != j) //原来array[i]需要进行移动
        {
            array[++j] = val;
        }
    }
}
```
