---
coverY: 0
---

# 😘 广义表

## 广义表

广义表是线性表的推广、也成为列表，由n>=0个元素组成的有限序列\
LS=(a0,a1,a2,...,an-1),LS为表名，ai是表元素，可以是表，也可以是数据元，n为表的长度、n=0则为空表

### 常见操作

* 求表头

表头：非空广义表的第一个元素。

* 求表为

表尾：删除表头元素余下的元素构成的表，表尾一定是一个表。

```cpp
D=(a,(b),(a,(b,c,d))) 表尾=> D=((b),(a,(b,c,d)))
```
