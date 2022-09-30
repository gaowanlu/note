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

### 函数指针形式构造线程传参

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

### 使用线程分离可能出现悬空指针的现象

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

### 使用函数指针形式传递线程函数

怎样传递引用类型参数,因为thread的构造函数机制与std::bind类似，所以其绑定的参数是拷贝而不是引用，在语言基础泛型算法的bind引用参数部分学习过，以及std::ref的使用

```cpp
#include<iostream>
#include<thread>
#include<string>

using namespace std;

void func(int&i) {
	++i;
}

int main() {
	int i = 99;
	/*thread t(::func,i);
	t.join();
	cout << i << endl;*/
	//报错，thread的构造函数并不知道函数的参数类型
	//只是盲目的拷贝提供的变量
	//想要解决此问题就要使用ref
	thread t(::func,std::ref(i));
	t.join();
	cout << i << endl;//100
	return 0;
}
```

### thread构造函数与std::bind机制类似

可以提供一个成员函数指针，并提供一个其类型对象的地址

```cpp
#include<iostream>
#include<thread>
#include<string>
#include<functional>

using namespace std;

class X {
public:
	void exe(int num);
};

void X::exe(int num) {
	cout << num << endl;
}

int main() {
	X m_x;
	int num = 100;
	std::thread t(&X::exe, &m_x,num);
	t.join();//100

	function<void(int)> m_f = std::bind(&X::exe, &m_x, num);
	m_f(num);//100

	return 0;
}
```

### thread绑定参数时std::move的使用

```cpp
#include<iostream>
#include<thread>
#include<functional>
#include<memory>

using namespace std;

void func(unique_ptr<int>ptr) {
	cout << *ptr << endl;
}

void funcb(shared_ptr<int>ptr) {
	cout<<*ptr<<endl;
}

int main() {
	unique_ptr<int>ptr(new int(1));
	thread t(::func,std::move(ptr));
	t.join();
	//cout << *ptr << endl; ptr已经不再指向申请的内存，因为已经移交给了形参
	if (nullptr==ptr) {
		cout << "is nullptr" << endl;
	}
	//1
	//is nullptr

	shared_ptr<int>ptrb(new int(100));
	thread t1(::funcb,std::move(ptrb));
	t1.join();//100 
	cout <<boolalpha<< (ptrb == nullptr) << endl;//true

	//其过程是将ptrb所指的int对象，通过
	//将ptrb所指对象作为右值传递给int的移动构造器函数或移动赋值运算符
	//然后进行了内容拷贝

	return 0;
}
```

### 转移所有权

std::thread是不能进行赋值的，但是可以在std::thread没有绑定任务或者已经结束是使用std::move令其关联新的线程任务

```cpp
#include<iostream>
#include<thread>
#include<functional>
#include<memory>

using namespace std;

void funca() {
	for(int i=0;i<10;i++)
		cout << i << endl;
}

void funcb() {

}

int main() {
	thread t1(::funca);
	//std::move返回一个右值引用常量表达式
	thread t2 = std::move(t1);//t1背后的任务将由t2管理
	cout <<boolalpha<< t1.joinable()<<noboolalpha<< endl;//false
	cout << boolalpha << t2.joinable() << noboolalpha << endl;//true
	t2.join();
	cout << "executed funca" << endl;

	//如果thread左值已经关联一个线程，则不能修改其关联
	thread t3(::funca);
	//t3.join();//等待t3关联线程结束后，可以让其关联新的其他线程任务
	t3 = std::move(t2);//t3没结束前赋值会发生错误
	return 0;
}
```

### 在函数间传递std::thread作为参数以及函数的返回值

```cpp
#include<iostream>
#include<thread>
#include<functional>
#include<memory>

using namespace std;

void funcb() {
	cout << "funcb" << endl;
}

//thread作为函数参数
void func(thread t) {
	t.join();
}

//函数返回thread对象
thread back() {
	return thread(funcb);//允许
}

//函数返回thread对象
thread backb() {
	thread t(funcb);
	bool res=t.joinable();
	return t;
}

int main() {
	func(thread(funcb));//funcb
	thread t(funcb);
	//func(t);//不允许 禁止thread拷贝
	//使用std::move可以解决
	func(std::move(t));//funcb
	
	thread t1=back();
	t1.join();//funcb

	thread t2=backb();
	t2.join();//funcb
	return 0;
}
```

### thread引用类型作为函数参数

```cpp
#include<iostream>
#include<thread>
#include<functional>
#include<memory>

using namespace std;

void funcb() {
	cout << "funcb" << endl;
}

void func(thread &t) {
	cout << boolalpha << t.joinable() << noboolalpha << endl;//true
	t.join();
}


int main() {
	thread t(funcb);
	func(t);
	return 0;
}
```

### 基于转移所有权的作用域自动join,scoped\_thread

```cpp
#include<iostream>
#include<thread>
#include<functional>
#include<memory>

using namespace std;

//基于转移所有权的作用域自动join
class scoped_thread {
private:
	std::thread t;
public:
	explicit scoped_thread(std::thread t_) :t(std::move(t_)) {
		if (!t.joinable()) {
			throw std::logic_error("no thread");
		}
	}
	~scoped_thread() {
		t.join();
	}
	scoped_thread(const scoped_thread&) = delete;//禁止拷贝
	scoped_thread& operator=(const scoped_thread&) = delete;//禁止拷贝
};


int main() {
	{
		auto func = []()->void {
			cout << "hello world" << endl;
		};
		thread t(func);
		scoped_thread scoped(std::move(t));
	}
	cout << "end" << endl;
	return 0;
}

/*
hello world
end
*/
```

### joining\_thread自定义线程类

```cpp
#include<iostream>
#include<thread>
#include<functional>
#include<memory>
#include<string>

using namespace std;

//joining_thread
class joining_thread {
private:
	std::thread t;
public:
	joining_thread()noexcept = default;
	template<typename Callable,typename ...Args>
	explicit joining_thread(Callable&& func, Args&&...args):t(func,std::forward<Args>(args)...) {

	}
	explicit joining_thread(std::thread t_)noexcept :t(std::move(t_)) {

	}
	joining_thread(joining_thread&& other)noexcept:t(std::move(other.t)) {
		
	}
	joining_thread& operator=(joining_thread&& other)noexcept {
		if (joinable()) {
			join();
		}
		t = std::move(other.t);
		return*this;
	}
	bool joinable()const noexcept {
		return t.joinable();
	}
	void join() {
		if(joinable())
			t.join();
	}
	~joining_thread()noexcept {
		if (joinable())
			join();
	}
	void swap(joining_thread&other)noexcept {
		t.swap(other.t);
	}
	std::thread::id get_id()const noexcept {
		return t.get_id();
	}
	void detach() {
		t.detach();
	}
	std::thread& as_thread()noexcept {
		return t;
	}
	const std::thread& as_thread()const noexcept {
		return t;
	}
};

int main() {
	joining_thread t([]()->void {
		cout << "hello world" << endl;
	});//hello world
	return 0;
}
```

### 量产线程使用容器存储thread对象

```cpp
#include<iostream>
#include<thread>
#include<vector>
#include<functional>

using namespace std;

int main() {
	function<void(int)> func = [](int n)->void {
		cout << n << endl;
	};
	vector<thread>vec;
	for (int i = 0; i < 10; i++) {
		vec.emplace_back(func,i);
	}
	for (thread& t : vec) {
		t.join();
	}
	return 0;
}
```

### 确定线程数量

std::thread::hardware\_concurrency()返回值可以是CPU核心数量，返回值仅仅是一个标识，无法获取时返回0

```cpp
#include<iostream>
#include<thread>
#include<vector>
#include<functional>

using namespace std;

int main() {
	cout << std::thread::hardware_concurrency() << endl;// It's 12 on my host
	return 0;
}
```

### 编写并发的std::accumulate

```cpp
/*
并发版的std::accumulate
*/
#include<iostream>
#include<thread>
#include<vector>
#include<functional>
#include<numeric>

using namespace std;

template<typename Iterator,typename T>
void accumulate_block(Iterator first, Iterator end, T& t) {
	t = std::accumulate(first, end, t);
}

template<typename Iterator,typename T>
T parallel_accumulate(Iterator first, Iterator last, T init) {
	const unsigned long length = std::distance(first,last);//计算求和列表长度
	if (!length) {//长度为0
		return init;
	}
	//每个线程最小负责的长度
	const unsigned long min_per_thread = 25;
	//理应需要的线程数量 当length>=1时
	const unsigned long max_threads = (length + min_per_thread - 1) / min_per_thread;
	//CPU核心
	unsigned long const hardware_threads =std::thread::hardware_concurrency();
	//得出合理的线程数量
	unsigned long const num_threads = std::min(hardware_threads != 0 ? hardware_threads : 2, max_threads);
	//每个block的元素数量
	unsigned long const block_size = length / num_threads;
	//记录计算内容
	std::vector<T> results(num_threads);
	std::vector<std::thread> threads(num_threads - 1);
	
	Iterator block_start = first;
	for (unsigned long i = 0; i < (num_threads - 1); ++i)
	{
		Iterator block_end = block_start;
		std::advance(block_end, block_size);//移动迭代器
		threads[i] = std::thread( 
			accumulate_block<Iterator,T>,
			block_start, block_end, std::ref(results[i]));
		block_start = block_end; 
	}

	accumulate_block(block_start, last, results[num_threads - 1]);//剩余的部分
	for (auto& entry : threads)//等待全部子任务结束
		entry.join();
	return std::accumulate(results.begin(), results.end(), init); 
}


int main() {
	vector<int>vec;
	for (int i = 0; i < 100; i++) {
		vec.push_back(i);
	}
	long sum = 0;
	sum=parallel_accumulate(vec.begin(),vec.end(),sum);
	cout << sum << endl;//4950
	return 0;
}
```

### 线程的标识

每个线程任务由自己的ID标识

std::this\_thread::get_id()以及thread.get\__id()的使用

```cpp
#include<iostream>
#include<thread>
#include<vector>
#include<functional>
#include<numeric>
#include<Windows.h>

using namespace std;

int main() {
	thread t1([]()->void {
		cout << std::this_thread::get_id() << endl;//a
	});
	cout << t1.get_id() << endl;//a
	t1.join();
	thread t2([]()->void {
		cout << std::this_thread::get_id() << endl;//b
	});
	cout << t2.get_id() << endl;//b
	t2.join();
	cout << std::this_thread::get_id() << endl;//c

	//std::hash<std::thread::id> 容器， std::thread::id 也可以作为无序容器的键值。
	std::hash<std::thread::id> t;
	cout << t(this_thread::get_id()) << endl;

	//std::thread::id 允许赋值 比较对比等操作
	//当thread出于未关联 以及detached状态时 get_id返回值为0
	return 0;
}
```
