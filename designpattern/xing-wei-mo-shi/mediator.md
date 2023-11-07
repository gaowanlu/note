---
description: 中介者模式
coverY: 0
---

# 💽 中介者模式(Mediator 模式)

中介者模式（Mediator Pattern）是一种行为型设计模式，旨在通过引入一个中介者对象，来解耦多个对象之间的交互关系。在中介者模式中，对象之间不直接相互通信，而是通过中介者进行通信。中介者模式促进了对象之间的松耦合，提高了系统的可维护性和可扩展性。

* 中介者（Mediator）：定义一个接口用于与各个同事对象进行通信，并协调各个同事对象的行为。
* 具体中介者（Concrete Mediator）：实现中介者接口，协调各个同事对象的行为。
* 同事（Colleague）：定义一个接口用于与中介者进行通信。
* 具体同事（Concrete Colleague）：实现同事接口，与其他同事对象进行通信。

![中介者模式](../../.gitbook/assets/ClassDiagram\_343434367654.png)

```cpp
#include <iostream>
#include <string>
#include <vector>

// 前向声明
class Mediator;

// 同事抽象类
class Colleague {
protected:
    Mediator* mediator;
public:
    Colleague(Mediator* mediator) : mediator(mediator) {}
    virtual void sendMessage(const std::string& message) = 0;
    virtual void receiveMessage(const std::string& message) = 0;
};

// 中介者抽象类
class Mediator {
public:
    virtual void sendMessage(const std::string& message, Colleague* colleague) = 0;
};

// 具体中介者类
class ConcreteMediator : public Mediator {
private:
    std::vector<Colleague*> colleagues;
public:
    void addColleague(Colleague* colleague) {
        colleagues.push_back(colleague);
    }
    void sendMessage(const std::string& message, Colleague* colleague) {
        for (auto c : colleagues) {
            if (c != colleague) {
                c->receiveMessage(message);
            }
        }
    }
};

// 具体同事类
class ConcreteColleague : public Colleague {
public:
    ConcreteColleague(Mediator* mediator) : Colleague(mediator) {}
    void sendMessage(const std::string& message) {
        mediator->sendMessage(message, this);
    }
    void receiveMessage(const std::string& message) {
        std::cout << "Received message: " << message << std::endl;
    }
};

int main() {
    // 创建中介者和同事对象
    ConcreteMediator mediator;
    ConcreteColleague colleague1(&mediator);//在实际场景中，具体同事类大概率是不同的具体类型，只不过是Colleague的派生类
    ConcreteColleague colleague2(&mediator);
    // 将同事对象添加到中介者中
    mediator.addColleague(&colleague1);
    mediator.addColleague(&colleague2);
    // 同事对象之间通过中介者进行通信
    colleague1.sendMessage("Hello from colleague1!");
    colleague2.sendMessage("Hi from colleague2!");
    return 0;
}
/*
Received message: Hello from colleague1!
Received message: Hi from colleague2!
*/
```
