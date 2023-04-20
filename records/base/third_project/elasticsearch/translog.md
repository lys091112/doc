# Translog 介绍

## 1. ES为什么需要有translog？
es是近实时的存储引擎（和搜索引擎）。所谓近实时，是指新增一条数据，或者修改一条数据，并不能保证被立刻看到。数据被看到的时候数据已经作为一个提交点，被写入到了文件系统中（这个过程称为refresh）。因为一次写入的成本相对比较大，所以用攒一波批量提交的方式，写入性能会更好。不管这些数据都是在堆内存中还是在文件系统中（Filesystem Cache），如果发生断电，或者JVM的崩溃，则这部分数据一定会丢失。为了防止数据丢失，这部分数据会被写入到traslog中一份。当然这个写入translog的代价远小于作为一个提交点写入到分片中（lucene实例中）的代价小。

所以trasnlog日志实际上是一个补偿机制。用来防止数据不丢失的。


写入时机：当有数据请求或修改时，就会写入translog

断电或其它故障，translog就会被使用。因为最后一个提交点，并没有被写到磁盘上（数据落到磁盘上的过程叫做flush），他可能还在内存中，也可能在文系统page cache上。此时可以从translog中拿到这份数据，回放。

而translog被清理，是当数据从文件系统上flush到磁盘上。此时这份translog已经失去了它的价值，所以理应被清理。这就好比方说，你请了一个雇佣兵，护送你从叙利亚回到中国。当你回到中国的目标实现了以后，雇佣兵也没有价值了，爱去哪里去哪里吧。


## 2. refresh和flush的区别是什么？
### 2.1 refresh
数据从堆内存进入到文件系统。此时数据从不可见到可以用来被搜索到。

执行条件：es每隔一秒钟执行一次refresh，可以通过参数index.refresh_interval来修改这个刷新间隔

触发动作：
  - 所有在内存缓冲区中的文档被写入到一个新的segment中,但是没有调用fsync,因此内存中的数据可能丢失
  - segment被打开使得里面的文档能够被搜索到
  - 清空内存缓冲区

### 2.2 flush
数据从文件系统到磁盘。此时数据不会丢失了，除非硬盘坏了

执行条件:
- index.translog.flush_threshold_ops,执行多少次操作后执行一次flush，默认无限制
- index.translog.flush_threshold_size，translog的大小超过这个参数后flush，默认512mb
- index.translog.flush_threshold_period,多长时间强制flush一次,默认30m
- index.translog.interval,es多久去检测一次translog是否满足flush条件
- 
- index.translog.sync_interval 控制translog多久fsync到磁盘,最小为100ms
- index.translog.durability translog是每5秒钟刷新一次还是每次请求都fsync，这个参数有2个取值:request(每次请求都执行fsync,es要等translog fsync到磁盘后才会返回成功)和async(默认值,translog每隔5秒钟fsync一次

触发动作：
  - 把所有在内存缓冲区中的文档写入到一个新的segment中
  - 清空内存缓冲区
  - 往磁盘里写入commit point信息
  - 文件系统的page cache(segments) fsync到磁盘
  - 删除旧的translog文件，因此此时内存中的segments已经写入到磁盘中,就不需要translog来保障数据安全了

flush是把内存中的数据(包括translog和segments)都刷到磁盘,而fsync只是把translog刷新的磁盘(确保数据不丢失), 在refresh时不会执行fsync

 

## 参考链接

1. [Translog](https://blog.csdn.net/star1210644725/article/details/123564559)
2. [Translog](https://www.cnblogs.com/huss2016/p/14706326.html)