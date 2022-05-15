---
coverY: 0
---

# 🎢 二叉树遍历

## 二叉树的遍历

```cpp
    2
   / \
  1   3
```

### 递归形式

#### 递归先序遍历

```cpp
2 1 3
```

```cpp
//main1.cpp
/**
 * @brief 先序遍历二叉树
 *
 * @param tree
 */
void PreOrderPrintBinTree(BinTree tree)
{
    if (tree != nullptr)
    {
        cout << tree->data << endl;
        PreOrderPrintBinTree(tree->left);
        PreOrderPrintBinTree(tree->right);
    }
}
```

#### 递归中序遍历

```cpp
1 2 3
```

```cpp
//main1.cpp
/**
 * @brief 中序遍历二叉树
 *
 * @param tree
 */
void InOrderPrintBinTree(BinTree tree)
{
    if (tree != nullptr)
    {
        InOrderPrintBinTree(tree->left);
        cout << tree->data << endl;
        InOrderPrintBinTree(tree->right);
    }
}
```

#### 递归后序遍历

```cpp
1 3 2
```

```cpp
//main1.cpp
/**
 * @brief 后序遍历二叉树
 *
 * @param tree
 */
void PostOrderPrintBinTree(BinTree tree)
{
    if (tree != nullptr)
    {
        PostOrderPrintBinTree(tree->left);
        PostOrderPrintBinTree(tree->right);
        cout << tree->data << endl;
    }
}
```

上面的三种方式都是递归形式

### 非递归形式

深度优先遍历借助栈、广度优先遍历(层次遍历)借助队列

#### 非递归先序遍历

```cpp
//main2.cpp
/**
 * @brief 先序遍历二叉树 非空节点则入栈 遇见空节点则出栈 出栈去右子树
 *
 * @param tree
 */
void PreOrderPrintBinTree(BinTree tree)
{
    vector<BinTree> stack;
    BinTree ptr = tree;
    while (ptr || !stack.empty())
    {
        if (ptr)
        {
            cout << ptr->data << endl; //先访问再入栈
            //当前节点入栈
            stack.push_back(ptr);
            //去左孩子
            ptr = ptr->left;
        }
        else
        {
            //栈顶元素出栈
            BinTree top = stack[stack.size() - 1];
            stack.erase(stack.end() - 1);
            //去右孩子
            ptr = top->right;
        }
    }
}
```

#### 非递归中序遍历

```cpp
/**
 * @brief 中序遍历二叉树
 *
 * @param tree
 */
void InOrderPrintBinTree(BinTree tree)
{
    vector<BinTree> stack;
    BinTree ptr = tree;
    while (ptr || !stack.empty())
    {
        if (ptr)
        {
            //当前节点入栈
            stack.push_back(ptr);
            //去左孩子
            ptr = ptr->left;
        }
        else
        {
            //栈顶元素出栈
            BinTree top = stack[stack.size() - 1];
            stack.erase(stack.end() - 1);
            ptr = top;
            cout << ptr->data << endl;
            //去右孩子
            ptr = top->right;
        }
    }
}
```

#### 非递归后序遍历

```cpp
/**
 * @brief 后序遍历二叉树
 *
 * @param tree
 */
void PostOrderPrintBinTree(BinTree tree)
{
    enum
    {
        LEFT,
        RIGHT
    };
    vector<BinTree> node_stack;
    vector<int> flag_stack; //二者同步记录，且记录现在的位置对于栈内的节点，在它们的左子树还是右子树
    BinTree ptr = tree;
    while (ptr || !node_stack.empty())
    {
        if (ptr == nullptr)
        {
            //看栈顶
            BinTree peek = node_stack[node_stack.size() - 1];
            int flag = flag_stack[flag_stack.size() - 1];
            if (flag == RIGHT)
            { //从右子树回来的 则对根节点进行访问
                cout << peek->data << endl;
                node_stack.erase(node_stack.end() - 1);
                flag_stack.erase(flag_stack.end() - 1);
            }
            else
            { //从左子树回来的，则跳去右子树
                ptr = node_stack[node_stack.size() - 1]->right;
                flag_stack[flag_stack.size() - 1] = RIGHT;
            }
            continue;
        }
        //节点入栈
        node_stack.push_back(ptr);
        flag_stack.push_back(LEFT); //要进入此节点的左子树
        //去左子树
        ptr = ptr->left;
    }
}
```

### 广度优先遍历(层级遍历二叉树)

使用c++标准库队列queue\<type>

```cpp
//main3.cpp
/**
 * @brief 层级遍历二叉树
 *
 * @param tree
 */
void LevelOrderPrintBinTree(BinTree &tree)
{
    if (tree == nullptr)
        return;
    std::queue<BinTree> node_queue;
    node_queue.push(tree);
    while (!node_queue.empty())
    {
        BinTree now_node = node_queue.front();
        node_queue.pop();
        cout << now_node->data << endl;
        if (now_node->left)
        {
            node_queue.push(now_node->left);
        }
        if (now_node->right)
        {
            node_queue.push(now_node->right);
        }
    }
}
```
