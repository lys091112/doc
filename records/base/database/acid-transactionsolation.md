# 数据库事务四大特性以及隔离级别


### 四大特性（ACID）

* **原子性** (Atomicity)

   <p> 原子性是指事务包含的一些列操作，要不全部成功，要不回滚。重要的是如果操作失败，不会对数据库有任何影响

* **一致性**（Consistency)

    <p> 一致性是指数据库从一个一致性状态转移到另一个一致性状态。

    > 例如：转账， A和B两者钱加起来一共是500，那么进故宫一个事务后，他们的金额总和仍为500，事务不应该改变
    > 两者的金额总和这个状态。

* **隔离性** (Isolation)

   <p> 隔离性是指当多个用户并发访问数据库时，例如操作同一个表，那么数据库会为每个连接开启一个事务，且不会憋
    其他事务所干扰，多个事务之间相互隔离。

* **持久性**（Durability)

    <p> 持久性是指一个事务一旦提交了，那么对于数据库的改变是永久性的，即便数据库出现故障情况下一步会丢失
    已经提交的事务。

    > 例如: 我们提交一个事务，当数据库出现问题，那么操作提示说事务完成，那么即便数据库出现故障，一
    > 必须保证事务执行完成，否则会出现数据库提示事务完成，却因故障而没有执行事务。 也因此需要保证
    > 只有事务真正执行完成后，才给予提示说事务完成。


### 数据库隔离级别

* **脏读**

    <p> 脏读是指在一个事务里读取了另一个事务未提交的数据

    > 例如： 当一个事务在执行过程中多次修改某数据，但该事务还未提交，此时又另一个事务对该数据进行了
    > 修改，并进行提交，那么此时会造成两个事务得到的数据不一致问题。 如A行B转账100元，此时B进行读取
    > 数据库，发现转帐已经到账，但由于A事务没有进行事务提交，造成事务回滚，此时B再次进行查看时，发现
    > 转账并没有进行。
   
* **不可重复读**

    <p> 不可重复读是指：指在一个事务中，多次查询某数据却返回了不同的值。这是因为在事务过程中，该数据
    被另一个事务修改了。

    不可重复读和脏读的区别是：一个是读取了未提交的事务数据，一个是读取了已提交的事务数据，
    通常情况下，不可重复读没有任何问题，

* **幻读（虚读）**

    <p>  幻读是非独立事务执行时发生的一种现象，例如事务A修改数据库摸个数据项从a变为b，此时事务B新 插入一条数据，并把这个a提交给了数据库，那么事务A会发现有一个数据没有修改，这行是因为事务B的添加 造成的，而对于事务A就发生了欢读。 解决了不重复读，保证了同一个事务里，查询的结果都是事务开始时的状态（一致性）。但是，如果另一个事务同时提交了新数据，本事务再更新时，就会“惊奇的”发现了这些新数据，貌似之前读到的数据是“鬼影”一样的幻觉。在事务未提交时，是无法通过select来获取其他事务新增的数据，但是在我们进行操作时，会忽然发现有冲突或者我们结束事务后，忽然发信多出一条我们刚才没有处理的数据，就像幻觉一样

    幻读和不可重复读都是读取的另一条已经提交的事务，而脏读读取的事还没提交的事务，不可重复读是针对的一行数据，而幻读针对的是一批数据。

不可重复读和幻读的区别在于一个是修改或删除操作，一个是添加操作， 如果要避免不可重复读
，那么需要添加行级锁，是数据不会被更新，如果要避免幻读，那么需要添加表级锁

### mysql 默认的四种隔离级别

| 隔离级别|脏读|不可重复读|幻读|
|------|----|---|---|
|串行化（Serializable）|N|N|N|
|可重复读（Repeatable)(Default)|N|N|Y|
|读已提交（Read Commited）|N|Y|Y|
|读未提交（Read Uncommited）|Y|Y|Y|

**可重复读会发生幻读**：即可以保证在改事务执行过程中不会有其他事务进行修改，但无法
保证其他事务不对数据库进行增加。
**读已**: 提交保证读取到的数据都是已经提交的事务。

```
读未提交：一个事务可以读取到另一个事务未提交的修改。这会带来脏读，幻读，不可重复读问题

读已提交：一个事务只能读取另一个事务已经提交的修改。其避免了脏读，仍然存在不可以重复读和幻读问题

可重复读：同一个事务中多次读取相同的数据返回的结果是一样的。其避免了脏读和不可重复读问题，但是幻读依然存在

串行化：事务串行之行。避免了以上所有问题
```


//TODO
mysql数据库的一些基本命令，以及事务实例实现


## MVCC

MVCC的全称是多版本并发控制, 为了查询一些正在被另一个事务更新的行，并且可以看到它们被更新之前的值。这是一个用来增强并发性的强大技术，可以使得查询不用等待另一个事务释放锁

### CRUD

在InnoDB中，给每行增加两个隐藏字段来实现MVCC，一个用来记录数据行的创建时间，另一个用来记录行的过期时间。

在实际操作中，存储的并不是时间，而是事务版本号，每开启一个新事务，事务的版本号就会递增

```
select：
读取创建(create版本)版本小于或等于当前事务版本号，并且删除版本为空或大于当前事务版本的记录。这样可以保证在读取之前记录都是存在的

insert：
将当前事务的版本号保存至行的创建版本号

update
新插入一行，并以当前事务版本号作为新行的创建版本号，同时将原记录行的删除版本号设置为当前事务版本号

delete
将当前事务版本号保存至行的删除版本号

```

快照读和当前读

快照读：读取的是快照版本，也就是历史版本

当前读：读取的是最新版版

普通的 select 就是快照读，而 update，delete，insert，select...LOCK In SHARE MODE，SELECT...for update 就是当前读


### 一致性非锁定读和锁定读

#### 锁定读

在一个事务中，标准的SELECT语句是不会加锁, 但一下两种例外

```
SELECT ... LOCK IN SHARE MODE

SELECT ... FOR UPDATE
```

SELECT ... LOCK IN SHARE MODE：给记录假设共享锁，这样其他事务职能读不能修改，直到当前事务提交

SELECT ... FOR UPDATE：给索引记录加锁，这种情况跟UPDATE的加锁情况是一样的

UPDATE, DELETE操作也会添加锁

#### 一致性非锁定读

consistent read(一致性读)，InnoDB用多版本来提供查询数据库在某个时间点的快照。

如果隔离级别是REPEATABLE READ，那么在同一个事务中的所有一致性读都读的是事务中第一个的读读到的快照；如果是READ COMMITTED，那么一个事务中的每一个一致性读都会读到它自己(在这个事务内执行的操作，和其他事务没关联)刷新的快照版本。

consistent read（一致性读）是READ COMMITTED和REPEATABLE READ隔离级别下普通SELECT语句默认的模式。一致性读不会给它锁访问的表加任何形式的锁，因此其他事务可以同时并发的修改它们


#### 锁

Record Locks（记录锁）：在索引记录上加锁

Gap Locks（间隙锁）：在索引记录之间加锁，或者在第一个索引记录之前加锁，或者在最后一个索引记录之后加锁

Next-Key Locks：在索引记录上加锁，并且在索引记录之前的间隙加锁。相当于Record Locks与Gap Locks的一个结合


如果对一个唯一索引使用了唯一的检索条件，那么只需要锁定相应的索引记录就好；如果是没有使用唯一索引作为检索条件，或者用到了索引范围扫描，那么将会使用间隙锁或者next-key锁来以此阻塞其他会话向这个范围内的间隙插入数据

利用MVCC实现一致性非锁定读，保证在同一个事务中多次读取相同的数据返回的结果是一样的，解决了不可重复读问题.

利用Gap Locks和Next-key可以阻止其他事务在锁定区间内插入数据，解决了幻读问题.

MySQL的默认隔离级别的实现依赖于MVCC和锁，准确点说就是一致性读和锁


## 乐观锁， 悲观锁

乐观锁更适合解决冲突概率极小的情况；而悲观锁则适合解决并发竞争激烈的情况，尽量用行锁，缩小加锁粒度，以提高并发处理能力，即便加行锁的时间比加表锁的要长

悲观锁（Pessimistic Concurrency Control，PCC）：假定会发生并发冲突，屏蔽一切可能违反数据完整性的操作。至于怎么加锁，加锁的范围也没讲。

乐观锁（Optimistic Concurrency Control，OCC）：假设不会发生并发冲突，只在提交操作时检查是否违反数据完整性。也没具体指定怎么检查。

乐观锁不能解决脏读，加锁的时间要比悲观锁短（只是在执行sql时加了基本的锁保证隔离性级别），乐观锁可以用较大的锁粒度获得较好的并发访问性能。但是如果第二个用户恰好在第一个用户提交更改之前读取了该对象，那么当他完成了自己的更改进行提交时，数据库就会发现该对象已经变化了，这样，第二个用户不得不重新读取该对象并作出更改。