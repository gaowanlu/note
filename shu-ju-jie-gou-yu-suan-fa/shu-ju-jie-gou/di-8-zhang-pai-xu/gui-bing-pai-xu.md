---
coverY: 0
---

# 😍 归并排序

## 归并排序

### 算法设计

归并排序采用分治策略实现对n个元素进行排序，它是一种平衡、简单的二分分治策略。

1、分解一将待排序序列分成规模大致相等的两个子序列

2、治理一对两个子序列进行合并排序

3、合并一将排好序的有序子序列进行合并，得到最终的有序序列

### 代码实现

```cpp
#include<iostream>
#include<algorithm>
#include<vector>

using namespace std;

template<typename T>
void printVec(vector<T>&t) {
	for (T& i : t) {
		cout << i << " ";
	}
	cout << endl;
}

void Merge(vector<int>&vec,int low,int mid,int high) {
	vector<int>temp;
	int i = low, j = mid + 1;
	while (i <= mid && j <= high) {
		if (vec[i] < vec[j]) {
			temp.push_back(vec[i++]);
		}
		else {
			temp.push_back(vec[j++]);
		}
	}
	while (i <= mid) {
		temp.push_back(vec[i++]);
	}
	while (j <= high) {
		temp.push_back(vec[j++]);
	}
	for (i = 0; i < temp.size(); i++) {
		vec[i + low] = temp[i];
	}
	temp.clear();
}

void MergeSort(vector<int>&vec,int low,int high) {
	if (low>=high) { return; }
	int mid =(high+low) / 2;
	MergeSort(vec,low,mid);
	MergeSort(vec,mid+1,high);
	Merge(vec, low, mid, high);
}

int main(int argc,char**argv) {
	vector<int>vec = { 67,45,23,1,4,6,87,34,13 };
	int size = vec.size();
	MergeSort(vec,0,size-1);
	printVec<int>(vec);
	return 0;
}

//1 4 6 13 23 34 45 67 87

```

### 复杂度分析

1、分解

只是计算子序列的中间位置，O(1)

2、解决子问题

递归求解两个规模为n/2的子问题，2T(n/2)

3、合并

可以在O(n)时间内完成

4、平均时间复杂度为O(nlogn)

5、空间复杂度，临时缓冲区最大分配空间n，递归调用所使用的占空间为O(logn),故空间复杂度为O(n)

### 稳定性

归并排序是稳定的排序算法
