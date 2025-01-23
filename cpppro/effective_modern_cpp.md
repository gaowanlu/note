# Effective Modern C++

Effective Modern C++

https://github.com/CnTransGroup/EffectiveModernCppChinese/

https://cntransgroup.github.io/EffectiveModernCppChinese/

## 一、类型推导

### 1.理解模板类型推导

### 2.理解auto类型推导

### 3.理解decltype

### 4.学会查看类型推导结果

## 二、auto

### 5.优先考虑auto而非显式类型声明

### 6.auto推导若非已愿，使用显式类型初始化惯用法

## 三、移步现代C++

### 7.区别使用()和{}创建对象

### 8.优先考虑nullptr而非0和NULL

### 9.优先考虑别名声明而非typedefs

### 10.优先考虑限域枚举而非未限域枚举

### 11.优先考虑使用deleted函数而非使用未定义的私有声明

### 12.使用override声明重写函数

### 13.优先考虑const_iterator而非iterator

### 14.如果函数不抛出异常请使用noexcept

### 15.尽可能的使用constexpr

### 16.让const成员函数线程安全

### 17.理解特殊成员函数函数的生成

## 四、智能指针

### 18.对于独占资源使用std::unique_ptr

### 19.对于共享资源使用std::shared_ptr

### 20.当std::shared_ptr可能悬空时使用std::weak_ptr

### 21.优先考虑使用std::make_unique和std::make_shared而非new

### 22.当使用Pimpl惯用法，请在实现文件中定义特殊成员函数

## 五、右值引用，移动语义，完美转发

### 23.理解std::move和std::forward

### 24.区别通用引用和右值引用

### 25.对于右值引用使用std::move,对于通用引用使用std::forward

### 26.避免重载通用引用

### 27.熟悉重载通用引用的替代品

### 28.理解引用折叠

### 29.认识移动操作的缺点

### 30.熟悉完美转发失败的情况

## 六、Lambda表达式

### 31.避免使用默认捕获模式

### 32.使用初始化捕获来移动对象到闭包中

### 33.对于std::forward的auto&&形参使用decltype

### 34.优先考虑lambda表达式而非std::bind

## 七、并发API

### 35.优先考虑基于任务的编程而非基于线程的编程

### 36.如果有异步的必要请指定std::lauch::async

### 37.从各个方面使得std::threads unjoinable

### 38.关注不同线程句柄析构行为

### 39.考虑对于单次事件通信使用void

### 40.对于并发使用std::atomic,volatile用于特殊内存区

## 八、微调

### 41.对于哪些可移动总是被拷贝的形参使用传值方式

### 42.考虑就地创建而非插入
