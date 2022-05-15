---
coverY: 0
---

# 🐤 链栈

## 链栈

### 定义数据结构

```cpp
#include <iostream>
using namespace std;

typedef struct Snode
{
    int data;
    struct Snode *next;
} Snode, *LinkStack;
```

### 释放链栈空间

* 时间复杂度 O(n)
* 空间复杂度 O(1)

```cpp
/**
 * @brief 释放链栈
 *
 * @param S
 */
void free_link_stack(LinkStack &S)
{
    auto ptr = S;
    while (ptr != nullptr)
    {
        auto temp = ptr;
        ptr = ptr->next;
        delete temp;
    }
    S = nullptr;
}
```

### 判断栈是否为空

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**
 * @brief 判断栈是否为空
 *
 * @param S
 * @return true
 * @return false
 */
bool empty(LinkStack &S)
{
    return S == nullptr;
}
```

### 初始化链栈

* 时间复杂度O(1)
* 空间复杂度O(1)

```cpp
/**
 * @brief 初始化没有头结点的链栈
 *
 * @param S 栈
 * @return true
 * @return false
 */
bool InitStack(LinkStack &S)
{
    if (S != nullptr)
    {
        free_link_stack(S);
    }
    S = NULL;
    return true;
}
```

### push操作

* 时间复杂度O(1)
* 空间复杂度O(1)

```cpp
/**
 * @brief 对链栈push元素
 *
 * @param S 栈
 * @param e push的内容
 * @return true
 * @return false
 */
bool Push(LinkStack &S, int e)
{
    LinkStack p;
    p = new Snode; // 生成新结点
    p->data = e;   // 将e放在新结点数据域
    p->next = S;   // 将新结点的指针域指向 S,即 将S的地址赋给新结点的指针域
    S = p;         // 修改栈顶指针为最新的节点
    return true;
}
```

### pop操作

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**
 * @brief pop操作
 *
 * @param S 栈
 * @param e pop出去的内容
 * @return true
 * @return false
 */
bool Pop(LinkStack &S, int &e)
{
    LinkStack p;
    if (empty(S)) //栈空
        return false;
    e = S->data; // 将栈顶元素赋给 e
    p = S;       //用 p 保存栈顶元素地址，以备释放
    S = S->next; // 修改栈顶指针，指向下一个结点
    delete p;    //释放原栈顶元素的空间
    return true;
}
```

### 取栈顶元素

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**
 * @brief 获取栈顶元素
 *
 * @param S
 * @return int
 */
int GetTop(LinkStack S)
{
    if (!empty(S))
        return S->data;
    else
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
    int n, x;
    LinkStack S = nullptr;
    InitStack(S); // 初始化一个栈
    cout << "n" << endl;
    cin >> n;
    while (n--)
    {
        cin >> x;
        Push(S, x);
    }
    while (!empty(S))
    {
        cout << GetTop(S) << " ";
        Pop(S, x);
    }
    free_link_stack(S); //释放链栈
    cout << endl;
    return 0;
}
/*
n
5
1 2 3 4 5
5 4 3 2 1
*/
```
