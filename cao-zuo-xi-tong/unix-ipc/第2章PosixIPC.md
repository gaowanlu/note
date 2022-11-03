---
coverY: 0
---

# 第2章 Posix IPC

## Posix IPC

### 组成部分

Posix IPC由Posix消息队列、Posix信号量、Posix共享内存区三部分内容组成

### Posix IPC函数

|             | 消息队列 | 信号量| 共享内存区|
| ----------- | ----------- |-----------|-----------|
| 头文件      | <mqueue.h>   | <semaphore.h>| <sys/mman.h>|
| 创建、打开或删除IPC的函数   | mq_open</br>mq_close</br>mq_unlink | sem_open</br> sem_close</br>sem_unlink</br>sem_init</br>sem_destory |shm_open</br>shm_unlink|
|控制IPC操作的函数|mq_getattr</br>mq_setattr||ftruncate</br>fstat|
|IPC操作函数|mq_read</br>mq_receive</br>mq_notify|sem_wait</br>sem_trywait</br>sem_post</br>sem_getvalue|mmap</br>munmap|

### IPC的名字

可能是文件系统中真正的路径名，也可能不是  

* 必须有自己的路径规则
* 如果以斜杠开头，对不同的调用将访问同一个队列，如果不以斜杠开头，则取决于实现
* 名字中额外的斜杠的解释由实现定义

实现自己的px_ipc_name函数,决定采用`/tmp/{{name}}`格式还是采用`/{{config}}/{{name}}`格式

```cpp
/* include px_ipc_name */
#include "unpipc.h"

char *
px_ipc_name(const char *name)
{
 char *dir, *dst, *slash;

 if ( (dst = malloc(PATH_MAX)) == NULL)
  return(NULL);

  /* 4can override default directory with environment variable */
 if ( (dir = getenv("PX_IPC_NAME")) == NULL) {
#ifdef POSIX_IPC_PREFIX
  dir = POSIX_IPC_PREFIX;  /* from "config.h" */
#else
  dir = "/tmp/";    /* default */
#endif
 }
  /* 4dir must end in a slash */
 slash = (dir[strlen(dir) - 1] == '/') ? "" : "/";
 snprintf(dst, PATH_MAX, "%s%s%s", dir, slash, name);

 return(dst);   /* caller can free() this pointer */
}
/* end px_ipc_name */

char *
Px_ipc_name(const char *name)
{
 char *ptr;

 if ( (ptr = px_ipc_name(name)) == NULL)
  err_sys("px_ipc_name error for %s", name);
 return(ptr);
}

```

### 未完待续

以后的章节暂时都是对书中讲了什么进行大致的描述，暂时并不展开细节，因为需要花费大量的时间，计划在一月份开始进行
也是每个板块将来所要进行实践的内容

1、创建Posix IPC对象，mq_open、sem_open、shm_open的使用，及其权限控制与unix系统权限之间展开联系，理解不同参数对IPC对象打开或者创建的逻辑流程  
2、IPC权限的控制，如用户、用户组、root超级用户的联系  
