# 消息队列

## 简介

* RABBITMQ
* KAFKA
* ACTIVEMQ
* ROCKETMQ
* PULSAR

## RabbitMQ

先学习RabbitMQ，比较经典。

### 安装RabbitMQ

直接上Docker好了

```bash
docker pull dockerpull.com/rabbitmq:latest
docker pull dockerpull.com/rabbitmq:4.0-management
docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 dockerpull.com/rabbitmq:4.0-management
```

不出意外就会启动成功，前者rabbitmq是正宗rabbitmq服务后面的management的端口15672是管理端web网页。

### 看RabbitMQ文档

看官方文档最靠谱

https://www.rabbitmq.com/docs/

### 用什么语言使用

待办
