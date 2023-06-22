# Redis 与 C++

## 什么是 redis

Redis（Remote Dictionary Server，远程字典服务）是一款高性能、开源、基于内存的 Key-Value 存储系统。Redis 不仅支持基本的字符串、列表、集合、有序集合、哈希等数据结构，还提供了事务、持久化、主从复制、订阅与发布等功能，具有极高的性能和可靠性，被广泛应用于缓存、消息队列、计数器、实时排行榜、任务队列等场景。

## 学习路径和建议

当你作为一个 C++开发者学习 Redis 时，以下是一些学习路径和建议：

Redis 基础知识：了解 Redis 的基本概念和数据类型，例如字符串、哈希、列表、集合和有序集合，还有 Redis 支持的各种命令。

Redis C++客户端：学习如何在 C++中使用 Redis，建议选择合适的 Redis C++客户端库，例如 hiredis 或者 redis-plus-plus。了解如何连接 Redis 服务器，执行命令并获取结果。

Redis 持久化：学习 Redis 的持久化机制，了解如何将数据持久化到磁盘中。Redis 支持两种持久化方式：RDB 和 AOF。

Redis 性能优化：了解 Redis 的性能优化技巧，例如使用 Redis 的 pipeline 命令批量执行命令，使用 Redis 集群来扩展性能，以及 Redis 的数据结构选择和使用。

Redis 高级特性：学习 Redis 的高级特性，例如发布/订阅模式、Lua 脚本、事务、管道等。

Redis 应用场景：了解 Redis 的常见应用场景，例如缓存、计数器、排行榜等。

Redis 安全：学习如何保护 Redis 服务器的安全性，例如设置密码、限制网络访问、禁止危险命令等。

综上所述，学习 Redis 对于 C++开发者来说是非常有价值的。通过学习 Redis，你可以了解分布式系统的核心技术，学习高性能的数据存储和处理，以及提高系统的稳定性和安全性。

## 环境搭建

推荐使用 docker

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

redis 有一个 redis.conf 配置文件

## redis 命令

命令非常非常多，见到不知道的就去问 chatgpt 吧

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

`type key` 查看 key 对应的 value 类型

```cpp
127.0.0.1:6379[2]> set name gaowanlu
OK
127.0.0.1:6379[2]> type name
string
```

## 库操作

### select

redis 默认有 16 个数据库，默认使用第 1 个数据库,通过 select 切换数据库，`select index`,index 从 0 开始

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

## 数据类型

Redis 支持多种数据类型，每种类型都有不同的用途和操作。

五大数据类型有 string、list、set、hash、zset

## string

String 是一种基本的数据类型，它可以存储文本或二进制数据

### 创建空字符串

```bash
SET KEY ""
```

### set

设置指定键的值

```bash
$set
SET key value
```

### get

```bash
$get
获取指定键的值
GET key
```

### del

```bash
$del
删除指定键
DEL key
```

### incr

```bash
$incr
将键存储的数字值加 1
INCR key
```

### decr

```bash
$decr
将键存储的数字值减 1
DECR key
```

### incrby

```bash
$incrby
将键存储的数字值增加指定的增量
INCRBY key increment
```

### decrby

```bash
$decrby
将键存储的数字值减少指定的减量
DECRBY key decrement
```

### append

```bash
$append
在键存储的字符串值后追加指定的值
APPEND key value
```

### strlen

```bash
$strlen
获取键存储的字符串值的长度
STRLEN key
```

### getrange

```bash
$getrange
获取键存储的字符串值在指定范围内的子字符串
GETRANGE key start end
```

### setrange

```bash
$setrange
从指定偏移量开始替换键存储的字符串值的一部分
SETRANGE key offset value
```

### mset

```bash
$mset(muti set)
同时设置多个键值对
MSET key1 value1 [key2 value2 ...]
```

### mget

```bash
$mget(multi get)
同时获取多个键的值
MGET key1 [key2 ...]
```

### exists

```bash
$exists
检查键是否存在
EXISTS key
```

### setex

```bash
$setex(set with expire)
设置指定键的值，并设置过期时间
SETEX key seconds value
```

### psetex

```bash
$psetex
设置指定键的值，并设置过期时间（毫秒）
PSETEX key milliseconds value
```

### getset

```bash
$getset
设置指定键的值，并返回原来的值
GETSET key value
```

### setnx

```bash
$setnx(set if not exist)
如果键不存在，则设置指定键的值
SETNX key value
```

## list

Redis 中的 List（列表）是一种有序、可重复的数据结构。它可以存储一个有序的字符串列表，列表中的元素按照插入的顺序排列，可以在列表的两端进行插入和删除操作。

### 创建空列表

```bash
LPUSH mylist "" 或者
RPUSH mylist ""
```

### lset

```bash
$LSET
LSET key index element 更新列表中指定索引位置的元素的值。
```

### lpush

```bash
$LPUSH
LPUSH key element1 element2 ... 将一个或多个元素插入到列表的头部
```

### rpush

```bash
$RPUSH
RPUSH key element1 element2 ... 将一个或多个元素插入到列表的尾部。
```

### lpop

```bash
$LPOP
LPOP key 移除并返回列表的头部元素。
```

### rpop

```bash
$RPOP
RPOP key 移除并返回列表的尾部元素。
```

### lindex

```bash
$LINDEX
LINDEX key index 获取列表中指定索引位置的元素。
```

### llen

```bash
$LLEN
LLEN key 获取列表的长度（即列表中元素的个数）。
```

### lrange

```bash
$LRANGE
LRANGE key start stop 获取列表中指定范围内的元素。
```

### ltrim

```bash
$LTRIM
LTRIM key start stop 裁剪列表，只保留指定范围内的元素，其它元素将被删除。
```

### linsert

```bash
$LINSERT
LINSERT key BEFORE|AFTER pivot element 在列表中指定元素的前面或后面插入一个新元素。
```

另外，Redis 的 List 类型还支持阻塞式的操作，如 BLPOP 和 BRPOP，可以在列表为空时阻塞等待新元素的到来。
请注意，以上示例中的 key 是列表的键名，element 是要插入或操作的元素值，index 是元素的索引位置，start 和 stop 是范围的起始和结束索引位置，count 是要移除的元素数量，pivot 是要插入的位置参考元素。

## set

在 Redis 中，Set（集合）是一种无序、不重复的数据结构，用于存储多个唯一的元素。Set 中的元素是无序的，且每个元素都是唯一的。

要在 Redis 中创建一个新的空 Set（集合），可以使用以下命令之一：SADD、SREM、SPOP、SINTERSTORE、SDIFFSTORE、SUNIONSTORE 等。这些命令在执行时如果指定的 Set 不存在，会自动创建一个空 Set。

```bash
SADD myset ""
```

### sadd

```bash
$SADD
SADD key element1 element2 ... 向集合中添加一个或多个元素。
```

### srem

```bash
$SREM
SREM key element1 element2 ... 从集合中移除一个或多个元素。
```

### sismember

```bash
$SISMEMBER
SISMEMBER key element 检查元素是否存在于集合中。
```

### smembers

```bash
$SMEMBERS
SMEMBERS key 获取集合中的所有元素。
```

### scard

```bash
$SCARD
SCARD key 获取集合中元素的数量（集合的基数）。
```

### spop

```bash
$SPOP
SPOP key 随机移除并返回集合中的一个元素。
```

### srandmember

```bash
$SRANDMEMBER
SRANDMEMBER key [count] 随机获取集合中的一个或多个元素。
```

### sdiff

```bash
$SDIFF
SDIFF key1 key2 ... 返回多个集合的差集。
```

### sinter

```bash
$SINTER
SINTER key1 key2 ... 返回多个集合的交集。
```

### sunion

```bash
$SUNION
SUNION key1 key2 ... 返回多个集合的并集。
```

### sdiffstore

```bash
$SDIFFSTORE
SDIFFSTORE destination key1 key2 ... 将多个集合的差集存储到一个新的集合中。
```

### sinterstore

```bash
$SINTERSTORE
SINTERSTORE destination key1 key2 ... 将多个集合的交集存储到一个新的集合中。
```

### sunionstore

```bash
$SUNIONSTORE
SUNIONSTORE destination key1 key2 ... 将多个集合的并集存储到一个新的集合中。
```

## hash

在 Redis 中，Hash（哈希）是一种用于存储键值对的数据结构。Redis 的 Hash 类型类似于关联数组或字典，它可以将一个字段（field）与一个值（value）相关联，从而形成一个键值对。

要在 Redis 中创建一个新的空 Hash，可以使用以下命令之一：HSET、HMSET。

```bash
HSET myhash "" 或
HMSET myhash "" ""
```

### hset

```bash
$HSET
HSET key field value 设置Hash中指定字段的值。
```

### hget

```bash
$HGET
HGET key field 获取Hash中指定字段的值。
```

### hmset

```bash
$HMSET
HMSET key field1 value1 field2 value2 ... 同时设置Hash中多个字段的值。
```

### hmget

```bash
$HMGET
HMGET key field1 field2 ... 同时获取Hash中多个字段的值。
```

### hdel

```bash
$HDEL
HDEL key field1 field2 ... 删除Hash中一个或多个字段。
```

### hexists

```bash
$HEXISTS
HEXISTS key field 检查Hash中是否存在指定字段。
```

### hkeys

```bash
$HKEYS
HKEYS key 获取Hash中所有字段的列表。
```

### hvals

```bash
$HVALS
HVALS key 获取Hash中所有值的列表。
```

### hlen

```bash
$HLEN
HLEN key 获取Hash中字段的数量。
```

### hincrby

```bash
$HINCRBY
HINCRBY key field increment 将Hash中指定字段的值增加一个整数。
```

## sorted set

Redis 中的 Sorted Set（有序集合）是一种数据结构，它是由一组唯一的成员（元素）组成的集合，每个成员都与一个分数相关联。Sorted Set 中的成员是按照分数的大小进行排序的，因此它是一个有序的集合。

常用命令

### zadd

```bash
$ZADD
ZADD key score member [score member ...]
向Sorted Set中添加一个或多个成员，每个成员都与一个分数相关联。
```

### zrem

```bash
$ZREM
ZREM key member [member ...]
从Sorted Set中移除一个或多个成员。
```

### zcard

```bash
$ZCARD
ZCARD key
获取Sorted Set中成员的数量。
```

### zscore

```bash
$ZSCORE
ZSCORE key member
获取指定成员的分数。
```

### zincrby

```bash
$ZINCRBY
ZINCRBY key increment member
增加或减少指定成员的分数。
```

### zrangebyscore

```bash
$ZRANGEBYSCORE
ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count]
按照指定的分数范围获取成员列表。
可以指定正无穷、负无穷
$ZRANGEBYSCORE salary -inf +inf
```

### zrange

```bash
$ZRANGE
ZRANGE key start stop [WITHSCORES]
按照成员的排名范围获取成员列表。
```

### zrank

```bash
$ZRANK
ZRANK key member
获取指定成员在Sorted Set中的排名。
```

### zrevrange

```bash
$ZREVRANGE
ZREVRANGE key start stop [WITHSCORES]
按照成员的排名范围获取成员列表，按照分数从大到小的顺序。
```

### zrevran

```bash
$ZREVRAN
ZREVRANK key member
获取指定成员在Sorted Set中的逆序排名。
```

这些命令只是 Sorted Set 操作的一小部分，还有其他命令可用于交集、并集、差集等操作。可以查阅 Redis 官方文档或使用 Redis 命令行客户端获取更多详细信息。

## geospatial

Redis 的 Geospatial 类型是指在 Redis 中处理地理空间数据的功能。它基于经纬度坐标系统，允许存储和操作具有地理位置信息的数据。

```bash
$GEOADD
```

## hyperloglog

## bitmap

## 乐观锁

## 持久化 RDB

## 持久化 AOF

## 订阅发布

## 集群环境

## 主从复制

## 宕机后手动配置主机

## 哨兵模式

## 缓存穿透与雪崩

## 在 C++中使用

在 C++ 项目中使用 Redis，您需要使用 Redis C++ 客户端库，例如 hiredis

hiredis 中常用的函数

### redisConnect

```cpp
redisContext* redisConnect(const char* ip, int port)
```

连接到 Redis 服务器，返回一个 redisContext 结构体指针。参数 ip 表示 Redis 服务器的 IP 地址，port 表示 Redis 服务器的端口号。

### redisFree

```cpp
void redisFree(redisContext* context)
```

### redisCommand

关闭 Redis 连接并释放相关资源，参数 context 表示 Redis 连接上下文。

```cpp
redisReply* redisCommand(redisContext* context, const char* format, ...)
```

执行 Redis 命令，并返回结果。参数 context 表示 Redis 连接上下文，format 是格式化字符串，表示要执行的 Redis 命令及其参数。

### freeReplyObject

```cpp
void freeReplyObject(redisReply* reply)
```

释放 redisCommand 函数返回的 redisReply 结构体，参数 reply 表示 redisReply 结构体指针。

### redisConnectWithTimeout

```cpp
redisContext* redisConnectWithTimeout(const char* ip, int port, const struct timeval timeout)
```

连接到 Redis 服务器，并设置连接超时时间。参数 ip 和 port 表示 Redis 服务器的 IP 地址和端口号，timeout 表示连接超时时间。

### redisAppendCommand

```cpp
int redisAppendCommand(redisContext* context, const char* format, ...)
```

将 Redis 命令添加到 Redis 请求队列中，返回 0 表示成功，-1 表示失败。参数 context 表示 Redis 连接上下文，format 是格式化字符串，表示要执行的 Redis 命令及其参数。

### redisGetReply

```cpp
int redisGetReply(redisContext* context, void** reply)
```

从 Redis 响应队列中获取结果，返回 0 表示成功，-1 表示失败。参数 context 表示 Redis 连接上下文，reply 是指向 redisReply 结构体指针的指针，用于存储 Redis 响应结果。

### redisCommandArgv

```cpp
redisReply* redisCommandArgv(redisContext* context, int argc, const char** argv, const size_t* argvlen)
```

以参数数组的方式执行 Redis 命令，并返回结果。参数 context 表示 Redis 连接上下文，argc 表示参数数量，argv 是参数列表，argvlen 是参数列表中每个参数的长度。

### redisCommandBinary

```cpp
redisReply* redisCommandBinary(redisContext* context, const char* cmd, const char* key, size_t keylen)
```

执行 Redis 命令，并返回结果。参数 context 表示 Redis 连接上下文，cmd 表示要执行的 Redis 命令，key 表示 Redis 键的名称，keylen 表示 Redis 键的长度。
