# mysql 锁(InnoDB)


## 1. 锁描述

### 1.1 锁模式
1，行锁（Record Locks）
行锁是作用在索引上的。

2，间隙锁（Gap Locks）
间隙锁是锁住一个区间的锁。
这个区间是一个开区间，范围是从某个存在的值向左直到比他小的第一个存在的值，所以间隙锁包含的内容就是在查询范围内，而又不存在的数据区间。
比如有id分别是1,10,20，要修改id<15的数据，那么生成的间隙锁有以下这些：(-∞,1)，(1,10)，(10,20)，此时若有其他事务想要插入id=11的数据，则需要等待。
间隙锁是不互斥的。

作用是防止其他事务在区间内添加记录，而本事务可以在区间内添加记录，从而防止幻读。
在可重复读这种隔离级别下会启用间隙锁，而在读未提交和读已提交两种隔离级别下，即使使用select ... in share mode或select ... for update，也不会有间隙锁，无法防止幻读。

3，临键锁（Next-key Locks）
临键锁=间隙锁+行锁，于是临键锁的区域是一个左开右闭的区间。
隔离级别是可重复读时，select ... in share mode或select ... for update会使用临键锁，防止幻读。普通select语句是快照读，不能防止幻读。

4，共享锁/排他锁（Shared and Exclusive Locks）
共享锁和排它锁都是行锁。共享锁用于事务并发读取，比如select ... in share mode。排它锁用于事务并发更新或删除。比如select ... for update

5，意向共享锁/意向排他锁（Intention Shared and Exclusive Locks）
意向共享锁和意向排他锁都是表级锁。
官方文档中说，事务获得共享锁前要先获得意向共享锁，获得排它锁前要先获得意向排它锁。
意向排它锁互相之间是兼容的。

6，插入意向锁（Insert Intention Locks）
插入意向锁锁的是一个点，是一种特殊的间隙锁，用于并发插入。
插入意向锁和间隙锁互斥。插入意向锁互相不互斥。

7，自增锁（Auto-inc Locks）
自增锁用于事务中插入自增字段。5.1版本前是表锁，5.1及以后版本是互斥轻量锁。

自增所相关的变量有：

auto_increment_offset，初始值
auto_increment_increment，每次增加的数量
innodb_autoinc_lock_mode，自增锁模式

其中：
innodb_autoinc_lock_mode=0，传统方式，每次都产生表锁。此为5.1版本前的默认配置。
innodb_autoinc_lock_mode=1，连续方式。产生轻量锁，申请到自增锁就将锁释放，simple insert会获得批量的锁，保证连续插入。此为5.2版本后的默认配置。
innodb_autoinc_lock_mode=2，交错锁定方式。不锁表，并发速度最快。但最终产生的序列号和执行的先后顺序可能不一致，也可能断裂。

### 1.2 锁粒度

### 1.3 加锁机制

### 1.4 兼容性

##  表锁，行锁， 乐观锁， 悲观锁

- **表锁**
```

```k


