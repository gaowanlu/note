---
description: 备忘录模式
coverY: 0
---

# 🥰 备忘录模式(Memento 模式)

备忘录模式（Memento Pattern）是一种行为型设计模式，它允许在不破坏封装性的前提下捕获一个对象的内部状态，并在该对象之外保存这个状态，以便日后可以将对象恢复到原先保存的状态。

![备忘录模式](../../.gitbook/assets/ClassDiagram\_83948394839.png)

```cpp
#include <iostream>
#include <string>
#include <vector>

using namespace std;

//备忘录类，用于保存对象的状态
class Memento {
public:
    Memento(const string& state) :state_(state) {

    }
    string GetState()const {
        return state_;
    }
private:
    string state_;
};

//需要保存状态的对象
class Originator {
public:
    void SetState(const string& state) {
        state_ = state;
    }
    string GetState()const {
        return state_;
    }
    //创建备忘录，保存当前状态
    Memento CreateMemento()const {
        return Memento(state_);
    }
    //恢复状态
    void RestoreMemento(const Memento& memento) {
        state_ = memento.GetState();
    }
private:
    string state_;
};

//Memeto Mgr
class Caretaker {
public:
    void AddMemento(const Memento& memento) {
        mementos_.push_back(memento);
    }
    Memento GetMemento(int index)const {
        return mementos_[index];
    }
private:
    vector<Memento>mementos_;
};

int main()
{
    Originator originator;
    Caretaker caretaker;
    originator.SetState("State 1");
    cout << originator.GetState() << endl;//State 1
    caretaker.AddMemento(originator.CreateMemento());
    originator.SetState("State 2");
    caretaker.AddMemento(originator.CreateMemento());
    originator.SetState("State 3");
    caretaker.AddMemento(originator.CreateMemento());
    cout << originator.GetState() << endl;//State 3
    //rollback
    originator.RestoreMemento(caretaker.GetMemento(0));
    cout << originator.GetState() << endl;//State 1
    return 0;
}
```

这证明了备忘录模式的有效性，通过备忘录模式，我们可以在不破坏对象封装性的前提下保存和恢复对象的内部状态。
