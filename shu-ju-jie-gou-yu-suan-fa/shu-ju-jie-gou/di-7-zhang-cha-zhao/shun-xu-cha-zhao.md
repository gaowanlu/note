# 🥲 顺序查找

## 顺序查找

### 算法步骤

(1) 将记录存储在数组r\[0,n-1]中，待查找关键字存储在x中\
(2) 依次将`r[i](i=0,...,n-1)`与x比较，如果比较成功则返回i，否则返回0

### 代码实现

```cpp
//main1.cpp
int find(vector<int>&vec,const int x){
    for (vector<int>::size_type i = 0; i < vec.size();i++){
        if(vec[i]==x){
            return i;
        }
    }
    return -1;
}

int main(int argc,char**argv){
    vector<int> vec = {1, 2, 3, 4, 5};
    cout << find(vec, 4) << endl;//3
    cout << find(vec, -4) << endl;//-1
    return 0;
}
```

### 时间复杂度分析

最好的情况为一次查找成功，最坏的情况为n次查找成功\
假设每个关键词被查找的概率均等，即`pi=1/n`,查找第i个关键字需要比较i次成功，则查找成功的平均查找长度为

![时间复杂度](<../../../.gitbook/assets/屏幕截图 2022-05-30 232427.jpg>)

如果查找的内容不存在，则每次都会比较n次，时间复杂度也为O(n)

### 空间复杂度分析

显然是O(1)

### 特殊情况下的一点小优化

优化后的算法，时间复杂度数量级没有变，仍为O(n),但是比较的次数变少了，省去了判断判断下标范围判断

```cpp
//arr数据从下标1开始存放
int find(int arr[],int n,int x){
    int i;
    arr[0]=x;//将要查找的元素放入下标0位置
    for(i=n;arr[i]!=x;i--);//从最后一个位置开始反向找
    return i;//如果找到了目标则不是返回0 没找到则返回0
}
```

> 顺序查找就是暴力穷举，数据量很大时，查找效率比较低
