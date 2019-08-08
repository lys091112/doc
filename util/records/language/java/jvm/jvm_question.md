# JVM 的一些问题


一、 java进程高负载问题排查

1. 执行top -c命令，找到cpu最高的进程的id
2. 使用top -H -p #{pid} 命令，查看当前java进程中的各线程的资源使用情况；
3. 找出负载高的线程，记录pid（26507）；
4. 使用printf "%x\n" 26507命令，将线程的pid（26507）转换为16进制字符串（678b）；
5. 在jstack -l pid 导出的java进程的堆栈信息中，查找字符串678b，即可定位负载高的线程的堆栈信息

二、 cpu高负载查询

```

1. top -c 将系统资源使用情况实时显示出来, 随后输入 ``P`` 使按照cpu使用率排序,找到pid
2. top -Hp pid , 然后输入 P 依然可以按照 CPU 使用率将线程排序 ,得知使GC线程

3.  jstat -gcutil pid 200 50 查看GC情况

4. jmap -dump:live,format=b,file=dump.hprof pid  使用MAT进行内存分析



```


jstat -gcutil 3353 2000 每隔2秒打印一次pid为3353的GC情况
jmap -histo 3353 | head -100  用于查看进行的堆对象使用情况
jmap -heap 3353 查看进程的内存使用情况

top -H -p {pid} 查看当前运行的线程数量

ERROR: 
1. Can't attach to the process

    这是因为新版的Linux系统加入了 ptrace-scope 机制. 这种机制为了防止用户访问当前正在运行的进程的内存和状态, 而一些调试软件本身就是利用 ptrace 来进行获取某进程的内存状态的(包括GDB),所以在新版本的Linux系统, 默认情况下不允许再访问了. 可以临时开启. 如:echo 0 > /proc/sys/kernel/yama/ptrace_scope

    可以写入文件来持久化：
    vim /etc/sysctl.d/10-ptrace.conf

    添加或修改为以下这一句:(0:允许, 1:不允许)
    kernel.yama.ptrace_scope = 0


