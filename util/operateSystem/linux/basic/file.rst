
.. toctree::
   :maxdepth: 2
   :glob:

文件操作
----------

文件权限
~~~~~~~~~~~~

::

    1). ln -sf 源文件 软连接名称 //为某个源文件建立软连接
    2). chown -R name:group filedir //修改文件的拥有者 如果是软连接，则需要添加-h参数
    3). chmod -R 744 dir/file //修改文件或文件夹的读写权限
    4). chgrp root ./test.sh  //将当前目录的test文件的所属组修改为root

文件操作 
~~~~~~~~~

::

    1. sudo du -h --max-depth=1 | grep 'G' | sort -n  #查询文件大小


文件压缩
~~~~~~~~

::

     tar 压缩解压 
        命令：tar [-cxtzjvfpPN] 文件或目录 ...
        -c : 建立一个压缩文件的参数指令
        -x ：解开一个压缩文件的参数指令
        -t : 查看一个tar里面的文件  c/x/t 仅能存在一个
        -z : 是否同时需要gzip压缩
        -j : 是否需要bzip2压缩
        -f : 使用文档名，f之后必须马上接档名。 如:tar -zcvfP target source 是错误的，需要写为tar -zcvPf target source
        -p : 使用文件的原来属性
        -P : 可以使用绝对路径来压缩
        -N : 比后面的日期(yyyy/mm/dd)新的才会被打包进新文件中
        --exclude FILE : 在压缩过程中，不将FILE打包
        示例:
            tar -zcvf /tmp/etc.tar.gz ##>打包成/tmp/etc.tar.gz后，以gzip来压缩
            tar -ztvf /tmp/etc.tar.gz ##>查看tar包中内容
            tar -N '2016/12/22' -zcvf home.tar.gz /home ##>在home中，比'2016/12/22'新的文件才会被打包
            tar exclude /home/dmtsai -zcvf myfile.tar.gz /home/* /etc ##>备份/home,/etc,但不包含/home/dmtsai
            tar -cvf - /etc | tar -xvf - ##>等价与cp -r /etc /tmp
            tar --exclude ./application-insight/.git -zcvf app.tar.gz ./application-insight/*
