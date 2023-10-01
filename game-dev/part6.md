---
cover: >-
  https://images.unsplash.com/photo-1650170496638-b05030a94005?crop=entropy&cs=srgb&fm=jpg&ixid=MnwxOTcwMjR8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI1MzAzMzQ&ixlib=rb-1.2.1&q=85
coverY: 0
---

# 🚗 ECS 框架

## ECS 框架

简单来说，不论是多线程还是单线程，不断更新逻辑，对每个对象执行
Update 操作，是目前比较常用的一种框架体系。但这个框架中有一些问题，例
如需要每一个对象都继承自 ThreadObject 类，如果功能复杂，就可能出现虚继
承的情况。代码越写越多，其复杂度越来越高，继承的层数也会变得更深，这
给编码带来了不小的麻烦。在此基础上，要引入一个新的架构思路——ECS 框架。

### 什么是 ECS 工程

ECS 的全称为 Entity Component System，Entity 是实体，Component 是组
件，System 则指系统。Entity 中可以包括无数个 Component，具备某组件便具有
某功能，而 System 是控制这些组件的动作。

所有的 Object 都继承 ThreadObject，但是并不是实现的所有 Object 都需要定义自己的 Initialize、与 update。
可能只是写了个空的函数。

为了解决空函数的问题，提出了一个 System 框架，在 System 中定义了几种类型的动作。例如 InitializeSystem 是初始化动作，UpdateSystem 是更新系统，每一个动作都是一个接口。这意味着一个对象可以实现按需定义，如果需要初始化就实现 InitializeSystem 接口，如果需要 Update 就实现 UpdateSystem 接口。
