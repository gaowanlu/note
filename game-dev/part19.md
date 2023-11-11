---
cover: >-
  https://images.unsplash.com/photo-1650170496638-b05030a94005?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI1MzAzMzQ&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 嵌入 Lua 脚本语言

## 嵌入 Lua 脚本语言

Lua 是一种轻量小巧的脚本语言，免费开源，简单易学。C/C++这类“低级语言”胜在能够直接与操作系统打交道，从而能够最大限度地利用系统资源，但写逻辑不太方便。“C++/Lua”是游戏业界比较常用的一种开发解决方案，用 C++做服务端底层，再嵌入 Lua 编写业务逻辑，这种组合能够较好地平衡性能与开发效率。

### 方案设计

C++负责底层调度，Lua 负责业务逻辑 就像 skynet 一样

### 隔离服务

系统可以调度数千个服务，各个 Lua 虚拟机相互独立，符合服务的特性，因此每个服务开启一个 Lua 虚拟机，
各个服务的 Lua 代码相互隔离

![Lua虚拟机和脚本文件示意图](../.gitbook/assets/2023-11-07233325.png)

服务可以分为很多类型，同一类型的服务对应同一份 Lua 脚本。每份脚本都提供了 OnInit、
OnServiceMsg 等回调方法，在创建服务时，C++底层会调用对应脚本的 OnInit 方法，当收到消息时，C++
底层会调用 OnServiceMsg 方法。

### 嵌入 Lua 虚拟机

嵌入 Lua 脚本，首先要引入 Lua 源码，再调用一些 API，设置编译参数。

### 下载、编译源码

不再详解，可以搜教程，或者 看下我的项目用 CMake 生成 Makefile 构建为静态库的，值得注意的是 lua 静态库依赖 dl 库

```cpp
https://github.com/crust-hub/tubekit/tree/main
target_link_libraries(exe liblua.a dl)
```

### lua_State

lua_State 是 Lua 提供给宿主语言（C/C++）的一种最重要的数据结构，顾名思义，lua_State 代表 Lua 的运行状态。可以创建多个 lua_State 对象，它们之间相互独立，就像创建了多个独立的虚拟机一样。Lua 提供的各种 API，大多都是围绕着 lua_State 进行操作的，比如，运行某个 Lua 文件，就是让 lua_State 去加载代码，然后执行的过程；调用某个 Lua 方法，就是操作 lua_State 的过程。

每个服务对应于一个 Lua 虚拟机

由于 Lua 是由 C 语言编写的，因此 Service.h 在包含 Lua 源码中的头文件时，需要把包含（include）语句放在“extern "C"”块中，lua.h、lauxlib.h 和 lualib.h 这三个头文件中包含了操作 lua_State 的常用方法。

```cpp
// include/Service.h
extern "C" {
  #include "lua.h"
  #include "lauxlib.h"
  #include "lualib.h"
}

class Service {
  //...
private:
  // Lua虚拟机
  lua_State* luaState;
};
```

仅创建了 lua_State 的结构指针，并未真正创建对象，可用 luaL_newstate 创建 lua_State 对象

![创建和销毁Lua虚拟机所用到的API及功能说明](../.gitbook/assets/2023-11-08000404.png)

### 从创建到销毁

虚拟机的生命流程贯穿了服务的整个生命周期，即在服务的初始化回调 OnInit 中创建和初始化虚拟机，在退出回调 OnExit 中销毁虚拟机。

```cpp
// scr/Service.cpp
// 创建服务后触发
void Service::OnInit()
{
  // 新建lua虚拟机
  luaState = luaL_newstate();
  luaL_openlibs(luaState);
  // 执行Lua文件
  string filename = "../service/" + *type + "/init.lua"
  int isok = luaL_dofile(luaState, filename.data());
  // 成功返回0，失败返回1
  if(isok == 1)
  {
    cout<<"err "<<lua_tostring(luaState, -1)<< endl;
  }
}

// 退出服务时触发
void Service::OnExit()
{
  // 关闭Lua虚拟机
  lua_close(luaState);
}
```

![Lua虚拟机的声明流程](../.gitbook/assets/2023-11-08001054.png)

### C++调用 Lua 方法

Lua 封装其实就是两个过程，一是把服务的回调方法 OnInit、OnExit、OnServiceMsg 等映射到 Lua 脚本上，当服务启动时会调用 Lua 的 OnInit 方法，当接收消息时，会调用 Lua 的 OnServiceMsg 方法。
二是为 Lua 提供一些功能，如发送消息的 Send 方法、开启服务的 NewService 方法。

```lua
-- service/main/init.lua
print("run lua init.lua")
function OnInit(id)
	print("[lua] main OnInit id:"..id)
end

function OnExit()
	print("[Lua] main OnExit")
end
```

为了实现 C++ 调用 Lua 的功能，在初始化 Lua 虚拟机之后，需要连接调用 lua_getglobal、lua_pushintegr、lua_pcall 这三个方法。

```cpp
void Service::OnInit()
{
	// 新建Lua虚拟机
	// 执行Lua文件
	// 调用Lua函数
	lua_getglobal(luaState, "OnInit")
	lua_pushinteger(lusState, id)
	isok = lua_pcall(luaState, 1, 0, 0)
	if(isok != 0)
	{
		cout << "call lua OnInit fail" <<endl;
		cout << lua_tostring(luaState, -1) <<endl;
	}
}
```

C++调用 Lua 方法设计的 API

```cpp
int lua_getglobal(lua_State *L, const char *name)
把name指定的全局变量压入栈，并返回该值的类型，例如lua_getglobal(luaState, "OnInit")就是将Lua脚本中的OnInit方法压入栈顶。
在Lua中，所谓把“方法”压栈，就是把方法的内存地址压栈。
```

```cpp
void lua_pushinteger(lua_State *L, lua_Integer n)
将整形数n压入栈中
```

```cpp
int lua_pcall(lua_State *L, int nargs, int nresults, int msgh)
调用一个Lua方法，nargs代表Lua方法的参数个数；nresults代表Lua方法的返回值个数；msgh用于指示如果调用失败则采用什么样的方式处理，填写0代表使用默认方法。
如果调用成功，则lua_pcall返回0，否则返回非0，并把错误的原因字符串压入栈中。
```

```cpp
const char* lua_tostring(lua_State *L, int index);
把给定索引处的Lua值转换为一个C字符串，如果lua_pcall调用失败，则把错误的原因字符串压入栈中，可以用lua_tostring取出刚压入栈的字符串。
```

"栈"是理解 Lua 与 C++交互的关键概念，只有做到脑中有栈，才能用好它。

对于 lua_State 最核心的数据结构是一个调用栈，大部分交互 API 都在操作这个栈。
lua_pcall 并不能直接指定要调用的方法和参数，开发者只能按照它的规则，在栈中准备好数据，等待 lua_pcall 读取。
将方法与参数压入栈

```cpp
栈顶
		参数...
		参数2
		参数1
		方法
		？
		？
栈底
```

执行 lua_pcall 后，程序会自动删除先前准备的元素，并将返回值压入栈中。
除了 lua_pushinteger 之外，lua 还提供了 lua_pushboolean、lua_pushlstring 等等。
除了 lua_tostring 之外，Lua 还提供了 lua_tointeger 和 lua_tolstring 等方法获取栈中的元素。

C++与 Lua 是单线程交互，lua_pcall 的执行时间即 Lua 脚本的运行时间，如果 Lua 方法很复杂，lua_pcall 的执行时间可能会很长。

### Lua 调用 C++函数

把 C++的一些方法映射到 Lua 中，就能增强 Lua 的功能，例如，可以在 Lua 中调用“NewService("ping")”开启 ping 类型的新服务，调用"Send(1, 2, "hello")"向 2 号服务发送消息。

脚本模块都是一个相对独立的模块，需要新增 LuaAPI 类，专门用于存放 C++提供给 Lua 的方法。

如新建服务 NewService、删除服务 KillService、Send 发送消息、Listen 开启网络监听、CloseConn 关闭网络连接、Write 发送网络数据。
提供给 Lua 的方法必须符合固定的格式，都以 lua_State 对象为参数，并且返回整形数。

```cpp
// include/LuaAPI.h
#pragma once
extern "C"{
    #include "lua.h"
}

using namespace std;

class LuaAPI{
public:
    static void Register(lua_State *luaState);
    static int NewService(lua_State *luaState);
    static int KillService(lua_State *luaState);
    static int Send(lua_State *luaState);
    static int Listen(lua_State *luaState);
    static int CloseConn(lua_State *luaState);
    static int Write(lua_State *luaState);
};
```

LuaAPI 的实现

```cpp
int LuaAPI::NewService(lua_State *luaState)
{
    int num = lua_gettop(luaState);
    if(lua_isstring(luaState, 1) == 0)
    {
        lua_pushinteger(luaState, -1);
        return 1;
    }
    size_t len = 0;
    const char *type = lua_tolstring(luaState, 1, &len);
    char* newstr = new char[len+1];
    newstr[len] = '\0';
    memcpy(newstr, type, len);
    auto t = make_shared<string>(newstr);
    uint32_t id = Sunnet::Instance()->NewService(t);
    lua_pushinteger(luaState, id);
    return 1;
}
```

分析 4 个 API

```cpp
int lua_gettop(lua_State *L);
返回栈顶元素的索引，相当于返回栈上的元素个数
```

```cpp
int lua_isstring(lua_State *L, int index);
判断栈中指定位置的元素是否为字符串，如果是字符串或数字（数字总能转换成字符串），返回1否则返回0
```

```cpp
const char *lua_tolstring(lua_State *L, int index, size_t *len);
与lua_tostring类似，不同的是多了个参数len，它会把字符串的长度存入*len中
```

```cpp
void lua_pushinteger(lua_State *L, lua_Integer n)
把值为n的整数压栈
```

当 Lua 调用 C++时，被调用的方法会得到一个新的栈，新栈中包含了 Lua 传递给 C++的所有参数，而 C++方法需要把返回的结果放入栈中，以返回给调用者。C++方法有一套固定的编写套路，一般分为 获取参数、处理、返回结果 三个步骤

如果在 Lua 中调用 sunnet.NewService("ping"),那么参数"ping"会被压入栈中，此时栈只有一个元素，由于 Lua 中字符串是引用值，
因此栈只会记录字符串内存的地址，真正的字符串则由 Lua 虚拟机进行管理。

Lua 的八种基本类型

nil、boolean、number、string、function、userdata、thread、table。其中 string、table、function、thread、userdata 在 Lua 中称为对象，变量并不真的持有它们的值，只是保存了这些对象的引用，也就是这些类型为引用类型。

lua_gettop 的功能是获取栈的大小，在"Lua 调用 C++"的场景中相当于是获取参数的个数，可以自行加入一些判断，比如只允许 num 值为 1，否则返回错误。还需要进行参数类型检查。

Lua 提供了 lua_isstring、lua_isinteger 等方法来判断栈中元素类型。栈中元素可以用正数或负数的索引来表示，正数索引代表从栈底到栈顶的位置，负数索引代表从栈顶到栈底的位置。是从-1 与 1 开始的，绝对值是几就代表第几个。
lua 字符串是由 Lua 虚拟机管理的，Lua 虚拟机带有 GC 机制。

注册函数,C++方法需要注册，才能在 Lua 中使用。

```cpp
// src/LuaAPI.cpp
void LuaAPI::Register(lua_State *luaState)
{
    static luaL_Reg lulibs[] = {
        {"NewService", NewService},
        {"KillService", KillService},
        {"Send", Send},
        {"Listen", Listen},
        {"CloseConn", CloseConn},
        {"Write", Write},
        {NULL, NULL}
    };
    luaL_newlib(luaState, lualibs);
    lua_setglobal(luaState, "sunnet");
}

void Service::OnInit(){
    //创建lua虚拟机
    luaState = luaL_newstate();
    luaL_openlibs(luaState);
    LuaAPI::Register(luaState);
    //执行lua文件
}
```

三个 Lua 函数

```lua
luaL_Reg 用于注册函数的数组类型，数组最后一个元素必须为双NULL，表示结束
luaL_newlib 在栈中创建一张新表，把数组中的函数注册到表中
lua_setglobal 将栈顶元素放入全局空间，并重新命名
```

在书中还进行了，pingpong、聊天室的简单样例，用 Lua 与 C++配合写，在此重要的是我们学习 C++嵌入 Lua 虚拟机的做法。
C++和 Lua 交互的东西还是非常多的如
用户数据 userdata 的处理
协程的处理
闭包的处理
还需要通读 Lua 参考手册，手册中的内容比较简单易学。

服务端脚本并不局限于 Lua，大家还可以尝试用相似的方法，将 Lua 换成 Python、JavaScript 嵌入 v8 引擎、C#等语言，甚至还可以自行编写一套简易解释器。

### Lua 版的 PingPong

略

### Lua 版聊天室

略
