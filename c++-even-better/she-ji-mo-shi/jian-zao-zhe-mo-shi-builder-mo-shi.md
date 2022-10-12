---
coverY: 0
---

# 🥳 建造者模式(Builder模式)

特点：如何创建一个组合的对象

```cpp
#include<iostream>
#include<vector>
#include<string>
using namespace std;

class Product {
public:
	vector<string>vec;
	ostream& operator<<(ostream& os) {
		for (const auto& item : vec) {
			os << item << " ";
		}
		return os;
	}
};

class Builder {
public:
	virtual ~Builder() {}
	virtual Builder* processA() = 0;
	virtual Builder* processB() = 0;
	virtual Builder* processC() = 0;
};

class MyBuilder:public Builder{
public:
	~MyBuilder() {
		delete ptr;
	}
	MyBuilder():ptr(nullptr) {
		reset();
	}
	void reset() {
		ptr = new Product;
	}
	Builder* processA() override {
		ptr->vec.push_back("process A");
		return this;
	}
	Builder* processB() override {
		ptr->vec.push_back("process B");
		return this;
	}
	Builder* processC() override {
		ptr->vec.push_back("process C");
		return this;
	}
	Product* get() {
		Product* ptrTemp = ptr;
		reset();//创建新的对象实例
		return ptrTemp;//将装配好的实例返回
	}
private:
	Product* ptr;
};

class Director {
private:
	Builder* mBuilder;
public:
	void setBuilder(Builder* builder) {
		mBuilder = builder;
	}
	void buildMinimalProduct() {
		mBuilder->processA();
	}
	void buildFullFeatureProduct() {
		mBuilder->processA()->processB()->processC();
	}
};

int main() {
	Director* director = new Director;
	MyBuilder* mBuilder = new MyBuilder;
	director->setBuilder(mBuilder);

	director->buildFullFeatureProduct();
	//内部调用builder提供的一系列接口
	Product* p1=mBuilder->get();
	p1->operator<<(cout);//process A process B process C
	cout << endl;
	delete p1;

	director->buildMinimalProduct();
	Product* p2 = mBuilder->get();
	p2->operator<<(cout);//process A
	cout << endl;
	delete p2;

	delete director;
	delete mBuilder;
	return 0;
}
```
