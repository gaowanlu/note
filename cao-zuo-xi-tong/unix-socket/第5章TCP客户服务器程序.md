---
coverY: 0
---

# 第5章 TCP客户/服务器程序实例

## TCP客户/服务器程序实例

### 未完待续

* 构建多进程服务端，服务端进程socket bind listen accept,当accept返回时进行fork，有一些如父进程关闭已连接套接字、子进程关闭监听套接字等细节  
* 子进程进行read，当被中断返回-1且errno==EINTR时则再次read、返回-1但errno!=EINTR则读取发生错误  
* 客户端进行socket connect,然后接收标准输入的内容，接收后将输入的内容write给服务端，然后进行readline操作等待响应，接收到响应内容过后进行标注输出  
* 本章简直是三次握手与四次挥手的升华
* 当服务端listen调用后，客户端已经可以向服务端进行三次握手操作，尽管服务端还没有进行accept操作，客户端接收到ACK后connect就能返回，而accept只有接收到客户端发送的第三个分解ACK才能accept返回，accept比connect返回多半个RTT。
* 正常终止：服务端当接收到FIN时，发送ACK、read返回0，然后子进程关闭已连接套接字引发TCP连接终止序列的两个分节的进行发一个FIN，收一个ACK，子进程终止时项父进程发送一个SIGCHLD信号，默认处理为忽略。如果父进程没有处理则子进程进入僵死状态，所以我们必须清理僵死进程  
* POSIX信号：信号的来源，一个进程给另一个进程发送，由内核向某个进程发送。可以设置回调函数当接收到响应种类的信号时，执行自定义的函数  

```cpp
void handler(int signo); 自定义
SIG_IGN 忽略
SIG_DFL 默认

#include <signal.h>
int sigaction(int signum, const struct sigaction *act,
                     struct sigaction *oldact);
signum为信号名，act为新的配置，oldact为为了读取原来的配置
struct sigaction act,oact;
act.sa_handler=func;//设置处理函数
sigemptyset(&act.sa_mask);//设置处理函数的信号掩码 清空则在运行信号处理函数时 不阻塞额外的信号产生，
//POSIX保证被捕获的信号在其信号处理函数运行期间总是阻塞其他信号的发送
act.sa_flags=0;
```

* POSIX信号语义：一个信号处理函数运行期间、正在被递交的信号是阻塞的，如果一个信号被阻塞期间产生了一次或多次，通常只递交一次，Unix信号默认是不排队的  
* 使用 sigprocmask 使得选择性阻塞或解阻塞一组信号是可能的  

* 处理SIGCHLD信号，处理僵死进程，在信号处理函数内调用wait,内部并关闭子线程并返回pid

```cpp
#include <sys/types.h>
#include <sys/wait.h>
pid_t wait(int *wstatus);
pid_t waitpid(pid_t pid, int *wstatus, int options);
```

在多进程服务中的案例  

1、客户端发送FIN、服务器子线程响应一个ACK  
2、因为服务端收到FIN、TCP传送EOF给子进程阻塞中的read，read返回0，子进程结束  
3、然后SIFCHLD递交，父进程正在阻塞accept，sig_chld信号处理函数运行，调用wait获取结束的子进程id和终止状态，然后返回  
4、accept被打断，所以read返回值-1，且errno的值为EINTR  

* 处理被中断的系统调用：因为被中断errno为EINTR，例如accept、read、write、select、open操作我们可以返回去再次尝试，但是对于connect不能，如果调用connect得到EINTR，则不能再次调用  

* wait和waitpid函数，当多个子进程同时发送SIG_CHLD信号，而信号处理函数只被触发执行一次(因为Unix信号是不排队的)，而在内部如果只是用wait的话，则只是处理了一个子进程，不能达到处理僵死进程  

```cpp
while((pid=waitpid(-1,&stat,WNOHANG))>0)//指定WNOHANG告知waitpid在尚未终止的子进程在运行时不要阻塞
{}
//而wait会阻塞
//如果用wait循环的话，那么到最后没有死子线程时，wait会阻塞，这样就难搞了，所以用waitpid
```

有三点很重要  

1、当fork子进程时，必须捕获SIGCHLD信号  
2、当捕获信号时，必须处理被中断的系统调用  
3、SIGCHLD信号处理函数必须正确编写，使用waitpid函数以免留下僵尸死进程  

* 下面将会学习一些非常具有精髓的内容  

* accept返回前连接终止  

如果在服务端listen后，客户端发起三次握手，并且三次握手已经进行完毕，也就是新的已连接套接字以加入已连接队列，这是accept还没有调用，此时客户端发来RST，然后调用accept这时候accept会怎样呢？  

POSIX指出erron的值为ECONNABORTED,做处理，然后服务端可以再次执行accept  

* 服务器进程终止

服务端进程终止，向客户端发送FIN、客户端然后响应ACK，ACK这个动作是由内核进行的，用户程序并不会察觉，例如我们在等待标准输入阻塞时，服务端发过来FIN、并且内核给服务端响应ACK，然后用户输入数据，准备调用write发送给服务端，这时服务端将会知道已经与对方断开，会返回一个RST、客户端并不会对这个RST有察觉，如果客户端再进行read的话，read前接收到了RST则产生ECONNRESET错误，否则在read调用后接收到RST，则read则返回0  

* SIGPIPE信号

如果一个套接字已经收到了RST，如果在对其进行写入操作，内核会向该进程发送SIGPIPE信号，默认为忽略此信号，无论是否忽略，写操作都将返回EPIPE错误在errno  

* 服务器主机崩溃

比如连接良好，突然网线断了。然后客户端不知道，然后进行write向对方发送数据，在背后会进行多次的TCP重传尝试，如果是对方有问题返回错误是ETIMEDOUT、如果是中间路由器判定目标主机不可达则返回目的地不可达的ICMP消息，EHOSTUNREACH或ENETUNREACH错误  

* 服务器主机崩溃后重启

如果服务器崩溃时不想客户发送数据，则客户端不知道其已经崩溃了。(假设没有使用SO_KEEPALIVE套接字)、然后服务器进行重启，然后此时客户端发送数据过来后，服务端检测不是正确的连接，返回给客户端一个RST，客户端TCP收到RST，如果客户端正在阻塞于read，导致该调用返回ECONNRESET错误  

* 服务器主机正常关机

Unix系统关机时，init进程通常给所有进程发送SIGTERM信号，通知进程，等待一定时间，然后给所有仍在运行的进程发送SIGKILL信号(该信号不能被捕获)。进程终止，所有打开的描述符将会被关闭  

* 客户端怎样能检测到连接状态呢

使用select、poll、epoll方式，使得服务器进程的终止发生，客户端就能检测到  

* 传递文本

很简单，直接传递字符字节序列就好了

* 传递二进制

传递自定义的结构体，或者基本数据类型的内存二进制数据时要注意，可能会设计的到字节对齐、大端、小端问题  

