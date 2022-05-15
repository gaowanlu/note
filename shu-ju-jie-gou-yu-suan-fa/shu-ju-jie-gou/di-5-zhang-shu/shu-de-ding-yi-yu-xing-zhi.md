---
coverY: 0
---

# 😇 树的定义与性质

## 树的定义与性质

树是 n个节点 (n>=0)的优先集合，当n=0，为空树:n>0时，为非空树，任意一棵非空树，满足一下两个条件；

（1）有且仅有一个称为根的节点\
（2）除根节点以外，其余节点可分为m(m>0)个互不相交的有限集T1,T2,...,Tm,其中每个集合都是一棵树，并且称为根的子树。

### 关键词

#### 节点

节点包含数据元素以及若干指向子树的分支信息

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
A B C D E 共5个节点
```

#### 节点的度

节点拥有的子树个数

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
B的度为1 C的度为2
```

#### 树的度

树中节点的最大度数

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
节点中度最大的度数为2 故树的最大度数为2
```

#### 终端节点

度为0的节点，又称叶子

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
F D E都是终端节点，又称叶子节点
```

#### 分支节点

度大于0的节点，除了叶子都是分支节点

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
A B C 都是分支节点
```

#### 内部节点

除了树根和叶子都是内部节点

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
B C为内部节点
```

#### 节点的层次

从根节点到该节点的层数

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
A所在层数为1 B所在层数2 D所在层数3
```

#### 树的深度（或高度）

所有节点中最大的层数

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
最大层数为3，故树的深度或高度为3
```

#### 路径

树中两个节点之间经过的节点序列

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
F 与 E的路径为 FBACE
```

#### 路径的长度

两节点之间路径上经过的边数

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
F 与 E的路径为 FBACE、路径长度为4
```

#### 树的路径长度

从树根到每个节点的路径长度的总和

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
A:0 B:1 F:2 C:1 D:2 E:2
sum_length=0+1+2+1+1+2+2=9
```

#### 双亲、孩子

节点的子树的根称为该节点的孩子，反之，该节点为其他孩子的双亲

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
B的双亲为A D的双亲为C
C的孩子为D与E A的孩子为B与C
```

#### 兄弟

双亲相同的接待你互称兄弟

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
B与C互为兄弟、D与E互为兄弟
```

#### 堂兄弟

双亲是兄弟的节点互称堂兄弟

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
F与D、F与E互为堂兄弟
```

#### 祖先

从该节点到树根经过的所有节点称为该节点的祖先

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
D的祖先有C A
F的祖先有B A
```

#### 子孙

节点的子树中的所有节点都称为该节点的子孙

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
B C D E F都是A的子孙
```

#### 有序树

节点的各子树从左到右有序，不能互换位置

```cpp
    A
   / \
  B   C
 /   / \
F   D   E
```

#### 无序树

节点各子树可以互换位置

```cpp
      子树位置互换
    A              A
   / \            / \
  B   C          C   B
 /   / \        / \  /
F   D   E      E  E F
```

#### 森林

由m (m>=0) 棵不相交的树组成的集合

```cpp
    A              A
   / \            / \
  B   C          C   B
 /   / \        / \  /
F   D   E      E  E F       ......
```

### 重要性质

1、树中节点的数量等于所有结点度数+1,因为根节点上面没有边\
2、度为m的树中第i层至多有m^(i-1)个节点(i>=1)\
3、高度为h的m叉树至多有(m^h - 1)(m-1)个节点 4、具有n个节点的m叉树的最小高度为 取上界(log m (n(m-1)+1) )

### 树的存储结构

#### 顺序存储

**双亲表示法**

```cpp
    data    parent
0   A       -1
1   B       0
2   C       0
3   F       1
4   D       2
5   E       2
```

```cpp
#define MAX_TREE_SIZE 100
typedef struct{
    ElementType data;
    int parent;
}PTNode;
typedef struct{
    PTNode nodes[MAX_TREE_SIZE];
    int n;//记录使用到哪里了
}PTree;
```

**孩子表示法**

```cpp
    data    child   child
0   A       1       2
1   B       3       -1
2   C       4       5
3   F       -1      -1
4   D       -1      -1
5   E       -1      -1
```

```cpp
#define MAX_TREE_SIZE 100
#define CHILD_MAX_SIZE 2//树的度
typedef struct{
    ElementType data;
    int child1;
    int child2;
    //或者使用数组形式
    //int childs[CHILD_MAX_SIZE];
    //int n;
}CTNode;
typedef struct{
    CTNode nodes[MAX_TREE_SIZE];
    int n;//记录使用到哪里了
}CTree;
```

**双亲孩子表示法**

```cpp
    data    parent  child   child
0   A       -1      1       2
1   B       0       3       -1
2   C       0       4       5
3   F       1       -1      -1
4   D       2       -1      -1
5   E       2       -1      -1
```

```cpp
#define MAX_TREE_SIZE 100
#define CHILD_MAX_SIZE 2
typedef struct{
    ElementType data;
    int childs[CHILD_MAX_SIZE];
    int n;
    int parent;
}PCTNode;
typedef struct{
    PCTNode nodes[MAX_TREE_SIZE];
    int n;
}PCTree;
```

#### 链式存储

* 孩子链表表示法

```cpp
    data|first
0      A|  ----->1|----->2|^
1      B|  ----->3|^
2      C|  ----->4|----->5|^
3      F|^
4      D|^
5      E|^
```

```cpp
#define MAX_TREE_SIZE 100
struct ChildNode{
    int index;
    ChildNode*next;
};
struct Node{
    ElementType data;
    ChildNode*firstChild;
};
Node tree[MAX_TREE_SIZE];
```

如果在表头加一个双亲域parent，则为双亲孩子链表

```cpp
#define MAX_TREE_SIZE 100
struct ChildNode{
    int index;
    ChildNode*next;
    int parent;
};
struct Node{
    ElementType data;
    ChildNode*firstChild;
};
Node tree[MAX_TREE_SIZE];
```

* 孩子兄弟表示法

又称二叉链表

```cpp
struct Node{
    Node*firstChild;//第一个孩子
    Node*nextSibling;//右兄弟
    ElementType data;
};
```

```cpp
    A      兄弟关系向右斜         ||A|^|
  / | \                          /
  B C D                        ||B||
 /\ /  /\                      /   \
E F G  H I                 |^|E||   \
     \                          \    \
     J                       |^|F|^|  \
                                     ||C||
                                     /   \
                                  ||G|^| ||D|^|
                                  /      /
                              |^|J|^| |^|H||
                                           \
                                        |^|I|^|
```
