---
cover: >-
  https://images.unsplash.com/photo-1650170496638-b05030a94005?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI1MzAzMzQ&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 防外挂

## 防外挂

外挂就像是游戏的毒瘤，它利用游戏漏洞破坏平衡，会造成游戏公司和普通玩家的损失。外挂就像是游戏的毒瘤，它利用游戏漏洞破坏平衡，会造成游戏公司和普通玩家的损失。
防外挂是一项长期工作，开发人员需要持续与外挂分子斗智斗勇。

### 不信任客户端

服务端防外挂的关键点：不能相信客户端，可以看一下因为信任客户端而遭外挂侵扰的案例。

### 刷金币案例

玩家通过选择商品输入数量来购买道具，客户端对“购买数量”的输入范围做了限制，只能填入 1 到 99 的数值。
玩家单击“购买”按钮时，客户端会发送请求，服务端先计算总价格，如果玩家拥有足够多的金币，则购买成功。

```lua
function onBug(player, itemID, num)
  --获取物品配置，取得该物品的价格
  local itemConfig = getItemConfig(itemID)
  --计算总共要花费多少钱
  local needCoin = itemConfig.price * num
  --判断玩家的钱是否足够
  if player.coin < needCoin then
    send(player, "金币不足")
    return
  end
  --扣钱，加物品
  player.coin = player.coin - needCoin
  player.addItem(itemID, num)
  send(player, "购买成功")
end
```

虽然客户端做了输入限制，测试员不能输入"-1","-2"之类的非法数值，商城通过了黑盒测试。
然而外挂开发着破解了协议格式，使用外挂工具直接发送协议，使得 needCoin 变为了负值，进而使得玩家的金币
数量的到增加。

修复后

```lua
function onBug(player, itemID, num)
  local itemConfig = getItemConfig(itemID)
  if not itemConfig then
    send(player, "物品不存在")
  end
  if num <= 0 ot num > 99 then
    send(player, "购买数量非法")
    return
  end
  --......
end
```

### 连发技能案例

一款动作类游戏，玩家可以使用技能攻击敌人。攻击协议 attack 中，skillID 代表技能编号;
伤害协议 damage 中，id 代表被攻击者的编号，hp 代表被攻击者剩余的血量。当玩家按下技能按钮后，
客户端发送 attack 协议`{_cmd="attack", skillID= 1001}`到服务端，服务端计算攻击范围和伤害，
再广播形如`{_cmd="damage", id=101, hp=30}`的协议。

```lua
--服务端处理技能协议的方法
function onAttack(player, skillid)
  --获取被攻击对象
  local enemy = getTarget(player, skillid)
  if not enemy then
    return
  end
  --如果敌人已经死亡，则忽略
  if enemy.hp <= 0 then
    return
  end
  --计算伤害值
  local damge = calDamge(player, enemy, skillid)
  -- 扣血
  enemy.hp = enemy.hp - damge
  if enemy.hp < 0 then --死亡
    enemy.hp = 0
  end
  -- 广播
  local msg = {
    _cmd = "damage",
    id = enemy.id,
    hp = enemy.hp
  }
  broadcast(msg)
end
```

虽然进行了一些条件判断，但是缺乏对技能冷却时间的判定，如果玩家作弊，让客户端以很高的频率发送技能协议，则玩家能打出极高的伤害值。
不信任客户端仅仅是不信任客户端发来的数据，还不能信任客户端发包的时机。

```lua
function onAttack(player, skillid)
  --冷却时间判定
  local cd = getCDTime(skillid) -- 获取技能冷却时间
  --是否还在冷却中
  if Time.now() < player.last_skill_time + cd then
    return
  end
  --last_skill_time 代表上次适用技能的时间
  player.last_skill_time = Time.now()
  --其他判定和处理
  --...
end
```

### 透视外挂案例

服务端向客户端发送的信息越多，外挂有机可乘的可能性就越大，外挂玩家可以看到对手的手牌，公平无从谈起。

如果有漏洞，如服务端向客户端广播所有手牌的信息，协议被破解，外挂玩家就可以看到对手的牌了。

```lua
--开始新的一局
function desk:Start()
  --deal方法表示发牌，将牌随机填入self.players[X].cards中
  --其中cards是一个数组，用于存放玩家的手牌
  self:deal()
  --发牌协议
  local msg = {
    _cmd = "deal"
    players = {
      [1] = self.players[1].cards, --地主
      [2] = self.players[2].cards, --农民1
      [3] = self.players[3].cards, --农民2
    }
  }
  self:brocast{msg} --广播给同一卓的玩家
end
```

改进写法，服务端只告诉玩家他自己的手牌，便能杜绝透视外挂

```lua
function desk:Start()
  self:deal()
  local msg1 = {
    _cmd = "deal",
    cards = self.players[1].cards,
  }
  self.players[1]:send(msg1)
  --农民1
  local msg2 = {
    _cmd = "deal"
    cards = self.players[2].cards
  }
  self.players[2]:send(msg2)
  --农民2
  local msg3 = {
    _cmd = "deal",
    cards = self.players[3].cards
  }
  self.players[3]:send(msg3)
end
```

相比棋牌游戏，射击类游戏很难杜绝透视外挂，因为服务端很难精准知道玩家的视野范围，只能向客户端多发送些冗余信息，
包括站在玩家背后的敌人，被障碍物挡住的敌人，这些都让外挂有机可乘，服务端应最大限度控制信息量。
总而言之，服务端不仅不能相信客户端的任何输入，而且不能向客户端发送过多冗余信息。

### 小游戏防刷榜

客户端不可信任，防外挂的根本办法是将游戏的所有逻辑全部放到服务端计算，然而实际项目往往有诸多限制，如 射击、运动类游戏对操作的灵敏
度要求很高，不能容忍太高的网络延迟，服务端的负载能力有限，难以计算全部逻辑，项目工期紧，加上服务端开发难度大，项目组不得已将逻辑
运算放到客户端。

如果必须依赖客户端的计算能力，那么服务端也要尽可能多的校验。

例如跑酷这种游戏，通常更青睐客户端运算的方案，客户端负责所有逻辑运算，具体来说就是：游戏开始时，服务端向客户端发送
“start”协议，客户端载入游戏场景，当角色碰触金币时，客户端发送"eat_coin"协议，服务端收到后为玩家添加 1 个金币，当角色
死亡时，客户端发送"game_over"协议。

```lua
--开始游戏
{_cmd="start"}
--吃金币
{_cmd="eat_coin"}
--结束游戏
{_cmd="game_over"}
```

加强防范的方案，由服务端产生一局游戏中的所有金币信息，包括它的位置坐标，以及是否已经被角色吃掉。
每个金币都会有包含一个随机值(key),用于提高作弊难度。

```lua
--跑酷游戏服务端状态
--战场信息
battle={
  --所有金币位置
  coins = {
    [1] = {x=50,y=20,key=1482,eat=false},
    [2] = {x=50,y=21,key=6542,eat=false},
    [3] = {x=51,y=20,key=1324,eat=false}
  }
  --角色
  role = {x=50,y=1,last_sync_time=1596022850}
}
```

在游戏开始时，服务端将前两屏的金币信息发送给客户端，待角色走动一段距离之后，再发送后面的金币信息。

```lua
--跑酷游戏
function battle:onEatCoin(player, msg)
  --判断金币是否存在
  coin = self.coins[msg.coin_id]
  if not coin then
    return
  end
  --判断金币是否已经被吃掉
  if coin.eat then
    return
  end
  --判断key对不对
  if msg.key ~= coin.key then
    return
  end
  --判断角色坐标是否合理
  local delta = os.time() - self.role.last_sync_time
  local last_x = self.role.x
  if msg.role_x > last_x + MAXSPEED * delta then
    return
  end
  --判断玩家坐标是否存在金币附近
  --...
  --金币顺序必然是从左到右，不可能吃到左边的金币
  --...
  player.coin = player.coin + 1
end
```

服务端所做的这些校验尽管不能从根源上杜绝作弊行为，却也提高了玩家作弊的难度。而且就算真有作弊行为，玩家也无法获得超额的奖励，或者用极短的时间通关。

### 篮球游戏案例

例如一款街头篮球游戏，开发团队考虑到篮球游戏会涉及较多的物理碰撞和复杂的 AI 规则，客户端引擎对此提供了较好的支持，
同时由于项目的开发期很紧，因此团队决定采用客户端运算的方案。

服务端会选择一场篮球赛中的某个客户端作为主机，让它承担逻辑运算。

```lua
--篮球游戏协议
--移动
{_cmd="move",dirX=1,dirY=0}
--投篮
{_cmd="shoot"}
--抢断
{_cmd="steal"}
--进球
{_cmd="goal"}
```

```bash
                 1{_cmd="steal"}          2
客户端B(非主机) ---->            服务器   ------> 客户端A(主机)
                <---                     <------
               4 抢断成功                 3 抢断成功
```

在这种架构下，如果主机被破解，那么主机玩家很容易就能作弊

为了加大作弊难度，服务端会同步球的位置、状态(球员持球，传球中，投篮中...),球员的位置、朝向等信息，
并对主机同步的数据做校验，如主机发送进球的协议，服务端会判断球是否处于“投篮中”的状态，球的位置坐标是否
在球篮附近，是否有球员在稍早的时间做出投篮动作，投篮球员的位置是否合理，投篮球员在上次得分后是否走出三分线，等等。

```lua
--篮球游戏的战场信息
battle = {
  --比赛
  score1 = 0, -- 红方得分
  score2 = 0, -- 蓝方得分
  --球
  ball = {
    last_pos = {120,10,0},--坐标
    who = 101, -- 谁持有球
    status = HOLD, -- 状态：持球、传球、投篮
    last_change_time = ...,--上次改变状态的时间
  },
  players = {
    [1] = {
      id = 101,
      team = 1,--所在队伍
      last_pos = {100,50,0},--坐标
      last_yaw = 180,--朝向
      --...
    },
    [2] = ...
  }
}
```

服务端的校验尽管不能从原理上杜绝作弊现象，却也能杜绝大部分低水平外挂。

### 部署校验服务

有些游戏偏向于单机玩法，对实时性的要求也不高，本可以采用服务端运算的方案，但由于项目前期的需求不太固定，
需要快速验证玩法，因此项目组往往也会选择客户端运算的模式，以争取提高开发效率，如三消类游戏就以客户端运算为主，
只在游戏结束时向服务端同步游戏的得分，因此很容易被外挂利用。

游戏火爆起来后，外挂也随之而来，但项目已经上线，此时再来重构代码，风险太大。项目组采用的补救措施是在服务端部署校验服务，服务端的架构。

校验服务实现了一套与客户端完全一样的算法，只要把玩家的每一步操作都告诉校验服务，它就能通过模拟算出游戏得分。

游戏结束时，客户端除了向游戏服务端发送游戏得分，还会附带玩家在该局游戏里的每一步操作，游戏服务端会把玩家的操作发给校验服务做校验，如果算出的得分与客户端发来的分数不同，就说明存在作弊行为。

我毕业到的一家游戏公司 我所在组内做的 行侠仗义“某”千年 ,就是用的这种架构。

```lua
client ----> 游戏服务 -----> 校验服务1
                |
                |------->    校验服务2
```

校验服务往往耗时较长，资源消耗大，往往会采用可横向扩展模式建立校验服务集群。
游戏服务将内容发给校验服务后并不会阻塞玩家，而是直接给玩家发送奖励与得分等。
当校验完毕后，校验服务会将结果发送至游戏服务，如果校验不通过，可以进行封号等等。

### 反外挂常用措施

如果开发外挂的难度足够大、成本足够高，远超过外挂的收益，就可以有效防止外挂。

### 防变速器

变速器是最常见的外挂之一，它可以改变客户端的运行速度，从而获取速度上优势。
例如，某款状态同步的游戏所使用的移动协议，由客户端运算并发送角色位置，服务端只做转发。

```lua
--移动
{_cmd="moveto",x=150,y=200}
```

客户端角色移动功能(Unity,C#)

```csharp
//每0.02秒执行一次(每秒50次)
void FixedUpdate()
{
  //如果按下键盘的向上按键
  if(Input.GetKey(KeyCode.Up))
  {
    //移动距离 = 正面方向 * 速度 * 时间
    Vector3 = transform.forward * speed * 0.02f;
    //新位置
    transform.transform.position += s;
  }
  // 此处省略向下 向左 向右 键的实现
  //每隔0.2秒发送一次位置协议
  if(Time.time - lastSyncTime > 0.2f)
  {
    SendMoveTo(); // 发送moveto协议
    lastSyncTime = Time.time;
  }
}
```

加速器会改变客户端的全局时间，这一点不难防范。在代码的例子中，正常的客户端每隔 0.2 秒发送一次同步协议，而使用加速器的客户端必然更快。服务端可以统计一段时间内移动协议的平均间隔时间，如果远小于预定的 0.2 秒，即可判断为加速器作弊。

```lua
--服务端移动协议处理方法，添加防加速功能
--处理移动协议
-- player.count 代表计数
-- player.last_time 代表上一次接收moveto协议的时间
-- player.sum 代表累计时间
-- Time.time()获取服务端启动到现在的时间
function onMoveTo(player, msg)
  --累计
  player.count = player.count + 1
  local delta = Time.time() - player.last_time
  player.sum = player.sum + delta
  player.last_time = Time.time()
  --如果累计了100次，就做一次判断
  if player.count > 100 then
    --计算平均间隔时间
    local avg = player.sum / player.count
    if avg < 0.2 * 0.7 then -- 平均值小于0.14算作弊
      cheat() --判定为作弊
      return
    end
    --重新计数
    player.count = 0
    player.sum = 0
  end
  --...处理移动逻辑
```

另外，在大部分服务端的设计中，客户端要定时向服务端发送心跳包，以便服务端检测客户端是否掉线，利用心跳包
来判断玩家是否作弊是一种常见的做法，由于加速器改变的是全局时间，因此其也会改变心跳包的发送频率，从而露出马脚。

### 防封包工具

外挂通常会利用 WPE(WinSock Packet Editor,网络数据包编辑器)等封包工具，这类工具可以截取和修改网络数据包，进而向
服务端发送任意数据，例如，玩家可以在开启游戏后用 WPE 截取“吃金币”的协议，然后重复发送，如果服务端没有做防护措施，
就有可能被外挂玩家刷金币。

有针对性修改协议内容，一种“防录制”的方法就是为协议添加一个校验码。

```lua
--吃金币
{_cmd="eta_coin",_code = 152}
```

服务端要求客户端按照特定格式计算校验码，如校验码规则为`msg_count*(start_rand+3)+79`,当客户端登陆时，
服务端会生成一个随机数 start_rand,然后发送给客户端，并要求客户端记录发送协议的次数，虽然校验码的规则很简单，
但该方法足以防止大部分封包外挂。

```lua
--服务端协议处理
function onMsg(player,msg)
  --客户端登录时，服务端为其分配一个随机数，随登录协议返回
  local start_rand = player.start_rand -- [0,99]
  --登陆后，一共收到多少条协议
  local msg_count = player.msg_count
  --判断密码
  if msg._code ~= msg_count*(start_rand+3)+79 then
    --作弊
  end
  player.msg_count = player.msg_count + 1
  --分发
  if msg._cmd == "eat_coin" then
    onEatCoin(player, msg)
  --...
end
```

### 帧同步投票

外挂的根源是游戏对客户端算力的依赖。帧同步是一种依赖客户端运算的技术，很容易作弊。服务端可以通过投票机制找出作弊的玩家。

服务端可以要求每个客户端每隔一定的帧数就发送一次状态协议，协议中包含客户端当前的帧数及状态码。
如果没有作弊，那么在同一帧时，各客户端应处于同样的状态，状态码也应相同。
服务端需要收集所有客户端的状态码，如果某个客户端的状态码不一样，
则该客户端的玩家很有可能是在作弊（也有可能是游戏本身的 Bug 造成的）。

```lua
--状态协议
{_cmd = "check", frameid = 10, status_code = 14566455}
```

状态码是反应客户端当前状态的数值，角色的生命值，体力值，位置，攻击力，金币数，道具数等都是游戏的某一项状态值。
组合这些状态值便能反应游戏的整体状态。

```csharp
//C# 状态码
void GetStatusCode(){
  int code = 0;
  //计算战场中所有角色(英雄)的血量
  foreach(Hero hero in heros){
    code = code + hero.hp
  }
  //计算所有塔的血量
  foreach(Tower tower in towers){
    code = code + tower.hp
  }
  return code;
}
```

防外挂的核心要点，就是要尽可能多地让服务端做逻辑运算、尽可能多地校验客户端的运算结果，不要相信客户端的一切输入。
