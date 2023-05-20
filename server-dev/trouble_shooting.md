# 网络通信故障排查命令

## ifconfig 命令

查看系统的网卡和IP地址信息

```bash
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.29.94.203  netmask 255.255.240.0  broadcast 172.29.95.255
        inet6 fe80::215:5dff:feb8:ec1d  prefixlen 64  scopeid 0x20<link>
        ether 00:15:5d:b8:ec:1d  txqueuelen 1000  (Ethernet)
        RX packets 18422  bytes 7165055 (7.1 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 13430  bytes 7452268 (7.4 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 277227  bytes 241178834 (241.1 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 277227  bytes 241178834 (241.1 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

部分选项

```bash
$ifconfig -s #精简列表，默认只显示已经激活的网卡信息，-a选项包含未激活的
$ifconfig 网卡名 up #激活网卡
$ifconfig 网卡名 down #禁用网卡
$ifconfig 网卡名 add IP地址 #将指定的IP地址绑定到某个网卡
$ifcofnig 网卡名 add IP地址 #从某个网卡上解绑某个IP地址
```

## ping 命令

ping命令通常用于检测本机到目标主机的网络是否通畅,ping命令是通过发ICMP数据包实现的

```bash
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ ping www.baidu.com
PING www.a.shifen.com (120.232.145.185) 56(84) bytes of data.
64 bytes from 120.232.145.185: icmp_seq=1 ttl=45 time=27.3 ms
64 bytes from 120.232.145.185: icmp_seq=2 ttl=45 time=26.7 ms
64 bytes from 120.232.145.185: icmp_seq=3 ttl=45 time=27.9 ms
64 bytes from 120.232.145.185: icmp_seq=4 ttl=45 time=27.4 ms
^C
--- www.a.shifen.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 7246ms
rtt min/avg/max/mdev = 26.719/27.324/27.918/0.425 ms
```

## telnet 命令

Telnet是一种用于远程登录或远程管理设备的网络协议，也是对应的命令行工具。它可以用于与远程主机建立基于文本的会话，并执行各种操作，如远程登录、端口连接和数据交互等。以下是Telnet命令的基本用法：

```bash
telnet [选项] <主机> [端口]
```

其中，主机是要连接的远程主机的IP地址或域名，端口是远程主机上要连接的端口号（可选，默认为23）。以下是一些常用的Telnet命令选项：

* -l <用户名>：指定远程登录的用户名。
* -p <端口>：指定远程主机上的端口号。
* -E：在文本行上使用ASCII转义字符（ASCII Escape character）。
* -e <字符>：设置本地终端上的特殊字符（默认为Ctrl+]）。

```bash
#远程登录主机
telnet example.com
#连接远程主机的指定端口,默认端口23
telnet example.com 8080
#使用用户名进行远程登录
telnet example.com -l username
#在连接建立后发送ASCII转义字符（如Ctrl+l）
telnet example.com -E
#使用自定义的本地特殊字符
telnet example.com -e @
```

请注意，由于Telnet协议是明文传输的，安全性较低，因此在实际使用中建议使用更安全的替代协议，如SSH。

## netstat 命令

Netstat是一个用于监控网络连接和网络统计信息的命令行工具。它可以显示当前计算机上的活动网络连接、监听端口、路由表、网络接口统计信息等。以下是Netstat命令的基本用法：

```bash
netstat [选项]
```

以下是一些常用的Netstat命令选项：

* -a：显示所有连接和监听端口。
* -t：显示TCP连接。
* -u：显示UDP连接。
* -n：以数字形式显示IP地址和端口号。
* -p：显示与连接关联的进程/程序。
* -r：显示路由表信息。
* -s：显示网络接口和协议统计信息。
* -l：显示仅处于监听状态的端口。

```bash
#显示所有活动的TCP和UDP连接
netstat -a
```

## lsof 命令

lsof（"list open files"）是一个用于列出正在被打开的文件和与之关联的进程的命令行工具。它可以显示当前系统中打开的文件、网络连接、目录等相关信息。以下是lsof命令的基本用法：

```bash
lsof [选项]
```

以下是一些常用的lsof命令选项：  

* -i：显示与网络相关的打开文件。
* -u <用户名>：显示指定用户名的进程打开的文件。
* -c <进程名>：显示指定进程名相关的打开文件。
* -p <进程ID>：显示指定进程ID相关的打开文件。
* -f <文件名>：显示与指定文件名匹配的打开文件。
* -r <秒数>：持续监视打开文件，并每隔指定秒数自动刷新结果。
* -n：禁用主机名解析。
* -t <文件类型>：显示指定类型的打开文件（如IPv4、IPv6、TCP、UDP等）。

```bash
#显示所有打开的文件
lsof
#显示与网络相关的打开文件
lsof -i
#显示指定用户名的进程打开的文件
lsof -u username
#显示指定进程名相关的打开文件
lsof -c processname
#显示指定进程ID相关的打开文件
lsof -p 1234
#显示与指定文件名匹配的打开文件
lsof -f myfile.txt
#持续监视打开文件并每隔2秒刷新结果
lsof -r 2
#显示指定类型的打开文件（如IPv4、TCP等）
lsof -t tcp
```

## nc 命令

nc（netcat）是一个功能强大的网络工具，用于在命令行中进行网络连接和数据传输。它可以用于创建 TCP/IP 连接、发送和接收数据，以及作为端口扫描工具。以下是nc命令的基本用法：

```bash
nc [选项] <主机> <端口>
```

其中，主机是要连接的目标主机的 IP 地址或域名，端口是目标主机上的端口号。以下是一些常用的nc命令选项：

* -l：监听模式，将nc作为服务器端进行侦听。
* -p <本地端口>：指定本地端口号。
* -u：使用 UDP 协议。
* -v：显示详细输出。
* -n：禁用主机名解析。
* -z：端口扫描模式，用于测试远程主机上的端口是否开放。

```bash
#连接到远程主机的指定端口
nc example.com 80
#在监听模式下作为服务器侦听指定端口
nc -l 8080
#使用 UDP 协议连接到远程主机的指定端口
nc -u example.com 1234
#在监听模式下使用指定的本地端口
nc -l -p 8080
#描远程主机上的指定端口是否开放
nc -z example.com 22
```

## curl 命令

curl是一个功能强大的命令行工具，用于与服务器进行数据交互，支持多种协议，如HTTP、HTTPS、FTP等。它可以发送请求、接收响应，并提供各种选项来控制请求的行为。以下是curl命令的基本用法：

```bash
curl [选项] <URL>
```

其中，URL是要访问的目标URL地址。以下是一些常用的curl命令选项：

* -X <请求方法>：指定HTTP请求方法，如GET、POST等。
* -H <请求头>：指定HTTP请求头。
* -d <数据>：发送POST请求时附带的数据。
* -o <输出文件>：将响应保存到指定的输出文件。
* -s：静默模式，不显示进度和错误信息。
* -i：显示响应头信息。
* -L：自动跟随重定向。
* -u <用户名:密码>：指定HTTP基本身份验证的用户名和密码。
* -k：忽略SSL证书验证。
* -X <代理服务器>：使用指定的代理服务器进行请求。

```bash
#发送GET请求并输出响应
curl http://example.com
#发送POST请求并附带数据
curl -X POST -d "key1=value1&key2=value2" http://example.com
#将响应保存到文件
curl -o output.txt http://example.com/file.txt
#发送带有自定义请求头的请求
curl -H "Content-Type: application/json" http://example.com/api
#显示响应头信息
curl -i http://example.com
#使用HTTP基本身份验证发送请求
curl -u username:password http://example.com
#忽略SSL证书验证
curl -k https://example.com
#使用代理服务器发送请求
curl -x proxy-server:port http://example.com
```

## tcpdump 命令

tcpdump是一个强大的命令行网络抓包工具，用于捕获和分析网络流量。它可以监听网络接口上的数据包，并显示或保存它们的内容。tcpdump支持多种协议，如TCP、UDP、ICMP等，并提供丰富的过滤选项和输出格式。以下是tcpdump命令的基本用法：

```bash
tcpdump [选项] [过滤表达式]
```

以下是一些常用的tcpdump命令选项：

* -i <接口>：指定要监听的网络接口。
* -c <数量>：指定要捕获的数据包数量。
* -s <长度>：指定要捕获的数据包的最大长度。
* -w <文件名>：将捕获的数据包保存到指定的文件中。
* -r <文件名>：从指定的文件中读取数据包进行分析。
* -A：以ASCII文本格式显示数据包的内容。
* -X：以十六进制和ASCII混合格式显示数据包的内容。
* -n：禁用主机名解析。
* -v：显示详细的输出。
* -q：静默模式，只显示必要的输出。

请注意，tcpdump命令需要以超级用户（root）或具有适当权限的用户身份运行，以便访问网络接口并捕获数据包。

```bash
#监听指定网络接口上的所有数据包
tcpdump -i eth0
#指定捕获的数据包数量
tcpdump -c 100
#将捕获的数据包保存到文件中
tcpdump -w capture.pcap
#从文件中读取数据包进行分析
tcpdump -r capture.pcap
#以ASCII文本格式显示数据包内容
tcpdump -A
#以十六进制和ASCII混合格式显示数据包内容
tcpdump -X
#禁用主机名解析
tcpdump -n
#显示详细的输出
tcpdump -v
``