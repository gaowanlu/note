# 🍎 C++14 特性

C++14 引入了许多新特性和语言改进，下面是其中一些主要的特性：

1、泛型 Lambda 表达式

2、constexpr 函数中的更多功能

3、std::make_unique

4、std::index_sequence 和相关功能

5、std::exchange 函数

6、std::integer_sequence 和相关功能

7、std::quoted 用于 IO 操作

8、变量模板

## 变量模板

根据不同的类型去定义一个变量有哪些方法。

- 在类模板定义静态数据成员

```cpp
#include <iostream>
using namespace std;

template <class T>
struct PI
{
    static constexpr T value = static_cast<T>(3.1415926);
};

int main(int argc, char **argv)
{
    std::cout << PI<float>::value << std::endl; // 3.14159
    return 0;
}
```

- 使用函数模板返回所需的值

```cpp
#include <iostream>
using namespace std;

template <class T>
constexpr T PI()
{
    return static_cast<T>(3.1415926);
};

int main(int argc, char **argv)
{
    std::cout << PI<int>() << std::endl; // 3
    return 0;
}
```

C++14标准引入了变量模板的特性。

```cpp
#include <iostream>
using namespace std;

template <class T>
constexpr T PI = static_cast<T>(3.1415926L);

int main(int argc, char **argv)
{
    std::cout << PI<float> << std::endl; // 3.1415926
    std::cout << PI<int> << std::endl;   // 3
    return 0;
}
```

变量模板的模板参数也可以是非类型的

```cpp
#include <iostream>
using namespace std;

template <class T, int N>
T PI = static_cast<T>(3.1415926L) * N;

int main(int argc, char **argv)
{
    PI<float, 2> *= 5;
    std::cout << PI<float, 2> << std::endl; // 31.4159
    return 0;
}
```

有了变量模板，有一个好处就是用于模板元编程,如比较两个类型是否相同时会用到

```cpp
bool b = std::is_same<int,std::size_t>::value;
```

但是`::value`有些鸡肋，可以用变量模板

```cpp
template<class T1, class T2>
constexpr bool is_same_v = std::is_same<T1, T2>::value;

bool b = is_same_v<int, std::size_t>;
```

不过C++14标准库并没有`is_same_v`，知道C++17标准库的type_traits中对类型特征采用了变量模板，比如
`some_trait<T>::value`会增加与它等效的变量模板`some_trait_v<T>`。
