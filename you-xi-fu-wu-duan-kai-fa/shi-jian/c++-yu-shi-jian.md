---
coverY: 0
---

# 🍉 C++与时间

## C++与时间

### 样例代码

基本可以验证 上一篇，正确认识时间部分

```cpp
#include <iostream>
#include <chrono>
#include <iomanip>
#include <ctime>
using namespace std;

int main(int argc, char **argv)
{
    // 获取当前时间点
    auto now = std::chrono::system_clock::now();
    // 将时间点转换为 time_t 其实就是UTC时间戳
    std::time_t time_now = std::chrono::system_clock::to_time_t(now);

    cout << time_now << endl;
    // 1703142830

    // time_t转换为tm结构(GMT时间)
    std::tm *gmt_time = std::gmtime(&time_now);

    // 打印GMT时间(伦敦中时区时间) Beijing时间需要在此基础上加8小时因为在东8区
    // 月份是从0开始的
    cout << "Current GMT time: "
         << gmt_time->tm_year + 1900 << '-'
         << gmt_time->tm_mon + 1 << '-'
         << gmt_time->tm_mday << ' '
         << gmt_time->tm_hour << ':'
         << gmt_time->tm_min << ':'
         << gmt_time->tm_sec
         << endl;
    // Current GMT time: 2023-12-21 7:13:50

    auto timestamp_s = std::chrono::duration_cast<std::chrono::seconds>(now.time_since_epoch()).count();
    auto timestamp_ms = std::chrono::duration_cast<std::chrono::milliseconds>(now.time_since_epoch()).count();
    auto timestamp_us = std::chrono::duration_cast<std::chrono::microseconds>(now.time_since_epoch()).count();
    auto timestamp_ns = std::chrono::duration_cast<std::chrono::nanoseconds>(now.time_since_epoch()).count();

    cout << timestamp_s << "\n"
         << timestamp_ms << "\n"
         << timestamp_us << "\n"
         << timestamp_ns << endl;
    /*
    1703142830
    1703142830235
    1703142830235759
    1703142830235759679
    */

    // 本地时间
    std::tm *localTime = std::localtime(&time_now);
    cout << "LocalTime:"
         << localTime->tm_year + 1900 << '-'
         << localTime->tm_mon + 1 << '-'
         << localTime->tm_mday << ' '
         << localTime->tm_hour << ':'
         << localTime->tm_min << ':'
         << localTime->tm_sec << ' '
         << "UTC " << localTime->tm_gmtoff << "s "
         << endl;
    // LocalTime:2023-12-21 15:13:50 UTC 28800s

    // 本地时间精度
    auto local_ms = std::chrono::duration_cast<std::chrono::microseconds>(now.time_since_epoch() % std::chrono::seconds(1));
    cout << "local_ms: " << local_ms.count() << endl;
    // local_ms: 235759

    // 夏令时
    cout << "tm_isdst: " << localTime->tm_isdst << endl;
    // tm_isdst: 0
    cout << "isdst: " << boolalpha << (bool)(localTime->tm_isdst > 0) << endl;
    // isdst:false

    // 时区相关
    // 1.使用<chrono>中的std::chrono::zoned_time,但不过C++20才有很好支持，所以一般不用
    // 2.使用<iomanip>中的std::get_time来操作

    // 设置时区,例如"America/New_York"表示纽约时区
    std::string time_zone_str = "America/New_York";
    if (std::getenv("TZ"))
    {
        cerr << "Warning: TZ is set." << endl;
    }
    setenv("TZ", time_zone_str.c_str(), 1);
    tzset();
    // 将UTC时间转为本地时间
    std::tm *newyork_localTime = std::localtime(&time_now);
    cout << "NewYork LocalTime:"
         << newyork_localTime->tm_year + 1900 << '-'
         << newyork_localTime->tm_mon + 1 << '-'
         << newyork_localTime->tm_mday << ' '
         << newyork_localTime->tm_hour << ':'
         << newyork_localTime->tm_min << ':'
         << newyork_localTime->tm_sec << ' '
         << "UTC " << newyork_localTime->tm_gmtoff << "s "
         << endl;
    // NewYork LocalTime:2023-12-21 2:25:54 UTC -18000s

    time_zone_str = "Asia/Shanghai";
    if (std::getenv("TZ"))
    {
        cerr << "Warning: TZ is set." << endl;
    }
    setenv("TZ", time_zone_str.c_str(), 1);
    tzset();
    std::tm *beijing_localTime = std::localtime(&time_now);
    cout << "Beijing LocalTime:"
         << beijing_localTime->tm_year + 1900 << '-'
         << beijing_localTime->tm_mon + 1 << '-'
         << beijing_localTime->tm_mday << ' '
         << beijing_localTime->tm_hour << ':'
         << beijing_localTime->tm_min << ':'
         << beijing_localTime->tm_sec << ' '
         << "UTC " << beijing_localTime->tm_gmtoff << "s "
         << endl;
    // Beijing LocalTime:2023-12-21 2:25:54 UTC 28800s

    return 0;
}
```

### 判断两个时间戳之间相差几天

其中可以解决夏令时调整问题

```cpp
#include <iostream>
#include <ctime>

// 自定义结构体表示本地时间
struct LocalTime {
    int year;
    int month;
    int day;
    int hour;
    int minute;
    int second;
};

// 获取每天凌晨5点的时间戳,以什么时间点为分界，可以进行调整
std::time_t getMidnightTimestamp(const LocalTime& localTime) {
    struct std::tm tmStruct = {};
    tmStruct.tm_year = localTime.year - 1900;
    tmStruct.tm_mon = localTime.month - 1;
    tmStruct.tm_mday = localTime.day;
    tmStruct.tm_hour = 5;
    tmStruct.tm_min = 0;
    tmStruct.tm_sec = 0;

    // mktime将tm转换为time_t
    return std::mktime(&tmStruct);
}

// 计算两个时间戳相差的天数
int calculateDaysDifference(std::time_t timestamp1, std::time_t timestamp2) {
    const int secondsInDay = 24 * 60 * 60;

    // 调整到每天凌晨5点的时间戳
    std::time_t midnight1 = getMidnightTimestamp(*std::localtime(&timestamp1));
    std::time_t midnight2 = getMidnightTimestamp(*std::localtime(&timestamp2));

    // 计算相差的天数
    return static_cast<int>((midnight2 - midnight1) / secondsInDay);
}

int main() {
    // 假设有两个时间戳（以秒为单位）
    std::time_t timestamp1 = /* 第一个时间戳 */;
    std::time_t timestamp2 = /* 第二个时间戳 */;

    // 计算相差的天数
    int daysDifference = calculateDaysDifference(timestamp1, timestamp2);

    // 输出结果
    std::cout << "Days difference: " << daysDifference << " days" << std::endl;

    return 0;
}
```

### 线程不安全问题

有些函数是线程不安全的，需要格外注意，像下面的，直接返回指针，背后肯定有全局变量的，当使用tm类型指针时，可能背后内存里面存储的值，已经不是你想要的了。

```cpp
std::tm *gmt_time = std::gmtime(&time_now);
std::tm *newyork_localTime = std::localtime(&time_now);
```
