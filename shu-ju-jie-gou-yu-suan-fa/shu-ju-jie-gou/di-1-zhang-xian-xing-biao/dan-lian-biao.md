---
coverY: 0
---

# 🐧 单链表

## 单链表

* 链表的优点 链表是动态存储、不需要预先分配空间、用多少加多少，再插入新的元素时不会像顺序表一样需要移动元素
* 链表的缺点 每个节点都需要知道下一个节点的地址、需要在节点内有指针域，而指针变量本身需要存储空间、增加了内存开销，存储密度低(数据所占空间/节点所占总空间)、存取元素需要从头向后查找，属于顺序存取而不是直接索引存取。

1、构造一个空的单链表L 即创建一个头结点，时间复杂度O(1)、空间复杂度O(1)\
2、头插法初始化链表，时间复杂度O(1)、空间复杂度O(n){根据元素个数而言}\
3、尾插法初始化链表，时间复杂度O(1)、空间复杂度O(n){根据元素个数而言}\
4、获取单链表第i个元素，时间复杂度O(n) {与i有关}、空间复杂度O(1)\
5、在带头结点的单链表L中查找值为e的元素，时间复杂度(n)、空间复杂度O(1)\
6、在第i个位置插入新的链表节点,时间复杂度O(n)、空间复杂度O(1)\
7、单链表的第i个节点的删除，时间复杂度O(n)、空间复杂度O(1)\
8、打印链表，时间复杂度O(n)、空间复杂度O(1)

### 自定义数据结构

```cpp
/**
 * @file main.cpp
 * @author your name (you@domain.com)
 * @brief 单向链表
 * @version 0.1
 * @date 2022-04-26
 *
 * @copyright Copyright (c) 2022
 *
 */
#include <iostream>
using namespace std;

//定义链表节点结构体
typedef struct Lnode
{
    int data;           //存储数据
    struct Lnode *next; //存储下一个节点的内存地址
} LNode, *LinkList;     //使用typedef定义别名,LNode等价于Lnode,LinkList等价于Lnode*
```

### 构造一个空的单链表L

```cpp
/**
 * @brief 构造一个空的单链表L 即创建一个头结点，时间复杂度O(1)、空间复杂度O(1)
 *
 * @param L 链表节点结构体指针引用
 * @return true 头结点生成成功
 * @return false 头结点生成失败
 */
bool InitList_L(LinkList &L)
{
    L = new LNode; //生成新结点作为头结点，用头指针L指向头结点
    if (!L)
        return false; //生成结点失败
    L->next = NULL;   //头结点的指针域置空
    return true;
}
```

### 头插法初始化链表

```cpp
/**
 * @brief 头插法初始化链表，时间复杂度O(1)因为n是来我们确定的他是个常数、空间复杂度O(n)[根据元素个数而言]
 *
 * @param L 存储头结点地址的指针的引用
 */
void CreateList_H(LinkList &L)
{
    int n;          //输入n个元素的值，建立到头结点的单链表L
    LinkList s;     //定义一个指针变量
    L = new LNode;  //创建头结点
    L->next = NULL; //先建立一个带头结点的空链表
    cout << "请输入元素个数n：" << endl;
    cin >> n;
    cout << "请依次输入n个元素：" << endl;
    cout << "前插法创建单链表..." << endl;
    while (n--)
    {
        s = new LNode;  //生成新结点s
        cin >> s->data; //输入元素值赋给新结点的数据域
        s->next = L->next;
        L->next = s; //将新结点s插入到头结点之后
    }
}
```

### 尾插法初始化链表

```cpp
/**
 * @brief 尾插法初始化链表，时间复杂度O(1)、空间复杂度O(n)[根据元素个数而言]
 *
 * @param L 存储单链表头结点地址指针的引用
 */
void CreateList_R(LinkList &L)
{
    //输入n个元素的值，建立带表头结点的单链表L
    int n;
    LinkList s, r;
    L = new LNode;  //创建头结点
    L->next = NULL; //先建立一个带头结点的空链表
    r = L;          //尾指针r指向头结点
    cout << "请输入元素个数n：" << endl;
    cin >> n;
    cout << "请依次输入n个元素：" << endl;
    cout << "尾插法创建单链表..." << endl;
    while (n--)
    {
        s = new LNode;  //生成新结点
        cin >> s->data; //输入元素值赋给新结点的数据域
        s->next = NULL;
        r->next = s; //将新结点s插入尾结点r之后
        r = s;       // r指向新的尾结点s
    }
}
```

### 获取单链表第i个元素

时间复杂度、获取第1个元素需要1次循环，第2个2个循环，则平均复杂度为 (1+2+3+...+n)/n=(n+1)/2,即O(n)

```cpp
/**
 * @brief 获取单链表第i个元素，时间复杂度O(n)[与i有关]、空间复杂度O(1)
 *
 * @param L 存储单链表头结点地址指针的引用
 * @param i 获取第i个节点的数据
 * @param e 将第i个节点数据赋值给int&e,以便在函数外可以得到数据
 * @return true 获取第i个数据成功
 * @return false 获取第i个数据失败
 */
bool GetElem_L(LinkList L, int i, int &e)
{
    //在带头结点的单链表L中查找第i个元素
    //用e记录L中第i个数据元素的值
    int j;
    LinkList p;
    p = L->next; // p指向第一个数据结点
    j = 1;       // j为计数器
    //寻找指定节点
    while (j < i && p) //顺着链表向后扫描，直到p指向第i个元素或p为空
    {
        p = p->next; // p指向下一个结点
        j++;         //计数器j相应加1
    }
    if (!p || j > i)
        return false; // i值不合法i＞n或i<=0
    //取值
    e = p->data; //取第i个结点的数据域
    return true;
}
```

### 在带头结点的单链表L中查找值为e的元素

复杂度分析类似于，获取第i个元素复杂度分析

```cpp
/**
 * @brief 在带头结点的单链表L中查找值为e的元素，时间复杂度(n)、空间复杂度O(1)
 *
 * @param L 存储单链表头结点地址指针的引用
 * @param e 需要查找的值（节点data域）
 * @return size_t 目标元素所在第几个位置，头结点为第0个，如果没找到指定元素则返回0
 */
size_t LocateElem_L(LinkList L, int e)
{
    LinkList p;
    p = L->next; //指向第1个数据节点
    std::size_t index = 1;
    while (p && p->data != e) //沿着链表向后扫描，直到p空或p所指结点数据域等于e
    {
        p = p->next; // p指向下一个结点
        index++;
    }
    if (!p)
        return 0; //查找失败p为NULL
    return index;
}
```

### 在第i个位置插入新的链表节点

复杂度类似于获取第i个元素类似，我们在第i个位置插入总需要至少i-1比较

```cpp
/**
 * @brief 在第i个位置插入新的链表节点,时间复杂度O(n)、空间复杂度O(1)
 *
 * @param L 存储单链表头结点地址指针的引用
 * @param i 插入到第i位置
 * @param e 新节点的data域要存储的内容
 * @return true 插入新节点成功
 * @return false 插入新节点失败
 */
bool ListInsert_L(LinkList &L, int i, int e)
{
    //在带头结点的单链表L中第i个位置插入值为e的新结点
    int j;
    LinkList p, s;         // p为迭代器指针，s指针用于存储生成新的节点的内存地址
    p = L;                 //将迭代器指针存储为链表的头结点地址
    j = 0;                 // j记录p现在在第几个节点，头结点在第0个位置
    while (p && j < i - 1) //查找第i-1个结点，p指向该结点，可见i应该大于等于1，要找的目标节点为j==i-1,即第i个节点的前一个节点
    {
        p = p->next;
        j++;
    }
    if (!p || j != i - 1) //表链表没有第i个节点（头结点为第0个节点），我们要的效果是j==i-1
        return false;     //插入失败
    //找到了第i个位置的前一个节点
    s = new LNode;     //生成新结点
    s->data = e;       //将新结点的数据域置为e
    s->next = p->next; //将新结点的指针域指向结点ai
    p->next = s;       //将结点p的指针域指向结点s
    return true;       //插入成功
}
```

### 单链表的第i个节点的删除

复杂度分析与获取第i个元素类似

```cpp
/**
 * @brief 单链表的第i个节点的删除，时间复杂度O(n)、空间复杂度O(1)
 *
 * @param L 存储单链表头结点地址指针的引用
 * @param i 删除第i个节点，头结点为第0个节点
 * @return true 删除成功
 * @return false 删除失败
 */
bool ListDelete_L(LinkList &L, int i)
{
    //在带头结点的单链表L中，删除第i个位置
    LinkList p, q;
    int j;
    p = L;
    j = 0;
    //先找第i-1个位置的节点，即寻找第i个位置的前一个位置的节点
    while ((p->next) && (j < i - 1)) //查找第i-1个结点，p指向该结点
    {
        p = p->next;
        j++;
    }
    if (!(p->next) || j != i - 1) //链表没有第i节点或、当i>n或i<1时，删除位置不合理
        return false;
    q = p->next;       //临时保存被删结点的地址以备释放空间
    p->next = q->next; //改变删除结点前驱结点的指针域
    delete q;          //释放被删除结点的空间
    return true;
}
```

### 打印链表

```cpp
/**
 * @brief 打印链表，时间复杂度O(n)、空间复杂度O(1)
 *
 * @param L 存储单链表头结点地址指针的引用
 */
void printLinklist(LinkList &L)
{
    if (L == nullptr)
    {
        return;
    }
    LNode *p = L->next;
    while (p)
    {
        std::cout << p->data << " " << std::endl;
        p = p->next;
    }
}
```

### 单链表数据结构测试

```cpp
/**
 * @brief 单链表数据结构测试
 *
 * @param argc
 * @param argv
 * @return int
 */
int main(int argc, char **argv)
{
    LinkList mlist;
    //以头插法初始化为例子
    CreateList_H(mlist);  // input 1 2 3 4 5 6 7 8 9 10
    printLinklist(mlist); // output 10 9 8 7 6 5 4 3 2 1
    int e;
    GetElem_L(mlist, 2, e);
    cout << e << endl;                      // 9
    cout << LocateElem_L(mlist, 9) << endl; // 2
    ListInsert_L(mlist, 1, 888);
    printLinklist(mlist); // 888 10 9 8 7 6 5 4 3 2 2 1
    ListDelete_L(mlist, 2);
    printLinklist(mlist); // 888 9 8 7 6 5 4 3 2 1
    return 0;
}
```
