---
coverY: 0
---

# 🤓 双端队列

## 双端队列

双端队列是指允许两端都可以进行入队和出队操作的队列、双端队列是比较特殊的线性表，具有栈和队列的两种性质。

* 普通双端队列，可前后允许入队出队
* 受限双端队列 允许在一端进队和出队，另一端只允许出队，被称为输入受限的双端队列\
  允许在一端进队和出队，另一端只允许进队，被称为输出受限的双端队列

### 队空

```cpp
Q.front==Q.rear;
```

### 队满

```cpp
(Q.rear+1)%Maxsize=Q.front
```

### 后端入队

```cpp
Q.base[Q.rear]=x;
Q.rear=(Q.rear+1)%Maxsize;
```

### 前端入队

```cpp
Q.front=(Q.front-1+Maxsize)%Maxsize;
Q.base[Q.front]=x;
```

### 后端出队

```cpp
rear.front=(Q.rear-1+Maxsize)%Maxsize;
e=Q.base[Q.rear];
```

### 前端出队

```cpp
e=Q.base[Q.front]
Q.front=(Q.front+1)%Maxsize;
```

### 计算长度

```cpp
(Maxsize-Q.front+Q.rear)%Maxsize
```
