# Redis与C++

## 什么是redis

redis教程文档 https://www.tutorialspoint.com/redis/index.htm

Redis（Remote Dictionary Server，远程字典服务）是一款高性能、开源、基于内存的键值存储系统。Redis 不仅支持基本的字符串、列表、集合、有序集合、哈希等数据结构，还提供了事务、持久化、主从复制、订阅与发布等功能，具有极高的性能和可靠性，被广泛应用于缓存、消息队列、计数器、实时排行榜、任务队列等场景。

## 环境搭建

## 配置

## 数据类型

## 命令行

### redis-cli

### keys

### strings

### hashes

### lists

### sets

### sorted sets

### hyperloglog

### publish subscribe

### transacrions

### scripting

### connections

### server

## 进阶

### back up

### security

### benchmarks

### client connection

### partitioning

## 在C++中使用

在 C++ 项目中使用 Redis，您需要使用 Redis C++ 客户端库，例如 hiredis

hiredis中常用的函数

### 1、redisConnect

```cpp
redisContext* redisConnect(const char* ip, int port)
```

连接到 Redis 服务器，返回一个 redisContext 结构体指针。参数 ip 表示 Redis 服务器的 IP 地址，port 表示 Redis 服务器的端口号。

### 2、redisFree

```cpp
void redisFree(redisContext* context)
```

### 3、redisCommand

关闭 Redis 连接并释放相关资源，参数 context 表示 Redis 连接上下文。

```cpp
redisReply* redisCommand(redisContext* context, const char* format, ...)
```

执行 Redis 命令，并返回结果。参数 context 表示 Redis 连接上下文，format 是格式化字符串，表示要执行的 Redis 命令及其参数。

### 4、freeReplyObject

```cpp
void freeReplyObject(redisReply* reply)
```

释放 redisCommand 函数返回的 redisReply 结构体，参数 reply 表示 redisReply 结构体指针。

### 5、redisConnectWithTimeout

```cpp
redisContext* redisConnectWithTimeout(const char* ip, int port, const struct timeval timeout)
```

连接到 Redis 服务器，并设置连接超时时间。参数 ip 和 port 表示 Redis 服务器的 IP 地址和端口号，timeout 表示连接超时时间。

### 6、redisAppendCommand

```cpp
int redisAppendCommand(redisContext* context, const char* format, ...)
```

将 Redis 命令添加到 Redis 请求队列中，返回 0 表示成功，-1 表示失败。参数 context 表示 Redis 连接上下文，format 是格式化字符串，表示要执行的 Redis 命令及其参数。

### 7、redisGetReply

```cpp
int redisGetReply(redisContext* context, void** reply)
```

从 Redis 响应队列中获取结果，返回 0 表示成功，-1 表示失败。参数 context 表示 Redis 连接上下文，reply 是指向 redisReply 结构体指针的指针，用于存储 Redis 响应结果。

### 8、redisCommandArgv

```cpp
redisReply* redisCommandArgv(redisContext* context, int argc, const char** argv, const size_t* argvlen)
```

以参数数组的方式执行 Redis 命令，并返回结果。参数 context 表示 Redis 连接上下文，argc 表示参数数量，argv 是参数列表，argvlen 是参数列表中每个参数的长度。

### 9、redisCommandBinary

```cpp
redisReply* redisCommandBinary(redisContext* context, const char* cmd, const char* key, size_t keylen)
```

执行 Redis 命令，并返回结果。参数 context 表示 Redis 连接上下文，cmd 表示要执行的 Redis 命令，key 表示 Redis 键的名称，keylen 表示 Redis 键的长度。
