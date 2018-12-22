.. highlight:: rst

.. _records_bigdata_hive_solutions:

使用hive中碰到的优化
^^^^^^^^^^^^^^^^^^^^^^

.. toctree::
  :maxdepth: 2
  :glob:

hive中碰到的数据倾斜
=========================

常见的情形：

+----------------+---------------------------------------------+----------------------------------------------+
| 关键词         | 情形                                        | 后果                                         |
+================+=============================================+==============================================+
| Join           | 其中一个表较小，但是key集中                 | 分发到某一个或几个Reduce上的数据远高于平均值 |
+----------------+---------------------------------------------+----------------------------------------------+
| Join           | 大表与大表，但是分桶的判断字段0值或空值过多 | 这些空值都由一个reduce处理，灰常慢           |
+----------------+---------------------------------------------+----------------------------------------------+
| group by       | group by 维度过小，某值的数量过多           | 处理某值的reduce非常耗时                     |
+----------------+---------------------------------------------+----------------------------------------------+
| Count Distinct | 某特殊值过多                                | 处理此特殊值的reduce耗时                     |
+----------------+---------------------------------------------+----------------------------------------------+

主要表现在其他任务可以很快完成，但是有几个任务一直保持99%左右的状态，持续很长时间,那么很有可能是发生了数据倾斜。

**常用的调节参数：**

- hive.map.aggr=true Map 端部分聚合，相当于Combiner

- hive.groupby.skewindata=true 有数据倾斜的时候进行负载均衡，当选项设定为 true，生成的查询计划会有两个 MR Job。第一个 MR Job 中，Map 的输出结果集合会随机分布到 Reduce 中，每个 Reduce 做部分聚合操作，并输出结果，这样处理的结果是相同的 Group By Key 有可能被分发到不同的 Reduce 中，从而达到负载均衡的目的；第二个 MR Job 再根据预处理的数据结果按照 Group By Key 分布到 Reduce 中（这个过程可以保证相同的 Group By Key 被分布到同一个 Reduce 中），最后完成最终的聚合操作。

**小表和大表的join**

小表与大表进行join时，一般是小表在前，大表在后，使用mapJoin将小表加载到内存中，提升join速度。 在hive1.1版本之后，hive默认开启mapjoin。

hive join操作的实际发生逻辑是：

当表A和表B之间发生join时，map会为所有的表生成map<key,value>结构，然后在shuffle阶段，会将biaoA和表B的数据放入到同一个List V中，
传递给reducer进行处理，
例如：select d.areaid, d.areaname  from  hdp_58_common_defaultdb.ds_dict_cmc_local d join  hdp_58_common_defaultdb.ds_dict_cmc_local  f on d.areaids[0]  = f.areaid and f.depth = '0' and     f.areaname = d.areaname and d.statdate = '20181206' and f.statdate = '20181206;

Mapper阶段： on 的条件是 d.areaids[0] = f.areaid  d.areaname=f.areaname, 那么在Mapper阶段，对于d表会使用key expressions: areaids[0] (type: string), areaname (type: string),对于F表则为key expressions: areaid (type: string), areaname (type: string)， 这样相同的key会被散列到同一个reducer中进行处理。

shuffle阶段: 会将d f两个表的数据组合成一个List V，左边的表在List V的前部，右边的表在List V的后部，随后传递给reducer处理

reducer阶段：遍历list V的,d表的数据在前，f表的数据在后：
    1. 如果遍历完整个数据发现只有d表数据或只有f表数据，那么代表该reducer没有符合的数据
    2. 如果遍历后V[0]... v[k] 属于d表，V[k+1] ... V[n] 属于f表，那么会依次两两组合，先取V[0] 然后分别与V[K+1].. V[n]进行关联输出，然后分别表用V[1]~V[k]与V[k+1]...V[n]进行关联输出

从reducer阶段可以看出，前期扫面V表需要K次判断区分两个表，后面会分别进行k * (n-k)次组合,总计k + k * (n - k) = k*(n - k + 1),所有当左边的表小时，可以减少扫描次数，同时左表小可以被加入到内存，同样加快处理速度

当reduce检测d表的记录时，还要记录d表同一个key的记录的条数，当发现同一个key的记录个数超过hive.skewjoin.key的值（默认为1000000）时，会在reduce的日志中打印出该key，并标记为倾斜的关联键

可以使用 ``explain`` 来查看hsql的执行过程

优化情景参考
==================

1. left join 时数据反而会比左边表数据条数多

::

    当右表中的同左表对应的记录有多条时，就会产生多条结果，
    如：select a.uuid, key, b.sport from a left join a on a.uuid = b.uuid
     a 数据           b数据
     uuid  key        uuid  sport
     1     k1          1     insert
     2     k2          1     delete

     那么合集后的数据为
     uuid key sport
     1    k1   insert
     1    k1   delete
     2    k2   null

2. select count(DISTINCT imei) from hdp_ubu_wuxian_defaultdb.tb_app_action where dt >= 20160801 and dt <= 20160831,执行任务失败

::
    问题分析：
    查询该表一个月的数据，总的数据量大约450亿条，这么巨大的数据量，使用distinct函数，所有的数据只会shuffle到一个reducer上，导致reducer数据倾斜严重！！！
g   解决办法：首先通过使用group by，按照imei进行分组，将数据分散到多台机器reduce。改写后的sql语句如下：select count(1) as uv from (select imei from hdp_ubu_wuxian_defaultdb.tb_app_action where dt >= 20160801 and dt <= 20160831group by imei)t;
    如果合理的设置reducer数量，将数据分散到更多机器上，效果会更好，不过这个设置需要队列有足够的资源，不了解的情况下不建议设置。
    另外由于数据量太大，这个sql运行的时间瓶颈在于map阶段，如果类似月活查询较多建议将每天的imei用类似方法去重单独存储用于计算月活

3. 空值产生的数据倾斜

::

    问题分析： 由于日志表数据记录不全，造成user_id信息缺失，join会造成数据倾斜
    那么在写sql时需要考虑user_is not null的情况单独处理


4. 不同数据类型关联产生数据倾斜

::
    这个网上看到，还没有实际碰到,待求证
    场景：用户表中user_id字段为int，log表中user_id字段既有string类型也有int类型。当按照user_id进行两个表的Join操作时，默认的Hash操作会按int型的id来进行分配，这样会导致所有string类型id的记录都分配到一个Reducer中。

    解决方法：把数字类型转换成字符串类型

    select * from users a
      left outer join logs b
      on a.usr_id = cast(b.user_id as string)

