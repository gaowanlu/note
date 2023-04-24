---
coverY: 0
---

# 第 18 章 网络 IPC 套接字

## 网络 IPC 套接字

Linux系统编程中，网络套接字（socket）是一个重要的概念。套接字是一种在网络上进行通信的工具，通过套接字可以建立客户端和服务器之间的连接，并进行数据的传输。

在Linux系统中，网络套接字是一种特殊的文件描述符，可以通过调用系统函数来创建、连接、发送和接收数据。常用的套接字类型包括TCP套接字和UDP套接字，它们分别用于建立可靠的连接和不可靠的连接。

在编程中，需要使用套接字相关的系统函数来进行网络通信。常用的系统函数包括socket()、bind()、listen()、accept()、connect()、send()和recv()等。其中，socket()函数用于创建套接字，bind()函数用于将套接字与一个地址绑定，listen()函数用于监听连接请求，accept()函数用于接受连接，connect()函数用于建立连接，send()函数用于发送数据，recv()函数用于接收数据。

网络套接字在Linux系统编程中是一个非常重要的概念，它是实现网络通信的基础。了解套接字的概念和相关系统函数的使用方法，可以帮助开发人员编写高效、可靠的网络应用程序。

### 大小端字节序

大小端字节序是指在多字节数据类型（如int、long、float等）的存储过程中，字节的存储顺序不同。  

在大端字节序中，高位字节存放在低地址，低位字节存放在高地址；  
而在小端字节序中，低位字节存放在低地址，高位字节存放在高地址。

```cpp
        2            3
大端： 0000 0010   0000 0011
小端： 0100 0000   1100 0000
    低地址--------->高地址
```

在Linux系统编程中，处理器架构可能是大端字节序或小端字节序，因此需要特别注意在网络通信中字节序的处理。

重点：IO和网络IO时永远是低地址的内容先出去

#### 字节序转换函数

网络通信中通常使用大端字节序（也称为网络字节序）作为标准字节序。为了保证跨平台通信的正确性，需要将本地字节序（即处理器架构字节序）与网络字节序进行转换。可以使用htonl()、htons()、ntohl()和ntohs()等系统函数来完成字节序的转换。

```cpp
//本地字节序转网络字节序
#include <arpa/inet.h>
uint32_t htonl(uint32_t hostlong);
uint16_t htons(uint16_t hostshort);
//网络字节序转本地字节序
uint32_t ntohl(uint32_t netlong);
uint16_t ntohs(uint16_t netshort);
```

### 字节对齐

请见C++内容中的字节对齐，在网络编程中一般会采取不对齐处理

[字节对齐跳转](/c++-even-better/yu-yan-ji-chu/c++-primer-ting-shuo-hen-nan/di-si-bu-fen-gao-ji-zhu-ti/di-19-zhang-te-shu-gong-ju-yu-ji-shu#nei-cun-zi-jie-dui-qi)

### 类型长度问题

在C中int、char等，并没有规定一定的长度大小，可能不同环境下会有不同，为了解决此问题，一般会采取以下固定长度整数类型进行使用

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

### 套接字描述符

在Linux系统编程中，套接字描述符是一种重要的概念，它是一种用于进行网络通信的抽象概念，类似于文件描述符，用于标识和管理网络连接

在Linux中，套接字描述符是一个整数，它唯一标识一个网络连接。套接字描述符通常由socket()函数创建，bind()和connect()函数绑定和连接网络端点，send()和recv()函数进行数据传输，close()函数关闭套接字。

#### socket函数

socket()函数是用于创建套接字的系统调用。套接字是一种抽象的通信机制，用于在网络上进行数据传输和通信。

```cpp
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
int socket(int domain, int type, int protocol);
返回值：若成功，返回文件描述符；若出错，返回-1
```

套接字通信域domain：

```cpp
AF_INET IPv4因特网域
AF_INET6 Ipv6因特网域
AF_UNIX UNIX域
AF_UNSPEC 未指定
```

套接字类型type：

```cpp
SOCK_DGRAM 固定长度的、无连接的、不可靠的报文传递
SOCK_RAW IP协议的数据报接口
SOCK_SEQPACKET 固定长度的、有序的、可靠的、面向连接的报文传递
SOCK_STREAM 有序的、可靠的、双向的、面向连接的字节流
```

为因特网域套接字定义的协议protocol：

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

#### 文件描述符函数使用套接字时的行为

![文件描述符函数使用套接字时的行为](../../.gitbook/assets/屏幕截图2023-04-23003354.jpg)

#### shutdown函数

shutdown函数是一个系统调用，用于关闭一个已经连接的套接字或禁止其读写操作。它位于头文件<sys/socket.h>中，并具有以下原型：

```cpp
#include <sys/socket.h>
int shutdown(int socket, int how);
```

socket为已经连接的套接字描述符，how指定关闭的方式：

```cpp
SHUT_RD:关闭套接字的读取功能，即禁止套接字接收数据。
SHUT_WR：关闭套接字的写入功能，即禁止套接字发送数据。
SHUT_RDWR：关闭套接字的读写功能，即禁止套接字读取和发送数据。
```

shutdown函数可以用于关闭一个已连接的套接字或禁止其读写操作，以此来表示通信结束或出现错误等情况。需要注意的是，调用该函数不会立即关闭套接字，而是将套接字置于一个特殊的状态，直到所有未发送的数据都被发送完毕或者被丢弃为止。在调用shutdown函数之后，应用程序仍然需要通过close函数关闭套接字描述符。

如果shutdown函数调用成功，返回值为0。如果发生错误，返回值为-1，并设置相应的错误代码，可以通过errno变量获取。

### 寻址

进程标识由两部分组成，一部分是计算机的网络地址，它可以帮助标识网络上我们想与之通信的计算机；另一部分是该计算机上用端口号表示的服务，它可以帮助标识特定的进程。

#### 地址格式

网络地址通常使用IPv4或IPv6地址格式。IPv4地址是32位的地址，通常表示为四个数字，每个数字之间用点号分隔。例如，192.168.1.1就是一个IPv4地址。

IPv6地址是128位的地址，通常表示为8组4位十六进制数，每组之间用冒号分隔。例如，2001:0db8:85a3:0000:0000:8a2e:0370:7334就是一个IPv6地址。

此外，还有一些其他的网络地址格式，如MAC地址和网络掩码等。MAC地址是48位的地址，通常表示为12个十六进制数，每个数之间用冒号或连字符分隔。网络掩码是用于子网划分的一种地址格式，它通常与IPv4地址一起使用，表示一个子网的地址范围。

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

#### inet_ntop函数

inet_ntop()函数是一个网络编程中常用的函数，用于将网络字节序的IP地址转换为字符串格式

```cpp
#include <arpa/inet.h>
const char *inet_ntop(int af, const void *src, char *dst, socklen_t size);
```

其中，af参数指定了地址族类型，可以是AF_INET（IPv4）或AF_INET6（IPv6）；src参数是指向存储IP地址的指针；dst参数是指向存储转换后的字符串的指针；size参数指定了dst指针指向的缓冲区的大小。

inet_ntop()函数成功转换IP地址时，返回值是指向转换后的字符串的指针。如果出现错误，返回值为NULL，并且可以通过调用errno来获取错误码。

IPv4代码样例

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

IPv6代码样例

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

#### inet_pton函数

用于将字符串格式的IP地址转换为网络字节序的二进制格式

```cpp
#include <arpa/inet.h>
int inet_pton(int af, const char *src, void *dst);
```

其中，af参数指定了地址族类型，可以是AF_INET（IPv4）或AF_INET6（IPv6）；src参数是指向存储字符串格式IP地址的指针；dst参数是指向存储转换后的二进制格式IP地址的指针。

inet_pton()函数成功转换IP地址时，返回值为1。如果出现错误，返回值为0，并且可以通过调用errno来获取错误码。

IPv4样例

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

IPv6样例

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

#### /etc/hosts文件

/etc/hosts文件是一个文本文件，用于将主机名映射到IP地址，或者将别名映射到主机名。在Linux和Unix系统中，每个主机都有一个/etc/hosts文件，用于本地解析域名。

/etc/hosts文件中每一行都表示一条主机名和地址的映射关系，格式如下：

```cpp
IP地址 主机名 别名
```

其中，IP地址是指主机的IP地址，主机名是指主机的名称，别名是指主机的别名，可以有多个别名。每个字段之间使用空格或制表符进行分隔。

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

#### 解析/etc/hosts内容

1、结构体struct hostent 用于存储主机的信息

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

2、gethostent、sethostent、endhostent函数

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

#### /etc/networks文件

/etc/networks是一个文本文件，包含已知网络的名称、网络号、子网掩码等信息，是一个网络数据库(network database),用于在系统中解析网络名称和地址

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

#### 解析/etc/networks文件

1、结构体struct netent

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
endnetent函数

getnetbyaddr函数用于获取指定网络地址的网络条目信息。net参数是网络地址，以网络字节序存储，type参数表示地址类型，通常为AF_INET（IPv4）。如果找到对应的网络条目，则返回一个指向struct netent结构体的指针，否则返回NULL。

```cpp
#include <netdb.h>
struct netent *getnetbyaddr(uint32_t net, int type);
```

getnetbyname函数用于获取指定网络名称的网络条目信息。name参数是网络名称。如果找到对应的网络条目，则返回一个指向struct netent结构体的指针，否则返回NULL。

```cpp
#include <netdb.h>
struct netent *getnetbyname(const char *name);
```

getnetent函数用于按顺序读取网络数据库中的每个条目。如果找到下一个网络条目，则返回一个指向struct netent结构体的指针，否则返回NULL。

```cpp
#include <netdb.h>
struct netent *getnetent(void);
```

setnetent函数用于打开网络数据库文件/etc/networks，并将文件指针设置为文件开头，以便逐条读取网络条目信息。如果stayopen参数不为0，则保持数据库打开状态以供后续函数使用；否则在每次打开和读取时打开和关闭数据库。

```cpp
#include <netdb.h>
void setnetent(int stayopen);
```

endnetent函数用于关闭网络数据库文件/etc/networks，以便释放资源。

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

#### /etc/protocols文件

系统的协议数据库文件，即/etc/protocols文件。该文件是一个文本文件，其中每一行表示一个协议条目，具有如下格式：

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

#### 解析/etc/protocols文件

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

#### /etc/services文件

/etc/services文件，存储服务条目的信息，其每一行表示一个服务条目

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

#### 解析/etc/services文件

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

#### getaddrinfo、freeaddrinfo、struct addrinfo、addrinfo结构的标志  

```cpp

```

#### gai_strerror、getnameinfo、getnameinfo函数的标志

```cpp

```

#### 将套接字与地址关联

```cpp
bind、getsockname、getpeername
```

### 建立连接

```cpp
connect
listen
accept
```

### 数据传输

```cpp
send
sendto
struct msghdr
recv
recvfrom
recvmsg
```

### 套接字选项

```cpp
setsockopt
getsockopt
```

### 带外数据

```cpp
fcntl
sockatmark
```

### 非阻塞和异步 IO

相关控制函数
