---
coverY: 0
---

# 第3章 共享数据

## 第三章 共享数据

### 互斥量std::mutex

lock\_guard为标准库提供，其在构造函数内申请mutex.lock，在析构函数内自动mutex.unlock.减轻编码工作量。

```cpp
#include<iostream>
#include<thread>
#include<list>
#include<mutex>
#include<algorithm>

using namespace std;

list<int> m_list;
mutex m_mutex;

void add_to_list(int el) {
	lock_guard<mutex>guard(m_mutex);
	m_list.push_back(el);
}

bool list_contains(int el) {
	lock_guard<mutex>guard(m_mutex);
	auto iter=find(m_list.begin(),m_list.end(),el);
	return iter != m_list.end();
}

int main() {
	thread t1([]()->void {
		for (int i = 0; i < 10; i++) {
			add_to_list(i);
		}
	});
	thread t2([]()->void {
		for (int i = 0; i < 10; i++) {
			cout << list_contains(i);
		}
	});
	t1.join();
	t2.join();
	cout << endl;
	for (const auto& item : m_list) {
		cout << item << " ";
	}
	cout << endl;
	//0111111111
	//0 1 2 3 4 5 6 7 8 9
	return 0;
}
```

### 保护共享数据

保护共享数据并没有仅仅价格lock\_guard那么简单，加锁我们只能保证此处的代码段仅有锁的线程才能执行，但是如果从外部可以直接共享数据（知道其地址或者有其引用），仍旧可以从外部访问，存在竞争问题

```cpp
#include<iostream>
#include<thread>
#include<mutex>
#include<algorithm>
#include<string>

using namespace std;

class m_data {
private:
	int a;
	string b;
public:
	m_data();
	void do_something();
	virtual ostream& operator<<(ostream& os);
};

m_data::m_data() :a(0) {

}

void m_data::do_something() {
	a++;
	b += to_string(a);
}

ostream& m_data::operator<<(ostream&os) {
	os << b;
	return os;
}

class data_wrapper {
private:
	m_data data;
	mutex m;
public:
	template<typename Callable>
	void process_data(Callable func);
};

template<typename Callable>
void data_wrapper::process_data(Callable func) {
	lock_guard<mutex> guard(m);
	func(data);
}

m_data* ptr;

void task(m_data&data) {
	ptr = &data;
}

data_wrapper wrapper;

int main() {
	wrapper.process_data(::task);
	ptr->do_something();//在没有保护的情况下对资源进行了访问
	ptr->operator<<(cout);//1
	cout << endl;
	return 0;
}

```

### 接口间的竞争

下面一个使用stack的样例

```cpp
#include<iostream>
#include<deque>
#include<stack>

using namespace std;

deque<int> m_deque;
stack<int> m_stack(m_deque);

int main() {
	if (!m_stack.empty()) {
		const int value = m_stack.top();
		m_stack.pop();
		cout << value << endl;
	}
	//这段代码在m_stack支持并发操作时会产生问题吗
	//如果在判断条件!m_stack.empty()后进入if代码块后
	//此时其他线程操作了m_stack，导致value值不再是其top元素
	//如
	/*
			A				B
		if(!s.empty)  
						if(!s.empty)
		value=s.top	
						value=s.top
		s.pop()
						s.pop()
	*/
	//这将导致不是我们原来想要的计划
	return 0;
}
```

有没有考虑过，为什么std::stack的弹出栈顶元素，需要top()然后pop()呢，而且pop()没有返回值，为什么不直接pop()返回栈顶值且将其弹出呢？这是因为接收栈顶元素时如果进行拷贝，然是内存分配失败导致异常，并没有如期拿到栈顶元素，且栈顶元素已经被弹出，那么我们将永远失去了栈顶元素。

而将其二者分开操作在一定程度上可以部分问题。

如果将某些操作封装为方法，且每个方法不能同时被进行，那么在一定程度上可以解决问题

```cpp
#include<iostream>
#include<deque>
#include<stack>
#include<vector>
#include<exception>
#include<memory>
#include<thread>
#include<mutex>

using namespace std;

class empty_stack : public std::exception {
public:
	const char* what()const;
};

const char* empty_stack::what()const{
	return "stack is empty";
}

template<typename T>
class threadsafe_stack {
private:
	stack<T>data;
	deque<T>m_deque;
	mutable mutex m_mutex;//mutable在任何情况下保持可变，即使在const函数内
public:
	threadsafe_stack();
	threadsafe_stack(const threadsafe_stack&);
	threadsafe_stack& operator=(const threadsafe_stack&) = delete;
	void push(T new_value);
	std::shared_ptr<T>pop();
	void pop(T& value);
	bool empty()const;
};

template<typename T>
threadsafe_stack<T>::threadsafe_stack():data(m_deque) {
	
}

template<typename T>
threadsafe_stack<T>::threadsafe_stack(const threadsafe_stack& other) {
	lock_guard<mutex>lock(other.m_mutex);
	data = other.data;
}

template<typename T>
void threadsafe_stack<T>::push(T new_value) {
	lock_guard<mutex>lock(m_mutex);
	data.push(new_value);
}

template<typename T>
shared_ptr<T> threadsafe_stack<T>::pop() {
	lock_guard<mutex>lock(m_mutex);
	if (data.empty()) {
		throw empty_stack();
	}
	//取出栈顶元素
	shared_ptr<T> const res(std::make_shared<T>(data.top()));
	data.pop();
	return res;
}

template<typename T>
void threadsafe_stack<T>::pop(T&value) {
	lock_guard<mutex>lock(m_mutex);
	if (data.empty()) {
		throw empty_stack();
	}
	value = data.top();
	data.pop();
}

template<typename T>
bool threadsafe_stack<T>::empty()const {
	lock_guard<mutex>lock(m_mutex);
	return data.empty();
}


int main() {
	threadsafe_stack<int> m_stack;
	thread t1([&]()->void {
		for (int i = 0; i < 100; i++) {
			m_stack.push(i);
		}
	});
	thread t2([&]()->void {
		for (int i = 0; i < 100; i++) {
			try {
				shared_ptr<int> ptr = m_stack.pop();
				cout << *ptr << endl;
			}
			catch (const empty_stack& e) {
				cout << e.what() << endl;
			}
		}
	});
	t1.join();
	t2.join();
	return 0;
}

```

但是这样也会引起其他问题，就是锁的粒度的粗与细

锁住的代码少，这个粒度叫细，执行效率高

锁住的代码多，这个粒度叫粗，执行效率低

### 死锁

死锁定义：一对线程需要对他们所有的互斥量做一些操作，其中每个 线程都有一个互斥量，且等待另一个解锁。因为他们都在等待对方释放互斥量，没有线程能工作。这种情况 就是死锁，它的问题就是由两个或两个以上的互斥量进行锁定。

简单点说就是互相等待的问题

```cpp
#include<iostream>
#include<exception>
#include<thread>
#include<mutex>
#include<algorithm>

using namespace std;

mutex m1;
mutex m2;
int data1, data2;

int main() {
	data1 = 1, data2 = 2;
	//std::lock 可以一次性锁住多个互斥量，并且没有死锁的风险，即要锁全部锁不然就全不锁
	thread t1([&]()->void {
		lock(m1,m2);
		lock_guard<mutex>lock_a(m1,std::adopt_lock);
		//std::adopt_lock 表示之前已经获取到了锁，lock_guard将来只需要unlock
		lock_guard<mutex>lock_b(m2,std::adopt_lock);
		swap(data1,data2);
		cout << data1 << " " << data2 << endl;
	});
	thread t2([&]()->void {
		lock(m1, m2);
		lock_guard<mutex>lock_a(m1, std::adopt_lock);
		lock_guard<mutex>lock_b(m2, std::adopt_lock);
		swap(data1, data2);
		cout << data1 << " " << data2 << endl;
	});
	t1.join();
	t2.join();
	return 0;
}
/*2 1
  1 2*/

```

不同的线程t1，t2对于m1,m2如果lock如果顺序是一样的那么就不会出现死锁的情况，不然例如t1获取了m1,t2先获取m2,那么就陷入死锁，t1等待获取m2,t2等待获取m1

### std::scoped\_lock<>

C++17提供了std::scoped_lock<>，其是一种新的RAII模板类型,功能相当于std::lock与lock\__guard的结合

```cpp
#include<iostream>
#include<exception>
#include<thread>
#include<mutex>
#include<algorithm>

using namespace std;

mutex m1;
mutex m2;
int data1, data2;

int main() {
	data1 = 1, data2 = 2;
	thread t1([&]()->void {
		std::scoped_lock guard(m1, m2);
		//在此使用了C++17的自动推导模板参数
		std::swap(data1, data2);
		cout << data1 << " " << data2 << endl;
		});
	thread t2([&]()->void {
		std::scoped_lock<std::mutex,std::mutex> guard(m1, m2);
		std::swap(data1, data2);
		cout << data1 << " " << data2 << endl;
		});
	t1.join();
	t2.join();
	return 0;
}
/*2 1
  1 2*/
```

### 避免死锁指南

死锁通常是使用锁方式不当造成的，多个线程相互join等待对方也会产生死锁，例如两个线程每个线程本身join等待对方完成，则二者陷入死锁状态

1、避免嵌套锁

当线程获取到一个锁时就不要去获取第二个，如果需要获取多个锁，使用std::lock(对取锁的操作上锁)，避免产生死锁

2、避免在持有锁时调用外部代码

调用外部的代码具有不确定性，可能会申请第二把锁，尽可能避免调用外部代码，仅为别的线程也可能在运行那个代码段，造成竞争状态

3、使用固定顺序获取锁

如果要获取两个及其以上锁，如果不能使用std::lock,则最好在每个线程上按照固定顺序获取锁

4、使用层次锁结构

层次锁是怎么回事呢，如果给锁规定层次等级，线程也有层次等级，线程获取锁时只能获取比自己等级低的锁，获取后将线程等级改为锁的等级，当解锁时在恢复回原来的线程层次等级

这样就会发现

```cpp
     异常拒绝
  ------------>
1               2    这样就不会造成双方等待的情况，避免了死锁
  <------------
     允许获得
```

```cpp
#include <iostream>
#include <thread>
#include <mutex>
#include <stdexcept>
#include <climits>

class hierarchical_mutex
{
    std::mutex internal_mutex;
    unsigned long const hierarchy_value;//现在所在层次
    unsigned long previous_hierarchy_value;//上一次所在层次

    //现在获取到此锁的线程所在的层次
    //thread_local关键此代表在每个线程中此static都是独立存在的
    static thread_local unsigned long this_thread_hierarchy_value;

    //检查自己的线程层次是否大于此锁的层次
    //满足大于其锁层次才能尝试获取此锁
    void check_for_hierarchy_violation()
    {
        if (this_thread_hierarchy_value <= hierarchy_value)
        {
            throw std::logic_error("mutex hierarchy violated");
        }
    }

    //当此锁被某线程获取时，需将此线程的层次改为此锁层次
    void update_hierarchy_value()
    {
        previous_hierarchy_value = this_thread_hierarchy_value;
        this_thread_hierarchy_value = hierarchy_value;
    }

public:
    explicit hierarchical_mutex(unsigned long value) :
        hierarchy_value(value),
        previous_hierarchy_value(0)
    {}

    void lock()
    {
        check_for_hierarchy_violation();
        internal_mutex.lock();
        update_hierarchy_value();
    }

    void unlock()
    {
        //使得此线程的层次恢复为原来的层次
        this_thread_hierarchy_value = previous_hierarchy_value;
        internal_mutex.unlock();
    }

    bool try_lock()
    {
        check_for_hierarchy_violation();
        if (!internal_mutex.try_lock())
            return false;
        update_hierarchy_value();
        return true;
    }
};


//将线程的层次设置为最高，代表有层次等级获取任何锁
thread_local unsigned long hierarchical_mutex::this_thread_hierarchy_value(ULONG_MAX);


hierarchical_mutex high_level_mutex(10000);
hierarchical_mutex low_level_mutex(5000);

int do_low_level_stuff()
{
    return 42;
}

int low_level_func()
{
    std::lock_guard<hierarchical_mutex> lk(low_level_mutex);
    return do_low_level_stuff();
}

void high_level_stuff(int some_param)
{}


void high_level_func()
{
    std::lock_guard<hierarchical_mutex> lk(high_level_mutex);
    high_level_stuff(low_level_func());
}

void thread_a()
{
    high_level_func();
}

hierarchical_mutex other_mutex(100);

void do_other_stuff()
{}


void other_stuff()
{
    high_level_func();
    do_other_stuff();
}

void thread_b()
{
    std::lock_guard<hierarchical_mutex> lk(other_mutex);
    //threab获取到other_mutex后层次等级成了100
    other_stuff();
    //而other_stuff内又要获取high_level_mutex与low_level_mutex
    //可见此时线程等级已经不满足层次锁获取条件
}

int main()
{
    thread a(thread_a);
    thread b(thread_b);
    a.join();
    b.join();
    //不能在执行thread_b时执行high_level_func
    //但是可以在执行high_level_func时执行thread_b获取other_mutex
    return 0;
}

```

5、超越锁的延伸

死锁不一定发生在所之间，可能还会发生在线程的同步问题中

```cpp
//嵌套锁
mutex a,b;

thread thread_b([&]()mutable->void{
    a.lock();
    b.lock();    
});

thread thread_a([&]()mutable->void{
    a.lock();
    b.lock();
    thread_b.join();    
});

如果thread_a先启动，获得了a,b锁，然后thread_b尝试获取a则thread_b则进入等待
然后thread_a一直在等待thread_b的结束，二者陷入死锁
```

### std::unique\_lock<>

std::unique\__lock与std::lock\_guard类似，但uniquelock支持延迟上锁，也就是先给它管理，然后我们等会再上锁，其次可以直接将unique\_lock传递给std::lock,而std::lock\_guard只支持std::adopt\_lock。_

```cpp
#include <iostream>
#include <mutex>
#include <algorithm>

using namespace std;

class some_big_object{
};

void swap(some_big_object& lhs, some_big_object& rhs){
}

class X{
    friend void swap(X& lhs, X& rhs);
private:
    some_big_object some_detail;
    mutable std::mutex m;
public:
    X(some_big_object const& sd) :some_detail(sd) {
    }
};

void swap(X& lhs, X& rhs)
{
    if (&lhs == &rhs)
        return;
    //unique_lock同样支持
    //std::adopt_lock与std::defer_lock 前者表示已经上锁了 后者表示推迟上锁
    //而lock_guard只支持std::adopt_lock
    std::unique_lock<std::mutex> lock_a(lhs.m, std::defer_lock);
    std::unique_lock<std::mutex> lock_b(rhs.m, std::defer_lock);
    //上锁
    std::lock(lock_a, lock_b);
    swap(lhs.some_detail, rhs.some_detail);
    //lhs.m rhs.m的解锁在unique_lock的析构函数执行
}

int main()
{
    some_big_object data1, data2;
    X x1(data1);
    X x2(data2);
    swap(x1, x2);
    return 0;
}

```

### 可移动std::unique\_lock<>

mutex不可以移动也不可以赋值，std::unque_lock支持移动，即转交对mutex的管理_

```cpp
#include <iostream>
#include <mutex>

using namespace std;

mutex m_mutex;


unique_lock<mutex> get_lock() {
    unique_lock<mutex> m_lock(m_mutex);//unique_lock构造函数
    return m_lock;//移动构造函数 然后执行lock的析构函数
    //不显式用std::move也会进行移动构造
    //当源值时右值时，才会必须要显式std::move
}


int main()
{
    {
        unique_lock<mutex> m_lock = get_lock();
        unique_lock<mutex> m_lock_ref = std::move(m_lock);
    }//m_lock_ref的析构函数执行时 释放m_mutex
    
    //当没有上面花括号时 t1无法获取到m_mutex因为m_lock析构时才会释放m_mutex

    thread t1([&]()->void {
        m_mutex.lock();
        cout << "t1" << endl;
        m_mutex.unlock();
     });//t1
    t1.join();

    return 0;
}

```

### 锁的粒度

一个细粒度锁(a fine-grained lock)能够保护较小的数据量，一个粗粒度(a coarse-grained lock)能够保护较多的数据量

有一个有趣的例子，超市有很多人正在结账，但是他忘了去一个自己想要的东西，在轮到他是就拿到了锁，但是他去那东西时没必要锁一直给他。如果一直给他，不管中间他要花费多长时间，知道他自己主动释放锁，这样就是粗粒度锁。

```cpp
//细粒度锁表现
#include <iostream>
#include <mutex>

using namespace std;

mutex m_mutex;
int data=0;

void process(int&m_data) {
    //可能process需要很长的时间
    m_data = 999;
}

int main()
{
    unique_lock<mutex> m_lock(m_mutex);
    int now_data = ::data;
    m_lock.unlock();
    process(now_data);
    m_lock.lock();
    ::data = now_data;
    cout << ::data << endl;//999
    return 0;
}
```

锁粒度太细会造成竞争

```cpp
#include <mutex>
#include <iostream>

using namespace std;

class Y
{
private:
    int some_detail;
    mutable std::mutex m;

    int get_detail() const
    {
        std::lock_guard<std::mutex> lock_a(m);
        return some_detail;
    }

public:
    Y(int sd) :some_detail(sd) {}

    void set_detail(int detail) {
        some_detail = detail;
    }

    friend bool operator==(Y const& lhs, Y const& rhs)
    {
        if (&lhs == &rhs)
            return true;
        int const lhs_value = lhs.get_detail();
        //这会处于一个问题，获取lhs_value后，其他线程可能改变lhs的some_detail
        int const rhs_value = rhs.get_detail();
        //那么这样的比较是没有意义的
        //可见锁的粒度太细
        return lhs_value == rhs_value;
    }
};

int main()
{
    Y y1(1);
    Y y2(2);
    bool res=(y1 == y2);
    cout << res << endl;//0
}

```

适当放大粒度

```cpp
#include <mutex>
#include <thread>
#include <iostream>

using namespace std;

class Y
{
private:
    int some_detail;
public:
    mutable std::mutex m;

private:
    int get_detail() const
    {
        return some_detail;
    }
public:
    Y(int sd) :some_detail(sd) {}

    void set_detail(int detail) {
        std::lock_guard<std::mutex> lock_a(m);
        some_detail = detail;
    }

    friend bool operator==(Y const& lhs, Y const& rhs)
    {
        if (&lhs == &rhs)
            return true;
        std::scoped_lock<mutex, mutex> m_lock(lhs.m,rhs.m);
        int const lhs_value = lhs.get_detail();
        //这会处于一个问题，获取lhs_value后，其他线程可能改变lhs的some_detail
        int const rhs_value = rhs.get_detail();
        //那么这样的比较是没有意义的
        //可见锁的粒度太细
        return lhs_value == rhs_value;
    }
};

int main()
{
    Y y1(12);
    Y y2(13);
    thread a([&]()->void {
        for(int i=0;i<1000;i++)
            cout <<(y1 == y2);
    });
    thread b([&]()->void {
        for (int i = 1000; i >0; i--) {
            y1.set_detail(i);
        }
    });
    thread c([&]()->void {
        for (int i = 0; i < 0; i++) {
            y2.set_detail(i);
        }
    });
    a.join(); b.join(); c.join();
    return 0;
}

```

### 保护共享数据的初始化过程

```cpp
//不考虑线程安全
int main()
{
    shared_ptr<int> resource_ptr;
    if (!resource_ptr) {
        resource_ptr.reset(new int(10));
    }
    cout << *resource_ptr << endl;//10
    return 0;
}
```

```cpp
//使用延迟初始化(线程安全)
#include <mutex>
#include <thread>
#include <iostream>
#include <memory>

using namespace std;

shared_ptr<int> resource_ptr;
mutex resource_mutex;

void fun() {
    unique_lock<mutex> lock(resource_mutex);
    if (!resource_ptr) {
        resource_ptr.reset(new int(999));
    }
    lock.unlock();
    cout << *resource_ptr << endl;
}

int main()
{
    thread a([&]()->void {
        fun();
    });
    thread b([&]()->void {
        fun();
    });
    a.join(); b.join();
    return 0;
}
```

```cpp
//双重检查锁模式
#include <mutex>
#include <thread>
#include <iostream>
#include <memory>

using namespace std;

shared_ptr<int> resource_ptr;
mutex resource_mutex;

void fun() {
    if (!resource_ptr) {
        lock_guard<mutex> lock(resource_mutex);
        if (!resource_ptr) {
            resource_ptr.reset(new int(999));
        }
    }
}

int main()
{
    thread a([&]()->void {
        fun();
    });
    thread b([&]()->void {
        fun();
    });
    a.join(); b.join();
    return 0;
}

```

### std::call\_once与std::once\_flag

一个once\_flag只能一次call_once,此操作是线程安全的,并不代表init\_resouce只能被调用一次，而是once\_flag只能被call\_once一次。_

```cpp
#include <mutex>
#include <thread>
#include <iostream>
#include <memory>

using namespace std;

shared_ptr<int> resource_ptr;
once_flag resource_flag;

void init_resouce() {
    resource_ptr.reset(new int(999));
    cout << *resource_ptr << endl;
}

void func() {
    call_once(resource_flag,init_resouce);
    //call_once与std::bind类似
}

int main()
{
    thread a([]()->void {
        func();
    });
    thread b([]()->void {
        func();
    });
    a.join(); b.join();
    //只会输出一次999
    //一个once_flag只能一次call_once,此操作是线程安全的
    return 0;
}

```

```cpp
#include <mutex>
#include <thread>
#include <iostream>
#include <memory>

using namespace std;

class X
{
private:
    int data;
    std::once_flag data_init_flag;
    void init_data()
    {
        cout << "init_data" << endl;
        data = 999;
    }
public:
    X() {}
    void a()
    {
        std::call_once(data_init_flag, &X::init_data, this);
    }
    void b()
    {
        std::call_once(data_init_flag, &X::init_data, this);
    }
};

int main()
{
    X x;
    thread a([&]()->void { x.a(); });
    thread b([&]()->void { x.b(); });
    a.join(); b.join();
    //init_data
    return 0;
}

```

### static的线程安全

```cpp
#include <mutex>
#include <thread>
#include <iostream>
#include <memory>

using namespace std;

struct MyStruct
{

};

//get是线程安全的
MyStruct& get() {
    static MyStruct instance;
    return instance;
}

int main()
{
   
    return 0;
}

```

### 保护不常更新的数据结构

这里需要另一种不同的互斥量，这种互斥量常被称为“读者-作者锁” 。因为其允许两种不同的使用方式：一个“作者”线程独占访问和共享访问，让多个“读者”线程并发访问。 C++17标准库提供了两种非常好的互斥量std::shared\_mutex、std::shared\_timed\_mutex 。 C++14只提供了std::shared\_timed\_mutex&#x20;

当有线程拥有共享锁时，尝试获取独占锁的线程会被阻塞，直到所有其他线程放弃锁。&#x20;

当任一线程拥有一个独占锁时，其他线程就无法获得共享锁或独占锁，直到第一个线程放弃其拥有的锁。

简单说shared\_locked状态还可以shared_lock，但不能独占锁，当有线程独占锁时其他线程也不能进行独占锁与shared\__lock

```cpp
#include <mutex>
#include <thread>
#include <iostream>
#include <memory>
#include <map>
#include <shared_mutex>

using namespace std;

class cache
{
    map<string,string> entries;
    shared_mutex entry_mutex;
public:
    string find_entry(string const& key)
    {
        shared_lock<shared_mutex> lk(entry_mutex);//使用共享状态
        map<string, string>::const_iterator const it = entries.find(key);
        return (it == entries.end()) ? "" : it->second;
    }
    void update_or_add_entry(std::string const& key,string const& value)
    {
        std::lock_guard<std::shared_mutex> lk(entry_mutex);//使用独占状态
        entries[key] = value;
    }
};

int main()
{
    cache c;
    c.update_or_add_entry("aaa","12345");
    cout << c.find_entry("aaa") << endl;//12345
    return 0;
}

```

### std::recursive\_mutex

std::recursive_mutex与std::mutex不同的是，std::recursive\__mutex可以进行lock多次，同理unlock也需要多次

```cpp
    mutex m;
    m.lock();
    m.lock();//错误 mutex不能二次上锁
    m.unlock();
    m.unlock();
```

```cpp
    recursive_mutex m;
    m.lock();
    m.lock();//正确

    m.unlock();
    m.unlock();
```

std::lock\__guard与std::unique\__lock可以辅助这些

```cpp
#include <mutex>
#include <thread>
#include <iostream>
#include <memory>
#include <map>

using namespace std;

int main()
{
    recursive_mutex m;
    thread a([&]()->void {
        unique_lock<recursive_mutex> lock1(m);
        cout << "a lock1" << endl;
        lock_guard<recursive_mutex> lock2(m);
        cout << "a lock2" << endl;
    });
    thread b([&]()->void {
        unique_lock<recursive_mutex> lock1(m);
        cout << "b lock1" << endl;
        lock_guard<recursive_mutex> lock2(m);
        cout << "b lock2" << endl;
    });
    a.join(); b.join();
    //当一个线程拥有了m,则在此线程可以继续lock
    //但其他线程如果想要lock则需要m处于unlock状态
    return 0;
}

```

有没有是实际点的例子呢

```cpp
#include <mutex>
#include <thread>
#include <iostream>
#include <memory>
#include <map>

using namespace std;

class A {
private:
    recursive_mutex m_mutex;
public:
    void a() {
        lock_guard<recursive_mutex> lock(m_mutex);
        cout << "a" << endl;
        b();
    }
    void b() {
        lock_guard<recursive_mutex> lock(m_mutex);
        cout << "b" << endl;
        c();
    }
    void c() {
        lock_guard<recursive_mutex> lock(m_mutex);
        cout << "c" << endl;
    }
};

int main()
{
    A a;
    thread t1([&]()->void {a.a(); });
    thread t2([&]()->void {a.a(); });
    t1.join(); t2.join();
    //有什么作用呢 也就是当某个线程访问 a b c任意方法时 其他的线程都不可访问三者
    //某个线程一旦获取到了锁 则有权利访问 三者且是任意多次访问
    //输出结果必定为 abcabc
    return 0;
}

```
