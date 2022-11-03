---
coverY: 0
---

# 第3章 System V IPC

## System V IPC

### 未完待续

1、了解System V IPC的由来  
2、System V IPC 的key_t键,其由pathname与文件索引节点号，以及指定id共同决策key_t,书中给出了key_t的大致构造流程代码svipc/ftok.c 

```cpp
#include <sys/types.h>
#include <sys/ipc.h>
key_t ftok(const char *pathname, int proj_id);
```

3、内核对每个IPC维护一个ipc_perm结构，内部有用户权限相关内容，以及IPC标识还有特殊的seq字段要理解其用途  
4、理解创建IPC的逻辑流程，msgget、semget、shmget的使用，其参数对其影响与Posix IPC类似  
5、关于其控制权限，也从用户属主、用户组属主、及其它用户进行分析  
6、标识符重用、理解`System V IPC是系统范围的`，而非进程范围的，seq是一个系统级别的全局变量  
7、介绍了ipcs以及ipcrm的工具的使用，内核对mq、信号量的数目大小一般都有限制，一般系统都允许用户来进行限制
