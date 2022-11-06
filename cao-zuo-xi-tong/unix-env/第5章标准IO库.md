---
coverY: 0
---

# 第 5 章 标准 I/O 库

## 标准 I/O 库

- 流和对象:打开一个文件，返回一个文件描述符，对于标准 IO 库而言，他们的操作是围绕流进行的，一个字符可能是一个字节，也可能是宽字符需要多个字节。
- 流的定向：决定了所读、写的字符是单字节还是多字节的宽字符，当一个流创建时时没有被定向，若在流上使用一个宽字符则变为宽定向，使用单字节的 IO 函数，则将流定向设为字节定向的
- fwide 函数用于设置流的定向

```cpp
#include <wchar.h>
int fwide(FILE *stream, int mode);
返回值为设置后的mode，
mode 负为字节定向 正为宽字符 0为未定向
```

- 标准输入、标准输出、标准错误

```cpp
STDIN_FILENO STDOUT_FILENO STDERR_FILENO
stdin        stdout        stderr
#include<stdio>
```

- 缓冲：标准 IO 有三种类型，全缓冲、行缓冲、不带缓冲
- 全缓冲：当填满标准 IO 缓冲区后才进行实际的 I/O 操作
- 行缓冲：在输入和输出中遇到换行符时，标准 I/O 库执行 I/O 操作，缓冲区大小有限当行大小超过缓冲大小即使没换行符也会 I/O 操作，通过标准 I/O 库要求从一个不带缓冲的流或行缓冲流得到输入数据，会冲洗所有行缓冲输出流
- 冲洗：flush、在进行写操作时，冲洗就是将缓冲区中的内容写到磁盘上，可以调用 fflush 函数冲洗一个流
- 不带缓冲，stderr 不带缓冲
- 更改缓冲类型

```cpp
#include <stdio.h>
void setbuf(FILE *stream, char *buf);//buf需要为BUFSIZE长度默认全缓冲
void setbuffer(FILE *stream, char *buf, size_t size);//buf为size长度
void setlinebuf(FILE *stream);//行缓冲
int setvbuf(FILE *stream, char *buf, int mode, size_t size);
//mode： _IOFBF全缓冲 _IOLBF行缓冲 _IONBF不带缓冲
```

- fflush 函数，强制冲洗一个流

```cpp
#include <stdio.h>
int fflush(FILE *stream);
//该函数使得所有未写的数据都被传送到内核
```

- fopen 打开流

```cpp
#include <stdio.h>
FILE *fopen(const char *pathname, const char *mode);
FILE *fdopen(int fd, const char *mode);//例如管道或者socket没有pathname
FILE *freopen(const char *pathname, const char *mode, FILE *stream);
//freopen在一个指定的流上打开一个指定的文件，若流已经打开则先关闭流，流已经定向则先清楚定向，一般用于将一个指定的文件打开为一个预定义的流
```

![打开标准I/O流的type](../../.gitbook/assets/屏幕截图2022-11-06232924.jpg)

b 用来以二进制读写还是字节形式

```cpp
#include <stdio.h>
int main(void)
{
    freopen("./temp.text", "ab", stdout);
    printf("new file");
    //会神奇的发现，new file被写到./temp.text文件里了
    return 0;
}
```

![打开一个标准I/O流的6种不同方式](../../.gitbook/assets/屏幕截图2022-11-06233308.jpg)

- fclose 关闭流，在关闭前将冲洗缓冲中的输出数据，缓冲区种的输入数据将会被清空，因为关闭流了，用户也不会再读数据了，进程正常终止时 exit 调用或 main 返回，都会自动 close

- I/O 读写有三种选择，每次操作一个字符、每次操作一行、直接 I/O 指定大小

```cpp
#include <stdio.h>
int fgetc(FILE *stream);//函数
char *fgets(char *s, int size, FILE *stream);
int getc(FILE *stream);//宏
int getchar(void);//等价于getc(stdin)
int ungetc(int c, FILE *stream);
```

getc 为什么返回 int，而不是 unsigned char,因为可能返回 EOF，EOF 通常为-1，标识文件末尾

```cpp
#include <stdio.h>
void clearerr(FILE *stream); //清楚出错标志
int feof(FILE *stream);      //检测文件结束标志
int ferror(FILE *stream);    //检测出错标志
int fileno(FILE *stream);    //获得文件描述符
```

- 压回字符，从流中读出数据后，可以将数据在返回到缓冲区

```cpp
int ungetc(int c, FILE *stream);
```

```cpp
#include <stdio.h>
int main(void)
{
    char ch = getchar(); // input a
    ungetc(ch, stdin);//压回到stdin缓冲区
    ch = getchar();
    printf("%c", ch); // ouput a
    return 0;
}
```

- 输出函数

```cpp
#include <stdio.h>
int fputc(int c, FILE *stream);
int putc(int c, FILE *stream);
int putchar(int c);
//成功返回c 出错返回EOF
```

- 每次一行 I/O

```cpp
#include <stdio.h>
char *gets(char *s);
char *fgets(char *s, int size, FILE *stream);
//成功返回buf，若已到达文件末尾或者出错，返回NULL
#include <stdio.h>
int main(void)
{
    char buf[5];
    if (fgets(buf, 5, stdin)) // 12345678
    {
        printf("%s\n", buf); // 1234
    }
    fgets(buf, 5, stdin);
    printf("%s\n", buf); // 5678
    return 0;
}
```

gets 不要使用，其不能指定 buf 大小，可能回造成缓冲区溢出

- 每次输出一行

```cpp
#include <stdio.h>
int fputs(const char *s, FILE *stream);
int puts(const char *s);
//返回非负值则成功 出错返回EOF
#include <stdio.h>
int main(void)
{
    puts("hello unix env");
    FILE *fp = fopen("./temp.txt", "ab");
    fputs("hello unix env", fp);
    fflush(fp);
    fclose(fp);
    return 0;
}
```

- TODO LIST

二进制I/O、定位流、格式化I/O、实现细节、临时文件、内存流
