# 网络编程重点

网络编程其实就是套接字与 IO 多路复用那回事，但是细节很多

## socket 相关函数

socket 创造某种类型的套接字  
bind 将一个 socket 绑定到一个 IP 与端口的二元组上  
listen 将一个 socket 变为监听状态  
connect 试图建立一个 TCP 连接，一般用于客户端  
accept 尝试接收一个连接，一般用于服务端  
send 通过一个 socket 发送数据  
recv 通过一个 socket 收取数据  
select 判断一组 socket 上的读写和异常事件  
gethostbyname 通过域名获取机器地址  
close 关闭一个套接字，回收该 socket 对应的资源  
shutdown 关闭 socket 收发通道  
setsockopt 设置一个套接字选项  
getsockopt 获取一个套接字选项

## man 手册

Section 1: 用户命令，包含系统中可执行命令的手册页，例如常见的命令如 ls、grep、cp 等。  
Section 2: 系统调用，包含内核提供的系统调用的手册页，这些调用可以在 C 语言程序中直接调用。  
Section 3: C 库函数，包含 C 语言标准库函数的手册页，例如字符串操作、文件操作、内存操作等。  
Section 4: 设备和特殊文件，包含设备驱动程序和特殊文件的手册页，例如硬件设备、设备驱动、设备文件等。  
Section 5: 文件格式和约定，包含特定文件格式、配置文件和约定的手册页，例如 passwd 文件、fstab 文件等。  
Section 6: 游戏和屏保，包含游戏和屏保程序的手册页。  
Section 7: 其他杂项，包含一些其他杂项的手册页，例如标准和协议、宏和特殊文件等。  
Section 8: 系统管理命令，包含系统管理命令的手册页，例如管理用户、系统配置、网络配置等。

## TCP 网络通信的基本流程

也就是那么回事，写写项目就好了

## select 函数

去看 UNIX 环境高级编程部分吧

## socket 操作错误码

"EWOULDBLOCK" 是一个定义在 <errno.h> 头文件中的宏，表示在非阻塞操作中出现了一个阻塞的情况。

在网络编程中，当使用非阻塞套接字进行读取或写入操作时，可能会出现 EWOULDBLOCK 错误码。它指示当前操作无法立即完成，因为没有可用的数据（对于读取操作）或没有足够的空间（对于写入操作）。这并不是一个真正的错误，而是一种指示需要等待更多数据可用或更多空间可用的条件。

EWOULDBLOCK 的值通常是一个正整数，表示该错误的特定错误码。具体的值可以因操作系统而异。在 POSIX 标准中，EWOULDBLOCK 通常与 EAGAIN 宏相同，它们都表示相同的非阻塞操作条件。

在处理 EWOULDBLOCK 错误时，通常需要在稍后的时间重新尝试相同的操作，直到操作能够成功完成。这可以通过在循环中重复调用相应的读取或写入函数来实现，直到返回不再是 EWOULDBLOCK 为止。

请注意，EWOULDBLOCK 错误与其他一些错误码，如 EINTR（表示操作由于信号中断）和 ECONNRESET（表示连接被重置）等，可能会同时出现，因此在处理错误时需要注意多种可能的情况。

## bind 函数

INADDR_ANY 表示`0.0.0.0`

## socket 的阻塞模式与非阻塞模式

socket 在阻塞和非阻塞模式下，connect、accept、send、recv 的行为表现有差异

1、如何将 socket 设置为非阻塞

```cpp
//fcntl
//socket函数时type加SOCK_NONBLOCK
//accept,accept4直接将accept函数返回的socket设置为非阻塞的
```

2、send 和 recv 函数在阻塞和非阻塞模式下的表现

send 本质是将应用层发送缓冲区的数据拷贝到内核中，数据什么时候会从网卡缓冲区真正发送到网络是不知道的，如果 socket 设置了 TCP_NODELAY，存放到内核缓冲区的数据就会立即发出去，如果一次放入内核缓冲区的数据包太小，系统会在多个小的数据包凑成一个大的数据包后才会将数据发出去

recv 函数本质上不是从网络取数据，而实从内核缓冲区中数据拷贝到应用程序缓冲区中，拷贝完成后内核缓冲区中的该数据部分会移除

如果内核缓冲区满了，还在 send 调用时

阻塞模式：继续调用 send、recv 函数，程序会阻塞在 send、recv 调用处  
非阻塞模式：继续调用 send、recv 函数，程序不会阻塞在 send、recv 调用处，而是返回，会得到错误码，EWOULDBLOCK、EAGAIN（二者错误码相同）

3、非阻塞模式下 send 和 recv 函数的返回值

| 返回值 n     | 返回值的含义                                                                                                                       |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------- |
| 大于 0       | 成功发送(send)或收(recv)n 字节                                                                                                     |
| 0            | 对端关闭                                                                                                                           |
| 小于 0（-1） | 出错（不是后三者）、被信号中断（EINTR）、对端 TCP 窗口太小导致数据发送不出去或当前网卡缓冲区已经无数据可接收（EWOUDBLOCK、EAGAIN） |

## 发送 0 字节数据效果

两种情形让send函数的返回值为0：  
1、对端关闭连接时，正好尝试调用send函数发送数据  
2、本段尝试调用send函数时发送0字节数据

## connect 在阻塞和非阻塞下的行为

阻塞：连接成功才会返回  
非阻塞：无论是否连接成功都会返回，返回-1并不一定表示连接出错，如果此时错误码为EINProGRESS则表示正在尝试连接，可以用select函数判断socket是否可写，可写则连接成功否则失败

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define SERVER_IP "127.0.0.1"
#define SERVER_PORT 8080

int set_nonblocking(int sockfd) {
    int flags = fcntl(sockfd, F_GETFL, 0);
    if (flags == -1) {
        perror("fcntl");
        return -1;
    }
    if (fcntl(sockfd, F_SETFL, flags | O_NONBLOCK) == -1) {
        perror("fcntl");
        return -1;
    }
    return 0;
}

int main() {
    int sockfd;
    struct sockaddr_in server_addr;

    // 创建socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置非阻塞
    if (set_nonblocking(sockfd) == -1) {
        exit(EXIT_FAILURE);
    }

    // 初始化服务器地址
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(SERVER_PORT);
    if (inet_pton(AF_INET, SERVER_IP, &(server_addr.sin_addr)) <= 0) {
        perror("inet_pton");
        exit(EXIT_FAILURE);
    }

    // 非阻塞连接
    int ret = connect(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr));
    if (ret == -1) {
        if (errno == EINPROGRESS) {
            printf("Connecting...\n");
            fd_set write_fds;
            FD_ZERO(&write_fds);
            FD_SET(sockfd, &write_fds);
            struct timeval timeout;
            timeout.tv_sec = 5;  // 设置超时时间为5秒
            timeout.tv_usec = 0;
            ret = select(sockfd + 1, NULL, &write_fds, NULL, &timeout);
            if (ret == -1) {
                perror("select");
                exit(EXIT_FAILURE);
            } else if (ret == 0) {
                fprintf(stderr, "Connection timeout\n");
                exit(EXIT_FAILURE);
            } else {
                if (!FD_ISSET(sockfd, &write_fds)) {
                    fprintf(stderr, "Connection failed\n");
                    exit(EXIT_FAILURE);
                }
            }
        } else {
            perror("connect");
            exit(EXIT_FAILURE);
        }
    }

    printf("Connected successfully\n");

    // 关闭socket
    close(sockfd);

    return 0;
}
```

## 连接时顺便接收第一组数据

Linux提供了TCP_DEFER_ACCEPT的socket选项，设置该选项后只有连接建立成功且接收到第一组对端数据时，accept函数才会返回

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define SERVER_IP "127.0.0.1"
#define SERVER_PORT 8080

int main() {
    int sockfd;
    struct sockaddr_in server_addr;

    // 创建socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置TCP_DEFER_ACCEPT选项
    int defer_accept = 1;
    if (setsockopt(sockfd, IPPROTO_TCP, TCP_DEFER_ACCEPT, &defer_accept, sizeof(defer_accept)) == -1) {
        perror("setsockopt");
        exit(EXIT_FAILURE);
    }

    // 初始化服务器地址
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(SERVER_PORT);
    if (inet_pton(AF_INET, SERVER_IP, &(server_addr.sin_addr)) <= 0) {
        perror("inet_pton");
        exit(EXIT_FAILURE);
    }

    // 绑定地址和端口
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        exit(EXIT_FAILURE);
    }

    // 监听连接
    if (listen(sockfd, SOMAXCONN) == -1) {
        perror("listen");
        exit(EXIT_FAILURE);
    }

    printf("Server is listening on %s:%d\n", SERVER_IP, SERVER_PORT);

    while (1) {
        // 接受连接
        int client_sockfd;
        struct sockaddr_in client_addr;
        socklen_t client_addrlen = sizeof(client_addr);

        client_sockfd = accept(sockfd, (struct sockaddr *)&client_addr, &client_addrlen);
        if (client_sockfd == -1) {
            perror("accept");
            exit(EXIT_FAILURE);
        }

        printf("Accepted connection from %s:%d\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));

        // 处理连接，可以在这里进行读写操作

        // 关闭连接
        close(client_sockfd);
    }

    // 关闭监听socket
    close(sockfd);

    return 0;
}
```

## 获取 socket 对应缓冲区中的可读数据量  

在Linux网络编程中，可以使用ioctl函数的FIONREAD参数来获取套接字对应缓冲区中的可读数据量。

```cpp
#include <sys/ioctl.h>
int ioctl(int fd, unsigned long request, ...);
```

请注意，获取可读数据量的值是一个估计值，因为在调用ioctl后和实际读取数据之前，缓冲区中的数据量可能会发生变化。因此，在实际读取数据之前，可以再次调用ioctl来获取最新的可读数据量。

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>

int main() {
    int sockfd;
    ssize_t available_data;

    // 创建socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 假设 sockfd 已经连接到远程服务器

    // 获取可读数据量
    if (ioctl(sockfd, FIONREAD, &available_data) == -1) {
        perror("ioctl");
        exit(EXIT_FAILURE);
    }

    printf("Available data in socket buffer: %zd bytes\n", available_data);

    // 关闭socket
    close(sockfd);

    return 0;
}
```

## EINTR 错误码  

像socket相关函数，connect、send、recv、epoll_wait等，出了函数调用出错时返回-1，当函数调用被信号中断时也会返回-1，可以通过错误码errno判断是不是EINTR,确定是不是由于信号中断产生的假错误

## SIGPIPE 信号  

假设A与B为TCP连接状态，当A关闭连接时，B继续向A发送数据则B收到A的RST报文应答，若接收到RST后仍然向A发送数据系统会产生一个SIGPIPE信号给B，代表这个连接已经断开了，SIGPIPE的默认处理行为是进程退出

根据四次挥手，当对端关闭时，虽然本意是关闭读写两个通道，但会本端只收到FIN包，按照TCP规定，表示对端只关闭了其所负责的哪一个单通道即不再发送数据，但是仍然可以接收

由于TCP限制，通信的一方无法判断对端socket是调用了close还是shutdown

```cpp
#include <sys/socket.h>
int shutdown(int sockfd, int how);
//SHUT_RD SHUT_WR SHUT_RDWR
```

如果已经接收到对方的FIN包，调用read或recv如果缓冲区为空则返回0，接收到FIN后第一次调用write或send时，如果缓冲区没问题则发送成功返回大于0的值，但是会导致接收到对方的RST报文，再次调用write或send时，会产生SIGPIPE信号，一般都是忽略信号处理

```cpp
signal(SIGPIPE,SIG_IGN)
```

## poll  

不再介绍，看UNIX环境编程部分吧

## epoll  

特别回顾的是epoll的LT与ET模式，EPOLLONESHOT

1、水平触发模式（LT），一个事件只要有，就会一直触发  
2、边缘触发模式（ET），一个事件从无到有时才会触发

LT模式，监听读如果可从缓冲区读到数据就会触发，读不完，下次还会触发  
ET模式，只有在不可读到可读变化时才会触发，可读到可读是不会触发的  
LT模式，如果对端是可写的，则有写事件一直触发  
ET模式，监听写只会触发一次，触发完成后只有再次注册、检测可写事件时，才会继续触发

EPOLLONESHOT，使得其注册监听的事件如EPOLLIN在触发一次后再也不会触发，除非重新注册监听该事件类型,一般用不到，好像用处不大

## readv 与 writev

去看UNIX环境编程部分吧

```cpp
#include <sys/uio.h>
ssize_t readv(int fd, const struct iovec *iov, int iovcnt);
ssize_t writev(int fd, const struct iovec *iov, int iovcnt);
ssize_t preadv(int fd, const struct iovec *iov, int iovcnt,
               off_t offset);
ssize_t pwritev(int fd, const struct iovec *iov, int iovcnt,
                off_t offset);
ssize_t preadv2(int fd, const struct iovec *iov, int iovcnt,
                off_t offset, int flags);
ssize_t pwritev2(int fd, const struct iovec *iov, int iovcnt,
                 off_t offset, int flags);
```

## 主机字节序和网络字节序  

详细的介绍请看UNIX环境编程部分，有趣的是如何判断本机字节序是大端还是小端

```cpp
#include <iostream>
using namespace std;

bool isNetByteOrder()
{
    unsigned short mode = 0x1234;
    // 如果是大端（网络字节序）时，34所在字节被存储在高地址
    // 如果是小端，34所在字节被存储在低地址
    char *pmode = (char *)&mode;
    if (*pmode == 0x34) // 0x34在低地址
    {
        return false;
    }
    return true; // 0x34在高地址
}

int main(int argc, char **argv)
{
    // false
    std::cout << boolalpha << isNetByteOrder() << std::endl;
    return 0;
}
```

## 域名解析 API

常用的有gethostbyname函数

```cpp
#include <netdb.h>
struct hostent *gethostbyname(const char *name);
struct hostent {
   char  *h_name;            /* official name of host */
   char **h_aliases;         /* alias list */
   int    h_addrtype;        /* host address type */
   int    h_length;          /* length of address */
   char **h_addr_list;       /* list of addresses */
}
```

使用样例

```cpp
#include <iostream>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

using namespace std;

bool connect_to_server(const char *server, short port)
{
    int m_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (m_socket == -1)
    {
        return false;
    }
    struct sockaddr_in addrSrv = {0};
    struct hostent *phostent = nullptr;
    // 域名形式
    if (addrSrv.sin_addr.s_addr = inet_addr(server) == INADDR_NONE)
    {
        phostent = gethostbyname(server);
        if (phostent == nullptr)
        {
            return false;
        }
        // 可能有多个IP地址
        addrSrv.sin_addr.s_addr = *((unsigned long *)phostent->h_addr_list[0]);
    }
    addrSrv.sin_family = AF_INET;
    addrSrv.sin_port = htons(port);
    int ret = connect(m_socket, (struct sockaddr *)&addrSrv, sizeof(addrSrv));
    if (ret == -1)
    {
        return false;
    }
    return true;
}

int main(int argc, char **argv)
{
    if (connect_to_server("baidu.com", 80))
    {
        cout << "connect successfully" << endl;
    }
    else
    {
        cout << "connect failed" << endl;
    }
    return 0;
}
```

在新的Linux中，gethostbyname与gethostbyaddr已经废弃，应该使用较新的getaddrinfo进行代替，可以看下UNIX环境编程部分
