.. _linux_clean:

系统清理
^^^^^^^^^^^

.. toctree::
   :maxdepth: 2
   :glob:


Var 目录清理
--------------

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
