# 单个服务的基本结构

虽然使用更好的硬件往往可以带来更好的性能（如内存、CPU、磁盘、网络带宽），但是软件的逻辑设计也非常重要

## 高效网络通信框架的设计原则

1、尽量少等待

* 如何检测有新的客户端连接到来
* 如何检测客户端是否有数据发送过来

    一般采用I/O复用(I/O Multiplexing),如select、poll、epoll

* 如何接收客户端的连接请求

    使用accept函数

* 如何收取客户端发送的数据

    使用recv函数

* 如何向客户端发送数据？

    使用send函数

* 如何检测异常的客户端连接？检测到之后，如何处理？
* 如何在客户端发送完数据后关闭连接？

要避免的一些情况

* 在recv函数没有数据时，线程会阻塞在recv函数调用处
* 如果TCP窗口不是足够大，则数据无法发出，send函数也会阻塞当前调用线程
* connect函数发起连接时会有一定时长的阻塞
* 使用recv函数接收对端数据，但对端一直不发送，当前调用线程会阻塞在recv函数调用处

在服务器设计中一般将socket设置成非阻塞模式，利用I/O复用函数检测各个socket上的事件（读、写、出错等事件）

> 在发送数据用send或write函数即使返回成功，只能说明向操作系统网络协议栈里面写入数据成功，并不代表数据已经成功发送到网络，socket有个linger选项，可以设置某个socket在关闭时，剩下的数据做多可以逗留的时间，一般设置为即使调用close后，将所有未发出的数据全部发送完毕后才彻底关闭

## 被动关闭与主动关闭

* 被动关闭一般是检测到了连接异常事件，触发EPOLLERR事件、send、recv函数返回0  
* 主动关闭，主动调用close、closesocket函数

## 长连接与短连接

长连接的操作通常为

```cpp
连接->数据传输->保持连接->数据传输->保持连接->...->关闭连接
```

短连接操作通常为

```cpp
连接->数据传输->关闭连接
```

每种连接设计都有特定适合的使用场景

## 原始的服务器结构

也就是小白写的那种,每轮循环只能处理一个客户端连接请求，要处理下一个客户端连接请求，就必须等当前操作完成后才能进入下一轮循环，缺点：不支持并发，更不支持高并发

```cpp
int main(){
    //1、初始化阶段
    while(true){
        //2、利用accept函数接受连接，产生客户端fd
        //3、处理客户端fd接受数据、发送数据
        //4、资源清理
    }
    return 0;
}
```

## 一个连接对应一个线程

在accept到客户端fd后，开启一个新的线程为其做专门处理，处理完毕后开启的线程结束

```cpp
int main(){
    //1、初始化阶段
    while(true){
        //2、accept函数接受连接，产生客户端fd
        //3、开启新线程处理fd、线程分离
    }
    return 0;
}
```

这种做法支持并发但不支持高并发，当连接达到一定数量后，会创建非常多的线程，CPU在线程之间的切换是一笔不小的开销，CPU时间片许多会浪费在各个线程之间的切换上，影响程序的效率

## Reactor模式

使用Reactor模式的知名项目有很多，C/C++的libevent、Java的Netty、Python的Twisted

```cpp
输入请求1    
--------->   
输入请求2                        ------->处理程序1
--------->     I/O Demultiplexer  
输入请求3            分离事件
--------->                      ------->处理程序2
输入请求4
--------->
```

Reactor模式结构一般包含以下模块

* 资源请求事件(Resource Request)
* 多路复用器与事件分离器(I/O Demultiplexer&Event Dispatcher)
* 事件处理器(EventHandler)

开源的许多供学习使用的C++并发服务器都是Reactor模式，可以找几个看一看

## on thread one loop

也就是一个线程对应一个循环

```cpp
//线程函数
void* thread_func(void* thread_arg){
    //初始化工作
    while(线程退出标志){
        //1、利用select、poll、epoll分离读写事件
        //2、处理读事件或写事件
        //3、做其他事情
    }
    //清理工作
}
```

### 工作线程

一般使用主线程，进行accept接受新的客户端连接并生成socket，然后将socket派发给工作线程，工作线程有多个，它们负责处理新连接上的网络IO事件

```cpp
while(!m_bQuitFlag){
    epoll_or_select_func();//检测事件
    handle_io_events();//收发数据
    handle_other_things();
}
```

这种设计方案简单的理解就是，有多个子线程，主线程将accept接收到的socketfd派发给工作线程，每个工作线程维持自己的事件循环，如果工作线程中的epoll_or_select_func设置超时时间为0则一直等待，如果设置为大于0，就非得等到超时后在能在不处理handle_io_events情况下执行handle_other_thing,怎么更好的设置I/O复用函数的超时时间呢，仍旧设置一定的大于0的超时时间，但会采取特殊的唤醒策略，让工作线程的IO复用监测一个特殊的fd称为wakeup fd(唤醒fd)，当有other_things处理时，可以向wakeup fd写数据，进而IO复用即可检测到时间，可以处理other_things

唤醒机制的实现可以用管道fd、eventfd、socketpair等

### handle_other_things方法的实现逻辑

一般就是在handle_other_things中从某个数据结构中取任务，一般这个数据结构会加锁访问，然后对取出的任务进行执行处理

### 带定时器的程序

一般，在epoll_or_select_func中使用的复用函数超时时间尽量不大于check_and_handle_timers中所有定时器的最小间隔时间，以免定时器的逻辑处理延迟较大

```cpp
while(!m_bQuitFlag){
    check_and_handle_timers();//处理定时器任务
    epoll_or_select_func();
    handle_io_events();
    handle_other_things();
}
```

在循环的每一步处理中，不能有处理耗时的操作，如果有可以考虑新线程处理业务，业务处理完后将结果返回给Loop线程

## 收发数据的正确做法

### 收数据

收取数据一般就是将clientfd绑定到I/O复用函数，poll为POLLIN事件、epoll为EPOLLIN事件，要注意ET与LT模式

收完数据的标志是recv或read函数返回-1，错误码errno等于EWOULDBLOCK(EAGAIN)

### 发数据

在epoll的LT模式下，如果注册了写事件是会一直触发的。一般一开始是不注册写事件，先调用send或write函数直接发送，如果send函数或write函数返回-1，并且errno为EWOULDBLOCK(EAGAIN),将剩余要发送的数据存到自定义的发送缓冲区中，注册监听写事件，然后触发再将发送缓冲区的内容send或write，如果无数据再发送，则移除监听写事件

### IO复用读写事件总结

* 使用select、poll、epoll LT模式时，可以直接为待检测fd注册监听读事件标志
* 使用select、poll、epoll LT模式时，不要直接为待检测fd注册监听可写事件标志，应先尝试发送数据，若TCP窗口太小发送不出去，则将fd注册可写事件标志，一旦数据发送完，应该立即移除监听写事件标志
* 使用EPOLL ET模式，如果需要发送数据，则每次都需要为fd注册监听写事件标志

> 不要多个线程同时利用一个socket收（发）数据

## 发送、接收缓冲区的设计要点

一般的发送缓冲区、接收缓冲区都会设计为连续内存，设计写指针、读指针，可以动态增加、按需分配容量不够时可以扩容

```cpp
 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14
[ ][ ][ ][a][b][c][d][e][ ][ ][ ][ ][ ][ ][ ]
预留空间 |              |
        读指针          写指针
```

读数据直接从读指针向后读

写数据如果剩余空间不够，优先考虑读指针到写指针的内容向前移动，如果还不够在考虑扩容

```cpp
 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14
[a][b][c][d][e][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]
|              |
读指针          写指针
```

还不够用就扩容

```cpp
 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16
[a][b][c][d][e][f][g][h][i][j][k][l][m][n][o][p][q]
|              |
读指针          写指针
```

每个连接都有自己的缓冲区，分别有两个缓冲，而且可能还会对缓冲进行一些大小限制，限流限制等

### 服务端发送数据时对端一直不接受问题

如果在服务器连接很多时，向用户发送数据，而有大量用户不接收数据，那么服务端的相应连接的系统缓冲区很快就会满，而且会消耗较多的内存，这应该怎么处理

1、为每个连接的发送缓冲区大小设置上限，当发送数据发送不出去时，在将数据放到发送缓冲区前时，先判断缓冲区的最大剩余空间（包括允许扩容后的容量），如果小于我们要放入的数据大小，说明缓冲区中的数据大小超过了我们规定的缓冲区容量上限，就认为连接出了问题，可以关闭连接释放资源等

2、如果由于某些原因，发送缓冲区中已经存在较多被积压未发送的数据，而且有一定时间了，但是不再像发送缓冲区些内容了，那么应该用定时器解决，可以每间隔一段时间检查各路连接的发送缓冲区中是否还有未发送的数据，如果很长时间已经没有从发送缓冲区读出数据了，说明连接是存在问题的

## 网络库的分层设计

有句经典的话，“对于计算机科学领域中的任何问题，都可以通过增加一个间接的中间层来解决”

### 网络库设计中的各个层

一般有Session层、Connection层、Socket层

```cpp
Session 层       业务层
----|-------------------
Connection层
    |
Channel层        技术层
    |
Socket层
```

1、Session层

用于记录各种业务状态数据和处理各种业务逻辑，抽象如下面例子

```cpp
class ChatSession
{
public:
    int32_t m_id;        // session id
    UserInfo m_userinfo; // 用户信息
    bool logined;//是否已经登录
    std::weak_ptr<TcpConnection> m_connection;
    void send(char *source, int64_t size); // 调用connection层发送数据
    void onHeartbeatResponse(TcpConnection &connection);
    void onFindUserResponse(const std::string &data, TcpConnection &connection);
    //...其他业务操作
};
```

2、Connection层

每个客户端连接都对应一个Connection对象，一般用于记录连接的各种状态信息有，连接状态、数据收发缓冲区信息、数据流量信息、本端和对端的地址和端口号信息等，同时提供各种对网络事件的处理接口、可以被本层使用或Session层使用，每个Connection持有一个Channel对象。且掌握着Channel对象的生命周期

3、Channel层

Channel层一般持有一个Socket句柄，是实际进行数据收发的地方，一个Channel对象会记录当前需要监听的各种网络事件（读写、出错）的状态，同时对这些事件状态提供查询和增删改接口，Channel对象管理着Socket对象的生命周期，需要提供创建和关闭socket对象的接口，Channel层不是必要的，将这些搞到Socket层

4、Socket层

一般是对Socket的封装，

Session的管理一般由SessionManager或SessionFactory管理，让TcpServer来管理Connection

```cpp
class TcpServer{
public:
    //...
    void addConnection(int sockfd,const InetAddress& peerAddr);
    void removeConnection(const TcpConnection& conn);
    typedef std::map<string,TcpConnectionPtr> ConnectionMap;

private:
    int m_nextConnId;
    ConnectionMap m_connections;
};
```

### 将Session进一步分层

```cpp
        ChatSession     业务逻辑处理
            |
        CompressSession 对数据进行压缩和解压    业务层
            |
        TcpSession 对数据进行装包、解包、校验等非业务上的处理
------------|---------------------------------------------
        TcpConnection   数据收发    技术层
```

### 连接信息与EventLoop/Thread的对应关系

一个socket对应一个Channel对象、一个Connection对象对应一个Session对象，在one thread one loop中，每一路连接信息都只能属于一个Loop，一个Loop（一个线程）可以同时拥有多个连接信息

## 后端服务中的定时器设计

### 最简单的定时器

### 定时器设计的基本思路

### 定时器逻辑的性能优化

### 对时间的缓存

## 处理业务数据时是否一定要单独开线程

## 非入侵式结构与侵入式结构

### 非侵入式结构

### 侵入式结构

## 带有网络通信模块的服务器的经典结构

### 为何将listenfd设置为非阻塞模式

### 基于one thread one loop结构的经典服务器结构
