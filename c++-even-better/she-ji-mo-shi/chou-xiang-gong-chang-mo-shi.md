---
coverY: 0
---

# 🤩 抽象工厂模式(AbstractFactory模式)

抽象工厂模式就是在工厂模式的基础上，对工厂进行抽象，有很多工厂的实现

特点：产品对象家族

```cpp
#include <iostream>
#include<string>
using namespace std;

//抽象苹果
class abstract_apple {
public:
    virtual void name() = 0;
};

class china_apple :public abstract_apple {
public:
    virtual void name() {
        cout << "apple from china" << endl;
    }
};

class usa_apple :public abstract_apple {
public:
    virtual void name() {
        cout << "apple from usa" << endl;
    }
};

class japan_apple :public abstract_apple {
public:
    virtual void name() {
        cout << "apple from japan" << endl;
    }
};


//抽象香蕉
class abstract_banana {
public:
    virtual void name() = 0;
};

class china_banana :public abstract_banana {
public:
    virtual void name() {
        cout << "banana from china" << endl;
    }
};

class usa_banana:public abstract_banana {
public:
    virtual void name() {
        cout << "banana from usa" << endl;
    }
};

class japan_banana :public abstract_banana {
public:
    virtual void name() {
        cout << "banana from japan" << endl;
    }
};

//抽象工厂
class abstract_factory {
public:
    virtual abstract_apple* get_apple()=0;
    virtual abstract_banana* get_banana()=0;
};

//中国工厂
class china_factory :public abstract_factory {
public:
    virtual abstract_apple* get_apple() {
        return new china_apple;
    }
    virtual abstract_banana* get_banana() {
        return new china_banana;
    }
};

//美国工厂
class usa_factory :public abstract_factory {
public:
    virtual abstract_apple* get_apple() {
        return new usa_apple;
    }
    virtual abstract_banana* get_banana() {
        return new usa_banana;
    }
};

//日本工厂
class japan_factory :public abstract_factory {
public:
    virtual abstract_apple* get_apple() {
        return new japan_apple;
    }
    virtual abstract_banana* get_banana() {
        return new japan_banana;
    }
};

int main(int argc, char** argv)
{
    //创建三种工厂
    abstract_factory* china = new china_factory;
    abstract_factory* usa = new usa_factory;
    abstract_factory* japan = new japan_factory;
    abstract_apple* apple_china = china->get_apple();
    apple_china->name();//apple from china
    abstract_banana* banana_usa = usa->get_banana();
    banana_usa->name();//banana from usa
    delete china;
    delete usa;
    delete japan;
    delete apple_china;
    delete banana_usa;
    return 0;
}
```
