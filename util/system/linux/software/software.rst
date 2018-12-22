.. _linux_basic_software:

.. toctree::
   :maxdepth: 2
   :glob:

装机必备的基础软件
----------------------

.. code-block:: sh

    sudo apt install vim
    sudo apt install git

    sudo apt install zsh

    sudo  apt-get install openssh-server
    service ssh start # 开启
    /etc/init.d/ssh start # 关闭



软件下载校验
=================

文件下载完成后，一般会有相应的校验文件。可以校验文件的完整性和安全性。

例如下载idea文件，文件名称为 ``ideaIU-2018.3.1.tar.gz`` ,可以直接执行 ``sha256sum ideaIU-2018.3.1.tar.gz`` 计算文件的加密值然后与网站提供的进行对比，也可以直接下载校验文件，然后执行 ``sha256sum 校验文件`` 来判断文件是否正确。
    
常见的其他校验算法还有： ``md5sum`` 等


系统软件安装与删除
-------------------

::

    aptitude purge $(dpkg -l|grep ^rc|awk '{ print $2 }')

    解释：
    dpkg -l 列出系统中所有安装的软件，如果是已经删除的软件（有残存的配置文件），那么该的软件包的状态是rc，即开头显赫为rc 然后是空格，然后是软件包的名称

    |grep ^rc 的用处就是找出状态为rc的所有软件包，即以rc开头的行;

    |awk '{ print $2 }' awk可以将输入的字符串用指定的分隔符进行分解，缺省情况下是空格，$2是表示第二个字段，也就是软件包的名称，因为第一个字段是 rc

    $(......)是一个shell表示法，即里面包含括号中的命令输出的内容，实际上是以空格分隔的所有软件包的名称组成的一个字符串

    aptitude purge 就是彻底删除软件包（包括配置文件），如果是残存的配置文件，也可以用这种方式删除
    其实，grep ^rc可以写成grep rc
     
     我在安装某一deb包时发生配置错误，每次安装其他东西都要显示这条错误信息，很烦。
     用dpkg -l查看包的状态时，发现是iF。就是配置失败。
     于是，aptitude purge $(dpkg -l|grep iF|awk '{ print $2 }')
     将其删除。

    Example: 
         sudo apt-get --purge remove nginx
         sudo apt-get autoremove # 自动移除全部不使用的软件包
         dpkg --get-selections|grep nginx #罗列出与nginx相关的软件


2. E: dpkg 被中断,您必须手工运行 ‘sudo dpkg --configure -a’ 解决此问题

::
    
    导致这个问题的主要原因是因为/var/lib/dpkg/updates文件下的文件有问题，可能是其他软件安装过程或是其他原因导致的，这里删除掉然后重建即可。

    sudo rm /var/lib/dpkg/updates/*
    sudo apt-get update
    sudo apt-get upgrade
