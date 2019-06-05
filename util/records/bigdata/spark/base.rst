.. highlight:: rst
.. _records_bigdata_spark_base:

使用基础
^^^^^^^^^^

.. toctree::
  :maxdepth: 2
  :glob:

spark 的集中运行模式
-------------------------


spark on yarn
==================

在该模式下，不需要启动Spark集群，只需要启动Yarn即可，Yarn的ResourceManager就相对于Spark Standalone模式下的Master！
但需要提交任务的机器部署有spark程序可以运行spark-submit 进行任务提交

 Spark on Yarn的两种运行模式：

    1. Cluster：Spark运行在on Yarn上，没必要启动Spark集群，Master是ResourceManager
    2. Client：Driver运行在当前提交程序的客户机器上；

唯一的决定因素是当前Application从任务调度器Driver运行在什么地方！client 模式是因为spark Driver运行在该提交机器上，所以该提交机器不能停止运行，否则没有sparkDriver对任务进行监督控制


Spark的内存分布
================

spark默认使用堆内内存，主要分为四大块：

- Execution 内存：主要用于存放 Shuffle、Join、Sort、Aggregation 等计算过程中的临时数据
- Storage 内存：主要用于存储 spark 的 cache 数据，例如RDD的缓存、unroll数据；
- 用户内存（User Memory）：主要用于存储 RDD 转换操作所需要的数据，例如 RDD 依赖等信息。
- 预留内存（Reserved Memory）：系统预留内存，会用来存储Spark内部对象。

Execution 和Storage 可以相互借用内存


spark1.6开始，支持堆外内存，因此可以使用堆外内存。 因此总的使用内存等于堆内内存和堆外内存的总和
