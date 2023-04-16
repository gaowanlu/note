---
coverY: 0
---

# 第 18 章 网络 IPC 套接字

## 网络 IPC 套接字

Linux系统编程中，网络套接字（socket）是一个重要的概念。套接字是一种在网络上进行通信的工具，通过套接字可以建立客户端和服务器之间的连接，并进行数据的传输。

在Linux系统中，网络套接字是一种特殊的文件描述符，可以通过调用系统函数来创建、连接、发送和接收数据。常用的套接字类型包括TCP套接字和UDP套接字，它们分别用于建立可靠的连接和不可靠的连接。

在编程中，需要使用套接字相关的系统函数来进行网络通信。常用的系统函数包括socket()、bind()、listen()、accept()、connect()、send()和recv()等。其中，socket()函数用于创建套接字，bind()函数用于将套接字与一个地址绑定，listen()函数用于监听连接请求，accept()函数用于接受连接，connect()函数用于建立连接，send()函数用于发送数据，recv()函数用于接收数据。

网络套接字在Linux系统编程中是一个非常重要的概念，它是实现网络通信的基础。了解套接字的概念和相关系统函数的使用方法，可以帮助开发人员编写高效、可靠的网络应用程序。

### 大小端字节序

大小端字节序是指在多字节数据类型（如int、long、float等）的存储过程中，字节的存储顺序不同。  

在大端字节序中，高位字节存放在低地址，低位字节存放在高地址；  
而在小端字节序中，低位字节存放在低地址，高位字节存放在高地址。

```cpp
        2            3
大端： 0000 0010   0000 0011
小端： 0100 0000   1100 0000
    低地址--------->高地址
```

在Linux系统编程中，处理器架构可能是大端字节序或小端字节序，因此需要特别注意在网络通信中字节序的处理。

重点：IO和网络IO时永远是低地址的内容先出去

#### 字节序转换函数

网络通信中通常使用大端字节序（也称为网络字节序）作为标准字节序。为了保证跨平台通信的正确性，需要将本地字节序（即处理器架构字节序）与网络字节序进行转换。可以使用htonl()、htons()、ntohl()和ntohs()等系统函数来完成字节序的转换。

```cpp
//本地字节序转网络字节序
#include <arpa/inet.h>
uint32_t htonl(uint32_t hostlong);
uint16_t htons(uint16_t hostshort);
//网络字节序转本地字节序
uint32_t ntohl(uint32_t netlong);
uint16_t ntohs(uint16_t netshort);
```

### 字节对齐

请见C++内容中的字节对齐，在网络编程中一般会采取不对齐处理

[字节对齐跳转](/c++-even-better/yu-yan-ji-chu/c++-primer-ting-shuo-hen-nan/di-si-bu-fen-gao-ji-zhu-ti/di-19-zhang-te-shu-gong-ju-yu-ji-shu#nei-cun-zi-jie-dui-qi)

### 类型长度问题

在C中int、char等，并没有规定一定的长度大小，可能不同环境下会有不同，为了解决此问题，一般会采取以下固定长度整数类型进行使用

```cpp
#include <stdint.h>
//int8_t: 8 位有符号整数，定义在 stdint.h 或 cstdint 头文件中
//uint8_t: 8 位无符号整数，定义在 stdint.h 或 cstdint 头文件中
//int16_t: 16 位有符号整数，定义在 stdint.h 或 cstdint 头文件中
//uint16_t: 16 位无符号整数，定义在 stdint.h 或 cstdint 头文件中
//int32_t: 32 位有符号整数，定义在 stdint.h 或 cstdint 头文件中
//uint32_t: 32 位无符号整数，定义在 stdint.h 或 cstdint 头文件中
//int64_t: 64 位有符号整数，定义在 stdint.h 或 cstdint 头文件中
//uint64_t: 64 位无符号整数，定义在 stdint.h 或 cstdint 头文件中
```

### 套接字描述符

### 寻址

### 建立连接

### 数据传输

### 套接字选项

### 带外数据

### 非阻塞和异步 IO
