---
cover: >-
  https://images.unsplash.com/photo-1650539886793-8968d41fabb7?crop=entropy&cs=tinysrgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTMyMjI2NTc&ixlib=rb-1.2.1&q=80
coverY: 0
---

# 🥰 第8章 IO库

## 第8章 IO库

C++中不直接处理输入输出，而是通过一系列定义在标准库中的类型处理IO，这些类型支持从设备读取数据，向设备写入数据的IO操作，设备可以是文件，控制台窗口等\
还有一些类型允许操作内存IO，即从string读取数据，向string写入数据

我们已经接触了

istream输入流类型，提供输入操作。ostream输出流类型，提供输出操作。\
cin是一个istream对象，从标准输入读取数据\
cout是一个ostream对象，向标准输出写入数据\
cerr是一个ostream对象，通常用于输出程序错误信息，写入到标准错误\
\>>运算符，用来从一个istream对象读取输入数据\
<<运算符，用来向一个ostream对象写入输出数据\
getline函数，从一个给定的istream读取一行数据，存入一个给定的string对象中

### IO类

先知道下面的东西大致有什么用途即可

![IO库类型和头文件](<../../../.gitbook/assets/屏幕截图 2022-05-23 123506.jpg>)

以w开头的是表示支持使用宽字符的语言，C++定义类一组来操纵wchar\_t类型的数据，宽字符版本类型和函数以w开头，如wcin,wcout,wcerr

```cpp
//example1.cpp
#include<iostream>
using namespace std;
int main(int argc,char**argv){
    wstring name;
    wcin >> name;//你好
    wcout << name << endl;//你好
    cout << name.length() << endl;//4
    return 0;
}
```

### IO类型间的关系

不同的输入输出流之间只通过继承机制来实现的，所有输入流的基类都是istream，所有输出流的基类是ostream

### IO对象无拷贝或赋值

总之IO对象是不能进行赋值的，因为不能拷贝，所以不能将形参或返回类型设置为流类型\
通常会使用引用方式传递和返回，因为读写一个对象会改变其状态，传递和返回的引用不能是const的

### 条件状态

流对象有自己的状态，称为操作流的条件状态

![IO库条件状态](<../../../.gitbook/assets/屏幕截图 2022-05-23 125105.jpg>)

看不懂没关系，先知道有这么回事，会面的学习才会真的用起来

```cpp
//example2.cpp
#include<iostream>
using namespace std;
int main(int argc,char**argv){
    cout << cin.eof() << endl;//0
    cout << cin.fail() << endl;//0
    cout << cin.good() << endl;//1 此时流状态位goodbit为1

    std::ios_base::iostate state=std::ios_base::failbit;
    cin.setstate(state);
    //读取条件状态
    cout << (cin.rdstate()==std::ios_base::failbit) << endl;//1
    cout << (cin.rdstate()==cin.failbit) << endl;//1
    cout << cin.good() << endl;//0

    return 0;
}
```

实际使用

```cpp
//example3.cpp
#include<iostream>
using namespace std;
int main(int argc,char**argv){
    int i;
    cin >> i;//g
    cout << cin.good() << endl;//0
    cout << i << endl;//0
    cin >> i;//不会被正常执行，因为cin的状态已经发生错误
    cout << cin.good() << endl;//0
    return 0;
}
```

如果将流操作放入if或者while等需要进行布尔检查的地方，则会检查流的状态

```cpp
//example4.cpp
#include<iostream>
using namespace std;
int main(int argc,char**argv){
    int i;
    if(cin>>i){
        cout << i << endl;
    }
    //输入 e 输出 none
    //输入 3 输出 3
    return 0;
}
```

### 管理条件状态

读取条件状态使用rdstate()方法，使用clear()恢复默认的状态,setstate设置状态

```cpp
//example5.cpp
#include<iostream>
using namespace std;
int main(int argc,char**argv){
    auto old_state = cin.rdstate();
    cin.clear();//恢复默认条件状态
    cin.setstate(old_state);
    //复位时可以保持其他标志位不变
    cin.clear(cin.rdstate() & ~cin.failbit & ~cin.badbit);
    //辅位failbit、badbit 保持其他标志位不变
    return 0;
}
```

### 管理输出缓冲

每个输出流都管理一个缓冲区，用来保存程序读写的数据

```cpp
os<<"hello world";
```

文本可能马上打印出来，也可能保存在缓冲区中，随后打印\
操作系统可以将多个程序的多个输出操作组合称单一的系统级写操作，提高效率

导致缓冲刷新，即数据真正写出输出设备或文件的原因有很多

* 程序正常结束，作为main函数的return操作的一部分，缓冲被刷新
* 缓冲区满的时候
* 使用endl显式刷新缓冲区
* 每个输出操纵后，可以使用操纵符unitbuf设置流的内部状态，来清空缓冲区，cerr默认是被设置unitbuf的，因此写入到cerr的内容会马上输出
* 一个输出流可能被关联到另一个流，当读写被关联的流时，关联到的流的缓冲区会被刷新，如cin、cerr都关联到cout,因此读cin或写cerr都会导致cout的缓冲区被刷新

```cpp
//example6.cpp
#include <iostream>
using namespace std;
int main(int argc, char **argv)
{
    cout << "hello world" << endl;//输出加换行 然后刷新
    cout << "hello world" << flush;//输出 然后刷新
    cout << "hello world" << ends;//输出加一个空字符 然后刷新
    //hello world
    //hello worldhello world
    return 0;
}
```

### unitbuf操纵符

```cpp
//example7.cpp
#include<iostream>
using namespace std;
int main(int argc,char**argv){
    cout << unitbuf;
    //都cout的写入都会立即刷新缓冲区，即立即输出
    //即cout不再使用缓冲区
    cout << "hello world";//hello world
    cout << nounitbuf;//恢复使用缓冲方式
    return 0;
}
```

### 关联输入和输出流

当一个输入流关联到一个输出流时，任何试图输入流读取数据的操作都会先刷新关联的输出流，默认cout与cin关联在一起

```cpp
//example8.cpp
#include<iostream>
using namespace std;
int main(int argc,char**argv){
    cout << "hello world" << endl;
    int i;
    cin >> i;//cout被缓冲区被刷新
    //也就是形成了先输出才会等待输入
    return 0;
}
```

`tie()`方法允许我们进行输入和输出流之间的关联\
`tie`有两个重载一个接收输出流的指针（设置关联的输出流指针），一个没有参数（返回关联输出流的指针）

```cpp
//example9.cpp
#include<iostream>
using namespace std;
int main(int argc,char**argv){
   std::ostream* m_ostream=cin.tie();
   if(m_ostream==&cout){
       cout << "m_ostream==&cout" << endl;//m_ostream==&cout
   }
   cin.tie(nullptr);//取消与其他输出流的关联
   cin.tie(&cout);//恢复关联
   return 0;
}
```
