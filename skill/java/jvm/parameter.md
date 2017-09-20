# JVM 变量参数


### JVM 基本参数值和含义

```
-Xmx: 最大堆内存
-Xms: 堆内存初始值
-Xmn: 新生代的大小
-Xss: 线程栈大小
-PretenureSizeThreshold: 直接晋升老年代的对象大小
-MaxTenuringThrehold: j晋升到老年代的对象年龄
-MaxAdaptiveSizePolicy: 自动调整新生代中eden， survivor的比例
-Survivor: Eden 和 survivor区域的容量比值
-XX:ParallelGCThreads 新生代垃圾回收的数量
-XX:GCTimeRatio: 设置吞吐量大小0-100之间， 如果GCTimeRatio值为n，那么系统的花费时间不超过1/（1+n) 用于垃圾回收
-XX:MaxGCPauseMills 垃圾回收的停顿时间，设置后，收集器会调整java堆大小或其他一下参数，保证停顿时间尽可能控制在maxgcpausemills以内，但不是必须
-XX:MaxJavaStackTraceDepth=1024  # JVM打印的栈深度，默热1024, 如果是-1,表明全部打印
-XX:ThreadStackSize or -Xss      # JVM 中java_thread 栈大小
-XX:CompilerThreadStackSize      # compiler_thread的stack_size
-XX:VMThreadStackSize            # vm内部的线程比如gc线程等
-XX:+PrintGCDetails              # 打印GC日志
-XX:+PrintGCTimeStamps           # 打印GC时间戳
```
