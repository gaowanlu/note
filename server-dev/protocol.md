# 网络通信协议设计

## 理解TCP

TCP是流式协议，例如A与B连接，A向B发送200字节，B可能先接收50字节也可能先接收100字节，可能200字节

## 如何解决粘包问题

TCP通信，在大多数场景下是不存在丢包和包乱序问题的，TCP是可靠的通信方式，TCP栈通过序号和包重传确认机制保证数据包有序和正确的发送到目的地

什么是粘包，就是连续向对端发送两个或以上的数据包，对端在一次读数据时数据量可能小于一个包，好几个包等  

一般有三种解决方案：

* 固定包长的数据包
* 以指定的字符（串）为包的结束标识
* 包头加包体格式

```cpp
struct msg_header{
    int32_t bodySize;
    int32_t cmd;
};
```

## 解包和处理

例如设计包头格式，而且将字节对齐改为一个字节

```cpp
//强制1字节对齐
#pragma pack(push,1)
struct msg_header
{
    int32_t  bodysize;//包体大小
};
#pragma pack(pop)
```

首先从字节流读取一个msg_header，判断bodysize大小进行限制操作等，然后再读取bodysize大小包体，再对包体进行协议解析

还可以利用压缩算法，将包体内容进行压缩

```cpp
#pragma pack(push,1)
struct msg_header{
    char compressflag;//是否压缩的标志
    int32_t originsize;//压缩前大小
    int32_t compresssize;//压缩后大小
    char reserve[16];//保留字段，用于将来的扩展
};
#pragma pack(pop)
```

## 从struct到TLV

协议的演化非常丰富多彩，例如A向B发送以下数据包

```cpp
#pragma pack(push,1)
struct userInfo{
    int32_t cmd;//命令号，根据命令号判断要执行什么业务
    char gender;//用户性别
    char name[8];//用户昵称
};
#pragma pack(pop)
```

后来有业务需要传输用户的年龄，则可以添加一个字段

```cpp
#pragma pack(push,1)
struct userInfo{
    int32_t cmd;//命令号，根据命令号判断要执行什么业务
    char gender;//用户性别
    char name[8];//用户昵称
    int32_t age;//用户年龄
};
#pragma pack(pop)
```

显然在业务变化频繁的是否这样的设计其实不是非常合理，进一步可以将包的第一个字段设计为版本号，在协议解析的时候，首先读取版本号再根据版本号决策根据那个自定义协议进行数据包的处理

```cpp
#pragma pack(push,1)
struct userInfo{
    short version;//版本号1
    int32_t cmd;
    char gender;
    char name[8];
};
#pragma pack(pop)
#pragma pack(push,1)
struct userInfo{
    short version;//版本号2
    int32_t cmd;
    char gender;
    char name[8];
    int32_t age;
};
#pragma pack(pop)
```

业务判断

```cpp
short version=?;
if(version==1){
    //当作版本1处理
}else if(version==2){
    //当作版本2处理
}else{}
```

又发现了，像name这样的字段，可能有的包数据的name字段根本用不了8字节，可以设计一种方案就是在每个字段的前面加一个表示字符串长度的length标志，对不同的类型进行编号，例如

|类型|Type值|类型描述|
|---|---|---|
|bool|0|布尔值|
|char|1|字符型|
|int16|2|16位整形|
|int32|3|32位整形|
|int64|4|64位整形|
|string|5|字符串成二进制序列|
|list|6|列表|
|map|7|map|

```cpp
                                          用几个字节表字符串长度
|type=2|  |  |type=3|  |  |  |  |type=1|  |type=1|le|ng| t| h|  |  |  |  |
short version       int32 cmd   char gender                   char name[]
```

每个字段的类型成为自解释，这种协议称为TLV(Type Length Value),protobuf就是这样的协议 https://github.com/protocolbuffers/protobuf

TLV的缺点

* 每个字段加了Type类型，占用空间增大
* 需要进行Type的判断，处理流程增加
* TLV格式只是在技术上做到的自解释并不能在业务上自解释

TLV还可以嵌套处理,也就是Type Length Data,Data部分也可以是一个Type Length Data

## 整形数值的压缩

对于int32、int64在协议中出现的频率非常频繁，一个字节有8位，如果用第一个位标识一个整形数值是否到此字节结束，为1代表后面还有为0则没有

例如

```cpp
第1字节 10111011
第2字节 11110000
第3字节 01110000
第4字节 11110111
假设压缩时低位内容存在内存地址较小的位置
第3字节     第2字节     第1字节
1 1100 0011 1000 0011 1011 十进制为1849403
```

POCO库提供了类似的功能 https://github.com/pocoproject/poco


## 设计通信协议时的注意事项

1、字节对齐，一般直接指定为1字节对齐

2、显式地指定整形字段的长度，一般使用int32_t、int64_t而不是使用int、long

3、涉及浮点数时要考虑精度问题，对于1.000000有的计算机可能得到0.999999,不同业务可能影响很大，可以考虑对浮点数值放大相应的倍数，或者变为整数或字符串传输

4、大小端问题，两端的字节序要相同，或者进行自定义规范设计

5、协议与自动升级功能，要考虑自定义协议的可升级性，不然导致客户端无法使用那将是灾难

## 包分片

## XML与JSON格式的协议

## 一个自定义协议示例

## 理解HTTP

## SMTP、POP3与邮件客户端

## WebSocket协议
