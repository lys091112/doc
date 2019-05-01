# 参数示例


# Jmap 的使用

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

    ---------------------
