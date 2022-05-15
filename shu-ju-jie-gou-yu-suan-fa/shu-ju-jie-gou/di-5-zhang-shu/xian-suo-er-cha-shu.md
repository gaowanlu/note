---
coverY: 0
---

# 🚜 线索二叉树

## 线索二叉树

什么是线索二叉树？

我们知道二叉树中有许多节点的left后者right指向nullptr，这样无疑是浪费了存储空间，我们能不能利用这些指向nullptr的指针域给利用起来，做点有利的事情呢？

### 关于n+1个空指针域

使用二叉链表存储链表，n个节点的二叉树的指针域有2\*n个，但只有n-1个是实指针，其余n+1个都是空指针，因为除了根节点的每个节点都需要双亲存储其地址所以是n-1个实指针。

### 线索二叉树节点数据结构

```cpp
enum{LINKCHILD,LINEOTHER};
typedef struct BTnode{
    ElemType data;
    struct Bnode*lchild,*rchild;
    int ltag,rtag;
}BTnode,*BTtree;
//ltag标志lchild指向自己的左孩子，还是指向遍历序列的前驱节点
//rtag标志rchild指向自己的右孩子，还是指向遍历序列的后驱节点
```

带有标志域的二叉链表称为`线索链表`，指向前驱和后继的指针称为`线索`，带有线索的二叉树称为`线索二叉树`，以某种遍历方式将二叉树转化为线索二叉树的过程称为线索化。

### 构造与遍历线索二叉树

#### 中序线索二叉树

```cpp
//main1.cpp
#include <iostream>
using namespace std;

enum
{
    LINKCHILD,
    LINKOTHER
};

typedef struct BTnode
{
    int data;
    struct BTnode *lchild, *rchild;
    int ltag, rtag;
} BTnode, *BTtree;

/**
 * @brief 二叉树中序线索化
 *
 * @param now_node 当前所在节点
 * @param pre_node 前驱节点
 */
void InThread(BTnode *&now_node, BTnode *&pre_node)
{
    //对当前所在节点线索化
    if (now_node)
    {
        InThread(now_node->lchild, pre_node); //线索化左子树
        if (!now_node->lchild)                //如果当前节点的左孩子为空
        {
            now_node->ltag = LINKOTHER;  //标志为线索
            now_node->lchild = pre_node; //左孩子指向遍历序列前驱节点
        }
        else
        {
            now_node->ltag = LINKCHILD; //标志为非线索
        }
        //对前驱节点rchild线索化
        if (pre_node)
        {
            if (!pre_node->rchild) //前驱节点的右孩子为空
            {
                pre_node->rtag = LINKOTHER; //将前驱节点的右孩子标记为线索
                pre_node->rchild = now_node;
            }
            else
            {
                pre_node->rtag = LINKCHILD;
            }
        }
        pre_node = now_node; //将前驱指针指向当前节点
        //线索化右子树
        InThread(now_node->rchild, pre_node);
    }
}

/**
 * @brief 创建中序线索
 *
 * @param tree
 */
void createInThread(BTtree &tree)
{
    BTnode *now_node = tree;    //指向现在所在的节点
    BTnode *pre_node = nullptr; //指向刚才遍历的前一个节点
    if (tree)                   //树不为空
    {
        InThread(now_node, pre_node); //中序线索化
        //当线索化结束时 now_node为nullptr pre_node指向中序遍历序列的最后一个节点
        pre_node->rchild = nullptr;
        pre_node->rtag = LINKOTHER; //标记为线索
    }
}

/**
 * @brief 创建代表标志可以被线索化的二叉树
 *
 */
void createBTtree(BTtree &tree)
{
    int data;
    cout << "input data" << endl;
    cin >> data;
    if (data != -1)
    {
        tree = new BTnode;
        tree->data = data;
        //创建左子树
        createBTtree(tree->lchild);
        //创建右子树
        createBTtree(tree->rchild);
    }
    else
    {
        tree = nullptr;
    }
}

/**
 * @brief 遍历中序线索二叉树
 *
 * @param tree
 */
void printInOrderThread(BTtree &tree)
{
    BTtree now = tree; // now为当前节点
    while (now)
    {
        //找到最左节点,最左节点为第一个线索节点
        while (now->ltag == LINKCHILD)
        {
            now = now->lchild;
        }
        //输出节点信息
        cout << now->data << endl;
        //如果右孩子为线索，则线索下去
        while (now->rtag == LINKOTHER && now->rchild)
        {
            now = now->rchild; //去往后驱节点
            cout << now->data << endl;
        }
        now = now->rchild;
    }
}

int main(int argc, char **argv)
{
    BTtree tree;
    createBTtree(tree);
    createInThread(tree);
    printInOrderThread(tree);
    cout << "end" << endl;
    return 0;
}

/*
input data
2
input data
1
input data
-1
input data
-1
input data
3
input data
-1
input data
-1
1
2
3
end
*/
```

#### 先序线索二叉树

```cpp
//等待填坑
```

#### 后序线索二叉树

```cpp
//等待填坑
```
