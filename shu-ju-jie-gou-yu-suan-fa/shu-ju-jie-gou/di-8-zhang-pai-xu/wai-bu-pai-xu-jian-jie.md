---
coverY: 0
---

# 😜 外部排序简介

先将每个块依次读取，对其内部排序后，写入外存后

然后进行归并排序，先从归并两个块开始，

<figure><img src="../../../.gitbook/assets/屏幕截图 2022-09-11 233452.jpg" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/image (3) (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/屏幕截图 2022-06-07 213406.jpg" alt=""><figcaption></figcaption></figure>

多路归并的优化

<figure><img src="../../../.gitbook/assets/屏幕截图 2022-06-07 23406.jpg" alt=""><figcaption></figcaption></figure>

还有其他优化方式，减少初始归并段数量

例如有四个缓冲区，一下子读入四个将其内部排序，然后将四个快写回磁盘，省去了之前的步骤

<figure><img src="../../../.gitbook/assets/屏幕截图 2022-09-11 235410.jpg" alt=""><figcaption></figcaption></figure>
