---
coverY: 0
---

# 🚜 前言

## 读薄《C++ Primer》

使用C++ Primer 第5版 进行一次酣畅淋漓的C++学习

我曾接触过许多编程语言最后我下定决心系统地重新认识C++，在这个浮躁的时代还是应该静下心来把自己的内功练好,它不像前端一样加包加包一堆webapi，不想java一样用这个jar那个jar一堆东西来应对业务，学习C++是适合静下心来打磨自己的一个过程。

### 文档适用

早就开始看C++ Primer中途放弃了很多次的学习的人，回想一下为什么就中断了呢。其实心没有静下来，没有循序渐进，其实坚持下来并不是意见很难的事情，每天只需要读大章节中的一个小章节就好了，大概为10页左右，整本书为777页左右，只要每天坚持大概两个月就可读完像砖头一样的C++ Primer. 如果对C++的认知相对于C语言停留在只是有了类这么一说，C++支持面向对象编程，从第二部分开始就会一步一步打破自己认知，还要耐心坚持阅读，切勿浮躁否则你将会再次弃坑，要知道C++不像java或者javascript甚至python它们有大量的包，几天就会出现一个火热的框架或者库，学起来是无穷无尽的，C++在各领域的框架或者库相对比较成熟稳定，而且更新迭代也没那么夸张，最重要的还是学好C++本身然后自己坚持学习操作系统、计算机网络、数据结构与算法、计算机组成原理、数据库等知识、然后打造自己的应用都不是问题，例如图像处理库OpenCV、机器学习库Tensorflow、图形渲染OpenGL等等它们都是支持C++的。

### C++基础 目录

#### 前言

* [x] 第1章 开始

#### 第一部分 C++基础

* [x] 第2章 变量和基本类型
* [x] 第3章 字符串、向量和数组
* [x] 第4章 表达式
* [ ] 第5章 语句
* [ ] 第6章 函数
* [ ] 第7章 类

#### 第二部分 标准库

* [ ] 第8章 IO库
* [ ] 第9章 顺序容器
* [ ] 第10章 泛型算法
* [ ] 第11章 关联容器
* [ ] 第12章 动态内存

#### 第三部分 类设计者的工具

* [ ] 第13章 拷贝控制
* [ ] 第14章 操作重载与类型转换
* [ ] 第15章 面向对象程序设计
* [ ] 第16章 模板和泛型编程

#### 第四部分 高级主题

* [ ] 第17章 标准库特殊设施
* [ ] 第18章 用于大型程序的工具
* [ ] 第19章 特殊工具与技术

#### 第五部分 术语

* [ ] 标准库名字和头文件
* [ ] 算法概览
* [ ] 随机数

#### 第六部分

* [ ] C++11的新特性

### C++终极路线

*   计算机体系架构基础

    图灵机、冯诺依曼体系架构、计算机总线、整数、符号数、无符号数、整数运算、浮点数、ASCII、GB2312/GBK、Unicode/UTF-8、x86与CISC、arm与RISC
*   Linux基础

    权限管理、文件、用户、磁盘、网络、进程、shell脚本
*   C语言基础

    宏、数据类型、数据运算、数组、输入输出、分支与循环、指针、结构体、联合体、枚举、函数、sizeof、文件操作
*   计算机网络

    局域网技术、集线器、交换机、路由器、OSI七层模型、TCP/IP四层模型、IP协议、TCP/UDP、DNS、HTTP、ISN、TCP SYN攻击、SYN Cookie、半链接队列、HTTP2、HTTP3、HTTPS、httpDNS、DNSSEC、tcpdump、wireshark、Fidler、Charles
*   C++基础

    继承、封装、多态、重载、友元、static、const、虚函数、指针、引用、RAII、vector 、set、 map 、list、 stack 、queue
* 数据结构与算法
*   数据库基础

    关系型数据库、NoSQL、常用数据库、数据库、数据表、索引、SQL
*   操作系统

    进程、线程、进程地址空间布局、内存虚拟化、内核态与用户态、系统调用、中断异常等等
*   C++进阶

    异常处理、泛型编程、内存对象模型、RTTI、多态实现原理、static\_cast、const\_cast、dynamic\_cast、reinterpret\_cast、右值引用、自动类型推导、unordered\_map、thread、lambda、for each、智能指针
*   线程堆栈

    内存对齐、线程栈布局、函数调用过程、栈溢出攻击、堆内存分配算法、new与delete原理、delete\[]原理
*   调试技术

    GDB、软件调试原理、反汇编
*   网络编程

    流式套接字、数据报套接字、原始套接字、IO模型 select、poll、epoll
*   多进程与多线程编程

    fork机制、C++11 thread、pthread、线程同步、原子操作、无锁编程、mutex、条件变量、event、线程局部存储TLS
*   进程间的通信

    Signal、信号量、命名管道、匿名管道、共享内存
*   RPC与序列化技术

    gRPC与Protobuf、Thrift、RapidJSON、AVRO
* 编译原理
* [设计模式](https://design-patterns.readthedocs.io/zh\_CN/latest/)
*   [网络安全](https://www.bilibili.com/video/BV1Lf4y1t7Mc)

    缓冲区溢出、释放后使用、空指针攻击、悬空指针与野指针、信息摘要：MD5 SHA1 SHA256 、对称加密：AES、DES、RC4、数字签名
*   [计算机底层技术](https://www.bilibili.com/video/BV1qF411E7ei)

    CPU:寄存器、特权级、缓存技术、缓存一致性原理、分支预测、乱序执行、中断与异常、内存管理、多核技术、线程亲和性、NUMA架构、超线程技术、文件系统原理：VFS、EXT、XFS 、IO：PIO、DMA、零拷贝技术
* [MYSQL](https://www.bilibili.com/video/BV1Xb41177na)
* Redis 数据结构；缓存基础：缓存穿透、缓存击穿、缓存雪崩、缓存过期淘汰；持久化：RDB、AOF ；高可用：哨兵、选举机制；集群
*   第三方软件

    [nginx](https://www.bilibili.com/video/BV1F5411J7vK)\
    [docker](https://www.bilibili.com/video/BV1og4y1q7M4)\
    [elasticsearch](https://www.bilibili.com/video/BV17a4y1x7zq)\
    [RabbitMQ](https://www.bilibili.com/video/BV1dX4y1V73G)\
    [KafKa](https://www.bilibili.com/video/BV1Xy4y1G7zA)([https://github.com/alanxz/rabbitmq-c](https://github.com/alanxz/rabbitmq-c))\
    [redis](https://www.bilibili.com/video/BV1S54y1R7SB)

### 学习建议

C++基础知识、POSIX编程接口、选择业务方向如音视频处理|机器学习|计算机视觉|工业软件|嵌入式等等。

一定要刷算法刷算法、多看书、多学习数据结构，设计模式、数据结构与算法、操作系统、计算机组成原理、计算机网络这是永远永远不会褪色的科学知识，这是程序员的内功、当然还有数学知识决定我们的上限。在面对招聘岗位时 web前端、java后端、还有兴起的golang，因为互联网的火热这些岗位竞争力极大，但在想在国内的工业软件、基础软件可谓是了了无几。

在机器人以及工业软件、汽车行业，它们的基础架构肯定是C++、结合Python等来进行混合开发，往往这些行业工作门槛都是很高的，它们也更加可靠、而不是一味的写CURD.

没有绝对好的语言、各个语言都在自己的领域发光发热。
