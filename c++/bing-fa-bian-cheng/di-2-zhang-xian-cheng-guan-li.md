---
coverY: 0
---

# 第2章 线程管理

## 第2章 线程管理

一个程序至少有一个正在执行的main()函数的线程，其他线程与主线程同时运行

### 创建线程的方式

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
    process.join();
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

class Hello{
    public:
    void operator()() const{
        cout << "hello world"<<endl;
    }
};

int main(int argc,char**argv){
    Hello hello;
    //thread process(hello);//正确
    //thread process(Hello()); //error 相当于声明了Hello()函数
    //thread process((Hello()));//正确
    thread process{Hello()};//正确
    process.join();
    return 0;
}
//g++ example2.cpp -o example2.exe -lpthread && ./example2.exe
```

### Lambda表达式
