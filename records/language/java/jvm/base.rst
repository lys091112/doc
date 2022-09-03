.. _records_language_java_jvm_paramter:

JVM 变量参数
==============


JVM 基本参数值和含义
::::::::::::::::::::::::::::::

::

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
    -XX:-OmitStackTraceInFastThrow   # 不设置该参数的话， 非热点内置异常。如果异常被抛出数次，就变成”hot“了，这时就会丢失异常信息,如null指针异常丢失，因为这时的异常是预先分配的。通常启动jvm是需要添加该参数
    -XX:+HeapDumpOnOutOfMemoryError  # 让JVM碰到OOM的时候，输出dump信息。
    -XX:PretenureSizeThreshold   #用于将指定大小的对象直接分配到老年代，避过新生代


    **CMS的常用参数**

    -XX:+UseCMSInitatingOccupancyOnly: 只有达到阙值时，才进行CMS回收
    -XX:CMSInitiatingOccupancyFraction=70 CMS垃圾收集器，当老年代达到70%时，触发CMS垃圾回收
    -XX:CMSParallelRemarkEnabled 开启并行remark
    -XX:+ParallelCMSThreads CMS垃圾回收线程数，默认为：（ParallelGCThreads + 3)/4 
    -XX:CMSInitatingPermOccupancyFraction: 当永久区占有率达到一定比例，进行垃圾回收（前提：-XX:CMSClassUnloadingEnabled)

    -XX:CMSScanvengeBeforRemark 
        > 强制remark前，会开启一次minor gc
        > 可在一定程度上降低CMS重新标记阶段对上述“又发生变化”对象的扫描时间, 但不保证一定会执行
        > 但是也因为增加了一次ygc(STW)， 而造成性能消耗

    -XX:+DisablExplicitGC 用来显示禁止System.gc()


    **GC collection** 

    **Young Collection**
    -XX:+UseSerialGC
    -XX:+UseParallelGC
    -XX:+UseParNewGC

    ** Old Collection**
    -XX:+UseParallelOldGC
    -XX:+UseConcMarkSweepGC
    -XX:+UseG1GCv

GC 启动设置片段
:::::::::::::::::::::

::


    java -server -Xms2g -Xmx4g 
    -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=35 -XX:+DisableExplicitGC -XX:+UseTLAB -XX:+ResizeTLAB 
    -verbose:gc -Xloggc:/oneapm/local/alert-consumer/logs/gc.20180330_174630.log -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps 
    -XX:+PrintHeapAtGC -XX:+PrintPromotionFailure -XX:+PrintClassHistogram -XX:+PrintTenuringDistribution -XX:+PrintGCApplicationStoppedTime -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=10M 

    -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/oneapm/local/alert-consumer/logs -XX:ErrorFile=/oneapm/local/alert-consumer/logs/err.log

    -Dfile.encoding=UTF-8 -Djava.awt.headless=true -Dsun.net.inetaddr.ttl=0 -Djava.net.preferIPv4Stack=true -Djava.security.egd=file:/dev/./urandom



工具
::::::::::::::

jstat
'''''''''
::

    Usage: jstat -help|-options
           jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]

    Example: jstat -gcutil pid 2000 //每两秒打印一次gc情况
    S0C、S1C、S0U、S1U：Survivor 0/1区容量（Capacity）和使用量（Used）
    EC、EU：Eden区容量和使用量
    OC、OU：年老代容量和使用量
    PC、PU：永久代容量和使用量
    YGC、YGT：年轻代GC次数和GC耗时
    FGC、FGCT：Full GC次数和Full GC耗时

    显示内容说明如下
    S0C：年轻代中第一个survivor（幸存区）的容量 (字节)         
    S1C：年轻代中第二个survivor（幸存区）的容量 (字节)         
    S0U：年轻代中第一个survivor（幸存区）目前已使用空间 (字节)         
    S1U：年轻代中第二个survivor（幸存区）目前已使用空间 (字节)         
    EC：年轻代中Eden（伊甸园）的容量 (字节)         
    EU：年轻代中Eden（伊甸园）目前已使用空间 (字节)         
    OC：Old代的容量 (字节)         
    OU：Old代目前已使用空间 (字节)         
    PC：Perm(持久代)的容量 (字节)         
    PU：Perm(持久代)目前已使用空间 (字节)         
    YGC：从应用程序启动到采样时年轻代中gc次数         
    YGCT：从应用程序启动到采样时年轻代中gc所用时间(s)         
    FGC：从应用程序启动到采样时old代(全gc)gc次数         
    FGCT：从应用程序启动到采样时old代(全gc)gc所用时间(s)         
    GCT：从应用程序启动到采样时gc用的总时间(s)         
    NGCMN：年轻代(young)中初始化(最小)的大小 (字节)         
    NGCMX：年轻代(young)的最大容量 (字节)         
    NGC：年轻代(young)中当前的容量 (字节)         
    OGCMN：old代中初始化(最小)的大小 (字节)         
    OGCMX：old代的最大容量 (字节)         
    OGC：old代当前新生成的容量 (字节)         
    PGCMN：perm代中初始化(最小)的大小 (字节)         
    PGCMX：perm代的最大容量 (字节)           
    PGC：perm代当前新生成的容量 (字节)         
    S0：年轻代中第一个survivor（幸存区）已使用的占当前容量百分比         
    S1：年轻代中第二个survivor（幸存区）已使用的占当前容量百分比         
    E：年轻代中Eden（伊甸园）已使用的占当前容量百分比         
    O：old代已使用的占当前容量百分比         
    P(M)：perm代已使用的占当前容量百分比         
    S0CMX：年轻代中第一个survivor（幸存区）的最大容量 (字节)         
    S1CMX ：年轻代中第二个survivor（幸存区）的最大容量 (字节)         
    ECMX：年轻代中Eden（伊甸园）的最大容量 (字节)         
    DSS：当前需要survivor（幸存区）的容量 (字节)（Eden区已满）         
    TT： 持有次数限制         
    MTT ： 最大持有次数限制

JMap
''''''''''''
::

    jmap -heap pid

    Attaching to process ID 3764, please wait...
    Debugger attached successfully.
    Server compiler detected.
    JVM version is 25.171-b11

    using thread-local object allocation.
    Parallel GC with 8 thread(s) //采用Parallel GC

    Heap Configuration:
       MinHeapFreeRatio         = 0    //JVM最小空闲比率 可由-XX:MinHeapFreeRatio=<n>参数设置， jvm heap 在使用率小于 n 时 ,heap 进行收缩
       MaxHeapFreeRatio         = 100  //JVM最大空闲比率 可由-XX:MaxHeapFreeRatio=<n>参数设置， jvm heap 在使用率大于 n 时 ,heap 进行扩张 
       MaxHeapSize              = 2095054848 (1998.0MB) //JVM堆的最大大小 可由-XX:MaxHeapSize=<n>参数设置
       NewSize                  = 44040192 (42.0MB) //JVM新生代的默认大小 可由-XX:NewSize=<n>参数设置
       MaxNewSize               = 698351616 (666.0MB) //JVM新生代的最大大小 可由-XX:MaxNewSize=<n>参数设置
       OldSize                  = 88080384 (84.0MB) //JVM老生代的默认大小 可由-XX:OldSize=<n>参数设置 
       NewRatio                 = 2 //新生代：老生代（的大小）=1:2 可由-XX:NewRatio=<n>参数指定New Generation与Old Generation heap size的比例。
       SurvivorRatio            = 8 //survivor:eden = 1:8,即survivor space是新生代大小的1/(8+2)[因为有两个survivor区域] 可由-XX:SurvivorRatio=<n>参数设置
       MetaspaceSize            = 21807104 (20.796875MB) //元空间的默认大小，超过此值就会触发Full GC 可由-XX:MetaspaceSize=<n>参数设置
       CompressedClassSpaceSize = 1073741824 (1024.0MB) //类指针压缩空间的默认大小 可由-XX:CompressedClassSpaceSize=<n>参数设置
       MaxMetaspaceSize         = 17592186044415 MB //元空间的最大大小 可由-XX:MaxMetaspaceSize=<n>参数设置
       G1HeapRegionSize         = 0 (0.0MB) //使用G1垃圾收集器的时候，堆被分割的大小 可由-XX:G1HeapRegionSize=<n>参数设置

    Heap Usage:
    PS Young Generation //新生代区域分配情况
    Eden Space: //Eden区域分配情况
       capacity = 89653248 (85.5MB)
       used     = 8946488 (8.532035827636719MB)
       free     = 80706760 (76.96796417236328MB)
       9.978989272089729% used
    From Space: //其中一个Survivor区域分配情况
       capacity = 42467328 (40.5MB)
       used     = 15497496 (14.779563903808594MB)
       free     = 26969832 (25.720436096191406MB)
       36.49275037977431% used
    To Space:  //另一个Survivor区域分配情况
       capacity = 42991616 (41.0MB)
       used     = 0 (0.0MB)
       free     = 42991616 (41.0MB)
       0.0% used
    PS Old Generation //老生代区域分配情况
       capacity = 154664960 (147.5MB)
       used     = 98556712 (93.99100494384766MB)
       free     = 56108248 (53.508995056152344MB)
       63.722715216167906% used

    1819 interned Strings occupying 163384 bytes

查看JVM默认xss大小
'''''''''''''''''''''

::

    java -XX:+PrintFlagsFinal -version | grep ThreadStackSize


jstat常用基础命令
'''''''''''''''''''
::

    jstat -gcnewcapacity pid  # 年轻代对象的信息及其占用量
    jstat -gcnew pid  #查看新生代的对象信息
    jstat -gcold pid  #查看老年代的对象信息
    jstat -gcoldcapacity pid  # 老年代对象的信息及其占用量
    jstat -class pid  # 加载的类数据及占用的空间信息
    jstat  -gcutil  pid 1000 每隔一秒钟，打印一次GC情况

jmap常用命令
'''''''''''''''

::

    jmap -heap pid    # 整体堆信息
    jmap -histo pid   # 查看top10, 展示信息为编号，实例数，字节，类名
    jmap =histo:live
    jmap -dump:format=b,file=pid.bin pid

    注意事项：
        jmap 所在的用户必须和目标进程的用户一致
        jmap 在线上环境禁止加 -F ， -F to force a thread dump. 
    jstack 不推荐使用

jinfo 常用命令
''''''''''''''''

::

    jinfo -flags {pid}   # 打印传给jvm的参数值

parameters
''''''''''''''''''

1. 查看CompressedClassSpace的几种方式

    - jcmd pid GC.heap_info(Metaspace为总的部分，包含了class space，而Metaspace area (excluding the Compressed Class Space)需要自己计算即total-class space)

    - jcmd pid VM.native_memory(class为总的部分，包含了Metaspace area (excluding the Compressed Class Space)及Class Space)

    - 使用JMX来获取NON_HEAP类型中的name为Metaspace及Compressed Class Space的MemoryPoolMXBean可以得到Metaspace及Compressed Class Space的使用情况(JMX得到的Metaspace为总的部分，而Metaspace area (excluding the Compressed Class Space)需要自己计算即total-class space)



