# binlog


## 1. 主从同步过程

1、主节点必须启用二进制日志，记录任何修改了数据库数据的事件。
2、从节点开启一个线程（I/O Thread)把自己扮演成 mysql 的客户端，通过 mysql 协议，请求主节点的二进制日志文件中的事件
3、主节点启动一个线程（dump Thread），检查自己二进制日志中的事件，跟对方请求的位置对比，如果不带请求位置参数，则主节点就会从第一个日志文件中的第一个事件一个一个发送给从节点。
4、从节点接收到主节点发送过来的数据把它放置到中继日志（Relay log）文件中。并记录该次请求到主节点的具体哪一个二进制日志文件内部的哪一个位置（主节点中的二进制文件会有多个，在后面详细讲解）。
5、从节点启动另外一个线程（sql Thread ），把 Relay log 中的事件读取出来，并在本地再执行一次



[主从同步](https://blog.csdn.net/qq_37102984/article/details/117842450)
