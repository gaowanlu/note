# CMake

很棒的CMake学习项目推荐,内容的许多出处来自于，请多支持原作者 https://github.com/eglinuxer/study_cmake  本人仅用作于记录学习

## cmake_minimum_required

cmake_minimum_required是一个CMake命令，用于指定需要使用的CMake版本的最小版本号。这个命令通常会放在CMakeLists.txt文件的顶部，以确保使用的CMake版本能够支持这个项目所需的所有功能。

```cmake
cmake_minimum_required(VERSION 3.26 FATAL_ERROR)
```

## project

project是一个CMake命令，用于定义一个CMake项目。它通常会被放在CMakeLists.txt文件的顶部，紧接着cmake_minimum_required命令。

```cmake
project(MyProject)
```

还可以接受一些可选的参数，用于指定项目的一些属性，如版本号、描述等。例如：

```cmake
project(MyProject VERSION 1.0 DESCRIPTION "My awesome project")
```

还可以用来指定编程语言，例如：

```cmake
project(MyProject LANGUAGES CXX)
```

这个命令会将项目语言设置为C++。在这种情况下，CMake会根据设置自动为项目添加C++编译器和链接器，并且会自动使用CMake中的一些内置变量（如CMAKE_CXX_COMPILER、CMAKE_CXX_FLAGS等）来设置编译器和编译选项。

## add_executable

将原文件加入到可执行文件

```cmake
add_executable(<executable_name> <source_file> [<source_file>...])
```

例如

```cpp
add_executable(MyProject main.cpp)
```

## add_library

生成库

```cmake
add_library(<library_name> [STATIC | SHARED | MODULE] <source_file> [<source_file>...])
```

STATIC: 静态库，也就是.a文件，库的代码会被编译到可执行文件中。  
SHARED: 共享库，也就是.so或.dylib文件，库的代码会被编译成独立的动态链接库文件，可供多个可执行文件使用。  
MODULE：模块库，也就是.so或.dylib文件，库的代码会被编译成动态链接库文件，但不会被链接到可执行文件中，而是在运行时通过dlopen等函数进行加载。  

例如:

```cmake
add_library(mylib STATIC lib1.cpp lib2.cpp)
```

## target_link_libraries

用于将一个目标（例如可执行文件或库）与一个或多个库进行链接

```cmake
target_link_libraries(<target> <library>...)
```

例如：

```cpp
target_link_libraries(MyProgram Library1 Library2)
```

## set与unset

用于设置一个变量的值

```cmake
set(<variable> <value> [CACHE <type> <docstring> [FORCE]])
```

<variable>是要设置的变量的名称，<value>是变量的值。CACHE选项用于将变量的值存储在CMake缓存中，这样可以在后续的构建中保留变量的值。<type>是变量的类型，可以是STRING、FILEPATH、PATH、BOOL、INTERNAL等类型。<docstring>是变量的描述信息，可以用于生成CMake缓存中的变量描述。FORCE选项用于在设置变量时，无论变量是否已存在，都强制设置变量的值。

例如:

```cpp
set(MYVARABLE "HELLO WORLD")
```

放入CMake缓存中

```cpp
set(MYVARABLE "HELLO WORLD" CACHE STRING "my message" FORCE)
```

unset为取消变量定义

```cpp
unset(MYVARABLE)
```

定义变量样例

```cmake
cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)
project(tubekit)

set(MY_VAR "HELLO WORLD")
message(AUTHOR_WARNING "${MY_VAR}")#HELLO WORLD

set(MY_VAR main.cpp a.cpp)#创建列表
message(AUTHOR_WARNING "${MY_VAR}") # main.cpp;a.cpp

set(MY_VAR "main.cpp;a.cpp")#字符串
message(AUTHOR_WARNING "${MY_VAR}") # main.cpp;a.cpp

set(MY_VAR "main.cpp a.cpp")
message(AUTHOR_WARNING "${MY_VAR}") # main.cpp a.cpp

# 多行
set(MY_CMD [[
#!/bin/bash

echo "ls"
echo "cmake"
]])
message(AUTHOR_WARNING "${MY_CMD}")
```

关于分隔符 `[[`与`]]`，`[=[`与`]=]`

[[ 分隔符用于定义 CMake 中的逻辑表达式。在逻辑表达式中，可以使用一些逻辑运算符（如 && 和 ||），以及一些常用的比较符（如 ==、!=、<、>、<=、>= 等）。逻辑表达式通常用于条件判断，如 if 命令中。

[=[ 和 ]=] 分隔符用于定义 CMake 中的字符串字面值（string literal）

## ENV{}

在cmake中可以使用系统环境变量，CMake设置的环境变量只在此CMake构建进程中有效

```cmake
# 定义环境变量
set(ENV{PATH} "$ENV{PATH}:/opt/main")
```

样例

```cpp
cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)
project(tubekit)

message(STATUS "PATH=$ENV{PATH}")
set(ENV{PATH} "$ENV{PATH}:/opt/Main")
message(STATUS "$ENV{PATH}")
```

## option

定义BOOL缓存变量，ON、TRUE、1、OFF、FALSE、0

```cpp
option(my_opt "select status" OFF)
# 修改my_opt
set(my_opt ON CACHE BOOL "select status" FORCE)
message(STATUS ${my_opt})# ON
```

## 变量作用域

add_subdirectory、定义函数、使用block()时产生新作用域  
缓存变量、环境变量作用域是全局的

## block

局部作用域相当于，C++中的{},只不过要CMake>=3.25

```cpp
block()
    set(x 1)
    set(y 2)
endblock()
```

block 还提供了相关参数，去选择使用引用外部的x、y变量等机制

总之用处不大

## 字符串

CMake有字符串类型，而且提供了许多字符串内置操作

### 查找

```cmake
string(FIND inputString subString outVar [REVERSE])
```

* 在 inputString 中查找 subString，将查找到的索引存在 outVar 中，索引从 0 开始。
* 如果没有 REVERSE 选项，则保存第一个查找到的索引，否则保存最后一个查找到的索引。
* 如果没有找到则保存 -1。

需要注意的是，string(FIND) 将所有字符串都作为 ASCII 字符，outVar 中存储的索引也会以字节为单位计算，因此包含多字节字符的字符串可能会导致意想不到的结果。

```cmake
string(FIND abcdefabcdef def fwdIndex)
string(FIND abcdefabcdef def revIndex REVERSE)
message("fwdIndex = ${fwdIndex}\n"
        "revIndex = ${revIndex}")
```

### 替换

```cmake
string(REPLACE matchString replaceWith outVar input...)
```

* 将 input 中所有匹配 matchString 的都用 replaceWith 替换，并将结果保存到 outVar 中。
* 如果有多个 input，它们是直接连接在一起的，没有任何分隔符。

还支持则正则表达式替换字符串

```cmake
string(REGEX MATCH    regex outVar input...)
string(REGEX MATCHALL regex outVar input...)
string(REGEX REPLACE  regex replaceWith outVar input...)
```

* input 字符串同样会在开始匹配正则表达式前进行串联。
* MATCH 只查找第一个匹配的字符串，并保存到 outVar 中。
* MATCHALL 会查找所有匹配的字符串，并保存到 outVar 中，如果匹配到多个，outVar 将是一个列表，列表我们后面会讲。
* REPLACE 会将每一个匹配到的字符串用 replaceWith 替换后，将替换后的完整字符串放到 outVar 中。

```cmake
string(REGEX MATCH    "[ace]"           matchOne abcdefabcdef)
string(REGEX MATCHALL "[ace]"           matchAll abcdefabcdef)
string(REGEX REPLACE  "([de])" "X\\1Y"  replVar1 abc def abcdef)
string(REGEX REPLACE  "([de])" [[X\1Y]] replVar2 abcdefabcdef)
message("matchOne = ${matchOne}\n"
        "matchAll = ${matchAll}\n"
        "replVar1 = ${replVar1}\n"
        "replVar2 = ${replVar2}")
```

### 截取

```cmake
string(SUBSTRING input index length outVar)
```

* 将 input 字符串从 index 处截取 length 长度放到 outVar 中。
* 如果 length 为 -1 的话，将从 index 到 input 结尾的字符串串保存到 outVar 中。

### 其他

```cmake
# 字符串查找和替换
  string(FIND <string> <substring> <out-var> [...])
  string(REPLACE <match-string> <replace-string> <out-var> <input>...)
  string(REGEX MATCH <match-regex> <out-var> <input>...)
  string(REGEX MATCHALL <match-regex> <out-var> <input>...)
  string(REGEX REPLACE <match-regex> <replace-expr> <out-var> <input>...)

# 操作字符串
  string(APPEND <string-var> [<input>...])
  string(PREPEND <string-var> [<input>...])
  string(CONCAT <out-var> [<input>...])
  string(JOIN <glue> <out-var> [<input>...])
  string(TOLOWER <string> <out-var>)
  string(TOUPPER <string> <out-var>)
  string(LENGTH <string> <out-var>)
  string(SUBSTRING <string> <begin> <length> <out-var>)
  string(STRIP <string> <out-var>)
  string(GENEX_STRIP <string> <out-var>)
  string(REPEAT <string> <count> <out-var>)

# 字符串比较
  string(COMPARE <op> <string1> <string2> <out-var>)

# 计算字符串的 hash 值
  string(<HASH> <out-var> <input>)

# 生成字符串
  string(ASCII <number>... <out-var>)
  string(HEX <string> <out-var>)
  string(CONFIGURE <string> <out-var> [...])
  string(MAKE_C_IDENTIFIER <string> <out-var>)
  string(RANDOM [<option>...] <out-var>)
  string(TIMESTAMP <out-var> [<format string>] [UTC])
  string(UUID <out-var> ...)

# json 相关的字符串操作
  string(JSON <out-var> [ERROR_VARIABLE <error-var>]
         {GET | TYPE | LENGTH | REMOVE}
         <json-string> <member|index> [<member|index> ...])
  string(JSON <out-var> [ERROR_VARIABLE <error-var>]
         MEMBER <json-string>
         [<member|index> ...] <index>)
  string(JSON <out-var> [ERROR_VARIABLE <error-var>]
         SET <json-string>
         <member|index> [<member|index> ...] <value>)
  string(JSON <out-var> [ERROR_VARIABLE <error-var>]
         EQUAL <json-string1> <json-string2>)
```

## 列表

上面set可知道，可以定义列表变量，cmake中提供了大量的列表相关的操作

```cmake
# 读取
  list(LENGTH <list> <out-var>)
  list(GET <list> <element index> [<index> ...] <out-var>)
  list(JOIN <list> <glue> <out-var>)
  list(SUBLIST <list> <begin> <length> <out-var>)

# 搜索
  list(FIND <list> <value> <out-var>)

# 修改
  list(APPEND <list> [<element>...])
  list(FILTER <list> {INCLUDE | EXCLUDE} REGEX <regex>)
  list(INSERT <list> <index> [<element>...])
  list(POP_BACK <list> [<out-var>...])
  list(POP_FRONT <list> [<out-var>...])
  list(PREPEND <list> [<element>...])
  list(REMOVE_ITEM <list> <value>...)
  list(REMOVE_AT <list> <index>...)
  list(REMOVE_DUPLICATES <list>)
  list(TRANSFORM <list> <ACTION> [...])

# 排序
  list(REVERSE <list>)
  list(SORT <list> [...])
```

简单样例

```cpp
cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

project(main)

set(m_list)
list(APPEND m_list "a" "c" "b")
foreach(var IN LISTS m_list)
    message(STATUS ${var})    
endforeach()

# a c b
set(var)
list(GET m_list 0 var)
message(STATUS ${var}) #a

# 追加
list(APPEND m_list 1)

# 排序
list(SORT m_list)

foreach(var IN LISTS m_list)
    message(STATUS ${var})
endforeach()
# 1 a b c
```

## math

cmake提供了数学计算，使用math函数实现

```cmake
math(EXPR outVar mathExpr [OUTPUT_FORMAT format])
```

直接通过 CMake 变量结合数学运算符组成 mathExpr，然后计算结果会保存到 outVar 中。

OUTPUT_FORMAT 是可选参数，代表输出结果的格式，可以是 HEXADECIMAL：输出 16 进制结果，DECIMAL：输出 10 进制结果。

样例

```cmake
cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

project(main)

set(x 1)
set(y 3)
math(EXPR outVar "(${x}*${y}) + 10" OUTPUT_FORMAT DECIMAL)
message(STATUS ${outVar})
# 13
```

## if

像编程语言一样cmake中可以使用流程控制

```cmake
if(expression1)
  # commands
elseif(expression2)
  # commands
else()
    # commands
endif()
```

### 基本条件表达式

```
if(value)
```

ON、YES、TRUE、Y 被视为真  
OFF、NO、FALSE、N、IGNORE、NOTFOUND、空字符串、以 -NOTFOUND 结尾的字符串被视为假。  
如果是一个数字，将根据 C 语言的规则转换成 bool 值。  
如果上述三种情况都不适用，那该条件表达式将被当作一个变量的名字。  
如果没有使用引号，那该变量的值会和为假的值对比，如果匹配上则为假，否则为真。  
如果其值是空字符串则为假。  
如果使用引号  
cmake 3.1 及以后，如果该字符串不匹配任何为真的值，那该条件表达式为假。  
cmake 3.1 以前，如果该字符串匹配到任何存在的变量名字，则会按照变量处理。  
if(ENV{some_var}) 这种形式的条件表达式永远为假，所以不要使用环境变量。  

### 逻辑表达式

```cmake
# Logical operators
if(NOT expression)
if(expression1 AND expression2)
if(expression1 OR expression2)

# Example with parentheses
if(NOT (expression1 AND (expression2 OR expression3)))
```

### 比较表达式

```cmake
if(value1 OPERATOR value2)
```

| Numeric | String | Version numbers | Path |
| --- | --- | --- | --- |
| LESS | STRLESS | VERSION_LESS |  |
| GREATER | STRGREATER | VERSION_GREATER |  |
| EQUAL | STREQUAL | VERSION_EQUAL | PATH_EQUAL |
| LESS_EQUAL | STRLESS_EQUAL | VERSION_LESS_EQUAL |  |
| GREATER_EQUAL | STRGREATER_EQUAL | VERSION_GREATER_EQUAL |  |

### 正则表达式

```cmake
if(value MATCHES regex)
if("Hi from ${who}" MATCHES "Hi from (Fred|Barney).*")
  message("${CMAKE_MATCH_1} says hello")
endif()
```

### 文件系统相关表达式

```cmake
if(EXISTS pathToFileOrDir)
if(IS_DIRECTORY pathToDir)
if(IS_SYMLINK fileName)
if(IS_ABSOLUTE path)
if(file1 IS_NEWER_THAN file2)
```

在没有变量引用符号时，不会执行任何变量替换。

```cmake
set(firstFile "/full/path/to/somewhere")
set(secondFile "/full/path/to/another/file")

if(NOT EXISTS ${firstFile})
        message(FATAL_ERROR "${firstFile} is missing")
elseif(NOT EXISTS ${secondFile} OR NOT ${secondFile} IS_NEWER_THAN ${firstFile})
        # ... commands to recreate secondFile
endif()
```

为什么要用 NOT IS_NEWER_THAN？

```cmake
# WARNING: Very likely to be wrong
if(${firstFile} IS_NEWER_THAN ${secondFile})
		# ... commands to recreate secondFile
endif()
```


### 判断是否存在表达式

```cmake
if(DEFINED name)
if(COMMAND name)
if(POLICY name)
if(TARGET name)
if(TEST name)               # Available since CMake 3.4
if(value IN_LIST listVar)   # Available since CMake 3.3
if(DEFINED SOMEVAR)           # Checks for a CMake variable (regular or cache)
if(DEFINED CACHE{SOMEVAR})    # Checks for a CMake cache variable
if(DEFINED ENV{SOMEVAR})      # Checks for an environment variable
```

## for

对一个列表的元素进行遍历，或者需要对一堆的值进行相似的操作

### foreach

```cmake
foreach(loopVar arg1 arg2 ...)
    # ...
endforeach()

foreach(loopVar IN [LISTS listVar1 ...] [ITEMS item1 ...])
    # ...
endforeach()
```

第一种形式很简单，每一次循环，loopVar 都讲从 arg1 arg2 ... 中取出一个值，然后在循环体中使用。

第二种形式比较通用，但是只要有 IN 关键字，那后面的 [LISTS listVar1 ...] [ITEMS item1 ...] 就必须有其一或者都有，当两者都有的时候，[ITEMS item1 ...] 需要全部放在 [LISTS listVar1 ...] 后面。

还有一点需要注意的是，[ITEMS item1 ...] 中的 item1 ... 都不会作为变量使用，就仅仅是字符串或者值。

```cmake
set(list1 A B)
set(list2)
set(foo WillNotBeShown)

foreach(loopVar IN LISTS list1 list2 ITEMS foo bar)
    message("Iteration for: ${loopVar}")
endforeach()
```

Cmake 3.17 中添加了一种特殊的形式，可以在一次循环多个列表，其形式如下：

```cmake
foreach(loopVar... IN ZIP_LISTS listVar...)
    # ...
endforeach()
```

如果只给出一个 loopVar，则该命令将在每次迭代时设置 loopVar_N 形式的变量，其中 N 对应于 listVarN 变量。编号从 0 开始。如果每个 listVar 都有一个 loopVar，那么该命令会一对一映射它们，而不是创建 loopVar_N 变量。以下示例演示了这两种情况：

```cmake
set(list0 A B)
set(list1 one two)

foreach(var0 var1 IN ZIP_LISTS list0 list1)
    message("Vars: ${var0} ${var1}")
endforeach()

foreach(var IN ZIP_LISTS list0 list1)
    message("Vars: ${var_0} ${var_1}")
endforeach()
```

以这种方式“压缩”的列表不必长度相同。当迭代超过较短列表的末尾时，关联的迭代变量将未定义。取未定义变量的值会导致空字符串。下一个示例演示了行为：

```cmake
set(long  A B C)
set(short justOne)

foreach(varLong varShort IN ZIP_LISTS long short)
    message("Vars: ${varLong} ${varShort}")
endforeach()
```

CMake 的 for 循环还有一种类似于 C 语言的 for 循环的形式，如下：

```cmake
foreach(loopVar RANGE start stop [step])
foreach(loopVar RANGE value)
```

第一种形式，在 start 到 stop 之间迭代，可以指定步长 step。 第二种形式等价于：

```cmake
foreach(loopVar RANGE 0 value)
```

## while

```cmake
while(condition)
    # ...
endwhile()
```

condition 的判断规则同 if() 命令

```cmake
set(num 10)
while(num GREATER 0)
    message(STATUS "current num = ${num}")
    math(EXPR num "${num} - 1")
endwhile()
```

## break与continue

while 循环和 foreach 循环都支持提前退出循环

```cmake
foreach(outerVar IN ITEMS a b c)
    unset(s)
    foreach(innerVar IN ITEMS 1 2 3)
        # Stop inner loop once string s gets long
        list(APPEND s "${outerVar}${innerVar}")
        string(LENGTH "${s}" length)
        if(length GREATER 5)
            # End the innerVar foreach loop early
            break()
        endif()
        # Do no more processing if outerVar is "b"
        if(outerVar STREQUAL "b")
            # End current innerVar iteration and move on to next innerVar item
            continue()
        endif()
        message("Processing ${outerVar}-${innerVar}")
    endforeach()
    message("Accumulated list: ${s}")
endforeach()
```

block() 和 endblock() 命令定义的块内也允许 break() 和 continue() 命令

```cmake
set(log "Value: ")
set(values one two skipMe three stopHere four)
set(didSkip FALSE)
while(NOT values STREQUAL "")
    list(POP_FRONT values next)
    # Modifications to "log" will be discarded
    block(PROPAGATE didSkip)
        string(APPEND log "${next}")
        if(next MATCHES "skip")
            set(didSkip TRUE)
            continue()
        elseif(next MATCHES "stop")
            break()
        elseif(next MATCHES "t")
            string(APPEND log ", has t")
        endif()
        message("${log}")
    endblock()
endwhile()
message("Did skip: ${didSkip}")
message("Remaining values: ${values}")
```

## 如何使用子目录

CMake提供了两个命令来解决多级目录的问题，分别为add_subdirectory和include

### add_subdirectory

函数原型

```cmake
add_subdirectory(sourceDir [binaryDir] [EXCLUDE_FROM_ALL] [SYSTEM])
# [SYSTEM] 需要 CMake >= 3.25
```

sourceDir 通常是当前 CMakeLists.txt 所在目录的子目录，但是它也可以是其它路径下的目录。可以指定绝对路径或者相对路径，如果是相对路径的话，是相对于当前目录的。

通常 binaryDir 不需要指定，不指定的情况下，CMake 会在构建目录中对应的位置创建和源码目录对应的目录，用于存放构建输出。但是当 sourceDir 是源外路径的话，binaryDir 需要明确指定。

其中：  
source_dir 是子目录的路径，包含一个 CMakeLists.txt 文件。  
binary_dir 是一个可选参数，指定在其中生成二进制文件的目录。  
EXCLUDE_FROM_ALL 是一个可选参数，指定将该目录排除在 all 编译选项之外。  
如果省略 binary_dir 参数，则使用与 source_dir 相同的目录来生成二进制文件。如果指定了
EXCLUDE_FROM_ALL 参数，则该目录中的构建规则不会包括在 all 编译选项中。  

注意，add_subdirectory 命令只适用于在同一 CMake 构建中构建的子目录。如果要构建另一个独立的项目，则应该使用 ExternalProject_Add 命令。

### EXCLUDE_FROM_ALL 场景案例

一个常见的例子是，在一个项目中可能会包含多个子目录，其中有些子目录是可选的或只在特定条件下才需要编译。如果没有使用EXCLUDE_FROM_ALL参数，那么CMake将默认构建所有子目录，这可能会浪费时间和资源。

例如，假设一个项目包含以下子目录：

```cpp
root/
├── CMakeLists.txt
├── lib/
│   ├── CMakeLists.txt
│   └── lib_source.cpp
└── app/
    ├── CMakeLists.txt
    └── app_source.cpp
```

其中lib是一个可选的库，只有在某些条件下才需要编译。如果没有使用EXCLUDE_FROM_ALL，则在执行cmake和make时，CMake会自动构建lib和app目录中的所有内容。

可以使用EXCLUDE_FROM_ALL来指定lib子目录不应被默认构建。例如，在root/CMakeLists.txt中添加以下内容：

```cmake
add_subdirectory(lib EXCLUDE_FROM_ALL)
add_subdirectory(app)
```

现在，在执行cmake和make时，CMake仅会构建app目录中的内容，lib目录中的内容则不会被默认构建。

如果需要构建lib目录，可以使用以下命令：

```shell
make lib
```

### 相关变量

CMake 提供了一些变量来跟踪当前正在处理的 CMakeLists.txt 文件的源和二进制目录。以下是一些只读变量，随着每个文件被 CMake 处理，这些变量会自动更新。它们始终包含绝对路径。

* CMAKE_SOURCE_DIR  
  源代码的最顶级目录（即最顶级 CMakeLists.txt 文件所在的位置）。这个变量的值永远不会改变。
* CMAKE_BINARY_DIR  
  构建目录的最顶级目录。这个变量的值永远不会改变。
* CMAKE_CURRENT_SOURCE_DIR
  当前正在被 CMake 处理的 CMakeLists.txt 文件所在的目录。每当由 add_subdirectory() 调用处理新文件时，它都会更新，当处理该目录完成时，它会被还原回原来的值。
* CMAKE_CURRENT_BINARY_DIR  
  由 CMake 处理的当前 CMakeLists.txt 文件所对应的构建目录。每次调用 add_subdirectory() 时都会更改该目录，当 add_subdirectory() 返回时将其恢复。

~/CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.16)

project(MyApp)

# ~
message("top: CMAKE_SOURCE_DIR              = ${CMAKE_SOURCE_DIR}")
# ~
message("top: CMAKE_BINARY_DIR              = ${CMAKE_BINARY_DIR}")
# ~
message("top: CMAKE_CURRENT_SOURCE_DIR      = ${CMAKE_CURRENT_SOURCE_DIR}")
# ~
message("top: CMAKE_CURRENT_BINARY_DIR      = ${CMAKE_CURRENT_BINARY_DIR}")

add_subdirectory(subdir)

# ~
message("top: CMAKE_CURRENT_SOURCE_DIR      = ${CMAKE_CURRENT_SOURCE_DIR}")
# ~
message("top: CMAKE_CURRENT_BINARY_DIR      = ${CMAKE_CURRENT_BINARY_DIR}")
```

~/subdir/CMakeLists.txt

```cmake
# ~
message("mysub: CMAKE_SOURCE_DIR            = ${CMAKE_SOURCE_DIR}")
# ~
message("mysub: CMAKE_BINARY_DIR            = ${CMAKE_BINARY_DIR}")
# ~/subdir
message("mysub: CMAKE_CURRENT_SOURCE_DIR    = ${CMAKE_CURRENT_SOURCE_DIR}")
# ~/subdir
message("mysub: CMAKE_CURRENT_BINARY_DIR    = ${CMAKE_CURRENT_BINARY_DIR}")
```

### 实际构建工程简单样例

假设有一个多级目录的C++工程，其目录结构如下

```cmake
CMakeLists.txt
src/
├── CMakeLists.txt
├── main.cpp
├── sub1/
│   ├── CMakeLists.txt
│   ├── sub1.cpp
│   └── sub1.h
└── sub2/
    ├── CMakeLists.txt
    ├── sub2.cpp
    └── sub2.h
```

其中，最外层的 CMakeLists.txt 的内容如下：

```cmake
cmake_minimum_required(VERSION 3.0)
project(my_project)
add_subdirectory(src)
```

src/CMakeLists.txt 的内容如下：

```cmake
add_subdirectory(sub1)
add_subdirectory(sub2)
add_executable(my_project main.cpp)
target_link_libraries(my_project sub1 sub2)
```

src/sub1/CMakeLists.txt 的内容如下：

```cmake
add_library(sub1 sub1.cpp sub1.h)
# 默认为STATIC库
```

src/sub2/CMakeLists.txt 的内容如下

```cmake
add_library(sub2 sub2.cpp sub2.h)
```

## 子目录相关的作用域详解

add_subdirectory() 命令引入一个新的子目录的同时，也引入了新的作用域，相对于调用 add_subdirectory() 命令的 CMakeLists.txt 所在的作用域来说，通过 add_subdirectory() 命令引入的新的作用域叫做子作用域。其行为类似于 C/C++ 语言中调用一个新的函数。

调用 add_subdirectory() 命令的时候，当前作用域内的变量均会复制一份到子作用域，子作用域中对这些复制的变量进行操作不会影响到当前作用域中这些变量的值。

在子作用域中定义的新的变量对父作用域是不可见的。

### 样例

CMakeLists.txt

```cmake
set(myVar foo)
#foo
message("Parent (before): myVar    = ${myVar}")
#
message("Parent (before): childVar = ${childVar}")
add_subdirectory(subdir)
#foo
message("Parent (after):  myVar    = ${myVar}")
#
message("Parent (after):  childVar = ${childVar}")
```

subdir/CMakeLists.txt

```cmake
#foo
message("Child  (before): myVar    = ${myVar}")
#
message("Child  (before): childVar = ${childVar}")
set(myVar bar)
set(childVar fuzz)
#bar
message("Child  (after):  myVar    = ${myVar}")
#fuzz
message("Child  (after):  childVar = ${childVar}")
```

### 如何写父作用域变量

set函数支持 PARENT_SCOPE 选项

CMakeLists.txt

```cmake
set(myVar foo)
#foo
message("Parent (before): myVar = ${myVar}")
add_subdirectory(subdir)
#bar
message("Parent (after):  myVar = ${myVar}")
```

subdir/CMakeLists.txt

```cmake
#foo
message("Child  (before): myVar = ${myVar}")
set(myVar bar PARENT_SCOPE)
#foo 因为子作用域拷贝的myVar没有改变
message("Child  (after):  myVar = ${myVar}")
```

## 子目录定义project

project() 命令对于一个项目来说是必须的，如果开发人员没有显式的调用 project() 命令，在运行 cmake 进行项目配置的时候会收到警告信息，同时，cmake 会隐式地添加 project() 命令的调用。强烈建议在顶层 CMakeLists.txt 中适当的位置显式的调用 project() 命令。

porject() 命令可不可以调用多次？  

可以的，但是需要有 add_subdirectory() 命令调用的情况下才行，也就是说，我们不能在同一个 CMakeLists.txt 中调用 project() 命令多次，但是可以在 add_subdirectory() 命令调用时引入的子目录中的 CMakeLists.txt 中再次调用 project() 命令。通常这样做没有什么坏处，但是会导致 CMake 生成更多的项目文件。

## include

CMake 可以通过include命令引入子目录，然后子目录中必须有一个 CMakeLists.txt，这相当于给顶层的 CMakeLists.txt 引入了新的 CMake 内容。

### fileName

```cmake
include(fileName [OPTIONAL] [RESULT_VARIABLE myVar] [NO_POLICY_SCOPE])
```

其中 <file> 指定要包含的文件名或路径，可以是相对路径或绝对路径。

OPTIONAL 选项表示如果找不到指定的文件，不会抛出错误，而是继续执行脚本。

RESULT_VARIABLE 选项指定一个变量名，用于接收 include 命令的结果。如果指定了该选项，CMake 将会在执行指定文件后将结果存储在该变量中。如果指定的文件不存在，则该变量将被设置为空字符串。

NO_POLICY_SCOPE参数表示在包含给定的脚本时，不应用此命令之前设置的策略或变量范围。也就是说，该选项会在一个新的独立作用域中执行给定的脚本文件，而不会受到任何外部策略或变量的影响。

使用 include 命令时需要注意避免文件循环包含，即 A 包含 B，B 又包含 A，这样会导致 CMake 陷入无限递归。

样例

~/CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.16 FATAL_ERROR)
project(main)

# ~
message(${CMAKE_CURRENT_BINARY_DIR})
#~
message(${CMAKE_CURRENT_SOURCE_DIR})

set(ENABLE_FEATURE ON)
#本质就是把syvdir/CMakeLists.txt的内容搬到此处
include(subdir/CMakeLists.txt OPTIONAL)

#Feature is disabled
if(ENABLE_FEATURE)
    message("Feature is enabled")
else()
    message("Feature is disabled")
endif()
```

~/subdir/CMakeLists.txt

```cmake
#ON
message(${ENABLE_FEATURE})
set(ENABLE_FEATURE OFF)
#OFF
message(${ENABLE_FEATURE})
#~
message(${CMAKE_CURRENT_BINARY_DIR})
#~
message(${CMAKE_CURRENT_SOURCE_DIR})
```

### 相关变量

CMAKE_CURRENT_LIST_DIR： 类似于 CMAKE_CURRENT_SOURCE_DIR，只是在处理 include 的文件时会更新。这是需要处理的当前文件的目录时使用的变量，无论它是如何添加到构建的。它将永远是一个绝对路径。

CMAKE_CURRENT_LIST_FILE： 始终提供当前正在处理的文件的名称。它始终持有文件的绝对路径，而不仅仅是文件名。

CMAKE_CURRENT_LIST_LINE： 保存当前正在处理的文件的行号。这个变量很少需要，但在某些调试场景中是很有用的。

~/CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.16 FATAL_ERROR)
project(main)

message(${CMAKE_CURRENT_LIST_DIR})# ~
message(${CMAKE_CURRENT_LIST_FILE})#~/CMakeLists.txt
message(${CMAKE_CURRENT_LIST_LINE})#6

include(subdir/CMakeLists.txt OPTIONAL)
```

~/subdir/CMakeLists.txt

```cmake
message(${CMAKE_CURRENT_LIST_DIR})#~/subdir
message(${CMAKE_CURRENT_LIST_FILE})#~/subdir/CMakeLists.txt
message(${CMAKE_CURRENT_LIST_LINE})#3
```

## 项目相关的变量

## 提前结束处理return

## 函数和宏基础

## 函数和宏的参数处理基础

## 函数和宏之关键字参数

## 函数和宏返回值

## cmake命令覆盖详解

## 函数相关的特殊变量

## 复用cmake代码

## cmake处理参数时的一些问题

## cmake预设

## cmake工具链
