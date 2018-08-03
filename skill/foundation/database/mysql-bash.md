# 数据库基础知识


### 1. mysql basic command

#### 1.1 Mysql 常用的基本命令

|命令语句| 描述|
|-------|-------|
|show variables like '%max_connections%'; |  mysql数据库链接数|
|show full processlist;  | 查询数据库的连接状态|                  
|show status like '%{param}%'| 根据变量名查询具体含义|

- **查询mysql锁等待情况**
```
 select * from information_schema.innodb_trx where trx_state="lock wait";
 或
 show engine innodb status;
```


**param** 代表的变量值

|变量名称| 含义|
|-------|----|
|Aborted_clients| 由于客户没有正确关闭连接已经死掉，已经放弃的连接数量。 |
|Aborted_connects| 尝试已经失败的mysql服务器的连接的次数。 |
|Connections| 试图连接MySQL服务器的次数。 |
|Created_tmp_tables| 当执行语句时，已经被创造了的隐含临时表的数量。 |
|Delayed_insert_threads| 正在使用的延迟插入处理器线程的数量。 |
|Delayed_writes| 用INSERT DELAYED写入的行数。 |
|Delayed_errors| 用INSERT DELAYED写入的发生某些错误(可能重复键值)的行数。 |
|Flush_commands| 执行FLUSH命令的次数。 |
|Handler_delete| 请求从一张表中删除行的次数。 |
|Handler_read_first| 请求读入表中第一行的次数。 |
|Handler_read_key| 请求数字基于键读行。 |
|Handler_read_next| 请求读入基于一个键的一行的次数。 |
|Handler_read_rnd| 请求读入基于一个固定位置的一行的次数。 |
|Handler_update| 请求更新表中一行的次数。 |
|Handler_write| 请求向表中插入一行的次数。 |
|Key_blocks_used| 用于关键字缓存的块的数量。 |
|Key_read_requests| 请求从缓存读入一个键值的次数。 |
|Key_reads| 从磁盘物理读入一个键值的次数。 |
|Key_write_requests| 请求将一个关键字块写入缓存次数。 |
|Key_writes| 将一个键值块物理写入磁盘的次数。 |
|Max_used_connections| 同时使用的连接的最大数目。 |
|Not_flushed_key_blocks| 在键缓存中已经改变但是还没被清空到磁盘上的键块。 |
|Not_flushed_delayed_rows| 在INSERT DELAY队列中等待写入的行的数量。 |
|Open_tables| 打开表的数量。 |
|Open_files| 打开文件的数量。 |
|Open_streams| 打开流的数量(主要用于日志记载） |
|Opened_tables| 已经打开的表的数量。 |
|Questions| 发往服务器的查询的数量。 |
|Slow_queries| 要花超过long_query_time时间的查询数量。 |
|Threads_connected| 当前打开的连接的数量。 |
|Threads_running| 不在睡眠的线程数量。 |
|Uptime| 服务器工作了多少秒。|


2. lock 相关参数 
```
show status like 'table%'

    Table_locks_immediate：产生表级锁定的次数；
    Table_locks_waited：出现表级锁定争用而发生等待的次数；

show status like 'InnoDB_row_lock%';

    InnoDB_row_lock_current_waits：当前正在等待锁定的数量；
    InnoDB_row_lock_time：从系统启动到现在锁定总时间长度；
    InnoDB_row_lock_time_avg：每次等待所花平均时间；
    InnoDB_row_lock_time_max：从系统启动到现在等待最常的一次所花的时间；
    InnoDB_row_lock_waits：系统启动后到现在总共等待的次数；


    #正在执行的事务
    SELECT * from information_schema.INNODB_TRX;
    #当前出现的锁等待
    SELECT * from information_schema.INNODB_LOCK_WAITS;
    #出现锁等待的锁的详细信息
    SELECT * from information_schema.INNODB_LOCKS;
    #查看全部线程，辅助定位客户端的主机ip，连接用户名等
    show full processlist;
    #如果活跃事务少，会显示当前活跃的事务详细信息，多的话只显示概要；最近一次死锁的信息
    show engine innodb status;
```

3. 查询修改mysql事务隔离级别
```
select @@tx_isolation
set global tx_isolation='REPEATABLE-READ';
set tx_isolation='READ-COMMITTED';
```

4. 查询数据库的死锁信息
```
show engine innodb status \G;
```


5. 锁冲突的表、数据行等，并分析锁争用的原因
```
create table InnoDB_monitor(a INT) engine=InnoDB;
show engine InnoDB status;
drop table InnoDB_monitor;
```
