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

## run 命令

运行一个程序

```bash
gdb main
(gdb) run
Starting program: /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main
[Inferior 1 (process 12536) exited normally]
```

输入 Crtl+c 可以使得程序中断

## continue 命令

让暂停的程序继续运行

```bash
(gdb)continue
```

## break 命令

添加断点

```bash
(gdb)break functionName
(gdb)break LineNo
(gdb)break filename:LineNo
```

## tbreak 命令

break 命令用于添加一个永久断点，tbreak 添加临时断点也就是被触发一次后就会自动删除

```bash
(gdb)tbreak functionName
(gdb)tbreak LineNo
(gdb)tbreak filename:LineNo
```

## backtrace 命令

backtrace 可简写为 bt,用于查看当前所有线程的调用堆栈

```bash
(gdb) backtrace
#0  func (f=4.635570538543758e-310) at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:17
#1  0x0000555555555357 in main (argc=1, argv=0x7fffffffde08) at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:32
```

## frame 命令

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

## info break 命令

查看添加了哪些断点，其中有是否为临时断点，是否启用等信息

```bash
(gdb) info break
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x0000000000001236 in func(double) at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:17
2       breakpoint     keep y   0x00000000000011da in func1() at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:10
3       breakpoint     keep y   0x00000000000011a9 in func2() at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:5
(gdb)
```

## enable 命令

启用断点，如果不提供断点号，则代表启动所有断点

```bash
(gdb)enable 断点号
如 enable 2
```

## disable 命令

禁用断点，如果不提供断点号，则代表禁用所有断点

```bash
(gdb)disbale 断点号
如disable 2
```

## delete 命令

删除断点

```bash
(gdb)delete 断点号 断点号...
如disable 2 3
```

## list 命令

list 命令用于查看当前断点附近的代码，第一次输入 list 会显示断点前后 10 行代码，继续输入 list 每次都会接着向后显式 10 行代码一直到文件结束

```bash
(gdb)list
(gdb)list - 向上
(gdb)list + 向下
```

## print 命令

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

## ptype 命令

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

## thread 命令

切换所正在调试的线程,使用 gdb 调试的默认就是主线程

```bash
thread 线程号
```

## next 命令

next 命令简写为 n，用于 gdb 跳到下一行代码

```bash
(gdb)next
(gdb)n
```

## step 命令

用于单步执行程序的调试过程。它允许你逐行执行程序并跳转到下一行代码

在使用"step"命令时，GDB 会执行当前行并进入下一行。如果当前行是函数调用语句，GDB 将进入该函数并在函数内部的第一行停下。这使你能够逐行跟踪程序的执行并查看每个步骤的结果。

请注意，"step"命令将进入所有可执行的代码，包括系统库和其他文件中的代码。如果你只想进入你自己的代码，可以使用"next"命令而不是"step"命令。

```bash
(gdb)step [count]
#单步执行程序
(gdb) step
#指定要执行的步骤数
(gdb) step 5
```

## until 命令

用于执行程序直到达到指定的位置或行号，然后停止执行并返回控制权给用户

```bash
(gdb)until [location]
```

其中，可选的"location"参数指定程序应执行到的位置或行号。如果未提供该参数，GDB 将默认执行到当前循环的结尾  
"until"命令执行程序直到达到指定位置，然后停止执行。这使你能够跳过代码块、循环或函数，并在达到指定位置后继续调试,until 只能在调试状态下用，也就是 run 执行后，程序结束前

```bash
1、执行程序直到下一个关键点
(gdb) until
2、执行程序直到指定的行号
(gdb)until 10
3、执行程序直到达到指定的函数或方法
(gdb)until my_function
```

## finish 命令

"finish"命令用于一次性执行完当前函数的剩余部分，并停止在函数返回之后。

```finish
(gdb)finish
```

## return 命令

return"命令用于跳出当前函数并停止在调用函数的位置  
当你在调试过程中进入一个函数，但对于函数内部的执行细节不感兴趣时，可以使用"return"命令直接返回到调用该函数的代码位置

```bash
(gdb)return [expression]
```

其中，可选的"expression"参数允许你在返回之前设置函数的返回值。

```bash
(gdb)return
(gdb)return 42
```

## jump 命令

"jump"命令用于直接跳转到程序中的指定位置并重新执行代码，而不是逐行执行

使用"jump"命令会绕过程序中的正常控制流程，直接跳转到指定位置，并可能导致程序状态的不一致。这可能会引发未定义行为或错误的结果。因此，在使用"jump"命令之前，确保你理解跳转的后果，并谨慎使用它。

```bash
(gdb)jump [location]
#其中，"location"参数指定要跳转的位置。可以是函数名、行号或地址。
(gdb)jump my_function
(gdb) jump 20
(gdb) jump *0x7fffffff
```

## set args 命令

当你需要在调试过程中指定程序运行时的命令行参数时，可以使用"set args"命令来设置这些参数。

```bash
(gdb)set args arguments
#(gdb) set args input.txt output.txt
#清空已设置的命令行参数：
#(gdb) set args
```

## show args 命令

用于显示当前设置的程序的命令行参数

```bash
(gdb) show args
```

## watch 命令

用于设置观察点（watchpoint），以便在变量或内存地址的值发生更改时停止程序的执行

```bash
(gdb)watch [expression]
#观察变量 "my_variable" 的值变化：
(gdb) watch my_variable
#观察内存地址 0x123456 的值变化：
(gdb) watch *0x123456
#观察表达式 "array[i]" 的值变化：
(gdb) watch array[i]
```

其中，"expression"参数是你要观察的变量、内存地址或表达式。

```bash
Breakpoint 1, func1 () at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:16
16      {
(gdb) n
17          int x=0;
(gdb) watch x
Hardware watchpoint 2: x
(gdb) n

Hardware watchpoint 2: x

Old value = 32767
New value = 0
func1 () at /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode/main.cpp:18
18          cout << 7 << endl;
```

info watch,命令来查看当前已设置的观察点

```bash
(gdb) info watch
Num     Type           Disp Enb Address            What
2       hw watchpoint  keep y                      x
        breakpoint already hit 1 time
```

使用"delete"命令来删除观察点

```bash
(gdb) info watch
Num     Type           Disp Enb Address            What
2       hw watchpoint  keep y                      x
        breakpoint already hit 1 time
(gdb) delete 2
(gdb) info watch
No watchpoints.
```

## display 命令

通过使用"display"命令，你可以在每次程序停下来时自动显示特定变量或表达式的当前值。这对于跟踪变量的值或查看表达式的结果非常有用，而无需手动输入每次都要检查的命令

```bash
(gdb)display [expression]
#其中，"expression"参数是你想要显示值的变量或表达式。
#显示变量 "my_variable" 的值：
(gdb) display my_variable
#显示表达式 "array[i]" 的值：
(gdb) display array[i]
```

希望停止显示特定变量或表达式的值，可以使用"undisplay"命令

```bash
(gdb) n
17          int x=0;
(gdb) display x
1: x = 32767
(gdb) n
18          cout << 7 << endl;
1: x = 0
(gdb) undisplay 1
(gdb) n
7
20          func2();
```

## dir 命令

"dir"命令用于指定源代码文件的搜索路径

```bash
(gdb)dir directory
#添加当前目录（即调试会话所在目录）到源代码搜索路径：
(gdb) dir .
#添加绝对路径 "/path/to/source" 到源代码搜索路径：
(gdb) dir /path/to/source
```

"dir"命令可以多次使用，以指定多个源代码搜索路径。  
你可以使用"show directories"命令查看当前设置的源代码搜索路径。如果需要删除已添加的目录路径，可以使用"undir"命令，并提供相应的目录路径参数。

```bash
(gdb) show directories
Source directories searched: $cdir:$cwd
(gdb) dir .
Source directories searched: /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode:$cdir:$cwd
(gdb) show directories
Source directories searched: /mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode:$cdir:$cwd
```

## 调试多线程程序

在多线程调试中，设置的断点是全局的不是调试某个线程，不同线程执行同样的函数代码，如果在函数内的语句加断点，那么多个线程在执行到响应位置时都会出发断点，而不仅仅对当当前调试线程有效

如何锁定一个线程，只观察某个线程的运行情况

```cmake
(gdb)set scheduler-locking on/step/off
# on 用来锁定当前进程,其他线程不会运行
# off 用于释放锁定当前线程
# step 用于在单步执行期间禁用并发调度
```

## 调试多进程程序

1、方法一

现在一个窗口用 gdb 调试父进程，等子进程被 fork 出来后，再来一个新窗口使用 gdb attach 命令将 gdb attach 到子进程上

2、方法二

gdb 提供了 follow-fork 选项，通过 set follow-fork mode 设置一个进程 fork 出新的子进程时，gdb 是调试父进程还是子进程

```bash
# fork后gdb attach到子进程
(gdb)set follow-fork child
# fork后gdb attach到父进程（默认值）
(gdb)set follow-fork parent
# 查看当前模式
(gdb)show follow-fork mode
```

## GDB 调试技巧

1、将 print 输出的字符串或字符数组完整显示

```bash
(gdb)set print element 0
(gdb)print xxx
```

2、让被 gdb 调试的程序接收信号

当在 gdb 调试时，输入 Ctrl+C(SIGINT)信号，信号会被 gdb 接收让调试器中断，所以无法让程序接收到此信号

```bash
1、在gdb手动使用signal函数发送信息
(gdb)signal SIGINT
2、通过改变信号处理的设置，告诉gdb在接收到SIGINT信号时不要停止，并把信号传递给正在调试的程序
(gdb)handle SIGINT nostop print pass
```

3、函数存在，添加断点时却无效

在一个函数存在时，使用函数名进行断点设置，却提示 Make breakpoint pending on future shared library load?y/n

此时需要改变设置策略，改用代码文件和行号添加断点即可

4、调试中的断点

断点分为三类，普通端点、条件断点、数据断点

```bash
# 条件断点
(gdb)break [lineNO] if [condition]
(gdb)break 11 if i==5000
```

还有一种方法为，先添加断点，然后使用`(gdb)condition 断点编号 断点触发条件`的格式添加

5、自定义 gdb 调试命令

在用户目录下定义`.gdbinit`文件，进阶应用可深究

## 网络并发测试

进行压力测试，但是通常我们是没有那么多的主机资源可以用，首先我们找一些免费的主机资源

`https://labs.play-with-docker.com/` 是提供 Docker 练习的。我们可以创建几个 instance

```bash
docker run -it ubuntu
```

执行上面命令进入 Ubuntu Docker 容器后

```bash
apt update
```

例如要进行 http 压力测试

```bash
apt install apache2-utils
```

使用 ab 进行测试

```bash
ab -c 2000 -n 1000000 https://61.171.51.135:20024/
```

可以多创建些容器同时执行，达到模拟大量用户同时访问效果，不过还是小心点不要对他人网站进行尝试。

```bash
apt install htop -y
apt install iproute2 -y
apt install iperf -y
```

使用 iperf 并发 tcp 连接

```bash
iperf -c [IP] -p [PORT] -P [并发连接数量]
```

使用 ss 查看端口的连接情况

```bash
ss -tnap | grep '(:|,)[PORT]' | wc -l
```
