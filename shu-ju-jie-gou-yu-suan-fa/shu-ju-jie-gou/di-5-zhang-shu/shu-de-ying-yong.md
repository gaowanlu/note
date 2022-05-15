---
coverY: 0
---

# 📀 树的应用

## 树的应用

主要从二叉树遍历与性质求解、哈夫曼树为主

### 二叉树的深度

算法步骤

* 如果二叉树为空、则深度为0
* 否则为根的左子树、右子树深度的最大值加1

```cpp
//main1.cpp
int bin_tree_depth(BinTree &tree)
{
    //二叉树为空则返回0
    if (tree == nullptr)
    {
        return 0;
    }
    //否则返回左子树、右子树的较大值加1
    int left_depth = bin_tree_depth(tree->left);
    int right_depth = bin_tree_depth(tree->right);
    //比较大小并返回深度
    int result = left_depth > right_depth ? left_depth + 1 : right_depth + 1;
    return result;
}
```

### 二叉树的叶子数

算法步骤

* 如果二叉树为空，则叶子数目为0
* 如果根的左右子树都为空，则叶子数为1
* 否则求左子树的叶子数加右子树的叶子数

```cpp
//main2.cpp
int leaf_count(BinTree &tree)
{
    if (tree == nullptr)
        return 0;
    if (tree->left == nullptr && tree->right == nullptr)
    {
        return 1;
    }
    return leaf_count(tree->left) + leaf_count(tree->right);
}
```

### 二叉树的结点数

算法步骤

* 如果二叉树为空，则节点数为0
* 如果左子树右子树都为空，则结点数为1
* 否则求左子树节点数加右子树结点数

```cpp
//main3.cpp
int node_count(BinTree &tree)
{
    if (tree == nullptr)
        return 0;
    return node_count(tree->left) + node_count(tree->right) + 1;
}
```

### 二叉树空节点个数

```cpp
//main4.cpp
int null_node_count(BinTree &tree)
{
    if (tree == nullptr)
    {
        return 1;
    }
    int sum = 0;
    sum += null_node_count(tree->left);
    sum += null_node_count(tree->right);
    return sum;
}
```

### 二叉树满结点个数

```cpp
//main5.cpp
int full_child_node_count(BinTree &tree)
{
    if (tree == nullptr)
        return 0;
    int sum = 0;
    if (tree->left != nullptr && tree->right != nullptr)
    {
        ++sum;
    }
    return sum + full_child_node_count(tree->left) + full_child_node_count(tree->right);
}
```

### 三元组创建二叉树

什么是三元组创建二叉树？也就是以三元组(F,C,L/R),F为C的父节点元素，L/R代表C为F的左孩子还是右孩子。提供这种形式的数据并且按照二叉树的层次输入构建二叉树。

算法步骤

* 输入第一组数据，创建根节点入队列，因为是按照层次输入，可使用队列辅助实现。
* 输入下组数据。
* 如果队列非空，且输入的前项数据非空即F、C非空，则队头出队列。
* 判断输入数据中的双亲是否和队头元素相同，如果不同转向第三步，如果相同则创建一个新节点，判断该节点是左子树还是右子树做出处理，入队列，输入下一组数据，转向第四步。
* 直到队列为空或者输入数据前两项为空，算法停止。

```cpp
//main6.cpp
#include <iostream>
#include <queue>
#include <string>
using namespace std;
typedef struct Node
{
    Node *left;
    Node *right;
    string data;
} * Tree;

/**
 * @brief 三元组创建二叉树
 *
 * @param tree
 */
void create_bi_tree(Tree &tree)
{
    string a, b, c; //三元组<a,b,c>
    //创建队列
    queue<Node *> node_queue;
    //输入第一个三元组
    cin >> a >> b >> c;
    cout << "CHECK: " << a << " " << b << " " << c << endl;
    //二叉树根节点 F=NULL 数据不为NULL
    if (a == "NULL" && b != "NULL")
    {
        Node *node = new Node;
        node->data = b;
        node->left = node->right = nullptr; //左右节点初始化为nullptr
        //保存二叉树根节点
        tree = node;
        //入队列
        node_queue.push(node);
    }
    //输入第2个三元组
    cin >> a >> b >> c;
    cout << "CHECK: " << a << " " << b << " " << c << endl;
    //队列不为空且输入的三元组父亲数据不为NULL自己本身数据不为NULL，否则停止算法
    //即NULL NULL L/R为构建二叉树结束标志
    while (!node_queue.empty() && a != "NULL" && b != "NULL")
    {
        Node *node = node_queue.front(); //取队头
        node_queue.pop();                //出队
        //因为是层次输入，一个节点最多比较两次，并不能保证程序不出错，但默认用户遵循规则
        while (a == node->data)
        {
            Node *new_node = new Node; //创建新节点
            new_node->data = b;
            new_node->left = new_node->right = nullptr;
            if (c == "L") //为队头左孩子
            {
                node->left = new_node;
            }
            else //为队头右孩子
            {
                node->right = new_node;
            }
            //新节点入队列
            node_queue.push(new_node);
            cin >> a >> b >> c; //输入下一组数据
            cout << "CHECK: " << a << " " << b << " " << c << endl;
        }
    }
}

/**
 * @brief print BinTree Seq
 *
 * @param tree
 */
void printBinTree(Node *tree)
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
    Tree tree;
    create_bi_tree(tree);
    printBinTree(tree);
    return 0;
}
/*

输入

NULL A L
A B L
A C R
B D R
C E L
C F R
D G L
F H L
NULL NULL L

遍历序列
B
G
D
A
E
C
H
F
*/
```

### 还原二叉树

根据遍历序列可以还原树，包括二叉树还原、树还原

#### 二叉树的还原

由二叉树的前序序列和中序序列，或者中序序列和后序序列，可以唯一地还原一棵二叉树。

**先序遍历与中序遍历还原二叉树**

算法步骤

* 先序序列地第一个字符为根
* 中序序列中看，以根为中心划分左右子树
* 还原左子树与右子树

```cpp
先序序列 ABDECFG
中序序列 DBEAFGC
A 作根 划分 DBE A FGC
        A
      /  \
    BDE  CFG
    DBE  FGC
左子树还原
BDE
DBE
B作根 划分 D B E
    B
  /  \
 D    E
右子树还原
CFG
FGC
C作根 划分 FG C
    C
   /
 FG
 FG
 还原左子树
 F作根 F 划分  F G
    F
     \
      G
得还原二叉树
         A
       /   \
      B     C
     / \   /
    D   E  F
            \
             G
```

算法实现

```cpp
//main7.cpp
#include <iostream>
using namespace std;
typedef struct Node
{
    Node *left;
    Node *right;
    char data;
} * Tree;

Tree pre_mid_rebuild(const char *pre, const char *mid, int len)
{
    if (len == 0)
    {
        return nullptr; //没有可还原地内容
    }
    char ch = pre[0]; //先序序列第一个节点作为根节点
    int index = 0;
    while (mid[index] != ch) //找到根所在的下标位置
    {
        index++;
    }
    //创建根节点
    Tree tree = new Node;
    tree->data = ch;
    tree->left = pre_mid_rebuild(pre + 1, mid, index);                                //还原左子树并返回左子树根节点
    tree->right = pre_mid_rebuild(pre + index + 1, mid + index + 1, len - index - 1); //还原右子树并返回右子树根节点
    return tree;
}

void printTree(Tree &tree)
{
    if (tree)
    {
        cout << tree->data << endl;
        printTree(tree->left);
        printTree(tree->right);
    }
}

int main(int argc, char **argv)
{
    const char pre[] = {'A', 'B', 'D', 'E', 'C', 'F', 'G'};
    const char mid[] = {'D', 'B', 'E', 'A', 'F', 'G', 'C'};
    Tree tree = pre_mid_rebuild(pre, mid, sizeof(pre));
    printTree(tree); // ABDECFG 即先序序列
    return 0;
}
```

**后序遍历与中序遍历还原二叉树**

```cpp
后序序列 DEBGFCA
中序序列 DBEAFGC
A 作为根 划分 DBE A FGC
    A
   / \
 DEB GFC
 DBE FGC
还原左子树
B作根 D B E
    B
   / \
  D   E
还原右子树
C作根 FG C
    C
  /
 GF
 FG
还原左子树
F作根 F G
    F
     \
      G
还原出的二叉树
         A
       /   \
      B     C
     / \   /
    D   E  F
            \
             G
```

算法实现

```cpp
//main8.cpp
#include <iostream>
using namespace std;
typedef struct Node
{
    Node *left;
    Node *right;
    char data;
} * Tree;

Tree pro_mid_rebuild(const char *pro, const char *mid, int len)
{
    if (len == 0)
        return nullptr;
    //找到后序遍历得最后一个节点作为根
    char ch = pro[len - 1];
    int index = 0;
    while (ch != mid[index])
    {
        index++;
    }
    //创建根节点
    Tree tree = new Node;
    tree->data = ch;
    tree->left = pro_mid_rebuild(pro, mid, index);                                //还原左子树并返回左子树根节点
    tree->right = pro_mid_rebuild(pro + index, mid + index + 1, len - index - 1); //还原右子树并返回右子树根节点
    return tree;
}

void printTree(Tree &tree)
{
    if (tree)
    {
        cout << tree->data << endl;
        printTree(tree->left);
        printTree(tree->right);
    }
}

int main(int argc, char **argv)
{
    const char pro[] = {'D', 'E', 'B', 'G', 'F', 'C', 'A'};
    const char mid[] = {'D', 'B', 'E', 'A', 'F', 'G', 'C'};
    Tree tree = pro_mid_rebuild(pro, mid, sizeof(pro));
    printTree(tree); // ABDECFG 即先序序列
    return 0;
}
```

### 树的还原

树的先根遍历和后根遍历与其对应二叉树的先序遍历和中序遍历相同，树的还原，先还原二叉树，再还原为树

算法步骤

* 树先根遍历和后根遍历与其对应的二叉树的先序遍历和中序遍历相同，因此根据这两个序列，按照先序遍历和中序遍历还原二叉树
* 将二叉树转为树

#### 树的先根遍历和后根遍历

树的先根遍历和后根遍历 对应 其二叉树的先序遍历和中序遍历

已知一棵树的先根遍历ABEFCDGIH 后根遍历EFBCIGHDA

```cpp
则二叉树的先序遍历ABEFCDGIH 中序遍历EFBCIGHDA
二叉树还原
          A                                  A
        /                                  / | \
       B          还原为树                B  C   D
      /  \                              /\      /\
     E     C                           E  F    G  H
      \     \                                 /
       F     D                               I
            /
           G
          / \
         I   H
```

### 森林的还原

森林的先序序列和中序序列 对应 二叉树的先序遍历和中序遍历，先转为二叉树，将二叉树转为森林

```cpp
森林先序遍历 ABCDEFGHJI  中序遍历 BCDAFEJHIG
二叉树先序遍历 ABCDEFGHJI 二叉树中序遍历 BCDAFEJHIG
        A                                  A      E    G
      /   \                              / | \    |   / \
     B     E     二叉树转森林            B  C  D   F  H   I
      \   / \                                        |
       C F   G                                       J
        \    /
         D  H
           / \
          J   I
```

### 哈夫曼树

两段代码的对比

```cpp
if(score<60){
}else if(score<70){
}else if(score<80){
}else if(score<90){
}eles{}
//其分数服从正态分布
if(score<80){
    if(score<70){
        if(score<60){}
        else{}
    }else{}
}else if(score<90){}
else{}
//它们的流程图
        <60
       Y   N
            \
            <70
           Y   N
                \
                <80
               Y  \
                   N
                    \
                    <90
                    Y  N
//可以根据它们出现的频率调整
            <80
           Y   N
         <70   <90
        Y   N  Y   N
      <60
     Y  N
```

哈夫曼树的思想就是概率越大的距离根越近，哈夫曼算法采用贪心策略是从树的集合中取出没有双亲且权值最小的两棵树作为左右子树，构造一棵新树，新树根节点的权值为其左右孩子节点权值之和，并将新树插入树的集合中。

算法实现

```cpp
//哈夫曼树及其编码
#include <iostream>
#include <cstdlib>
#include <vector>
using namespace std;
//定义节点抽象数据结构
struct HuffNode
{
    float weight; //节点权重
    int parent;   //节点的父节点下标
    int lchild;   //节点的左孩子下标
    int rchild;   //节点的右孩子下标
    char value;   //节点的值
};
typedef struct HuffNode HuffNode;

//打印哈夫曼树信息
void PrintHuffTree(HuffNode *HuffTree, int node_num)
{
    int i;
    cout << "HuffTree:\n";
    for (i = 0; i < 2 * node_num - 1; ++i)
    {
        cout << "\t" << HuffTree[i].weight << " ";
        cout << HuffTree[i].parent << " ";
        cout << HuffTree[i].lchild << " ";
        cout << HuffTree[i].rchild << " ";
        cout << HuffTree[i].value << "\n";
    }
}

//哈夫曼编码
void PrintHuffCode(HuffNode *HuffTree, int root, vector<char> &HuffCode)
{
    //每次递归到左孩子为-1,右孩子为-1就输出编码
    if (HuffTree[root].lchild != -1 || HuffTree[root].rchild != -1)
    { //没有遇见叶子节点
        //遍历左子树
        HuffCode.push_back('0');
        PrintHuffCode(HuffTree, HuffTree[root].lchild, HuffCode);
        //遍历右子树
        HuffCode.push_back('1');
        PrintHuffCode(HuffTree, HuffTree[root].rchild, HuffCode);
        //遍历完左子树与右子树后，要将为root节点的编码位删除
        HuffCode.erase(HuffCode.end() - 1);
    }
    else
    { //遇到叶子节点
        cout << HuffTree[root].value << ":\n\t";
        int i;
        for (i = 0; i < HuffCode.size(); i++)
        {
            cout << HuffCode[i];
        }
        cout << endl;
        //输出root节点编码后,将为root节点的编码位删除
        HuffCode.erase(HuffCode.end() - 1);
    }
    return;
}

int main(int argc, char **argv)
{
    //存储要编码的信息个体数量
    const int node_num = 6;
    //则我们共需要2*node_num-1个节点，因为构建的HuffTree共有node_num个节点
    //使用动态内存申请
    struct HuffNode *HuffTree = (struct HuffNode *)malloc(sizeof(struct HuffNode) * (2 * node_num - 1));
    if (!HuffTree)
        return -1; //内存申请失败
    //初始化哈夫曼树原始数据
    int i;
    for (i = 0; i < 2 * node_num - 1; ++i)
    {
        HuffTree[i].weight = 0;
        HuffTree[i].parent = -1;
        HuffTree[i].lchild = -1;
        HuffTree[i].rchild = -1;
    }
    float weight[node_num] = {5, 32, 18, 7, 25, 13};
    char value[node_num] = {'a', 'b', 'c', 'd', 'e', 'f'};
    //权值以及节点数据初始化
    for (i = 0; i < node_num; ++i)
    {
        HuffTree[i].weight = weight[i];
        HuffTree[i].value = value[i];
    }
    //输出初始化后的哈夫曼树
    PrintHuffTree(HuffTree, node_num);

    //开始构建哈夫曼树
    //一共需要node_num-1次合并
    for (i = 0; i < node_num - 1; i++)
    {
        //找两个最小权重且父节点下标为-1的两个节点
        //遍历找到最大权重
        int j;
        float max_weight = -1;
        for (j = 0; j < node_num + i; j++)
        {
            if (max_weight < HuffTree[j].weight)
            {
                max_weight = HuffTree[j].weight;
            }
        }
        float weight_1 = max_weight + 1, weight_2 = max_weight + 1; //存储两个节点的权重
        int index_1 = -1, index_2 = -1;                             //存储两个符合要求的节点的下标
        for (j = 0; j < node_num + i; j++)
        { //找两小
            if (HuffTree[j].weight < weight_1 && HuffTree[j].weight < weight_2 && HuffTree[j].parent == -1)
            { //比次小与最小都小
                weight_2 = weight_1;
                index_2 = index_1;
                weight_1 = HuffTree[j].weight;
                index_1 = j;
            }
            else if (HuffTree[j].weight < weight_2 && HuffTree[j].parent == -1)
            { //比次小小
                weight_2 = HuffTree[j].weight;
                index_2 = j;
            }
        }
        //构建新节点
        HuffTree[index_1].parent = node_num + i; //更新两最小节点的父节点
        HuffTree[index_2].parent = node_num + i;
        //更新新节点权值
        HuffTree[node_num + i].weight = weight_1 + weight_2;
        HuffTree[node_num + i].lchild = index_1; //最小
        HuffTree[node_num + i].rchild = index_2; //次小
    }
    //输出哈夫曼树信息
    PrintHuffTree(HuffTree, node_num);
    //输出哈夫曼编码(采用递归方法)
    vector<char> huff_code;
    cout << "HuffCode:\n";
    PrintHuffCode(HuffTree, 2 * node_num - 2, huff_code);

    //释放哈夫曼树内存
    free(HuffTree);
    return 0;
}
```

输出结果

```cpp
HuffTree:
        5 -1 -1 -1 a
        32 -1 -1 -1 b
        18 -1 -1 -1 c
        7 -1 -1 -1 d
        25 -1 -1 -1 e
        13 -1 -1 -1 f
        0 -1 -1 -1 S
        0 -1 -1 -1 N
        0 -1 -1 -1
        0 -1 -1 -1 O
        0 -1 -1 -1
HuffTree:
        5 6 -1 -1 a
        32 9 -1 -1 b
        18 8 -1 -1 c
        7 6 -1 -1 d
        25 8 -1 -1 e
        13 7 -1 -1 f
        12 7 0 3 S
        25 9 6 5 N
        43 10 2 4
        57 10 7 1 O
        100 -1 8 9
HuffCode:
c:
        00
e:
        01
a:
        1000
d:
        1001
f:
        101
b:
        11
```
