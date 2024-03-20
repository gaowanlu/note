# UDP

## UDP

虽然虽然是无连接的，然是公网服务器仍然可以给发送者进行回包，甚至可以绕过NAT成为很多NAT内网穿透的基础，也成为打洞

### 实现服务端与客户端

服务端 udp_server.cpp

```cpp
// g++ udp_server.cpp udp_component.cpp -o udp_server.exe --std=c++11
#include <iostream>
#include "udp_component.h"
using namespace std;
using namespace tubekit::ipc;

int main(int argc, char **argv)
{
    udp_component udp;
    uint64_t recv_count = 0;

    udp.tick_callback = [&udp](bool &to_stop)
    {
        // std::cout<<"on_tick"<<std::endl;
    };

    udp.message_callback = [&udp, &recv_count](const char *buffer, ssize_t len, sockaddr_in &addr)
    {
        ++recv_count;
        std::cout << std::string(buffer, len) << " recv_count " << recv_count << std::endl;
        // pingpong
        udp.udp_component_client("", 0,
                                 buffer,
                                 len,
                                 (sockaddr *)&addr,
                                 sizeof(addr));
    };

    udp.close_callback = [&udp]()
    {
        // close callback
    };

    udp.udp_component_server("0.0.0.0", 20025);

    return 0;
}
```

客户端 udp_client.cpp

```cpp
// g++ udp_client.cpp udp_component.cpp -o udp_client.exe --std=c++11
#include <iostream>
#include "udp_component.h"
using namespace std;
using namespace tubekit::ipc;

int main(int argc, char **argv)
{
    udp_component udp;
    uint64_t pingpong_count = 0;

    udp.tick_callback = [&udp](bool &to_stop)
    {
        // std::cout<<"on_tick"<<std::endl;
    };

    udp.message_callback = [&udp, &pingpong_count](const char *buffer, ssize_t len, sockaddr_in &addr)
    {
        // 这里接受包不一定来自172.29.94.203 而是像172.29.94.203:20025发数据时 使用了一个端口 IP:A 只要有外界向IP:A发消息 如果接收到了则这里就会接收到
        pingpong_count++;
        std::cout << std::string(buffer, len) << " pingpong_count " << pingpong_count << std::endl;
        // pingpong
        udp.udp_component_client("", 0,
                                 buffer,
                                 len,
                                 (sockaddr *)&addr,
                                 sizeof(addr));
    };

    udp.close_callback = [&udp]()
    {
        // close callback
    };

    udp.udp_component_client("172.29.94.203", 20025, "pingpong", 8);
    return 0;
}
```

### udp_component

头文件 udp_component.h

```cpp
#include <iostream>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <fcntl.h>
#include <cstring>
#include <string>
#include <sys/epoll.h>
#include <functional>

namespace tubekit
{
    namespace ipc
    {
        class udp_component
        {
        public:
            ~udp_component();
            std::string udp_component_get_ip(struct sockaddr_in &addr);
            int udp_component_get_port(struct sockaddr_in &addr);

            int udp_component_server(const std::string &IP,
                                     const int PORT);

            int udp_component_client(const std::string &IP,
                                     const int PORT,
                                     const char *buffer,
                                     ssize_t len,
                                     struct sockaddr *addr = nullptr,
                                     socklen_t addr_len = 0);

        private:
            int event_loop();
            int init_sock();
            void to_close();

        private:
            int m_socket_fd{0};
            int m_epoll_fd{0};

        public:
            std::function<void(bool &to_stop)> tick_callback{nullptr};
            std::function<void(const char *buffer, ssize_t len, struct sockaddr_in &)> message_callback{nullptr};
            std::function<void()> close_callback{nullptr};
        };
    }
}
```

源码 udp_component.cpp

```cpp
#include "udp_component.h"

namespace tubekit
{
    namespace ipc
    {
        static int udp_component_setnonblocking(int fd)
        {
            int flags = fcntl(fd, F_GETFL, 0);
            if (flags == -1)
            {
                perror("error getting fd flags");
                return -1;
            }
            if (fcntl(fd, F_SETFL, flags | O_NONBLOCK) == -1)
            {
                perror("error setting non-bloking mode");
                return -1;
            }
            return 0;
        }

        udp_component::~udp_component()
        {
            to_close();
        }

        void udp_component::to_close()
        {
            if (m_socket_fd > 0)
            {
                close(m_socket_fd);
            }
            if (m_epoll_fd > 0)
            {
                close(m_epoll_fd);
            }
            if (close_callback)
            {
                close_callback();
            }
        }

        int udp_component::init_sock()
        {
            int &server_socket_fd = m_socket_fd;
            if (server_socket_fd <= 0)
            {
                server_socket_fd = ::socket(AF_INET, SOCK_DGRAM, 0);
                if (server_socket_fd == -1)
                {
                    perror("error creating socket");
                    return -1;
                }
            }
            return 0;
        }

        std::string udp_component::udp_component_get_ip(struct sockaddr_in &addr)
        {
            char ip[INET_ADDRSTRLEN];
            inet_ntop(AF_INET, &(addr.sin_addr), ip, INET_ADDRSTRLEN);
            return std::string(ip, INET_ADDRSTRLEN);
        }

        int udp_component::udp_component_get_port(struct sockaddr_in &addr)
        {
            unsigned short port = ntohs(addr.sin_port);
            return port;
        }

        int udp_component::udp_component_server(const std::string &IP,
                                                const int PORT)
        {
            const int int_port = PORT;

            // create udp socket
            int &server_socket_fd = m_socket_fd;
            if (server_socket_fd <= 0)
            {
                if (0 != init_sock())
                {
                    perror("Error creating socket");
                    return -1;
                }
            }

            // setting server addr
            struct sockaddr_in server_addr;
            bzero(&server_addr, sizeof(server_addr));

            server_addr.sin_family = AF_INET;
            server_addr.sin_addr.s_addr = inet_addr(IP.c_str());
            server_addr.sin_port = htons(int_port);

            // server bind addr
            if (-1 == bind(server_socket_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)))
            {
                perror("error binding socket");
                to_close();
                return -1;
            }

            // port reuse
            int reuse = 1;
            if (-1 == setsockopt(server_socket_fd, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse)))
            {
                perror("Error setting socket options");
                to_close();
                return -1;
            }
            return event_loop();
        }

        int udp_component::udp_component_client(const std::string &IP,
                                                const int PORT,
                                                const char *buffer,
                                                ssize_t len,
                                                struct sockaddr *addr /*=nullptr*/,
                                                socklen_t addr_len /*=0*/)
        {
            int &client_socket = m_socket_fd;
            if (client_socket <= 0)
            {
                if (0 != init_sock())
                {
                    perror("Error creating socket");
                    return -1;
                }
            }

            sockaddr_in server_addr;
            std::memset(&server_addr, 0, sizeof(server_addr));

            // server addr
            if (IP != "" && PORT != 0)
            {
                server_addr.sin_family = AF_INET;
                server_addr.sin_addr.s_addr = inet_addr(IP.c_str());
                server_addr.sin_port = htons(PORT);
            }
            else if (addr && addr_len > 0)
            {
            }
            else
            {
                perror("IP PORT and addr addr_len");
                return -1;
            }

            ssize_t bytesSent = 0;

            if (addr)
            {
                bytesSent = sendto(client_socket, buffer, len, 0,
                                   addr, addr_len);
            }
            else
            {
                bytesSent = sendto(client_socket, buffer, len, 0,
                                   (sockaddr *)&server_addr, sizeof(server_addr));
            }

            if (bytesSent != len)
            {
                perror("Error sending message bytesSent != len");
                to_close();
                return -1;
            }

            if (addr == nullptr)
            {
                return event_loop();
            }

            return 0;
        }

        int udp_component::event_loop()
        {
            int &server_socket_fd = m_socket_fd;
            if (server_socket_fd <= 0)
            {
                perror("eventloop err server_socket_fd <= 0");
                return -1;
            }

            // set nonblocking
            if (udp_component_setnonblocking(server_socket_fd) == -1)
            {
                to_close();
                perror("udp_component_setnonblocking err");
                return -1;
            }

            // create epoll instance
            m_epoll_fd = epoll_create(1);
            int &epoll_fd = m_epoll_fd;
            if (epoll_fd == -1)
            {
                perror("error creating epoll");
                to_close();
                return -1;
            }

            // add server fd to epoll's listen list
            epoll_event event;
            bzero(&event, sizeof(event));
            event.data.fd = server_socket_fd;
            event.events = EPOLLIN;
            if (-1 == epoll_ctl(epoll_fd, EPOLL_CTL_ADD, server_socket_fd, &event))
            {
                perror("error adding server socket to epoll");
                to_close();
                return -1;
            }

            // event loop
            constexpr int MAX_EVENTS_NUM = 1;
            sockaddr_in client_addr;
            socklen_t addr_len = sizeof(client_addr);
            epoll_event events[MAX_EVENTS_NUM];
            bzero(&events[0], sizeof(events));
            int events_num = 0;

            bzero(&client_addr, sizeof(client_addr));
            constexpr int buffer_size = 65507;
            char buffer[buffer_size];
            bzero(buffer, sizeof(buffer));

            do
            {
                events_num = epoll_wait(epoll_fd, events, MAX_EVENTS_NUM, 10); // 10ms

                // tick
                {
                    if (tick_callback)
                    {
                        bool to_stop = false;
                        tick_callback(to_stop);
                        if (to_stop)
                        {
                            to_close();
                            return 0;
                        }
                    }
                }

                if (0 == events_num)
                {
                    continue;
                }
                else if (0 > events_num)
                {
                    perror("0 > events_num");
                    to_close();
                    return -1;
                }

                for (int i = 0; i < events_num; ++i)
                {
                    if (events[i].data.fd == server_socket_fd)
                    {
                        // have new message
                        ssize_t bytes = recvfrom(server_socket_fd, buffer, buffer_size, 0, (struct sockaddr *)&client_addr, (socklen_t *)&addr_len);

                        // process recved data
                        if (bytes > 0)
                        {
                            if (message_callback)
                            {
                                message_callback(buffer, bytes, client_addr);
                            }
                        }
                    }
                }
            } while (true);
            return 0;
        }
    }
}
```

### UDP穿透

#### UDP穿透作用

假设两台主机分别位于两个局域网中，这两台主机不能直接通过TCP建立连接（TCP连接需要固定的ip和端口，通常路由器或者本机防火墙是不会将这个暴露在外的）。这时可以通过 UDP穿透来实现两台主机的跨局域网通信（当然前提是需要一台公网服务器）。

#### UDP穿透原理

1. 公网服务器开启一个UDP监听套接字
2. 主机1向公网服务器发送UDP报文，此时公网服务器就能知道主机1的ip和端口（此时的这个ip和端口是不会受到防火墙的限制的，因为是主机的主动行为），公网服务器存储该地址
3. 同样的，主机2向公网服务器发送UDP报文，此时公网服务器就能知道主机2的ip和端口，公网服务器存储该地址
4. 公网服务器收集到这两个地址以后，分别将对方的地址返还，公网服务器就可以关闭了
5. 主机1收到主机2的地址，主机2收到主机1的地址，只要它们不关闭套接字，就可以向对方发送UDP（UDP只管收，并不关心谁发的，发的啥）

#### UDP穿透实例

服务器布设在远程linux服务器上 ip：47.113.150.167

局域网主机环境是windows

服务器代码：

```cpp
#include <cstdio>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netdb.h>
#include<iostream>
#define BUF_SIZE 30
//using namespace std;
/*
* 服务器
*/
int main()
{
    int serverSocket;
    sockaddr_in serverAddress, clientAddress;
    sockaddr_in clientAddress1, clientAddress2;
    int flagAddress1 = 0, flagAddress2 = 0;
    char message[BUF_SIZE];
    int str_len;
    socklen_t clientAddressLen;
    serverSocket = socket(AF_INET, SOCK_DGRAM, 0);
    memset(&serverAddress, 0, sizeof(serverAddress));
    memset(&clientAddress, 0, sizeof(serverAddress));
    memset(&clientAddress1, 0, sizeof(serverAddress));
    memset(&clientAddress2, 0, sizeof(serverAddress));
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_addr.s_addr = htonl(INADDR_ANY);
    serverAddress.sin_port = htons(8888);
    bind(serverSocket, (struct sockaddr*)&serverAddress, sizeof(serverAddress));
    while (1)
    {
        clientAddressLen = sizeof(sockaddr);
        std::cout << "等待接受来自客户端的UDP数据报....." << std::endl;
        //接收消息
        str_len = recvfrom(serverSocket, message, BUF_SIZE, 0, (sockaddr*)&clientAddress, &clientAddressLen);
        //打印客户端信息
        std::cout << "客户端地址：" << clientAddress.sin_addr.s_addr << std::endl;
        std::cout << "客户端端口：" << clientAddress.sin_port << std::endl;
        std::cout << "UDP内容:" << message << std::endl;
        if (flagAddress1 == 0) {
            memcpy(&clientAddress1, &clientAddress, sizeof(clientAddress));
            flagAddress1 = 1;
        }
        else if (flagAddress2 == 0) {
            memcpy(&clientAddress2, &clientAddress, sizeof(clientAddress));
            flagAddress2 = 1;
        }

        if (flagAddress1 == 1 && flagAddress2 == 1) {   //UDP双方准备就绪   将地址分别发给对方
            sendto(serverSocket, (void*)&clientAddress1, sizeof(clientAddress1), 0, (struct sockaddr*)&clientAddress2, sizeof(clientAddress2));
            sendto(serverSocket, (void*)&clientAddress2, sizeof(clientAddress2), 0, (struct sockaddr*)&clientAddress1, sizeof(clientAddress1));
            break;   //该服务器可以关闭了
        }
       
    }
    close(serverSocket);
    return 0;
}
```

局域网主机端代码：

```cpp
//局域网主机端代码
#define _WINSOCK_DEPRECATED_NO_WARNINGS
#include <WinSock2.h>
#include <iostream>
#pragma comment(lib, "ws2_32.lib")
using namespace std;
int main()
{
    // 加载套接字库
    WORD wVersion;
    WSADATA wsaData;
    int err;
    wVersion = MAKEWORD(1, 1);
    err = WSAStartup(wVersion, &wsaData);
    if (err != 0)
    {
        return err;
    }
    if (LOBYTE(wsaData.wVersion) != 1 || HIBYTE(wsaData.wVersion) != 1)
    {
        WSACleanup();
        return -1;
    }

    // 创建套接字
    SOCKET sockCli = socket(AF_INET, SOCK_DGRAM, 0);
    sockaddr_in addrSrv, addTarget;
    addrSrv.sin_addr.s_addr = inet_addr("192.168.147.128");
    addrSrv.sin_port = htons(8888);
    addrSrv.sin_family = AF_INET;

    int len = sizeof(sockaddr);
    char buff[100] = "hello i am client!";
    //发送数据   获取目标主机UDP地址到addTarget
    cout << sendto(sockCli, buff, strlen(buff), 0, (sockaddr*)&addrSrv, sizeof(sockaddr)) << endl;
    cout << "等待服务器反馈！" << endl;
    recvfrom(sockCli, (char*)&addTarget, sizeof(addTarget), 0, (sockaddr*)&addrSrv, &len);
    cout <<"目标主机ip:" << addTarget.sin_addr.s_addr << endl;
    cout << "目标主机端口:" << addTarget.sin_port << endl;
    closesocket(sockCli);
    system("pause");
    return 0;

}
```
