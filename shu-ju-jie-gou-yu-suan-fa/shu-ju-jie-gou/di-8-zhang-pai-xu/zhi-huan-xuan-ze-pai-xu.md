---
coverY: 0
---

# 🥳 置换-选择排序

```cpp
4 6 9 7 13 11
16 14 10 22 30 2
3 19 20 17 1 23
5 36 12 18 21 39

内存工作区WA 大小为3 个块的大小

|4|6|9| MINMAX=4 
段1 => 4
|7|6|9| MINMAX=6
段1 => 4 6
|7|13|11| MINMAX=7
段1 => 4 6 7
|16|13|11| MINMAX=11
段1 => 4 6 7 11
|16|13|14| MINMAX=13
段1 => 4 6 7 11 13
|16|10|14| MINMAX=14
段1 => 4 6 7 11 13 14
|16|10|22| MINMAX=16
段1 => 4 6 7 11 13 14 16
|30|10|22| MINMAX=22
段1 => 4 6 7 11 13 14 16 22
|30|10|2| MINMAX=30
段1 => 4 6 7 11 13 14 16 22 30
|3|10|2| MINMAX=2
段2 => 2
|3|10|19| MINMAX=3
段2 => 2 3
|20|10|19| MINMAX=10
段2 => 2 3 10
|20|17|19| MINMAX=17
段2 => 2 3 10 17
|20|1|19| MINMAX=19
段2 => 2 3 10 17 19
|20|1|23| MINMAX=20
段2 => 2 3 10 17 19 20
|5|1|23| MINMAX=23
段2 => 2 3 10 17 19 20 23
|5|1|36| MINMAX=36
段2 => 2 3 10 17 19 20 23 36
|5|1|12| MINMAX=1
段3 => 1
......
段3 => 1 5 12 18 21 39
```

此方法也是优化方法之一