# rabbitMQ

## 简介

较好的文档 https://www.tutorialspoint.com/rabbitmq/index.htm

RabbitMQ是一款开源的消息队列中间件，它实现了高级消息队列协议（AMQP），可以在分布式应用程序中安全地传递消息、数据和事件。

RabbitMQ主要由以下几个组件组成：

1、Broker：消息队列服务器，负责接收、存储和转发消息。  
2、Exchange：消息交换机，负责将消息路由到正确的队列或者其他交换机中。  
3、Queue：消息队列，存储等待被消费的消息。  
4、Binding：绑定，规定了 Exchange 如何将消息路由到队列中。  
5、Connection：生产者或者消费者与 Broker 之间的网络连接。  
6、Channel：消息通道，表示客户端与 Broker 之间的一条独立的双向数据流，所有的 AMQP 操作都是在Channel 中完成的。

## 架构

## 环境配置

## 特性

## 安装

## Producer

## Consumer

## RabbitMQ C API

常用的函数

```cpp
amqp_channel_close：关闭通道
amqp_channel_close_ok：通道关闭成功
amqp_channel_flow：开启或关闭通道流控
amqp_channel_flow_ok：确认通道流控状态
amqp_channel_open：打开通道
amqp_channel_open_ok：通道打开成功
amqp_connection_close：关闭连接
amqp_connection_close_ok：连接关闭成功
amqp_connection_open：打开连接
amqp_connection_open_ok：连接打开成功
amqp_bytes_compare：比较两个 amqp_bytes_t 类型的字节序列
amqp_bytes_free：释放 amqp_bytes_t 类型的字节序列
amqp_bytes_malloc：为 amqp_bytes_t 类型的字节序列分配内存
amqp_bytes_strdup：将 amqp_bytes_t 类型的字节序列复制到新的内存块中
amqp_basic_ack：确认接收到的消息
amqp_basic_cancel：取消消费者标签
amqp_basic_cancel_ok：消费者取消成功
amqp_basic_consume：创建消费者
amqp_basic_consume_ok：消费者创建成功
amqp_basic_deliver：投递消息
amqp_basic_get：获取消息
amqp_basic_get_empty：获取消息为空
amqp_basic_get_ok：获取消息成功
amqp_basic_nack：否定确认接收到的消息
amqp_basic_publish：发布消息
amqp_basic_qos：设置消费者的服务质量参数
amqp_basic_qos_ok：消费者服务质量参数设置成功
amqp_basic_reject：拒绝接收到的消息
amqp_bytes_t：表示字节序列的结构体
amqp_channel_close_t：通道关闭信息的结构体
amqp_channel_flow_t：通道流控信息的结构体
amqp_channel_open_t：打开通道的信息的结构体
amqp_connection_close_t：连接关闭信息的结构体
amqp_connection_open_t：打开连接的信息的结构体
amqp_connection_state_t：连接状态的结构体
amqp_envelope_t：存储投递消息的结构体
amqp_frame_t：存储 AMQP 帧的结构体
amqp_method_number_t：AMQP 方法编号的枚举类型
amqp_rpc_reply_t：存储 RPC 响应的结构体
amqp_socket_close：关闭套接字
amqp_socket_error：获取套接字错误信息
amqp_socket_open：打开套接字
amqp_socket_t：套接字类型的结构体
amqp_table_entry_t：表示 AMQP 表中的一项的结构体
amqp_table_t：表示 AMQP 表的结构体
```
