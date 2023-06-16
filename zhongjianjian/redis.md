# Redis与C++

## 什么是redis

Redis（Remote Dictionary Server，远程字典服务）是一款高性能、开源、基于内存的Key-Value存储系统。Redis 不仅支持基本的字符串、列表、集合、有序集合、哈希等数据结构，还提供了事务、持久化、主从复制、订阅与发布等功能，具有极高的性能和可靠性，被广泛应用于缓存、消息队列、计数器、实时排行榜、任务队列等场景。

## 学习路径和建议

当你作为一个C++开发者学习Redis时，以下是一些学习路径和建议：

Redis基础知识：了解Redis的基本概念和数据类型，例如字符串、哈希、列表、集合和有序集合，还有Redis支持的各种命令。

Redis C++客户端：学习如何在C++中使用Redis，建议选择合适的Redis C++客户端库，例如hiredis或者redis-plus-plus。了解如何连接Redis服务器，执行命令并获取结果。

Redis持久化：学习Redis的持久化机制，了解如何将数据持久化到磁盘中。Redis支持两种持久化方式：RDB和AOF。

Redis性能优化：了解Redis的性能优化技巧，例如使用Redis的pipeline命令批量执行命令，使用Redis集群来扩展性能，以及Redis的数据结构选择和使用。

Redis高级特性：学习Redis的高级特性，例如发布/订阅模式、Lua脚本、事务、管道等。

Redis应用场景：了解Redis的常见应用场景，例如缓存、计数器、排行榜等。

Redis安全：学习如何保护Redis服务器的安全性，例如设置密码、限制网络访问、禁止危险命令等。

综上所述，学习Redis对于C++开发者来说是非常有价值的。通过学习Redis，你可以了解分布式系统的核心技术，学习高性能的数据存储和处理，以及提高系统的稳定性和安全性。

## 环境搭建

推荐使用docker

```sh
docker pull redis
# 无密码
docker run -d --name my-redis -p 6379:6379 redis
docker exec -it <container_id_or_name> /bin/bash
# 设置密码
docker run --name my-redis -p 6379:6379 -d redis --requirepass YOUR_PASSWORD
```

## redis-cli

```cpp
root@15e3b8475855:/# redis-cli -p 6379
127.0.0.1:6379> AUTH PASSWORD
```

## 配置

redis有一个redis.conf配置文件

## redis 命令

命令非常非常多，见到不知道的就去问chatgpt吧

## 键值操作

### set

`set key value` 设置给定键的值

```cpp
127.0.0.1:6379[3]> set name gaowanlu
OK
```

### get

`get key` 获取给定键的值

```cpp
127.0.0.1:6379[3]> get name
"gaowanlu"
127.0.0.1:6379[3]> get nam
(nil)
```

### keys

`keys [reg]` 查找匹配指定模式的键

```cpp
127.0.0.1:6379[3]> keys na*
1) "name"
```

### del

`del key` 删除给定键

```cpp
127.0.0.1:6379[3]> del name
(integer) 1
```

### exists

`exists key` 检查给定键是否存在

```cpp
127.0.0.1:6379[3]> exists name
(integer) 0
```

### ttl

`ttl key` 获取键的剩余过期时间

```cpp
127.0.0.1:6379[3]> ttl name
(integer) -1
```

### expire

`expire key seconds [NX|XX|GT|LT]`设置过期时间

```cpp
127.0.0.1:6379[2]> expire name 10
(integer) 1
127.0.0.1:6379[2]> ttl name
(integer) 7
127.0.0.1:6379[2]> ttl name
(integer) 6
127.0.0.1:6379[2]> ttl name
(integer) 5
127.0.0.1:6379[2]> ttl name
(integer) 0
127.0.0.1:6379[2]> ttl name
(integer) -2
127.0.0.1:6379[2]> ttl name
(integer) -2
127.0.0.1:6379[2]> keys *
(empty array)
```

## type

`type key` 查看key对应的value类型

```cpp
127.0.0.1:6379[2]> set name gaowanlu
OK
127.0.0.1:6379[2]> type name
string
```

## 库操作

### select

redis默认有16个数据库，默认使用第1个数据库,通过select切换数据库，`select index`,index从0开始 

```cpp
127.0.0.1:6379> select 3 # 选择数据库
OK
```

### dbsize

```cpp
127.0.0.1:6379[3]> dbsize #查看数据库已使用大小
(integer) 0
127.0.0.1:6379[3]> dbsize
(integer) 1
```

### flushdb

清空当前库`flushdb [ASYNC|SYNC]`

```cpp
127.0.0.1:6379[3]> flushdb
OK
127.0.0.1:6379[3]> keys *
(empty array)
```

### flushall

清空全部库 `flushall [ASYNC|SYNC]`

```cpp
127.0.0.1:6379[3]> flushall
OK
```

### move

`MOVE key db` 用于将指定键从当前数据库移动到目标数据库

```cpp
127.0.0.1:6379[3]> move name 2
(integer) 1
127.0.0.1:6379[3]> select 2
OK
127.0.0.1:6379[2]> keys *
1) "name"
```

## 数据类型操作

```bash
$hset key field value
设置哈希中给定字段的值
$hget key field
获取哈希中给定字段的值
$lpush key value1 [value2]
将一个或多个值推入列表的左侧
$lpop key
从列表的左侧弹出一个值。
$sadd key member1 [member2] 
将一个或多个成员添加到集合中
$smembers key
获取集合中的所有成员
$zadd key score1 member1 [score2 member2]
将一个或多个成员及其分数添加到有序集合中
$zrange key start stop
按索引范围获取有序集合的成员
```

## 事务操作

```bash
$multi
标记事务的开始。
$exec
执行在 MULTI 和 EXEC 之间的一系列命令。
$discard
取消事务。
$watch key [key...]
监视一个或多个键的变化。
```

## 持久化操作

```bash
$save
将数据同步保存到硬盘上的 RDB 文件。
$bgsave
在后台异步保存数据到硬盘上的 RDB 文件。
$aof
开启或关闭 AOF（Append-Only File）持久化方式。
```

## 集群管理

```bash
$cluster info 
获取集群的信息
$cluster nodes
列出集群中的节点信息。
$cluster meet ip port
将节点添加到集群中。
$cluster replicate node-id
将节点设置为另一个节点的从节点。
```

## 数据类型

Redis支持多种数据类型，每种类型都有不同的用途和操作。

五大数据类型有 string、list、set、hash、zset

### string

String 是一种基本的数据类型，它可以存储文本或二进制数据

```bash
$set
SET key value：设置指定键的值。
$get
GET key：获取指定键的值。
$del
DEL key：删除指定键。
$incr
INCR key：将键存储的数字值加 1。
$decr
DECR key：将键存储的数字值减 1。
$incrby 
INCRBY key increment：将键存储的数字值增加指定的增量。
$decrby
DECRBY key decrement：将键存储的数字值减少指定的减量。
$append
APPEND key value：在键存储的字符串值后追加指定的值。
$strlen
STRLEN key：获取键存储的字符串值的长度。
$getrange
GETRANGE key start end：获取键存储的字符串值在指定范围内的子字符串。
$setrange
SETRANGE key offset value：从指定偏移量开始替换键存储的字符串值的一部分。
$mset(muti set)
MSET key1 value1 [key2 value2 ...]：同时设置多个键值对。
$mget(multi get)
MGET key1 [key2 ...]：同时获取多个键的值。
$exists
EXISTS key：检查键是否存在。
$setex(set with expire)
SETEX key seconds value：设置指定键的值，并设置过期时间。
$psetex
PSETEX key milliseconds value：设置指定键的值，并设置过期时间（毫秒）。
$getset
GETSET key value：设置指定键的值，并返回原来的值。
$setnx(set if not exist)
SETNX key value：如果键不存在，则设置指定键的值。
```

### list

### set

### hash

### sorted set

### geospatial

### hyperloglog

### bitmap

### 事务

### 乐观锁

### 持久化RDB

### 持久化AOF

### 订阅发布

### 集群环境

### 主从复制

### 宕机后手动配置主机

### 哨兵模式

### 缓存穿透与雪崩

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
