.. highlight:: rst

.. _system_mac_system-tools:

系统的基本工具和属性
----------------------

1. 外接硬盘只读模式

   由于硬盘的文件格式为window格式，无法被mac操作, 如果希望能够读写外接硬盘，那么需要以ExFAT格式重新格式化硬盘，

::

    1. 备份需要格式化的硬盘
    2. finder -> 应用程序 -- 实用工具 -- 磁盘工具，选择要格式化的磁盘并以ExFAT格式进行格式化
    3. 磁盘可以读写操作了，将备份的数据拷回来


2. mac 系统的mdworker进程占用大量cpu

   macx系统通过Spotlight建立文件索引消耗cpu

::

    # 关闭命令
      sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
    # 开启命令
      sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist

3 brew 使用

    brew install xx
    brew upgrade xx


4. 系统命令

1. top
::::::::::

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


::

   top -o -mem  按占用内存进行排序  
   top -o -cpu  按cpu使用率进行排序  
