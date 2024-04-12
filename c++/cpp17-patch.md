# 🍎 C++17 特性

C++17 引入了许多新特性和语言改进，下面是其中一些主要的特性：

1、结构化绑定（Structured Binding）：可以通过结构化绑定语法将一个复杂数据类型的成员变量绑定到一个或多个变量上，从而方便地访问这些变量。

2、if with initializer：允许在 if 语句中声明和初始化变量，简化了代码。

3、嵌套命名空间（Nested Namespace）：可以将命名空间嵌套到其他命名空间中，提高了代码的组织性和可读性。

4、表达式语句（Expression Statement）：允许将一个表达式作为语句使用，方便了一些特殊情况的编码。

5、constexpr if 语句：允许在编译时根据条件选择不同的代码路径，提高了代码的性能和可读性。

6、类模板参数推导（Class Template Argument Deduction）：允许编译器从函数调用中推导出类模板参数，简化了代码。

7、折叠表达式（Fold Expression）：可以使用折叠表达式对多个表达式进行折叠求值，简化了代码。

8、元编程（Metaprogramming）：引入了一些新的元编程特性，如变量模板、内联变量和 if constexpr 等。

9、[[nodiscard]]属性：可以使用[[nodiscard]]属性来告诉编译器，某个函数返回的结果不应该被忽略。

10、内联变量（Inline Variable）：可以将变量声明为内联的，从而避免了多个编译单元中定义相同的变量时的重复定义错误。

11、UTF-8 字符串字面量：C++17 支持 UTF-8 字符串字面量，可以更好地处理多语言字符集。

12、std::variant类型

13、std::any类型

14、并行算法库

15、std::filesystem 文件系统库

16、新的字符串字面值后缀 sv, if and s

17、其他细节改进：C++17 还引入了一些其他的细节改进，如 constexpr lambda 表达式、std::invoke()函数、std::optional<T>类模板等。

## 文件系统库

C++17 新特性 用起来就是一个字 爽

### std::filesystem::path

```cpp
#include <iostream>
#include <filesystem>
using namespace std;
namespace fs = std::filesystem;

int main()
{
    // 赋值
    fs::path m_path = "sandbox\\a\\b"; // 初始化
    m_path.assign("sandbox\\a");       // 赋值

    // 连接
    m_path.append("c");
    m_path /= "d";          // 自动带分隔符号
    cout << m_path << endl; //"sandbox\\a\\c"
    m_path.concat("\\e");
    m_path += "\\f";        // 不自动带分隔符
    cout << m_path << endl; //"sandbox\\a\\c\\d\\e\\f"

    // 修改器
    m_path.clear(); // 擦除
    m_path.assign("sandbox/a/b");
    fs::path p = m_path.make_preferred(); // 偏好分隔符 //在 Windows 上 \ 是偏好分隔符， foo/bar 将被转换为 foo\bar 。
    cout << p << endl;                    //"sandbox\\a\\b"
    p.assign("dir/dir/m.txt");
    cout << p.remove_filename() << endl; //"dir/dir/"
    cout << p.remove_filename() << endl; //"dir/dir/" 返回值*this
    // 替换单个文件名组分 "a/b/f.mp4"
    cout << fs::path("a/b/c.mp4").replace_filename("f.mp4") << endl;
    // 替换文件扩展名 "/a/b.html"
    cout << fs::path("/a/b.mp4").replace_extension("html") << endl;
    // 交换两个路径
    fs::path a = "p";
    fs::path b = "b";
    a.swap(b);
    cout << a << " " << b << endl; //"b" "p"

    // 格式观察器
    cout << m_path.string() << endl;         // sandbox\a\b
    wcout << m_path.wstring() << endl;       // sandbox\a\b
    cout << m_path.generic_string() << endl; // sandbox/a/b 返回转换到字符串的通用路径名格式

    // 字典序列比较
    fs::path other("sandbox\\a\\b");
    cout << m_path.compare(other) << endl; // 0

    // 生成
    cout << fs::path("/dsc/./../").lexically_normal().string() << endl; //'\'  路径的正规形式
    cout << fs::path("/a/d").lexically_relative("/a/b/c") << endl;      //"..\\..\\d" 路径的相对形式
    cout << fs::path("/a/b/e").lexically_proximate("/a/b/c/c") << endl; //"..\\..\\e" 转换路径到准确形式

    // 分解
    cout << fs::current_path() << endl; // 执行程序路径
    //"C:\\Users\\gaowanlu\\Desktop\\MyProject\\tempcpp\\ConsoleApplication2\\ConsoleApplication2"
    cout << fs::current_path().root_name() << endl;
    //"C:"
    cout << fs::path("/mes/cpp.cpp").root_path() << endl;      //"/" 若存在则返回路径的根路径
    cout << fs::path("/mes/cpp.cpp").root_directory() << endl; //"/"若存在则返回路径的根目录
    cout << fs::path("/mes/cpp.cpp").root_name() << endl;      //"" 若存在则返回路径的根名
    // 返回相对根路径的路径
    cout << fs::path("/mes/cpp.cpp").relative_path() << endl; //"mes/cpp.cpp"
    // 到父目录的路径。
    cout << fs::path("/mes/cpp.cpp").parent_path() << endl; //"/mes"
    cout << fs::path("/mes/.").parent_path() << endl;       //"/mes"
    // 返回文件名
    cout << fs::path("/mes/cpp.cpp").filename() << endl; //"cpp.cpp"
    cout << fs::path("..").filename() << endl;           //..
    cout << fs::path("/mes/..").filename() << endl;      //..
    // 返回文件名，并剥去扩展名
    auto temp = fs::path("/mes/filename.cpp");
    cout << temp.stem() << endl; //"filename"
    // 返回扩展名部分
    cout << temp.extension() << endl;                 //".cpp"
    cout << fs::path("sdc/../.").extension() << endl; //""

    // 查询
    cout << fs::path("  ").empty() << endl;                // 0 检查路径是否为空
    cout << fs::path("").empty() << endl;                  // 1
    cout << fs::path("/a/s").has_extension() << endl;      // 0 检查 root_path() 是否为空。
    cout << fs::path("/a/s").has_root_name() << endl;      // 0
    cout << fs::path("/a/s").has_root_directory() << endl; // 1
    cout << fs::path("/a/s").has_relative_path() << endl;  // 1
    cout << fs::path("/a/s").has_parent_path() << endl;    // 1
    cout << fs::path("/a/s").has_filename() << endl;       // 1
    cout << fs::path("/a/s").has_stem() << endl;           // 1
    cout << fs::path("/a/s").has_extension() << endl;      // 0

    // 检查是否为相对或绝对路径
    cout << fs::path("/as/sda").is_absolute() << endl;    // 0
    cout << fs::path("../ssd/../").is_relative() << endl; // 1

    // 迭代器
    for (auto p = temp.begin(); p != temp.end(); p++)
    {
        cout << *p << endl; //"/" "mes" "filename.cpp"
    }

    // 非成员函数支持
    // swap hash_value
    // 字典序列比较 operator== operator!= operator!= operator< operator<=
    // operator> operator>= operator<=>
    // operator/
    // 用分隔符连接两个路径 operator<<
    // operator>>

    // 支持hash
    size_t code = fs::hash_value(temp);
    cout << code << endl; // 12442686431355853930
    auto code_other = hash<fs::path>{}(temp);
    cout << (code == code_other) << endl; // 1
    return 0;
}
```

## 扩展的inline说明符

### 定义非常量静态成员变量的问题

在C++17标准以前，定义类的非常量静态成员变量是一件让人头痛的事情，因为变量的声明和定义必须分开进行。

```cpp
#include <iostream>
using namespace std;

class X
{
public:
    static std::string text;
};

std::string X::text{"hello"};

int main(int argc, char **argv)
{
    X::text += " world";
    std::cout << X::text << std::endl;
    return 0;
}
```

`static std::string text`是静态成员变量的声明，`std::string X::text{"hello"}`
是静态成员变量的定义和初始化。为了保证代码能够顺利地编译，必须保证
静态成员变量地定义有且只有一份，非常引发错误，比较常见的就是为了方便
将静态成员变量的定义放在头文件中。

```cpp
#ifndef X_H
#define X_H
class X
{
public:
    static std::string text;
};
std::string X::text{"hello"};
#endif
```

因为被include到多个cpp文件中，在链接时会发生重复定义的错误。对于一些字面量类型如 整型、浮点型等，这种情况有所缓解，至少对于它们而言静态成员
变量可以一边声明一边定义的。

```cpp
#include <iostream>
#include <string>
class X
{
public:
    static const int num{5};
};
int main()
{
    std::cout << X::num << std::endl;
    return 0;
}
```

虽然常量可以让它们方便地声明和定义，但却丢失了修改变量地能力，对于std::string这种非字面量类型，这种方法是无能为力的。

### C++17内联定义静态变量

C++17标准中增强了inline说明符的能力，允许内联定义静态变量。

下面代码可以编译和运行，即使将类X的定义作为头文件包含在多个CPP中也不会有任何问题，这种情况下，编译器会在类X的定义首次出现时对内联静态成员进行定义和初始化。

```cpp
#include <iostream>
using namespace std;

class X
{
public:
    inline static std::string text{"hello"};
};

int main(int argc, char **argv)
{
    X::text += " world";
    std::cout << X::text << std::endl;
    return 0;
}
```

### C++17 constexpr内联属性

C++17中，constexpr声明静态成员变量时，被赋予了变量的内联属性，如

```cpp
#include <iostream>
using namespace std;

class X
{
public:
    static constexpr int num{5};
};

// 以上代码在C++17中等同于

class A
{
public:
    inline static constexpr int num{5};
};

int main(int argc, char **argv)
{
    char buffer1[X::num]{0};
    char buffer2[A::num]{0};
    return 0;
}
```

自C++11以来就有,这种用法，那么C++11和C++17中有什么区别。

```cpp
static constexpr int num{5};
```

C++11 ，num是只有声明没有定义的，虽然我们可以通过`std::cout << X::num << std::endl`输出其结果，但这实际上是编译器的一个小把戏，它将`X::num`直接替换为了5。如果将输出语句修改为`std::cout << &X::num << std::endl`，那么链接器会明确报告`X::num`缺少定义。

从C++17开始情况发生了变化，`static constexpr int num{5}`既是声明也是定义，所以在C++17标准中`std::cout << &X::num << std::endl`可以顺利编译链接，并且输出正确的结果。值得注意的是，对于编译器而言为`X::num`产生定义并不是必需的，如果代码只是引用了`X::num`的值，那么编译器完全可以使用直接替换为值的技巧。只有当代码中引用到变量指针的时候，编译器才会为其生成定义。
