.. highlight:: rst

.. _records_language_java_concurrent_threadpool:



Runtime.getRuntime().availableProcessors() 返回值很可能和你计算的值有出入，有时是物理cpu数，有时是逻辑cpu个数，所以使用该参数不一定靠谱

一般一个物理cpu可以有多个逻辑cpu组合而成。每个逻辑cpu都是一个单独的执行单元 


线程设置数量：

1. 线程数 = CPU 核心数 * (1 + IO 耗时/ CPU 耗时) 也可以翻译为： = cpu核心数 * (1 + 等待时间/计算时间)
   来源：java并发编程实战

2. 线程数 = CPU 核心数 / (1 - 阻塞系数)  其中计算密集型阻塞系数为 0，IO 密集型阻塞系数接近 1，一般认为在 0.8 ~ 0.9 之间。比如 8 核 CPU，按照公式就是 2 / ( 1 - 0.9 ) = 20 个线程数
   来源： Java虚拟机并发编程


