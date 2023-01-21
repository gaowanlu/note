---
coverY: 0
---

# GCC 的使用

## GCC

### 版本

```cpp
$gcc -v
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/9/lto-wrapper
OFFLOAD_TARGET_NAMES=nvptx-none:hsa
OFFLOAD_TARGET_DEFAULT=1
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu 9.4.0-1ubuntu1~20.04.1' --with-bugurl=file:///usr/share/doc/gcc-9/README.Bugs --enable-languages=c,ada,c++,go,brig,d,fortran,objc,obj-c++,gm2 --prefix=/usr --with-gcc-major-version-only --program-suffix=-9 --program-prefix=x86_64-linux-gnu- --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-vtable-verify --enable-plugin --enable-default-pie --with-system-zlib --with-target-system-zlib=auto --enable-objc-gc=auto --enable-multiarch --disable-werror --with-arch-32=i686 --with-abi=m64 --with-multilib-list=m32,m64,mx32 --enable-multilib --with-tune=generic --enable-offload-targets=nvptx-none=/build/gcc-9-Av3uEd/gcc-9-9.4.0/debian/tmp-nvptx/usr,hsa --without-cuda-driver --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)
```

### 编译流程

C 源文件-预处理-编译-汇编-链接-可执行文件

- 预处理,以#开头的预处理命令都是在预处理阶段处理掉的

```bash
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ gcc -E  main.cpp > main.i
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ ls
main.cpp  main.i
```

- 编译，将预处理后的C代码转为汇编代码

```bash
gcc -S main.i
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ ls
main.cpp  main.i  main.s
```

- 汇编，将汇编转为目标文件,目标文件已经是二进制

```bash
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ gcc -c main.s
gaowanlu@DESKTOP-QDLGRDB:/mnt/c/Users/gaowanlu/Desktop/MyProject/note/testcode$ ls
main.cpp  main.i  main.o  main.s
```

- 链接，将多个目标文件，链接为一个可执行文件

```bash
$ g++ -E main.cpp > main.i
$ ls
main.cpp  main.i  main.o  main.s
$ g++ -S main.i
$ g++ -c main.i
$ ls
main.cpp  main.i  main.o  main.s
$ g++ main.o -o main
$ ls
main  main.cpp  main.i  main.o  main.s
$ ./main
```

### 圆滑的GCC

在GCC中，没有引入源文件使用了相关函数，可能不会报错，但是在在你运行生成的可执行文件时，居然出现了段错误  
gcc中的警告需要注意，能够避免此类问题

检查警告  

```bash
$gcc main.cpp -Wall
```

### 预处理注释

```cpp
//这样也挺好用的
#if 0
void func(){

}
#endif
```
