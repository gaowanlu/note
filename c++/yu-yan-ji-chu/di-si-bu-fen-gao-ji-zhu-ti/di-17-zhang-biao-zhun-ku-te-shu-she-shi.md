---
cover: >-
  https://images.unsplash.com/photo-1584114161426-b5f10850272a?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHNlYXJjaHw1fHxtZXJpZGF8ZW58MHx8fHwxNjU4Mzg5Nzc3&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🏍 第17章 标准库特殊设施

## 第17章 标准库特殊设施

如果你已经从第一章按部就班的学到了第17章，我相信你所认识的C++知识已经超过了很多人，因为有学习的同学并没有耐心慢慢全面地学完C++11的全部知识，从17章 标准库特殊设施以及第18章 用于大型程序的工具、第19章 特殊工具与技术这三个单元被统称为高级主题，这些内容往往在大型工程中意义重大

### tuple类型

```cpp
#include<tuple>
```

tuple与pair有些类似，但是tuple支持多个元素，多种元素类型，在希望将一些数据组合成单一对象，但不想麻烦地自定义数据结构表示时很有用,tuple是一个“快速而随意”的数据结构

![tuple支持的操作](<../../../.gitbook/assets/屏幕截图 2022-07-21 131108.jpg>)

### 定义和初始化tuple

定义格式为`tuple<T1,T2,T3...>name;`,使用构造函数初始化，或者在tuple内元素类型相同时使用参数列表进行初始化、或者使用`make_tuple`初始化tuple类型

```cpp
int main(int argc, char **argv)
{
    //成员被默认初始化
    tuple<size_t, int, string> threeData;
    //参数列表初始化内部容器类型
    tuple<string, vector<double>, int, list<int>> s("hi", {12.0, 32., 43.}, 9, {2, 3});
    //参数列表初始化tuple
    // tuple<int, int, int> s1 = {1, 2, 3};//错误 tuple构造函数是explicit的
    tuple<int, int, int> s2{1, 2, 3};

    // make_tuple
    auto s3 = make_tuple("12", 32, 34.f, 34.5);
    // class std::tuple<const char *, int, float, double>

    return 0;
}
```

### 访问tuple成员

需要使用get模板，`get<size_t>(tuple)`对成员进行访问，`tuple_size模板`获取tuple内元素的个数、`tuple_element模板`可以获取tuple内元素的数据类型

```cpp
//example2.cpp
int main(int argc, char **argv)
{
    tuple<int, string, double> m_tuple{1, "12", 34.};
    //取值
    auto item1 = get<0>(m_tuple);
    auto item2 = get<1>(m_tuple) + "[]";
    auto item3 = get<2>(m_tuple) * 5;
    cout << item1 << " " << item2 << " " << item3 << endl;
    // 1 12[] 170
    //赋值
    get<0>(m_tuple) = 999;
    cout << get<0>(m_tuple) << endl; // 999

    // tuple_size模板
    size_t size = tuple_size<decltype(m_tuple)>::value;
    cout << size << endl; // 3

    // tuple_element模板
    tuple_element<1, decltype(m_tuple)>::type el = get<1>(m_tuple);
    cout << el << endl; // 12

    return 0;
}
```

### 关系和相等运算符

tuple之间允许使用关系比较运算符==、<、>,本质为两个tuple中的元素相同位置的元素与另一个tuple相同位置元素比较，两两元素之间必须为可比较的

```cpp
//example3.cpp
int main(int argc, char **argv)
{
    tuple<int, int, int> t1{1, 2, 3};
    tuple<int, int, int> t2{1, 2, 3};
    tuple<int, int, int> t3{0, 1, 2};
    tuple<string, int, int> t4{"hi", 2, 3};
    // 错误 string与int不能比较
    // cout << (t4 < t2) << endl;
    cout << (t1 == t2) << endl; // 1
    cout << (t1 > t3) << endl;  // 1
    cout << (t3 < t1) << endl;  // 1
    cout << (t3 == t1) << endl; // 0
    return 0;
}
```

### 返回多个tuple

可以借助容器或者数组实现

```cpp
//example4.cpp
struct Pack
{
    tuple<int, int> res[3];
};

Pack func1()
{
    Pack pack;
    tuple<int, int>(&res)[3] = pack.res;
    get<0>(res[0]) = 1;
    get<1>(res[0]) = 2;
    get<0>(res[1]) = 1;
    get<1>(res[1]) = 2;
    get<0>(res[2]) = 1;
    get<1>(res[3]) = 2;
    return pack;
}

vector<tuple<int, int>> func2()
{
    vector<tuple<int, int>> vec;
    for (int i = 0; i < 3; i++)
    {
        vec.push_back(make_tuple(i, i + 1));
    }
    return vec;
}

int main(int argc, char **argv)
{
    Pack pack = func1();
    decltype(pack.res) &res = pack.res;
    cout << get<0>(res[0]) << " " << get<1>(res[0]) << endl;
    // 1 2
    vector<tuple<int, int>> &&res1 = func2();
    cout << get<0>(res1[0]) << " " << get<1>(res1[0]) << endl;
    // 0 1
    return 0;
}
```

### 返回tuple与tuple做参数

与标准容器一样，用tuple做参数时默认为拷贝

```cpp
//example5.cpp
tuple<int, string> func1(const tuple<string, int> &m_tuple)
{
    tuple<int, string> res;
    get<0>(res) = get<1>(m_tuple);
    get<1>(res) = get<0>(m_tuple);
    return res;
}

int main(int argc, char **argv)
{
    auto temp = make_tuple("hello", 10);
    const auto &&res = func1(temp);
    cout << get<0>(res) << " " << get<1>(res) << endl;
    // 10 hello
    return 0;
}
```

### bitset类型

已经学习过位运算的相关知识，标准库还定义了bitset类，使得位运算使用起来更为容易，能够处理超过最长整形类型大小的位集合

```cpp
#include<bitset>
```

### 定义和初始化bitset

bitset是一个模板，与array类类似，有固定大小

编号从0开始的二进制位被称为低位、编号到n-1结束的二进制被称为高位

```cpp
//example6.cpp
int main(int argc, char **argv)
{
    bitset<10> b1;       // n位全为0
    bitset<64> b2(1ull); //使用unsigned long long初始化
    bitset<128> b22(0xbeef);
    bitset<128> b23(~0ull); // 64个1

    //使用字符串初始化
    string str = "010101010101";
    bitset<32> b31(str);
    cout << b31 << endl; // 00000000000000000000010101010101

    bitset<32> b32(str, 0, str.size(), '0', '1'); //'0'为0 '1'为1
    cout << b32 << endl;                          // 00000000000000000000010101010101

    bitset<32> b33(str, 0, 3); //[ 0, 2 ]
    cout << b33 << endl;       // 00000000000000000000000000000010

    bitset<32> b34(str, str.size() - 4); //末尾4位
    cout << b34 << endl;                 // 00000000000000000000000000000101

    try
    {
        bitset<32> b4(str, 0, str.size(), '0', 'g'); //有非g的字符
    }
    catch (invalid_argument e)
    {
        cout << e.what() << endl; // bitset::_M_copy_from_ptr
    }

    // C字符串初始化
    const char *str1 = "010101000111";
    bitset<32> b5(str1); //默认为[0,strlen(str1)-1]
    cout << b5 << endl;  // 00000000000000000000010101000111

    bitset<32> b6(string(str1), 0, 1, '0', '1');
    cout << b6 << endl; // 00000000000000000000000000000000
    return 0;
}
```

### bitset操作

bitset类模板支持功能丰富的二进制相关操作

![bitset操作](<../../../.gitbook/assets/屏幕截图 2022-07-22 114326.jpg>)

### bitset统计操作

bitset支持统计其中的零一比特位，操作有bitset.any()、bitset.all()、bitset.count()、bitset.size()、bitset.none()

```cpp
//example7.cpp
int main(int argc, char **argv)
{
    bitset<64> b(888ULL);
    cout << b << endl;
    // 0000000000000000000000000000000000000000000000000000001101111000
    cout << b.any() << endl;   // 1 是否存在1
    cout << b.all() << endl;   // 0 是否全为1
    cout << b.count() << endl; // 6 有几个1
    cout << b.size() << endl;  // 64 bitset大小
    cout << b.none() << endl;  // 0 是否全为0

    bitset<32> b1;
    cout << b1 << endl;
    // 00000000000000000000000000000000
    cout << b1.any() << endl;   // 0 是否存在1
    cout << b1.all() << endl;   // 0 是否全为1
    cout << b1.count() << endl; // 0 有几个1
    cout << b1.size() << endl;  // 32 bitset大小
    cout << b1.none() << endl;  // 1 是否全为0
    return 0;
}
```

### bitset修改操作

bitset支持改变bitset内的内容,bitset.flip()、bitset.reset()、bitset.set()、bitset.test(),bitset\[pos]

```cpp
//example8.cpp
int main(int argc, char **argv)
{
    bitset<10> b;
    cout << b << endl; // 0000000000

    //默认
    b.flip();          //反转所有位
    cout << b << endl; // 1111111111
    b.reset();         //全置为0
    cout << b << endl; // 0000000000
    b.set();           //全置为1
    cout << b << endl; // 1111111111

    //指定下标
    b.flip(0);
    cout << b << endl; // 1111111110
    b.set(0);
    cout << b << endl; // 1111111111
    b.set(1, 0);       // index 1 value 0
    cout << b << endl; // 1111111101
    b.reset(0);
    cout << b << endl; // 1111111100
    //判断是bit 1
    cout << b.test(0) << " " << b.test(2) << endl; // 0 1

    //下标操作
    cout << b << endl; // 1111111100
    b[0] = 1;
    cout << b << endl; // 1111111101
    b[1] = b[0];
    cout << b << endl; // 1111111111
    b[0].flip();
    cout << b << endl; // 1111111110
    bool res = ~b[0];
    cout << res << endl; // 1
    return 0;
}
```

### bitset提取值

bitset.to\_ulong()与bitset.to\_ullong操作，只有bitset的大小与unsigned long 与 unsigned long long 内存大小相等时，才能调用这两个方法

```cpp
//example9.cpp
int main(int argc, char **argv)
{
    cout << sizeof(unsigned long) * 8 << endl;      // 32bit
    cout << sizeof(unsigned long long) * 8 << endl; // 64bit

    bitset<32> b1;
    unsigned long res1 = b1.to_ulong();

    bitset<64> b2;
    unsigned long long res2 = b2.to_ullong();
    cout << b2.to_string() << endl;
    // 0000000000000000000000000000000000000000000000000000000000000000

    try
    {
        bitset<128> b3;
        b3.set();
        int res = b3.to_ulong(); // b3装不到ulong里
    }
    catch (overflow_error e)
    {
        cout << e.what() << endl; //_Base_bitset::_M_do_to_ulong
    }
    return 0;
}
```

### bitset的IO运算

bitset作为作为输入流时，其原理为先用临时的字符串流存储，然后用字符串对bitset进行了改变，在读取字符串时，遇到输入流结尾或者不是'0'或'1'时结束\
bitset作为输出流时也是将内容以字符串形式输出

```cpp
//example10.cpp
int main(int argc, char **argv)
{
    bitset<10> b1;
    string s1 = "0101010011";
    stringstream s;
    s << s1;
    s >> b1;
    cout << b1 << endl; // 0101010011
    return 0;
}
```

### bitset实战

请你用尽可能内存少数据存储64个同学的成绩是否通过的数据结构

```cpp
//example11.cpp
class Data
{
private:
    bitset<64> base;
    function<bool(int)> check;

public:
    Data(const function<bool(int)> &check) : check(check)
    {
    }
    void set(int index, int score)
    {
        if (check(score))
        {
            base.set(index);
        }
    }
    string to_string()
    {
        return base.to_string();
    }
    bool operator[](const int &index)
    {
        return base[index];
    }
};

int main(int argc, char **argv)
{
    Data data([](int score) -> bool
              { return score >= 60; });
    cout << data.to_string() << endl;
    // 0000000000000000000000000000000000000000000000000000000000000000
    data.set(0, 45);
    data.set(1, 78);
    cout << data.to_string() << endl;
    // 0000000000000000000000000000000000000000000000000000000000000010
    cout << data[0] << " " << data[1] << endl;
    // 0 1
    return 0;
}
```

可以发现第17章是很有趣的一章，因为在前面的章节内我们已经学习了关于C++的大多数功能特性，再此应用起来也能够明白其内的原理
