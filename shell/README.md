# shell

Shell 不是一种传统意义上的编程语言，而是一种命令行解释器。它是一种解释型语言，主要用于在 Unix 和类 Unix 系统上执行命令和控制系统的操作。Shell 可以编写脚本，通过运行这些脚本来实现批量处理文件、执行系统命令等功能。

Shell 脚本通常包含了一系列的命令、控制结构和变量定义，可以完成很多与操作系统相关的任务。Shell 脚本也可以调用其他程序和脚本，可以与其他编程语言和工具结合使用。因此，尽管 Shell 不是一种传统的编程语言，但它在系统管理和自动化方面的作用非常重要。

## 初始 Linux shell

## 走进shell

## 基本的bash shell命令

## 更多的bash shell命令

## 理解shell

## 使用linux环境变量

## 理解linux文件权限

## 管理文件系统

## 安装软件程序

## 使用编辑器

## 构建基本脚本

## 使用结构化命令

## 更多的结构化命令

## 处理用户输入

## 呈现数据

## 控制脚本

## 创建函数

## 图形化桌面环境中的脚本编程

## 初始sed和gawk

## 正则表达式

## sed进阶

## gawk进阶

## 使用其他shell

## 编写简单的脚本使用工具

## 创建与数据库、web及电子邮件相关的脚本

## 一些小有意思的脚本

## ssh密钥免密登录

在 Linux 系统上设置 SSH 密钥免密登录可以使你在登录远程服务器时不需要输入密码。以下是具体步骤：

1. 生成SSH密钥对

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

2. 将公钥复制到远程服务器

```bash
ssh-copy-id user@remote_host
```

3. 执行该命令后，系统会提示你输入远程服务器的密码。成功后，公钥将被添加到远程服务器上的 `~/.ssh/authorized_keys` 文件中。

```bash
ssh user@remote_host
```

如果设置正确，应该能够直接登录到远程服务器，不需要输入密码。

4. 远程主机上删除SSH免密登录的方法

删除公钥，SSH 免密登录是通过将公钥添加到远程主机上的 `~/.ssh/authorized_keys` 文件中实现的。要删除免密登录，你需要从这个文件中删除相关的公钥。
`~/.ssh/authorized_keys`中一行就是一条公钥，找到目标把那行删除即可。

5. 手动添加公钥到目标主机

可以将用户下的`~/.ssh/id_rsa.pub`内容加到remote_host user下的`~/.ssh/authorized_keys`中，一行。有时需要设置文件权限才能生效。

```bash
# 在remote_host user下
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
# 在remote_host root下
service sshd restart
```
