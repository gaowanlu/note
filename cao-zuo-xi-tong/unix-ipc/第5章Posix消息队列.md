---
coverY: 0
---

# 第5章 Posix消息队列

## Posix消息队列

### 未完待续

1、概述与管道和FIFO不同，消息队列有随内核的持续性  
2、消息队列是一个由链表实现的优先队列，队列中的每个消息由优先级、数据长度、数据本身三部分组成，PosixMQ的优先级为无符号整数、System VMQ优先级为长整数类型  
3、mq_open创建或者打开消息队列  
4、mq_close犹如关闭一个打开的文件一样，关闭消息队列，但消息队列本身任然存在，只是调用关闭后不能再用标识符操作消息队列  
5、mq_unlink即删除消息队列，mq本身有存在当前打开着描述符的引用计数器，队列的析构要到最后一个mq_close发生时才能进行  
6、mqcreatel程序demo 使用mq_open创建消息队列  
7、mqunlink程序demo使用mq_unlink删除一个消息队列  
8、每个消息队列有四个属性，使用mq_getattr获取所有属性，mq_setattr设置单个属性，四个属性

```cpp
struct mq_attr{
    long mq_flags;//是否阻塞标识 0:O_NONBLOCK
    long mq_maxmsg;//队列允许最大消息长度
    long mq_msgsize;//每个消息允许最大的大小
    long mq_curmsgs;//此时消息队列拥有的消息数量
}
```

9、mq_setattr只能设置mq_flags，mq_maxmsg和mq_msgsize只能在创建消息队列时指定，而mq_curmsgs不可手动更改  
10、mqgetattr程序使用mq_close程序获取其mq_attr  
11、mqcreate程序使用mq_open在创建消息队列时提供mq_attr初始化mq_msgsize与mq_msg_maxmsg  
12、介绍了计息argc,agv的方法  
13、mq的初始化大小与文件系统的占用大小相关，一般MQ相关文件大于mq_msgsize*mq_maxmsg,因为还有其他内容要存储  
14、mq_send用于发数据、mq_receive用户取出优先级最高入队列最早的消息,mq_receive提供的读取buffer长度大小不能小于mq_msgsize,否则直接返回EMSGSIZE错误  
15、mq_send指定优先级prio参数，必须小于MQ_PRIO_MAX,mq_receive指定prio参数为0则代表不使用优先级，mq_receive若成功则返回消息中的字节数否则返回-1，mq_send发送成功返回0否则返回-1  
16、给出了mqsend，使用mq_send的demo程序  
17、mqreceive程序中，展示了设置非阻塞receive的选项，使用mq_receive如果是非阻塞时，但队列中没有消息则返回一个错误  
18、消息队列限制：mq_attr结构体中的限制之外还有两个宏，MQ_OPEN_MAX一个进程能够同时拥有的打开着消息队列的最大数目，MQ_PRIO_MAX任意消息的最大优先级+1  ，二者都定义在`<unisyd.h>`头文件中 ,可以使用sysconfig函数查看  
