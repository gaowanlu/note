---
coverY: 0
---

# 静态库与动态库

## 静态库与动态库

### 静态库引用静态库

static_b.h

```cpp
#pragma once

void static_b();
```

static_b.cpp

```cpp
#include "static_b.h"
#include <iostream>

void static_b()
{
    std::cout << "static_b" << std::endl;
}
```

生成静态库libstatic_b.a

```cpp
# CMakeLists.txt
add_library(static_b STATIC static_b.cpp)
```

static_a.h

```cpp
#pragma once

void static_a();
```

static_a.cpp

```cpp
#include "static_a.h"
#include "static_b.h"
#include <iostream>

void static_a()
{
    std::cout << "static_a" << std::endl;
    static_b();
}
```

生成静态库libstatic_a.a

```cpp
# CMakeLists.txt
add_library(static_a STATIC static_a.cpp)
target_link_libraries(static_a PRIVATE static_b)
```

工程使用静态库a即可

main.cpp

```cpp
#include <iostream>
#include "static_a.h"
using namespace std;

int main(int argc, char **argv)
{
    static_a();
    return 0;
}
```

CMakeLists.txt

```cpp
project(main)

LINK_DIRECTORIES(./)

add_executable(main.exe main.cpp)
target_link_libraries(main.exe static_a)
```

或者g++命令

```bash
g++ main.cpp -o main.exe -L./  libstatic_a.a
```

可生成main.exe 执行可以输出

```cpp
static_a
static_b
```

如果生成静态库a没有连接静态库b,那么生成main.exe需要同时连接a与b

```cpp
project(main)

LINK_DIRECTORIES(./)

add_executable(main.exe main.cpp)
target_link_libraries(main.exe static_a static_b)
```

工程可能会覆盖静态库中已经定义的函数?

```cpp
#include <iostream>
#include "static_a.h"
using namespace std;

void static_b()
{
    std::cout << "kob" << std::endl;
}

int main(int argc, char **argv)
{
    static_a();
    return 0;
}
```

即使有链接a与b，但是输出的是static_a kob 以下是groq给出的答复

当将静态库链接到可执行文件时，如果静态库中定义的名为`void func(){}`函数，而用户的`main.cpp`也定义了`void func(){}`，那么链接时不会报错，而是会选择用户在`main.cpp`中定义的`void func(){}`。

这是因为链接器的工作是解析对象文件中的符号（即函数名称和地址），并确保生成的可执行文件中只包含每个符号的一个定义。当链接器遇到多个对象文件中定义了相同符号的情况时，它会选择`最“本地”`的定义。

在您的情况下，符号`void func()`在静态库和`main.cpp`中都定义了。当链接器遇到`main.cpp`中的该符号时，它会选择`main.cpp`中的`void func()`定义，因为它是最“本地”的定义。

这种行为是链接器的一种常见特性，它允许链接器根据符号的使用上下文选择最合适的定义，而不是仅仅是选择第一个定义。

### 静态库引用动态库

生成动态库b

```cpp
# CMakeLists.txt
add_library(static_b SHARED static_b.cpp)
```

生成静态库a时链接动态库b

```cpp
# CMakeLists.txt
add_library(static_a STATIC static_a.cpp)
target_link_libraries(static_a PRIVATE static_b)
```

即可得到libstatic_a.a 与 libstatic_b.so

main.exe使用静态库a

```cpp
#include <iostream>
#include "static_a.h"
using namespace std;

int main(int argc, char **argv)
{
    static_a();
    return 0;
}
```

CMakeLists, main.exe 写规则只链接到static_a和static_a.a static_b.so都写 都能编译过,因为静态库a已经规定链接static_b.so动态库b,写不写链接b都行，但是如果static_b.so不存在了，动态库丢失了，在编译时会编译不通过，main.exe生成后so文件丢失后，在启动main.exe时会报错，动态库丢失。

```cpp
project(main)

add_compile_options(-Wall -Werror)

LINK_DIRECTORIES(./)

add_executable(main.exe main.cpp)
target_link_libraries(main.exe static_a static_b)
```

例如上面生成的动态库b会生成在main.exe同目录，手动将libstatic_b.so移动到`/usr/lib/`目录下，再运行main.exe 程序也会自动找到`/usr/lib/`下的libstatic_b.so的。

### 动态库引用静态库

```cpp
# CMakeLists.txt
cmake_minimum_required(VERSION 3.10)

add_library(static_b STATIC static_b.cpp)
add_library(static_a SHARED static_a.cpp)

target_link_libraries(static_a PRIVATE static_b)
```

不可以

```cpp
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ make -j4
[ 25%] Building CXX object CMakeFiles/static_b.dir/static_b.cpp.o
[ 50%] Linking CXX static library libstatic_b.a
[ 50%] Built target static_b
[ 75%] Linking CXX shared library libstatic_a.so
/usr/bin/ld: libstatic_b.a(static_b.cpp.o): warning: relocation against `_ZSt4cout@@GLIBCXX_3.4' in read-only section `.text'
/usr/bin/ld: libstatic_b.a(static_b.cpp.o): relocation R_X86_64_PC32 against symbol `_ZSt4cout@@GLIBCXX_3.4' can not be used when making a shared object; recompile with -fPIC
/usr/bin/ld: final link failed: bad value
collect2: error: ld returned 1 exit status
make[2]: *** [CMakeFiles/static_a.dir/build.make:85: libstatic_a.so] Error 1
make[1]: *** [CMakeFiles/Makefile2:78: CMakeFiles/static_a.dir/all] Error 2
make: *** [Makefile:84: all] Error 2
```

以下是chatgpt给出的回答

```cpp
# CMakeLists.txt
cmake_minimum_required(VERSION 3.10)

add_library(static_b STATIC static_b.cpp)
add_library(static_a SHARED static_a.cpp)
target_compile_options(static_b PRIVATE -fPIC)

target_link_libraries(static_a PRIVATE static_b)
```

但是能生成main.exe 但是运行时报错,看来非要动态库版的b不可

```cpp
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ ./main.exe
./main.exe: error while loading shared libraries: libstatic_b.so: cannot open shared object file: No such file or directory
```

解决方案就是 生成静态库b 生成动态库a 供工程使用时需要连接a和b

```cpp
# CMakeLists.txt
add_library(static_b STATIC static_b.cpp)

# CMakeLists.txt
add_library(static_a SHARED static_a.cpp)

# CMakeLists.txt
project(main)
add_compile_options(-Wall -Werror)
LINK_DIRECTORIES(./)
add_executable(main.exe main.cpp)
target_link_libraries(main.exe static_a)
target_link_libraries(main.exe static_b)
```

此处如果把static_b先link然后再link static_a则会编译报错

```bash
/usr/bin/ld: ./libstatic_a.so: undefined reference to `static_b()'
collect2: error: ld returned 1 exit status
make[2]: *** [CMakeFiles/main.exe.dir/build.make:84: main.exe] Error 1
make[1]: *** [CMakeFiles/Makefile2:76: CMakeFiles/main.exe.dir/all] Error 2
make: *** [Makefile:84: all] Error 2
```

此处原因是main.cpp没有对static_b的引用，如果main函数内调用`static_b()`,那么`static_a.so`放前面还是`static_b.a`放前面都可以编译成功。

整体流程就是

```cpp
project(main)
add_compile_options(-Wall -Werror)
LINK_DIRECTORIES(./)
add_executable(main.exe main.cpp)
add_library(static_b STATIC static_b.cpp)
add_library(static_a SHARED static_a.cpp)
target_link_libraries(main.exe static_a)
target_link_libraries(main.exe static_b)
```

上面的例子就是如下所说，前面的main.cpp内定义的static_a覆盖statoc_a库中的函数定义，是一个道理，都和链接器规则有关。

链接顺序问题

当链接器处理输入文件、静态库和共享库时，它会按照以下顺序解析符号：  
输入文件和目标文件  
静态库  
共享库  
这意味着，如果链接器在解析输入文件和目标文件中的符号时遇到尚未解析的符号，它将尝试在静态库中查找这些符号的定义。如果仍然找不到定义，链接器将继续尝试在共享库中查找这些符号的定义。  

```cpp
因为main.cpp扫描后 记录了符号static_a()是还没有被定义的,链接static_b.a时
发现static_b.a没有什么可用需要被链接的所以static_b.a没有被链接,等到处理
static_a.so时记录未定义符号static_b()此时，已经没有再需要处理的文件了
自然static_b()会缺少定义。
只要main.cpp调用了static_b.cpp任意函数 static_b将会被链接进来
简单点就是 在处理链接库时只有前面已经被链接起来的整体 对 要处理的内部有依赖，这时才会将要处理的链接进来加入整体
否则就跳过了
且前面如果已经定义了同符号函数 后面链接时又来一个一模一样的符号 则以先被链接的优先 而且全局变量也是(那怕自己cpp中定义了一个名为n的全局变量如果此部分没有被先链接，而是链接时已经有过一个名为n的变量了，不会取代已经被链接好的n,可以用IDE试一试，哪怕各个cpp中的n类型不同，其实全局只有一个n且类型时唯一的，也有是很多个cpp中有n但只有一个cpp中的n做了全局老大)
```

### 动态库引用动态库

```cpp
# CMakeLists.txt
cmake_minimum_required(VERSION 3.10)

add_library(static_b SHARED static_b.cpp)
add_library(static_a SHARED static_a.cpp)

target_link_libraries(static_a PRIVATE static_b)
```

生成动态库b

```cpp
# CMakeLists.txt
cmake_minimum_required(VERSION 3.10)

add_library(static_b SHARED static_b.cpp)
```

生成动态库a

```cpp
# CMakeLists.txt
cmake_minimum_required(VERSION 3.10)

add_library(static_a SHARED static_a.cpp)

target_link_libraries(static_a PRIVATE static_b)
```

生成可执行文件

```cpp
project(main)

add_compile_options(-Wall -Werror)

LINK_DIRECTORIES(./)

add_executable(main.exe main.cpp)
target_link_libraries(main.exe static_a)
```

写不写static_b都行，因为依赖static_a就会依赖static_b了。
