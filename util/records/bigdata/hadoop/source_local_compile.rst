.. highlight:: rst

.. _records_bigdata_hadoop_source_local_compile:

Hadoop 源码本地编译安装
--------------------------

1. 安装源码编译需要的组件

::
    
    sudo apt-get install cmake
    sudo apt-get install zlib1g-dev
    sudo apt-get install libssl-dev
    ... 


2. 执行编译安装

::

    mvn package -Pdist,native,docs,src -DskipTests -Dtar
