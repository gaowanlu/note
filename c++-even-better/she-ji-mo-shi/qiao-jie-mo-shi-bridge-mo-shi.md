---
description: 结构型模式
coverY: 0
---

# 🤩 桥接模式(Bridge模式)

```cpp
#include<iostream>
using namespace std;

class Implementor;

class Interface {
public:
	virtual void run() = 0;
	Interface():impl(nullptr) {}
	Interface(Implementor*impl):impl(impl) {

	}
	virtual ~Interface() {
		delete impl;
	}
protected:
	Implementor* impl;
};

class Implementor{
public:
	virtual void call() = 0;
	virtual ~Implementor() = default;
};

class ReinterfaceCab:public Interface {
public:
	ReinterfaceCab(Implementor*impl):Interface(impl){}
	void run() override {
		//通常这里会做更多操作，如业务的参数逻辑判断等等
		cout << "Cab" << endl;
		impl->call();
	}
};

class ReinterfaceUber :public Interface {
public:
	ReinterfaceUber(Implementor* impl) :Interface(impl) {
	}
	void run() override {
		cout << "Uber" << endl;
		impl->call();
	}
};

class ImplementA :public Implementor {
public:
	void call() override{
		cout << "ImplementA" << endl;
	}
};

class ImplementB :public Implementor {
public:
	void call() override{
		cout << "ImplementB" << endl;
	}
};

int main() {
	Interface* api1 = new ReinterfaceCab(new ImplementA);
	api1->run();//Cab ImplementA

	Interface* api2 = new ReinterfaceUber(new ImplementB);
	api2->run();//Cab ImplementB
	
	delete api1;
	delete api2;
	//这里可以这样理解，我们是一个网约车程序
	//Interface是叫车抽象，run方法为叫车操作
	//ReinterfaceCab是叫普通出租车
	//然后用impl->call()，真正的去叫出租车
	//ReinterfaceUber是叫Uber
	//然后impl->call(),真正的去叫出租车
	//当叫不同的车有不同的业务逻辑，则在不同的Reinterface的run内进行就好了
	return 0;
}

```
