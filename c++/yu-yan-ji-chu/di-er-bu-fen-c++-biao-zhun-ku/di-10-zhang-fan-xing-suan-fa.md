---
coverY: 0
---

# 🥳 第10章 泛型算法

## 第10章 泛型算法

标准库为我们提供了容器，同时为开发者提供了许多算法，这些算法中大多数都独立于任何特定的容器，也就是说这些算法是通用的(generic,或者称为泛型的)：它们可用于不同类型的容器和不同类型的元素，本章主要学习泛型算法与对迭代器更加深入的讨论

### 概述

大多数算法在头文件`algorithm`，`numeric`中定义了一组数值泛型算法\
下面简单使用find算法

```cpp
//example1.cpp
vector<int> vec = {1, 2, 3, 4, 5};
auto target = find(vec.begin(), vec.end(), 3);
if (target != vec.cend())
{
    cout << "finded " << *target << endl; // finded 3
}

//泛型算法是一种通用算法
string str = "abcde";
auto ch = find(begin(str), end(str), 'c');
if (ch != str.cend())
{
    cout << "fined " << *ch << endl; // fined c
}
```

可见迭代器令算法不依赖于容器、不同的容器可以使用相同的算法\
算法依赖于元素类型的操作，如find就依赖于元素类型间的==操作，其他算法可依赖>、<等等

关键概念：算法永远不会执行容器的操作，因为这样就会对特定容器产生依赖，不是真正的泛型算法，它们只会运行在迭代器上
