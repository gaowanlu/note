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

### 正则表达式

C++是支持正则表达式的，如果你还不知道正则表达式请查阅相关博客或者教学视频进行了解其理论基础与实际用法

```cpp
#include<regex>
```

正则表达式库组件

![正则表达式库组件](<../../../.gitbook/assets/屏幕截图 2022-07-23 223413.jpg>)

regex\_match用于匹配整个输入序列与表达式匹配，则返回true\
regex\_search用于如果输入序列中一个子串与表达式匹配，则返回true

![regexsearch和regex\_match的参数](<../../../.gitbook/assets/屏幕截图 2022-07-23 223816.jpg>)

表达式基础

![正则表达式语法规则](<../../../.gitbook/assets/屏幕截图 2022-07-23 224319.jpg>)

### 使用正则表达式

下面以`[abc]wan`表达式为模板，其表达式的含义为以abc中任意一个字符开头，且后面紧跟的序列为wan

```cpp
//example12.cpp
int main(int argc, char **argv)
{
    string pattern("[abc]wan");
    regex r(pattern);
    smatch results;
    string test = "cwanawanbwanwan";
    regex_search(test, results, r);
    cout << results.str() << endl; // cwan

    const sregex_iterator end;
    sregex_iterator iter(test.begin(), test.end(), r);
    while (iter != end)
    {
        cout << iter->str() << endl; // cwan awan bwan
        iter++;
    }

    return 0;
}
```

### 深入regex对象

正则表达式是一种语言，但是其有多种版本，这些都是历史遗留问题，C++允许在创建regex与wregex时指定正则表达式语法版本

![regex和wregex的选项](<../../../.gitbook/assets/屏幕截图 2022-07-23 225629.jpg>)

```cpp
//example13.cpp
int main(int argc, char **argv)
{
    string s1 = "[acv]pp";
    const char *s2 = "[acv]pp";
    regex p1(s1, regex::icase);
    p1 = s2;
    regex p2 = p1;
    p2.assign(s1, regex::optimize);
    return 0;
}
```

### regex相关异常

正则表达式本身可以视为一种简单程序设计语言，这种语言的解析不是C++编译器解决的，所以有异常时，也是运行时异常而非编译错误

![正则表达式错误类型](<../../../.gitbook/assets/屏幕截图 2022-07-23 230446.jpg>)

```cpp
//example14.cpp
int main(int argc, char **argv)
{
    try
    {
        regex r("[acv", regex::icase);
    }
    catch (regex_error e)
    {
        // Unexpected character in bracket expression.
        cout << e.what() << endl;
    }
    cout << "hi" << endl; // hi
    return 0;
}
```

### 输入序列类型

输入序列类型可以为，char数据和wchar\_t数据，字符可以保存在string或char数组中、宽字符版本，w\_string或wchar\_t数组中

regex默认为匹配char字符，如果操作宽字符要使用wregex

![正则表达式库类](<../../../.gitbook/assets/屏幕截图 2022-07-23 231220.jpg>)

```cpp
//example15.cpp
int main(int argc, char **argv)
{
    regex r1("[abc]ui");
    smatch res1;
    // regex_search("cui", res1, r1);
    //错误 不应用smatch接收char序列的结果
    string test = string("cui");
    regex_search(test, res1, r1); //正确
    cmatch res2;
    regex_search("cui", res2, r1); //正确

    wstring test2 = L"b你好";
    wsmatch res3;
    wregex r2(L"[abc]你好");
    regex_search(test2, res3, r2);
    // wcout.imbue(std::locale(""));
    wcout << res3.str() << endl;

    wchar_t ch = L'你';
    cout << ch << endl;

    return 0;
}
```

### 匹配和Regex迭代器类型

有时需要找出一个序列中所有符号要求的子序列，这就需要使用sregex\_iterator、cregex\_iterator、wsregex\_iterator和wcregx\_iterator

![sregex\_iterator操作](<../../../.gitbook/assets/屏幕截图 2022-07-24 160628.jpg>)

```cpp
//example16.cpp
int main(int argc, char **argv)
{
    string pattern("[^bc]ui");
    string test = "buicuiruiuitui";
    regex r(pattern, regex::icase);
    for (sregex_iterator iter(test.begin(), test.end(), r), end_iter; iter != end_iter; ++iter)
    {
        cout << iter->str() << endl; // rui tui
    }
    return 0;
}
```

我们会发现上面的匹配结果中并没有`iui`,为什么呢？因为在扫描test时有一个迭代器，每次从那个迭代器使用regex\_search然后从开头进行匹配，匹配成功则将迭代器移动到符合要求的子串的后面，所以在`buicuiruiuitui`迭代器到`uitui`时匹配成功的子序列就是`tui`

### smatch操作

本质上每个sregex\_iterator指向一个smatch,smatch本身可以提供很多额外的信息

![smatch操作](<../../../.gitbook/assets/屏幕截图 2022-07-24 162117.jpg>)

```cpp
//example17.cpp
int main(int argc, char **argv)
{
    string pattern("[^bc]ui");
    string test = "buicuiruiuitui";
    regex r(pattern, regex::icase);
    for (sregex_iterator iter(test.begin(), test.end(), r), end_iter; iter != end_iter; ++iter)
    {
        if (iter->ready())
        {
            cout << iter->str() << " "
                 << iter->prefix().str() << " "
                 << iter->suffix().str() << endl;
            // rui buicui uitui 此次的subffix会成为下次search的序列
            // tui ui 当subffix为空串时结束
            cout << iter->size() << endl;     // 1 1
            cout << iter->empty() << endl;    // 0 0
            cout << iter->length() << endl;   // 3 3
            cout << iter->position() << endl; // 6 11 匹配成功的子序列首字母下标
            cout << iter->format("$0=>") << endl; // tui=>
        }
    }
    return 0;
}
```

### 使用子表达式

一个正则表达式从语法上由多个子表达式共同组成

```cpp
//example18.cpp
int main(int argc, char **argv)
{
    regex r("([[:alnum:]]+)\\.(cpp|cxx|cc)$", regex::icase);
    //[[:alnum:]]+ [a-z]+
    //\\. .
    //(cpp|cxx|cc)
    //$
    string test("dcsc.cpp dsc.cpp vfd.cxx fgbf.cc sdfc.cc");
    smatch res;
    regex_search(test, res, r);
    //子表达式匹配结果
    for (size_t i = 0; i < res.size(); i++)
    {
        cout << res.str(i) << endl;
        // sdfc.cc
        // sdfc
        // cc
    }
    for (sregex_iterator iter(test.begin(), test.end(), r), end_iter; iter != end_iter; ++iter)
    {
        cout << iter->str() << endl; // sdfc.cc
    }
    return 0;
}
```

### 使用子匹配操作

根据ECMAScript标准，正则表达式`(\\()?(\\d{3})(\\))?([-. ])?(\\d{3})([-. ]?)(\\d{4})`

1、`(\\()?`表示可选的左括号\
2、`(\\d{3})`表示三位数字\
3、`(\\))?`表示可选的右括号\
4、`([-. ])?`表示可选的- . 空格\
5、`(\\d{3})`表示三位数字\
6、`([-. ]?)`表示可选的- . 空格\
7、`(\\d{4})`表示4位数字

仅仅拥有整个正则表达式是否匹配成功的信息是不足够的，smatch内有ssub\_match的信息，\[0]表示整个匹配，\[1]表示第一个子表达式匹配，以此类推

![子匹配操作](<../../../.gitbook/assets/屏幕截图 2022-07-24 172624.jpg>)

```cpp
//example19.cpp
//因为phonePattern由8个子表达式组成，所以m有8个ssub_match元素
bool valid(const smatch &m)
{
    if (m[1].matched)
    { //有左括号
        return m[3].matched && (m[4].matched && m[4].str() == "-");
    }
    else
    {
        return !m[3].matched && m[4].str() == m[6].str();
    }
}

int main(int argc, char **argv)
{
    string phonePattern = "(\\()?(\\d{3})(\\))?([-. ])?(\\d{3})([-. ])?(\\d{4})";
    regex r(phonePattern);
    smatch m;
    string s = "434-434-5423"; // valid: 434-434-5423
    for (sregex_iterator iter(s.begin(), s.end(), r), end_iter; iter != end_iter; ++iter)
    {
        if (valid(*iter))
        {
            cout << "valid: " << iter->str() << endl;
        }
        else
        {
            cout << "not valid: " << iter->str() << endl;
        }
    }
    return 0;
}
```

### regex\_replace

regex\_replace用于在匹配时，将符合要求的子序列替换成其他指定的内容

![正则表达式替换操作](<../../../.gitbook/assets/屏幕截图 2022-07-24 173017.jpg>)

```cpp
//example20.cpp
int main(int argc, char **argv)
{
    string phonePattern = "(\\()?(\\d{3})(\\))?([-. ])?(\\d{3})([-. ])?(\\d{4})";
    regex r(phonePattern);
    string s = "434-434-5423 434-434-5423";
    string fmt = "$2.$5.$7"; //第2个表达式.第5个表达式.第7个表达式
    string fmted = regex_replace(s, r, fmt);
    cout << fmted << endl; // 434.434.5423 434.434.5423
    return 0;
}
```

### 匹配和格式标志

这些标志可以传递给函数regex\_search、regex\_match、smatch的format成员

![匹配标志](<../../../.gitbook/assets/屏幕截图 2022-07-24 181330.jpg>)

```cpp
//example21.cpp
int main(int argc, char **argv)
{
    string phonePattern = "(\\()?(\\d{3})(\\))?([-. ])?(\\d{3})([-. ])?(\\d{4})";
    regex r(phonePattern, regex::icase);
    string s = "434-434-5423 434-434-5523nvfdkjnvdk";
    string fmt = "$2.$5.$7"; //第2个表达式.第5个表达式.第7个表达式
    string fmted = regex_replace(s, r, fmt, std::regex_constants::format_no_copy);
    cout << fmted << endl; // 434.434.5423434.434.5523

    fmted = regex_replace(s, r, fmt);
    cout << fmted << endl; // 434.434.5423 434.434.5523nvfdkjnvdk

    sregex_iterator end_iter;
    for (sregex_iterator iter(s.begin(), s.end(), r); iter != end_iter; ++iter)
    {
        cout << iter->str() << endl; // 434-434-5423 434-434-5523
    }
    for (sregex_iterator iter(s.begin(), s.end(), r, std::regex_constants::match_continuous); iter != end_iter; ++iter)
    {
        cout << iter->str() << endl; // 434-434-5423
    }

    return 0;
}
```
