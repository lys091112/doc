.. highlight:: rst

.. _records_gitdata_spark_memory:

Spark的内存分布
---------------

spark默认使用堆内内存，主要分为四大块：

- Execution 内存：主要用于存放 Shuffle、Join、Sort、Aggregation 等计算过程中的临时数据
- Storage 内存：主要用于存储 spark 的 cache 数据，例如RDD的缓存、unroll数据；
- 用户内存（User Memory）：主要用于存储 RDD 转换操作所需要的数据，例如 RDD 依赖等信息。
- 预留内存（Reserved Memory）：系统预留内存，会用来存储Spark内部对象。

Execution 和Storage 可以相互借用内存


spark1.6开始，支持堆外内存，因此可以使用堆外内存。 因此总的使用内存等于堆内内存和堆外内存的总和
