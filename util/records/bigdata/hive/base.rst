.. highlight:: rst
.. _records_bigdata_hive_base:

Hive 基本概念
^^^^^^^^^^^^^^^^^^
.. toctree::
  :maxdepth: 2
  :glob:




- hive参数的配置方式

::

    1. 通过hive-site.xml配置, 全局生效
    2. 通过启动时的命令行传递，但只针对本次回话生效
    3. 通过执行时设置 ``set ...`` 生效，只针对本次会话

    优先级方式： 3 > 2 > 1 ,优先级高的会覆盖优先级低的参数配置

调优特性
===========

1. hive-同一份数据多种处理

::

    使用方式：
        hive > from table1
        > INSERT OVERWRITE TABLE2 select *  where action='xx1'
        > INSERT OVERWRITE TABLE3 select *  where action='xx2';

2. mapper and reducer 处理优化

当Hive输入由很多个小文件组成，由于每个小文件都会启动一个map任务，如果文件过小，以至于map任务启动和初始化的时间大于逻辑处理的时间，会造成资源浪费，甚至OOM。
为此，当我们启动一个任务，发现输入数据量小但任务数量多时，需要注意在Map前端进行输入合并
当然，在我们向一个表写数据时，也需要注意输出文件大小
 
    1. Map输入合并小文件
    对应参数：
    set mapred.max.split.size=256000000;  #每个Map最大输入大小
    set mapred.min.split.size.per.node=100000000; #一个节点上split的至少的大小 
    set mapred.min.split.size.per.rack=100000000; #一个交换机下split的至少的大小
    set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;  #执行Map前进行小文件合并
     
    在开启了org.apache.hadoop.hive.ql.io.CombineHiveInputFormat后，一个data node节点上多个小文件会进行合并，合并文件数由mapred.max.split.size限制的大小决定。
    mapred.min.split.size.per.node决定了多个data node上的文件是否需要合并~
    mapred.min.split.size.per.rack决定了多个交换机上的文件是否需要合并~
     
     
    2.输出合并
    set hive.merge.mapfiles = true #在Map-only的任务结束时合并小文件
    set hive.merge.mapredfiles = true #在Map-Reduce的任务结束时合并小文件
    set hive.merge.size.per.task = 256*1000*100 # 合并后文件的大小为256M左右
    set hive.merge.smallfiles.avgsize=16000000 #当输出文件的平均大小小于该值时，启动一个独立的map-reduce任务进行文件merge

    3. reducer 参数
    set hive.exec.reducers.bytes.per.reducer=5120000000；   # 用来控制每个reducer处理的数据量大小
    set hive.exec.reducers.max = 3; # 设置最大可用reducer数，默认999
    set mapred.reduce.tasks = xx; #手动设置运行的reducer数量

基础应用
============

1. 修改数据表

::

    # 修改表的location
    alter table {tableName} set location 'hdfs://xxxx' 

    # 修改表的row_format，用于拆分hive表中的集合数据
    alter table hdp_hbg_fcrd_58_defaultdb.fangchan_offline_houses_daily set SERDEPROPERTIES ('mapkey.delim' = ':');
    alter table hdp_hbg_fcrd_58_defaultdb.fangchan_offline_houses_daily set SERDEPROPERTIES ('colelction.delim' = ',');
    # 修改字段的分割
    ALTER TABLE table_name set serde 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' WITH SERDEPROPERTIES ('field.delim' = '|');

    # 修改字段的名称，类型和顺序
    ALTER TABLE table_name CHANGE col_old_name col_new_name column_type CONMMENT '' [FIRST|AFTER column_name


    # 删除表数据
    truncate table {tableName} 删除表数据，但保留表结构


2. hive表数据关联hdfs文件

::

    alter table {tablename} add partition (dt='${dateSuffix}') location 'hdfs://xxx';
    load data inpath 'hdfs://xxxx' overwrite into table {tablename} partition(`type`='commercial',statdate='20181129'); 




hive 基本函数
===================


1. count

::

    count(*)：所有行进行统计，包括NULL行
    count(1)：所有行进行统计，包括NULL行
    count(column)：对column中非Null进行统计
    count(case when is_biz = 1 then uuid else null end) as pv  包含复杂条件的数量统计


2. if 函数

::

    通过判断条件值，返回响应结果
    if(condition, ture_return , fasle_return) as xxx

3. insr 

::

    用于判断字符串中是否存在某字符。 函数形式为：

    instr(string str, string substr) 返回substr在str中第一次出现的位置。若任何参数为null返回null，若substr不在str中返回0。否则返回字符串的其实位置。 返回结果的下标从1开始

4. 时间函数

::

    unix_timestamp('2018-12-18 00:38:50')*1000 时间戳转化为毫秒
    unix_timestamp('20111207 13:01:03','yyyyMMdd HH:mm:ss') 日期转化为时间戳
    from_unixtime(1441565203,'yyyy/MM/dd HH:mm:ss') 时间戳转化为日期
