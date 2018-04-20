# Redis

1. redis and memcached区别比较
    - Redis不仅仅支持简单的k/v类型的数据，同时还提供list，set，zset，hash等数据结构的存储。memcache支持简单的数据类型，String。
    - Redis支持数据的备份，即master-slave模式的数据备份。
    - Redis支持数据的持久化，可以将内存中的数据保持在磁盘中，重启的时候可以再次加载进行使用,而Memecache把数据全部存在内存之中
    - redis的速度比memcached快很多
    - Memcached是多线程，非阻塞IO复用的网络模型；Redis使用单线程的IO复用模型

    终极策略： 使用Redis的String类型做的事，都可以用Memcached替换，以此换取更好的性能提升； 除此以外，优先考虑Redis
    - 速度快，因为数据存在内存中，类似于HashMap，HashMap的优势就是查找和操作的时间复杂度都是O(1)
    - 支持丰富数据类型，支持string，list，set，sorted set，hash
    - 支持事务，操作都是原子性，所谓的原子性就是对数据的更改要么全部执行，要么全部不执行
    - 丰富的特性：可用于缓存，消息，按key设置过期时间，过期后将会自动删除

2. redis 数据淘汰策略

    - volatile-lru：从已设置过期时间的数据集（server.db[i].expires）中挑选最近最少使用的数据淘汰
    - volatile-ttl：从已设置过期时间的数据集（server.db[i].expires）中挑选将要过期的数据淘汰
    - volatile-random：从已设置过期时间的数据集（server.db[i].expires）中任意选择数据淘汰
    - allkeys-lru：从数据集（server.db[i].dict）中挑选最近最少使用的数据淘汰
    - allkeys-random：从数据集（server.db[i].dict）中任意选择数据淘汰
    - no-enviction（驱逐）：禁止驱逐数据

3. Reis 如何保证并发的安全
    Redis为单进程单线程模式，采用队列模式将并发访问变为串行访问，但是客户端的访问无法控制，并发访问是造成数据混乱。解决方式：
    - 客户端角度，为保证每个客户端间正常有序与Redis进行通信，对连接进行池化，同时对客户端读写Redis操作采用内部锁synchronized
    - 服务器角度，利用setnx实现锁
    

4. Redis 大量数据插入

    - (cat data.txt; sleep 10) | nc localhost 6379 > /dev/null 这种方式不可靠，在大量插入时无法检查错误
    - redis 2.6 之后的新模式pipe模式：cat data.txt | redis-cli --pipe 这里需要主要的是参考redis协议说明（协议说
   

5. Redis常见性能问题和解决方案:

    - Master最好不要做任何持久化工作，如RDB内存快照和AOF日志文件
    - 如果数据比较重要，某个Slave开启AOF备份数据，策略设置为每秒同步一次
    - 为了主从复制的速度和连接的稳定性，Master和Slave最好在同一个局域网内
    - 尽量避免在压力很大的主库上增加从库

6. redis 集群数据的分配以及投票选举机制

    - Redis 集群中内置了 16384个哈希槽，当需要在 Redis 集群中放置一个 key-value 时，redis 先对 key 使用 crc16 算法算出一个结果，然后把结果对 16384 求余数，这样每个 key 都会对应一个编号在 0-16383 之间的哈希槽，redis 会根据节点数量大致均等的将哈希槽映射到不同的节点。

    - 集群投票机制： redis集群中有多台redis服务器不可避免会有服务器挂掉。redis集群服务器之间通过互相的ping-pong判断是否节点可以连接上。如果有一半以上的节点去ping一个节点的时候没有回应，集群就认为这个节点宕机了。使用gossip相互传递信息


