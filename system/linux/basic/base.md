
## 系统特性基础

``tip``

    buntu-16.10 开始不再使用initd管理系统，改用systemd,例如 systemctl restart networking.service

### 1. 系统常用命令

``` 
    1. cat /proc/cpuinfo , lscpu  查看cpu信息 \
    2. sudo gedit /etc/apt/sources.list // 操作清理apt update 数据
    3. nslookup smtp.exmail.qq.com // 查看邮件的服务地址是否合法

    3. 操作历史记录： 
          history -c 清除当前回话的历史命令
          通过编辑： ``vim ~/bash_history`` 文件删除历史命令 

    4.  base64 命令
        echo 'ownStr' | base64 # 将ownStr进行base64转码
        echo 'ownStr' | base64 -d # 将ownStr进行base64解码
    5. chown -R langle:langle {targetDir} 将某目标文件权限赋予langle

    6. uname -a 查看系统环境参数

```
#### 1.1 查看物理CPU个数、CPU内核数、线程数

physical id：每颗CPU的id，计算系统中有几个CPU。
cpu cores：当前的CPU有几个核心。
processor：每个CPU线程的id，计算系统中总计有几个CPU线程。

``` sh
# 总核心数 = 物理CPU个数  X  每颗物理CPU的核数
# 总逻辑CPU数 = 物理CPU个数  X  每颗物理CPU的核数  X  超线程数

# 查看CPU逻辑id
grep 'physical id' /proc/cpuinfo | sort -u

# 查询物理CPU个数
cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l

# 查看每个物理CPU中core的核数(即个数)
cat /proc/cpuinfo| grep "cpu cores"| uniq

# 查看逻辑CPU的个数
cat /proc/cpuinfo| grep "processor"| wc -l

# 查看总线程数量
grep 'processor' /proc/cpuinfo | sort -u | wc -l

# 查看CPU信息（型号）
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c

# cpu详细信息
cat /proc/cpuinfo

# intel官方查看CPU列表信息 https://ark.intel.com/content/www/us/en/ark.html#@Processors

# CPU占用最多的前10个进程
ps auxw|head -1;ps auxw|sort -rn -k3|head -10 

# 内存消耗最多的前10个进程 
ps auxw|head -1;ps auxw|sort -rn -k4|head -10 

# 虚拟内存使用最多的前10个进程 
ps auxw|head -1;ps auxw|sort -rn -k5|head -10

	USER      //用户名
	%CPU      //进程占用的CPU百分比
	%MEM      //占用内存的百分比
	VSZ       //该进程使用的虚拟內存量（KB）
	RSS       //该进程占用的固定內存量（KB）resident set size
	STAT      //进程的状态
	START     //该进程被触发启动时间
	TIME      //该进程实际使用CPU运行的时间

	ps auxw
	u：以用户为主的格式来显示程序状况
	x：显示所有程序，不以终端机来区分 
	w：采用宽阔的格式来显示程序状况
	ps auxw|head -1 输出表头
	
	sort -rn -k5 
	-n是按照数字大小排序
	-r是以相反顺序
	-k是指定需要排序的栏位


```

杂项技巧
===============

* 开机启动

::
   1. 查看/lib/systemd/system/ 可以发现我们需要的rc.local.service, 在文件中添加
         [Install]
         WantedBy=multi-user.target
         Alias=rc-local.service
   2. 编辑/etc/rc.local 文件，在文件中 ``exit 0`` 中添加自定义脚本,模板：rc.local_
   3. 添加软链接： ln -s /lib/systemd/system/rc.local.service /etc/systemd/system/      


.. _rc.local:

.. code-block:: shell

::
    
    #!/bin/sh -e
    #
    # rc.local
    #
    # This script is executed at the end of each multiuser runlevel.
    # Make sure that the script will "exit 0" on success or any other
    # value on error.
    #
    # In order to enable or disable this script just change the execution
    # bits.
    #
    # By default this script does nothing.
      
    exit 0


系统清理
----------------

Var 目录清理
===================

1. 定时清理无用的软件信息
   autoremove的作用是卸载所有自动安装且不再使用的软件包,这种方式容易将必要的软件删除掉，尽量不要使用

::
    sudo apt-get clean

    // autoremove的作用是卸载所有自动安装且不再使用的软件包,这种方式容易将必要的软件删除掉，尽量不要使用
    sudo apt-get autoremove

2. 将var目录链接到空间比较富裕的区块

::

    Linux软链接：它只会在你选定的位置上生成一个文件的镜像，不会占用磁盘空间，命令：ln －s xxx
    Linux硬链接：它会在你选定的位置上生成一个和源文件大小相同的文件，命令：ln xxx
