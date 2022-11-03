---
coverY: 0
---

# 📼 顺序队列

## 顺序队列

队列简称队，是一种操作受限的线性表、只允许在表的一端进行插入、而在表的另一端进行删除，遵循First In First Out 先进先出的规则。

非循环队列会出现，使用的空间一直向后走，无论入队还是出队，front与rear都会增加，最后会出现假溢出的情况，也就是还有空间用但是它且不会用，而如果想象将线性表的尾部接到头部就好了，形成一个逻辑上的环状。 一般而言队列都是循环队列、本质上是为了解决判断队满与队空的情况。

### 定义数据结构

```cpp
#include <iostream>
using namespace std;

#define Maxsize 100

/**
 * @brief 循环顺序队列
 *
 */
typedef struct SqQueue
{
    int *base;       //基地址
    int front, rear; // 头指针，尾指针
} SqQueue;
```

### 队列初始化

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**
 * @brief 循环队列的初始化
 *
 * @param Q
 * @return true
 * @return false
 */
bool InitQueue(SqQueue &Q)
{
    Q.base = new int[Maxsize]; // 分配空间
    if (!Q.base)
        return false;
    Q.front = Q.rear = 0; // 头指针和尾指针置为 0，即队列为空
    return true;
}
```

### 入队列

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**
 * @brief 入队列操作
 *
 * @param Q
 * @param e
 * @return true
 * @return false
 */
bool EnQueue(SqQueue &Q, int e)
{
    //尾指针后移一位等于头指针，表明队满总之元素总是存储在头指针后与尾指针前
    // Maxsize是为了解决当rear在最后一个位置时能后表达其后面一个位置为0，达到循环的效果
    if ((Q.rear + 1) % Maxsize == Q.front)
        return false;
    Q.base[Q.rear] = e;              //新元素插入队尾
    Q.rear = (Q.rear + 1) % Maxsize; //队尾指针加1
    return true;
}
```

### 出队列

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**
 * @brief 出队操作
 *
 * @param Q
 * @param e
 * @return true
 * @return false
 */
bool DeQueue(SqQueue &Q, int &e)
{
    //判断队空的的表达式为rear==front
    if (Q.rear == Q.front)
        return false;
    e = Q.base[Q.front];               //保存队头元素
    Q.front = (Q.front + 1) % Maxsize; //队头指针加1
    return true;
}
```

### 获取队头内容

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**
 * @brief 获取队列头内容
 *
 * @param Q
 * @return int
 */
int GetHead(SqQueue Q)
{
    //如果循环队列存放元素不为空
    if (Q.front != Q.rear)
        return Q.base[Q.front];
    return -1; //空则返回-1
}
```

### 队列长度

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**
 * @brief 计算队列的使用长度
 *
 * @param Q
 * @return int
 */
int QueueLength(SqQueue Q)
{
    //非空
    return (Maxsize - Q.front + Q.rear) % Maxsize;
    //使用
    /*
        r   f
    0 1 2 3 4 5 6 7 8 9
    * * *   * * * * * *
    Maxsize-f 是 f 到末尾的个数
    r 是 0 到 r的个数 加起来就是元素的个数
      f           r
    0 1 2 3 4 5 6 7 8 9
      * * * * * * *
    Maxsize-f 为 f 到末尾个数
    r 为 0 到 r的个数
    二者的和 - 总长 则为 二者公共的部分
    */
}
```

### 释放队列

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**
 * @brief 释放队列
 *
 * @param q
 */
void free_queue(SqQueue &q)
{
    if (q.base != nullptr)
    {
        free(q.base);
    }
}
```

### 测试样例

```cpp
/**
 * @brief 测试
 *
 * @return int
 */
int main()
{
    SqQueue Q;
    int n, x;
    InitQueue(Q);
    cout << "n:" << endl;
    cin >> n;
    while (n--)
    {
        cin >> x;
        EnQueue(Q, x);
    }
    cout << endl;
    cout << "queue length " << QueueLength(Q) << endl;
    cout << "first el " << GetHead(Q) << endl;
    cout << "pop seq" << endl;
    while (true)
    {
        if (DeQueue(Q, x))
            cout << x << "\t";
        else
            break;
    }
    cout << endl;
    cout << "queue length " << QueueLength(Q) << endl;
    return 0;
}

/*
n:
5
1 2 3 4 5

queue length 5
first el 1
pop seq
1       2       3       4       5
queue length 0
*/
```
