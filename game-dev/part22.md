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
  
end
```

### 透视外挂案例

### 尽可能多的校验

### 小游戏防刷榜

### 篮球游戏案例

### 部署校验服务

### 反外挂常用措施

### 防变速器

### 防封包工具

### 帧同步投票
