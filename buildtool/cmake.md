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

## 子目录相关的作用域详解

## 子目录定义project

## include

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
