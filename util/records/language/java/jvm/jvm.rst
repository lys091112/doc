.. _records_language_java_jvm_jvm:



常见概念
'''''''''''

::

     java对象申请时，内存分配
        1. 对象默认都是从Eden区分配，但是遇到大对象会直接在Old区分配，此时不会进行YGC
        2. 这个大对象是指：大于PretenureSizeThreshold或者大于Eden
        3. 但是如果遇到待分配对象不是大对象，Eden区剩余空间不足，此时就会发生YGC
        4. PretenureSizeThreshold值只是判断条件之一还有其他条件，判断条件的顺序不重要，不会影响最终的YGC的触发
        5. 注意young GC中有部分存活对象会晋升到old gen,晋升周期默认为15次，所以young GC后old gen的占用量通常会有所升高

JVM内存模型和结构
''''''''''''''''''


GC原理，性能调优
''''''''''''''''''''


调优：Thread Dump， 分析内存结构
''''''''''''''''''''''''''''''''


class 二进制字节码结构， class loader 体系 ， class加载过程 ， 实例创建过程 方法执行过程

Java各个大版本更新提供的新特性(需要简单了解)

