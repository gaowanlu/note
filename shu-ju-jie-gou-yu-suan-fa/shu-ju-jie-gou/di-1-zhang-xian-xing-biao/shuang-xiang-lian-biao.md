---
coverY: 0
---

# ⏰ 双向链表

## 双向链表

与单向链表不同的是，双向链表在每个节点中除了有存储下一个节点的内存的指针，而且有存储上一个节点地址的指针，这样我们就能在所在节点简单的获取此节点前面的节点与后面的节点了

### 定义双向链表数据结构

```cpp
/**
 * @file main.cpp
 * @author your name (you@domain.com)
 * @brief 双向链表
 * @version 0.1
 * @date 2022-04-26
 *
 * @copyright Copyright (c) 2022
 *
 */
#include <iostream>
#include <string>
using namespace std;

typedef struct DuLNode
{
    int data;                     //结点的数据域
    struct DuLNode *prior, *next; //结点的指针域prior存储前面一个节点的地址，next存储后面一个节点的地址
} DuLNode, *DuLinkList;           // LinkList为指向结构体LNode的指针类型
```

### 创建新的空的双向链表

```cpp
/**
 * @brief 创建一个新的空的双向链表
 *
 * @param L 为指针的引用，创建一个新节点作为头结点，使得L存储新建节点的内存地址
 * @return true 创建成功
 * @return false 创建失败
 */
bool InitDuList_L(DuLinkList &L)
{
    L = new DuLNode; //生成新结点作为头结点，用头指针L指向头结点
    if (!L)
        return false;          //生成结点失败
    L->prior = L->next = NULL; //头结点的两个指针域置空
    return true;               //创建头结点成功
}
```

### 前插法创建双向链表

```cpp
/**
 * @brief 前插法创建双向链表
 *
 * @param L 存储头结点地址
 */
void CreateDuList_H(DuLinkList &L)
{
    //输入n个元素的值，建立到头结点的单链表L
    int n;
    DuLinkList s; //定义一个指针变量
    L = new DuLNode;
    L->prior = L->next = NULL; //先建立一个带头结点的空链表
    cout << "请输入元素个数n：" << endl;
    cin >> n;
    cout << "请依次输入n个元素：" << endl;
    cout << "前插法创建单链表..." << endl;
    while (n--)
    {
        s = new DuLNode; //生成新结点s
        cin >> s->data;  //输入元素值赋给新结点的数据域
        if (L->next)     //如果链表头结点后面已经有数据节点了
        {
            L->next->prior = s; //将第一个节点的前指针存储新节点s的地址
        }
        s->next = L->next; //新节点的后指针存储原来第一个节点的地址
        s->prior = L;
        L->next = s; //将新结点s插入到头结点之后
    }
}
```

### 尾插法创建双向链表

```cpp
/**
 * @brief 尾插法创建双向链表
 *
 * @param L 未初始化的DuLinkList
 */
void CreateDuList_T(DuLinkList &L)
{
    int n;
    DuLNode *s, *last;
    //创建头节点
    L = new DuLNode;
    last = L;
    L->prior = L->next = nullptr;
    cin >> n;   //要输入n个元素
    while (n--) //先判断n在--
    {
        s = new DuLNode; //创建新节点
        cin >> s->data;
        s->next = last->next;
        last->next = s;
        s->prior = last;
        last = s;
    }
}
```

### 获取链表第i个节点数据域的内容

```cpp
/**
 * @brief 获取双向链表的第i个节点数据
 *
 * @param L 双向链表头结点地址
 * @param i 获取第i个节点数据
 * @param e 将第i个节点数据存储到e
 * @return true 获取第i个节点数据成功
 * @return false 获取第i个节点数据失败
 */
bool GetElem_L(DuLinkList L, int i, int &e)
{
    //在带头结点的双向链表L中查找第i个元素
    //用e记录L中第i个数据元素的值
    int j;
    DuLinkList p;
    p = L->next;       // p指向第一个结点，
    j = 1;             // j为计数器
    while (j < i && p) //顺链域向后扫描，直到p指向第i个元素或p为空
    {
        p = p->next; // p指向下一个结点
        j++;         //计数器j相应加1
    }
    if (!p || j > i)
        return false; // i值不合法i＞n或i<=0
    e = p->data;      //取第i个结点的数据域
    return true;
}
```

### 查找数据

```cpp
/**
 * @brief 在双向链表中搜索数据e
 *
 * @param L 双向链表
 * @param e 要搜索的值
 * @return 0 搜索失败
 * @return i 此数据在链表第i个节点
 */
int LocateElem_L(DuLinkList L, int e)
{
    if (L == nullptr)
        return false;
    //在带头结点的双向链表L中查找值为e的元素
    DuLinkList p;
    p = L->next;
    std::size_t i = 1;
    //当p为空或者找到e为止
    while (p && p->data != e) //顺链域向后扫描，直到p为空或p所指结点的数据域等于e
    {
        p = p->next; // p指向下一个结点
        i++;
    }
    if (!p)
        return 0;
    return i;
}
```

### 在指定位置插入新节点

```cpp
//双向链表的插入
/**
 * @brief 双向链表的插入
 *
 * @param L 双向链表
 * @param i 插入到第i个节点的位置
 * @param e 插入节点的数据域存储的数据
 * @return  true 插入成功
 * @return  false 插入失败
 */
bool ListInsert_L(DuLinkList &L, int i, int &e)
{
    //在带头结点的单链表L中第i个位置之前插入值为e的新结点
    int j = 0;
    DuLinkList p, s; //创建两个节点指针，s存储新建节点的地址
    p = L;           // p用于迭代
    //头结点为第0个节点
    while (p && j < i) //查找第i个结点，p指向该结点，当i==j时循环可退出
    {
        p = p->next;
        j++;
    }
    if (!p || j > i) // i＞n+1或者i＜1
        return false;
    s = new DuLNode;     //生成新结点
    s->data = e;         //将新结点的数据域置为e
    p->prior->next = s;  //将第i-1个节点的next指针存储为新节点地址
    s->prior = p->prior; //新节点prior指针存储第i-1节点地址
    s->next = p;         //新节点next指针存储第i个节点的地址
    p->prior = s;        //第i个节点的prior指针存储新节点的地址
    return true;
}
```

### 删除第i个数据节点

```cpp
/**
 * @brief 双向链表删除第i个节点
 *
 * @param L 双向链表
 * @param i 第i个节点
 * @return true 删除成功
 * @return false 删除失败
 */
bool ListDelete_L(DuLinkList &L, int i)
{
    //在带头结点的双向链表L中，删除第i个位置
    DuLinkList p;
    int j;
    p = L;
    j = 0;
    //首先需要寻找第i节点
    while (p && j < i)
    {
        p = p->next;
        j++;
    }
    //如果p节点不为空且j==i,则进行删除操作
    if (j == i && p)
    {
        //将其前一个节点的next指针存储其后面节点的地址
        p->prior->next = p->next;
        //其后面一个节点的prior指针存储其前面节点的地址
        if (p->next) //如果p不是最后一个节点
        {
            p->next->prior = p->prior;
        }
        delete p;
        return true;
    }
    return false;
}
```

### 打印双向链表

```cpp
/**
 * @brief 输出双向链表
 *
 * @param L 双向链表
 */
void Listprint_L(DuLinkList L)
{
    if (L == nullptr) //判空
    {
        return;
    }
    DuLinkList p; //用于迭代
    p = L->next;  //指向第一个数据节点
    while (p)
    {
        cout << p->data << "\t";
        p = p->next; //指针向后移动
    }
    cout << endl;
}
```

### 样例测试

```cpp
/**
 * @brief 双向链表demo测试
 *
 * @return int
 */
int main()
{
    DuLinkList list;
    //前插法
    CreateDuList_H(list); // input 5 1 2 3 4 5
    Listprint_L(list);    // output 5 4 3 2 1
    //插入新的节点
    int e = 9;
    //在第一个节点位置插入新的节点
    ListInsert_L(list, 1, e);
    Listprint_L(list);
    // 9       5       4       3       2       1
    //删除第6个节点
    ListDelete_L(list, 6);
    Listprint_L(list);
    // 9       5       4       3       2
    //查找数据4
    cout << LocateElem_L(list, 4) << endl; // 3 数据4在第3个数据节点
    cout << LocateElem_L(list, 1) << endl; // 0 没找到数据1
    Listprint_L(list);
    // 9       5       4       3       2
    return 0;
}
```
