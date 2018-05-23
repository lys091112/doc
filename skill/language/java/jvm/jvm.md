# jvm 基本命令介绍

1. **jstat**
```
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
 P：perm代已使用的占当前容量百分比         
 S0CMX：年轻代中第一个survivor（幸存区）的最大容量 (字节)         
 S1CMX ：年轻代中第二个survivor（幸存区）的最大容量 (字节)         
 ECMX：年轻代中Eden（伊甸园）的最大容量 (字节)         
 DSS：当前需要survivor（幸存区）的容量 (字节)（Eden区已满）         
 TT： 持有次数限制         
 MTT ： 最大持有次数限制
```

## 常用命令

* 查看JVM默认xss大小
```
java -XX:+PrintFlagsFinal -version | grep ThreadStackSize
```

* jstat 
```
jstat -gcnewcapacity pid  # 年轻代对象的信息及其占用量
jstat -gcnew pid  #查看新生代的对象信息
jstat -gcold pid  #查看老年代的对象信息
jstat -gcoldcapacity pid  # 老年代对象的信息及其占用量
jstat -class pid  # 加载的类数据及占用的空间信息

```

* jmap
```
    jmap -heap pid    # 整体堆信息
    jmap -histo pid   # 查看top10, 展示信息为编号，实例数，字节，类名
    jmap =histo:live
    jmap -dump:format=b,file=pid.bin pid

注意事项：
    jmap 所在的用户必须和目标进程的用户一致
    jmap 在线上环境禁止加 -F ， -F to force a thread dump. 
    jstack 不推荐使用
```

* jinfo
```
    jinfo -flags {pid}   # 打印传给jvm的参数值
```

## 常见概念

* java对象申请时，内存分配
```
    1. 对象默认都是从Eden区分配，但是遇到大对象会直接在Old区分配，此时不会进行YGC
    2. 这个大对象是指：大于PretenureSizeThreshold或者大于Eden
    3. 但是如果遇到待分配对象不是大对象，Eden区剩余空间不足，此时就会发生YGC
    4. PretenureSizeThreshold值只是判断条件之一还有其他条件，判断条件的顺序不重要，不会影响最终的YGC的触发
    5. 注意young GC中有部分存活对象会晋升到old gen,晋升周期默认为15次，所以young GC后old gen的占用量通常会有所升高
```

* YGC

```
    YGC整个过程都stw
```

