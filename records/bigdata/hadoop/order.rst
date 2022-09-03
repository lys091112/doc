.. highlight:: rst
.. _records_bigdata_hadoop_order

hadoop使用的常用命令
^^^^^^^^^^^^^^^^^^^^^^^^^^

操作hdfs文件
------------

::
    # 查看文件的前几行数据
    hadoop fs -text /home/xxxx/warehouse/xxxx/xxxx/203/20181125/000370_0_0.lzo | head -10

    # 查看文件的后几行数据
    hadoop fs -text /home/xxxx/warehouse/xxxx/xxxx/203/20181125/000370_0_0.lzo | tail -10

    #查看文件数量
    hadoop fs -cat xxx | wc -l

