---
coverY: 0
---

# 😛 你不知道的C++

## 小技巧&#x20;

### 当C函数与成员函数重名时 ::name() 的作用

```cpp
#include<iostream>
using namespace std;

void func(){
    cout<<"void func()"<<endl;
}

class A{
public:
    void func(){
        ::func();// void func() class C function
        //this->func(); //class member function
        //func(); //class member function
    }
};

```
