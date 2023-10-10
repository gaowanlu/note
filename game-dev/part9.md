---
cover: >-
  https://images.unsplash.com/photo-1650170496638-b05030a94005?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI1MzAzMzQ&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 🚗 服务器管理进程与 HTTP

## 服务器管理进程与 HTTP

如果有多个 login 进程，它是服务器的第一道屏障，玩家只有登录成功才可能进入游戏。当有多个 login 的时候就涉及一个问
题，客户端到底该从哪个 login 登录呢？

### 启用多个 Login 进程

只有一个 login 进程，容易形成瓶颈，所以需要为整个架构设置多个 login 进程。
对于客户端来说，登录游戏时应该使用哪一个 login 呢，解决这个问题有两种方案：一种方案是运维的角度来解决，利用 Nginx 的功能，另一种方案是通过游戏的逻辑数据来解决，做一个简单的登录策略，每个玩家登录时，可以通过某种方式得知玩家在线最少的 login 的 IP 和端口。

这样一来，登录问题进一步演变为如何得到最小负载的 login，为了解决此问题，建立一个新工程，用来维护所有的 login，将其称为 appmgr，除了当前
的 login 进程之外，appmgr 来会维护 game 进程。

### appmgr 进程

客户端需要从 appmgr 进程获取某个 login 信息，然后客户端对指定的 login 进行登录请求。

![appmgr登录数据](../.gitbook/assets/2023-10-11001138.png)

login 进程启动之后会定期向 appmgr 发送自己当前的状态，这样 appmgr 可以被动收集到
所有 login 数据，客户端登陆时，只需要向 appmgr 询问即可得到最小负载的 login 信息。

在 appmgr 进程中定义 LoginSyncComponent,用于收集所有 login 进程的同步信息。

```cpp
class LoginSyncComponent : public SyncComponent, public IAwakeSystem<>{
public:
  void Awake() override;
  void BackToPool() override;
};
class SyncComponent : public Entity<SyncComponent>{
public:
  void AppInfoSyncHandle(Packet* pPacket);
  bool GetOneApp(APP_TYPE appType, AppInfo& info);
  //...
protected:
  std::map<int, AppInfo> _apps;
};
```

基类组件 SyncComponent 将收集到的数据保存在字典 std：：map<int，AppInfo>中，Key 值为
AppId，Value 值为结构 AppInfo.

```cpp
struct AppInfo{
  APP_TYPE AppType;
  int AppId;
  std::string Ip;
  int Port;
  int Online;//用于记录AppId对应进程有多少玩家在线
  SOCKET Socket;
};
```

`LoginSyncComponent::Awake`初始化函数中注册了 login 同步消息 MI_AppInfoSync 的
处理函数，对于 LoginSyncComponent 组件来说，它并不关心谁发送了数据，
只关心 MI_AppInfoSync 协议本身的内容，谁发来的并不重要。

```cpp
void SyncComponent::AppInfoSyncHandle(Packet* pPacket){
  auto proto = pPacket->ParseToProto<Proto::AppInfoSync>();
  const auto iter = _apps.find(proto.app_id());
  if(iter == _apps.end()){
    AppInfo syncAppInfo;
    syncAppInfo.Socket = pPacket->GetSocket();
    _apps[syncAppInfo.AppId] = syncAppInfo;
  }else{
    const int appId = proto.app_id();
    _apps[appId].Online = proto.online();
    _apps[appId].Socket = pPacket->GetSocket();
  }
}
```

对于 Login 进程，MI_AppInfoSync 协议需要发送至 appmgr，在 Login 的 Account 组件增加定时器，
每隔几秒就将自己的信息发送出去。

```cpp
void Account::Awake(){
  AddTimer(0, 10, true, 2, BindFunP0(this, &Account::SyncAppInfoToAppMgr));
  //...
}
void Account::SyncAppInfoToAppMgr(){
  Proto::AppInfoSync protoSync;
  protoSync.set_app_id(Global::GetInstance()->GetCurAppId());
  protoSync.set_app_type((int)Global::GetInstance()->GetCurAppType());
  protoSync.set_online(_playerMgr.Count());
  MessageSystenHelp::SendPacket(Proto::MsgId::MI_AppInfoSync, protoSync, APP_APPMGR);
}
```

完成了数据的收集工作，接下来要解决的问题是：客户端通过什么方式从 appmgr 中知道 login 的这些状态呢？鉴于客户端与 appmgr 进程只有一次性的通信，这里我们采用 HTTP 弱连接方式。具体方法是，appmgr 进程提供一个 HTTP 端口——例如 appmgr 的 IP 为 `192.168.0.100`，开放一个 HTTP 服务——端口为 8081，提供一个 `192.168.0.100：8081/login` 请求，该请求返回一个 JSON 数据，类似`{"ip"："192.168.0.100"，"port"：5002}`，让调用者知道当前在 `192.168.0.100` 的 5002 端口上有一个可以进行连接的 login 进程。

则现在需要在框架中加入 HTTP 的处理，提供 HTTP 服务。

### HTTP

### Mongoose 分析 HTTP

### 为 Packet 定义新的网络标识

### HTTP 分块
