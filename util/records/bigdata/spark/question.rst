.. highlight:: rst

学习过程中的疑问
------------------
.. toctree::
  :maxdepth: 2
  :glob:


1. 在一个任务中，如果DAG最后的froeach执行中，有一个需要和外部建立连接的操作，例如需要和mysql建立连接，因为saprkjob被分成很多task，那么mysql连接就会在每个task中被建立一次，有没有什么办法尽可能的共用连接信息

::
   将对数据库的连接放置到静态类中，这样就保证在一台机器上只会被初始话一次，即便在某台机器上，yigejob被分成多个task，但是他们还是在一个进程内，可以共用静态类 


2. 数据倾斜的解决办法

::

    1、避免shuffle，改reduce join为map join，适用于JOIN的时候有一个表是小表的情况，直接使用collect()获取小表的所有数据，然后brodcast，对大表进行MAP，MAP时直接提取broadcast的小表数据实现JOIN；

    2、随机数的方案，对于聚合类操作，可以分步骤进行聚合，第一步，在原来的KEY后面加上随机数（比如1~10），然后进行聚合（比如SUM操作）；第二步去掉KEY后面的随机数；第三部再次聚合（对应第一步的SUM），只适用于聚合类场景；

    3、HIVE预处理的方案，如果已经有数据倾斜，则用HIVE预处理，然后将结果加载到SPARK中进行使用，适用于SPARK会频繁使用但是HIVE只会预计算一次的场景，用于即席查询比较多；

    4、修改或者提升shuffle的并行度，使用repatition进行，比如原来每个节点处理10个KEY的数据，现在处理3个KEY的数据，虽然某些KEY仍然是热点，但是会缓解不少；

    5、过滤掉发生倾斜的KEY，场景较少，可以用采样、预计算的方式计算出KEY的数量分布，然后过滤掉最多的KEY的数据即可；

    6、分治法+空间浪费法，将A表中热点KEY的数据单独提取出来，对KEY加上随机前缀；然后将B表对应热点KEY的数据提取出来，重复加上所有的随机数KEY，然后这俩RDD关联，得到热点的结果RDD；对于A/B剩下的数据，按普通的进行JOIN，得到普通结果的RDD；然后将热点RDD和普通RDD进行UNION得到最终结果；

    7、完全空间浪费法，对A表所有数据的KEY加随机前缀，对B表所有KEY做重复加上所有的随机前缀，然后做关联得到结果；


3. ERROR ApplicationMaster: SparkContext did not initialize after waiting for 100000 ms. Please check earlier log output for errors. Failing the application

:: 

    解决方案：
        1.资源不能分配过大,或者没有把.setMaster(“local[*]”)去掉,
        2. 检查是否运行了spark初始化的程序，如果不小心被注释掉，也会报错

4. spark on hive 解决小文件过多的问题

::
    
    设置参数： config("spark.sql.shuffle.partitions", "1")
    或者
    xx.toDF().repartition(1).createOrReplaceTempView("examined")

    数量根据实际需要配置


5. 如何通过sql插入map类型数据

::
    
    可以使用str_to_map方法处理。例如：
    str_to_map("k1:v1&k2:v2", '&', ':') == {"k1":"v1","k2","v2"}

