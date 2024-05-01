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

### rename

用于重命名键。它可以将一个已存在的键重命名为一个新的键名，或者覆盖已存在的键名。

```bash
$RENAME key newkey
```

需要注意的是，如果 newkey 已经存在，那么它会被覆盖，并且原始的键名 key 将被删除。如果 newkey 和 key 是同一个键，那么命令将会失败。

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

### geoadd

```bash
$GEOADD key longitude lastitude member [longitude latitude member ...]
将一个或多个地理位置添加到指定的地理空间索引中
GEOADD mylocations 13.361389 38.115556 "Paris" 15.087269 37.502669 "Rome"
```

### geopos

```bash
$GEOPOS key member [member ...]
获取指定成员的经纬度坐标
GEOPOS mylocations "Paris" "Rome"
```

### geodist

```bash
$GEODIST key member1 member2 [unit]
计算两个成员之间的距离，默认以米为单位，也可以选择其他单位。
GEODIST mylocations "Paris" "Rome" km
```

### georadius

```bash
$GEORADIUS key longitude latitude radius unit [WITHCOORD] [WITHDIST] [WITHHASH] [COUNT count] [ASC|DESC] [STORE key] [STOREDIST key]
根据中心点和半径范围获取位于该范围内的成员列表。
GEORADIUS mylocations 13.361389 38.115556 200 km WITHDIST
```

### georadiusbymember

```bash
$GEORADIUSBYMEMBER key member radius unit [WITHCOORD] [WITHDIST] [WITHHASH] [COUNT count] [ASC|DESC] [STORE key] [STOREDIST key]
根据指定成员为中心点和半径范围获取位于该范围内的成员列表
GEORADIUSBYMEMBER mylocations "Paris" 200 km WITHCOORD
```

### geohash

```bash
$GEOHASH key member [member ...]
获取指定成员的 Geohash 值
GEOHASH mylocations "Paris"
```

### georadius_ro

```bash
$GEORADIUS_RO key longitude latitude radius unit [ASC|DESC] [WITHCOORD] [WITHDIST] [WITHHASH] [COUNT count]
在只读模式下，根据中心点和半径范围获取位于该范围内的成员列表,仅适用于 Redis Cluster。
GEORADIUS_RO mylocations 13.361389 38.115556 200 km WITHDIST
```

### georadiusbymember_ro

```bash
$GEORADIUSBYMEMBER_RO key member radius unit [ASC|DESC] [WITHCOORD] [WITHDIST] [WITHHASH] [COUNT count]
在只读模式下，根据指定成员为中心点和半径范围获取位于该范围内的成员列表,仅适用于 Redis Cluster。
GEORADIUSBYMEMBER_RO mylocations "Paris" 200 km WITHDIST
```

这些命令提供了对地理空间数据进行存储、检索和计算的功能。可以根据具体需求选择合适的命令进行操作，并结合其他 Redis 功能实现复杂的地理位置相关应用。

## hyperloglog

HyperLogLog 是 Redis 中一种基数估计数据结构，用于估计集合中不重复元素的数量。它通过使用固定的空间来估计集合的基数，而不需要存储每个元素的详细信息。

HyperLogLog 使用了一种概率算法来实现基数估计。它将每个元素映射到一个哈希函数的输出，并根据输出的位数来计算估计的基数。HyperLogLog 的主要特点是在消耗较小的内存空间下，能够提供接近精确结果的估计。

### pfadd

```bash
$PFADD key element [element ...]
将一个或多个元素添加到HyperLogLog中
```

### pfcount

```bash
$PFCOUNT key [key ...]
估计给定HyperLogLog的基数
```

### pfmerge

```bash
$PFMERGE destkey sourcekey [sourcekey ...]
将多个HyperLogLog合并为一个新的HyperLogLog
```

HyperLogLog 数据类型在一些场景中非常有用，特别是需要快速估计集合的基数而不需要存储全部元素的情况。例如，可以用于统计网站的独立访客数量、社交媒体的活跃用户数等。

需要注意的是，由于 HyperLogLog 是一种概率算法，估计的结果不是精确的，会存在一定的误差。误差率通常在 0.81%左右，但在特定情况下可能会更高。因此，对于精确基数计数要求较高的场景，可能需要考虑其他数据结构或方法。

## bitmap

Redis 中的 Bitmap（位图）是一种特殊的数据类型，用于处理位级别的操作。它是由字符串类型实现的，可以将每个位设置为 0 或 1，并且支持对位图进行逻辑和位级别的操作。

### setbit

```bash
$SETBIT key offset value
设置位图指定偏移量上的位值为value（0或1）
```

### getbit

```bash
$GETBIT key offset
获取位图指定偏移量上的位值
```

### bitop

```bash
$BITOP operation destkey key [key...]
对一个或多个位图进行逻辑操作（AND、OR、XOR、NOT），并将结果存储在目标键中
```

### bitcount

```bash
$BITCOUNT key [start end [BYTE|BIT]]
计算位图指定范围内（可选）的位值为1的数量
127.0.0.1:6379> bitcount gao 0 -1 bit
(integer) 1
```

### bitpos

```bash
$BITPOS key bit [start [end [BYTE|BIT]]]
查找位图指定范围内（可选）的第一个出现指定位值的位的偏移量
127.0.0.1:6379> bitpos gao 0 0 -1
(integer) 0
127.0.0.1:6379> bitpos gao 1 0 -1
(integer) 1
```

### 使用场景

Bitmap 类型在一些特定场景下非常有用。以下是一些应用示例：

计数器：可以使用位图来实现计数器功能，其中每个位表示一个计数值，通过设置位值为 1 或 0 来增加或减少计数。

布隆过滤器（Bloom Filter）：位图可以用于实现布隆过滤器，用于快速判断一个元素是否可能存在于一个集合中。

用户在线状态：可以使用位图来表示用户的在线状态，其中每个位表示一个时间片段，通过设置位值为 1 或 0 来表示用户在该时间片段内是否在线。

需要注意的是，Redis 的 Bitmap 类型是基于字符串实现的，因此在处理大型位图时，需要考虑存储和性能方面的限制。同时，位图的操作是基于位级别的，适用于位运算和位级别的计数，但不适用于复杂的数据处理和查询。在使用 Bitmap 类型时，需要根据具体场景和需求进行合理的使用和权衡。

## 基本的事务操作

Redis 中的事务操作是通过 MULTI、EXEC、DISCARD 和 WATCH 命令来实现的，它提供了一种将多个命令打包成一个原子操作的机制。

### 事务操作一般流程

- 使用 multi 命令开启事务块
- 将要执行的命令添加到事务队列中
- 执行 exec 命令，redis 按照事务队列中的命令顺序执行
- 根据执行结果判断事务是否成功
- 可以选择使用 discard 命令取消事务

事务操作的关键在于将多个命令打包成一个原子操作，保证了这些命令的执行在一个事务中是连续、不被其他客户端的操作干扰的。但需要注意的是，Redis 的事务并不提供隔离性，即在事务执行过程中，其他客户端仍然可以对数据库进行操作。此外，事务也不支持回滚操作，即使其中某个命令执行失败，仍会继续执行后续命令。尽管 Redis 的事务操作不支持回滚，但是你可以通过检查执行结果来确定事务执行是否成功。EXEC 命令返回一个数组，包含了每个命令的执行结果。你可以遍历这个数组，根据每个命令的返回值来判断事务执行的成功与否，并根据需要进行进一步处理。

事务操作在一些特定场景下非常有用，可以将多个命令作为一个逻辑操作进行批处理，减少与服务器的通信次数，提高性能和效率。但需要根据具体的应用场景和需求，合理使用事务操作，并考虑并发操作和异常处理等因素。

### multi

用于开启一个事务块。在执行 MULTI 命令之后，Redis 会将后续的命令都加入到事务队列中，而不是立即执行

```bash
$MULTI
127.0.0.1:6379> multi
OK
127.0.0.1:6379(TX)> setbit gao 1 0
QUEUED
127.0.0.1:6379(TX)> setbit gao 0 1
QUEUED
127.0.0.1:6379(TX)> exec
1) (integer) 1
2) (integer) 0
```

### exec

在 multi 后有两种选择，一种是 exec 一种是 discard。用于执行事务中的所有命令。当执行 EXEC 命令时，Redis 会按照命令的顺序依次执行事务队列中的命令。如果执行成功，返回事务中所有命令的执行结果；如果执行失败，返回一个错误。

```bash
$EXEC
127.0.0.1:6379> multi
OK
127.0.0.1:6379(TX)> setbit gao 1 0
QUEUED
127.0.0.1:6379(TX)> setbit gao 0 1
QUEUED
127.0.0.1:6379(TX)> exec
1) (integer) 1
2) (integer) 0
```

### discard

用于取消当前事务，清空事务队列中的所有命令。执行 DISCARD 命令后，之前加入到事务队列中的命令将被忽略。

```bash
127.0.0.1:6379> multi
OK
127.0.0.1:6379(TX)> setbit gao 1 1
QUEUED
127.0.0.1:6379(TX)> discard
OK
```

### watch

在 Redis 中，WATCH 命令用于实现乐观锁机制，它可以在事务开始之前监视一个或多个键。如果在 WATCH 执行后，被监视的键发生了修改，整个事务将被取消，从而实现了对被监视键的并发控制。

```bash
WATCH key1 key2 ... keyN
```

接下来，你可以开始执行事务操作。在事务中，如果被监视的键在 EXEC 执行之前被修改了，整个事务将被取消。

```bash
WATCH counter
GET counter
MULTI
INCR counter
EXEC
UNWATCH
```

## unwatch

Redis 中的 UNWATCH 命令用于取消对所有键的监视。

```bash
$UNWATCH
```

注意，UNWATCH 命令必须在执行 MULTI 命令之前使用，以确保取消监视的键在事务开始之前生效。

## 乐观锁

Redis 乐观锁是一种并发控制机制，它通过乐观的方式处理并发操作，而不是使用传统的悲观锁机制。乐观锁的核心思想是假设在操作期间不会发生冲突，但在操作完成时会检查是否有其他并发操作对数据进行了修改。乐观锁通常用于实现事务操作，结合 WATCH 命令和 CAS（Check-and-Set）操作来确保数据的一致性和完整性。

```bash
127.0.0.1:6379> SET counter 1
OK
127.0.0.1:6379> WATCH counter
OK
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379(TX)> incr counter
QUEUED
127.0.0.1:6379(TX)> exec
1) (integer) 2
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379(TX)> incr counter
QUEUED
127.0.0.1:6379(TX)> exec
1) (integer) 3
127.0.0.1:6379> unwatch
OK
```

## 配置文件详解

Redis 的配置文件是一个文本文件，用于配置 Redis 服务器的各种参数和选项。以下是 Redis 配置文件的一些重要参数和选项的详解：

- bind ip-address,指定 Redis 监听的 IP 地址，默认为 "127.0.0.1"，表示只监听本地回环地址。可以设置为 "0.0.0.0"，表示监听所有可用的 IP 地址。
- port port,指定 Redis 监听的端口号，默认为 6379。
- requirepass password,设置 Redis 的连接密码。默认情况下，密码为空，即无需密码进行连接。通过设置 requirepass 参数，可以启用密码验证。
- logfile file,指定 Redis 日志文件的路径和名称，默认为 "redis-server.log"。可以通过设置为空字符串来禁用日志记录。
- dir directory,指定 Redis 数据库持久化文件的存储目录，默认为当前工作目录。在持久化方式为 RDB 或 AOF 时，该目录用于存储数据文件。
- maxmemory bytes,指定 Redis 的最大内存限制。当达到该限制时，Redis 会根据所配置的内存策略（如 LRU）来删除键，以便为新键腾出空间
- appendonly yes/no,启用或禁用 AOF（Append-Only File）持久化方式。默认为 "no"，表示禁用 AOF。将其设置为 "yes" 启用 AOF。
- appendfilename file,指定 AOF 文件的名称，默认为 "appendonly.aof"。可以修改为自定义的文件名。
- save seconds changes,配置触发 RDB 持久化的条件。可以设置多个 save 规则，每个规则由保存的时间间隔（以秒为单位）和键的修改次数组成。
- maxclients count,指定 Redis 允许的最大客户端连接数。

以上仅是 Redis 配置文件的一小部分参数和选项。配置文件中还有其他更多的参数和选项，可以根据实际需求进行配置和调整。在修改配置文件后，需要重启 Redis 服务器才能使新的配置生效。

注意：修改 Redis 配置文件时，需要谨慎操作，确保配置的正确性和安全性。配置错误可能导致 Redis 服务器无法启动或存在安全风险。

## 持久化 RDB

Redis RDB（Redis DataBase）是 Redis 的一种持久化方式，用于将数据以二进制格式保存到磁盘上。RDB 持久化通过将 Redis 内存中的数据快照保存到一个 RDB 文件中，实现了数据的持久化存储和恢复。

### RDB 工作流程

- Redis 定期执行保存操作或手动执行 SAVE 或 BGSAVE 命令来触发持久化操作。
- Redis 会创建一个子进程，该子进程负责执行持久化操作。
- 子进程会遍历 Redis 的数据集，将数据以二进制格式写入到 RDB 文件中。
- 当子进程完成持久化操作后，会用新的 RDB 文件替换掉旧的 RDB 文件（如果有）。

RDB 文件是一个紧凑且经过压缩的二进制文件，其中包含了 Redis 的数据和元数据。通过将数据保存到 RDB 文件中，Redis 可以在重启时读取该文件并将数据加载到内存中，实现数据的恢复。

### RDB 优点

- 性能较高：RDB 持久化是通过生成一个数据快照来完成的，这个过程相对简单且快速。
- 文件紧凑：RDB 文件是经过压缩的二进制文件，相对较小，占用较少的磁盘空间。

### RDB 配置

在实际应用中，RDB 持久化通常与 Redis 的快照功能一起使用，可以根据实际需求来配置保存操作的触发条件和频率，以及 RDB 文件的存储位置和命名规则。

需要注意的是，RDB 持久化是全量备份，即每次持久化操作都会将所有数据保存到 RDB 文件中。因此，在某些情况下，RDB 持久化可能会造成一定的数据丢失。如果对数据的完整性和实时性要求较高，可以考虑结合 AOF（Append-Only File）持久化方式来使用。

### save

SAVE 命令：

SAVE 命令会阻塞 Redis 服务器进程，直到 RDB 文件保存完成为止。  
在执行 SAVE 命令期间，Redis 服务器将无法处理其他客户端的请求。  
SAVE 命令将数据快照保存到一个新的 RDB 文件中，如果之前已经存在 RDB 文件，则会覆盖它。  
SAVE 命令通常用于进行手动的持久化操作，由管理员在需要时手动触发。

```bash
$SAVE
```

### bgsave

BGSAVE 命令：

BGSAVE 命令会在后台异步执行 RDB 持久化操作，不会阻塞 Redis 服务器进程。  
在执行 BGSAVE 命令期间，Redis 服务器仍然可以继续处理其他客户端的请求。  
BGSAVE 命令将数据快照保存到一个新的 RDB 文件中，如果之前已经存在 RDB 文件，则会覆盖它。  
BGSAVE 命令通常用于自动定期的持久化操作，可以通过设置 save 配置项来指定触发 BGSAVE 的条件和频率。

```bash
$BGSAVE
```

### 加载 RDB 文件

当 Redis 服务器启动时，会检查配置文件中是否指定了 RDB 文件的位置。如果存在 RDB 文件，则会加载该文件，并将其中的数据恢复到内存中。RDB 文件的加载和恢复过程是自动完成的，不需要手动操作。Redis 在加载 RDB 文件时会先读取文件中的元数据信息，然后逐个读取键值对并恢复到内存中。

## 持久化 AOF

Redis 的 AOF（Append-Only File）持久化是一种将写操作追加到文件末尾的方式，用于实现数据的持久化。

### AOF 持久化方式

- Redis 的 AOF 持久化将所有的写操作以追加的方式写入一个文件（AOF 文件）中。
- 当 Redis 服务器启动时，会重新执行 AOF 文件中的写操作，将数据恢复到内存中。
- Redis 在运行过程中，每执行一条写命令，就会将该命令追加到 AOF 文件的末尾。

### AOF 持久化的配置

- 在 Redis 配置文件中，可以设置 appendonly 配置项为 yes，启用 AOF 持久化。
- 可以通过设置 appendfilename 配置项指定 AOF 文件的位置和名称。
- Redis 还提供了其他的 AOF 配置选项，如 appendfsync 控制 AOF 文件同步的方式，有 always、everysec、no 三种选项。

### AOF 文件的重写

- 为了避免 AOF 文件过大，Redis 提供了 AOF 文件的重写机制。
- AOF 重写会生成一个新的 AOF 文件，其中只包含当前数据的最小操作集，从而减小文件的大小。
- AOF 重写可以通过执行 BGREWRITEAOF 命令或达到一定条件自动触发。

### AOF 持久化的示例

- 启用 AOF 持久化：在 Redis 配置文件中设置 appendonly yes，启用 AOF 持久化。
- 执行写操作：Redis 服务器会将每个写操作追加到 AOF 文件的末尾。例如，执行以下写命令：
- 恢复数据：当 Redis 服务器启动时，会自动加载 AOF 文件，并将其中的写命令重新执行，将数据恢复到内存中。
- AOF 文件重写：当 AOF 文件过大时，可以执行 BGREWRITEAOF 命令触发 AOF 文件的重写。重写后会生成一个新的 AOF 文件，其中只包含当前数据的最小操作集。

需要注意的是，AOF 文件是一个追加方式的日志文件，它记录了所有的写操作。AOF 持久化可以确保 Redis 在重启后能够恢复到最后一次持久化的状态。AOF 文件的大小会随着写操作的增加而增大，可以通过设置合适的 AOF 重写策略和配置参数来控制文件的大小和同步频率。

总结起来，Redis 的 AOF 持久化将写操作追加到文件末尾，以保证数据的持久化。可以通过配置 Redis 的 appendonly 和 appendfilename 配置项启用和指定 AOF 文件。Redis 在启动时自动加载 AOF 文件并恢复数据，同时提供 AOF 重写机制来减小文件大小。

## 订阅发布

Redis 提供了订阅（Subscribe）和发布（Publish）功能，允许客户端通过频道（Channel）进行消息的发布和订阅。

### 发布消息 PUBLISH

使用 PUBLISH 命令向指定的频道发布消息。

```bash
PUBLISH channel message
127.0.0.1:6379> PUBLISH mychannel "Hello, subscribers!"
```

上述示例将消息 "Hello, subscribers!" 发布到名为 "mychannel" 的频道。

### 订阅频道 SUBSCRIBE

使用 SUBSCRIBE 命令订阅一个或多个频道，以接收发布到这些频道的消息。

```bash
SUBSCRIBE channel [channel ...]
127.0.0.1:6379> SUBSCRIBE mychannel
```

上述示例将客户端订阅名为 "mychannel" 的频道，客户端将收到该频道发布的消息。

### 取消订阅频道 UNSUBSCRIBE

使用 UNSUBSCRIBE 命令取消对指定频道的订阅

```bash
UNSUBSCRIBE [channel [channel ...]]
127.0.0.1:6379> UNSUBSCRIBE mychannel
```

述示例将取消对名为 "mychannel" 的频道的订阅。

### 应用场景

Redis 订阅发布的场景和示例：

实时消息传递：多个客户端可以订阅同一个频道，实现实时消息的传递。例如，在一个聊天应用中，用户可以订阅一个公共频道，以接收其他用户发送的消息。

发布/订阅模式：将消息发布到不同的频道，不同的客户端可以选择订阅感兴趣的频道。例如，在新闻网站中，不同的频道可以用于发布不同类别的新闻，用户可以选择订阅他们感兴趣的频道以获取相关新闻。

实时数据更新：在某些应用场景中，需要将实时数据更新通知给订阅者。例如，股票市场数据的实时更新，可以将更新的数据发布到对应的频道，订阅者可以接收到最新的股票行情。

总结：
Redis 订阅发布是一种灵活且高效的消息传递机制，可用于构建实时通信、消息队列、实时数据更新等场景。通过发布消息和订阅频道，可以实现即时的消息传递和数据更新。

### 是否可以作为消息队列

虽然 Redis 的订阅发布功能可以用于消息传递，但它并不是一个专门的消息队列（Message Queue）解决方案。Redis 的订阅发布机制更适合用于实时消息传递和发布/订阅模式。

在某些场景下，可以使用 Redis 的订阅发布功能作为简单的消息队列，但它并不具备一些高级的消息队列特性，如消息持久化、消息顺序保证、消息重试机制等。如果对消息队列有更高的要求，建议选择专门的消息队列中间件，如 RabbitMQ、Apache Kafka、ActiveMQ 等。

然而，Redis 的订阅发布功能在一些特定的应用场景下仍然可以发挥作用，例如实时通知、实时事件广播等。它具有快速、低延迟的特性，并且与 Redis 数据库无缝集成，易于使用和部署。

需要注意的是，在使用 Redis 的订阅发布功能作为消息队列时，需要自行处理一些常见的消息队列功能，如消息持久化、消息确认机制、消息重试、消息顺序等。这可能需要在应用层面进行一些额外的编码和处理。

综上所述，Redis 的订阅发布功能可以用于简单的消息队列场景，但对于更复杂的消息队列需求，建议选择专门的消息队列中间件。

## 主从复制

主从复制，是指将一台 Redis 服务器的数据，复制到其他的 Redis 服务器，前者称为主节点（master / leader），后者称为从节点（slave / follower）。

- 数据的复制是单向的，只能由主节点到从节点。
- Master 以写为主，Slave 以读为主。
- 一个主节点可以有多个从节点（或没有从节点），但一个从节点只能有一个主节点。
- 默认情况下，每台 Redis 服务器都是主节点。

### 作用

- 数据冗余，主从复制实现了数据的热备份，是持久化之外的一种数据冗余方式。
- 故障恢复，当主节点出现问题时，可以由从节点提供服务，实现快速的故障恢复。这也是一种服务的冗余。
- 负载均衡，在主从复制的基础上，配合读写分离，可以由主节点提供写服务，由从节点提供读服务，分担服务器负载。尤其是在写少读多的场景下，通过多个从节点分担读负载，可以大大提高 Redis 服务器的并发量。
- 高可用，主从复制是哨兵和集群能够实施的基础，因此说主从复制是 Redis 高可用的基础。
- 一般来说，要将 Redis 运用于工程项目中，只使用一台 Redis 是万万不能的，原因如下：`结构上`：单个 Redis 服务器会发生单点故障，并且一台服务器需要处理所有的请求负载，压力较大。`容量上`：单个 Redis 服务器内存容量有限，一般来说，单台 Redis 最大使用内存不应该超过 20G。

### 应用

电商网站上的商品，一般都是一次上传，无数次浏览的，说专业点也就是多读少写。可以用一个 Master 用于处理写请求，多个 slave 处理读请求

### 环境配置

1、命令模式

指定主库（只需要配置 slave 不用配 master），这种方式每次与 master 断开连接后，都需要重新连接手动配置

```bash
$slaveof masterIP masterPort
```

2、配置文件方式

修改每个 redis 的 redis.conf 配置文件

Master

```bash
daemonize yes
pidfile /var/run/redis_6379.pid
logfile "6379.log"
dbfilename dump6379.rdb
```

Slave1

```bash
daemonize yes
pidfile /var/run/redis_6380.pid
logfile "6380.log"
dbfilename dump6380.rdb
```

Slave2

```bash
daemonize yes
pidfile /var/run/redis_6381.pid
logfile "6381.log"
dbfilename dump6381.rdb
```

启动三个 redis，启动后发现都是 master 节点

```bash
127.0.0.1:6379> info replication
# Replication
role:master
connected_slaves:0
master_failover_state:no-failover
master_replid:005d45cb5386d00782595bf5626696a5cecb49b1
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:0
second_repl_offset:-1
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0
127.0.0.1:6379>
```

配置文件中有关于 REPLICATION 的配置区域,只需要配置从节点

```bash
replicaof <masterip> <masterport>
masterauth <master-password>
```

从主机是不能复赋值的，这样就实现了读写分离

### 主从断开时

主从因为某些原因，网络挂了也许主节点宕机了，主从断开后从节点仍旧是从节点，能读不能写，工作正常。当主节点恢复后，从节点会自动主从连接回复（配置文件配置的情况），保证了高可用

### 层层链路

从节点也可以被其他从节点当做主节点，可以有效减轻主机的写压力

```bash
主-->主、从-->从
```

这样 6379 赋的值只需要复制到 6380，6380 再复制到 6381，这样就有效的减轻首主机的写压力。

### 谋朝篡位

```bash
slaveof no one
```

主机断开后，从机如果想要当主机，可以使用 slaveof no one 进行“谋朝篡位”，从而变成主机。但此时其他节点还是很“忠心”，依然认定之前的主机为主机，这样变成的主机是没有从机的，是个“孤家寡人”。主机如果恢复，可以“平息叛乱”，之前的从机依旧认定它为主机。

### 改朝换代

前面的操作在实际场景中并不适用，因为我们希望的是主机断开后有从机作为主机，依旧实现主从复制。  
所以在从机“谋朝篡位”后，还需要让剩余的从机“认主”，让他们都“归顺”于新的主机。  
这样原来的主机恢复后就变成了“孤家寡人”。

## 哨兵模式

主从切换技术的操作是：当主机宕机后，需要手动把一台从机切换为主机。  
这就需要人工干预，费事费力，还会造成一段时间内服务不可用。  
这不是一种推荐的方式，更多时候，我们优先考虑哨兵模式。  
Redis 从 2.8 开始正式提供了 Sentinel（哨兵） 架构来解决这个问题。  
它是“谋朝篡位”的自动版，能够后台监控主机是否故障，如果故障了根据投票数自动将从机转换为主机。  
哨兵模式是一种特殊的模式，首先 Redis 提供了哨兵的命令，哨兵是一个独立的进程，它会独立运行。  
其原理是哨兵通过发送命令，等待 Redis 服务器响应，从而监控运行的多个 Redis 实例。

### 哨兵作用

一个哨兵可以监控多个 redis 服务器（主、从），通常有两个作用

- 通过发送命令，让 Redis 服务器返回监控其运行状态，包括主机和从机。
- 当哨兵监测到 master 宕机，会自动将 slave 切换成 master，然后通过发布订阅模式通知其他的从机，修改配置文件，让它们切换主机。

### 多哨兵模式

然而一个哨兵进程对 Redis 服务器进行监控，可能会出现问题，为此，我们可以使用多个哨兵进行监控。  
各个哨兵之间还会进行监控，这样就形成了多哨兵模式，出了监控各个 redis 服务器之外，哨兵之间也会相互监控

假设主机宕机，哨兵 1 先检测到这个结果，系统并不会马上进行 failover（故障转移） 过程，仅仅是哨兵 1 主观的认为主机不可用，这个现象称为主观下线。

当后面的哨兵也检测到主机不可用，并且数量达到一定值时，哨兵之间就会进行一次投票，投票的结果由一个哨兵发起，进行 failover 操作。

切换成功后，就会通过发布订阅模式，让各个哨兵把自己监控的从机实现切换主机，这个过程称为客观下线。

### 哨兵配置

sentinel.conf，要配置还是去网上好好查询以下，或者问一问 chatgpt

```bash
sentinel monitor myredis 127.0.0.1 6379 1
# 末尾的 1 代表选票达到多少时选举成功。
```

启动哨兵

```bash
$redis-sentinel sentinel.conf
```

主节点挂掉后，哨兵进程会监测到，然后发起选举，调用选举算法，最后选举 6380 为新的主机，6381 也认定其为主机。

之前断开的主节点恢复后，哨兵进程也会检测到，但此时并不会将其再设为主机，而是设为新的主机的从机。

### 哨兵模式优缺点

1、优点

哨兵集群模式是基于主从模式的，所有主从的优点，哨兵模式同样具有。  
主从可以切换，故障可以转移，系统可用性更好。  
哨兵模式是主从模式的升级，系统更健壮，可用性更高。

2、缺点

Redis 较难支持在线扩容，在集群容量达到上限时在线扩容会变得很复杂。  
实现哨兵模式的配置也不简单，甚至可以说有些繁琐。

## 缓存穿透与雪崩

### 使用缓存的问题

Redis 缓存的使用，极大的提升了应用程序的性能和效率，特别是数据查询方面。但同时，它也带来了一些问题。其中，最要害的问题，就是数据的一致性问题，从严格意义上讲，这个问题无解。

如果对数据的一致性要求很高，那么就不能使用缓存。另外的一些典型问题就是，缓存穿透、缓存雪崩和缓存击穿。目前，业界也都有比较流行的解决方案。

### 缓存穿透

1、概念

使用缓存通常的逻辑为，查询一个数据先到缓存中查询，如果缓存命中则返回，否则去数据库中查询，如果数据库中存在则返回数据且存到缓存，如果数据库中不存在则返回空

缓存穿透的概念，缓存穿透出现的情况就是数据库和缓存中都没有。这样缓存就不能拦截，数据库中查不到值也就不能存到缓存。这样每次这样查询都会到数据库，相当于直达了，即穿透。这样会给数据库造成很大的压力。

2、解决方案

- 布隆过滤器

布隆过滤器是一种数据结构，对所有可能查询的参数以 hash 形式存储，在控制层先进行校验，不符合则丢弃，从而避免了对底层存储系统的查询压力。

- 缓存空对象

当存储层不命中后，即使返回的空对象也将其缓存起来，同时会设置一个过期时间，之后再访问这个数据将会从缓存中获取，保护了后端数据源。
但是这种方法会存在两个问题：  
如果空值能够被缓存起来，这就意味着缓存需要更多的空间存储更多的键，因为这当中可能会有很多的空值的键。  
即使对空值设置了过期时间，还是会存在缓存层和存储层的数据会有一段时间窗口的不一致，这对于需要保持一致性的业务会有影响。

### 缓存击穿

1、概念

缓存击穿，是指一个 key 非常热点，在不停的扛着大并发，大并发集中对这一个点进行访问。  
当这个 key 在失效的瞬间，持续的大并发就穿破缓存，直接请求数据库，就像在一个屏障上凿开了一个洞。  
当某个 key 在过期的瞬间，有大量的请求并发访问，这类数据一般是热点数据。  
由于缓存过期，会同时访问数据库来查询最新数据，并且回写缓存，会导使数据库瞬间压力过大。

2、解决方案

- 设置热点数据永不过期，从缓存层面来看，没有设置过期时间，所以不会出现热点 key 过期后产生的问题。
- 加互斥锁，使用分布式锁，保证对于每个 key 同时只有一个线程去查询后端服务，其他线程没有获得分布式锁的权限，因此只能等待。

这种方式将高并发的压力转移到了分布式锁，因此对分布式锁的考验很大。

### 缓存雪崩

1、概念

缓存雪崩，是指在某一个时间段，缓存集中过期失效。  
产生雪崩的原因之一，比如马上就要到双十一零点，很快就会迎来一波抢购。  
这波商品时间比较集中的放入了缓存，假设缓存一个小时。  
那么到了凌晨一点钟的时候，这批商品的缓存就都过期了。  
而对这批商品的访问查询，都落到了数据库上，对于数据库而言，就会产生周期性的压力波峰。  
于是所有的请求都会达到存储层，存储层的调用量会暴增，造成存储层也会挂掉的情况。  
其实集中过期，倒不是非常致命。比较致命的缓存雪崩，是缓存服务器某个节点宕机或断网。因为自然形成的缓存雪崩，一定是在某个时间段集中创建缓存。这个时候，数据库也是可以顶住压力的，无非就是对数据库产生周期性的压力而已。而缓存服务节点的宕机，对数据库服务器造成的压力是不可预知的，很有可能瞬间就把数据库压垮。

2、解决方案

- 搭建集群，实现 Redis 的高可用，既然一台服务有可能挂掉，那就多增设几台服务。这样一台挂掉之后其他的还可以继续工作，其实就是搭建的集群。
- 限流降级，在缓存失效后，通过加锁或者队列来控制读数据库写缓存的线程数量。比如对某个 key 只允许一个线程查询数据和写缓存，其他线程等待。
- 数据预热，数据加热的含义就是在正式部署之前，先把可能的数据先预先访问一遍，这样部分可能大量访问的数据就会加载到缓存中。在即将发生大并发访问前手动触发加载缓存不同的 key，设置不同的过期时间，让缓存失效的时间点尽量均匀。

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
