---
coverY: 0
---

# 第4章 基本TCP套接字编程

## 基本TCP套接字编程

### 未完待续

* socket函数

```cpp
#include<sys/socket.h>
int socket(int domain, int type, int protocol);
//domain如 AF_INET  IPv4 Internet protocols     
//AF_INET6     IPv6 Internet protocols    等等可以查看man手册
//type TCP通常用  SOCK_STREAM 
```

* 了解常用的socket函数的family值、type值、protocol值，以及family和type参数组合的合法性  
* 了解socket=>bind-=>listen=>accept阻塞流程，client socket=>connect,此时accept返回一个文件描述符，然后二者进行相互的write和read，最后由一方调用close，然后另一方read返回0，然后也调用close，最后四次挥手过程发生，当connect被调用，系统发起连接建立三次握手  
* connect函数，发起三次握手，仅在成功或者出错时返回  

```cpp
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
int connect(int sockfd, const struct sockaddr *addr,
            socklen_t addrlen);
没有收到SYN分节，返回ETIMEDOUT错误，在errno  
服务端没有端口或者服务进程，则返回SYN的响应是 RST复位，返回ECONNREFUSED错误
路由转发错误 ICMP错误，则返回EHOSTUNREACH或ENETUNREACH错误
```

* bind函数，为套接字绑定协议地址

```cpp
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
int bind(int sockfd, const struct sockaddr *addr,
                socklen_t addrlen);
```

如果当调用connect和listen之前没有bind端口，则会自动绑定一个临时端口  
bind可以指定通配地址，端口分为0和非0情况，如果指定端口号为0，则内核在bind调用时选择一个临时端口  

```cpp
struct sockaddr_in servaddr;
servaddr.sin_addr.s_addr=htonl(INADDR_ANY)//通配地址
struct sockaddr_in6 serv;
serv.sin6_addr=in6addr_any;
```

* listen函数，仅由TCP服务器调用，当使用socket函数创建套接字时，默认它是一个主动套接字，也就是调用connect发起连接的客户端套接字，使用listen将其转换为被动套接字，调用listen导致套接字从CLOSED状态转换到LISTEN状态  

```cpp
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
int listen(int sockfd, int backlog);
//backlog为响应套接字排队的最大连接个数
```

相关的队列有两个，一个未完成连接队列、一个已完成连接队列。connect调用发起第一次握手，服务器接收到第一次握手后在未完成队列建立条目，然后发出第二次握手，connect返回，然后发起客户端第三次握手，服务器收到第三次握手后将条目从未完成队列转移至已完成队列，accept能够返回  
backlog不一定就是两个队列长度总和，Berkeley实现还提供了模糊因子对其进行放缩  
不要将backlog设置为0，不用套接字你就不应该创建它好吧  
未完成队列建立条目存活时间为一个RTT，客户端发出第一次握手SYN，然后服务端为完成条目已经满了，则服务端则忽略此分节也不会返回RST，因为返回RST则与没有服务进程区别不开了  

获取系统环境变量函数getenv  

```cpp
#include <stdlib.h>
char *getenv(const char *name);
```

在完成三次握手后，accept还没有返回，或者服务端也没有read，已经接收的最大数据量，为已连接套接字的接收缓冲区大小  
不同操作系统有实际排队连接的最大数目限制  

* accept函数，由服务端调用，从已经完成连接队列头返回下一个已完成连接，如果已完成连接队列为空，则进入睡眠状态，当队列中来条目时被唤醒(假设套接字为默认的阻塞方式)，如果服务端套接字为非阻塞，则队列为空则会直接返回  

```cpp
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
//sockfd为监听套接字
//addr为获取客户协议地址
//addrlen对addr大小
//addr与addrlen可以为NULL
```

本地时间获取  

```cpp
#include <iostream>
#include <time.h>

int main()
{
 time_t ticks;
 ticks = time(nullptr);
 printf("%s\n", ctime(&ticks));
 // Thu Nov  3 00:37:59 2022
 return 0;
}

```

* fork和exec函数，直接fork为一个进程创建一个自身的副本，如果想要执行另一个程序，可以先进行fork，然后由子进程调用exec，exec把当前进程映像替换成新的程序文件，新程序从main开始执行，进程ID不改变，成调用exec的进程为调用进程，被执行的程序称为新程序  
exec共有6个，可以从 新程序由路径名指出还是有文件名指出，新程序参数是一一列出还是数组指针来引用，把进程环境传递给新程序还是开辟新环境  

```cpp
#include <sys/types.h>
#include <unistd.h>
pid_t fork(void);//返回0则为子进程
```

exec函数  

```cpp
#include <unistd.h>
extern char **environ;
int execl(const char *pathname, const char *arg, ...
                       /* (char  *) NULL */);
//file为系统环境变量，然后背后进程映射为pathname
int execlp(const char *file, const char *arg, ...
                       /* (char  *) NULL */);
int execle(const char *pathname, const char *arg, ...
                       /*, (char *) NULL, char *const envp[] */);
int execv(const char *pathname, char *const argv[]);
int execve(const char *pathname, char *const argv[],char*const envp[]);//系统调用，其他exec为execve的封装
int execvp(const char *file, char *const argv[]);
int execvpe(const char *file, char *const argv[],
                       char *const envp[]);
```

exec函数只有出错时才返回到调用者，否则将传递给新程序，通常起点为main  

* 并发服务器，可以使用简单的多进程，当accept返回一个描述符，就fork，父进程关闭已连接套接字，子进程关闭监听套接字，然后处理这个连接，父进程则仍旧进程死循环进行accept，内核为进程的socket描述符维护引用计数，只有引用计数为0时才干掉socket，而不是仅仅父进程close 已连接套接字，这个套接字就会被丢弃，因为子进程还在引用着  
* 对TCP套接字调用close，则会发出FIN、但只在引用计数为0时才真的发FIN  
* 当调用close时并不会马上断开，默认行为是将套接字标记为已关闭，不能再掉用write和read，但是缓冲区可能还有数据没有让对方收到，默认情况会将缓冲区内容发送完毕后才进行四次挥手，正常断开连接（但也可以指定行为）  
* 描述符引用计数：如果想直接发送FIN、可以调用shutdown,调用shutdown并不回使得描述符引用计数减少，如果服务端调用shutdown，然后子进程调用close，那么此时引用计数为1，这会导致父进程用不关闭任何已经连接的套接字，文件描述符大小终将耗尽  

* getsockname和getpeername函数  

```cpp
//获取本地协议地址
#include <sys/socket.h>
int getsockname(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
```

```cpp
//获取已连接套接字地址信息
#include <sys/socket.h>
int getpeername(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
```

* sockaddr_storage可以存储任何大小的sockaddr，在使用getsockname是可以使用这种类型，以保证能读取容纳任何sockaddr类型  
