# 存储相关

## 高效的key-Value存储

    常见的kv存储又： levelDB，RocksDB, InnoDb, TiDB
    RocksDB在levelDB的基础上进行开发
    TiDB的底层存储又使用的是RocksDB


## Mysql

1. select ... for update

    ```
    排他锁的申请前提：没有线程对该结果集中的任何行数据使用排他锁或共享锁，否则申请会阻塞。

    for update仅适用于InnoDB，且必须在事务块(BEGIN/COMMIT)中才能生效。
    在进行事务操作时，通过“for update”语句，MySQL会对查询结果集中每行数据都添加排他锁，其他线程对该记录的更新与删除操作都会阻塞。排他锁包含行锁、表锁
    ```
2. select ... for update 是row lock or table lock

    ```
    1. 明确主键，并且有数据，则为row lock
    2. 明确主键，但是无数据，则no lock
    3. 无主键，但是有数据， 则为table lock
    4. 主键不明确，例如使用了id <> 3 or id like '%3',则为table lock
    ```
3. Mysql 锁分类和作用
    - Innodb的锁模式实际可以分为四种： 排他锁(x),共享锁(S), 意向排他锁(IX), 意向共享锁(IS)

        ```
        对于表锁：
        LOCK TABLE my_tabl_name READ;  用读锁锁表，会阻塞其他事务修改表数据。
        LOCK TABLE my_table_name WRITe; 用写锁锁表，会阻塞其他事务读和写

        对于行锁：
        共享锁，一个事务对一行的共享只读锁。
        排它锁，一个事务对一行的排他读写锁。

        例子如下：
        事务A锁住了表中的一行，让这一行只能读，不能写。 之后，事务B申请整个表的写锁。
        但读锁和写锁是有冲突的，那么如何判断当前表中的锁申请有冲突呢
        1. 判断表中的每一行是否有被行锁锁住
        2. 判断表是否已经被其他事务用表锁锁住

        使用方式1很明显是不合理的，性能消耗太严重，因此有了意向锁。
        当事务申请行锁时，首先向表申请意向锁，然后在申请行锁
        当申请的是表锁时，因为本身就是表锁，因此无需意向锁来表示该表的锁情况

        IS，IX 意向锁是表级的锁，

        如果一个事务请求的锁模式与当前的锁兼容，InnoDB就将请求的锁授予该事务；反之，如果两者不兼容，该事务就要等待锁释放。
        意向锁是InnoDB自动加的，不需用户干预。对于UPDATE、DELETE和INSERT语句，InnoDB会自动给涉及数据集加排他锁（X)；对于普通SELECT语句，InnoDB不会加任何锁；事务可以通过以下语句显示给记录集加共享锁或排他锁。
        共享锁（S）：SELECT * FROM table_name WHERE ... LOCK IN SHARE MODE
        排他锁（X)：SELECT * FROM table_name WHERE ... FOR UPDATE
        ```

    - 间隙锁
        锁加在不存在的空闲空间，可以是两个索引记录之间，也可能是第一个索引记录之前或最后一个索引之后的空间,主要作用是在RR模式下，可以防止幻读, 通过修改隔离级别为读已提交来避免死锁
        ```
        间隙锁的出现主要集中在同一个事务中先delete后 insert的情况下， 当我们通过一个参数去删除一条记录的时候， 
        如果参数在数据库中存在，那么这个时候产生的是普通行锁，锁住这个记录， 然后删除， 然后释放锁。如果这条记录不存在，
        问题就来了， 数据库会扫描索引，发现这个记录不存在， 这个时候的delete语句获取到的就是一个间隙锁，
        然后数据库会向左扫描扫到第一个比给定参数小的值，向右扫描扫描到第一个比给定参数大的值， 然后以此为界，
        构建一个区间， 锁住整个区间内的数据， 一个特别容易出现死锁的间隙锁诞生了

            表数据：
            Id           taskId
            1              2
            3              9
            10            20
            40            41

            taskId是一个普通索引列

            开启一个会话： session 1
            sql> set autocommit=0; ## 取消自动提交 
            sql> delete from task_queue where taskId = 20;(数据存在)
            sql> insert into task_queue values(20, 20);

            在开启一个会话： session 2
            sql> set autocommit=0; ## 取消自动提交
            sql> delete from task_queue where taskId = 25;(数据不存在)
            sql> insert into task_queue values(30, 25);

            并发情况下，执行顺序可能为
            sql> delete from task_queue where taskId = 20;
            sql> delete from task_queue where taskId = 25;
            sql> insert into task_queue values(20, 20);
            sql> insert into task_queue values(30, 25);

            此时session 1 会形成20 到 41之间的间隙锁, session 2 也会造成20-40之间的间隙锁,造成了随后的死锁。

            ??猜测mysql解决方法，将其中一个事务的锁升级为写锁，然后另一个事务进入等待阶段

        间隙锁的产生：在事务中进行delete操作时会产生间隙锁(操作的时普通索引而非唯一索引或主键)， 在用select .. for update进行范围查询时，会产生间隙锁, 

        因此为了防止间隙锁的干扰，一，可以调整事务级别，由RR改为RC。
        或者对于修改操作尽可能使用唯一索引或者主键索引，对于查询，尽可能使用相等条件查询(需要注意的是如果使用相等条件查询，但记录不存在，也会产生间隙锁)
        
        ```

4. mysql 死锁以及如何避免

    * 如果一个事务select ... in share mode获得共享锁，但是如果当前事务也需要对该记录进行更新操作，那么很容易产生死锁。 因此对于锁定记录后需要进行更新的操作，应当使用select .. for update 获得 排他锁, 即一次性申请足够的锁
    ```
        T1:
        begin tran
        select * from table (share lock) 
        update table set column1='hello'

        T2:
        begin tran
        select * from table(share lock)
        update table set column1='world'

        假设T1和T2同时达到select，T1对table加共享锁，T2也对加共享锁，当
        T1的select执行完，准备执行update时，根据锁机制，T1的共享锁需要升
        级到排他锁才能执行接下来的update.在升级排他锁前，必须等table上的
        其它共享锁释放，但因为sharelock这样的共享锁只有等事务结束后才释放，
        所以因为T2的共享锁不释放而导致T1等(等T2释放共享锁，自己好升级成排
        他锁），同理，也因为T1的共享锁不释放而导致T2等。死锁产生了。
    ```

    * 多个不同的应用程序并发存取多个表时，保证每个线程按照固定的顺序申请表资源，可降低死锁概率
    * 在程序以批量方式处理数据的时候，如果事先对数据排序，保证每个线程按固定的顺序来处理记录，也可以大大降低出现死锁的可能

    * 在 repeatable-read模式下，如果两个线程同时使用select .. for update 加排他锁，如果资源不存在，那么都会加锁成功，记录不存在，试图添加一条记录，如果两个线程都这么做，那么会产生死锁，这种情况下可以将事务级别改为repeatable-commit，避免死锁问题
    
    * 当隔离级别为READ COMMITTED时，如果两个线程都先执行SELECT...FOR UPDATE，判断是否存在符合条件的记录，如果没有，就插入记录。此时，只有一个线程能插入成功，另一个线程会出现锁等待，当第1个线程提交后，第2个线程会因主键重出错，但虽然这个线程出错了，却会获得一个排他锁。这时如果有第3个线程又来申请排他锁，也会出现死锁。对于这种情况，可以直接做插入操作，然后再捕获主键重异常，或者在遇到主键重错误时，总是执行ROLLBACK释放获得的排他锁。 ???



5. 索引建立以及优化
    索引分为三类：
        - 普通索引 
            由key或index定义用来加快数据的查询速度，应只为那些经常出现的查询条件或者排序条件(order by)创建索引
        - 唯一索引 避免数据出现重复
        - 主索引 同唯一索引，主要区别是使用primary修饰






参考文档： [Mysql 锁详情](https://www.cnblogs.com/luyucheng/p/6297752.html)
