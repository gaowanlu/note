---
coverY: 0
---

# 第2章 线程管理

## 线程管理

一个程序至少有一个正在执行的main()函数的线程，其他线程与主线程同时运行

### 创建线程的方式

创建线程的方式有很多，可以使用C风格的调用pthread线程库函数实现，但是C++标准中定义了thread相关接口，底层依赖动态库pthread但是这使得不同平台上的C++多线程代码能够得到统一的规范，使得代码的平台可移植性大大提高

### 使用函数指针

```cpp
//example1.cpp
#include<thread>
#include<iostream>

using namespace std;

void hello(){
    cout << "hello world" << endl;
}

int main(int argc,char**argv){
    thread process(hello);
    process.join();//等待线程process运行结束
    return 0;
}
//g++ example1.cpp -o example1.exe -lpthread && ./example1.exe
```

### 使用重写()方法

```cpp
//example2.cpp
#include<thread>
#include<iostream>

using namespace std;

//使用函数对象忘记的话就要复习C++基础知识喽
class Hello{
    public:
    void operator()() const{
        cout << "hello world"<<endl;
    }
};

int main(int argc,char**argv){
    Hello hello;
    //thread process(hello);//正确
    //thread process(Hello()); //error 相当于声明了Hello()函数，并不是创建了一个Hello对象
    //thread process((Hello()));//正确
    thread process{Hello()};//正确 使用初始化列表
    process.join();//等待线程运行结束
    return 0;
}
//g++ example2.cpp -o example2.exe -lpthread && ./example2.exe
```

### Lambda表达式

总之我们就是为线程的构造函数传递一个function对象例如接收`function<int(int,int)>`,function类型在标准库functional头文件中\
如果忘记了请看C++的第14章,Lambda表达式是C++11中新增的特性

```cpp
//example3.cpp
#include <iostream>
#include <thread>
using namespace std;

int main(int argc, char **argv)
{
    //传递lambda表达式
    thread m_thread([]() -> void
                    { cout << "hello thread" << endl; });
    m_thread.join(); // hello thread
    return 0;
}

// g++ ./example3.cpp -o example.exe -lpthread & ./example.exe
```

### 线程访问已经不存在的资源

主要体现在一个函数已经返回，而线程使用其内部的局部变量，函数已经返回，但是线程没有结束，仍旧尝试访问函数局部资源

```cpp
//example4.cpp
#include <iostream>
#include <thread>
using namespace std;

void func()
{
    int i = 999;
    thread process([&i]() -> void
                   {
        while(i>0){
            cout << --i << endl;
        } });
    process.detach(); //不等待线程结束
};

int main(int argc, char **argv)
{
    func();
    //结果并不会按照我们理想中的情形
    //从999...0 因为中途i的内存资源被释放掉了
    return 0;
}
// g++ ./example4.cpp -o example.exe -lpthread & ./example.exe
```

### 等待线程完成

如果要等待线程完成，则需要调用join()方法，一旦使用过join后，其joinable()将会返回false

```cpp
//example5.cpp
#include <iostream>
#include <thread>
using namespace std;

int main(int argc, char **argv)
{
    thread m_thread([]() -> void
                    { cout << "hello world" << endl; });
    if (m_thread.joinable())
    {
        m_thread.join();
    }
    cout << "joined" << endl;
    // joined一定在hello world之后
    return 0;
}
```

### 主线程结束子线程不一定结束

当主线程因为某种原因结束时，但是子线程还处于运行状态，则将会子线程分离出去保持运行，往往父线程出现错误终止时，要对子线程做出控制

```cpp
//example6.cpp
#include <iostream>
#include <thread>
using namespace std;

void func()
{
    throw runtime_error("error");
}

int main(int argc, char **argv)
{
    int i = 999;
    thread m_thread([&i]() -> void
                    {
                    while(i){
                        cout << --i << endl;
                    } });
    try
    {
        func();
        //即使func出错也会等到m_thread运行结束后结束程序
        //否则i的内存释放导致子线程运作不正常
    }
    catch (runtime_error e)
    {
        cout << e.what() << endl;
        m_thread.join();             //等待子线程运行结束
        throw runtime_error("exit"); //异常结束父线程
    }
    m_thread.join(); //正常等待
    return 0;
}
// g++ ./example6.cpp -o example.exe -lpthread & ./example.exe
```

### 编写thread\_guard

```cpp
//example7.cpp
#include <iostream>
#include <thread>
using namespace std;

class thread_guard
{
private:
    std::thread &t;

public:
    // explicit禁止用thread赋值给thread_guard
    explicit thread_guard(std::thread &t) : t(t) {}
    ~thread_guard() //当对象被销毁时调用
    {
        cout << "~thread_guard\n"
             << flush;
        if (t.joinable())
            t.join();
    }
    //禁止合成构造拷贝
    thread_guard(const thread_guard &) = delete;
    //禁止合成赋值拷贝
    thread_guard &operator=(const thread_guard &) = delete;
};

int main(int argc, char **argv)
{
    {
        int i = 999;
        thread m_thread([&i]() -> void
                        { while(i)cout<<--i<<endl; });
        thread_guard guard(m_thread);
        //这使得i的声明周期与guard声明周期是一样的
        //在i将会销毁时guard也会被销毁
        //进而触发guard析构函数内的join等待m_thread使用i完毕
    }
    return 0;
}
```

### 后台运行线程

使用detach()使得线程在后台运行，使得线程分离，不再有thread对象引用它，不再可控，但C++运行库保证，在线程退出时，相关的资源能够正常的回收\
分离线程通常称为`守护线程(daemon threads)`,一旦std::thread调用detach则对象本身不再与实际执行的线程有关系，且这个线程无法汇入（再次获得控制）\
只能对正在运行的线程使用detach也即是joinable()返回true

```cpp
//example8.cpp
#include <iostream>
#include <thread>
#include <unistd.h>
#include <fstream>
using namespace std;

int main(int argc, char **argv)
{
    thread f_thread([](){
        int i = 1000;
        // i为值捕获
        thread m_thread([i]() mutable -> void
                        { 
                            ofstream os("temp.iofile",fstream::app|fstream::in);
                            while(i>0){
                                cout << --i << endl;
                                os << to_string(i) << endl;
                            }
                            os.close();
                            cout << "close file" << endl;
                        });
        if (m_thread.joinable())
        {
            m_thread.detach(); //分离线程
        }
        cout << m_thread.joinable() << endl; // 0 线程分离后与m_thread对象再无关系 
    });
    f_thread.detach();
    sleep(5);//主进程线程睡眠5秒,否则进程结束全部线程停止
    cout << "end" << endl;
    //当父线程f_thread运行结束时 m_thread产生的线程并不会结束
    //但是当主进程结束时，其所有线程将会被结束
    return 0;
}
```

对于WINDOWS系统,主线程退出,其他未执行完毕的子线程也会退出,因为主线程退出调用exit(),相当于终止整个进程,其他线程自然而然会终止; 对于linux系统,主线程退出,其他未执行完毕的子线程不会退出,会继续执行,但是这个进程会编程僵尸进程,通过ps -ef查看进程列表,如果有defunct字样的进程,就是僵尸进程。僵尸进程应该被避免。所以,我们应该在主线程退出之前等待其他子线程执行完毕

1、父线程是主线程，则父线程退出后， 子线程一定会退出。\
2、父线程不是主线程，则父线程退出后， 子线程不受影响，继续运行。

总之进程的mian线程会随着主进程结束而结束，主进程结束程序的所有进程都会被干掉,但是子线程开的子线程就不同

### 参数传递

函数指针形式构造线程传参

```cpp
#include<iostream>
#include<thread>
#include<string>

using namespace std;

void f(int t,const string&s) {
	cout << t << " " << s << endl;
}

int main() {
	thread t1(::f,1,"hello");
	t1.join();//1 hello

	char buffer[1024];
	int i=999;
	sprintf_s(buffer, "%i",i);
	thread t2(f,1,buffer);//参数自动转换
	t2.join();//1 999
	return 0;
}
```

使用线程分离可能出现悬空指针的现象

```cpp
#include<iostream>
#include<thread>
#include<string>

using namespace std;

void f(int t,const string&s) {
	cout << t << " " << s << endl;
}

int main() {
	char buffer[1024];
	int i=999;
	sprintf_s(buffer, "%i",i);
	thread t2(f,1,buffer);//参数自动转换
	t2.detach();
	//在main结束时可能t2还没有利用buffer指针构造string
	//可能会造成悬空指针的问题

	//应该使用
	//std::thread t2(f,1,std::string(buffer));
	//在传递到构造函数之前，将字面值转化为string

	return 0;
}
```
