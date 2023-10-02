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

![旧框架与ECS框架对比](../.gitbook/assets/2023-10-02154110.png)

每个实体可以根据自己的需求来选择，是否需要有这个动作来决定是否实现这些接口。

下面我们将从以前的面向对象编程，慢慢探索组件式编程的奇妙之旅。

### Component 与 Entity

1. 构建组件 Component 类,每一个组件都有唯一的 SN 标识，和一个父对象指针。

```cpp
class Entity;
class Component
{
public:
    virtual ~Component() = default;
    virtual void Dispose() = 0;
    void SetParent(Entity *pObj);
    Entity *GetParent() const;
    long GetSN() const;
    void SetSN(const long sn);

private:
    Entity *_parent{nullptr};
    long _sn{0};
};
void Component::SetParent(Entity *pObj)
{
    _parent = pObj;
}
Entity *Component::GetParent() const
{
    return _parent;
}
long Component::GetSN() const
{
    return _sn;
}
void Component::SetSN(const long sn)
{
    _sn = sn;
}
```

2. 实体 Entity 类

Entity 继承于 Component, 也就是 Entity 本身也是个 Component,Entity 下可以挂载多个 Component。被挂载的 Component 的\_parent 指向挂载自己的 Entity 对象地址。

```cpp
class Entity : public Component
{
public:
    void Dispose() override;
    void AddComponent(Component *obj);
    template <class T>
    T *GetComponent();

protected:
    std::map<long, Component *> _components;
};

template <class T>
T *Entity::GetComponent()
{
    auto iter = std::find_if(_components.begin(), _component.end(), [](std::pair < long, Component *) one)
    {
        //不能动态转换地址对应对象与T没有基类派生类关系
        if (dynamic_cast<T>(one.second) != nullptr)
        {
            return true;
        }
        return false;
    });
    if (iter == _components.end())
    {
        return nullptr;
    }
    return dynamic_cast<T>(iter->second)
}
```

再看下 AddComponent 与 Dispose 的实现

```cpp
void Entity::AddComponent(Component *pObj)
{
    pObj->SetParent(this);//这样每个Component本身就可以获取自己在那个Entity
    _components.insert(std::make_pair(pObj->GetSN(), pObj));
}

void Entity::Dispose()
{
    for (const auto &one : _components)
    {
        one.second->Dispse();
    }
}
```

### 系统类 System

定义 System 的接口，不同的 Object 可以根据自身的业务需求，按需实现。

```cpp
class ISystem
{
protected:
    ISystem() = default;

public:
    virtual ~ISystem() = default;
};

// Init接口 实现初始化操作
class IInitializeSystem : virtual public ISystem
{
protected:
    IInitializeSystem() = default;

public:
    virtual ~IInitializeSystem() = default;
    virtual void Initialize() = 0;
};

// Update接口 实现更新操作
class IUpdateSystem : virtual public ISystem
{
protected:
    IUpdateSystem() = default;

public:
    virtual ~IUpdateSystem() = default;
    virtual void Update();
};

// 为什么要用虚继承，因为同一个类可能同时实现IInitializeSystem与IUpdateSystem
// 不用虚继承就会产生ISystem的二义性
```

### 管理类 EntitySystem

管理类 EntitySystem 用于维护 Entity 和 Component 类,通俗的来讲就是将 Entity 与 Component 按照 System 接口的实现类型进行分类管理.

```cpp
class EntitySystem
{
public:
    virtual ~EntitySystem() = default;
    // 创建Component
    template <class T, typename... TArgs>
    T *CreateComponent(TArgs &&...args);
    virtual bool Update();
    void Dispose();

protected:
    std::list<IInitializeSystem *> _initializeSystems;
    std::list<IUpdateSystem> _updateSystem;
};
template <class T, typename... TArgs>
T *EntitySystem::CreateComponent(TArgs &&...args)
{
    std::cout << "create obj:" << typeid(T).name() << std::endl;
    auto component = new T(std::forward<TArgs>(args)...);
    const auto objInit = dynamic_cast<IInitializeSystem *>(component);
    if (objInit != nullptr)
    {
        _initializeSystems.push_back(objInit);
        return component;
    }
    const auto objUpdate = dynamic_cast<IUpdateSystem *>(component);
    if (objUpdate != nullptr)
    {
        _updateSystems.push_back(objUpdate);
        return component;
    }
    return component;
}
```

EntitySystem 有自己的 Update 与 Dispose,对需要 Init 的处理后,还会判断其是否实现了 Update,如果实现了 Update 则加入 Update 列表.

```cpp
bool EntitySystem::Update()
{
    while (_initializeSystems.size() > 0)
    {
        auto pComponent = _initializeSystems.front();
        pComponent->Initialize();
        _initializeSystems.pop_front();
        const auto objUpdate = dynamic_cast<IUpdateSystem *>(pComponent);
        if (objUpdate != nullptr)
        {
            _updateSystems.push_back(objUpdate);
        }
    }
    for (auto &iter : _updateSystems)
    {
        iter->Update();
    }
    return true;
}

void EntitySystem::Dispose()
{
    while (_initializeSystems.size() > 0)
    {
        auto pComponent = dynamic_cast<Component *>(_initializeSystems.font());
        pComponent->Dispose();
        _initializeSystems.pop_front();
    }
    for (auto &iter : _updateSystems)
    {
        auto pComponent = dynamic_cast<Component *>(iter);
        pComponent->Dispose();
    }
    _updateSystems.clear();
}
```

### ECS 大致效果

使用起来的实际效果大概是怎样的呢?

1. 实现 Entity

```cpp
class TestEntityWithUpdate : public Entity, public IUpdateSystem
{
public:
    virtual void Update() override;

private:
    bool _isShow{false};
};
class TestEntityWithInitAndUpdate : public Entity, public IInitializeSystem, public IUpdateSystem
{
public:
    virtual void Initialize() override;
    virtual void Update() override;

private:
    bool _isShow{false};
};
void TestEntityWithInitAndUpdate::Initialize()
{
    std::cout << typeid(this).name() << "::" << "Initialize" << std::endl;
}
void TestEntityWithInitAndUpdate::Update()
{
    if (_isShow)
        return;

    std::cout << typeid(this).name() << "::" << "Update" << std::endl;
    _isShow = true;
}
void TestEntityWithUpdate::Update()
{
    if (_isShow)
        return;
    std::cout << typeid(this).name() << "::" << "Update" << std::endl;
    _isShow = true;
}
```

2. 实现 Component

```cpp
class TestCUpdate : public Component, public IUpdateSystem
{
public:
    void Dispose() override;
    void Update() override;

private:
    bool _isShow{false};
};
void TestCUpdate::Dispose()
{
}
void TestCUpdate::Update()
{
    if (_isShow)
        return;
    std::cout << typeid(this).name() << "::" << "Update" << std::endl;
    _isShow = true;
}
```

```cpp
class TestCInit :public Component, public IInitializeSystem
{
public:
	void Initialize() override;
	void Dispose() override;
};
void TestCInit::Initialize()
{
    std::cout << typeid(this).name() << "::" << "Initialize" << std::endl;
}
void TestCInit::Dispose()
{
}
```

使用效果

```cpp
int main()
{
    EntitySystem eSys;
    auto pEntity1 = eSys.CreateComponent<TestEntityWithInitAndUpdate>();
    auto pEntity2 = eSys.CreateComponent<TestEntityWithUpdate>();

    const auto pCInit = eSys.CreateComponent<TestCInit>();
    pEntity1->AddComponent(pCInit);

    const auto pCUpdate = eSys.CreateComponent<TestCUpdate>();
    pEntity2->AddComponent(pCUpdate);

    //进行AddComponent后,pCInit与pCUpdate内部就可以去到自己所挂载在的Entity

    while (true)
    {
        eSys.Update();
    }
}
```

现在其实还是存在些问题的,其实如 TestEntityWithInitAndUpdate 应该自己所挂载在的 Entity 来执行自己的 Initial 与 Update,而不是由 EntitySytem 直接管理.

### 这种骚操作真的好吗

像这样的代码简直晦涩难懂,但是向顶层提供了简介的使用方式,这样的设计还是不错的.

### 基于 ECS 的 Server

![对象与EntitySystem的分布图](../.gitbook/assets/2023-10-02175358.png)

现在每个 Thread 都应有一个 EntitySystem,这与以前的设计不同的大致有:

1. 不需要基类 ThreadObject,由 Entity 或者 Component 代替.
2. ThreadMgr 作为主线程的对象,除了进行线程管理之外,也需要继承 EntitySystem,在主线程中也有全局的 Entity 或 Component 需要管理.
3. 线程类 Thread 需要集合 EntitySystem 类的功能,Thread 管理 std::thread 对象,而基类 EntitySystem 打理线程中的 Entity 或 Component(相当于原来的 ThreadObject).
4. 增加一些基础的 System 类,如 UpdateSystem 和 MessageSystem.

这样一来,在新的框架设计中,生成对象是由 EntitySystem 对象统一生成的,生成对象的同时需要对这些对象特征进行分析,放置到不同的系统中,如新对象是否实现了 IMessageSystem 接口,决定了它是否需要进行消息处理,实现了 IUpdateSystem 接口决定了它需要每帧更新.
