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

