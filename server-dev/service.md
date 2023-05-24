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

直接上代码吧，定时器一般分为timer、timer_manager,timer为定时器任务，timer_manager用于对timer的管理检查与执行

### timer

```cpp
//timer.h
#pragma once
#include <functional>
#include <mutex>
#include <cstdint>
#include <ctime>

/*
*PLAN: 待提高时间精度
*/

namespace tubekit
{
    namespace timer
    {
        using timer_callback = std::function<void()>;
        class timer
        {
        public:
            timer(int32_t repeated_times, int64_t interval, timer_callback callback);
            timer(const timer &) = delete;
            virtual ~timer();
            virtual void run();
            bool is_expired() const;
            int64_t get_id() const;
            int32_t get_repeated_times() const;

        public:
            static int64_t generate_id();

        private:
            int64_t m_id;              // timer id
            time_t m_expired_time;     // 到期时间
            int32_t m_repeated_times;  // 重复次数
            timer_callback m_callback; // 回调函数
            int64_t m_interval;        // 时间间隔

        private:
            static int64_t s_initial_id;
            static std::mutex s_mutex; // 保护 s_initial_id 线程安全
        };
    }
}
//timer.cpp
#include "timer/timer.h"

using namespace tubekit::timer;

int64_t timer::s_initial_id = 0;
std::mutex timer::s_mutex;

timer::timer(int32_t repeated_times, int64_t interval, timer_callback callback)
    : m_repeated_times(repeated_times), m_interval(interval), m_callback(callback)
{
    // 当前时间加上一个间隔时间,为下次到期时间
    m_expired_time = (int64_t)time(nullptr) + interval; // seconds
    m_id = generate_id();
}

timer::~timer()
{
}

int64_t timer::get_id() const
{
    return m_id;
}

int32_t timer::get_repeated_times() const
{
    return m_repeated_times;
}

void timer::run()
{
    if (m_repeated_times == -1 || m_repeated_times >= 1)
    {
        m_callback();
    }
    if (m_repeated_times >= 1)
    {
        --m_repeated_times;
    }
    m_expired_time += m_interval;
}

bool timer::is_expired() const
{
    int64_t now = time(nullptr);
    return now >= m_expired_time;
}

int64_t timer::generate_id()
{
    int64_t new_id;
    s_mutex.lock();
    ++s_initial_id;
    new_id = s_initial_id;
    s_mutex.unlock();
    return new_id;
}
```

### timer_manager

```cpp
//timer_manager.h
#pragma once
#include <list>
#include <mutex>
#include "timer/timer.h"

/*
* PLAN: 需要后续优化，使用优先队列解决，待提高时间精度
*/

namespace tubekit
{
    namespace timer
    {
        class timer_manager final
        {
        public:
            timer_manager();
            ~timer_manager();
            /**
             * @brief 添加新的定时器
             *
             * @param repeated_times 重复次数，为-1则一直重复下去
             * @param interval 触发间隔
             * @param callback 回调函数
             * @return int64_t 返回新创建的定时器id
             */
            int64_t add(int32_t repeated_times, int64_t interval, const timer_callback callback);

            /**
             * @brief 删除定时器
             *
             * @param timer_id 定时器ID
             * @return true
             * @return false
             */
            bool remove(int64_t timer_id);

            /**
             * @brief 检测定时器，到期则触发执行
             *
             */
            void check_and_handle();

        private:
            std::list<timer *> m_list;
            std::mutex m_mutex;
        };
    }
}
//timer_manager.cpp
#include "timer/timer_manager.h"

using namespace tubekit::timer;

timer_manager::timer_manager()
{
}

timer_manager::~timer_manager()
{
    std::lock_guard<std::mutex> lock(m_mutex);
    for (auto iter = m_list.begin(); iter != m_list.end(); ++iter)
    {
        timer *timer_ptr = (*iter);
        delete timer_ptr;
    }
    m_list.clear();
}

int64_t timer_manager::add(int32_t repeated_times, int64_t interval, const timer_callback callback)
{
    std::lock_guard<std::mutex> lock(m_mutex);
    timer *timer_ptr = new timer(repeated_times, interval, callback);
    if (timer_ptr == nullptr)
    {
        return -1;
    }
    m_list.push_back(timer_ptr);
    return timer_ptr->get_id();
}

bool timer_manager::remove(int64_t timer_id)
{
    std::lock_guard<std::mutex> lock(m_mutex);
    if (timer_id < 0)
    {
        return false;
    }
    for (auto iter = m_list.begin(); iter != m_list.end(); ++iter)
    {
        if ((*iter)->get_id() == timer_id)
        {
            timer *timer_ptr = (*iter);
            delete timer_ptr;
            m_list.erase(iter);
            return true;
        }
    }
    return false;
}

void timer_manager::check_and_handle()
{
    std::lock_guard<std::mutex> lock(m_mutex);
    for (auto iter = m_list.begin(); iter != m_list.end();)
    {
        if ((*iter)->is_expired())
        {
            (*iter)->run();
            int32_t times = (*iter)->get_repeated_times();
            if (times == 0)
            {
                timer *timer_ptr = *iter;
                iter = m_list.erase(iter);
                delete timer_ptr;
            }
        }
        else
        {
            ++iter;
        }
    }
}
```

### 使用样例

```cpp
#include <iostream>
#include <thread>
#include <memory>
#include <unistd.h>

#include "timer/timer.h"
#include "timer/timer_manager.h"

using namespace std;
using namespace tubekit::timer;

int main(int argc, char **argv)
{
    auto m_manager = make_shared<timer_manager>();
    m_manager->add(-1, 1, []() -> void
                   { cout << "-1 1" << endl; });
    m_manager->add(3, 3, []() -> void
                   { cout << "3 3" << endl; });
    int loop_timer_id = m_manager->add(1, 5, []() -> void
                                       { cout << "1 5" << endl; });
    thread m_thread([&]() -> void
                    {
                        while(1){
                            sleep(1);//can use select epoll nanosleep etc...
                            m_manager->check_and_handle();
                        } });
    m_thread.detach();
    // m_manager->remove(loop_timer_id);
    sleep(20);
    return 0;
}
// g++ timer.test.cpp ../src/timer/timer.cpp ../src/timer/timer_manager.cpp -o timer.test.exe -I"../src/" -lpthread
```

### 定时器逻辑的性能优化

1、定时器对象集合的数据结构优化一

如果使用std::list存储timer的话，可以定义排序函数，每次添加timer时将list排序处理，则检查timer与执行时，就不需要顺序遍历全部timer了，遍历到不到期的即可停止，但是list不能高效解决从中查找目标timer删除的问题，可以使用std::map,并对std::map进行排序

std::map基于红黑树，std::map会根据键的值进行自动排序，std::unordered_map是一个基于哈希表的关联容器，它提供了一种将键值对关联起来的方式，并且不对键进行排序

std::multimap的底层实现通常使用红黑树，std::unordered_multimap使用哈希函数将键映射到桶(bucket)中，并使用链表或其他数据结构来解决哈希冲突

2、定时器对象集合的数据结构优化二

还有两种常见的为，时间轮和时间堆

时间轮，有一个环形队列，每个位置之间为一个时间间隔interval,那么队列每个位置可以将相同时间的timer拉成链表，在系统检查时，先检查此时时间在那个位置，则之前的位置都是到期的，将多个链表的timer元素进行处理

时间堆，使用小根堆，即每次取出都是时间最小的timer，可以使用stl中的std::priority_queue,std::priority_queue默认是大根堆（max heap

```cpp
#include <queue>
#include <iostream>

int main() {
    std::priority_queue<int> pq;

    // 插入元素
    pq.push(30);
    pq.push(10);
    pq.push(50);
    pq.push(20);

    // 访问并弹出顶部元素
    std::cout << "Top element: " << pq.top() << std::endl;
    pq.pop();

    // 迭代元素（无序）
    std::cout << "Elements in priority queue: ";
    while (!pq.empty()) {
        std::cout << pq.top() << " ";
        pq.pop();
    }
    std::cout << std::endl;

    return 0;
}
//Top element: 50
//Elements in priority queue: 30 20 10
```

小根堆

```cpp
#include <queue>
#include <iostream>
int main() {
    std::priority_queue<int, std::vector<int>, std::greater<int>> pq;
    // 插入元素
    pq.push(30);
    pq.push(10);
    pq.push(50);
    pq.push(20);
    // 访问并弹出顶部元素
    std::cout << "Top element: " << pq.top() << std::endl;
    pq.pop();
    // 迭代元素（无序）
    std::cout << "Elements in priority queue: ";
    while (!pq.empty()) {
        std::cout << pq.top() << " ";
        pq.pop();
    }
    std::cout << std::endl;
    return 0;
}
//Top element: 10
//Elements in priority queue: 20 30 50
```

### 对时间的缓存

对于定时器功能，会频繁地使用获取操作系统时间的函数，使用则会调用系统调用，在系统与进程间进行上向下文切换，消耗资源，one thread one loop结构可能花费更多时间

```cpp
while(!mQuitFlag)
{
    get_time_and_cache();//获取时间并缓存
    do_something_quickly_with_system_timer();//利用上一步获取的系统时间进行些耗时短的操作
    use_cached_time_to_check_and_handler_timers();//定时器使用缓存的时间，下面的函数也是
    epoll_or_select_func();
    handle_io_events();
    handle_other_thing();
}
```

## 处理业务数据时是否一定要单独开线程

前面知道一个loop的结构大概为

```cpp
while(!m_quit_flag){
    epoll_or_select_func();
    handle_io_events();
    handle_other_things();
}
```

通常handle_io_events用于收发数据，也可以直接用来做业务逻辑的处理，但是不能是耗时较长的业务

```cpp
void handle_io_events(){
    recv_or_send_data();
    decode_packages_and_process();
}
```

网络线程即Loop中，handle_io_events示意图  

```cpp
网络线程
栈顶            do_bussiness_logic()//不能耗时过长
                /
            decode_packages_and_process()
            /
栈底   handle_io_events()
```

如果do_bussiness_logic需要消耗很长的时间该怎么办，应该用独立的线程进行处理

```cpp
网络线程                            业务线程
调用I/O复用        业务数据队列     从业务数据队列
函数检测事件                        中取任务
    |                                  |
处理I/O事件                         业务逻辑处理
收发数据                                |
    |                                   
   解包 
    |
将业务数据包<----------------------> 处理后的结果数据如果需要通过网络发送，
交给业务线程                         则再次交给网络线程
```

业务怎么将结果数据交给网络线程呢

1、对Connection层发送数据进行加锁，这样业务线程可以将数据写到业务层缓冲区，网络线程也可以发送数据，这就要保证线程安全，需要对Connection层的发送数据进行加锁处理

2、或者为业务线程在Conection层开一个缓冲区，利用Loop中的定时器任务，将数据从业务缓冲区读到Connection发送缓冲区

3、和2类似，只不过把缓冲区数据的移动任务在handle_other_thing进行处理

## 非侵入式结构

非入侵结构，指的是一个服务中的所有通信或业务数据都在网络通信框架内部流动，也就是没有外部数据源注入网络通信模块或从网络通信模块中流出，例如A向B用户发送消息，实际上是从A的Connection传递到B的Connection，如果是群发则从一个Connection传递到多个用户的Connection，Connection对象都是网络通信模块的内部结构

## 侵入式结构

如果有外部消息流入网络通信模块或从网络通信模块流出，就相当于有外部消息“侵入”网络通信结构，常见的情况有

1、业务线程（或称数据源线程）将数据处理后交给网络通信组件发送   
2、网络解包后需要将任务交给专门的业务线程处理（Loop成了生产者），处理完后需要再次通过网络通信组件发送出去

* 方法1

可以通过对应的Session或Socket直接对数据进行发送

```cpp
//群发
{
    std::lock_guard<std::mutex> scoped_lock(m_mutexForSession);
    for(auto& session:m_mapSessions){
        session.second->pushSomeData(dataToPush);
    }
}
```

```cpp
//发送到某用户
{
    std::lock_guard<std::mutex> scoped_lock(m_mutexForSession);
    for(auto& session:m_mapSessions){
        if(session.second->isAccountIdMatched(accountId)){
            session.second->pushSomeData(dataToPush);
            return true;
        }
    }
}
```

这样的话，会发现业务线程可能占有存放session的数据据结构时间过长，网络线程如果更改session，就要等到业务线程任务完成后了，有些开发者会这样设计

```cpp
{
    std::map<int64_t,BusinessSession*> mapLocalSessions;
    {
        std::lock_guard<std::mutex> scoped_lock(m_mutexForSession);
        mapLocalSessions = m_mapSessions;//拷贝
    }
    for(auto& session:mapLocalSessions){
        session.second->pushSomeData(dataToPush);
    }
}
```

缺点一：这样还是有问题，在拷贝后，session可能会进行销毁的，那么我们拷贝的session指针就成了野指针，mapLocalSessions中记录的Session对象可以使用waek_ptr,weak_ptr配和shared_ptr使用，用weak_ptr的expired方法可以检测对象的shared_ptr计数是否大于0，也就是对象还是否存在没有被释放

```cpp
std::map<int64_t,std::weak_ptr<BusinessSession>> mapLocalSessions;
```

缺点二：业务线程有数据发送，网络线程可能也有数据发送，虽然可以用锁保证包的完整性，但是不能保证包发送的顺序，显然方法一本身是不适合这种情况的

```cpp
//多个业务组件发送数据，且有顺序要求，方法一不适用
业务组件1   业务组件2   业务组件3
    \           |       /
        数据发送模块(网络组件)
```

可以搞成这样

```cpp
业务组件1   业务组件2   业务组件3
    \          |       /
            排序组件 <----------------
---------------|------------------   |
          数据发送模块                |
                                    |
          产生数据的内部模块----------|
                           (网络组件)
------------------------------------
```

* 方法2

将业务组件需要发送的数据交给网络组件发送，可以使用队列，业务组件将数据交给队列，然后告知对应的网络组件中的线程需要收取任务并执行，前面有说过唤醒机制执行handle_other_things

```cpp
void EventLoop::runInLoop(const Functor&taskCallback){
    if(isInLoopThread){
        taskCallback();//Loop线程执行
    }else{
        queueInLoop(taskCallback);//其他线程放入队列
    }
}
void EventLoop::queueInLoop(const Functor& taskCallback){
    {
        std::unique_lock<std::mutex> lock(m_mutex);
        m_pendingFunctors.push_back(taskCallback);
    }
    if(!isInLoopThread()||m_doingOtherThings){
        wakeup();//唤醒Loop
    }
}
void EventLoop::handle_other_things(){
    std::vector<Functor> functors;
    m_doingOtherThings = true;
    {
        std::unique_lock<std::mutex> lock(m_mutex);
        functors.swap(m_pendingFunctors);
    }
    size_t size = functors.size();
    for(size_t i=0;i<size;i++){
        functors[i]();
    }
    m_doingOtherThings=false;
}
```

这样就是实际由Loop线程进行数据发送，std::lock_guard是RAII获取锁释放锁，std::shared_lock是可重入的读取锁（配和shared_mutex、unique_lock使用），std::scoped_lock用于锁定多个互斥量可以避免死锁

## 带有网络通信模块的服务器的经典结构

### 为何将listenfd设置为非阻塞模式

1、结构一：listenfd为阻塞模式，为listenfd独立分配一个接受连接线程,一般用主线程循环调用accept，当accept返回时得到新的clientfd，将clientfd加入到如list、vector的数据结构中（要加锁），处理clientfd的I/O线程（Loop线程），在handle_other_things的时候从list或vector中取出clientfd，为了高效在有多个clientfd时可以尝试唤醒Loop线程的epoll_wait(前面说过唤醒fd策略)

2、结构二：listenfd为阻塞模式，使用同一个one thread one loop结构处理listenfd的事件，将listenfd放到一个Loop中监听读事件，在epoll_wait返回后，判断处理的fd是listenfd还是clientfd，如果是listenfd就进行accept处理，此时accept就不会阻塞了，每次循环只能调用一个accept（因为出第一次调用之外不知道是否会阻塞）

3、结构三：listenfd为非阻塞模式，使用同一个one thread one loop结构处理listenfd，仍旧将listenfd放到Loop中进行epoll_wait在返回后如果是listenfd，则进行循环调用accept，知道返回-1且errno为EAGAIN（EWOULDBLOCK）则break，如果errno为EINTR则continue，在一次accept循环时还可以限制一次循环最多执行多少次accept

### 基于one thread one loop结构的经典服务器结构

1、listenfd单独使用一个loop，clientfd被分配到其他loop

这样可以设计clientfd分发的负载均衡，一般采用轮询策略（round-robin），可以将clientfd均匀的分配到其他工作线程

2、listenfd不单独使用一个loop，将所有clientfd都按一定策略分配给各个loop

如果有loop1,loop2,loop3,loop4,listenfd在loop1，在accept到新的clientfd时，将其提交给分配策略组件，分配策略组件再根据分配策略分配到loop1、loop2、loop3、loop4

3、listenfd和所有clientfd均使用一个loop

所有fd的事件监听采用一个线程处理，在有数据包收到后可以提交给业务处理线程

### 常见的负载均衡策略

1、轮询（Round Robin）算法：按照顺序依次将请求分配给每个后端服务器，循环往复。它是最简单和最常见的负载均衡算法。

2、最少连接（Least Connection）算法：将请求分配给当前连接数最少的后端服务器，以实现负载均衡。这可以确保将负载较均匀地分配到各个服务器上。

3、最快响应（Fastest Response）算法：将请求分配给响应时间最短的后端服务器，以提供最佳的用户体验。

4、IP 哈希（IP Hash）算法：根据客户端的 IP 地址进行哈希计算，将同一 IP 的请求分配给同一台后端服务器。这样可以确保来自同一客户端的请求总是被发送到同一台服务器上，适用于一些需要保持会话状态的应用。

5、加权轮询（Weighted Round Robin）算法：为每个后端服务器分配一个权重值，根据权重比例来决定请求的分配比例。具有较高权重的服务器将获得更多的请求。

6、加权最少连接（Weighted Least Connection）算法：结合了最少连接和加权轮询的特点，根据服务器的权重和当前连接数来决定请求的分配。

7、随机（Random）算法：随机选择一个后端服务器来处理请求。虽然简单，但无法保证负载的均衡性。

### 服务器的性能瓶颈

1、I/O密集型指的是程序业务上没有复杂的计算或者耗时的业务逻辑处理，大多数情况下为网络收发操作，如即时通信、交易系统行情推送、实时对战游戏

2、计算密集型指的是在程序业务逻辑中存在耗时的计算，如数据处理服务、调度服务等

根据不同类型的业务，就要使得有效的线程资源合理分配到网络通信组件还是业务模块，总之就是根据实际情况合理分配
