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
