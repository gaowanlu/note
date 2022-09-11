---
coverY: 0
---

# 🤪 基数排序

## 基数排序

### 算法步骤

（1）求出待排序序列中最大的关键字的位数d,然后从低位到高位进行基数排序

（2）按个位将关键字依次分配到桶中，然后将每个桶中的数据依次收集起来

（3）按十位将关键字依次分配到桶中，然后将每个桶中的数据依次收集起来。

（4）依次下去，直到d位处理完毕，然后得到一个有序的序列

最大值为92，共两位数字

<figure><img src="../../../.gitbook/assets/image (1).png" alt=""><figcaption><p>分配</p></figcaption></figure>

收集 70、80、12、92、83、54、75、75、68、48

<figure><img src="../../../.gitbook/assets/image (2).png" alt=""><figcaption><p>分配</p></figcaption></figure>

收集12、48、54、68、70、75、75、80、83、92

如果当数字的位数不同时，缺位的高位用0补充，比如123、008（8做处理后）

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

//求待排序序列最大元素位数
int Maxbit(vector<int>&vec) {
	int max = vec[0],bits=0;
	for (int i = 1; i < vec.size(); i++) {
		if (vec[i] > max) {
			max = vec[i];
		}
	}
	//计算位数
	while (max!=0) {
		bits++;
		max /= 10;
	}
	return bits;
}

//取num的第bit位的数字
int Bitnumber(int num,int bit) {
	int temp = 1;
	for (int i = 1; i < bit; i++) {
		temp *= 10;
	}
	return (num / temp) % 10;
}

void RadixSort(vector<int>&vec) {
	int max_bit = Maxbit(vec);
	//分配空间
	int** B = new int* [10];
	for (int i = 0; i < 10; i++) {
		B[i] = new int[vec.size() + 1];
	}
	//每个桶存放元素的个数
	for (int i = 0; i < 10; i++) {
		B[i][0] = 0;
	}
	for (int bit = 1; bit <= max_bit;bit++) {
		//分配
		for (int j = 0; j < vec.size();j++) {
			int num = Bitnumber(vec[j],bit);//取vec[j]第bit位上的数字
			int index = ++B[num][0];
			B[num][index] = vec[j];
		}
		//收集
		for (int i = 0, j = 0; i < 10; i++) {
			for (int k = 1; k <= B[i][0]; k++) {
				vec[j++] = B[i][k];
			}
			B[i][0] = 0;
		}
	}
	//释放空间
	for (int i = 0; i < 10; i++) {
		delete[] B[i];
	}
	delete B;
}


int main(int argc,char**argv) {
	vector<int>vec = { 67,45,23,1,4,6,87,34,13 };
	RadixSort(vec);
	printVec<int>(vec);
	return 0;
}

//1 4 6 13 23 34 45 67 87

```

### 算法分析

1、时间复杂度

基数排序需要进行d趟排序，每趟排序有分配和收集两个部分，分配需要O(n)。收集操作如果使用顺序队列则需要O(n)时间，如果是链队列只需将r个链队列链接即可，需要O(r)。总的时间复杂度为O(d(n+r))。

2、空间复杂度

使用顺序队列，则需要r个大小为n的队列，空间复杂度为O(rn)。链队列，则需要r个链表头，与n个数据节点即可，空间复杂度为O(n+r)。

3、稳定性

基数排序是按照关键字出现的顺序依次进行的，是稳定排序。

