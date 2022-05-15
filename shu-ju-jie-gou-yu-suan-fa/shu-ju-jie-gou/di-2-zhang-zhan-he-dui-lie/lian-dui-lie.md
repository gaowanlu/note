---
coverY: 0
---

# 🛵 链队列

## 链队列

### 定义数据结构

```cpp
# include <iostream>
using namespace std;

typedef struct Qnode
{
    int data;
    struct Qnode *next;
} Qnode,*Qptr;

typedef struct
{
    Qnode *front; //对头指针
    Qnode*rear;  //队尾指针
} LinkQueue;
```

### 队列初始化

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**

* @brief 链队列初始化
*
* @param Q
 */
void InitQueue(LinkQueue &Q) //注意使用引用参数，否则出了函数，其改变无效
{
    Q.front = Q.rear = new Qnode; //创建头结点，头指针和尾指针指向头结点
    Q.front->next = NULL;         //头结点的next初始化为null
}
```

### 释放队列

* 时间复杂度 O(n)
* 空间复杂度 O(1)

```cpp
/**
 * @brief 释放队列Q
 *
 * @param Q
 */
void freeQueue(LinkQueue &Q)
{
    if (Q.front == nullptr)
        return;
    while (Q.front != nullptr)
    {
        auto temp = Q.front;
        Q.front = Q.front->next;
        free(temp);
    }
}
```

### 链队列入队

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**

* @brief 链队列入队
*
* @param Q
* @param e
 */
void EnQueue(LinkQueue &Q, int e)
{
    Qptr s;
    s = new Qnode;
    s->data = e;
    s->next = NULL;
    Q.rear->next = s; //新元素插入队尾
    Q.rear = s;       //队尾指针后移
}
```

### 出队列

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**

* @brief 出队列
*
* @param Q
* @param e
* @return true
* @return false
 */
bool DeQueue(LinkQueue &Q, int &e)
{
    Qptr p;
    if (Q.front == Q.rear) //队空直接返回
        return false;
    p = Q.front->next; //另p指向第一个数据节点
    e = p->data;       //获取第一个节点存储内容
    Q.front->next = p->next;
    if (Q.rear == p) //若队列中只有一个元素，删除后需要修改队尾指针
        Q.rear = Q.front;
    delete p;
    return true;
}
```

### 取队头元素

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**

* @brief 取队头元素
*
* @param Q
* @return int
 */
int GetHead(LinkQueue Q)
{
    if (Q.front != Q.rear) //队列非空
        return Q.front->next->data;
    return -1;
}
```

### 测试样例

```cpp
/**
 * @brief 测试样例
 *
 * @return int
 */
int main()
{
    LinkQueue Q;
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
    cout << "queue heade el" << GetHead(Q) << endl;
    cout << "queue seq" << endl;
    while (true)
    {
        if (DeQueue(Q, x))
            cout << x << "\t";
        else
            break;
    }
    cout << endl;
    freeQueue(Q);
    return 0;
}
/*
n:
5
1 2 3 4 5

queue heade el1
queue seq
1       2       3       4       5
*/
```
