---
coverY: 0
---

# ☺ 最小生成树

## 最小生成树

### Prim算法

对于n个顶点的连通图，只需n-1条边就可以使得这个图连通，不应该有回路，所以生成最小树只需找出n-1条权值最小且无回路的边即可

* 子图：从原图中选中一些顶点和边组成的图
* 生成子图：选中一些边和所有顶点组成的图
* 生成树：如果生成子图恰好是一棵树
* 最小生成树：权值之和最小的生成树，则成为最小生成树

1、代码实现

```cpp
#include<iostream>
#include<algorithm>
#include<vector>
using namespace std;

static constexpr int N=100;
static constexpr int INF = INT_MAX;

/**
 * @brief Prim最小生成树
 * @param n 带权邻接矩阵大小 
 * @param u0 开始顶点
 * @param c 带权邻接矩阵
*/
void Prim(int n,int u0,int c[N][N]) {
	bool s[N] = {false};//为true则代表加入了s集合
	int lowcost[N];
	int closest[N];
	for (int i = 1; i <= n; i++) {//初始化
		if (i != u0) {
			lowcost[i] = c[u0][i];
			closest[i] = u0;
			s[i] = false;//未加入生成树
		}
		else {
			lowcost[i] = 0;
			closest[i] = u0;
			s[u0] = true;//将起点加入最小生成树
		}
	}
	//生成最小生成树
	for (int i = 1; i <= n; i++) {
		//在集合中寻找距离s集合最近的顶点（非s集合中顶点）
		int t = u0;
		int temp = INF;
		for (int j = 1; j <= n; j++) {
			if (!s[j] && (lowcost[j] < temp)) {
				temp = lowcost[j];
				t = j;
			}
		}
		if (t == u0) {//找不到t
			break;
		}
		s[t] = true;
		for (int j = 1; j <= n;j++) {
			//更新lowcost closest
			if (!s[j] && c[t][j] < lowcost[j]) {
				lowcost[j] = c[t][j];
				closest[j] = t;
			}
		}
	}
	cout << "closest[]" <<endl;
	for (int i = 1; i <= n; i++) {
		cout << closest[i] << " ";
	}
	cout << "\nlowcost[]" << endl;
	for (int i = 1; i <= n; i++) {
		cout << lowcost[i] << " ";
	}
	cout << endl;
}

void Print_Map(int c[N][N],int n) {
	for (int i = 1; i < n; i++) {
		for (int j = 1; j <= n; j++) {
			if (c[i][j] == INF) {
				cout << "INF ";
			}
			else {
				cout << c[i][j] << " ";
			}
		}
		cout << endl;
	}
}


int main(int argc,char**argv) {
	int m_map[N][N];
	int s=0, e;
	vector<vector<int>>c = {
		{0,0,0,0,0,0,0,0},
		{0,0,23,-1,-1,-1,28,36},
		{0,23,0,20,-1,-1,-1,1},
		{0,-1,20,0,15,-1,-1,4},
		{0,-1,-1,15,0,3,-1,9},
		{0,-1,-1,-1,3,0,17,16},
		{0,28,-1,-1,-1,17,0,25},
		{0,36,1,4,9,16,25,0}};
	int n = c.size() - 1;
	for (int i = 1; i <= n; i++) {
		for (int j = 1; j <= n; j++) {
			m_map[i][j]=c[i][j];
			if (m_map[i][j] == -1) {
				m_map[i][j] = INF;
			}
		}
	}
	Prim(n,1,m_map);
	Print_Map(m_map,n);
	return 0;
}

/*
closest[]
1 1 7 7 4 5 2
lowcost[]
0 23 4 9 3 17 1
0 23 INF INF INF 28 36
23 0 20 INF INF INF 1
INF 20 0 15 INF INF 4
INF INF 15 0 3 INF 9
INF INF INF 3 0 17 16
28 INF INF INF 17 0 25
*/

```

2、复杂度分析

（1）时间复杂度O(n^2)

（2）空间复杂度O(n) ,辅助空间包括i,j,lowcost,closest,s。

### Kruskal算法

<figure><img src="../../../.gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>

每次挑选权值最小的边，如果两个顶点的集合号不同，则将两个集合的集合号都改为二者当中最小的，最后只有一个集合，则得到最小生成树

1、代码实现

```cpp
#include<iostream>
#include<vector>
#include<algorithm>

using namespace std;

struct Edge {
	int u;
	int v;
	int w;
};

struct Node {
	int set_num;
};

bool Merge(vector<Edge>& e, vector<Node>& nodes, int e_index) {
	int u = e[e_index].u;
	int v = e[e_index].v;
	int p = nodes[u].set_num;
	int q = nodes[v].set_num;
	if (p == q) {//二者集合号相同则合并失败
		return false;
	}
	//检查所有节点
	for (int i = 1; i < nodes.size(); i++) {
		if (nodes[i].set_num == q) {//将q集合并入p集合
			nodes[i].set_num = p;
		}
	}
	return true;
}

int Kruskal(vector<Edge>&e, vector<Node>&nodes) {
	if (nodes.size() == 0)return 0;
	int ans = 0, n = nodes.size()-1;
	for (int i = 0; i < e.size(); i++) {
		if (Merge(e,nodes,i)) {//尝试合并
			//合并成功
			cout << e[i].u << " " << e[i].v << " " << e[i].w << endl;
			ans += e[i].w;
			n--;
			if (n == 1) {//合并成功了n-1次
				return ans;
			}
		}
	}
	return 0;
}

int main(int argc, char** argv) {
	vector <Edge>e = {
		{1,2,23},
		{2,3,20},
		{3,4,15},
		{4,5,3},
		{5,6,17},
		{1,6,28},
		{2,7,1},
		{3,7,4},
		{4,7,9},
		{5,7,16},
		{6,7,25},
		{1,7,36} };
	//将边根据权值排序
	std::sort(e.begin(), e.end(), [](Edge&e1,Edge&e2)->bool {
		return e1.w < e2.w;
	});
	//顶点集合号始化
	vector<Node> n = { {0},{1},{2},{3},{4},{5},{6},{7} };
	Kruskal(e,n);
	return 0;
}

/*
2 7 1
4 5 3
3 7 4
4 7 9
5 6 17
1 2 23
*/
```

2、复杂度分析

（1）时间复杂度，对边进行排序O(eloge)，需要进行n-1次合并，每次合并遍历n个顶点，O(n^2)，总时间复杂度为O(n^2)。

（2）空间复杂度，vector\<Node> n,大小为O(n)。

（3）优化，如果用并查集可以优化合并集合的时间，总的时间复杂度将会优化为O(eloge)。
