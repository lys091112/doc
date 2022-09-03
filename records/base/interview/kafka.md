# kafka 

## 1. 消息的可靠性保证

消息的可靠性一般分为三块，发送端，存储端，消费端，任何一端出问题，都可能会造成数据的丢失

### 1.1 发送端

开启ack确认机制，保证每条数据都可以被发送成功

```
    ack=all  //要求每条数据，必须是写入所有 replica 之后，才能认为是写成功
    retries=xxx // 发送失败后的重试次数
```

### 1.2 存储端
kafka按照partition保存, 数据可以保存多个副本 , 副本中有一个副本是 Leader，其余的副本是 follower , follower会定期的同步leader的数据
要保证在leader挂了之后数据一致性 , 在Leader挂了，在新Leader上数据依然可以被客户端读到
这就要通过一个HighWater 机制 , 每个分区的 leader 会维护一个 ISR 列表 , ISR 列表里面就是 follower 副本的 Borker 编号, 只有跟得上 Leader 的 follower 副本才能加入到 ISR 里面, 只有所有ISR列表都同步的数据才能被comsumer读取 , High Water机制取决于 ISR 列表里面偏移量最小的分区

### 1.3 消费端

关闭offsert自动提交，保证消费成功后在手动提交消费成功信息
```
enable.auto.commit=false
```

## 2. 消息消费的顺序性

### 2.1 何种条件下会产生乱序

1. 一个topic，一个partition，一个consumer，但是consumer内部进行多线程消费，会出现顺序错乱问题。
2. 具有顺序的数据写入到了不同的partition里面，不同的消费者去消费，但是每个consumer的执行时间是不固定的，无法保证先读到消息的consumer一定先完成操作，这样就会出现消息并没有按照顺序执行，造成数据顺序错误. 需要调整分片函数，将有顺序性要求的数据打到同一个分片上

### 2.2 保证消息的消费顺序

1. 确保同一个消息发送到同一个partition，一个topic，一个partition，一个consumer，内部单线程消费
2. 写N个内存queue，然后N个线程分别消费一个内存queue即可

## 3. kafka 高效零拷贝
