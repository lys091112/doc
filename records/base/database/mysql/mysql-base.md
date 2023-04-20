# mysql 日常使用

## 1. 基础命令

### 1.1. 基本命令

|命令语句| 描述|
|-------|-------|
|show variables like '%max_connections%'; |  mysql数据库链接数|
|show full processlist;  | 查询数据库的连接状态|                  
|show status like '%{param}%'| 根据变量名查询具体含义|

### 1.2. 数据库表字段修改
```
ALTER TABLE `alert_action` add COLUMN `tenant` varchar(4) NOT NULL DEFAULT "ai";


索引修改
ALTER TABLE `alert_policy` DROP INDEX i_application_name;
CREATE INDEX i_app_tenant_name ON `alert_policy` (`application_id`, `tenant`, `name`); 

## 修改并添加自增主键
ALTER TABLE `alert_application_switch` DROP PRIMARY KEY;
ALTER TABLE `alert_application_switch` ADD `id` BIGINT(32) NOT NULL first;
ALTER TABLE `alert_application_switch` CHANGE COLUMN `id` `id` BIGINT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY;
```

### 1.3 字符集相关基础命令

```sql

# 获取当前mysql的字符集
show variables like '%character%';
# 获取库下某表的字符集
show table status from db58_xfzx_rdktsandbox like '%agent%';
# 获取表列的字符集
show full columns from rdkt_customer;
# 获取当前mysql支持的所有字符集
show character set ;
# 修改数据库字符集
 alter database name character set utf8;
# 修改表字符集
alter table 表名 convert to character set gbk;
# 修改字段字符集
alter table 表名 modify column '字段名' varchar(30) character set gbk not null;
# 添加表字段字符集
alter table 表名 add column '字段名' varchar (20) character set gbk;

```

### 1.4. 查询修改mysql事务隔离级别

```sql
select @@tx_isolation
set global tx_isolation='REPEATABLE-READ';
set tx_isolation='READ-COMMITTED';
```

### 1.5. 锁相关

- 基础参数

``` sql
-- Table_locks_immediate：产生表级锁定的次数；
-- Table_locks_waited：出现表级锁定争用而发生等待的次数；
show status like 'table%'


-- InnoDB_row_lock_current_waits：当前正在等待锁定的数量；
-- InnoDB_row_lock_time：从系统启动到现在锁定总时间长度；
-- InnoDB_row_lock_time_avg：每次等待所花平均时间；
-- InnoDB_row_lock_time_max：从系统启动到现在等待最常的一次所花的时间；
-- InnoDB_row_lock_waits：系统启动后到现在总共等待的次数；
show status like 'InnoDB_row_lock%';


-- 正在执行的事务
SELECT * from information_schema.INNODB_TRX;
-- 当前出现的锁等待
SELECT * from information_schema.INNODB_LOCK_WAITS;
-- 出现锁等待的锁的详细信息
SELECT * from information_schema.INNODB_LOCKS;
-- 查看全部线程，辅助定位客户端的主机ip，连接用户名等
show full processlist;
-- 如果活跃事务少，会显示当前活跃的事务详细信息，多的话只显示概要；最近一次死锁的信息
show engine innodb status;
```

- 查询死锁信息
``` sql
show engine innodb status \G;
```
-  查询mysql锁等待情况
```
 select * from information_schema.innodb_trx where trx_state="lock wait";
 或
 show engine innodb status;
```
- **param** 代表的变量值

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

## 2. 常用功能

1. 日期处理

```sql

    -- add_date 类型为 timestamp

    -- 查询前一天的数据
    select * from test where to_days(add_date) = to_days(Now()) -1;

    -- 字符串处理查询
    select count(*) from test where substr(add_date,1,10) = '2019-04-04';

```
2. 特殊函数

```sql

    -- if 函数
    select key1,if(records like '%k2%',"成功","失败") from test 

    -- left(length), right(length) 截取作用指定长度的数据

```
3. limit 性能限制

limit10000,20的意思扫描满足条件的10020行，扔掉前面的10000行，返回最后的20行,所以当limit要跳过的数字很大时，这是一个很耗时的操作

优化方式：(基本是从查表到查索引)

 1 子查询
 ```sql
    select * from mytbl order by id limit 100000,10 
    -- 改进后的SQL语句如下：
    -- 假设id是主键索引，那么里层走的是索引，外层也是走的索引，所以性能大大提高
    select * from mytbl where id >= ( select id from mytbl order by id limit 100000,1 ) limit 10
 ```

 2 join 查询
 ```sql
    SELECT * FROM tableName ORDER BY id LIMIT 500000,2;
    -- 改变为
    SELECT *
    FROM tableName AS t1
    JOIN (SELECT id FROM tableName ORDER BY id desc LIMIT 500000, 1) AS t2
    WHERE t1.id <= t2.id ORDER BY t1.id desc LIMIT 2

 ```
  3 反向查找优化法
    当偏移超过一半记录数的时候，先用排序，这样偏移就反转了
    
## 3. mysql常见错误

### 3.1 查询超时
```sql

show global variables like "wait_timeout"; # 查询数据库最大超时时间
-- 查询mysql默认连接数和当前数据库的连接状态
show variables like '%max_connections%'
show full processlist; 
```

### 3.2 MySQL的Sleep进程占用大量连接解决方法

#### 3.1 产生原因
1. 由于mysql通常使用的是长连接方式，因而数据库连接不会在生命周期内不会释放，造成大量连接被暂用。 

2. 如果使用短连接方式，那么可能有一下记住原因：
    - Web服务器负荷过重，导致HTTP请求处理过慢，从而造成Sleep连接堆积
    - 逻辑处理过于复杂，处理耗时较长，如打开数据库连接后，会大量长时间的计算，导致数据不被释放，从而造成数据连接被占用，应尽可能合理优化逻辑，并建立超时机制，尽早释放不正常的处理

#### 3.2 解决方式

设置数据库wait_timeout数值大小，mysql数据库默认是28800（8小时），数值过大会造成mysql中有大量的数据连接无法释放，从而拖累系统性能，但也不能过于小，否则会遭遇到 "Mysql has gone away", (有类似与mysql_ping 的方式，告诉服务器连接的存活状态，以便于服务器重新计算wait_timeout时间)


### 3.3 com.mysql.jdbc.exceptions.jdbc4.CommunicationsException: Communications link failure

#### 3.3.1 产生原因
    当数据库重启或数据库空闲连接超过设置的最大timemout时间，数据库会强行断开已有的链接,这是由于 ``wait_timeout`` 设置过小导致

#### 3.3.2 解决方法
在配置数据库连接池的时候需要做一些检查连接有效性的配置，这里以Druid为例，相关配置如下（更多配置）：

| 字段名 | 默认值 | 说明 |
| ----------------------------- | ----------- | ---------------------------------------- |
| validationQuery | | 用来检测连接是否有效的sql，要求是一个查询语句，常用select 'x'。如果validationQuery为null，testOnBorrow、testOnReturn、testWhileIdle都不会起作用。 |
| validationQueryTimeout | | 单位：秒，检测连接是否有效的超时时间。底层调用jdbc Statement对象的void setQueryTimeout(int seconds)方法 |
| testOnBorrow | true | 申请连接时执行validationQuery检测连接是否有效，做了这个配置会降低性能。 |
| testOnReturn | false | 归还连接时执行validationQuery检测连接是否有效，做了这个配置会降低性能。 |
| testWhileIdle | false | 建议配置为true，不影响性能，并且保证安全性。申请连接的时候检测，如果空闲时间大于timeBetweenEvictionRunsMillis，执行validationQuery检测连接是否有效。 |
| timeBetweenEvictionRunsMillis | 1分钟（1.0.14） | 有两个含义：1) Destroy线程会检测连接的间隔时间，如果连接空闲时间大于等于minEvictableIdleTimeMillis则关闭物理连接。2) testWhileIdle的判断依据，详细看testWhileIdle属性的说明 |

为了避免空闲时间过长超过最大空闲时间而被断开，我们设置三个配置：
  - validationQuery: SELECT 1
  - testWhileIdle: true
  - timeBetweenEvictionRunsMillis: 28000

其中timeBetweenEvictionRunsMillis需要小于mysql的wait_timeout。

但是这种方法无法避免重启的情况，不过一般数据库不会频繁重启，影响不大，如果非得频繁重启，可以通过设置testOnBorrow，即申请连接的时候先试一试连接是否可用，不过带来的影响就是性能降低，需要根据实际需求合理取舍。


## 4. mysql 特性记录

mysql表里单行中的所有列加起来（不考虑其他隐藏列和记录头信息） ，占用的最大长度是65535(64K)个字节

- 现在的mysql数据表一般采用Dynamic行记录格式。它由行记录的额外信息和行记录的真实数据组成。
- mysql表里单行中的所有列加起来（不考虑其他隐藏列和记录头信息） ，占用的最大长度是65535个字节。
- 如果数据表里只有一列 not null 的varchar字段，它的最大长度，接近于 65535 除以 字符集的maxlen。
- 如果要存放大于64k的字段数据，可以考虑使用longtext和longblob等类型,查询的时候如果不用查询大文件字段，就不要写在sql里。
- mysql的数据页大小是16k，为了保存varchar或者text，blob这种长度可能大于16k的字段，在Dynamic行格式中，会只保留20个字节的指针，实际数据则放在其他溢出页中。为了将它们读取出来，会需要更多的磁盘IO。
- blob和text很像，但blob没有字符集的概念，并且还能存放二进制的数据，比如图片或视频，但实际上图片和视频更推荐放在对象存储（Object Storage Service，简称oss）中

参考：[mysql的varchar字段最大长度真的是65535吗](https://mp.weixin.qq.com/s/TC-c-d4DO8YnXNLeJjE58Q)
