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

就是将一个主体内容分为多个片，也就是在协议头中定义一些总共有多少个分片，此时往后是否还有分片，此时的分片序号等字段，来标识。利用包分片其实还可以实现如文件中断重传功能

## XML与JSON格式的协议

两种常见的格式就不再详细探讨，一般的使用情况就是将XML或者JSON格式的数据作为主体部分

```cpp
struct msg{
    msgheader header;//说明包大小 主体类型
    int32_t cmd;
    int32_t seq;
    char* buf;//XML or JSON
};
```

## 理解HTTP

1、作为曾经的一个前端小子，HTTP基本的格式不再详细记录，像GET、POST、PUT、DELETE之类的不再详细记录

2、HTTP chunk编码,不用指定Content-Length,头部设置Transfer-Encoding:chunked,主体部分为

```cpp
[chunkSize][\r\n][chunkData][\r\n][chunkSize][\r\n][chunkData][\r\n][chunkSize][\r\n][chunkData][\r\n][chunkSize=0][\r\n][\r\n]
```

3、HTTP与长连接

4、libcurl常用于发送HTTP请求的第三方C/C++库

## SMTP、POP3与邮件客户端

邮件有关的协议一般有，IMAP、SMTP、POP3三种协议

1、SMTP协议

SMTP用于发送邮件，格式为

```cpp
关键字 自定义内容\r\n
```

客户端向服务器发送

```cpp
//服务端响应220
//连接邮件服务器后登录服务器之前向服务器发送的问候信息
HELO 自定义问候语\r\n
//服务端响应250
//请求登录邮件服务器
AUTH LOGIN\r\n
//服务端响应334
base64形式的用户名\r\n
//服务端响应334
base64形式的密码\r\n
//服务端响应235
//设置发件人的邮箱地址
MAIL FROM:发件人地址\r\n
//服务端响应250
//设置收件人地址，每次发送时都可以设置一个收件人地址，如果有多个收件人就要设置多次
rcpt to:收件人地址\r\n
//服务端响应250
//发送邮件正文的开始标志
DATA\r\n
//服务端响应354
//发送邮件正文，正文以.\r\n结束
邮件正文\r\n和国家答复客户看\r\n.\r\n
//服务端响应250
//退出登录
QUIT\r\n
//服务端响应221
```

SMTP服务器响应格式

```cpp
应答码 自定义消息\r\n
```

常见的应答码

```cpp
211 帮助返回系统状态
214 帮助信息
220 服务准备就绪
221 关闭连接
235 用户验证成功
250 请求操作就绪
251 用户不在本地，转寄到其他路径
334 等待用户输入验证信息
354 开始邮件输入
421 服务不可用
450 操作未执行，邮箱忙
451 操作中止，本地错误
452 操作未执行，存储空间不足
500 命令不可识别或语言错误
501 参数语法错误
502 命令不支持
503 命令顺序错误
504 命令参数不支持
550 操作未执行，邮箱不可用
551 非本地用户
552 因存储空间不足而中止
553 操作未执行，邮箱名不正确
554 传输失败
```

2、POP3协议

POP3（Post Office Protocol version 3）是一种用于接收电子邮件的标准协议。它允许电子邮件客户端从邮件服务器上下载邮件到本地计算机。下面是POP3协议的基本工作流程：

```cpp
建立与POP3服务器的连接：
telnet pop3.example.com 110
发送问候消息：
USER username
输入用户名：
PASS password
身份验证成功后，获取邮件数量和大小：
STAT
获取特定邮件的详细信息（可选）：
LIST
获取特定邮件的内容：
RETR message_number
删除特定邮件：
DELE message_number
断开与POP3服务器的连接：
QUIT
```

## WebSocket协议

1、简介

* 建立WebSocket连接：客户端通过发送特定的HTTP请求（称为WebSocket握手请求）来与服务器建立WebSocket连接。该请求包含一些特殊的HTTP头部，以指示客户端希望升级到WebSocket协议。
* 握手过程：服务器接收到WebSocket握手请求后，会进行验证和处理。如果验证通过，服务器将返回一个特定的HTTP响应（称为WebSocket握手响应），其中包含一些头部信息，表明连接已成功升级到WebSocket协议。
* WebSocket通信：一旦WebSocket连接建立，服务器和客户端就可以通过该连接进行双向通信。双方可以通过发送帧（Frames）来交换数据。这些帧可以包含文本、二进制数据或控制信息。服务器和客户端都可以在任何时候发送帧，并且可以以异步方式进行通信。
* 关闭连接：当其中一方决定关闭连接时，它可以发送一个特定的关闭帧（Close Frame）来表示关闭连接的意图。对方收到关闭帧后，也会发送关闭帧进行响应，然后双方都关闭连接。

2、Websocket协议的握手过程

请求端先发送的格式

```cpp
GET /chat HTTP/1.1\r\n
Host: example.com\r\n
Upgrade: websocket\r\n
Connection: Upgrade\r\n
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\n
Sec-WebSocket-Version: 13\r\n
\r\n
```

* Upgrade: websocket：指示服务器该请求是为了升级到WebSocket协议。
* Connection: Upgrade：指示服务器将连接升级为WebSocket协议。
* Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==：是一个Base64编码的随机字符串，用于握手过程中的安全验证。
* Sec-WebSocket-Version: 13：指定所使用的WebSocket协议版本。

以上示例是一种基本的握手请求格式，实际的WebSocket握手请求可能会包含其他头部字段，如Origin、Sec-WebSocket-Protocol等，具体字段的使用取决于实际的应用需求和服务器要求。

服务端回复的格式

```cpp
HTTP/1.1 101 Switching Protocols\r\n
Upgrade: websocket\r\n
Connection: Upgrade\r\n
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=\r\n
\r\n
```
Sec-WebSocket-Accept内容是经过Sec-WebSocket-Key进行转换后的内容,算法流程为

将Sec-WebSocket-Key的值与固定的字符串"258EAFA5-E914-47DA-95CA-C5AB0DC85B11"拼接  
然后将拼接后的字符串进行SHA-1处理，然后转为base64编码

```cpp
mask = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
accept = base64(sha1(Sec-WebSocket-Key + mask))
```

3、Websocket协议的格式

* 数据帧格式

```cpp
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-------+-+-------------+-------------------------------+
|F|R|R|R| opcode|M| Payload len |    Extended payload length    |
|I|S|S|S|  (4)  |A|     (7)     |            (16/64)            |
|N|V|V|V|       |S|             |   (if payload len==126/127)   |
| |1|2|3|       |K|             |                               |
+-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
|     Extended payload length continued, if payload len == 127  |
+ - - - - - - - - - - - - - - - +-------------------------------+
|                               |Masking-key, if MASK set to 1  |
+-------------------------------+-------------------------------+
| Masking-key (continued)       |          Payload Data         |
+-------------------------------+-------------------------------+
|           Payload Data continued...                           |
+-------------------------------+-------------------------------+
|           Payload Data continued...                           |
+-------------------------------+-------------------------------+
```

FIN：1位，指示消息是否为消息的最后一个帧。  
RSV1, RSV2, RSV3：各占1位，保留给扩展使用。  
Opcode：4位，指示帧的类型，如文本、二进制数据等。  
Mask：1位，指示Payload Data是否经过掩码处理。  
Payload length：7位或16位或64位，表示Payload Data的长度。  
Extended payload length：当Payload length的值为126或127时，使用16位或64位来表示更大范围的Payload Data长度。  
Masking-key：当Mask为1时，使用4个字节的掩码密钥进行Payload Data的解码。  
Payload Data：实际的数据载荷。  

* 控制帧格式

```cpp
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-------+-+-------------+-------------------------------+
|F|R|R|R| opcode|M| Payload len |    Extended payload length    |
|I|S|S|S|  (8)  |A|     (7)     |            (16/64)            |
|N|V|V|V|       |S|             |   (if payload len==126/127)   |
| |1|2|3|       |K|             |                               |
+-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
|     Extended payload length continued, if payload len == 127  |
+ - - - - - - - - - - - - - - - +-------------------------------+
|                               |Masking-key, if MASK set to 1  |
+-------------------------------+-------------------------------+
| Masking-key (continued)       |          Payload Data         |
+-------------------------------+-------------------------------+
```

控制帧的格式与数据帧相似，但Opcode字段的值表示控制帧类型，用于WebSocket的控制操作，如连接关闭、心跳等。

在帧的格式中，Payload Data部分可能会经过掩码处理，需要使用4个字节的掩码密钥进行解码。

```cpp
enum OpCode {
    CONTINUATION_FRAME = 0x0,
    TEXT_FRAME = 0x1,
    BINARY_FRAME = 0x2,
    CONNECTION_CLOSE_FRAME = 0x8,
    PING_FRAME = 0x9,
    PONG_FRAME = 0xA,
    // 扩展操作码
    RESERVED_3 = 0x3,
    RESERVED_4 = 0x4,
    RESERVED_5 = 0x5,
    RESERVED_6 = 0x6,
    RESERVED_7 = 0x7,
    RESERVED_B = 0xB,
    RESERVED_C = 0xC,
    RESERVED_D = 0xD,
    RESERVED_E = 0xE,
    RESERVED_F = 0xF
};
```

CONTINUATION_FRAME：用于指示消息的后续帧。  
TEXT_FRAME：用于传输文本数据。  
BINARY_FRAME：用于传输二进制数据。  
CONNECTION_CLOSE_FRAME：用于关闭连接。  
PING_FRAME：用于发起心跳检测。  
PONG_FRAME：用于对心跳检测进行响应。  
RESERVED_3 ~ RESERVED_7：WebSocket协议保留的扩展操作码。  
RESERVED_B ~ RESERVED_F：WebSocket协议保留的扩展操作码。  

4、Websocket协议的压缩格式

WebSocket协议支持对数据帧进行压缩，以减少数据传输的大小和带宽消耗。压缩是通过在数据帧的Payload Data部分应用压缩算法来实现的。以下是WebSocket协议中常见的压缩格式：

没有压缩：在没有启用压缩的情况下，Payload Data部分是原始的数据。  
Per-Message Compression Extension（PMCE）：WebSocket协议定义了Per-Message Compression Extension，允许使用压缩扩展来对整个消息进行压缩。在使用PMCE时，数据帧的Payload Data部分会经过压缩算法进行压缩，然后发送到对方。PMCE的压缩扩展由应用层协议自行定义和实现，常见的压缩扩展包括Deflate压缩算法和LZ77等。

主动发起一方的包内容

```cpp
GET /realtime HTTP/1.1\r\n
Host: 127.0.0.1:9989\r\n
Connection: Upgrade\r\n
Pragma: no-cache\r\n
Cache-Control: no-cache\r\n
User-Agent: Mozilia/5.0 (Windows NT 10.0; Win64; x64)\r\n
Upgrade: websocket\r\n
Origin: http://xyz.com\r\n
Sec-WebSocket-Version: 13\r\n
Accept-Encoding: gzip, deflate, br\r\n
Accept-Language: zh-CN,zh;q=0.0,en;q=0.8\r\n
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\n
Sec-WebSocket-Extensions: permessage-deflate; client_max_window_bits\r\n
\r\n
```

响应

```cpp
HTTP/1.1 101 Switching Protocols\r\n
Upgrade: websocket\r\n
Connection: Upgrade\r\n
Sec-WebSocket-Accept: 5wC5L6joP6t131zpj901CNv9Jy4=\r\n
Sec-WebSocket-Extensions: permessage-deflate; client_no_context_takeover\r\n
\r\n
```

5、Websocket协议装包与解包示例,省略不详细探讨了，可能实际开发中因为不会造轮子

6、解析握手协议，省略不详细探讨了，可能实际开发中因为不会造轮子
