# 性能优化

### 1、调整数据库参数
（1） innodb_flush_log_at_trx_commit
默认为1，这是数据库的事务提交设置参数，可选值如下：
0: 日志缓冲每秒一次地被写到日志文件，并且对日志文件做到磁盘操作的刷新，但是在一个事务提交不做任何操作。
1：在每个事务提交时，日志缓冲被写到日志文件，对日志文件做到磁盘操作的刷新。
2：在每个提交，日志缓冲被写到文件，但不对日志文件做到磁盘操作的刷新。对日志文件每秒刷新一次。
有人会说如果改为不是1的值会不会不安全呢？ 安全性比较如下：
在 mysql 的手册中，为了确保事务的持久性和一致性，都是建议将这个参数设置为 1 。出厂默认值是 1，也是最安全的设置。
当innodb_flush_log_at_trx_commit和sync_binlog 都为 1 时是最安全的，在mysqld 服务崩溃或者服务器主机crash的情况下，binary log 只有可能丢失最多一个语句 或者一个事务。
但是这种情况下，会导致频繁的io操作，因此该模式也是最慢的一种方式。

当innodb_flush_log_at_trx_commit设置为0，mysqld进程的崩溃会导致上一秒钟所有事务数据的丢失。
当innodb_flush_log_at_trx_commit设置为2，只有在操作系统崩溃或者系统掉电的情况下，上一秒钟所有事务数据才可能丢失。

针对同一个表通过c#代码按照系统业务流程进行批量插入，性能比较如下所示：

（a.相同条件下：innodb_flush_log_at_trx_commit=0，插入50W行数据所花时间25.08秒;
（b.相同条件下：innodb_flush_log_at_trx_commit=1，插入50W行数据所花时间17分21.91秒;
（c.相同条件下：innodb_flush_log_at_trx_commit=2，插入50W行数据所花时间1分0.35秒。

结论：设置为0的情况下，数据写入是最快的，能迅速提升数据库的写入性能， 但有可能丢失上1秒的数据。
（2) temp_table_size,heap_table_size
这两个参数主要影响临时表temporary table 以及内存数据库引擎memory engine表的写入，设置太小，甚至会出现table is full的报错信息.
要根据实际业务情况设置大于需要写入的数据量占用空间大小才行。
（3) max_allowed_packet=256M,net_buffer_length=16M，set autocommit=0
备份和恢复时如果设置好这三个参数,可以让你的备份恢复速度飞起来哦！
（4) innodb_data_file_path=ibdata1:1G;ibdata2:64M:autoextend
很显然表空间后面的autoextend就是让表空间自动扩展，不够默认情况下只有10M，而在大批量数据写入的场景，不妨把这个参数调大；
让表空间增长时一次尽可能分配更多的表空间，避免在大批量写入时频繁的进行文件扩容
（5) innodb_log_file_size,innodb_log_files_in_group,innodb_log_buffer_size
设置事务日志的大小，日志组数，以及日志缓存。默认值很小，innodb_log_file_size默认值才几十M，innodb_log_files_in_group默认为2。
然而在innodb中，数据通常都是先写缓存，再写事务日志，再写入数据文件。设置太小，在大批量数据写入的场景，必然会导致频繁的触发数据库的检查点，去把 日志中的数据写入磁盘数据文件。频繁的刷新buffer以及切换日志，就会导致大批量写入数据性能的降低。
当然，也不宜设置过大。过大会导致数据库异常宕机时，数据库重启时会去读取日志中未写入数据文件的脏数据，进行redo，恢复数据库，太大就会导致恢复的时间变的更长。当恢复时间远远超出用户的预期接受的恢复时间，必然会引起用户的抱怨。
这方面的设置倒可以参考华为云的数据库默认设置,在华为云2核4G的环境，貌似默认配置的buffer:16M,log_file_size:1G----差不多按照mysql官方建议达到总内存的25%了；而日志组files_in_group则设置为4组。

2核4G这么低的硬件配置，由于参数设置的合理性，已经能抗住每秒数千次，每分钟8万多次的读写请求了。
而假如在写入数据量远大于读的场景，或者说方便随便改动参数的场景，可以针对大批量的数据导入，再做调整，把log_file_size调整的更大，可以达到innodb_buffer_pool_size的25%~100%。
（6) innodb_buffer_pool_size设置MySQL Innodb的可用缓存大小。理论上最大可以设置为服务器总内存的80%.
设置越大的值，当然比设置小的值的写入性能更好。比如上面的参数innodb_log_file_size就是参考innodb_buffer_pool_size的大小来设置的。
（7) innodb_thread_concurrency=16
故名思意，控制并发线程数，理论上线程数越多当然会写入越快。当然也不能设置过大官方建议是CPU核数的两倍左右最合适。
（8) write_buffer_size
控制单个会话单次写入的缓存大小，默认值4K左右，一般可以不用调整。然而在频繁大批量写入场景，可以尝试调整为2M，你会发现写入速度会有一定的提升。
（9) innodb_buffer_pool_instance
默认为1，主要设置内存缓冲池的个数，简单一点来说，是控制并发读写innodb_buffer_pool的个数。
在大批量写入的场景，同样可以调大该参数，也会带来显著的性能提升。
（10) bin_log
二进制日志，通常会记录数据库的所有增删改操作。然而在大量导数据，比如数据库还原的时候不妨临时关闭bin_log,关掉对二进制日志的写入，让数据只写入数据文件，迅速完成数据恢复，完了再开启吧。

### 2.减少磁盘IO，提高磁盘读写效率

包括如下方法：
（1)：数据库系统架构优化
a：做主从复制；
比如部署一个双主从，双主从模式部署是为了相互备份，能保证数据安全，不同的业务系统连接不同的数据库服务器，结合ngnix或者keepalive自动切换的功能实现负载均衡以及故障时自动切换。
通过这种架构优化，分散业务系统的并发读写IO从一台服务器到多台服务器，同样能提高单台数据库的写入速度。
b：做读写分离
和1中要考虑的问题一样，可以减轻单台服务器的磁盘IO，还可以把在服务器上的备份操作移到备服务器，减轻主服务器的IO压力，从而提升写入性能。
（2)：硬件优化
a: 在资源有限的情况下，安装部署的时候，操作系统中应有多个磁盘，把应用程序，数据库文件，日志文件等分散到不同的磁盘存储，减轻每个磁盘的IO，从而提升单个磁盘的写入性能。
b：采用固态硬盘SSD
如果资源足够可以采用SSD存储，SSD具有高速写入的特性，同样也能显著提升所有的磁盘IO操作。

### 3. 唯一索义插入冲突处理
### 3.1 insert ignore into
即插入数据时，如果数据存在，则忽略此次插入，前提条件是插入的数据字段设置了主键或唯一索引，测试SQL语句如下，当插入本条数据时，MySQL数据库会首先检索已有数据(也就是idx_username索引)，如果存在，则忽略本次插入，如果不存在，则正常插入数据
```sql
insert ignore into user(xxx) values ("ll")
```

### 3.2 on duplicate key update
即插入数据时，如果数据存在，则执行更新操作，前提条件同上，也是插入的数据字段设置了主键或唯一索引，测试SQL语句如下，当插入本条记录时，MySQL数据库会首先检索已有数据(idx_username索引)，如果存在，则执行update更新操作，如果不存在，则直接插入：
```sql
insert into user(xxx) values ("ll") on duplicate key update xxx='';
```

### 3.3 replace into
即插入数据时，如果数据存在，则删除再插入，前提条件同上，插入的数据字段需要设置主键或唯一索引，测试SQL语句如下，当插入本条记录时，MySQL数据库会首先检索已有数据(idx_username索引)，如果存在，则先删除旧数据，然后再插入，如果不存在，则直接插入：
```sql
replace into user(xxx) values ('11')
```

### 3.4 insert if not exists
即insert into … select … where not exist ... ，这种方式适合于插入的数据字段没有设置主键或唯一索引，当插入一条数据时，首先判断MySQL数据库中是否存在这条数据，如果不存在，则正常插入，如果存在，则忽略：
```sql
insert into user(xxx) value ("11") where not exist (select xxx from user where user="xx")
```


## 2. 表设计优化

### 2.1.数据库表结构中的 `text` 等大字段的设计
    
在设计数据库表结构时，如果使用的是大字段，那么需要考虑每一次的查询，是否一定会查询该大字段，如果不是每次都查询，那么建议将其移动到另一张表中
进行关联，原因如下：

在Innodb的模式中，查询的叶子节点的数据不是指向真实数据的指针，而是真实数据本身，如果text太大，那么由于每次索引加载查询的页大小为固定值（4K）
那么会造成每页所承载的数据量变少，从而降低查询的效率，因此可以将不经常使用的大字段放入到单独的关联表中

### 2.2 TIMESTAMP的使用

TIMESTAMP 是数据库用于记录时间的字段， 避免了datetime的2038问题。 

TIMESTAMP 的默认值为 DEFAULT CURRENT_TIMESTAMP 和 ON UPDATE CURRENT_TIMESTAMP, 
含义为： 当字段为空时，默认使用数据库当前时间， 以及在更新事件时会触发该字段事件修改

```
--查看sql_mode, 这个用来控制数据表创建时的确认检查
参考： <a href=http://blog.csdn.net/achuo/article/details/54618990 />
select @@sql_mode  

--创建测试表
CREATE TABLE `timestampTest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

```


## 参考链接

[mysql写入优化](https://juejin.cn/post/6913800194446327815?utm_source=gold_browser_extension)
