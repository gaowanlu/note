---
coverY: 0
---

# 第 18 章 网络 IPC 套接字

## 网络 IPC 套接字

Linux 系统编程中，网络套接字（socket）是一个重要的概念。套接字是一种在网络上进行通信的工具，通过套接字可以建立客户端和服务器之间的连接，并进行数据的传输。

在 Linux 系统中，网络套接字是一种特殊的文件描述符，可以通过调用系统函数来创建、连接、发送和接收数据。常用的套接字类型包括 TCP 套接字和 UDP 套接字，它们分别用于建立可靠的连接和不可靠的连接。

在编程中，需要使用套接字相关的系统函数来进行网络通信。常用的系统函数包括 socket()、bind()、listen()、accept()、connect()、send()和 recv()等。其中，socket()函数用于创建套接字，bind()函数用于将套接字与一个地址绑定，listen()函数用于监听连接请求，accept()函数用于接受连接，connect()函数用于建立连接，send()函数用于发送数据，recv()函数用于接收数据。

网络套接字在 Linux 系统编程中是一个非常重要的概念，它是实现网络通信的基础。了解套接字的概念和相关系统函数的使用方法，可以帮助开发人员编写高效、可靠的网络应用程序。

## 大小端字节序

大小端字节序是指在多字节数据类型（如 int、long、float 等）的存储过程中，字节的存储顺序不同。

在大端字节序中，高位字节存放在低地址，低位字节存放在高地址；  
而在小端字节序中，低位字节存放在低地址，高位字节存放在高地址。

```cpp
        2            3
大端： 0000 0010   0000 0011
小端： 0100 0000   1100 0000
    低地址--------->高地址
```

在 Linux 系统编程中，处理器架构可能是大端字节序或小端字节序，因此需要特别注意在网络通信中字节序的处理。

重点：IO 和网络 IO 时永远是低地址的内容先出去

## 字节序转换函数

网络通信中通常使用大端字节序（也称为网络字节序）作为标准字节序。为了保证跨平台通信的正确性，需要将本地字节序（即处理器架构字节序）与网络字节序进行转换。可以使用 htonl()、htons()、ntohl()和 ntohs()等系统函数来完成字节序的转换。

```cpp
//本地字节序转网络字节序
#include <arpa/inet.h>
uint32_t htonl(uint32_t hostlong);
uint16_t htons(uint16_t hostshort);
//网络字节序转本地字节序
uint32_t ntohl(uint32_t netlong);
uint16_t ntohs(uint16_t netshort);
```

## 字节对齐

请见 C++内容中的字节对齐，在网络编程中一般会采取不对齐处理

[字节对齐跳转](/c++-even-better/yu-yan-ji-chu/c++-primer-ting-shuo-hen-nan/di-si-bu-fen-gao-ji-zhu-ti/di-19-zhang-te-shu-gong-ju-yu-ji-shu#nei-cun-zi-jie-dui-qi)

## 类型长度问题

在 C 中 int、char 等，并没有规定一定的长度大小，可能不同环境下会有不同，为了解决此问题，一般会采取以下固定长度整数类型进行使用

```cpp
#include <stdint.h>
//int8_t: 8 位有符号整数，定义在 stdint.h 或 cstdint 头文件中
//uint8_t: 8 位无符号整数，定义在 stdint.h 或 cstdint 头文件中
//int16_t: 16 位有符号整数，定义在 stdint.h 或 cstdint 头文件中
//uint16_t: 16 位无符号整数，定义在 stdint.h 或 cstdint 头文件中
//int32_t: 32 位有符号整数，定义在 stdint.h 或 cstdint 头文件中
//uint32_t: 32 位无符号整数，定义在 stdint.h 或 cstdint 头文件中
//int64_t: 64 位有符号整数，定义在 stdint.h 或 cstdint 头文件中
//uint64_t: 64 位无符号整数，定义在 stdint.h 或 cstdint 头文件中
```

## 套接字描述符

在 Linux 系统编程中，套接字描述符是一种重要的概念，它是一种用于进行网络通信的抽象概念，类似于文件描述符，用于标识和管理网络连接

在 Linux 中，套接字描述符是一个整数，它唯一标识一个网络连接。套接字描述符通常由 socket()函数创建，bind()和 connect()函数绑定和连接网络端点，send()和 recv()函数进行数据传输，close()函数关闭套接字。

## socket 函数

socket()函数是用于创建套接字的系统调用。套接字是一种抽象的通信机制，用于在网络上进行数据传输和通信。

```cpp
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
int socket(int domain, int type, int protocol);
返回值：若成功，返回文件描述符；若出错，返回-1
```

套接字通信域 domain：

```cpp
AF_INET IPv4因特网域
AF_INET6 Ipv6因特网域
AF_UNIX UNIX域
AF_UNSPEC 未指定
```

套接字类型 type：

```cpp
SOCK_DGRAM 固定长度的、无连接的、不可靠的报文传递
SOCK_RAW IP协议的数据报接口
SOCK_SEQPACKET 固定长度的、有序的、可靠的、面向连接的报文传递
SOCK_STREAM 有序的、可靠的、双向的、面向连接的字节流
```

为因特网域套接字定义的协议 protocol：

```cpp
IPPROTO_IP  IPv4网际协议
IPPROTO_IPV6    IPv6网际协议
IPPROTO_ICMP    因特网控制报文协议
IPPROTO_RAW     原始IP数据包协议
IPPROTO_TCP     传输控制协议
IPPROTO_UDP     用于数据报协议
```

创建套接字样例

```cpp
#include <iostream>
#include <cstring>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <unistd.h>

using namespace std;

int main(int argc, char **argv)
{
    //监听套接字创建
    int fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (fd == -1)
    {
        cout << "socket error " << strerror(errno) << endl;
    }
    else
    {
        cout << "socket fd = " << fd << endl;
    }
    close(fd);
    return 0;
}
```

## 文件描述符函数使用套接字时的行为

![文件描述符函数使用套接字时的行为](../.gitbook/assets/屏幕截图2023-04-23003354.jpg)

## shutdown 函数

shutdown 函数是一个系统调用，用于关闭一个已经连接的套接字或禁止其读写操作。它位于头文件<sys/socket.h>中，并具有以下原型：

```cpp
#include <sys/socket.h>
int shutdown(int socket, int how);
```

socket 为已经连接的套接字描述符，how 指定关闭的方式：

```cpp
SHUT_RD:关闭套接字的读取功能，即禁止套接字接收数据。
SHUT_WR：关闭套接字的写入功能，即禁止套接字发送数据。
SHUT_RDWR：关闭套接字的读写功能，即禁止套接字读取和发送数据。
```

shutdown 函数可以用于关闭一个已连接的套接字或禁止其读写操作，以此来表示通信结束或出现错误等情况。需要注意的是，调用该函数不会立即关闭套接字，而是将套接字置于一个特殊的状态，直到所有未发送的数据都被发送完毕或者被丢弃为止。在调用 shutdown 函数之后，应用程序仍然需要通过 close 函数关闭套接字描述符。

如果 shutdown 函数调用成功，返回值为 0。如果发生错误，返回值为-1，并设置相应的错误代码，可以通过 errno 变量获取。

## 寻址

进程标识由两部分组成，一部分是计算机的网络地址，它可以帮助标识网络上我们想与之通信的计算机；另一部分是该计算机上用端口号表示的服务，它可以帮助标识特定的进程。

## 地址格式

网络地址通常使用 IPv4 或 IPv6 地址格式。IPv4 地址是 32 位的地址，通常表示为四个数字，每个数字之间用点号分隔。例如，192.168.1.1 就是一个 IPv4 地址。

IPv6 地址是 128 位的地址，通常表示为 8 组 4 位十六进制数，每组之间用冒号分隔。例如，2001:0db8:85a3:0000:0000:8a2e:0370:7334 就是一个 IPv6 地址。

此外，还有一些其他的网络地址格式，如 MAC 地址和网络掩码等。MAC 地址是 48 位的地址，通常表示为 12 个十六进制数，每个数之间用冒号或连字符分隔。网络掩码是用于子网划分的一种地址格式，它通常与 IPv4 地址一起使用，表示一个子网的地址范围。

1、struct sockaddr

它是一个抽象结构，其具体实现取决于地址族（address family）的类型。

```cpp
struct sockaddr {
    unsigned short sa_family;    // 地址族类型 AF_INET AF_INET6 ...
    char sa_data[14];            // 具体的地址信息
};
```

2、struct sockaddr_in

```cpp
struct sockaddr_in {
    short int sin_family;        // 地址族类型，固定为AF_INET
    unsigned short int sin_port; // 端口号，网络字节序
    struct in_addr sin_addr;     // IPv4地址
    unsigned char sin_zero[8];   // 暂未使用，一般设为0
};
struct in_addr {
    uint32_t s_addr;            // IPv4地址，网络字节序
};
/*
struct sockaddr_in* p = (struct sockaddr_in*)&addr;
char* ip = inet_ntoa(p->sin_addr);
printf("IP address: %s\n", ip);
*/
```

3、struct sockaddr_in6

```cpp
struct sockaddr_in6 {
    uint16_t sin6_family;       // 地址族类型，固定为AF_INET6
    uint16_t sin6_port;         // 端口号，网络字节序
    uint32_t sin6_flowinfo;     // 流标识，暂未使用
    struct in6_addr sin6_addr;  // IPv6地址
    uint32_t sin6_scope_id;     // 作用域标识，暂未使用
};
struct in6_addr {
    unsigned char s6_addr[16];  // IPv6地址，使用网络字节序
};
/*
struct sockaddr_in6* p = (struct sockaddr_in6*)&addr;
char ip[INET6_ADDRSTRLEN];
inet_ntop(AF_INET6, &(p->sin6_addr), ip, INET6_ADDRSTRLEN);
printf("IP address: %s\n", ip);
*/
```

## inet_ntop 函数

inet_ntop()函数是一个网络编程中常用的函数，用于将网络字节序的 IP 地址转换为字符串格式

```cpp
#include <arpa/inet.h>
const char *inet_ntop(int af, const void *src, char *dst, socklen_t size);
```

其中，af 参数指定了地址族类型，可以是 AF_INET（IPv4）或 AF_INET6（IPv6）；src 参数是指向存储 IP 地址的指针；dst 参数是指向存储转换后的字符串的指针；size 参数指定了 dst 指针指向的缓冲区的大小。

inet_ntop()函数成功转换 IP 地址时，返回值是指向转换后的字符串的指针。如果出现错误，返回值为 NULL，并且可以通过调用 errno 来获取错误码。

IPv4 代码样例

```cpp
#include <arpa/inet.h>
#include <stdio.h>

int main()
{
    struct in_addr addr;
    addr.s_addr = htonl(0x7f000001); // 127.0.0.1
    char ip[INET_ADDRSTRLEN];
    if (inet_ntop(AF_INET, &addr, ip, INET_ADDRSTRLEN) == NULL)
    {
        perror("inet_ntop");
        return 1;
    }
    printf("IP address: %s\n", ip); // IP address: 127.0.0.1
    return 0;
}
```

IPv6 代码样例

```cpp
#include <arpa/inet.h>
#include <stdio.h>

int main()
{
    struct in6_addr addr;
    addr.s6_addr[0] = 0x20;
    addr.s6_addr[1] = 0x01;
    addr.s6_addr[2] = 0x0d;
    addr.s6_addr[3] = 0xb8;
    char ip[INET6_ADDRSTRLEN];
    if (inet_ntop(AF_INET6, &addr, ip, INET6_ADDRSTRLEN) == NULL)
    {
        perror("inet_ntop");
        return 1;
    }
    printf("IP address: %s\n", ip);
    // IP address: 2001:db8::f7e5:78a4:ff7f:0
    return 0;
}

```

## inet_pton 函数

用于将字符串格式的 IP 地址转换为网络字节序的二进制格式

```cpp
#include <arpa/inet.h>
int inet_pton(int af, const char *src, void *dst);
```

其中，af 参数指定了地址族类型，可以是 AF_INET（IPv4）或 AF_INET6（IPv6）；src 参数是指向存储字符串格式 IP 地址的指针；dst 参数是指向存储转换后的二进制格式 IP 地址的指针。

inet_pton()函数成功转换 IP 地址时，返回值为 1。如果出现错误，返回值为 0，并且可以通过调用 errno 来获取错误码。

IPv4 样例

```cpp
#include <arpa/inet.h>
#include <stdio.h>

int main()
{
    const char *ip_str = "127.0.0.1";
    struct in_addr addr;
    if (inet_pton(AF_INET, ip_str, &addr) <= 0)
    {
        perror("inet_pton");
        return 1;
    }
    printf("IP address: 0x%x\n", ntohl(addr.s_addr));
    // IP address: 0x7f000001
    return 0;
}
```

IPv6 样例

```cpp
#include <arpa/inet.h>
#include <stdio.h>

int main()
{
    const char *ip_str = "2001:db8::";
    struct in6_addr addr;
    if (inet_pton(AF_INET6, ip_str, &addr) <= 0)
    {
        perror("inet_pton");
        return 1;
    }
    printf("IP address: ");
    for (int i = 0; i < 16; i++)
    {
        printf("%02x", addr.s6_addr[i]);
    }
    printf("\n");
    // IP address: 2001 0db8 000000000000000000000000
    return 0;
}
```

## /etc/hosts 文件

/etc/hosts 文件是一个文本文件，用于将主机名映射到 IP 地址，或者将别名映射到主机名。在 Linux 和 Unix 系统中，每个主机都有一个/etc/hosts 文件，用于本地解析域名。

/etc/hosts 文件中每一行都表示一条主机名和地址的映射关系，格式如下：

```cpp
IP地址 主机名 别名
```

其中，IP 地址是指主机的 IP 地址，主机名是指主机的名称，别名是指主机的别名，可以有多个别名。每个字段之间使用空格或制表符进行分隔。

例如

```cpp
# This file was automatically generated by WSL. To stop automatic generation of this file, add the following entry to /etc/wsl.conf:
# [network]
# generateHosts = false
127.0.0.1       localhost
127.0.1.1       DESKTOP-QDLGRDB.        DESKTOP-QDLGRDB

192.168.56.1    windows10.microdone.cn
192.168.38.130  master
192.168.0.107   host.docker.internal
192.168.0.107   gateway.docker.internal
127.0.0.1       kubernetes.docker.internal

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

## 解析/etc/hosts 内容

1、结构体 struct hostent 用于存储主机的信息

```cpp
struct hostent {
    char *h_name;           /* official name of host */
    char **h_aliases;       /* alias list */
    int h_addrtype;         /* host address type */
    int h_length;           /* length of address */
    char **h_addr_list;     /* list of addresses */
};
//h_name：官方主机名，也就是主机的正式名称。
//h_aliases：别名列表，一个指向字符指针数组的指针，其中每个元素都是一个指向主机的别名的字符指针。
//h_addrtype：主机地址类型，通常为AF_INET（IPv4地址）或AF_INET6（IPv6地址）。
//h_length：地址长度，通常为4（IPv4地址长度）或16（IPv6地址长度）。
//h_addr_list：地址列表，一个指向字符指针数组的指针，其中每个元素都是一个指向主机地址的字符指针。
```

2、gethostent、sethostent、endhostent 函数

```cpp
#include <iostream>
#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

using std::cout;
using std::endl;

int main()
{
    struct hostent *host;
    sethostent(1);//1表示保持打开/etc/hosts
    while ((host = gethostent()) != NULL)
    {
        cout << "host: " << host->h_name << endl;
        // 别名
        char **alias;
        for (alias = host->h_aliases; *alias != NULL; alias++)
        {
            cout << "alias: " << *alias << endl;
        }
        // 地址
        char **addr;
        for (addr = host->h_addr_list; *addr != NULL; addr++)
        {
            struct in_addr *ptr = (struct in_addr *)(*addr);
            cout << "addr: " << inet_ntoa(*ptr) << endl;
        }
    }
    endhostent(); // 关闭/etc/hosts文件
    return 0;
}
/*
host: localhost
addr: 127.0.0.1
host: DESKTOP-QDLGRDB.
alias: DESKTOP-QDLGRDB
addr: 127.0.1.1
host: windows10.microdone.cn
addr: 192.168.56.1
host: master
addr: 192.168.38.130
host: host.docker.internal
addr: 192.168.0.107
host: gateway.docker.internal
addr: 192.168.0.107
host: kubernetes.docker.internal
addr: 127.0.0.1
host: ip6-localhost
alias: ip6-loopback
addr: 127.0.0.1
*/
```

## /etc/networks 文件

/etc/networks 是一个文本文件，包含已知网络的名称、网络号、子网掩码等信息，是一个网络数据库(network database),用于在系统中解析网络名称和地址

文件内容格式

```cpp
networkname network_number [netmask]
//其中，networkname是网络的名称，network_number是网络的地址，netmask是网络的子网掩码。网络地址和子网掩码可以是点分十进制或十六进制格式的，如果省略了子网掩码，则默认为类别掩码（classful mask）。
```

例如

```cpp
loopback        127         # loopback network
link-local      169.254     # link-local network for address autoconfiguration
localnet        192.168.0   # local network
```

## 解析/etc/networks 文件

1、结构体 struct netent

```cpp
struct netent {
    char  *n_name;        // 网络名称
    char **n_aliases;     // 网络别名列表，以NULL结尾
    int    n_addrtype;    // 地址类型，通常为AF_INET
    uint32_t n_net;       // 网络地址，以网络字节序存储
};
//n_name表示网络的名称
//n_aliases是一个指向网络别名列表的指针，列表以NUL尾
//n_addrtype表示地址类型，通常为AF_INET（IPv4）
//n_net表示网络的地址，以网络字节序（network byte order）存储。
```

2、getnetbyaddr、getnetbyname、getnetent、setnetent、
endnetent 函数

getnetbyaddr 函数用于获取指定网络地址的网络条目信息。net 参数是网络地址，以网络字节序存储，type 参数表示地址类型，通常为 AF_INET（IPv4）。如果找到对应的网络条目，则返回一个指向 struct netent 结构体的指针，否则返回 NULL。

```cpp
#include <netdb.h>
struct netent *getnetbyaddr(uint32_t net, int type);
```

getnetbyname 函数用于获取指定网络名称的网络条目信息。name 参数是网络名称。如果找到对应的网络条目，则返回一个指向 struct netent 结构体的指针，否则返回 NULL。

```cpp
#include <netdb.h>
struct netent *getnetbyname(const char *name);
```

getnetent 函数用于按顺序读取网络数据库中的每个条目。如果找到下一个网络条目，则返回一个指向 struct netent 结构体的指针，否则返回 NULL。

```cpp
#include <netdb.h>
struct netent *getnetent(void);
```

setnetent 函数用于打开网络数据库文件/etc/networks，并将文件指针设置为文件开头，以便逐条读取网络条目信息。如果 stayopen 参数不为 0，则保持数据库打开状态以供后续函数使用；否则在每次打开和读取时打开和关闭数据库。

```cpp
#include <netdb.h>
void setnetent(int stayopen);
```

endnetent 函数用于关闭网络数据库文件/etc/networks，以便释放资源。

```cpp
#include <netdb.h>
void endnetent(void);
```

综合样例

```cpp
#include <iostream>
#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

using std::cout;
using std::endl;

int main()
{
    char ip[INET_ADDRSTRLEN];
    struct netent *ptr;
    setnetent(1);
    while ((ptr = getnetent()) != NULL)
    {
        cout << "name: " << ptr->n_name << endl;
        cout << "address: " << inet_ntop(AF_INET, (void *)&ptr->n_net, ip, INET_ADDRSTRLEN) << endl;
        cout << "aliases:" << endl;
        char **alias = ptr->n_aliases;
        while (*alias != NULL)
        {
            cout << *alias << endl;
            alias++;
        }
    }
    // getnetbyaddr
    uint32_t net_addr = inet_addr("169.254.0.0");
    ptr = getnetbyaddr(net_addr, AF_INET);
    if (ptr != NULL)
    {
        cout << "name: " << ptr->n_name << endl;
    }
    // getnetbyname
    ptr = getnetbyname("link-local");
    if (ptr != NULL)
    {
        cout << "address: " << inet_ntop(AF_INET, (void *)&ptr->n_net, ip, INET_ADDRSTRLEN) << endl;
    }
    endnetent();
    return 0;
}
/*
name: link-local
address: 0.0.254.169
aliases:
address: 0.0.254.169
*/
```

## /etc/protocols 文件

系统的协议数据库文件，即/etc/protocols 文件。该文件是一个文本文件，其中每一行表示一个协议条目，具有如下格式：

```cpp
<protocol name> <protocol number> <alias list>
```

其中，<protocol name>为协议的名称，<protocol number>为协议的编号，<alias list>为协议的别名列表，多个别名之间用空格隔开。

例如

```cpp
icmp    1   ICMP
igmp    2   IGMP
tcp     6   TCP
udp     17  UDP
```

## 解析/etc/protocols 文件

1、struct protent

```cpp
struct protoent {
    char  *p_name;       /* 协议名称 */
    char **p_aliases;    /* 协议别名列表 */
    int    p_proto;      /* 协议编号 */
};
```

2、getprotobyname、getprotobynumber、getprotoent、setprotoent、endprotoent 函数

函数的使用方式都是类似的，下面是一个综合用例

```cpp
#include <iostream>
#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

using std::cout;
using std::endl;

int main()
{
    struct protoent *ptr;
    setprotoent(1);
    while ((ptr = getprotoent()) != NULL)
    {
        cout << "name: " << ptr->p_name << " number: " << ptr->p_proto << endl;
    }
    ptr = getprotobyname("TCP");
    if (ptr != NULL)
    {
        cout << "name: " << ptr->p_name << " number: " << ptr->p_proto << endl;
    }
    ptr = getprotobynumber(6);
    if (ptr != NULL)
    {
        cout << "name: " << ptr->p_name << " number: " << ptr->p_proto << endl;
    }
    endprotoent();
    return 0;
}
```

## /etc/services 文件

/etc/services 文件，存储服务条目的信息，其每一行表示一个服务条目

```cpp
<service name> <port number>/<protocol name> <alias list>
```

其中，<service name>为服务的名称，<port number>为服务的端口号，<protocol name>为服务所使用的协议名称，<alias list>为服务的别名列表，多个别名之间用空格隔开。

例如

```cpp
ftp-data     20/tcp
ftp           21/tcp
ssh           22/tcp
telnet        23/tcp
smtp          25/tcp    mail
http          80/tcp    www httpd
```

## 解析/etc/services 文件

1、struct servent

```cpp
struct servent {
    char  *s_name;      /* 服务名称 */
    char **s_aliases;   /* 服务别名列表 */
    int    s_port;      /* 端口号 */
    char  *s_proto;     /* 协议名称 */
};
```

2、getservbyname、getserbyport、getservent、setservent、endservent 函数

综合使用样例

```cpp
#include <iostream>
#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

using std::cout;
using std::endl;

int main()
{
    struct servent *ptr;
    setservent(1);
    while ((ptr = getservent()) != NULL)
    {
        cout << ptr->s_name << " " << ptr->s_port << "/" << ptr->s_proto << endl;
    }
    ptr = getservbyname("echo", "tcp");
    if (ptr != NULL)
    {
        cout << ptr->s_name << " " << ptr->s_port << "/" << ptr->s_proto << endl;
    }
    ptr = getservbyport(256, "tcp");
    if (ptr != NULL)
    {
        cout << ptr->s_name << " " << ptr->s_port << "/" << ptr->s_proto << endl;
    }
    endservent();
    return 0;
}
```

## getaddrinfo 与 addrinfo

getaddrinfo 可以很好的代替 gethostbyname 和 gethostbyaddr 函数，其作用为知道主机名或服务名，查找其地址结构信息

man 手册解释

```txt
getaddrinfo, freeaddrinfo, gai_strerror - network address and service translation
```

```cpp
struct addrinfo {
    int              ai_flags;       // AI_PASSIVE, AI_CANONNAME, etc.
    int              ai_family;      // AF_UNSPEC, AF_INET, AF_INET6, etc.
    int              ai_socktype;    // SOCK_STREAM, SOCK_DGRAM, SOCK_RAW, etc.
    int              ai_protocol;    // IPPROTO_TCP, IPPROTO_UDP, IPPROTO_RAW, etc.
    size_t           ai_addrlen;     // length of ai_addr
    struct sockaddr *ai_addr;        // struct sockaddr_in or _in6
    char            *ai_canonname;   // canonical name for nodename
    struct addrinfo *ai_next;        // linked list, next node
};
/*
ai_flags选项
AI_ADDRCONFIG 查询配置的地址类型(IPv4和IPv6)
AI_ALL 查找IPv4和IPv6地址（仅用于AI_V4MAPPED）
AI_CANONNAME 需要一个规范的名字（与别名相对）
AI_NUMBERICHOST 以数字格式指定主机地址，不翻译
AI_NUMBERICSERV 将服务指定为数字端口号，不翻译
AI_PASSIVE 套接字地址用于监听绑定
AI_V4MAPPED 如果没有找到IPV6地址，返回映射到IPv6格式的IPv4地址
*/
```

相关函数原型

```cpp
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
int getaddrinfo(const char *node, const char *service,
               const struct addrinfo *hints,
               struct addrinfo **res);
void freeaddrinfo(struct addrinfo *res);
```

样例,查找符合 hint 条件的主机名为"DESKTOP-QDLGRDB."对应的 IP 地址

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <netdb.h>
#include <cstring>
#include <arpa/inet.h>

int main(int argc, char *argv[])
{

    struct addrinfo hints; // 搜索限制参数
    struct addrinfo *result, *rp;
    int s;

    /* 配置 addrinfo 结构体 */
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;     /* IPv4 或 IPv6 */
    hints.ai_socktype = SOCK_STREAM; /* 流式套接字 */

    /* 获取主机名对应的 IP 地址列表 */
    s = getaddrinfo("DESKTOP-QDLGRDB.", NULL, &hints, &result);
    if (s != 0)
    {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(s));
        exit(EXIT_FAILURE);
    }

    /* 遍历获取的地址列表 */
    for (rp = result; rp != NULL; rp = rp->ai_next)
    {
        void *addr;
        char ip_str[INET6_ADDRSTRLEN];

        if (rp->ai_family == AF_INET)
        { /* IPv4 */
            struct sockaddr_in *ipv4 = (struct sockaddr_in *)rp->ai_addr;
            addr = &(ipv4->sin_addr);
        }
        else
        { /* IPv6 */
            struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)rp->ai_addr;
            addr = &(ipv6->sin6_addr);
        }

        /* 将地址转换为字符串 */
        if (inet_ntop(rp->ai_family, addr, ip_str, INET6_ADDRSTRLEN) == NULL)
        {
            perror("inet_ntop");
            exit(EXIT_FAILURE);
        }

        /* 打印地址 */
        printf("%s\n", ip_str);
    }

    /* 释放地址列表 */
    freeaddrinfo(result);
    return 0;
}
```

## gai_strerror、getnameinfo、getnameinfo 函数的标志

如果 getaddrinfo 失败，不能使用 perror 或 strerror 生成错误信息，需要使用 gai_strerror 将返回的错误码转换成错误信息

```cpp
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
const char *gai_strerror(int errcode);
```

样例请见上一个样例中的使用

getnameinfo 用于将一个地址转换成一个主机名和一个服务名

```cpp
#include <sys/socket.h>
#include <netdb.h>
int getnameinfo(const struct sockaddr *addr, socklen_t addrlen,
               char *host, socklen_t hostlen,
               char *serv, socklen_t servlen, int flags);
/*flags参数选择：
NI_DGRAM 服务基于数据报而非基于流
NI_NAMEREQD 如果找不到主机名，将其作为一个错误对待
NI_NOFQDN   对于本地主机，仅返回全限定域名的节点名部分
NI_NUMERICHOST  返回主机地址的数字形式，而非主机名
NI_NUMERICSCOPE 对于IPv6，返回范围ID的数字形式，而非名字
NI_NUMERICSERV  返回服务地址的数字形式（即端口号），而非名字
NI_NUMERICHOST 如果不能解析名称，则返回包含该地址的数字字符串。
NI_IDN 如果主机名使用国际化域名，则进行IDN编码。
*/
```

使用样例

```cpp
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>

int main(int argc, char *argv[])
{
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    inet_pton(AF_INET, "192.168.0.107", &addr.sin_addr);
    char host[NI_MAXHOST];
    char service[NI_MAXSERV];
    int flags = 0; // NI_NUMERICSERV | NI_NUMERICHOST;
    int ret = getnameinfo((struct sockaddr *)&addr, sizeof(addr),
                          host, NI_MAXHOST, service, NI_MAXSERV, flags);
    if (ret != 0)
    {
        fprintf(stderr, "getnameinfo: %s\n", gai_strerror(ret));
        return 1;
    }
    printf("Host: %s\n", host);       // Host: host.docker.internal
    printf("Service: %s\n", service); // Service: 0
    return 0;
}
```

## bind 函数

使用 bind 函数来关联地址和套接字,即将套接字和 IP 地址与端口号绑定起来，使得套接字可以接受特定地址发来的数据报

```cpp
// bind a name to a socket
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
int bind(int sockfd, const struct sockaddr *addr,
         socklen_t addrlen);
```

注意事项：

1、指定的地址必须有效，在进程运行的主机上应该有效  
2、地址必须和创建套接字时的地址族所支持的格式相匹配  
3、地址端口一般不小于 1024，除非该进程具有相应权限  
4、一般只能将一个套接字端点绑定到一个给定地址上，尽管有些协议允许多重绑定  
5、bind 函数之前必须先创建套接字，并且套接字处于未连接状态，对于 TCP 套接字必须出与 LISTEN 状态之前  
6、如果要绑定的地址为 INADDR_ANY 或 IN6ADDR_ANY,则表示该套接字可以接受来自任何 IP 地址的数据包  
7、在多次使用同一个地址和端口号绑定套接字时，必须使用 SO_REUSEADDR 套接字选项，否则会报错

简单使用样例

```cpp
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

using namespace std;

int main(int argc, char **argv)
{
    int socketfd;
    struct sockaddr_in server_addr; // IPv4
    // 创建套接字
    socketfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); // TCP
    if (socketfd < 0)
    {
        cerr << "socket " << strerror(errno) << endl;
        exit(EXIT_FAILURE);
    }
    // 绑定地址
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(20023);
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind(socketfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0)
    {
        cerr << "bind " << strerror(errno) << endl;
        close(socketfd);
        exit(EXIT_FAILURE);
    }
    cout << "server started,listening on port " << 20023 << endl;
    //...
    close(socketfd);
    return 0;
}
```

## SO_REUSEADDR 选项

SO_REUSEADDR 是一个 socket 选项，用于在 bind() 函数中重用本地地址（IP 地址和端口号），即使之前连接仍然存在于 TIME_WAIT 状态。这个选项通常在服务器程序中使用，以便能够更快地重启服务器。

当一个 TCP 连接被关闭时，它可能处于 TIME_WAIT 状态，这是因为 TCP 协议需要确保该连接的所有数据都已传输完成，并且双方都已经确认了这一点。这个状态默认持续 2 \* MSL（最大报文段生存时间，通常为 30 秒） 的时间，以确保在这段时间内任何迟到的数据包都能够被丢弃。

但是，这个状态下的端口无法被重复使用，这可能会导致服务器无法在短时间内重启，因为旧的连接仍然存在于 TIME_WAIT 状态。使用 SO_REUSEADDR 选项可以绕过这个问题，从而使服务器可以更快地重启并绑定到相同的地址和端口。

需要注意的是，使用 SO_REUSEADDR 选项会有一些安全风险。因为它可以绕过 TIME_WAIT 状态下的端口使用限制，因此可能会导致新的连接接收到旧的数据包，或者让攻击者冒充旧连接的一方。因此，使用该选项时需要仔细评估安全风险，并且只在确保安全的情况下使用。

```cpp
int listen_fd = socket(AF_INET, SOCK_STREAM, 0);
if (listen_fd == -1) {
    perror("socket");
    exit(1);
}
int optval = 1;
if (setsockopt(listen_fd, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval)) < 0) {
    perror("setsockopt");
    exit(1);
}
```

## TIME_WAIT 阶段

TIME_WAIT 状态是指在套接字连接断开之后，等待一段时间以确保所有分组都被正确处理之后才彻底关闭套接字。在这个状态下，套接字不能被重新使用，直到经过足够长的时间。

在套接字编程中，TIME_WAIT 状态通常发生在主动关闭连接的一方，即调用 close() 函数来关闭连接的一方。在关闭连接之后，套接字会进入 TIME_WAIT 状态并等待 2MSL 的时间（MSL 是 Maximum Segment Lifetime 的缩写，代表一个 TCP 分组在网络中最大存活时间）。

TIME_WAIT 状态主要是为了保证网络传输的可靠性和数据完整性。当 TCP 连接的一端发送了 FIN 报文后，进入了 FIN_WAIT_1 状态，并等待另一端的 ACK 报文。如果这个 ACK 报文因为网络原因丢失了，那么这个连接就会一直处于 FIN_WAIT_1 状态，直到超时，这样会使得另一端的 TCP 无法再次连接这个端口，从而导致网络阻塞。为了避免这种情况的发生，TCP 协议规定当一个 TCP 连接被关闭时，必须经过一段时间的 TIME_WAIT 状态，这个状态下，TCP 连接仍然保持着最后一次传输的数据，以及最后一次发送和接收到的序列号等信息，如果另一端有需要，就可以进行重传，从而保证数据的可靠传输。因此，TIME_WAIT 状态对于网络传输的可靠性和数据完整性至关重要。

## getsockname 函数

用于获取一个已绑定的套接字的本地地址信息，包括 IP 地址和端口号。

```cpp
#include <sys/socket.h>
int getsockname(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
//函数返回值为 0 表示成功，-1 表示出错。
```

使用样例

```cpp
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main()
{
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    addr.sin_port = htons(12345);
    if (bind(sockfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    struct sockaddr_in local_addr;
    socklen_t addr_len = sizeof(local_addr);
    if (getsockname(sockfd, (struct sockaddr*)&local_addr, &addr_len) < 0) {
        perror("getsockname failed");
        exit(EXIT_FAILURE);
    }
    char ip_str[INET_ADDRSTRLEN];
    if (inet_ntop(AF_INET, &(local_addr.sin_addr), ip_str, INET_ADDRSTRLEN) == NULL) {
        perror("inet_ntop failed");
        exit(EXIT_FAILURE);
    }
    printf("Local IP address: %s\n", ip_str);
    printf("Local port: %d\n", ntohs(local_addr.sin_port));
    close(sockfd);
    return 0;
}
```

## getpeername 函数

用于获取已连接套接字的远程地址信息

```cpp
#include <sys/socket.h>
int getpeername(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
//若调用成功，返回0，addr 存储了对端套接字的地址信息，addrlen 已经被更新为 addr 结构体的实际长度。
//若出现错误，返回-1，并设置 errno 变量来指示错误类型。
```

使用样例 demo

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main()
{
    int sockfd, newsockfd, portno;
    socklen_t clilen;
    char buffer[256];
    struct sockaddr_in serv_addr, cli_addr;
    int n;

    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0)
    {
        perror("ERROR opening socket");
        exit(1);
    }

    bzero((char *)&serv_addr, sizeof(serv_addr));
    portno = 5001;

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port = htons(portno);

    if (bind(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
        perror("ERROR on binding");
        exit(1);
    }

    listen(sockfd, 5);

    clilen = sizeof(cli_addr);
    newsockfd = accept(sockfd, (struct sockaddr *)&cli_addr, &clilen);
    if (newsockfd < 0)
    {
        perror("ERROR on accept");
        exit(1);
    }

    struct sockaddr_in remote_addr;
    socklen_t addrlen = sizeof(remote_addr);
    getpeername(newsockfd, (struct sockaddr *)&remote_addr, &addrlen);

    printf("Connection accepted from %s:%d\n", inet_ntoa(remote_addr.sin_addr), ntohs(remote_addr.sin_port));

    close(newsockfd);
    close(sockfd);
    return 0;
}
```

## TCP 套接字状态

常见的状态

```cpp
CLOSED：初始状态，未连接
LISTEN：套接字正在监听连接请求
SYN_SENT：向对方发起连接请求，并等待对方确认
SYN_RECEIVED：接收到对方的连接请求，并已发送确认
ESTABLISHED：连接已建立，双方可以进行通信
FIN_WAIT_1：关闭连接，等待对方发送关闭请求
FIN_WAIT_2：等待对方发送关闭请求或确认已发送的关闭请求
CLOSE_WAIT：等待对方发送关闭请求
CLOSING：发送关闭请求，并等待对方的确认
LAST_ACK：等待对方的关闭请求的确认
TIME_WAIT：等待一段时间，确保对方已收到自己发送的关闭请求的确认
CLOSED：连接已关闭，处于最终状态
```

常见的状态转换

```txt
客户端                                   服务器
socket         SYN J,MSS=536
connect（阻塞）------------------->  socket,bind,listen(LISTEN)
SYN_SENT                            accept(阻塞) SYN_RCVD
              <-------------------
             SYN K,ACK J+1 MSS=1460
ESTABLISHED
 connect返回  ---------------------> ESTABLISHED accept返回，read（阻塞）
                   ACK K+1
write
read阻塞      ----------------------> read 返回
                     数据请求

read返回      <--------------------- write read阻塞
                  数据应答，请求ACK

              --------------------->
                       应答ACK

close主动关闭  ---------------------> CLOSE_WAIT(被动关闭) read返回0
FIN_WAIT_1              FIN M

FIN_WAIT2     <--------------------
                       ACK M+1

TIME_WAIT     <---------------------close LAST_ACK
                      FIN N

              ----------------------> CLOSED
                    ACK N+1
(2MSL)CLOSED

特殊的CLOSING状态:对于主动关闭方，CLOSING状态表示你发送FIN报文后，并没有收到对方的ACK报文，反而却也收到了对方的FIN报文
```

## connect 函数

用于建立与远程主机的连接。

```cpp
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
int connect(int sockfd, const struct sockaddr *addr,
           socklen_t addrlen);
```

调用 connect 函数会使系统尝试与远程主机建立连接，如果连接建立成功，则返回 0。如果连接建立失败，则返回-1，并设置相应的错误码，可以通过 perror 函数来输出错误信息。

需要注意的是，如果 connect 函数返回-1 并设置了错误码 EINPROGRESS，则说明连接建立请求已经被发送到远程主机，但连接还未建立完成。此时可以调用 select 函数来等待连接完成，或者调用 poll 函数、epoll_wait 函数等待连接完成。

另外，如果使用非阻塞的套接字进行连接操作，也需要先调用 connect 函数，然后通过 select 函数等待连接完成。在这种情况下，connect 函数可能会立即返回，并设置错误码为 EINPROGRESS。

样例 demo

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 20023

int main()
{
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0)
    {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    struct sockaddr_in servaddr;
    memset(&servaddr, 0, sizeof(servaddr));

    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(PORT);

    if (inet_pton(AF_INET, "61.171.51.135", &servaddr.sin_addr) <= 0)
    {
        perror("inet_pton");
        exit(EXIT_FAILURE);
    }

    if (connect(sockfd, (struct sockaddr *)&servaddr, sizeof(servaddr)) < 0)
    {
        perror("connect");
        exit(EXIT_FAILURE);
    }

    printf("Connected to server\n");

    close(sockfd);
    return 0;
}
```

## listen 函数

用于将指定的套接字设置为从客户端接受连接请求的状态

```cpp
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
int listen(int sockfd, int backlog);
/*
sockfd：需要设置为监听状态的套接字描述符。
backlog：内核为相应套接字排队的最大连接个数。
该函数调用成功时返回0，失败时返回-1，并设置errno为相应的错误码。
backlog: 它指定了可以在已完成连接队列中等待接受的尚未被 accept 函数处理的连接请求的数量。
*/
```

样例 demo

```cpp
#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>

#define SERVER_PORT 8080
#define BACKLOG 5

int main() {
    int listenfd, connfd;
    struct sockaddr_in servaddr, cliaddr;
    socklen_t clilen;
    // 创建监听套接字
    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    if (listenfd == -1) {
        perror("socket error");
        exit(EXIT_FAILURE);
    }
    // 初始化服务器地址结构体
    bzero(&servaddr, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    servaddr.sin_port = htons(SERVER_PORT);
    // 将套接字绑定到服务器地址结构体上
    if (bind(listenfd, (struct sockaddr *) &servaddr, sizeof(servaddr)) == -1) {
        perror("bind error");
        exit(EXIT_FAILURE);
    }
    // 将套接字设置为监听状态，等待客户端连接请求
    if (listen(listenfd, BACKLOG) == -1) {
        perror("listen error");
        exit(EXIT_FAILURE);
    }
    // 处理客户端连接请求
    while (1) {
        clilen = sizeof(cliaddr);
        connfd = accept(listenfd, (struct sockaddr *) &cliaddr, &clilen);
        if (connfd == -1) {
            perror("accept error");
            exit(EXIT_FAILURE);
        }
        // 处理连接
        // ...
        // 关闭连接
        close(connfd);
    }
    // 关闭监听套接字
    close(listenfd);
    return 0;
}
```

## accept 函数

accept 函数用于从已经建立连接的套接字队列中取出一个客户端连接，创建一个新的套接字并返回该套接字的文件描述符，用于与客户端进行通信。

```cpp
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
/*
sockfd：表示监听套接字的文件描述符；
addr：表示用于存储连接到的客户端地址信息的指针，通常是一个 struct sockaddr_in 类型的指针；
addrlen：表示 addr 指针指向的地址结构体的长度，需要传入一个指向 socklen_t 类型的变量的指针。
如果连接成功，返回一个新的套接字的文件描述符，这个套接字用于与客户端进行通信；
如果出错，返回 -1。
*/
```

如果 sockfd 处于非阻塞模式，accept 返回-1，并将 errno 设置为 EAGAIN 或 EWOULDBLOCK

使用样例可见上一个样例

## 数据传输

在套接字的数据传输中，完全可以使用 read 与 write 函数，如果想指定选项，从多少个客户端接收数据包，或者发送带外数据，就需要使用 6 个为数据传递而设计的套接字函数

### send 函数

send 函数用于发送数据到已连接的套接字

send 函数的返回值是发送数据的实际字节数，如果发生错误，则返回 -1，并设置 errno 变量来指示错误类型。

```cpp
#include <sys/types.h>
#include <sys/socket.h>
ssize_t send(int sockfd, const void *buf, size_t len, int flags);
/*
sockfd：已连接的套接字描述符。
buf：发送数据缓冲区的指针。
len：发送数据缓冲区的大小。
flags：可选参数，指定发送数据的行为。
flags：
MSG_CONFIRM 提供链路层反馈以保持地址映射有效
MSG_DONTROUTE 勿将数据包路由出本地网络
MSG_DONTWAIT 允许非阻塞操作（等价于使用O_NONBLOCK）
MSG_EOF 发送数据后关闭套接字的发送端
MSG_EOR 如果协议支持，标记记录结束
MSG_MORE 延迟发送数据包允许写更多数据
MSG_NOSIGNAL 在写无连接的套接字时不产生SIGPIPE信息
MSG_OOB 如果协议支持，发送带外数据
*/
```

注意事项

应该检查返回值，以确保所有数据都被发送出去了。  
如果需要，应该在调用 send 函数之前设置套接字选项。  
应该考虑对数据进行分段处理，以免发送的数据过大。

```cpp
#include <sys/socket.h>
#include <unistd.h>
#define BUF_SIZE 1024
int main(int argc, char *argv[]) {
    int sockfd;
    char buf[BUF_SIZE];
    ssize_t bytes_sent;
    // 创建套接字并连接到远程主机
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    // ...
    // connect(sockfd, ...);
    // 发送数据
    bytes_sent = send(sockfd, buf, BUF_SIZE, 0);
    if (bytes_sent == -1) {
        perror("send error");
        return -1;
    }
    // 关闭套接字
    close(sockfd);
    return 0;
}
```

### sendto 函数

sendto 函数用于 DUP 套接字发送数据的函数

```cpp
#include <sys/types.h>
#include <sys/socket.h>
ssize_t sendto(int sockfd, const void *buf, size_t len, int flags,
                      const struct sockaddr *dest_addr, socklen_t addrlen);
/*
sockfd：已连接套接字的文件描述符。
buf：指向要发送数据的缓冲区。
len：发送数据的长度。
flags：额外的选项，可以设置为 0。与send的参数类似。
dest_addr：目标地址结构体的指针，包含了目标 IP 和端口信息。
addrlen：目标地址结构体的大小。
*/
```

使用 sendto() 函数发送数据，一般不需要事先建立连接。如果已经建立了连接，也可以使用该函数发送数据，只需要忽略 dest_addr 和 addrlen 参数即可。

函数返回值为发送的字节数，如果出现错误，返回值为 -1。可以通过 errno 全局变量获取错误代码。

sendto 函数使用样例

```cpp
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

#define PORT 12345

int main() {
    int sockfd;
    struct sockaddr_in server_addr;
    char buffer[] = "Hello, World!";
    // 创建套接字
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    // 设置服务器地址
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    memset(&(server_addr.sin_zero), 0, 8);
    // 发送数据
    sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)&server_addr, sizeof(struct sockaddr));
    // 关闭套接字
    close(sockfd);
    return 0;
}

```

### sendmsg

再通过套接字发送数据时，可以调用带有 msghdr 结构的 sendmsg 来指定多重缓冲区传输数据，和 writev 类似

```cpp
#include <sys/types.h>
#include <sys/socket.h>
ssize_t sendmsg(int sockfd, const struct msghdr *msg, int flags);
```

struct msghdr

```cpp
struct iovec {
    void *iov_base;    // 数据缓冲区的起始地址
    size_t iov_len;    // 数据缓冲区的长度
};
struct msghdr
{
    void *msg_name;        /* Optional address */
    socklen_t msg_namelen; /* Size of address */
    struct iovec *msg_iov; /* Scatter/gather array */
    size_t msg_iovlen;     /* # elements in msg_iov */
    void *msg_control;     /* Ancillary data, see below */
    size_t msg_controllen; /* Ancillary data buffer len */
    int msg_flags;         /* Flags (unused) */
};
/*
void *msg_name：一个指向存放目标协议地址的缓冲区的指针。在发送数据时，这个字段可以为 NULL。在接收数据时，这个字段指向一个套接字地址结构体，例如 struct sockaddr_in 或 struct sockaddr_un。
socklen_t msg_namelen：存放目标协议地址缓冲区的长度。这个字段只在 msg_name 不为 NULL 时有用。
struct iovec *msg_iov：一个指向 struct iovec 结构体的指针，用于指定要发送或接收的数据缓冲区和缓冲区大小。
int msg_iovlen：msg_iov 数组中元素的个数。
void *msg_control：一个指向辅助数据的指针，例如控制消息。在发送和接收数据时，这个字段通常为 NULL。
socklen_t msg_controllen：辅助数据的长度。
int msg_flags：一组标志位，用于指定如何处理消息。
*/
```

### recv 函数

用于从套接字接收数据的函数

```cpp
#include <sys/types.h>
#include <sys/socket.h>
ssize_t recv(int sockfd, void *buf, size_t len, int flags);
/*
sockfd：表示要接收数据的套接字文件描述符；
buf：表示接收数据的缓冲区地址；
len：表示缓冲区长度；
flags：通常设置为0，表示默认行为。
recv函数的返回值为实际接收到的字节数，如果返回0表示对端已关闭连接，如果返回-1表示出现错误，此时需要通过errno变量查看具体错误原因。
*/
```

flags 参数

```cpp
MSG_CMSG_CLOEXEC    为UNIX域套接字上接收的文件描述符设置执行时关闭标志
MSG_DONTWAIT    启用非阻塞操作（相当于使用O_NONBLOCK）
MSG_ERRQUEUE    接收错误信息作为辅助数据
MSG_OOB 如果协议支持，获取带外数据
MSG_PEEK    返回数据包内容而不真正取走数据包
MSG_TRUNC   即使数据包被阶段，也返回数据包的实际长度
MSG_WAITALL 等待直到所有的数据可用（仅SOCK_STREAM）
```

样例

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>

#define BUF_SIZE 1024

int main()
{
    int sockfd, connfd, n;
    char buf[BUF_SIZE];
    struct sockaddr_in servaddr;
    // 创建套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket error");
        exit(EXIT_FAILURE);
    }
    // 设置服务器地址
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(12345);
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    // 绑定套接字
    if (bind(sockfd, (struct sockaddr *)&servaddr, sizeof(servaddr)) == -1) {
        perror("bind error");
        exit(EXIT_FAILURE);
    }
    // 监听套接字
    if (listen(sockfd, 10) == -1) {
        perror("listen error");
        exit(EXIT_FAILURE);
    }
    // 接受客户端连接
    connfd = accept(sockfd, NULL, NULL);
    if (connfd == -1) {
        perror("accept error");
        exit(EXIT_FAILURE);
    }
    // 接收客户端发送的数据
    while ((n = recv(connfd, buf, BUF_SIZE, 0)) > 0) {
        printf("receive %d bytes: %s\n", n, buf);
    }
    // 关闭连接
    close(connfd);
    close(sockfd);
    return 0;
}
```

### recvfrom 函数

recvfrom() 函数是在 Unix 系统上用于接收数据的函数，特别适用于网络编程中的套接字通信。它用于从一个已连接或未连接的套接字接收数据，并将数据存储在指定的缓冲区中。

```cpp
#include <sys/types.h>
#include <sys/socket.h>
ssize_t recvfrom(int sockfd, void *buf, size_t len, int flags,
                    struct sockaddr *src_addr, socklen_t *addrlen);
```

参数说明：

- sockfd ：套接字描述符，用于标识要接收数据的套接字。
- buf ：指向接收数据的缓冲区。
- len ：缓冲区的大小，即可接收的最大字节数。
- flags ：接收操作的标志，通常设置为 0。
- src_addr ：指向发送方的地址信息的结构体指针，在接收到数据后，会填充发送方的地址信息。
- addrlen ：指向 src_addr 结构体的长度的指针。

recvfrom() 函数的返回值表示实际接收到的字节数，如果出现错误，则返回 -1。

```cpp
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
 #define PORT 8080
#define MAX_BUFFER_SIZE 1024
 int main() {
    int sockfd;
    struct sockaddr_in serverAddr, clientAddr;
    socklen_t addrLen = sizeof(clientAddr);
    char buffer[MAX_BUFFER_SIZE];
     // 创建套接字
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("socket creation failed");
        return -1;
    }
     // 绑定套接字到指定端口
    memset(&serverAddr, 0, sizeof(serverAddr));
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serverAddr.sin_port = htons(PORT);
     if (bind(sockfd, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) < 0) {
        perror("bind failed");
        return -1;
    }
     // 接收数据
    ssize_t numBytes = recvfrom(sockfd, buffer, MAX_BUFFER_SIZE, 0, (struct sockaddr*)&clientAddr, &addrLen);
    if (numBytes < 0) {
        perror("recvfrom failed");
        return -1;
    }
     // 打印接收到的数据
    printf("Received data: %s\n", buffer);
     // 关闭套接字
    close(sockfd);
     return 0;
}
```

在这个示例中，我们创建了一个 UDP 服务器，通过 recvfrom() 函数从客户端接收数据，并将接收到的数据打印出来。

### recvmsg 函数

recvmsg() 函数是在 Linux 系统上用于接收消息的函数，特别适用于网络编程中的套接字通信。它可以接收包含多个数据块的消息，并将消息的各个部分存储在指定的缓冲区中。

```cpp
#include <sys/types.h>
#include <sys/socket.h>
ssize_t recvmsg(int sockfd, struct msghdr *msg, int flags);
```

参数说明：

- sockfd ：套接字描述符，用于标识要接收消息的套接字。
- msg ：指向 msghdr 结构体的指针，用于存储接收到的消息的信息。
- flags ：接收操作的标志，通常设置为 0。 MSG_CTRUNC(控制数据被截断)、MSG_EOR(接收记录结束符)、MSG_ERRQUEUE(接收错误信息作为辅助数据)、MSG_OOB(接收带外数据)、MSG_TRUNC(一般数据被截断)

```cpp
struct msghdr {
    void         *msg_name;       // 指向发送方的地址信息的结构体指针
    socklen_t    msg_namelen;     // 发送方地址信息的长度
    struct iovec *msg_iov;        // 指向数据块的结构体指针数组
    int          msg_iovlen;      // 数据块的数量
    void         *msg_control;    // 指向辅助数据的指针
    socklen_t    msg_controllen;  // 辅助数据的长度
    int          msg_flags;       // 接收消息的标志
};
```

recvmsg() 函数的返回值表示实际接收到的字节数，如果出现错误，则返回 -1。

```cpp
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
 #define PORT 8080
#define MAX_BUFFER_SIZE 1024
 int main() {
    int sockfd;
    struct sockaddr_in serverAddr, clientAddr;
    socklen_t addrLen = sizeof(clientAddr);
    char buffer[MAX_BUFFER_SIZE];
    struct msghdr msg;
    struct iovec iov[1];
     // 创建套接字
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("socket creation failed");
        return -1;
    }
     // 绑定套接字到指定端口
    memset(&serverAddr, 0, sizeof(serverAddr));
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serverAddr.sin_port = htons(PORT);
     if (bind(sockfd, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) < 0) {
        perror("bind failed");
        return -1;
    }
     // 接收消息
    memset(&msg, 0, sizeof(msg));
    memset(&iov, 0, sizeof(iov));
    iov[0].iov_base = buffer;
    iov[0].iov_len = sizeof(buffer);
    msg.msg_iov = iov;
    msg.msg_iovlen = 1;
     ssize_t numBytes = recvmsg(sockfd, &msg, 0);
    if (numBytes < 0) {
        perror("recvmsg failed");
        return -1;
    }
     // 打印接收到的消息
    printf("Received message: %s\n", (char*)iov[0].iov_base);
     // 关闭套接字
    close(sockfd);
     return 0;
}
```

在这个示例中，我们创建了一个 UDP 服务器，通过 recvmsg() 函数从客户端接收消息，并将消息打印出来。

## 套接字选项

在这个示例中，我们创建了一个 UDP 服务器，通过 recvmsg() 函数从客户端接收消息，并将消息打印出来。

常用的套接字选项，除此之外有很多

1. SO_REUSEADDR ：允许重用处于 TIME_WAIT 状态的本地地址。这对于服务器程序在关闭后立即重新启动时很有用。
2. SO_KEEPALIVE ：启用 TCP 的心跳机制，用于检测连接是否仍然有效。
3. SO_SNDBUF 和 SO_RCVBUF ：分别用于设置发送缓冲区和接收缓冲区的大小。
4. SO_LINGER ：控制套接字关闭时的行为。如果设置了 SO_LINGER 选项并且时间为非零值，则 close() 函数将阻塞，直到所有未发送的数据都被发送或超时发生。
5. TCP_NODELAY ：禁用 Nagle 算法，允许小数据包立即发送。
6. IP_TTL ：设置 IP 数据包的生存时间（TTL）。

### setsockopt

套接字选项可以通过 setsockopt() 函数设置

```cpp
#include <sys/types.h>
#include <sys/socket.h>
int setsockopt(int sockfd, int level, int optname, const void *optval, socklen_t optlen);
```

- sockfd ：套接字描述符。
- level ：选项的级别，常见的级别包括 SOL_SOCKET 和 IPPROTO_TCP 。
- optname ：选项的名称。
- optval ：指向包含选项值的缓冲区的指针。
- optlen ：缓冲区的长度。

```cpp
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
 #define PORT 8080
 int main() {
    int sockfd;
    struct sockaddr_in serverAddr;
     // 创建套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket creation failed");
        return -1;
    }
     // 设置 SO_REUSEADDR 选项
    int reuse = 1;
    if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse)) < 0) {
        perror("setsockopt failed");
        return -1;
    }
     // 获取 SO_REUSEADDR 选项的值
    int reuseVal;
    socklen_t reuseLen = sizeof(reuseVal);
    if (getsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &reuseVal, &reuseLen) < 0) {
        perror("getsockopt failed");
        return -1;
    }
    printf("SO_REUSEADDR value: %d\n", reuseVal);
     // 关闭套接字
    close(sockfd);
     return 0;
}
```

### getsockopt

getsockopt() 函数是一个用于获取套接字选项值的函数。它可以用来查询套接字的属性和状态。

```cpp
#include <sys/types.h>
#include <sys/socket.h>
int getsockopt(int sockfd, int level, int optname, void *optval, socklen_t *optlen);
```

- sockfd ：套接字描述符。
- level ：选项的级别，常见的级别包括 SOL_SOCKET 和 IPPROTO_TCP 。
- optname ：选项的名称。
- optval ：指向存储选项值的缓冲区的指针。
- optlen ：指向存储缓冲区长度的变量的指针。

```cpp
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
 #define PORT 8080
 int main() {
    int sockfd;
    struct sockaddr_in serverAddr;
     // 创建套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket creation failed");
        return -1;
    }
     // 获取 SO_REUSEADDR 选项的值
    int reuseVal;
    socklen_t reuseLen = sizeof(reuseVal);
    if (getsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &reuseVal, &reuseLen) < 0) {
        perror("getsockopt failed");
        return -1;
    }
    printf("SO_REUSEADDR value: %d\n", reuseVal);
     // 关闭套接字
    close(sockfd);
     return 0;
}
```

## 带外数据

在 Linux C++ socket 编程中，带外数据（Out-of-Band data）是指在正常数据流之外传输的特殊数据。带外数据通常用于发送紧急信息或指示特殊事件的发生。TCP 将带外数据称为紧急数据。

在套接字编程中，可以使用 send() 函数的 MSG_OOB 标志来发送带外数据，使用 recv() 函数的 MSG_OOB 标志来接收带外数据。

```cpp
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
 #define PORT 8080
 int main() {
    int sockfd, newsockfd;
    struct sockaddr_in serverAddr, clientAddr;
    socklen_t addr_size;
    char buffer[1024];
     // 创建套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket creation failed");
        return -1;
    }
     // 设置套接字选项，允许发送和接收带外数据
    int oobInline = 1;
    if (setsockopt(sockfd, SOL_SOCKET, SO_OOBINLINE, &oobInline, sizeof(oobInline)) < 0) {
        perror("setsockopt failed");
        return -1;
    }
     // 绑定套接字到端口
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(PORT);
    serverAddr.sin_addr.s_addr = INADDR_ANY;
    memset(serverAddr.sin_zero, '\0', sizeof(serverAddr.sin_zero));
    if (bind(sockfd, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) < 0) {
        perror("bind failed");
        return -1;
    }
     // 监听连接
    if (listen(sockfd, 10) < 0) {
        perror("listen failed");
        return -1;
    }
     // 接受连接
    addr_size = sizeof(clientAddr);
    newsockfd = accept(sockfd, (struct sockaddr*)&clientAddr, &addr_size);
    if (newsockfd < 0) {
        perror("accept failed");
        return -1;
    }
     // 接收带外数据
    memset(buffer, '\0', sizeof(buffer));
    if (recv(newsockfd, buffer, sizeof(buffer), MSG_OOB) < 0) {
        perror("recv OOB failed");
        return -1;
    }
    printf("Received OOB data: %s\n", buffer);
     // 关闭套接字
    close(newsockfd);
    close(sockfd);
     return 0;
}
```

### fcntl

带外数据（Out-of-Band data）是在正常数据流之外传输的特殊数据。在 Linux C++ socket 编程中，可以使用 fcntl 函数和 sockatmark 函数来处理带外数据。

fcntl 函数可以用于获取或设置文件描述符的属性。对于套接字，可以使用 fcntl 函数来设置和检查带外数据的接收标志。

设置接收带外数据的标志：

```cpp
int enableOOB = 1;
if (setsockopt(sockfd, SOL_SOCKET, SO_OOBINLINE, &enableOOB, sizeof(enableOOB)) < 0) {
    perror("setsockopt failed");
    return -1;
}
```

上述代码将 SO_OOBINLINE 选项设置为 1，表示将带外数据与普通数据混合在一起接收。

检查是否接收到带外数据：

```cpp
int flags = fcntl(sockfd, F_GETFL, 0);
if (flags < 0) {
    perror("fcntl failed");
    return -1;
}
if (flags & OOB) {
    printf("Received Out-of-Band data\n");
}
```

上述代码使用 fcntl 函数获取套接字的标志，并检查是否设置了 OOB 标志，如果设置了，则表示接收到了带外数据。

### sockatmark

sockatmark 函数用于检查套接字的当前位置是否位于带外数据的边界（即下一次接收将接收到带外数据）。

```cpp
int atMark = sockatmark(sockfd);
if (atMark < 0) {
    perror("sockatmark failed");
    return -1;
}
if (atMark) {
    printf("At Out-of-Band data mark\n");
}
```

上述代码使用 sockatmark 函数检查套接字的当前位置是否位于带外数据的边界，如果是，则表示当前位置是带外数据的边界。

## 非阻塞和异步 IO

recv（read）函数没有数据时会阻塞等待、套接字输出队列没有足够空间来发送消息时，send 函数会阻塞。

非阻塞模式下，这些函数不会阻塞而会失败，将 errno 置为 EWOULDBLOCK 或者 EAGAIN,可以通过 select、poll、epoll 判断是否能接收或传输数据。

套接字异步 I/O 管理命令,详细的可以问 chatgpt

```cpp
fcntl(fd,F_SETOWN,pid)
ioctl(fd,FIOSETOWN,pid)
ioctl(fd,SIOCSPGRP,pid)
fcntl(fd,F_SETFL,flags|O_ASYNC)
ioctl(fd,FIOASYNC,&n)
```
