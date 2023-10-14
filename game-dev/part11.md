---
cover: >-
  https://images.unsplash.com/photo-1650170496638-b05030a94005?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI1MzAzMzQ&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 🚗 分布式跳转方案

## 分布式跳转方案

此部分主要学习玩家在 game 进程上跳转地图的流程,Player 组件如何读取数据,game 进程如何与 space 进程通信,还有游戏逻辑配置文件读取,
进入地图流程.

### 资源数据配置与读取

到此还没有搭建,逻辑配置资源的功能设计,可以采用 CSV 文件格式,而且 execel 可以转 csv.
游戏策划几乎每天大多数时间在与表格打交道.

首先需要一个总的管理类,管理所有游戏逻辑的配置文件,命名为 ResourceManager,在这个类下可能存在 ResourceWorldMgr 和 ResourceItemMgr,分别管理地图和道具的相关配置.

![游戏逻辑配置表管理类](../.gitbook/assets/2023-10-15003657.png)

### 资源管理类 ResourceManager

加入需要读取某个资源配置文件,需要设计简单的调用方式风格

```cpp
GetResMgr()->WorldMgr->GetWorld(id);
GetResMgr()->ItemMgr->GetItem(id);
```

先取得一个总的入口，从入口取得需要的地图或道具的管理器，再从管理器中取得
想要的一行数据。

```cpp
class ResourceManager:public Entity<ResourceManager>, public IAwakeSystem<>{
public:
  void Awake() override;
  void BackToPool() override;
public:
  ResourceWorldMgr* Worlds;
}
```

ResourceManager 只在主线程中的 EntitySystem 就好了,虽然设计到多线程的访问,但是初始化完成后,数据只读不写,对于只读的数据,在任何线程中都是安全的.

```cpp
void ResourceManager::Awake(){
  const auto pResPath = ComponentHelp::GetResPath();
  Worlds = new ResourceWorldMgr();
  if(!Worlds->Initialize("world.csv", pResPath)){
    LOG_ERROR("...");
  }
  //LOG...
}
```

努力学习中....
