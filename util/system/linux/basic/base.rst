
.. toctree::
   :maxdepth: 2
   :glob:

系统特性基础
^^^^^^^^^^^^^^^^^

.. tip::

    buntu-16.10 开始不再使用initd管理系统，改用systemd,例如 systemctl restart networking.service

系统基本信息
-----------------

::

    1. cat /proc/cpuinfo , lscpu  查看cpu信息
    2. sudo gedit /etc/apt/sources.list // 操作清理apt update 数据


杂项技巧
-----------------

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

    

小技巧
~~~~~~~~

::

    1. 开机自启动
       vim /etc/rc.local 将自己的脚本写入到里面，例如： cd /home/langle/vpn  sh vpn.sh
    2. 查看邮件的服务地址是否合法
        nslookup smtp.exmail.qq.com
