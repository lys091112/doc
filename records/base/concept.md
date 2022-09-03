# 一些开发中的名次含义

## 正则

NFA：非确定有限状态自动机或非确定有限自动机
```
是对每个状态和输入符号对可以有多个可能的下一个状态的有限状态自动机, j
```


DFA: 确定有限状态自动机
```
它的下一个可能状态是唯一确定的
```



AMQP:全称: Advanced Message Queueing Protocol,个提供统一消息服务的应用层标准高级消息队列协议,是应用层协议的一个开放标准,为面向消息的中间件设计。基于此协议的客户端与消息中间件可传递消息，并不受客户端/中间件不同产品，不同的开发语言等条件的限制, 主要有RabbitMQ



DDD CRUD


幂等性

## 程序员应该知道的一些数字（jeff dean)

+--------------------------------------------------------------------+----------------+
| L1 cache reference 读取CPU的一级缓存                               | 0.5 ns         |
| Branch mispredict(转移、分支预测)                                  | 5 ns           |
| L2 cache reference 读取CPU的二级缓存                               | 7 ns           |
| Mutex lock/unlock 互斥锁\解锁                                      | 100 ns         |
| Main memory reference 读取内存数据                                 | 100 ns         |
| Compress 1K bytes with Zippy 1k字节压缩                            | 10,000 ns      |
| Send 2K bytes over 1 Gbps network 在1Gbps的网络上发送2k字节        | 20,000 ns      |
| Read 1 MB sequentially from memory 从内存顺序读取1MB               | 250,000 ns     |
| Round trip within same datacenter 从一个数据中心往返一次，ping一下 | 500,000 ns     |
| Disk seek   磁盘搜索                                               | 10,000,000 ns  |
| Read 1 MB sequentially from network 从网络上顺序读取1兆的数据      | 10,000,000 ns  |
| Read 1 MB sequentially from disk 从磁盘里面读出1MB                 | 30,000,000 ns  |
| Send packet CA->Netherlands->CA 一个包的一次远程访问               | 150,000,000 ns |
+--------------------------------------------------------------------+----------------+
