Git 问题记录
==============

记录在使用git过程中，碰到的一些问题

.. toctree::
   :maxdepth: 2
   :glob:

使用OpenSSh重启后，git链接服务器会UnKonwHost报错
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
::

    ssh-keygen -f "/home/langle/.ssh/known_hosts" -R scm.xxx.me


GET CRLF to LF问题
~~~~~~~~~~~~~~~~~~
::
   
    可以通过命令转化：
    find ./ -type f -name "*.properties" -exec dos2unix {}
