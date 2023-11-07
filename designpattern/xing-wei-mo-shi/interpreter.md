---
description: 解释器模式
coverY: 0
---

# 🦄 解释器模式(Interpreter 模式)

解释器模式是一种行为型设计模式，它用于解释和评估语言的语法或表达式。该模式定义了一种表示语言文法的类结构，并提供了一种解释器来解释语法中的表达式。

在解释器模式中，通常有两种类型的角色：

1. 抽象表达式（Abstract Expression）：定义了解释器的接口，所有具体表达式都必须实现这个接口。
2. 具体表达式（Concrete Expression）：实现了抽象表达式接口，并提供了具体的解释逻辑。

解释器模式通过递归的方式解释表达式，将表达式转换为一系列的操作或动作。这些操作可以是简单的操作，也可以是复杂的操作，具体取决于语言的语法规则。

总结一下，解释器模式适用于需要解释和评估语言语法或表达式的场景。它可以灵活地定义语法规则，并提供了一种解释器来解释和执行这些规则。

![解释器模式](../../.gitbook/assets/ClassDiagram1\_839rh39h549.png)

```cpp
#include <iostream>
#include <string>

using namespace std;

class Context
{
public:
	Context(int num):m_num(num),m_res(0)
	{
	}
public:
	void SetNum(int num)
	{
		m_num = num;
	}
	int GetNum()
	{
		return m_num;
	}
	void SetRes(int res)
	{
		m_res = res;
	}
	int GetRes()
	{
		return m_res;
	}
private:
	int m_num;
	int m_res;
};

//表达式抽象
class Expression
{
public:
	virtual void Interpreter(Context& context) = 0;
};

//具体表达式
class PlusExpression :public Expression
{
public:
	virtual void Interpreter(Context& context)
	{
		int num = context.GetNum();
		num++;
		context.SetNum(num);
		context.SetRes(num);
	}
};

class MinusExpression :public Expression
{
public:
	virtual void Interpreter(Context& context)
	{
		int num = context.GetNum();
		num--;
		context.SetNum(num);
		context.SetRes(num);
	}
};

int main(int argc, char** argv)
{
	Context context(10);
	PlusExpression plusExpression;
	MinusExpression minusExpression;
	Expression& express1 = plusExpression;
	Expression& express2 = minusExpression;
	express1.Interpreter(context);
	cout << context.GetNum() << endl;//11
	express2.Interpreter(context);
	cout << context.GetNum() << endl;//10
	return 0;
}
```
