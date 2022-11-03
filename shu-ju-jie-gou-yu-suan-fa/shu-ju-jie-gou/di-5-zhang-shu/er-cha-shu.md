---
coverY: 0
---

# 🌴 二叉树

## 二叉树

何为二叉树？二叉树简单的说就是度为2的树、也就是每个节点最多有两个孩子节点，并且二叉树是有序树，左右位置不能互换

### 二叉树的性质

1、二叉树的第i层上至多有2^(i-1)个节点\
2、深度为k的二叉树最多有2^k - 1 个节点\
3、对于一棵二叉树，若叶子数为n0 ,度为2的节点数为n2,则n0=n2+1

```cpp
证: 设总结点数为n，度为0数量为n0，度为1数量为n1,度为2数量为n2,则有 n=n0+n1+n2
分支数为 b=n1+2*n2 则有 b+1=n
n1+2*n2+1=n0+n1+n2
n2+1=n0
故 n0=n2+1
```

4、满二叉树，深度为k且有2^k - 1个节点的二叉树，满二叉树每层都是满的，即每层达到了最多的容量

5、完全二叉树，除了最后一层，其余每一层都是满的，走后一层节点是从左向右出现的

6、具有n个节点的完全二叉树的深度必为 ⌊log2 n⌋+1

```cpp
证：因为2^(k-1)<=n<=2^k - 1 ,右边放大 2^(k-1)<=n<=2^k,同时取对数，k-1<=log2n<k,故k= ⌊log2 n⌋+1  
```

7、对于完全二叉树，若从上至下、从左至右编号，则编号为i的节点，其左孩子编号必为2i,其有孩子编号必为2i+1，其双亲编号必为i/2

### 树和森林与二叉树的转换

* 树与二叉树

```cpp
    A
  / | \
 B  C  D
    /  /
    E  F
长子当作左孩子，兄弟关系向右斜
            A
           /
          B
            \
             C
           /  \
          E    D
              /
             F
树转二叉树 则长子当作左孩子，兄弟关系向右斜
```

* 森林和二叉树的转换

长子当作左孩子，兄弟关系向右斜

```cpp
    B    C   D
   / \      / \
  E   F    G   H
          /
         I
长子当作左孩子，兄弟关系向右斜
        B
       / \
      E   C
       \   \
        F   D
           /
          G
         / \
        I   H
还原为森林则为，进行反操作就好了
```

### 二叉树的存储结构

* 顺序存储

```
    A
  / | \
 B  C  D
    /  /
    E  F

0 1 2 3 4 5 6 7 8 9 10 11 12 13
A B C D 0 0 E 0 F 0  0  0  0  0

没有孩子的位置补0
```

* 链式存储

二叉链表节点

```cpp
struct Node{
    type data;
    Node*left;//左孩子
    Node*right;//右孩子
};
```

三叉链表节点

```cpp
struct Node{
    type data;
    Node*parent;//双亲节点
    Node*right;//右孩子
    Node*left;//左孩子
}
```

### 二叉树的创建

* 询问法

```cpp
//main1.cpp
#include <iostream>
using namespace std;
typedef struct Node
{
    int data;
    Node *left;
    Node *right;
} BinNode, *BinTree;

/**
 * @brief Create a Bin Tree object
 *
 * @param tree 节点指针的引用
 */
void createBinTree(BinTree &tree)
{
    char ch;
    tree = new BinNode;
    cout << "input data" << endl;
    cin >> tree->data;
    tree->left = nullptr;
    tree->right = nullptr;
    cout << "add left child? Y/N" << endl;
    cin >> ch;
    if (ch == 'Y')
    {
        createBinTree(tree->left);
    }
    cout << "add right child? Y/N" << endl;
    cin >> ch;
    if (ch == 'Y')
    {
        createBinTree(tree->right);
    }
}

/**
 * @brief print BinTree Seq
 *
 * @param tree
 */
void printBinTree(BinTree tree)
{
    if (tree == nullptr)
    {
        return;
    }
    printBinTree(tree->left);
    cout << tree->data << endl;
    printBinTree(tree->right);
}

int main(int argc, char **argv)
{
    BinTree tree;
    createBinTree(tree);
    printBinTree(tree);
    return 0;
}
/*
input data
1
add left child? Y/N
input data
3
add left child? Y/N
N
add right child? Y/N
N
2
1
3
*/
```

* 补空法

```cpp
//main2.cpp
#include <iostream>
using namespace std;
typedef struct Node
{
    int data;
    Node *left;
    Node *right;
} BinNode, *BinTree;

/**
 * @brief Create a Bin Tree object
 *
 * @param tree 节点指针的引用
 */
void createBinTree(BinTree &tree)
{
    int data;
    cout << "input data" << endl;
    cin >> data;
    if (data != -1)
    {
        tree = new BinNode;
        tree->data = data;
        createBinTree(tree->left);
        createBinTree(tree->right);
    }
    else
    {
        tree = nullptr;
    }
}

/**
 * @brief print BinTree Seq
 *
 * @param tree
 */
void printBinTree(BinTree tree)
{
    if (tree == nullptr)
    {
        return;
    }
    printBinTree(tree->left);
    cout << tree->data << endl;
    printBinTree(tree->right);
}

int main(int argc, char **argv)
{
    BinTree tree;
    createBinTree(tree);
    printBinTree(tree);
    return 0;
}
/*
input data
1
input data
2
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
2
1
3
*/
```
