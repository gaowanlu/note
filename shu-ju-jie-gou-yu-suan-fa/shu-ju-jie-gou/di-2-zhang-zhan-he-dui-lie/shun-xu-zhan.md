---
coverY: 0
---

# 😅 顺序栈

## 顺序栈

栈是允许在一端进行插入或删除操作的受限的线性表。

### 栈数据结构

```cpp
#include <iostream>
using namespace std;
#define Maxsize 100 //预先分配空间，这个数值根据实际需要预估确定；

/**
 * @brief 顺序栈
 *
 */
typedef struct SqStack
{
    int *base=nullptr; //栈底指针，用于存储线性存储空间的头地址
    int *top=nullptr;  //栈顶指针
} SqStack;
```

### 初始化栈空间

* 时间复杂度 O(1) 执行的都是顺序语句
* 空间复杂度O(1) 因为Maxsize是一个常量，所以每执行一次都是使用常量空间

```cpp
/**
 * @brief 初始化栈空间
 *
 * @param S 栈
 * @return true 初始化成功
 * @return false 初始化失败
 */
bool InitStack(SqStack &S)
{
    if (S.base != nullptr)
    {
        free_stack(S);
    }
    S.base = new int[Maxsize]; //为顺序栈分配一个最大容量为Maxsize的空间
    //当然可以使用 (int*)malloc(sizeof(int)*Maxsize) 使用 free 释放
    if (!S.base) //空间分配失败
        return false;
    S.top = S.base; // top初始为base空栈，即指向头地址
    return true;    //初始化成功
}
```

### push操作

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**
 * @brief 追加新的数据e到栈内
 *
 * @param S 栈
 * @param e 要push进栈的数据
 * @return true push成功
 * @return false push失败
 */
bool Push(SqStack &S, int e)
{
    //当.top==.base时 size=0
    if (S.top - S.base == Maxsize) //栈满
        return false;
    *(S.top++) = e;
    //元素e压入栈顶，然后栈顶指针加1，等价于*S.top=e; S.top++;
    return true;
}
```

### pop操作

* 时间复杂度 O(1)
* 空间复杂度 O(1)

```cpp
/**
 * @brief 从栈内弹出栈顶元素
 *
 * @param S 栈
 * @param e 存储栈顶内容
 * @return true 弹出成功
 * @return false 弹出失败
 */
bool Pop(SqStack &S, int &e) //删除S的栈顶元素，暂存在变量e中
{
    if (S.base == S.top) //栈空
        return false;
    e = *(--S.top); //栈顶指针减1，将栈顶元素赋给e
    return true;
}
```

### 获取栈顶内容

* 时间复杂度O(1)
* 空间复杂度O(1)

```cpp
/**
 * @brief 获取栈顶内容
 *
 * @param S 栈
 * @return int 栈顶内容
 */
int GetTop(SqStack S)
{
    if (S.top != S.base)     //栈非空
        return *(S.top - 1); //返回栈顶元素的值，栈顶指针不变
    else
        return -1;
}
```

### 判断栈是否为空

* 时间复杂度O(1)
* 空间复杂度O(1)

```cpp
/**
 * @brief 判断栈是否为空
 *
 * @return true
 * @return false
 */
bool empty(SqStack &stack)
{
    if (stack.base == nullptr)
    {
        return true;
    }
    if (stack.base == stack.top)
    {
        return true;
    }
    return false;
}
```

### 释放栈空间

* 时间复杂度O(1)
* 空间复杂度O(1)

```cpp
/**
 * @brief 释放栈空间
 *
 * @param stack
 */
void free_stack(SqStack &stack)
{
    if (stack.base != nullptr)
    {
        delete stack.base;
        stack.base = nullptr;
        stack.top = stack.base;
    }
}
```

### 测试样例

```cpp
/**
 * @brief 样例测试
 *
 * @return int
 */
int main()
{
    int n, x;
    SqStack S;
    InitStack(S); //初始化一个顺序栈S
    cout << "n:\n";
    cin >> n;
    while (n--)
    {
        cin >> x;
        Push(S, x);
    }
    cout << "pop seq" << endl;
    while (!empty(S)) //如果栈不空，则依次出栈
    {
        cout << GetTop(S) << "\t"; //输出栈顶元素
        Pop(S, x);                 //栈顶元素出栈
    }
    free_stack(S);
    cout << "stack is empty: " << (empty(S) ? "true" : "false") << endl;
    return 0;
}

/*
n:
5
1 2 3 4 5
pop seq
5       4       3       2       1       stack is empty: true
*/
```
