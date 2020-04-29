.. highlight:: rst

.. _records_language_java_concurrent_threadpool:



Runtime.getRuntime().availableProcessors() 返回值很可能和你计算的值有出入，有时是物理cpu数，有时是逻辑cpu个数，所以使用该参数不一定靠谱

一般一个物理cpu可以有多个逻辑cpu组合而成。每个逻辑cpu都是一个单独的执行单元 


