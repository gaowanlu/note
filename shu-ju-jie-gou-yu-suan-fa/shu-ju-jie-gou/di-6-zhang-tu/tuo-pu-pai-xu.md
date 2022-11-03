---
coverY: 0
---

# 😜 拓扑排序

AOV（Activity On Vertex network）网，用有向图表示活动之间的制约关系，顶点表达活动，弧表示活动之间的优先制约关系，这种有向图为顶点表示活动的网，简称AOV网。

AOE(Activity On Edge)网，弧表示活动，以顶点表示活动的开始或结束时间，这种有向图为边表示活动的网，称为AOE网

1、算法步骤

* 在有向图中选一个没有前驱的顶点且输出
* 从图中删除该顶点和所有以它为尾的弧
* 重复上述两步，直到全部顶点均已输出或者当图中不存在无前驱的顶点为止

重点：一个AOV网的拓扑序列不是唯一的

2、代码实现

```cpp
#include <iostream>
#include <cstring>
#include <stack>
using namespace std;
const int MaxVnum = 100; //顶点数最大值
int indegree[MaxVnum];   //入度数组

typedef string VexType; //顶点的数据类型为字符型
typedef struct AdjNode
{                         //定义邻接点类型
    int v;                //邻接点下标
    struct AdjNode *next; //指向下一个邻接点
} AdjNode;

typedef struct VexNode
{                   //定义顶点类型
    VexType data;   // VexType为顶点的数据类型，根据需要定义
    AdjNode *first; //指向第一个邻接点
} VexNode;

typedef struct
{                                  //包含邻接表和逆邻接表
    VexNode Vex[MaxVnum];          //定义邻接表
    VexNode converse_Vex[MaxVnum]; //定义逆邻接表
    int vexnum, edgenum;           //顶点数，边数
} ALGragh;

int locatevex(ALGragh G, VexType x)
{
    for (int i = 0; i < G.vexnum; i++) //查找顶点信息的下标
        if (x == G.Vex[i].data)
            return i;
    return -1; //没找到
}

void insertedge(ALGragh &G, int i, int j) //插入一条边
{
    AdjNode *s1, *s2;
    s1 = new AdjNode; //创建邻接表结点
    s1->v = j;
    s1->next = G.Vex[i].first;
    G.Vex[i].first = s1;
    s2 = new AdjNode; //创建逆邻接表结点
    s2->v = i;
    s2->next = G.converse_Vex[j].first;
    G.converse_Vex[j].first = s2;
}

void printg(ALGragh G) //输出邻接表
{
    cout << "----------邻接表如下：----------" << endl;
    for (int i = 0; i < G.vexnum; i++)
    {
        AdjNode *t = G.Vex[i].first;
        cout << G.Vex[i].data << "：  ";
        while (t != NULL)
        {
            cout << "[" << t->v << "]  ";
            t = t->next;
        }
        cout << endl;
    }
    cout << "----------逆邻接表如下：----------" << endl;
    for (int i = 0; i < G.vexnum; i++)
    {
        AdjNode *t = G.converse_Vex[i].first;
        cout << G.converse_Vex[i].data << "：  ";
        while (t != NULL)
        {
            cout << "[" << t->v << "]  ";
            t = t->next;
        }
        cout << endl;
    }
}

void CreateALGraph(ALGragh &G) //创建有向图的邻接表和逆邻接表
{
    int i, j;
    VexType u, v;
    cout << "请输入顶点数和边数:" << endl;
    cin >> G.vexnum >> G.edgenum;
    cout << "请输入顶点信息:" << endl;
    for (i = 0; i < G.vexnum; i++) //输入顶点信息，存入顶点信息数组
    {
        cin >> G.Vex[i].data;
        G.converse_Vex[i].data = G.Vex[i].data;
        G.Vex[i].first = NULL;
        G.converse_Vex[i].first = NULL;
    }
    cout << "请依次输入每条边的两个顶点u,v" << endl;
    while (G.edgenum--)
    {
        cin >> u >> v;
        i = locatevex(G, u); //查找顶点u的存储下标
        j = locatevex(G, v); //查找顶点v的存储下标
        if (i != -1 && j != -1)
            insertedge(G, i, j);
        else
        {
            cout << "输入顶点信息错！请重新输入！" << endl;
            G.edgenum++; //本次输入不算
        }
    }
}

//O(e)
void FindInDegree(ALGragh G) //求出各顶点的入度存入数组indegree中
{
    int i, count;
    for (i = 0; i < G.vexnum; i++)
    {
        count = 0;
        AdjNode *p = G.converse_Vex[i].first;
        if (p)
        {
            while (p)
            {
                p = p->next;
                count++;
            }
        }
        indegree[i] = count;
    }
    cout << "入度数组为：" << endl;
    for (int i = 0; i < G.vexnum; i++) //输出入度数组
        cout << indegree[i] << "\t";
    cout << endl;
}

bool TopologicalSort(ALGragh G, int topo[]) //拓扑排序
{
    //有向图G采用邻接表存储结构
    //若G无回路，则生成G的一个拓扑序列topo[]并返回true，否则false
    int i, m;
    stack<int> S;    //初始化一个栈S，需要引入头文件#include<stack>
    FindInDegree(G); //求出各顶点的入度存入数组indegree[]中O(e)
    //O(n)
    for (i = 0; i < G.vexnum; i++)
        if (!indegree[i]) //入度为0者进栈
            S.push(i);
    m = 0;             //对输出顶点计数，初始为0
    //O(e)
    while (!S.empty()) //栈S非空
    {
        i = S.top();                 //取栈顶顶点i
        S.pop();                     //栈顶顶点i出栈
        topo[m] = i;                 //将i保存在拓扑序列数组topo中
        m++;                         //对输出顶点计数
        AdjNode *p = G.Vex[i].first; // p指向i的第一个邻接点
        while (p)                    // i的所有邻接点入度减1
        {
            int k = p->v;         // k为i的邻接点
            --indegree[k];        // i的每个邻接点的入度减1
            if (indegree[k] == 0) //若入度减为0，则入栈
                S.push(k);
            p = p->next; // p指向顶点i下一个邻接结点
        }
    }
    if (m < G.vexnum) //该有向图有回路
        return false;
    else
        return true;
}

int main()
{
    ALGragh G;
    int *topo = new int[G.vexnum];
    CreateALGraph(G); //创建有向图的邻接表和逆邻接表
    printg(G);        //输出邻接表和逆邻接表
    if (TopologicalSort(G, topo))
    {
        cout << "拓扑序列为：" << endl;
        for (int i = 0; i < G.vexnum; i++) //输出拓扑序列
            cout << topo[i] << "\t";
    }
    else
        cout << "该图有环，无拓扑序列！" << endl;
    return 0;
}

```

3、复杂度分析

* 时间复杂度&#x20;

求有向图各顶点的入度需要遍历邻接表，O(e)。开始选择出入度为0的顶点入栈O(n)，每个顶点出栈后其邻接点入度减1，O(e)。总时间复杂度为O(n+e)。

* 空间复杂度

入度数组indegree\[]，topo\[],statck s,空间复杂度为O(n)。

4、重要应用

拓扑排序是检测AOV网中是否存在环的方法。进行拓扑排序后所有顶点都在序列中，则不存在环。
