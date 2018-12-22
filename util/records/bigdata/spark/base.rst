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


