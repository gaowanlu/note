---
coverY: 0
---

# 😎 最佳归并树

### 二路归并

IO读写的次数与合并树的结构是有关的。

<figure><img src="../../../.gitbook/assets/屏幕截图 2022-09-12 015908.jpg" alt=""><figcaption></figcaption></figure>

构造最佳归并树（哈夫曼树）

<figure><img src="../../../.gitbook/assets/屏幕截图 2022-09-12 020214.jpg" alt=""><figcaption></figcaption></figure>

最佳归并树 WPLmin=(1+2)\*4+2\*3+5\*2+6\*1=34

总的磁盘IO次数=68

### 多路归并

<figure><img src="../../../.gitbook/assets/屏幕截图 2022-09-12 020449.jpg" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/屏幕截图 2022-09-12 020627.jpg" alt=""><figcaption></figcaption></figure>

选择k小造新树，构造哈夫曼树

对于k叉归并，若初始归并段的数量无法构成严格的k叉归并树，则需要补充几个长度为0的"虚段"，在进行k叉哈夫曼树的构造。

<figure><img src="../../../.gitbook/assets/屏幕截图 2022-09-12 021104.jpg" alt=""><figcaption></figcaption></figure>

k叉的最佳归并树一定是一棵严格的k叉树，即树中只包含度为k、度为0的节点，设度为k的节点有n\[k]个,度为0节点为n\[0]个，归并树总结点数=n,则

初始归并段数量+虚段数量=n\[0]

n=n\[0]+n\[k]

k\*n\[k]=n-1

n\[0]=(k-1)\*n\[k]+1

n\[k]=(n\[0]-1)/(k-1)

<figure><img src="../../../.gitbook/assets/屏幕截图 2022-09-12 021541.jpg" alt=""><figcaption></figcaption></figure>

