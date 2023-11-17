---
cover: >-
  https://images.unsplash.com/photo-1650170496638-b05030a94005?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI1MzAzMzQ&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 热更新

## 热更新

运营期的游戏必须保证能够提供稳定的服务，然而手游的开发节奏很快，难免要修复 Bug，或者线上调整数值。如果每次修改都要重启服务端，把全部玩家踢下线，那么这无疑会加速用户流失，影响营收。

怎样才能实现热更新，有人说

“热更新是结构设计问题，需要做好架构解耦”
“谁说只有脚本语言能热更新的？C 语言写的 Nginx 就能做到”
“做成微服务就行了”

可是，到底怎么做才是解耦，怎样做才能微服务化，它们又有哪些限制。

Skynet 的业务由 Lua 语言编写，可以使用常规的 Lua 热更新方法，Skynet 的 Actor 架构还提供了利用
“独立虚拟机”作为“服务”级别的热更新的能力，以及“注入补丁”的热更新方法。

热更新技术往往与具体的游戏业务相关联，只有充分理解业务才能选取合适的热更新方案。

### 简化版游戏服务端

只有一个进程，包括网关服务与多个 Player 服务。也就是只有一个 Skynet 节点。

例如我们在线上发现了某些 Player 服务的业务错误需要修复，希望在不停服务的情况下进行修改更新。“热更新”与服务端的架构设计息息相关，Skynet 实现了 Actor 模型，还为每个 Lua 服务开启了独立的虚拟机，这种架构为 Skynet 提供了一些热更新的能力。

可以这样理解：开启新的服务时，虚拟机需要重新加载 Lua 代码，所以只要先修改 Lua 代码，再重启（或新建）服务，新开的服务就会基于新代码运行，实现热更新。

### 清除代码缓存

直接修改 Lua 代码并不能起作用，这是因为 Skynet 使用了修改版的 Lua 虚拟机，它会缓存代码，所以在修改 Lua 代码后，要先登录调试控制台。

Skynet 调试控制台的 clearcache 指令虽然称为清缓存，但是并不是真的清理操作而是额外加载一份代码，频繁执行 clearcache 会加大内存开销。

skynet 独立虚拟机热更新的方式适合在“一个客户端对应一个代理服务”的架构下热更新代理服务，以及在“开房间型”游戏中热更新战斗服务。

```lua
                        Skynet
            match battle1 battle2
            agent_mgr agent101 agent102 agent103

client------>gateway1 gateway2 login
```

虽然旧的比赛执行的依旧是旧代码，但新开的比赛就能运行新的版本。由于每个客户端的登录时长有限、每场战斗的持续时间也有限，程序最终会趋向于运行新版本。

### 注入补丁

Skynet 还提供了一种称为 inject 的热更新方案，写一份补丁文件，将其注入某个服务，就可以单独修复这个服务的 bug。例如针对某个玩家的 agent 服务，注入补丁。

### 编写补丁文件

虽然 skynet 提供了注入的热更新方案，却没有给予足够的支持，补丁文件的写法颇具技巧性。

```lua
--hagent.lua
--老代码
local skynet = require(...)
local coin = 0

function onMsg(data)
    //...
end

skynet.start(...)
```

补丁代码

```lua
--skynet/examples/hinject.lua
local oldfun = _P.lua._ENV.onMsg
_P.lua._ENV.onMsg = function(data)
    //引用原来的变量
    local _, skynet = debug.getupvalue(oldfun, 1)
    local _, coin = debug.getupvalue(oldfun, 2)
    skynet.error("agent recv "..data)
    --消息处理
    if data == "workd\r\n" then
        coin = coin + 2
        debug.setupvalue(oldfun, 2, coin)
        return coin.."\r\n"
    end
    return "err cmd\r\n"
end
```

> “\_P”是 Skynet 提供的变量，用于获取旧代码的内容，“\_P.lua.\_ENV.onMsg”即原先的 onMsg 方法，
> 重新为它赋值，即可换成新的方法。因为新、旧方法的运行环境不同，
> 新方法不能直接读取 skynet、coin 等外部变量，所以这里还要依靠一些小技巧，通过 Lua 的调试模块（debug）来获取外部值的。

写完补丁文件，在调式控制台输入 inject a examples/hinject.lua 即可完成热更新。其中，"a"为代理服务的 id，可从服务端的输出日志中获取。"example/hinject.lua"是补丁文件的路径。

### 适用场景

"注入"热更新方案适用于需要紧急修复 Bug 的情况，补丁写法比较诡异，容易出错，需要在开发环境中做严密测试。

Lua 调式模块的运行效率低，还会破坏语言封装的整体性，因此若不是非常危急的情况，则尽量不要使用。

Skynet 只提供了针对某个服务的注入功能，若要热更某类服务，还需自行实现。

### 冷更新

### 《跳一跳》案例

### 优雅的进程切换

### fork 和 exec

### Nginx 的热更新方法

### 利用网关实现热更新

### 数据与逻辑分离

### 微服务

### 动态库案例

### 实现动态库热更新

### 动态库的限制

### 动态库在游戏中的应用

### 多线程与版本管理

### 脚本语言业务需求

### 实现 Lua 热更新

### 尽量做正确的热更新

### 没有万能药的根源

### 选择何使的热更新范围
