---
coverY: 0
---

# 🤩 桶排序

## 桶排序

例如有10个学生的成绩(68、75、54、70、83、48、80、12、75、92)

成绩在0\~100区间，则可以划分为10个桶

<figure><img src="../../../.gitbook/assets/屏幕截图 2022-09-11 220046.jpg" alt=""><figcaption><p>分配</p></figcaption></figure>

0\~9放在0区间，10\~19放在1区间，然后用较好的排序算法对每个区间进行排序

<figure><img src="../../../.gitbook/assets/屏幕截图 2022-09-11 220032.jpg" alt=""><figcaption><p>排序</p></figcaption></figure>

然后使用O(n)的时间将内容取出，就得到了有序的序列
