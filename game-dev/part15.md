---
cover: >-
  https://images.unsplash.com/photo-1650170496638-b05030a94005?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI1MzAzMzQ&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 🚗 球球大作战

## 球球大作战

本部分用一个完整游戏案例《球球大作战》，介绍分布式游戏服务端的实现方法。

### 功能需求

《球球大作战》是一款多人对战游戏，玩家控制一个小球，让它在场景中移动，场景会随机产生食物，小球吃掉（碰到）食物后，体积会增大。
数十名玩家在同一场景堆栈，体积大的玩家可以吃掉体积小的玩家。

整个游戏流程如下：

1. 玩家输入账号密码登录游戏
2. 进入主界面，可以设置本轮游戏的昵称、选择服务器
3. 当玩家点击界面中的“开始比赛”按钮时，会进入某一战斗场景，在这里可以与其他玩家对战

假设预估有数万到数十万玩家同时在线，服务端也要根据这个量级来设计。

### 方案设计

因为要支持数以万计的在线玩家，必然要采取分布式的设计方案。

### 拓扑结构

服务端拓扑结构设计如下

![服务端拓扑结构设计](../.gitbook/assets/2023-10-22232405.png)

其中的圆圈代表服务，圈内文字表明服务的类型和编号。每个节点被划分为两部分，其中用虚线框起来的为`本地服务`,方框外的称为`全局服务`

| 类型     | 说明                                                                                                          |
| -------- | ------------------------------------------------------------------------------------------------------------- |
| 本地服务 | 在单节点内是唯一的，但是它不具备全局唯一性的服务                                                              |
| 全局服务 | 在所有节点中都具有唯一性的服务，如图中的 agentmgr,可以把它部署到节点 1 或者节点 2，但是在整个架构中只能有一个 |

### 各服务功能

服务端包含了 gateway、login 等多个类型的服务

- gateway

网关，用于处理客户端连接的服务，客户端会连接某个网关，如果玩家尚未登录，网关会把消息转发给节点内某个登录服务器，
以处理账号校验等操作；如果登录成功，则会把消息转发给客户端对应的代理(agent),一个节点可以开启多个网关以分摊性能

- login

登录服务，用于处理登录逻辑的服务，账号校验，一个节点可以开启多个登录服务分摊性能。

- agent

代理，每个客户端会对应一个代理服务(agent),负责对应角色的数据加载，数据存储，单服逻辑处理（如强化装备、成就等）。
处于性能考虑，agent 必须与它对应的客户端连接（即客户端连接的 gateway）处于在同一个节点。

- agentmgr

管理代理(agent)的服务，它会记录每个 agent 所在的节点，避免不同的客户端登录同一个账号

- nodemgr

节点管理，每个节点会开启一个 nodemgr 服务，用于管理该节点和监控性能

- scene

场景服务，处理战斗逻辑的服务，每一局游戏由一个场景服务负责。

### 消息流程

从客户端发起连接开始，服务端内部的消息处理流程如下，简化忽略了 nodemgr

![服务端消息处理流程](../.gitbook/assets/2023-10-22234252.png)

- 登录过程

在第 1 阶段，客户端连接某个 gateway，然后发送登录协议，gateway 将登录协议转发给 login（阶段 2），校验账号后，
由 agentmgr 创建与客户端对应的 agent（阶段 3 和 4）完成登录。如果玩家已经在其他节点登录，agentmgr 会把另一个客户端下线处理。

- 游戏过程

登录成功后，客户端的消息经由 gateway 转发给对应的 agent（阶段 5），agent 会处理角色的个人功能，比如购买装备、查看成就等。
当客户端发送开始比赛的协议时，程序会选择一个场景服务器，让它和 agent 关联，处理一场战斗（阶段 6）。

### 设计要点

- gateway

gateway 只做消息转发，解包，启用 gateway 服务是有好处的，隔离客户端与服务端系统，例如要更改客户端协议（如 json 改为 protobuf）
仅需要修改 gateway，不会对系统内部产生影响。

预留断线重连功能，如果客户端掉线，仅影响到 gateway，引入 gateway 意味着客户端消息需经过一层转发，会带来一定的延迟。将同一个客户端连接
的 gateway、login、agent 置于同一个节点有助于减少延迟。

- agent 与 scene 的关系

agent 可以和任意一个 scene 通信，但跨节点通信开销比较大，一个节点可以支撑数千名玩家，足以支撑各种段位的匹配，玩家应尽可能
进入同节点的战斗场景服务器（scene）。

- agentmgr

agentmgr 仅记录 agent 的状态、处理玩家登录，登出功能，所有对它的访问都以玩家 id 为索引，agentmgr 是一个单节点，但也很容易扩展为分布式。

### 分布式登录流程

处理玩家的登录，是服务端框架的主要功能之一，分布式系统涉及多个服务，让它们相互配置不产生重复是一大难点。

### 完整的登录流程

看一下下面的图大致就可以理解整体流程，这涉及到重复登录的场景

![登录架构流程](../.gitbook/assets/2023-10-23001534.png)

### 掉线登出流程

当客户端掉线时，登出流程如图所示

![掉线登出流程图](../.gitbook/assets/2023-10-23001706.png)

所有上线下线的请求都要经过 agentmgr，由它裁决，只有“已在线”状态的客户端方可被顶替下线，如果处于“登录中”或“登出中”，agentmgr 会告诉新登录的客户端“其他玩家正在尝试登录该账号，请稍后再试”。这样设计可以免去考虑很多复杂情况。

### 实现 gateway

请见如下部分

### 连接类和玩家类

gateway 需要使用两个列表，一个用于保存客户端连接信息，另一个用于记录已登录玩家信息，"让 gateway 把客户端和 agent 关联起来"，即是将 连接信息和玩家信息关联起来。

```lua
-- service/gateway/init.lua
conns = {} --[fd] = conn
players = {} --[playerid] = gateplayer
-- 连接类
function conn()
  local m = {
      fd = nil
      playerid = nil
  }
  return m
end
-- 玩家类
function gateplayer()
  local m = {
    playerid = nil,
    agent = nil,
    conn = nil
  }
end
```

在客户端进行连接后，程序会创建一个 conn 对象，gateway 会以 fd 为索引将其存进 conns 表中。conn 对象会保存连接的 fd
标识，但 playerid 属性为空，此时 gateway 可以通过 conn 对象找到连接标识 fd，给客户端发送消息。

![conns和players列表示意图](../.gitbook/assets/2023-10-24000212.png)

当玩家成功登陆时，会创建一个 gateplayer 对象，服务端才会创建角色对象(agent),gateway 会以玩家 id 为索引将其存入
player 表中。gateplayer 对象会保存 playerid(玩家 id)、agent（代理服务 id）、conn（对应的 conn 对象）。

登录后，gateway 可以做到双向查找

- 客户端发了消息，可以由底层 socketfd 找到 conn 对象，再由 playerid 属性找到 gateplayer 对象，进而可以知道代理服务 agent 在哪里
- 若 agent 发来消息，只要附带玩家 id，gateway 可以由 playerid 获取到 gateplayer 对象进而可以找到 conn，可以使用 fd 进行发送

### 接收客户端连接

首先需要开启 socket 的监听，当有客户端连接时，start 方法的回调函数 connect 被调用

```lua
--service/gateway/init.lua
local socket = require "skynet.socket"
local runconfig = require "runconfig"
function s.init()
  local node = skynet.getenv("node")
  local nodecfg = runconfig[node]
  local port = nodecfg.gateway[s.id].port
  local listenfd = socket.listen("0.0.0.0", port)
  skynet.error("Listen socket :", "0.0.0.0", port)
  socket.start(listenfd, connect)
end
--有新连接时的处理
local connect = function(fd, addr)
  print("connect from " .. addr .. " " .. fd)
  local c = conn()
  conns[fd] = c
  c.fd = fd
  skynet.fork(recv_loop, fd)
end
```

recv_loop 负责接收客户端消息

```lua
-- service/gateway/init.lua
--每一条连接接收数据处理
--协议格式cmd,arg1,arg2,...#
local recv_loop = function(fd)
  socket.start(fd)
  skynet.error("socket connected" ..fd)
  local readbuff = ""
  while true do
    local recvstr = socket.read(fd)
    if recvstr then
      readbuff = readbuff..recvstr
      readbuff = process_buff(fd, readbuff)
    else
      skynet.error("socket close" ..fd)
      disconnect(fd)
      socket.close(fd)
      return
    end
  end
end
```

通过拼接 Lua 字符串实现缓冲区是一种简单的做法，它可能带来 GC（垃圾回收）的负担。

![处理客户端连接的示意图](../.gitbook/assets/2023-10-24002047.png)

### 处理客户端协议

服务端接收到数据后就会调用 process_buff,并把缓冲区传给它，process_buf 会实现消息的切分工作.

```lua
--service/gateway/init.lua
local process_buff = function(fd, readbuff)
  while true do
    local msgstr, rest = string.match(readbuff, "(.-)\r\n(.*)")
    if msgstr then
      readbuff = rest
      process_msg(fd, msgstr)
    else
      return readbuff
    end
end
```

这就是个从 buffer 中解析协议的流程，并不难理解

### 编码和解码

可以封装自己的工具函数，进行协议的解包封包操作，此处不再详细展开

### 消息分发

先看下代码，要做的就是 消息解码、如果尚未登陆、如果已经登录、将消息发往 agent

![process_msg方法示意图](../.gitbook/assets/2023-10-24003137.png)

```lua
local process_msg = function(fd, msgstr)
    local cmd, msg = str_unpack(msgstr)
    skyn et.error("recv "..fd.." ["..cmd.."] {"..table.concat( msg, ",").."}")

    local conn = conns[fd]
    local playerid = conn.playerid
    --尚未完成登录流程
    if not playerid then
        local node = skynet.getenv("node")
        local nodecfg = runconfig[node]
        -- 随机一个login节点
        local loginid = math.random(1, #nodecfg.login)
        local login = "login"..loginid
        -- 发往目标login
        skynet.send(login, "lua", "client", fd, cmd, msg)
    --完成登录流程
    else
        local gplayer = players[playerid]
        local agent = gplayer.agent
        skynet.send(agent, "lua", "client", cmd, msg)
    end
end
```

### 发送消息接口

gateway 将消息传给 login 或 agent，login 或 agent 也需要给客户端回应。比例，在客户端发送登录协议，login 校验失败后，
要给客户端回应 账号或密码错误，则需要 login 发往 gateway 再由 gateway 发往 client。

![login给客户端发送消息的过程](../.gitbook/assets/2023-10-24003456.png)

```lua
-- 从source发来 发给fd 消息为msg
s.resp.send_by_fd = function(source, fd, msg)
    if not conns[fd] then
        return
    end

    local buff = str_pack(msg[1], msg)
    skynet.error("send "..fd.." ["..msg[1].."] {"..table.concat( msg, ",").."}")
    socket.write(fd, buff)
end

-- 根据playerid给client发送消息
s.resp.send = function(source, playerid, msg)
    local gplayer = players[playerid]
    if gplayer == nil then
        return
    end
    local c = gplayer.conn
    if c == nil then
        return
    end

    s.resp.send_by_fd(nil, c.fd, msg)
end
```

### 确认登录接口

在完成登录流程后，login 会通知 gateway，让它把客户端连接和新 agent 关联起来

```lua
s.resp.sure_agent = function(source, fd, playerid, agent)
    local conn = conns[fd]
    if not conn then --登录过程中已经下线
        skynet.call("agentmgr", "lua", "reqkick", playerid, "未完成登录即下线")
        return false
    end

    conn.playerid = playerid

    local gplayer = gateplayer()
    gplayer.playerid = playerid
    gplayer.agent = agent
    gplayer.conn = conn
    players[playerid] = gplayer

    return true
end
```

sure_agent 的功能是将 fd 和 playerid 关联起来，它会先查找连接对象 conn，再创建 gateplayer 对象 gplayer，并设置属性。

### 登出协议

玩家有两种登出情况，一种为客户端掉线或者自主线下，另一种是被顶替下线。如果客户端掉线 gateway 会向 agentmgr 发送下线请求，由 agentmgr 仲裁。

```lua
--service/gateway/init.lua
local disconnect = function(fd)
    local c = conns[fd]
    if not c then
        return
    end

    local playerid = c.playerid
    --还没完成登录
    if not playerid then
        return
    --已在游戏中
    else
        -- players[playerid] = nil -- 将玩家的gateplayer对象删除，其实里应当在agentmgr回包后删除
        local reason = "断线"
        skynet.call("agentmgr", "lua", "reqkick", playerid, reason)
    end
end
```

如果 agentmgr 仲裁通过，或者 agentmgr 想直接把玩家踢下线，在保存数据后，会通知 gateway 做收尾工作,删掉玩家的 conn 和 gateplayer 对象

```lua
s.resp.kick = function(source, playerid)
    local gplayer = players[playerid]
    if not gplayer then
        return
    end

    local c = gplayer.conn
    players[playerid] = nil

    if not c then
        return
    end
    conns[c.fd] = nil
    disconnect(c.fd)
    socket.close(c.fd)
end
```

gateway 大致就是这样，理论这样设计没啥问题，但是在生产环境中应用还需要很多深思，但是我们现在是用来，学习，很不错啦，你很棒的加油。

### 实现 login

登录服务，对于此服务可以看以前的登录流程。

### 登录协议

客户端肯定要发账号密码，服务端收到登录协议后会做出回应，gateway 挑一个 login 去验证，在 login 返回包给 gateway 时，gateway 应该提示客户端，如账号或密码错误，其他玩家正在尝试登录该账号请稍后再试。

### 登录流程处理

gateway 会将客户端协议以 client 消息的形式转发给 login 服务，login 服务会先校验客户端发来的用户名密码，再作为
gateway 和 agentmgr 的中介，等待 agentmgr 创建代理服务。

1. 校验用户名密码：这个过程可能是查询数据库或者向平台 SDK 进行验证
2. 给 agentmgr 发送 reqlogin，请求登录，reqlogin 会回应两个值一个值代表是否成功，一个值为 agent 代表已创建的代理服务 id
3. 给 gate 发送 sure_agent
4. 如果全部过程成功执行，login 服务会给客户端回应成功消息。

详细的还是看本章以前的 完整的登录流程 部分的图解吧。

```lua
--service/login/init.lua
s.client.login = function(fs, msg, source)
  local playerid = tonumber(msg[2])
  local pw = tonumber(msg[3])
  local gate = source
  node = skynet.getenv("node")
  --校验用户名密码
  if pw ~= 123 then
    return {"login", 1, "密码错误"}
  end
  --发给agentmgr
  local isok, agent = skynet.call("agentmgr", "lua", "reqlogin", playerid, node, gate)
  if not isok then
    return {"login", 1, "请求mgr失败"}
  end
  --回应gate
  local isok = skynet.call(gate, "lua", "sure_agent", fd, playerid, agent)
  if not isok then
    return {"login", 1, "gate注册失败"}
  end
  skynet.error("login succ"..playerid)
  return {"login", 0, "登录成功"}
end
```

代码当伪代码看就行了，主打一个业务学习作用

### 实现 agentmgr

agentmgr 是管理 agent 的服务，它是登录过程的仲裁服务，控制着登录过程。agentmgr 中含有一个列表 players，里面保存着所有玩家的在线状态。

### 玩家类

登录流程中，玩家会有 “登录中”、“游戏中”、“登出中”三种状态。

```lua
STATUS = {
  LOGIN = 2,
  GAME = 3,
  LOGOUT = 4
}
--玩家列表
local players={}
--玩家类
function mgrplayer()
  local m = {
    playerid = nil, -- 玩家id
    node = nil, -- 该玩家对应gateway和agent所在的节点
    agent = nil, -- 该玩家对agent服务的id
    status = nil, -- 状态
    gate = nil -- 该玩家对应gateway的id
  }
end
```

![mgrplayer对象的示意图](../.gitbook/assets/2023-10-27002821.png)

### 请求登录接口

login 服务会向 agentmgr 请求登录(reqlogin)

1. 登录仲裁，判断玩家是否已经登录
2. 顶替已在线玩家，如果该角色已在线，需要先把它踢下线
3. 记录在线信息，将新建的 mgrplayer 对象记录为登陆中状态
4. 让 nodemgr 创建 agent 服务
5. 登录完成，设置 mgrplayer 为游戏中状态，并返回 true 与 agent 服务的 id

![当前完成的登录流程标注图](../.gitbook/assets/2023-10-27003600.png)

```lua
s.resp.reqlogin = function(source, playerid, node, gate)
    local mplayer = players[playerid]
    --登录过程禁止顶替
    if mplayer and mplayer.status == STATUS.LOGOUT then
        skynet.error("reqlogin fail, at status LOGOUT " ..playerid )
        return false
    end
    if mplayer and mplayer.status == STATUS.LOGIN then
        skynet.error("reqlogin fail, at status LOGIN " ..playerid)
        return false
    end
    --在线，顶替
    if mplayer then
        local pnode = mplayer.node
        local pagent = mplayer.agent
        local pgate = mplayer.gate
        mplayer.status = STATUS.LOGOUT,
        s.call(pnode, pagent, "kick")
        s.send(pnode, pagent, "exit")
        s.send(pnode, pgate, "send", playerid, {"kick","顶替下线"})
        s.call(pnode, pgate, "kick", playerid)
    end
    --上线
    local player = mgrplayer()
    player.playerid = playerid
    player.node = node
    player.gate = gate
    player.agent = nil
    player.status = STATUS.LOGIN
    players[playerid] = player
    local agent = s.call(node, "nodemgr", "newservice", "agent", "agent", playerid)
    player.agent = agent
    player.status = STATUS.GAME
    return true, agent
end
```

### 请求登出接口

除了登录，agentmgr 还负责登出的仲裁。agentmgr 会先发送 kick 让 agent 处理保存数据的事情，再发送 exit 让 agent 退出服务，由于保存数据需要一小段时间，因此 mgrplayer 会保存一小段时间的 LOGOUT 状态。

```lua
-- service/agentmgr/init.lua
s.resp.reqkick = function(source, playerid, reason)
    local mplayer = players[playerid]
    if not mplayer then
        return false
    end

    if mplayer.status ~= STATUS.GAME then
        return false
    end

    local pnode = mplayer.node
    local pagent = mplayer.agent
    local pgate = mplayer.gate
    mplayer.status = STATUS.LOGOUT

    s.call(pnode, pagent, "kick") -- call同步
    s.send(pnode, pagent, "exit") -- send异步
    s.send(pnode, pgate, "kick", playerid) --异步调用
    players[playerid] = nil

    return true
end
```

### 实现 nodemgr

### 实现 agent 单机

### 测试登录流程

### 战斗流程

### 场景服务

### 实现 agent 跨服务器
