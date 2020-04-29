
# 系统的基本工具和命令

## 1. 基本使用命令

* Spotlight 打开和关闭
mac 系统的mdworker进程占用大量cpu, 原因是系统通过Spotlight建立文件索引消耗cpu

      sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
      sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
* mac终端下打开图片或文件（夹）
  打开图片 ： open 图片名
  打开finder： open 文件夹名
  打开当前文件夹：open  .
  此外还可以通过open命令打开文件、打开程序等


## 2. 技巧篇

* 外接硬盘只读模式

   由于硬盘的文件格式为window格式，无法被mac操作, 如果希望能够读写外接硬盘，那么需要以ExFAT格式重新格式化硬盘，

    1. 备份需要格式化的硬盘
    2. finder -> 应用程序 -- 实用工具 -- 磁盘工具，选择要格式化的磁盘并以ExFAT格式进行格式化
    3. 磁盘可以读写操作了，将备份的数据拷回来

## 3. 工具篇

* brew 使用

    brew install xx
    brew upgrade xx
    export HOMEBREW_NO_AUTO_UPDATE=true // 每次使用时关掉brew的自动更新

## 系统命令

1. top

```
字段说明：
PID       进程 id
COMMAND   命令
%CPU      cup 占比
TIME      运行时间
#TH       线程数量
#WQ
#PORT
MEM       内存
PURG
CMPRS     表示属于您的进程的压缩数据的字节数（不是位）。
PGRP
PPID
STATE
BOOSTS
%CPU_ME
%CPU_OTHRS
UID

top -o -mem  按占用内存进行排序  
top -o -cpu  按cpu使用率进行排序  
```