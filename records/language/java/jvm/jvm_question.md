# JVM

## 1. 常见概念

### 1.1 内存分配

java对象申请时，内存分配

   1. 对象默认都是从Eden区分配，但是遇到大对象会直接在Old区分配，此时不会进行YGC
   2. 这个大对象是指：大于PretenureSizeThreshold或者大于Eden
   3. 但是如果遇到待分配对象不是大对象，Eden区剩余空间不足，此时就会发生YGC
   4. PretenureSizeThreshold值只是判断条件之一还有其他条件，判断条件的顺序不重要，不会影响最终的YGC的触发
   5. 注意young GC中有部分存活对象会晋升到old gen,晋升周期默认为15次，所以young GC后old gen的占用量通常会有所升高

### 1.2 GC原理，性能调优

### 1.3 调优：Thread Dump， 分析内存结构

class 二进制字节码结构， class loader 体系 ， class加载过程 ， 实例创建过程 方法执行过程

Java各个大版本更新提供的新特性(需要简单了解)

## 2. 问题排查

### 2.1 常用排查工具

jstat:
jmap
jstack
jhat
arthas，mat

一、 java进程高负载问题排查

1. 执行top -c命令，找到cpu最高的进程的id
2. 使用top -H -p #{pid} 命令，查看当前java进程中的各线程的资源使用情况；
3. 找出负载高的线程，记录pid（26507）；
4. 使用printf "%x\n" 26507命令，将线程的pid（26507）转换为16进制字符串（678b）；
5. 在jstack -l pid 导出的java进程的堆栈信息中，查找字符串678b，即可定位负载高的线程的堆栈信息

二、 cpu高负载查询

``` txt

1. top -c 将系统资源使用情况实时显示出来, 随后输入 ``P`` 使按照cpu使用率排序,找到pid
2. top -Hp pid , 然后输入 P 依然可以按照 CPU 使用率将线程排序 ,得知使GC线程
3. jstat -gcutil pid 200 50 查看GC情况
4. jmap -dump:live,format=b,file=dump.hprof pid  使用MAT进行内存分析
```

三、 进程无故消息

``` txt
    1. 首先排查是否是因为内存超限，被系统进程杀掉 可以查看/var/log/message 来确认是否有进程被杀掉
        查看系统剩余内存，以及进程启动分配的堆内存大小，进行判断
```

### 2.2 常用命令

- jstat -gcutil 3353 2000 每隔2秒打印一次pid为3353的GC情况
- jmap -histo 3353 | head -100  用于查看进行的堆对象使用情况
- jmap -heap 3353 查看进程的内存使用情况
- top -H -p {pid} 查看当前运行的线程数量

### 2.3  一些常见错误

1. Can't attach to the process

    这是因为新版的Linux系统加入了 ptrace-scope 机制. 这种机制为了防止用户访问当前正在运行的进程的内存和状态, 而一些调试软件本身就是利用 ptrace 来进行获取某进程的内存状态的(包括GDB),所以在新版本的Linux系统, 默认情况下不允许再访问了. 可以临时开启. 如:echo 0 > /proc/sys/kernel/yama/ptrace_scope

    可以写入文件来持久化：
    vim /etc/sysctl.d/10-ptrace.conf

    添加或修改为以下这一句:(0:允许, 1:不允许)
    kernel.yama.ptrace_scope = 0
