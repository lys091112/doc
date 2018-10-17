.. _system_linux_basic_error:

.. toctree::
   :maxdepth: 2
   :glob:

错误记录
================

在使用过程中linux的一些文件大小，编码，文件属性等之类的问题

Linux 和 window 造成的文件编码问题
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::
    
    在执行window上传的sh文件时，控制台报错：
    /bin/bash^M: bad interpreter: 没有那个文件或目录，

    Reason: 
    因为操作系统是windows，在windows下编辑的脚本，有可能有不可见字符。
    脚本文件是DOS格式的, 即每一行的行尾以^M 来标识, 其ASCII码分别是0x0D, 0x0A.
    
    可以在vim下通过:set ff? 查看文件格式是否为fileforma=dos,
    然后在vim下通过执行:set fileforma=unix转化文件编码

