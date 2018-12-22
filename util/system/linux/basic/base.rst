
.. toctree::
   :maxdepth: 2
   :glob:

系统特性基础
^^^^^^^^^^^^^^^^^

.. tip::

    buntu-16.10 开始不再使用initd管理系统，改用systemd,例如 systemctl restart networking.service

系统常用命令
-----------------

::

    1. cat /proc/cpuinfo , lscpu  查看cpu信息 \
    2. sudo gedit /etc/apt/sources.list // 操作清理apt update 数据
    3. nslookup smtp.exmail.qq.com // 查看邮件的服务地址是否合法

    3. 操作历史记录： 
          history -c 清除当前回话的历史命令
          通过编辑： ``vim ~/bash_history`` 文件删除历史命令 

    4.  base64 命令
        echo 'ownStr' | base64 # 将ownStr进行base64转码
        echo 'ownStr' | base64 -d # 将ownStr进行base64解码


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
