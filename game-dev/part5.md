# 🚗 性能优化与对象池

## 性能优化与对象池

学习嘛，要稳扎稳打，学习使用工具对程序性能检查，思考怎样让程序更加高效很重要。

### Vistual Studio 性能工具

Visual Stdudio 性能工具，就先不学了，暂时用不到

在多线程编程中，注意谨防并行编程串行

```cpp
void ThreadMgr::DispatchPacket(Packet *pPacket)
{
    // 主线程
    AddPacketToList(pPacket);
    // 子线程
    std::lock_guard<std::mutex> guard(_thread_lock);
    for (auto iter = _threads.begin(); iter != _threads.end(); ++iter)
    {
        Thread *pThread = iter->second;
        pThread->AddPacketToList(pPacket);
    }
}
void ThreadObjectList::AddPacketToList(Packet *pPacket)
{
    std::lock_guard<std::mutex> guard(_obj_lock);
    for (auto iter = _objlist.begin(); iter != _objlist.end(); ++iter)
    {
        ThreadObject *pObj = *iter;
        if (pObj->IsFollowMsgId(pPacket))
        {
            pObj->AddPacket(pPacket);
        }
    }
}
```

上面的代码中有哪些不足之处，要知道 ThreadMgr 只有一个，其管理多个线程，每个线程的 ThreadObjectList 下管理大量的 ThreadObject。
这样调用 DispatchPacket 明明只是需要将 Packet 交给每个线程就行了，其实并不需要关注每个线程怎么做。交给每个线程，每个线程自己在 Update 时再处理将 Packet 派发给 ThreadObject 就好了。
能够有效 ThreadMgr::DispatchPacket 从调用到返回的间隔。

在上一章节中，看到了使用 std::copy 开拷贝 std::list 中的 Packet 的操作，显然这是非常耗费事件的，所以对内存中的数据结构进行优化也非常的重要。

### 内存中的数据结构

数据结构是计算机组织数据的方式，精心选择的数据结构可以带来更高的
运行或者存储效率。下面会了解交换型数据结构与刷新型数据结构。

### gprof

### valgrind

### 对象池
