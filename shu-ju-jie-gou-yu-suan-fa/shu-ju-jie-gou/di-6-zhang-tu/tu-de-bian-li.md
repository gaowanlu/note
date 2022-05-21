---
cover: >-
  https://images.unsplash.com/photo-1650960865660-241c2d255aa9?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTMwOTcxNTk&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🚎 图的遍历

## 图的遍历

图的遍历和树的遍历类似，是从图的某一个顶点出发，按照某种搜索方式对图种中所有顶点访问一次且仅一次。\
图的遍历根据搜索方式不同，分为广度优先搜索和深度优先搜索

### 广度优先搜索

广度优先搜索(Breadth First Search,BFS)

又称宽度优先搜索，先被访问的顶点的邻接点先被访问

算法步骤

1、初始化图中所有顶点未被访问，初始化一个空队列\
2、从图中的某个顶点v触发，访问v并标记以访问，将v入队\
3、如果队列非空，则继续执行，否则算法结束\
4、队头元素v出队，一次访问v的所有未被访问过的邻接点，标记为以访问并且入队，转向步骤3

广度优先遍历经过的顶点及边，称为广度优先生成树，简称BFS树，如果是非连通图，则每一个连通分量会产生一棵BFS树，合起来称为BFS森林

![广度优先搜索](<../../../.gitbook/assets/屏幕截图 2022-05-21 085842.jpg>)

BFS树

![BFS树](<../../../.gitbook/assets/屏幕截图 2022-05-21 090006.jpg>)

代码实现

* 基于邻接矩阵的BFS

```cpp
void BFS_AM(AMGragh G,int v)//基于邻接矩阵的广度优先遍历
{
    int u,w;
    queue<int>Q; //创建一个普通队列(先进先出)，里面存放int类型
    cout<<G.Vex[v]<<"\t";
    visited[v]=true;
    Q.push(v); //源点v入队
    while(!Q.empty()) //如果队列不空
    {
        u=Q.front();//取出队头元素赋值给u
        Q.pop(); //队头元素出队
        for(w=0;w<G.vexnum;w++)//依次检查u的所有邻接点
        {
            if(G.Edge[u][w]&&!visited[w])//u、w邻接而且w未被访问
            {
               cout<<G.Vex[w]<<"\t";
               visited[w]=true;
               Q.push(w);
            }
        }
    }
}
```

* 基于邻接表的BFS

```cpp
void BFS_AL(ALGragh G,int v)//基于邻接表的广度优先遍历
{
    int u,w;
    AdjNode *p;
    queue<int>Q; //创建一个普通队列(先进先出)，里面存放int类型
    cout<<G.Vex[v].data<<"\t";
    visited[v]=true;
    Q.push(v); //源点v入队
    while(!Q.empty()) //如果队列不空
    {
        u=Q.front();//取出队头元素赋值给u
        Q.pop(); //队头元素出队
        p=G.Vex[u].first;
        while(p)//依次检查u的所有邻接点
        {
            w=p->v;//w为u的邻接点
            if(!visited[w])//w未被访问
            {
               cout<<G.Vex[w].data<<"\t";
               visited[w]=true;
               Q.push(w);
            }
            p=p->next;
        }
    }
}
```

* 非连通图的BFS

```cpp

void BFS_AL(ALGragh G)//非连通图，基于邻接表的广度优先遍历
{
    for(int i=0;i<G.vexnum;i++)//非连通图需要查漏点，检查未被访问的顶点
     if(!visited[i])//i未被访问,以i为起点再次广度优先遍历
         BFS_AL(G,i);
}
```

算法复杂度分析

1、基于邻接矩阵的BFS算法

查找每个顶点的邻接点O(n),一共n个顶点，则时间复杂度O(n^2)\
辅助队列，最坏情况下每个顶点入队一次，空间复杂度为O(n)

2、基于邻接表的BFS算法

查找顶点vi的邻接点需要O(d(vi))时间，d(vi)为vi的度（无向图为度），对有向图所有顶点的出度之和等于边数e，对于无向图而言，所有顶点的度之和为2e,因此查找邻接表时间都是O(e),加上visited初始化时间O(n),总时间复杂度O(n+e)\
辅助队列，最坏情况下每个顶点入队一次，空间复杂度为O(n)

### 深度优先搜索

深度优先搜索(Depth FIrst Search,DFS)\
被访问的顶点，其邻接点先被访问

算法步骤（递归）

1、初始化图中所有顶点未被访问\
2、从图中的某个顶点v出发，访问v并标记以访问\
3、一次检查v的所有邻接点w，如果w未被访问，则从w出发进行深度优先遍历(递归调用，重复步骤2和步骤3)

算法步骤（非递归）

1、初始化图中所有顶带你未被访问\
2、从图中的某个顶点v除法，访问v并标记已访问\
3、访问最近访问顶点的未被访问邻接点w1，再访问w1的未被访问邻接点w2...直达当前没有未被访问的邻接点时停止\
4、回退到最近访问过且有未被访问过的邻接点的顶点，访问该顶带你的未被访问的邻接点\
5、重复3和4，直到所有顶点都被访问过

![深度优先搜索](<../../../.gitbook/assets/屏幕截图 2022-05-21 092328.jpg>)

DFS树

![DFS树](<../../../.gitbook/assets/屏幕截图 2022-05-21 092417.jpg>)

代码实现

* 基于邻接矩阵的DFS

```cpp
void DFS_AM(AMGragh G,int v)//基于邻接矩阵的深度优先遍历
{
    int w;
    cout<<G.Vex[v]<<"\t";
    visited[v]=true;
    for(w=0;w<G.vexnum;w++)//依次检查v的所有邻接点
  if(G.Edge[v][w]&&!visited[w])//v、w邻接而且w未被访问
   DFS_AM(G,w);//从w顶点开始递归深度优先遍历
}
```

* 基于邻接表的DFS

```cpp
void DFS_AL(ALGragh G, int v) //基于邻接表的深度优先遍历
{
    int w;
    AdjNode *p;
    cout << G.Vex[v].data << "\t";
    visited[v] = true;
    p = G.Vex[v].first;
    while (p) //依次检查v的所有邻接点
    {
        w = p->v;         // w为v的邻接点
        if (!visited[w])  // w未被访问
            DFS_AL(G, w); //从w出发，递归深度优先遍历
        p = p->next;
    }
}
```

* 非连通图的DFS

```cpp
void DFS_AL(ALGragh G) //非连通图，基于邻接表的深度优先遍历
{
    for (int i = 0; i < G.vexnum; i++) //非连通图需要查漏点，检查未被访问的顶点
        if (!visited[i])               // i未被访问,以i为起点再次广度优先遍历
            DFS_AL(G, i);
}
```

算法复杂度分析

1、基于邻接矩阵的DFS算法

查找每个顶点的邻接点O(n),一共n各顶点，则时间复杂度为O(n^2)\
使用了一个递归工作栈,栈的最坏堆叠大小是全部节点同时入栈，空间复杂度为O(n)

2、基于邻接表的DFS算法

查找顶点vi的邻接点需要O(d(vi))时间，d(vi)为vi的度（无向图为度），对有向图所有顶点的出度之和等于边数e，对于无向图而言，所有顶点的度之和为2e,因此查找邻接表时间都是O(e),加上visited初始化时间O(n),总时间复杂度O(n+e)

辅助栈(递归栈)，空间复杂度为O(n)

> 一个图的邻接矩阵是唯一的，因此基于邻接矩阵的BFS或者DFS的遍历序列是唯一的，因为我们的程序扫描一个顶点的邻接点时总是从0扫到n-1,这是固定的。图的邻接表不是唯一的，可能对于同一个图但是输入顺序不同，链表节点的顺序签后会影响邻接点的顺序，因此基于邻接表的BFS或DFS遍历序列不是唯一的
