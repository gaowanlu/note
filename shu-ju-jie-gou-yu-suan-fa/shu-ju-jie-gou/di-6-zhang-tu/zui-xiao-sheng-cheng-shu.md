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
