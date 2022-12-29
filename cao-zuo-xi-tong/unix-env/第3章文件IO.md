---
coverY: 0
---

# 第3章 文件I/O

## 文件I/O

* 主要内容有open、read、write、lseek、close的使用，这五个函数并不是ISOC、而是POSIX的标准  
* 文件描述符，在进程中默认0为标准输入、1为标准输出、2为标准错误输出，分别定义在头文件unistd,STDIN_FILENO、STDOUT_FILENO、STDERR_FILENO  
* 每个进程打开的文件数量是有限制的  
* open相关函数  

```cpp
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
int open(const char *pathname, int flags);
int open(const char *pathname, int flags, mode_t mode);
int creat(const char *pathname, mode_t mode);
int openat(int dirfd, const char *pathname, int flags);
int openat(int dirfd, const char *pathname, int flags, mode_t mode);
```

open与openat的区别在于，openat支持指定文件目录然后pathname为相对于指定目录的文件路径，flags有许多规则，读写打开类型、追加、不存在则创建，是否非阻塞打开、写是否等待物理IO完成，等等

* create函数，用于创建文件  

```cpp
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
int creat(const char *pathname, mode_t mode);
```

* close函数用于关闭一个打开文件  

```cpp
#include <unistd.h>
int close(int fd);
```

注意的是，关闭一个文件还会释放此进程在文件上加的锁、当一个进程终止时其打开的文件将会被关闭  

* lseek用于调整当前文件偏移量  

```cpp
#include <sys/types.h>
#include <unistd.h>
off_t lseek(int fd, off_t offset, int whence);
//offset为移动的偏移量
//偏移量根据whence来说，SEEK_SET文件开始、SEEK_CUR当前位置、SEEK_END文件末尾
```

lseek仅将当前的文件的偏移量记录在内核，不会引起IO操作、文件偏移量可以大于文件的当前长度  

* 空洞文件：例如当写文件时，移动偏移量超过文件本身大小，再写时中间的哪些位置称为空洞，空洞是否占用磁盘空间，这取决于操作系统的优化  
* 不同系统平台的offset的数据类型可能不同  
* read函数：从打开的文件中读取数据  

```cpp
#include <unistd.h>
ssize_t read(int fd, void *buf, size_t count);
```

返回读出的字节数、读到文件末尾返回0，出错返回-1。当从网络读取时，网络中的缓冲机制可能造成返回值小于所要求读的长度，千万不要用size_t接收read返回参数，因为read可能返回-1  

* write函数  

```cpp
#include<unistd.h>
ssize_t write(int fd,const void*fd,size_t nbytes);
```

成功返回已经写的字节数、出错返回-1  

* 关于程序的读写数据缓冲不宜过大也不能太小，根据情况自己把握  
* 文件共享：在PCB中有进程表项，存储fd标志与文件指针的对应关系，所以文件标识符是对进程而言的，内核中维护文件表项例如当前文件偏移量，控制权限、v节点指针等等，一个进程可以有多个fd指向同一个文件表项目，不同进程在内核中的文件表项可以指向同一个v节点表项  
* lseek可能会引起竞争问题，例如要在文件末尾加数据，一个进程刚设置偏移量到末尾，然后另一个进程在此时在末尾写入了数据，这使得另一个进程加数据时加到的位置不是末尾。解决办法是使用O_APPEND标志打开文件追加模式  
* 函数pread与pwrite  

```cpp
#include <unistd.h>
ssize_t pread(int fd, void *buf, size_t count, off_t offset);
ssize_t pwrite(int fd, const void *buf, size_t count, off_t offset);
//两个函数不会改变文件的offset,只是从指定的offset读
```

* 在创建文件时也是，先检查文件是否存在、不存在则创建，检查与创建过程中可能出现中断，这样会引发问题  

* dup和dup2函数  

用于复制文件描述符  

```cpp
#include <unistd.h>
int dup(int oldfd);
int dup2(int oldfd, int newfd);//当oldfd==newfd时返回newfd

//----------------------------------------
//open时会先分配最小的没用的fd
close(1);
fd = open(FILE,O_WRONLY|O_CREAT|O_TRUNC,0600);
puts("hello");//输出到了FILE中
//与
fd = open(FILE,O_WRONLY|O_CREAT|O_TRUNC,0600);
close(1);
dup(fd);//效果一样，只不过后者将fd副本复制到fd 1上
//但不能保证close与dup的原子性
//所以有了函数dup2
dup2(fd,1);//close(1);dup(fd);
```

不同的文件描述符指向同一个内核中维护的文件表  

* sync、fsync、fdatasync函数  

```cpp
#include <unistd.h>
void sync(void);
int fsync(int fd);
int fdatasync(int fd);
```

sync只是将修改过的块缓冲区排入写队列，然后返回、并不等待实际磁盘写完毕再返回  
fync支持同步文件属性修改与文件数据，而fdatasync只支持数据，二者等待磁盘实际操作OK后再返回，可以保证数据一致性  

* fcntl函数用于修改已经打开文件的属性  

```cpp
#include <unistd.h>
#include <fcntl.h>
int fcntl(int fd, int cmd, ... /* arg */ );
```

功能主要有1、复制一个已有的描述符 2、获取与设置文件描述符标志 3、获取设置文件状态标志 就是以O_开头的一些宏如O_RDWR等 4、获取设置异步IO所有权 5、获取设置记录锁  

* ioctl函数：IO操作杂物箱，后面再学，一般用得少  
* /dev/fd/{{n}} n 0 1 2 ，打开文件/dev/fd/n等效于复制描述符n  

```cpp
fd=open("/dev/fd/0",O_RDWR) //标准输入
```

* 将得到文件指针所对应的文件描述符  

```cpp
int fileno(FILE *stream);
```

* 截断文件到指定长度大小

```cpp
#include <unistd.h>
#include <sys/types.h>
int truncate(const char *path, off_t length);
int ftruncate(int fd, off_t length);
```
