---
cover: >-
  https://images.unsplash.com/photo-1650170496638-b05030a94005?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI1MzAzMzQ&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 🚗 断线与动态加载系统

## 断线与动态加载系统

本部分主要讨论一个异常处理，网络断线和重连。断线又包括，玩家的断线，服务端进程之间的断线。

### 玩家断线

玩家断线是一种正常的网络断线，在整个游戏框架中，玩家数据会保存在 3 个进程和
4 个实体中。3 个进程分别为 login 进程、game 进程、space 进程。当玩家断线时，
要充分考虑到 3 个进程中的数据，相关数据都需要处理。

4 种实体分别为：

1. 在 login 进程中，实体对象为 Account 类，改类用于玩家账号验证
2. 在 game 进程中，有两个与玩家有关的实体类，Lobby 类，改类是玩家进入 game 进程的第一个实体类。WorldProxy 类，改类是地图类的代理类。
3. 在 space 进程中，玩家存在于一个特定的 World 类中，改类是真正的地图类。

对于以上的 4 种实体类，都需要处理玩家断线的问题，当一个网络连接中断时，网络底层
会发送 MI_NetworkDisconnect 协议给各个线程。需要在这 4 个实体类种，处理好 MI_NetworkDisconnect 的后续操作。

### 玩家在 login 进程中断线

当玩家还没有进入 game 进程之前，客户端是与 login 进行通信的，其主要数据位于 Account 类中,下面为 Account 类对于断线协议做出的反应

```cpp
void Account::HandleNetworkDisconnect(Packet* pPacket){
  const auto socketKey = pPacket->GetSocketKey();
  if(socketKey->NetType != NetworkType::TcpListen)
    return;
  auto pPlayerCollector = GetComponent<PlayerCollectorComponent>();
  pPlayerCollector->RemovePlayerBySocket(pPacket->GetSocketKey()->Socket);
}
```

收到断线协议后，Account 类会将玩家的数据进行销毁，附加在 Player 实体上的组件会将玩家在 Redis 中的数据也销毁。
在 Login 进程中，除了有 TCP 连接外，还有向外发出的 HTTP 连接，HTTP 连接用于玩家向第三方 Web 服务器请求账号验证时使用，在断线处理时，需要判断当前断线 Socket 类型，只有是外部连接到套接字的连接才进行处理。

### 玩家在 game 进程中断线

当玩家进入 game 进程时，可能存在于两个实体中：一个是 Lobby、一个是 WorldProxy,在这两个类中，都需要要做断线处理。
Lobby 时验证玩家登陆时提交的 Token 的，WorldProxy 则是某个 space 进程中的 world 代理类。

```cpp
void Lobby::HandleNetworkDisconnect(Packet* pPacket){
  auto pTagValue = pPacket->GetTagKey()->GetTagValue(TagType::Account);
  if(pTagValue == nullptr)
    return;
  GetComponent<PlayerCollectorComponent>()->RemovePlayerBySocket(pPacket->GetSocketKey()->Socket);
}
```

在 Lobby 类中，只需要以除玩家数据即可，在 WorldProxy 类中需要处理的步骤及较多。

```cpp
void WorldProxy::HandleNetworkDisconnect(Packet* pPacket){
  TagValue* pTagValue = pPacket->GetTagKey()->GetTagValue(TagType::Account);
  if(pTagValue!=nullptr){
    const auto pPlayer = GetComponent<PlayerCollectorComponent>()->GetPlayerBySocket(pPacket->GetSocketKey()->Socket);
    if(pPlayer==nullptr){
      return;
    }
    auto pCollector = GetComponent<PlayerCollectorComponent>();
    pCollector->RemovePlayerBySocket(pPacket->GetSocketKey()->Socket);
    SendPacketToWorld(Proto::MsgId::MI_NetworkDisconnect, pPlayer);
  }
  //...
}
```

当一个玩家的网络中断后，WorldProxy 代理地图类将玩家数据移除，同时需要向 space 进程中的 World 发送一个断线消息，
告诉 World 类有一个玩家断线了。

### 玩家断线时 World 类的处理

下面为 space 进程收到断线消息所进行的大致处理

```cpp
void World::HandleNetworkDisconnect(Packet* pPacket){
  auto pTags = pPacket->GetTagKey();
  const auto pTagPlayer = pTags->GetTagValue(TagType::Player);
  if(pTagPlayer != nullptr){
    auto pPlayerMgr = GetComponent<PlayerManagerComponent>();
    const auto pPlayer = pPlayerMgr->GetPlayerBySn(pTagPlayer->KeyInt64);
    if(pPlayer==nullptr){
      //LOG_ERR();
      return;
    }
    Proto::SavePlayer protoSave;
    protoSave.set_player_sn(pPlayer->GetPlayerSN());
    pPlayer->SerializeToProto(protoSave.mutable_player());
    MessageSystemHelp::SendPacket(Proto::MsgId::G2DB_SavePlayer, protoSave, APP_DB_MGR);
    //玩家掉线
    pPlayerMgr->RemovePlayerBySn(pTagPlayer->KeyInt64);
  }
}
```

当 world 收到玩家断线的消息后，第一件事就是将内存中玩家的数据移除，将其从 PlayerManagerComponent 管理类中移除，第二件事是在移除之前，将玩家的数据发送到 dbmgr 进程中进行数据存储，发送的协议号为 G2DB_SavePlayer.

### 玩家数据的读取与保存

当玩家下线时，需要从 World 对象中移除玩家，并对当前数据进行存储，存储玩家数据时使用协议发送给 dbmgr

```cpp
message Player{
  uint64 sn = 1;
  string name = 2;
  PlayerBase base = 3;
  PlayerMisc misc = 4;
}
```

结构 PlayerBase 中包括一些基础数据，结构 PlayerMisc 中包括一些杂项数据，如果要增加道具数据，那么可以再增加一个
PlayerItems 结构，当玩家登录 game 进城后，再 Lobby 类中会生辰一个 Player 实例，game 进程会读取出玩家选中的叫色，并
从 DB 中读取 Proto::Player 传递到 Player 实体中。

```cpp
void Player::ParserFromProto(const uint64 playerSn, const Proto::Player& proto){
  _playerSn = playerSn;
  _player.CopyFrom(proto);
  _name = _player.name();
  //在内存中修改数据,Player实体上挂在了许多Component，当从DB读到玩家数据时
  //也需要让组件知道
  for(auto pair : _components){
    auto pPlayerComponent = dynamic_cast<PlayerComponent*>(pair.second);
    if(pPlayerComponent == nullptr){
      continue;
    }
    pPlayerComponent->ParseFromProto(proto);
  }
}
```

对于附加在 Player 实体上的组件，如果有存储或读取数据库的需要，都是基于 PlayerComponent 接口的，要实现两个虚函数。

```cpp
class PlayerComponent{
public:
  virtual void ParserFromProto(const Proto::Player& proto) = 0;
  virtual void SerializeToProto(Proto::Player* pProto) = 0;
};
```

Player 类解析了 Proto::Player 的结构，并将它传递到自己身上所有组件上，让组件选择自己需要的数据来填充内存数据，如 PlayerComponentLastMap，用于分析最后一次登录地图的数据

```cpp
void PlayerComponentLastMap::ParserFromProto(const Proto::Player& proto){
  //公共地图
  auto protoMap = proto.misc().last_world();
  int worldId = protoMap.world_id();
  auto pResMgr = ResourceHelp::GetResourceManager();
  auto pMap = pResMgr->Worlds->GetResource(worldId);
  if(pMap!=nullptr){
    _pPublic = new LastWorld(protoMap);
  }else{
    pMap = pResMgr->Worlds->GetInitMap();//默认地图
    _pPublic = new LastWorld(pMap->GetId(),0,pMap->GetInitPosition);
  }
  //...
}
```

当 Proto::Player 数据传递到 PlayerComponentLastMap 组件时，从 PlayerMisc 数据挑选自己感兴趣的读到属性中去。
又例如 space 进程中的 PlayerComponentDetail 组件，这个组件存储着玩家的基础数据，如 level、gender 常用数据。

```cpp
void PlayerComponentDetail::ParseFromProto(const Proto::Player& proto){
  auto protoBase = proto.base();
  _gender = protoBase.gender();
  //...
}
```

每个组件指对自己感兴趣的数据进行处理。现在还存在另一种情况，如果 Proto::Player 结构已经解析过了，这时动态为 Player 加入了
新组件，初始化工作由 Awake 组件来完成。

```cpp
void PlayerComponentLastMap::Awake(){
  Player* pPlayer = dynamic_cast<Player*>(_parent);
  ParserFromProto(pPlayer->GetPlayerProto());
}
```

除了读取之外，还需要关注玩家身上的组件是如何进行数据存储的，当玩家断线时，调用下面的代码实现保存

```cpp
Proto::SavePlayer protoSave;
protoSave.set_player_sn(pPlayer->GetPlayerSN());
pPlayer->SerializeToProto(protoSave.mutable_player());
MessageSystemHelp::SendPacket(Proto::MsgId::G2DB_SavePlayer, protoSave, APP_DB_MGR);
```

关键点在于 Player 的 SerializeToProto

```cpp
void Player::SerializeToProto(Proto::Player* pProto) const{
  //基础数据
  pProto->CopyFrom(_player);
  //在内存中修改数据
  for(auto pair:_components){
    auto pPlayerComponent = dynamic_cast<PLayerComponent*>(pair.second);
    if(pPlayerComponent==nullptr){
      continue;
    }
    pPlayerComponent->SerializeToProto(pProto);
  }
}
```

当需要保存数据时，也是遍历玩家的所有组件，让组件把自己的数据传递到给定的参数 Proto::Player 中。

```cpp
void PlayerComponentLastMap::SerializeToProto(Proto::Player* pProto){
  //公共地图
  if(_pPublic!=nullptr){
    const auto pLastMap = pProto->mutable_misc()->mutable_last_world();
    _pPublic->SerializeToProto(pLastMap);
  }
  //副本
  if(_pDungeon!=nullptr){
    const auto pLastDungeon = pProto->mutable_misc()->mutable_last_dungeon();
    _pDungeon->SerializeToProto(pLastDungeon);
  }
}
```

PlayerComponentLastMap 组件保存上一次登录的地图信息，将自己的内存数据(最近的登录地图数据)写入给定的
Proto::Player 中，这样角色下次上线时取到的数据就是下线时最后的数据.

在 Player 组件的 SerializeToProto 函数中,将内存的数据重新写回到 Proto::Player 中,再将它传递到 dbmgr 实现存储,
除了实现持久化存储,还应该处理 Redis 的缓存数据如在线标识应该删除.

### 如何进入断线之前的地图

在一个玩家进入 game 进程时,第一个到达的地方是 Lobby 类中,是一个中转站.Lobby 类从 Redis 读 token 校验,从数据库中读取出玩家数据,其处理函数为`Lobby::HandleQueryPlayerRs`,本函数应从玩家数据中取出最近登录的副本地图(例如王者荣耀的枚举匹配比赛,其实本质就是副本,如果断线后重新上线理应让玩家选择进入未结束的副本),以保证玩家优先进入之前被中断的副本,如果副本不在本地就向 appmgr 进行查询,查询时将玩家放在等待队列.

```cpp
void Lobby::HandleQueryPlayerRs(Packet *pPacket)
{
    auto protoRs = pPacket->ParseToProto<Proto::QueryPlayerRs>();
    auto account = protoRs.account();
    auto pPlayer = GetComponent<PlayerCollectorComponent>()->GetPlayerByAccount(account);
    //...
    // 分析进入地图
    auto protoPlayer = protoRs.player();
    const auto playerSn = protoPlayer.sn();
    pPlayer->ParserFromProto(playerSn, protoPlayer);
    auto pWorldLocator = ComponentHelp::GetGlobalEntitySystem()->GetComponent<WorldProxyLocator>();
    // 进入副本
    auto pLastMap = pPlayerLastMap->GetLastDungeon();
    if (pLastMap != nullptr)
    {
        // 现在game进程找
        if (pWorldLocator->IsExistDungeon(pLastMap->WorldSn))
        {
            // 存在副本,则跳转
            WorldProxyHelp::Teleport(pPlayer, GetSN(), pLastMap->WorldSn);
            return;
        }
        // 为副本加上等待列表
        if (_waitingForDungeon.find(pLastMap->WorldSn) == _waitingForDungeon.end())
        {
            _waitingForDungeon[pLastMap->WorldSn] = std::set<uint64>();
        }
        if (_waitingForDungeon[pLastMap->WorldSn].empty())
        {
            // 向appmgr查询副本
            Proto::QueryWorld protoToMgr;
            protoToMgr.set_world_sn(pLastMap->WorldSn);
            protoToMgr.set_last_world_sn(GetSN());
            MessageSystemHelp::SendPacket(Proto::MsgId::G2M_QueryWorld, protoToMgr, APP_APPMGR);
        }
        // 将用户加入到副本请求等待列表
        _waitingForDungeon[pLastMap->WorldSn].insert(pPlayer->GetPlayerSN());
        return;
    }
    // 进入公共地图
    EnterPublicWorld(pPlayer);
}
```

game 向 appmgr 进程进行副本查询后,如果副本在 space 进程中存在,就会在本地创建一个 WorldProxy 代理地图,进行跳转.
多进程启动时,存在多个 game 进程,有可能玩家第二次登录的 game 进程不是之前的 game 进程,也就不存在 WorldProxy.
虽然不存在,但是可以创建一个代理类.

### WorldProxy 何时被销毁的

理论上来说,当 World 在某种条件下被销毁了,应该广播一条销毁协议,这个销毁协议会发送到所有 game 进程和 appmgr 进程,以请求这个 World 当前对应的 WorldProxy 数据,appmgr 的数据被清除之后,玩家登录时向 appmgr 请求副本地图时会返回失败,这时就会选择最近的公共地图进入.

### 进程之间的断线

对于服务器而言,除了玩家断线之外,服务器进程之间的断线更为复杂,进程之间的通信不一定非得用 TCP,有必要时 UDP,分布式消息队列.
可能会有更好的选择方案,不能说那一个更好,需要结合业务场景选择何使的方案.

### login 进程断线与重连

### game 进程断线与重连

### space 进程断线与重连

### appmgr 进程断线与重连

### 动态新增系统

### MoveComponent 组件

### 新系统 MoveSystem

### 加载新系统

### 测试移动
