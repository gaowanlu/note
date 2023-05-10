# 工具与调试

## 基本工具

像 ssh、ftp 不再介绍，makefile 与 cmake 可以看构建工具部分

## 生成带调试信息的可执行文件

编译器加`-g `选项

```sh
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
```

## 建议关闭编译器优化选项

O0~O4,O0 表示优化关闭

```sh
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0")
```

## 启动 GDB 调试方法

1、直接调试目标程序

```sh
gdb filename
```

2、attach 到进程

```sh
gdb attach 进程号
//如果想结束调试
(gdb) detach
//然后
(gdb) quit
```

3、coredump 文件

```sh
gdb 可执行文件 core.xxxx
(gdb)bt
(gdb)...
```

## GDB 常用调试命令

| 命令名称    | 命令缩写 | 命令说明                                                         |
| ----------- | -------- | ---------------------------------------------------------------- |
| run         | r        | 运行一个程序                                                     |
| continue    | c        | 让暂停的程序继续运行                                             |
| break       | b        | 添加断点                                                         |
| tbreak      | tb       | 添加临时断点                                                     |
| backtrace   | bt       | 查看当前线程的调用堆栈                                           |
| frame       | f        | 切换到当前调用线程的指定堆栈                                     |
| info        | info     | 查看断点、线程等信息                                             |
| enable      | enable   | 启用某个断点                                                     |
| disable     | disable  | 禁用某个断点                                                     |
| delete      | del      | 删除断点                                                         |
| list        | l        | 显式源码                                                         |
| print       | p        | 打印或修改变量、寄存器的值                                       |
| ptype       | ptype    | 查看变量的类型                                                   |
| thread      | thread   | 切换到指定的线程                                                 |
| next        | n        | 运行到下一行                                                     |
| step        | s        | 如果有调用函数，则进入调用的函数内部，相当于 step into           |
| until       | u        | 运行到指定的行停下来                                             |
| finish      | fi       | 结束当前调用函数，到上一层函数调用处                             |
| return      | return   | 结束当前调用函数并返回指定的值，到上一层函数调用处               |
| jump        | j        | 将当前程序的执行流跳转到指定的行或地址                           |
| disassemble | dis      | 查看汇编代码                                                     |
| set args    |          | 设置程序启动命令行参数                                           |
| show args   |          | 查看设置的命令行参数                                             |
| watch       | watch    | 监视某个变量或内存地址的值是否发生变化                           |
| display     | display  | 监视的变量或者内存地址，在程序中断后自动输出监控的变量或内存地址 |
| dir         | dir      | 重定向源码文件的位置                                             |

## GDB 调试

### run 命令

运行一个程序

```bash
gdb main
(gdb) run
Starting program: /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main
[Inferior 1 (process 12536) exited normally]
```

输入 Crtl+c 可以使得程序中断

### continue 命令

让暂停的程序继续运行

```bash
(gdb)continue
```

### break 命令

添加断点

```bash
(gdb)break functionName
(gdb)break LineNo
(gdb)break filename:LineNo
```

### tbreak 命令

break 命令用于添加一个永久断点，tbreak 添加临时断点也就是被触发一次后就会自动删除

```bash
(gdb)tbreak functionName
(gdb)tbreak LineNo
(gdb)tbreak filename:LineNo
```

### backtrace 命令

backtrace 可简写为 bt,用于查看当前所有线程的调用堆栈

```bash
(gdb) backtrace
#0  func (f=4.635570538543758e-310) at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:17
#1  0x0000555555555357 in main (argc=1, argv=0x7fffffffde08) at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:32
```

### frame 命令

frame 命令用于在调用堆栈中切换当前帧。

```bash
(gdb) bt
#0  func2 () at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:5
#1  0x000055555555520d in func1 () at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:12
#2  0x0000555555555330 in func (f=21) at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:24
#3  0x0000555555555357 in main (argc=1, argv=0x7fffffffde08) at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:32
(gdb) frame 2
#2  0x0000555555555330 in func (f=21) at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:24
24          func1();
(gdb)
#可见在24行func调用的func1
```

### info break 命令

查看添加了哪些断点，其中有是否为临时断点，是否启用等信息

```bash
(gdb) info break
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x0000000000001236 in func(double) at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:17
2       breakpoint     keep y   0x00000000000011da in func1() at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:10
3       breakpoint     keep y   0x00000000000011a9 in func2() at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:5
(gdb)
```

### enable 命令

启用断点，如果不提供断点号，则代表启动所有断点

```bash
(gdb)enable 断点号
如 enable 2
```

### disable 命令

禁用断点，如果不提供断点号，则代表禁用所有断点

```bash
(gdb)disbale 断点号
如disable 2
```

### delete 命令

删除断点

```bash
(gdb)delete 断点号 断点号...
如disable 2 3
```

### list 命令

list 命令用于查看当前断点附近的代码，第一次输入 list 会显示断点前后 10 行代码，继续输入 list 每次都会接着向后显式 10 行代码一直到文件结束

```bash
(gdb)list
(gdb)list - 向上
(gdb)list + 向下
```

### print 命令

print 命令可以简写为 p，查看变量的值，也可以修改当前内存的变量值

```bash
(gdb)print 变量名
(gdb)print 变量名=232
```

输出格式化

```bash
(gdb)print /format 变量名
format可选项
o 八进制显示
x 十六进制显示
d 十进制显示
u 无符号十进制显示
t 二进制显示
f 浮点值显示
a 内存地址格式显示
i 指令格式显示
s 字符串格式显示
```

如何查看指针所指向的值，与复杂类型的值的查看

```bash
Breakpoint 1, func (point=0x5555555554ed <__libc_csu_init+77>) at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:23
23      {
(gdb) p point
$1 = (Point *) 0x5555555554ed <__libc_csu_init+77>
(gdb) p *point
$2 = {x = 29590344, y = 1977432392}
(gdb) p point->x
$3 = 29590344
(gdb) p point->y
$4 = 1977432392
```

### ptype 命令

输出变量的类型

```bash
(gdb)ptype 变量名
```

## info 命令

info 是一个混合命令，可以查看当前进程所有线程运行情况,列表前面的\*表示当前所在线程

```bash
(gdb) info threads
  Id   Target Id                                   Frame
* 1    Thread 0x7ffff7a34740 (LWP 13383) "tubekit" tubekit::socket::socket_handler::handle (this=0x5555555ba860, max_connections=10000, wait_time=10)
    at /mnt/c/Users/gaowanlu/Desktop/MyProject/tubekit/src/socket/socket_handler.cpp:69
  2    Thread 0x7ffff7a33700 (LWP 13387) "tubekit" futex_wait_cancelable (private=<optimized out>, expected=0, futex_word=0x5555555bb468) at ../sysdeps/nptl/futex-internal.h:183
  3    Thread 0x7ffff7232700 (LWP 13388) "tubekit" futex_wait_cancelable (private=<optimized out>, expected=0, futex_word=0x5555555bb678) at ../sysdeps/nptl/futex-internal.h:183
  4    Thread 0x7ffff6a31700 (LWP 13389) "tubekit" futex_wait_cancelable (private=<optimized out>, expected=0, futex_word=0x5555555bb858) at ../sysdeps/nptl/futex-internal.h:183
  5    Thread 0x7ffff6230700 (LWP 13390) "tubekit" futex_wait_cancelable (private=<optimized out>, expected=0, futex_word=0x5555555bba38) at ../sysdeps/nptl/futex-internal.h:183
```

所处某个线程时可以使用 backtrace 查看调用栈等

### thread 命令

切换所正在调试的线程

```bash
thread 线程号
```

## GDB 调试多线程程序方法

## GDB 调试多进程程序方法

## GDB 调试技巧
