---
coverY: 0
---

# 🐽 顺序表

## 顺序表

顺序表的连续空间有两种初始化方式一种是直接定义数组，即固定大小分配,也就是我们固定了其最大长度。另一种是使用动态内存分配，如C中的malloc(sizeof(int)\*n)与c++中的new int\[n],动态分配的内存是堆内存，在C/C++中没有自动GC，需要我们手动释放,free()与delete，使得我们对其最大长度进行可控

1、 构造一个空的顺序表L，最大长度为Maxsize,时间复杂度为O(1)、空间复杂度O(1)\
2、获取顺序表指定元素,时间复杂度O(1)、空间复杂度O(1)\
3、查找表内是否有某个元素int e,时间复杂度O(n)、空间复杂度O(1)\
4、在指定位置插入指定元素,时间复杂度O(n)、空间复杂度O(1)\
5、删除顺序表中指定位置的元素，时间复杂度O(n)、空间复杂度O(1)\
6、销毁顺序表，时间复杂度O(1)、空间复杂度O(1)\
7、打印顺序表到终端，时间复杂度O(n)、空间复杂度O(1)

### 自定义顺序表数据结构

```cpp
/**
 * @file main.cpp
 * @author gaowanl (you@domain.com)
 * @brief 线性表-顺序表
 * @version 0.1
 * @date 2022-03-01
 *
 * @copyright Copyright (c) 2022
 *
 */
#include <iostream>
using namespace std;

#define Maxsize 100 //每个顺序表最大存储Maxsize个元素

/**
 * @brief int数据顺序表
 *
 */
typedef struct
{
    int *elem;
    int length; //记录线性表末尾用到那里了，初始为0表示用到了0前面一个位置也就没有任何使用
} SqList;
```

### 初始化顺序表

```cpp
/**
 * @brief 构造一个空的顺序表L，最大长度为Maxsize,时间复杂度为O(1)、空间复杂度O(1)
 *
 * @param L 顺序表数据结构SqList引用
 * @return true 初始化成功
 * @return false 初始化失败
 */
bool InitList(SqList &L) //在此使用C++引用，否则在C语言使用二维指针
{
    L.elem = new int[Maxsize]; //为顺序表分配Maxsize个空间

    if (!L.elem)
        return false; //存储分配失败

    L.length = 0; //空表长度为0

    return true;
}
```

### 获取指定位置元素

```cpp
/**
 * @brief 获取顺序表指定元素,时间复杂度O(1)、空间复杂度O(1)
 *
 * @param L 顺序表数据结构
 * @param i 获取第i个元素
 * @param e int类型引用
 * @return true int&e获取第i个位置元素引用成功
 * @return false int&e获取第i个位置元素引用成功
 */
bool GetElem(SqList L, int i, int &e)
{

    if (i < 1 || i > L.length)
        return false;
    //判断i值是否合理，若不合理，返回false
    e = L.elem[i - 1]; //第i-1的单元存储着第i个数据
    return true;
}
```

### 查找元素

时间复杂度

最好情况：元素正好在第一个位置，比较一次就查找成功，时间复杂度为O(1)\
最坏情况：元素正好在最后一个位置，比较n次查找成功，时间复杂度为O(1)\
平均情况：查找第一个元素必须1次比较、第二个元素要2次比较、第i个元素需要i此比较，把每种情况比较次数乘以其查找概率P(i)并求和，即为平均复杂度.(1/n)(1+2+3+...+n)=(n+1)/2,在此情况是那个元素被查找的概率是1/n,故平均复杂度为O((n+1)/2) 即 O(n)

空间复杂度

除存储处理数据本身，常量空间，故为O(1)

```cpp
/**
 * @brief 查找表内是否有某个元素int e,时间复杂度O(n)、空间复杂度O(1)
 *
 * @param L 顺序表
 * @param e 要查找的元素int e
 * @return int 当搜索到目标元素e 返回int n 表示为顺序表中第n个元素
 * @return -1 表示没有找到目标元素int e
 */
int LocateELem(SqList L, int e)
{
    //遍历所有元素
    for (int i = 0; i < L.length; i++)
        if (L.elem[i] == e)
            return i + 1; //第几个元素，例如第5个元素，下标其实为4
    return -1;
}
```

### 在指定位置插入元素

时间复杂度

在插入时，有n+1个位置供我们进行插入，例如第一个元素的前面，我们则需要移动n个元素，在最后一个元素后插入需要移动0个元素，故平均时间复杂度为(n+(n-1)+(n-2)+...+0)/(n+1),每个位置插入的概率为1/(n+1)

```cpp
/**
 * @brief 在指定位置插入指定元素,时间复杂度O(n)、空间复杂度O(1)
 *
 * @param L 顺序表
 * @param i 表示在第i个位置插入新的元素，i>=1且i<=L.length
 * @param e 要插入的元素
 * @return true 插入成功
 * @return false 插入失败
 */
bool ListInsert_Sq(SqList &L, int i, int e)
{
    if (i < 1 || i > L.length + 1) // i值不合法 i必须在 1<=i<=L.length+1
        return false;
    if (L.length == Maxsize) //存储空间已满
        return false;
    //最后一个元素的下标为L.length-1 需要 将目标下标i-1 及后面的元素向后移动一个位置
    for (int j = L.length - 1; j >= i - 1; j--)
        L.elem[j + 1] = L.elem[j]; //从最后一个元素开始后移，直到第i个元素后移
    L.elem[i - 1] = e;             //将新元素e放入第i个位置
    L.length++;                    //表长增1
    return true;
}
```

### 删除指定位置元素

复杂度分析

时间复杂度分析与插入元素类似,((n-1)+...+1+0)/n=(n-1)/2,即O(n)

```cpp
/**
 * @brief 删除顺序表中指定位置的元素，时间复杂度O(n)、空间复杂度O(1)
 *
 * @param L 顺序表
 * @param i 删除第i位置的元素 i>=1 且 i<L.length
 * @param e 将删除额元素赋值给e
 * @return true 删除成功
 * @return false 删除失败
 */
bool ListDelete_Sq(SqList &L, int i, int &e)
{
    if ((i < 1) || (i > L.length)) // 1<=i<=L.length-1
        return false;              // i值不合法
    e = L.elem[i - 1];             //将欲删除的元素保留在e中
    //从下标i-1开始将后面的元素向前移动一个位置
    for (int j = i; j <= L.length - 1; j++)
        L.elem[j - 1] = L.elem[j]; //被删除元素之后的元素前移
    L.length--;                    //表长减1
    return true;
}
```

### 销毁顺序表

```cpp
/**
 * @brief 销毁顺序表，时间复杂度O(1)、空间复杂度O(1)
 *
 * @param L 顺序表
 */
void DestroyList(SqList &L)
{
    if (L.elem)
        delete[] L.elem; //释放手动分配的堆存储空间
}
```

### 打印顺序表

```cpp
/**
 * @brief 打印顺序表到终端，时间复杂度O(n)、空间复杂度O(1)
 *
 * @param L 顺序表
 */
void PrintList(SqList &L)
{
    //遍历顺序表每个元素
    for (int i = 1; i <= L.length; i++)
    {
        int el;
        GetElem(L, i, el); //获取第i个位置的元素值
        cout << el << " ";
        if (i == L.length)
            cout << "\n";
    }
}
```

### 测试使用自定义顺序表

```cpp
int main(int argc, char **argv)
{
    SqList L;    //定义顺序表
    InitList(L); //初始化顺序表空间
    for (int i = 1; i < 5; i++)
        ListInsert_Sq(L, i, i);       //插入元素i到第i个位置
    PrintList(L);                     //打印顺序表
    cout << LocateELem(L, 3) << endl; //打印第3个元素
    int temp;
    ListDelete_Sq(L, 1, temp); //删除第1个元素
    cout << temp << endl;      //打印刚刚删除的第1个位置的元素
    PrintList(L);              //打印顺序表
    ListInsert_Sq(L, 1, 100);  //插入元素100到第1个位置
    PrintList(L);              //打印顺序表
    DestroyList(L);            //释放顺序表空间
    return 0;
}
/*
1 2 3 4
3
1
2 3 4
100 2 3 4
*/
```
