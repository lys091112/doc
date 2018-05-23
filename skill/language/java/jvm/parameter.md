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



**CMS的常用参数**

-UseCMSInitatingOccupancyOnly: 只有达到阙值时，才进行CMS回收
-XX:CMSParallelRemarkEnabled 开启并行remark
-XX:CMSScanvengeBeforRemark 强制remark前，会开启一次minor gc
-XX:+ParallelCMSThreads CMS垃圾回收线程数，默认为：（ParallelGCThreads + 3)/4 
-XX:CMSInitatingPermOccupancyFraction: 当永久区占有率达到一定比例，进行垃圾回收（前提：-XX:CMSClassUnloadingEnabled)

-XX:+DisablExplicitGC 用来显示禁止System.gc()



GC collection

**Young Collection**
-XX:+UseSerialGC
-XX:+UseParallelGC
-XX:+UseParNewGC

** Old Collection**
-XX:+UseParallelOldGC
-XX:+UseConcMarkSweepGC
-XX:+UseG1GCv
```

GC 启动设置片段
```
java -server -Xms2g -Xmx4g 
-XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=35 -XX:+DisableExplicitGC -XX:+UseTLAB -XX:+ResizeTLAB 
-verbose:gc -Xloggc:/oneapm/local/alert-consumer/logs/gc.20180330_174630.log -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps 


-XX:+PrintHeapAtGC -XX:+PrintPromotionFailure -XX:+PrintClassHistogram -XX:+PrintTenuringDistribution -XX:+PrintGCApplicationStoppedTime -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=10M 


-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/oneapm/local/alert-consumer/logs -XX:ErrorFile=/oneapm/local/alert-consumer/logs/err.log

-Dfile.encoding=UTF-8 -Djava.awt.headless=true -Dsun.net.inetaddr.ttl=0 -Djava.net.preferIPv4Stack=true -Djava.security.egd=file:/dev/./urandom

```
