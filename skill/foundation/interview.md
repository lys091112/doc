## 数据库方面

1. 数据库设计的三大范式

    第一范式是最基本的范式。如果数据库表中的所有字段值都是不可分解的原子值，就说明该数据库表满足了第一范式, 例如地址可以拆分为省份，城市，详细地址多个部分

    第二范式： 首先是第一范式，另外包含两部分内容，一是表必须有主键，二是没有包含在主键中的列必须完全依赖与主键，而不能只依赖主键的一部分
    例如：订单明细表：OrderDetail（OrderId, ProductId,单价，折扣，数量，产品名称），对于一个订单它可能有多个商品，那么单单一个OrderId不足以做主键，因此会使用OrderId和ProductId做为联合主键。 折扣，数量是严格与联合主键关联，但是单价，产品名称却只和ProductId相关，因此不满足2NF，所以需要将单价和产品名称拆到一张单独的表中，防止在订单详情表中多余产品信息的冗余（因为如果每个订单都包含订单单价和订单名称，那么多个订单会重复出现该数据，造成冗余）。但是也有意外情况，即我需要单价和产品名称来做历史记录，防止产品信息更改后造成历史数据的丢失

    第三范式： 首先是2NF，其次非主键列必须直接依赖于主键列，而不能存在传递依赖，即不能存在A列依赖于B列，B列依赖于主键列
    例如订单表：Order（OrderID，createTime, customerId, customerName, customerAddr),其中OderID是主键，其他列都于主键相关，但是CustomerName，customerAddr于customerId直接相关，而并非于orderId直接相关，因此不满足3NF，需要将数据库表进行拆分 其他： BCNF： 
    第四范式：要求把同一表内的多对多关系删除
    五范式：从最终结构重新建立原始结构？？


2. 数据库设计过程中有那些注意事项或者优化原则

- 库设计：
     数据库名称要明确，可以加前缀或后缀，要有业务含义
     不同类型的数据应分开管理，如财务数据，业务数据
     尽可能少用存储过程，不要让数据库处理过多逻辑，将业务放到应用中

- 表设计：
   - 数据尽量不要进行物理删除，应添加一个标志位，以防用户后悔时无法恢复
   - 数据添加是否有效的标识位
   - 字段排序 将数据库字段按照一定的规则进行排序，方便查找
   - 是否需要记录时间，创建时间和更新时间等
   - 数据库字段尽可能添加默认值
   - 如果两个表存在多对多的关系，尽可能在添加一张关联表，将其转化为一对多的关系
   - 表的垂直拆分，经常查询的字段放置到一个表中，把text， blob类型的数据拆分到另一个表中
   - 禁止使用select (*)这样的查询

   索引：
    索引需要根据where groupby等语句后的条件按照一定的顺序进行排列
    索引的个数需要控制在3个以内
    对于字符串索引，需要添加索引的长度控制，防止索引太大，占据太多空间

索引的弊端: 一是创建索引要耗费时间，二是索引要占有大量磁盘空间，三是增加了维护代价（在修改带索引的数据列时索引会减缓修改速度）

3. Mysql数据库有哪几种引擎，各自的特性是什么

+-------------+------+----------------------+-------------------------------+------------------------+
| 存储引擎    | 事务 | 锁粒度               | 主要应用                      | 忌用                   |
+=============+======+======================+===============================+========================+
| MyISAM      | No   | 支持并发插入的表级锁 | SELECT，INSERT                | 读写操作频繁           |
+-------------+------+----------------------+-------------------------------+------------------------+
| MRG-MyISAM  | No   | 支持并发插入的表级锁 | 分段归档，数据仓库            | 全局查找过多的场景     |
+-------------+------+----------------------+-------------------------------+------------------------+
| Innodb      | Yes  | 支持MVCC级别的行级锁 | 事务处理                      | 无                     |
+-------------+------+----------------------+-------------------------------+------------------------+
| Archine     | No   | 行级锁               | 日记记录，只支持insert select | 需要随机读取 更新 删除 |
+-------------+------+----------------------+-------------------------------+------------------------+
| NDB Cluster | Yes  | 行级锁               | 高可用                        | 大部分应用             |
+-------------+------+----------------------+-------------------------------+------------------------+

Innodb引擎提供了对数据库ACID事务的支持，并且实现了SQL标准的四种隔离级别，关于数据库事务与其隔离级别的内容请见数据库事务与其隔离级别这篇文章。该引擎还提供了行级锁和外键约束，它的设计目标是处理大容量数据库系统，它本身其实就是基于MySQL后台的完整数据库系统，MySQL运行时Innodb会在内存中建立缓冲池，用于缓冲数据和索引。但是该引擎不支持FULLTEXT类型的索引，而且它没有保存表的行数，当SELECT COUNT(*) FROM TABLE时需要扫描全表。当需要使用数据库事务时，该引擎当然是首选。由于锁的粒度更小，写操作不会锁定全表，所以在并发较高时，使用Innodb引擎会提升效率。但是使用行级锁也不是绝对的，如果在执行一个SQL语句时MySQL不能确定要扫描的范围，InnoDB表同样会锁全表

MyIASM是MySQL默认的引擎，但是它没有提供对数据库事务的支持，也不支持行级锁和外键，因此当INSERT(插入)或UPDATE(更新)数据时即写操作需要锁定整个表，效率便会低一些。不过和Innodb不同，MyIASM中存储了表的行数，于是SELECT COUNT(*) FROM TABLE时只需要直接读取已经保存好的值而不需要进行全表扫描。如果表的读操作远远多于写操作且不需要数据库事务的支持，那么MyIASM也是很好的选择

大尺寸的数据集趋向于选择InnoDB引擎，因为它支持事务处理和故障恢复。数据库的大小决定了故障恢复的时间长短，InnoDB可以利用事务日志进行数据恢复，这会比较快。主键查询在InnoDB引擎下也会相当快，不过需要注意的是如果主键太长也会导致性能问题，关于这个问题我会在下文中讲到。大批的INSERT语句(在每个INSERT语句中写入多行，批量插入)在MyISAM下会快一些，但是UPDATE语句在InnoDB下则会更快一些，尤其是在并发量大的时候

InnoDB：磁盘表，支持事务，支持行级锁，B+Tree索引
ps:优点： 具有良好的ACID特性。适用于高并发，更新操作比较多的表。需要使用事务的表。对自动灾难恢复有要求的表。
缺点：读写效率相对MYISAM比较差。占用的磁盘空间比较大。

MyISAM：磁盘表，不支持事务，支持表级锁，B+Tree索引
ps: 优点：占用空间小，处理速度快（相对InnoDB来说）
缺点：不支持事务的完整性和并发性

MEMORY(Heap)：内存表，不支持事务，表级锁，Hash索引，不支持Blob,Text大类型
ps: 优点：速度要求快的，临时数据
缺点：丢失以后，对项目整体没有或者负面影响不大的时候。

4. 其他
    useServerPrestmts=true 开启PreparedStatemeng的缓存

##  nosql

1. 什么是nosql

2. 为什么nosql比sql快？
    Nosql是非关系型数据库，因为不需要满足关系数据库数据一致性等复杂特性所以速度快；
    sql是关系型数据库，功能强大，但是效率上有瓶颈

3. 

## ZK+Kafka
1. 为什么kafka需要使用zkeeper， 能够替代zk

    kafka需要一个地方存储元数据以及交换集群信息，使用zookeeper的watch机制来发现meta的变更以及做出相应的动作
    kafka broker启动后会在zk建立一个临时节点(当broker挂掉后，删除该临时节点),随后向broker注册自己持有的topic和partitions
    consumer and consmergroup 一个group中的多个consumer可以交错的消费一个topic的所有partitions;简而言之,保证此topic的所有partitions都能被此group所消费,且消费时为了性能考虑,让partition相对均衡的分散到每个consumer上
    
状态同步：
    consmer 保存消费的offset到zookeeper
    partition leader 注册在zk中，Producer作为client，通过注册Watch用来监听partition leader的变更事件
    zk支持kafka的partition leader／follower的协同和选举，保证partition中只要有leader／follower就不会停止服务


总结：
    Producer通过zk来发现borker列表，并通过于topic下的每个partition leader建立连接关系并发送消息
    Borker用zk来注册borker信息，以及检测partion leader的存活性
    Consumer使用zk来组成consumer信息，包括consumer消费的partition信息等，同时也可以用来发现borker列表，并同partitionleader建立连接来消费信息


换言之需要知道现在那些生产者（对于消费者而言，kafka就是生产者）是可用的。 如果没了zk消费者如何知道呢？如果每次消费者在消费之前都去尝试连接生产者测试下是否连接成功，效率呢？ 所以kafka需要zk，在kafka的设计中就依赖了zk了

2. ZK的使用场景有哪些
    
    常见的使用场景包括：配置管理， 统一命名服务，提供分布式同步，集群管理

3. ZK的特性，包括Watch之类的特性

3. kafka与其他消息队列的对比，为什么告警使用kafka而不使用其他队列


## Redis
1. Redis的两种方式，各自有什么优缺点，以及注意事项
    
    RDB:可以在指定时间内生成数据集的时间点快照(point-in-time snapshot)
    AOF: 记录服务器执行的所有写操作命令，并在服务器启动时，通过重新执行这些命令来还原数据集, AOF 文件中的命令全部以 Redis 协议的格式来保存，新命令会被追加到文件的末尾。 Redis 还可以在后台对 AOF 文件进行重写（rewrite），使得 AOF 文件的体积不会超出保存数据集状态所需的实际大小。
    Redis 还可以同时使用 AOF 持久化和 RDB 持久化。 在这种情况下， 当 Redis 重启时， 它会优先使用 AOF 文件来还原数据集， 因为 AOF 文件保存的数据集通常比 RDB 文件所保存的数据集更完整

    RDB优点：
    - RDB 是一个非常紧凑（compact）的文件，它保存了 Redis 在某个时间点上的数据集。 这种文件非常适合用于进行备份： 比如说，你可以在最近的 24 小时内，每小时备份一次 RDB 文件，并且在每个月的每一天，也备份一个 RDB 文件。 这样的话，即使遇上问题，也可以随时将数据集还原到不同的版本
    - RDB 非常适用于灾难恢复（disaster recovery）：它只有一个文件，并且内容都非常紧凑，可以（在加密后）将它传送到别的数据中心，或者亚马逊 S3 中
    - RDB 可以最大化 Redis 的性能：父进程在保存 RDB 文件时唯一要做的就是 fork 出一个子进程，然后这个子进程就会处理接下来的所有保存工作，父进程无须执行任何磁盘 I/O 操作
    - RDB 在恢复大数据集时的速度比 AOF 的恢复速度要快。
    缺点：
    - 如果你需要尽量避免在服务器故障时丢失数据，那么 RDB 不适合你。 虽然 Redis 允许你设置不同的保存点（save point）来控制保存 RDB 文件的频率， 但是， 因为RDB 文件需要保存整个数据集的状态， 所以它并不是一个轻松的操作。 因此你可能会至少 5 分钟才保存一次 RDB 文件。 在这种情况下， 一旦发生故障停机， 你就可能会丢失好几分钟的数据
    - 每次保存 RDB 的时候，Redis 都要 fork() 出一个子进程，并由子进程来进行实际的持久化工作。 在数据集比较庞大时， fork() 可能会非常耗时，造成服务器在某某毫秒内停止处理客户端； 如果数据集非常巨大，并且 CPU 时间非常紧张的话，那么这种停止时间甚至可能会长达整整一秒。 虽然 AOF 重写也需要进行 fork() ，但无论 AOF 重写的执行间隔有多长，数据的耐久性都不会有任何损失

    AOF优点：
    - 使用 AOF 持久化会让 Redis 变得非常耐久（much more durable）：你可以设置不同的 fsync 策略，比如无 fsync ，每秒钟一次 fsync ，或者每次执行写入命令时 fsync 。 AOF 的默认策略为每秒钟 fsync 一次，在这种配置下，Redis 仍然可以保持良好的性能，并且就算发生故障停机，也最多只会丢失一秒钟的数据（ fsync 会在后台线程执行，所以主线程可以继续努力地处理命令请求）
    - AOF 文件是一个只进行追加操作的日志文件（append only log）， 因此对 AOF 文件的写入不需要进行 seek ， 即使日志因为某些原因而包含了未写入完整的命令（比如写入时磁盘已满，写入中途停机，等等）， redis-check-aof 工具也可以轻易地修复这种问题
    - Redis 可以在 AOF 文件体积变得过大时，自动地在后台对 AOF 进行重写： 重写后的新 AOF 文件包含了恢复当前数据集所需的最小命令集合。 整个重写操作是绝对安全的，因为 Redis 在创建新 AOF 文件的过程中，会继续将命令追加到现有的 AOF 文件里面，即使重写过程中发生停机，现有的 AOF 文件也不会丢失。 而一旦新 AOF 文件创建完毕，Redis 就会从旧 AOF 文件切换到新 AOF 文件，并开始对新 AOF 文件进行追加操作
    - AOF 文件有序地保存了对数据库执行的所有写入操作， 这些写入操作以 Redis 协议的格式保存， 因此 AOF 文件的内容非常容易被人读懂， 对文件进行分析（parse）也很轻松。 导出（export） AOF 文件也非常简单： 举个例子， 如果你不小心执行了 FLUSHALL 命令， 但只要 AOF 文件未被重写， 那么只要停止服务器， 移除 AOF 文件末尾的 FLUSHALL 命令， 并重启 Redis ， 就可以将数据集恢复到 FLUSHALL 执行之前的状态。
    AOF缺点：
    - 对于相同的数据集来说，AOF 文件的体积通常要大于 RDB 文件的体积
    - 根据所使用的 fsync 策略，AOF 的速度可能会慢于 RDB 。 在一般情况下， 每秒 fsync 的性能依然非常高， 而关闭 fsync 可以让 AOF 的速度和 RDB 一样快， 即使在高负荷之下也是如此。 不过在处理巨大的写入载入时，RDB 可以提供更有保证的最大延迟时间（latency）
    - AOF 在过去曾经发生过这样的 bug ： 因为个别命令的原因，导致 AOF 文件在重新载入时，无法将数据集恢复成保存时的原样。 （举个例子，阻塞命令 BRPOPLPUSH 就曾经引起过这样的 bug 。） 测试套件里为这种情况添加了测试： 它们会自动生成随机的、复杂的数据集， 并通过重新载入这些数据来确保一切正常。 虽然这种 bug 在 AOF 文件中并不常见， 但是对比来说， RDB 几乎是不可能出现这种 bug 的

    RDB : save 60 1000  60 秒内有至少有 1000 个键被改动,就自动保存一次数据集

    当 Redis 需要保存 dump.rdb 文件时， 服务器执行以下操作：
    ```
    Redis 调用 fork() ，同时拥有父进程和子进程。
    子进程将数据集写入到一个临时 RDB 文件中。
    当子进程完成对新 RDB 文件的写入时，Redis 用新 RDB 文件替换原来的 RDB 文件，并删除旧的 RDB 文件。
    这种工作方式使得 Redis 可以从写时复制（copy-on-write）机制中获益。
    ```

    快照功能并不是非常耐久（durable）： 如果 Redis 因为某些原因而造成故障停机， 那么服务器将丢失最近写入、且仍未保存到快照中的那些数据。
    尽管对于某些程序来说， 数据的耐久性并不是最重要的考虑因素， 但是对于那些追求完全耐久能力（full durability）的程序来说， 快照功能就不太适用了
    通过设置appendonly yes， 保证每个命令都会被刷新到aof

    AOF 有多耐久？
    你可以配置 Redis 多久才将数据 fsync 到磁盘一次。

    有三个选项：
        - 每次有新命令追加到 AOF 文件时就执行一次 fsync ：非常慢，也非常安全。
        - 每秒 fsync 一次：足够快（和使用 RDB 持久化差不多），并且在故障时只会丢失 1 秒钟的数据。
        - 从不 fsync ：将数据交给操作系统来处理。更快，也更不安全的选择。
    推荐（并且也是默认）的措施为每秒 fsync 一次， 这种 fsync 策略可以兼顾速度和安全性

    AOF运作方式：
    AOF 重写和 RDB 创建快照一样，都巧妙地利用了写时复制机制。

    以下是 AOF 重写的执行步骤：
    - Redis 执行 fork() ，现在同时拥有父进程和子进程。
    - 子进程开始将新 AOF 文件的内容写入到临时文件。
    - 对于所有新执行的写入命令，父进程一边将它们累积到一个内存缓存中，一边将这些改动追加到现有 AOF 文件的末尾： 这样即使在重写的中途发生停机，现有的 AOF 文件也还是安全的。
    - 当子进程完成重写工作时，它给父进程发送一个信号，父进程在接收到信号之后，将内存缓存中的所有数据追加到新 AOF 文件的末尾。
    - 搞定！现在 Redis 原子地用新文件替换旧文件，之后所有命令都会直接追加到新 AOF 文件的末尾。

备份建议：
- 创建一个定期任务（cron job）， 每小时将一个 RDB 文件备份到一个文件夹， 并且每天将一个 RDB 文件备份到另一个文件夹。
- 确保快照的备份都带有相应的日期和时间信息， 每次执行定期任务脚本时， 使用 find 命令来删除过期的快照： 比如说， 你可以保留最近 48 小时内的每小时快照， 还可以保留最近一两个月的每日快照。
- 至少每天一次， 将 RDB 备份到你的数据中心之外， 或者至少是备份到你运行 Redis 服务器的物理机器之外。
- Master最好不做持久化如RDB快照和AOF日志文件；如果数据比较重要，某分slave开启AOF备份数据，策略为每秒1次，为了主从复制速度及稳定，MS主从在同一局域网内；主从复制不要用图状结构，用单向链表更为稳定 M-S-S-S-S。。。。；redis过期采用懒汉+定期，懒汉即get/set时候检查key是否过期，过期则删除key，定期遍历每个DB，检查制定个数个key；结合服务器性能调节并发情况

2. Redis处理用来做缓存外，还可以用来做什么(它的使用场景)

    - Redis缓存-热数据
    - 计数器 INCRBY
    - 队列 不仅可以把并发请求变成串行，并且还可以做队列或者栈使用
    - 位操作（大数据处理）setbit getbit bitcount
    - 分布式锁与单线程机制 
        验证前端的重复请求（可以自由扩展类似情况），可以通过redis进行过滤：每次请求将request Ip、参数、接口等hash作为key存储redis（幂等性请求），设置多长时间有效期，然后下次请求过来的时候先在redis中检索有没有这个key，进而验证是不是一定时间内过来的重复提交
        秒杀系统，基于redis是单线程特征，防止出现数据库“爆破”
        全局增量ID生成，类似“秒杀”
    - Redis订阅/发布
    

3. Redis的数据key返回类型有那些
    Type 命令用于返回 key 所储存的值的类型
    - String 
    - Hash
    - List
    - Set
    - Sorted set
    - pub/sub
    - Transactions

4. Redis的常见问题

5. Redis 淘汰策略
    - volatile-lru：从已设置过期时间的数据集（server.db[i].expires）中挑选最近最少使用的数据淘汰
    - volatile-ttl：从已设置过期时间的数据集（server.db[i].expires）中挑选将要过期的数据淘汰
    - volatile-random：从已设置过期时间的数据集（server.db[i].expires）中任意选择数据淘汰
    - allkeys-lru：从数据集（server.db[i].dict）中挑选最近最少使用的数据淘汰
    - allkeys-random：从数据集（server.db[i].dict）中任意选择数据淘汰
    - no-enviction（驱逐）：禁止驱逐数据

6. redis的hash算法用的是啥？
redis应该是使用一致性hash算法---MurmurHash3 算法，具有低碰撞率优点，google改进的版本cityhash也是redis中用到的哈希算法。现有的主流的大数据系统都是用的 MurmurHash本身或者改进redis应该是

6. redis, mongdb, hbase的使用与区别

## Java 基础

1. JVM内存模型，以及各个模块的作用

    - 线程私有域:
        1.  Program Counter Register(程序计数器), 作用是当前线程所执行字节码的行号指示器(类似于传统cpu的pc), 字节码解释器就是通过改变PC值来选取下一条需要执行的字节码指令,分支、循环、跳转、异常处理、线程恢复等基础功能都需要依赖PC完成
        2. Java Stack(虚拟机栈) 虚拟机栈描述的是Java方法执行的内存模型: 每个方法被执行时会创建一个栈帧(Stack Frame)用于存储局部变量表、操作数栈、动态链接、方法出口等信息. 每个方法被调用至返回的过程, 就对应着一个栈帧在虚拟机栈中从入栈到出栈的过程
        3. Native Method Stack(本地方法栈)：基本同虚拟机栈，本地方法栈则为Native方法服务
    - 线程共享区域
        1. Method Area(方法区),即我们常说的永久代，用于存储被JVM加载的类信息、常量、静态变量、即时编译器编译后的代码等数据。 运行时常量池，方法区的一部分. Class文件中除了有类的版本、字段、方法、接口等描述信息外,还有一项常量池(Constant Pool Table)用于存放编译期生成的各种字面量和符号引用
        2. Heap(Java堆) 几乎所有对象实例和数组都要在堆上分配(栈上分配、标量替换除外), 因此是VM管理的最大一块内存, 也是垃圾收集器的主要活动区域. 由于现代VM采用分代收集算法, 因此Java堆从GC的角度还可以细分为: 新生代(Eden区、From Survivor区和To Survivor区)和老年代; 而从内存分配的角度来看, 线程共享的Java堆还还可以划分出多个线程私有的分配缓冲区(TLAB). 而进一步划分的目的是为了更好地回收内存和更快地分配内存
    - 直接内存
        直接内存并不是JVM运行时数据区的一部分, 但也会被频繁的使用: 在JDK 1.4引入的NIO提供了基于Channel与Buffer的IO方式, 它可以使用Native函数库直接分配堆外内存, 然后使用DirectByteBuffer对象作为这块内存的引用进行操作(详见: Java I/O 扩展), 这样就避免了在Java堆和Native堆中来回复制数据, 因此在一些场景中可以显著提高性能.

    java7 and java8:
    持久代已经被彻底删除了，取代它的是另一个内存区域也被称为元空间
        - 它是本地堆内存中的一部分
        - 它可以通过-XX:MetaspaceSize和-XX:MaxMetaspaceSize来进行调整
        - 当到达XX:MetaspaceSize所指定的阈值后会开始进行清理该区域
        - 如果本地空间的内存用尽了会收到java.lang.OutOfMemoryError: Metadata space的错误信息。
        - 和持久代相关的JVM参数-XX:PermSize及-XX:MaxPermSize将会被忽略掉，并且在启动的时候给出警告信息。
        - 充分利用了Java语言规范中的好处：类及相关的元数据的生命周期与类加载器的一致
    元空间 —— 调优
        - 使用-XX:MaxMetaspaceSize参数可以设置元空间的最大值，默认是没有上限的，也就是说你的系统内存上限是多少它就是多少。
        - 使用-XX:MetaspaceSize选项指定的是元空间的初始大小，如果没有指定的话，元空间会根据应用程序运行时的需要动态地调整大小。
        -  一旦类元数据的使用量达到了“MaxMetaspaceSize”指定的值，对于无用的类和类加载器，垃圾收集此时会触发。为了控制这种垃圾收集的频率和延迟，合适的监控和调整Metaspace非常有必要。过于频繁的Metaspace垃圾收集是类和类加载器发生内存泄露的征兆，同时也说明你的应用程序内存大小不合适，需要调整。

1.1. 内存操作规则
    主内存和工作内存：
        java内存模型中规定了所有变量都存贮到主内存（如虚拟机物理内存中的一部分）中。每一个线程都有一个自己的工作内存(如cpu中的高速缓存)。线程中的工作内存保存了该线程使用到的变量的主内存的副本拷贝。线程对变量的所有操作（读取、赋值等）必须在该线程的工作内存中进行。不同线程之间无法直接访问对方工作内存中变量。线程间变量的值传递均需要通过主内存来完成

   java内存模型定义了8种操作来完成。这8种操作每一种都是原子操作
        - lock(锁定)：作用于主内存，它把一个变量标记为一条线程独占状态；
        - unlock(解锁)：作用于主内存，它将一个处于锁定状态的变量释放出来，释放后的变量才能够被其他线程锁定；
        - read(读取)：作用于主内存，它把变量值从主内存传送到线程的工作内存中，以便随后的load动作使用；
        - load(载入)：作用于工作内存，它把read操作的值放入工作内存中的变量副本中；
        - use(使用)：作用于工作内存，它把工作内存中的值传递给执行引擎，每当虚拟机遇到一个需要使用这个变量的指令时候，将会执行这个动作；
        - assign(赋值)：作用于工作内存，它把从执行引擎获取的值赋值给工作内存中的变量，每当虚拟机遇到一个给变量赋值的指令时候，执行该操作；
        - store(存储)：作用于工作内存，它把工作内存中的一个变量传送给主内存中，以备随后的write操作使用；
        - write(写入)：作用于主内存，它把store传送值放到主内存中的变量中。

    Java内存模型还规定了执行上述8种基本操作时必须满足如下规则:
        - 不允许read和load、store和write操作之一单独出现，以上两个操作必须按顺序执行，但没有保证必须连续执行，也就是说，read与load之间、store与write之间是可插入其他指令的。
        - 不允许一个线程丢弃它的最近的assign操作，即变量在工作内存中改变了之后必须把该变化同步回主内存。
        - 不允许一个线程无原因地（没有发生过任何assign操作）把数据从线程的工作内存同步回主内存中。
        - 一个新的变量只能从主内存中“诞生”，不允许在工作内存中直接使用一个未被初始化（load或assign）的变量，换句话说就是对一个变量实施use和store操作之前，必须先执行过了assign和load操作。
        - 一个变量在同一个时刻只允许一条线程对其执行lock操作，但lock操作可以被同一个条线程重复执行多次，多次执行lock后，只有执行相同次数的unlock操作，变量才会被解锁。
        - 如果对一个变量执行lock操作，将会清空工作内存中此变量的值，在执行引擎使用这个变量前，需要重新执行load或assign操作初始化变量的值。
        - 如果一个变量实现没有被lock操作锁定，则不允许对它执行unlock操作，也不允许去unlock一个被其他线程锁定的变量。
        对一个变量执行unlock操作之前，必须先把此变量同步回主内存（执行store和write操作）


2. 常用集合类以及AQS的作用

3. synchronized 锁的类型和锁的作用范围
    synchronized 是针对于对象级别的锁，如果同于同一个类有多个实例，那么实例与实例之间是不会受synchronized影响
    synchronized的底层实现主要依靠Lock-Free的队列，基本思路是自旋后阻塞，竞争切换后继续竞争锁，稍微牺牲了公平性，但获得了高吞吐量

4. synchronized 与 Lock的区别

    - 锁的种类
        1. 可重入锁:synchronized和ReentrantLock都是可重入锁，可重入性在我看来实际上表明了锁的分配机制：基于线程的分配，而不是基于方法调用的分配。举比如说，当一个线程执行到method1 的synchronized方法时，而在method1中会调用另外一个synchronized方法method2，此时该线程不必重新去申请锁，而是可以直接执行方法method2
        2. 读写锁;读写锁将对一个资源的访问分成了2个锁，如文件，一个读锁和一个写锁。正因为有了读写锁，才使得多个线程之间的读操作不会发生冲突
        3. 可中断锁:在Java中，synchronized就不是可中断锁，而Lock是可中断锁。 如果某一线程A正在执行锁中的代码，另一线程B正在等待获取该锁，可能由于等待时间过长，线程B不想等待了，想先处理其他事情，我们可以让它中断自己或者在别的线程中中断它，这种就是可中断锁
        4.  公平锁:公平锁即尽量以请求锁的顺序来获取锁。同时有多个线程在等待一个锁，当这个锁被释放时，等待时间最久的线程（最先请求的线程）会获得该锁公平锁即尽量以请求锁的顺序来获取锁
    - syncchronized 的用法
        1. 锁定一段代码块
        2. 锁定一个方法
        3. 锁定一个类实例 例如：synchronized(this)
        4. 锁定一个类 例：synchronized(Test.class)
    - lokc 常见方法
        1. void lockInterruptibly() throws InterruptedException;
        2. boolean tryLock(); 
        3. boolean tryLock(long time, TimeUnit unit) throws InterruptedException; 
        4. void unlock(); 
        5. Condition newCondition();
    - 两种锁对比：
        1. lock是一个接口，而synchronized 是java内置关键字
        2. synchronized 发生异常时会自动释放锁，而lock需要手动释放，一般会使用try{}finallly{}结构并在finally中释放
        3. lock 可以使等待锁线程响应中断，而synchronized不能响应中断，会一直等下去
        4. lock可以知道锁的状态，而synchronized无法知道


5. 常用的线程安全类以及使用场景
    5.1. java 线程池
        - **ThreadPoolExecutor参数信息**

        | 参数名 | 作用|
        |-------|-------|
        | corePoolSize | 核心线程池大小|
        | maximumPoolSize| 最大线程池大小 |
        | keepAliveTime| 线程池中超过corePoolSize数目的空闲线程最大存活时间 |
        | timeUnit | keepAliveTime时间单位 |
        | workQueue| 阻塞任务队列|
        | threadFactory | 新建线程工程，常用来制定线程名称等 |
        | RejectedExecutionHandler | 当提交任务数超过maxmumPoolSize+workQueue之和时，任务会交给RejectedExecutionHandler来处理 |

        - **corePoolSize, workQueue, maximumPoolSize 的关系**

        ```
        有新的任务时：
            当线程数小于核心线程数时，创建新线程。
            当线程数大于等于核心线程数，且任务队列未满时，将任务放入任务队列，此时不会创建新线程。
            当线程数大于等于核心线程数，且任务队列已满
            若线程数小于最大线程数，创建新线程
            若线程数等于最大线程数，抛出异常，拒绝任务
        ```

6. ThreadLocal的使用场景
    - 日期的初始化，因为日期格式化函数非线程安全，保证每个线程使用的日期格式化函数都是各自唯一的
    - 保存数据库连接Connection， 保证每个线程都使用线程唯一的connection处理连接

7. IO, NIO, AIO的区别
    - IO(同步阻塞BIO)
        同步并阻塞，服务器实现模式为一个连接一个线程，即客户端有连接请求时服务器端就需要启动一个线程进行处理，如果这个连接不做任何事情会造成不必要的线程开销，当然可以通过线程池机制改善。
    - NIO(同步非阻塞)
        同步非阻塞，服务器实现模式为一个请求一个线程，即客户端发送的连接请求都会注册到多路复用器上，多路复用器轮询到连接有I/O请求时才启动一个线程进行处理。用户进程也需要时不时的询问IO操作是否就绪，这就要求用户进程不停的去询问
    - AIO(异步非阻塞)
        服务器实现模式为一个有效请求一个线程，客户端的I/O请求都是由OS先完成了再通知服务器应用去启动线程进行处理

    总结：
        第一点，NIO少了1次从内核空间到用户空间的拷贝
        第二点，NIO以块处理数据，IO以流处理数据
        第三点，非阻塞，NIO1个线程可以管理多个输入输出通道

8. 直接内存和非直接内存的区别
    - 性能比较：
         直接内存申请空间耗费更高的性能，当频繁申请到一定量时尤为明显
        直接内存IO读写的性能要优于普通的堆内存，在多次读写操作的情况下差异明显
    - 从数据流的角度，来看
        非直接内存作用链:
        本地IO –>直接内存–>非直接内存–>直接内存–>本地IO
        直接内存作用链:
        本地IO–>直接内存–>本地IO

    直接内存的使用场景：1.  有很大的数据需要存储，它的生命周期很长 2. 适合频繁的IO操作，例如网络并发场景
    正常情况下，JVM创建缓冲区的时候做了如下几步：
    1.JVM确保Heap区域内的空间足够，如果不够则使用触发GC在内的方法获得空间;
    2.获得空间之后会找一组堆内的连续地址分配数组, 这里需要注意的是，在物理内存上，这些字节是不一定连续的;
    3.对于不涉及到IO的操作，这样的处理没有任何问题，但是当进行IO操作的时候就会出现一点性能问题.

    所有的IO操作都需要操作系统进入内核态才行，而JVM进程属于用户态进程, 当JVM需要把一个缓冲区写到某个Channel或Socket的时候，需要切换到内核态.

    而内核态由于并不知道JVM里面这个缓冲区存储在物理内存的什么地址，并且这些物理地址并不一定是连续的(或者说不一定是IO操作需要的块结构)，所以在切换之前JVM需要把缓冲区复制到物理内存一块连续的内存上, 然后由内核去读取这块物理内存，整合成连续的、分块的内存.

    也就是说如果我们这个时候用的是非直接缓存的话，我们还要进行“复制”这么一个操作，而当我们申请了一个直接缓存的话，因为他本是就是一大块连续地址，我们就可以直接在它上面进行IO操作，省去了“复制”这个步骤

9. 范型以及范型的使用
   class Fruit{} 
   class Apple extend Fruit{}
   class Orange extend Fruit{}
    <? extends Fruit> 上界通配符，表示元素是任何从Fruit类型继承的列表，但该元素可能是Apple，也可能是Orange， 因此无法确定可以添加的具体类型，也就是该范型变量无法添加元素，只能从其中获取
    <? super Fruit> 下界通配符，表明元素是具有任何Fruit的超类的列表。列表至少是一个Fruilt型，因此可以添加Fruit以及Fruilt的子类。 但是取元素时需要进行强转。

10. 数据库分库分表

11. java JNDI RMI JMS
    - JNDI java（Java Naming and Directory Interface）：java命名和目录接口,它是为JAVA应用程序提供命名和目录访问服务的API
    - RMI:远程方法调用(Remote Method Invocation)。能够让在某个java虚拟机上的对象像调用本地对象一样调用另一个java 虚拟机中的对象上的方法
    ```
    clent.java
        Hello h = (Hello)Naming.lookup("rmi://192.168.58.164:12312/Hello");
        System.out.println(h.sayHello("zx"));
        1. 从代码中也可以看到，代码依赖于ip与端口
        2. RMI依赖于Java远程消息交换协议JRMP（Java Remote Messaging Protocol），该协议为java定制，要求服务端与客户端都为java编写

    ```
    - JMS即Java消息服务（Java Message Service）应用程序接口，是一个Java平台中关于面向消息中间件（MOM）的API，用于在两个应用程序之间，或分布式系统中发送消息，进行异步通信。Java消息服务是一个与具体平台无关的API，绝大多数MOM提供商都对JMS提供支持
    ```
        1、Point-to-Point(P2P)
　　　　2、Publish/Subscribe(Pub/Sub)

    ```

12. thread 

    - wait() and sleep()方法的区别： wait() 会释放锁，而sleep()不会释放锁
    - wait() and notify() 是Object的方法，而不是Thread的方法
    - 状态说明：
        1. 新建(new)：新创建了一个线程对象。
        2. 可运行(runnable)：线程对象创建后，其他线程(比如main线程）调用了该对象的start()方法。该状态的线程位于可运行线程池中，等待被线程调度选中，获取cpu 的使用权 。
        3. 运行(running)：可运行状态(runnable)的线程获得了cpu 时间片（timeslice） ，执行程序代码。
        4. 阻塞(block)：阻塞状态是指线程因为某种原因放弃了cpu 使用权，也即让出了cpu timeslice，暂时停止运行。直到线程进入可运行(runnable)状态，才有机会再次获得cpu timeslice 转到运行(running)状态。阻塞的情况分三种：
            (一). 等待阻塞：运行(running)的线程执行o.wait()方法，JVM会把该线程放入等待队列(waitting queue)中。
            (二). 同步阻塞：运行(running)的线程在获取对象的同步锁时，若该同步锁被别的线程占用，则JVM会把该线程放入锁池(lock pool)中。
            (三). 其他阻塞：运行(running)的线程执行Thread.sleep(long ms)或t.join()方法，或者发出了I/O请求时，JVM会把该线程置为阻塞状态。当sleep()状态超时、join()等待线程终止或者超时、或者I/O处理完毕时，线程重新转入可运行(runnable)状态。
        5. 死亡(dead)：线程run()、main() 方法执行结束，或者因异常退出了run()方法，则该线程结束生命周期。死亡的线程不可再次复生。

13. volatile 特性
    - 禁止指令重排
        1、当第二个操作为volatile写操做时,不管第一个操作是什么(普通读写或者volatile读写),都不能进行重排序。这个规则确保volatile写之前的所有操作都不会被重排序到volatile之后;
        2、当第一个操作为volatile读操作时,不管第二个操作是什么,都不能进行重排序。这个规则确保volatile读之后的所有操作都不会被重排序到volatile之前;
        3、当第一个操作是volatile写操作时,第二个操作是volatile读操作,不能进行重排序。
        这个规则和前面两个规则一起构成了:两个volatile变量操作不能够进行重排序；
    - 可见性

14. 内存屏障/内存栅栏

    内存屏障（Memory Barrier，或有时叫做内存栅栏，Memory Fence）是一种CPU指令，用于控制特定条件下的重排序和内存可见性问题。Java编译器也会根据内存屏障的规则禁止重排序。
    内存屏障可以被分为以下几种类型：

    - LoadLoad屏障：对于这样的语句Load1; LoadLoad; Load2，在Load2及后续读取操作要读取的数据被访问前，保证Load1要读取的数据被读取完毕。

    - StoreStore屏障：对于这样的语句Store1; StoreStore; Store2，在Store2及后续写入操作执行前，保证Store1的写入操作对其它处理器可见。

    - LoadStore屏障：对于这样的语句Load1; LoadStore; Store2，在Store2及后续写入操作被刷出前，保证Load1要读取的数据被读取完毕。

    - StoreLoad屏障：对于这样的语句Store1; StoreLoad; Load2，在Load2及后续所有读取操作执行前，保证Store1的写入对所有处理器可见。它的开销是四种屏障中最大的。

    在大多数处理器的实现中，这个屏障是个万能屏障，兼具其它三种内存屏障的功能。

    好处？？

15. happens-before原则
    - 程序次序规则：一个线程内，按照代码顺序，书写在前面的操作先行发生于书写在后面的操作；
    - 锁定规则：一个unLock操作先行发生于后面对同一个锁额lock操作；
    - volatile变量规则：对一个变量的写操作先行发生于后面对这个变量的读操作；
    - 传递规则：如果操作A先行发生于操作B，而操作B又先行发生于操作C，则可以得出操作A先行发生于操作C；
    - 线程启动规则：Thread对象的start()方法先行发生于此线程的每个一个动作；
    - 线程中断规则：对线程interrupt()方法的调用先行发生于被中断线程的代码检测到中断事件的发生；
    - 线程终结规则：线程中所有的操作都先行发生于线程的终止检测，我们可以通过Thread.join()方法结束、Thread.isAlive()的返回值手段检测到线程已经终止执行；
    - 对象终结规则：一个对象的初始化完成先行发生于他的finalize()方法的开始

    explain:
    程序次序规则：一段代码在单线程中执行的结果是有序的。注意是执行结果，因为虚拟机、处理器会对指令进行重排序（重排序后面会详细介绍）。虽然重排序了，但是并不会影响程序的执行结果，所以程序最终执行的结果与顺序执行的结果是一致的。故而这个规则只对单线程有效，在多线程环境下无法保证正确性。

    锁定规则：这个规则比较好理解，无论是在单线程环境还是多线程环境，一个锁处于被锁定状态，那么必须先执行unlock操作后面才能进行lock操作。

    volatile变量规则：这是一条比较重要的规则，它标志着volatile保证了线程可见性。通俗点讲就是如果一个线程先去写一个volatile变量，然后一个线程去读这个变量，那么这个写操作一定是happens-before读操作的。

    传递规则：提现了happens-before原则具有传递性，即A happens-before B , B happens-before C，那么A happens-before C

    线程启动规则：假定线程A在执行过程中，通过执行ThreadB.start()来启动线程B，那么线程A对共享变量的修改在接下来线程B开始执行后确保对线程B可见。

    线程终结规则：假定线程A在执行的过程中，通过制定ThreadB.join()等待线程B终止，那么线程B在终止之前对共享变量的修改在线程A等待返回后可见。

    上面八条是原生Java满足Happens-before关系的规则，但是我们可以对他们进行推导出其他满足happens-before的规则：
        - 将一个元素放入一个线程安全的队列的操作Happens-Before从队列中取出这个元素的操作
        - 将一个元素放入一个线程安全容器的操作Happens-Before从容器中取出这个元素的操作
        - 在CountDownLatch上的倒数操作Happens-Before CountDownLatch#await()操作
        - 释放Semaphore许可的操作Happens-Before获得许可操作
        - Future表示的任务的所有操作Happens-Before Future#get()操作
        - 向Executor提交一个Runnable或Callable的操作Happens-Before任务开始执行操作

    happen-before原则是JMM中非常重要的原则，它是判断数据是否存在竞争、线程是否安全的主要依据，保证了多线程环境下的可见性。

15.1. CPU L1,L2,L3缓存 缓存一致性协议 MESI MESIF 以及只写模式，写回模式，写穿模式??

16. Comparable和Comparator的区别
        Comparable是一个类，用于自己和其他相同类型的类比较
        Comparator 是一个接口，用于比较两个对象。
        即一个是用自身和其他比较，一个是比较两个对象16. Comparable和Comparator的区别

17. 线程间通信 wait及notify方法
    
    线程间的相互作用：线程之间需要一些协调通信，来共同完成一件任务,notify wait()方法在Object中可以被继承使用，他们是final方法，无法被重写

    wait():
        wait()方法使得当前线程必须要等待，等到另外一个线程调用notify()或者notifyAll()方法，当前线程必须拥有当前对象的monitor，即lock。
        线程调用wait()方法，释放它对锁的拥有权，然后等待另外的线程来通知它（通知的方式是notify()或者notifyAll()方法），这样它才能重新获得锁的拥有权和恢复执行。
    　　要确保调用wait()方法的时候拥有锁，即，wait()方法的调用必须放在synchronized方法或synchronized块中。
        一个小的比较：
        - wait会释放掉对象的锁， Thread.sleep()不会释放掉对象的锁

    notify():
        notify()方法会唤醒一个等待当前对象的锁的线程,如果多个线程在等待，它们中的一个将会选择被唤醒。这种选择是随意的,被唤醒的线程是不能被执行的，需要等到当前线程放弃这个对象的锁

    wait()和notify()方法要求在调用时线程已经获得了对象的锁，因此对这两个方法的调用需要放在synchronized方法或synchronized块中。

18.  Arrays.sort() and Collection.sort()
    - 该算法是一个经过调优的快速排序，此算法在很多数据集上提供N*log(N)的性能
    - Collection.sort() 一个经过修改的合并排序算,此算法可提供保证的N*log(N)的性能，此实现将指定列表转储到一个数组中，然后再对数组进行排序，在重置数组中相应位置处每个元素的列表上进行迭代

19. java 序列化和反序列化
    Java序列化是指把Java对象转换为字节序列的过程；而Java反序列化是指把字节序列恢复为Java对象的过程
    java.io.ObjectOutputStream：表示对象输出流
    java.io.ObjectInputStream：表示对象输入流
    需要实现了Serializable接口，再看是否定义readObject(ObjectInputStream in)和writeObject(ObjectOutputSteam out)

20. 反射的定义和作用
    是在运行状态中，对于任意的一个类，都能够知道这个类的所有属性和方法，对任意一个对象都能够通过反射机制调用一个类的任意方法，这种动态获取类信息及动态调用类对象方法的功能称为java的反射机制   
    反射的作用：
        - 动态地创建类的实例，将类绑定到现有的对象中，或从现有的对象中获取类型。
        - 应用程序需要在运行时从某个特定的程序集中载入一个特定的类

21. 内存溢出可能原因和解决。
    原因可能是
        - 数据加载过多，如1次从数据库中取出过多数据  
        - 集合类中有对对象的引用，用完后没有清空或者集合对象未置空导致引用存在等，是的JVM无法回收  
        - 死循环，过多重复对象 
        - 第三方软件的bug       
        - 启动参数内存值设定的过小。
    修改JVM启动参数，加内存(-Xms，-Xmx)；错误日志，是否还有其他错误；代码走查

22. redis memorycache, guavacache,caffine的区别
    redis使用单线程模型，数据顺序提交，redis支持主从模式，mencache只支持一致性hash做分布式；redis支持数据落地，rdb定时快照和aof实时记录操作命令的日志备份，memcache不支持；redis数据类型丰富，有string，hash，set，list， sort set，而memcache只支持简单数据类型；memcache使用cas乐观锁做一致性。

23. 分布式唯一ID
确定ID存储用64位，1个64位二进制1是这样的00000000.....1100......0101，切割64位，某段二进制表示成1个约束条件，前41位为毫秒时间，后紧接9位为IP，IP之后为自增的二进制，记录当前面位数相同情况下是第几个id，如现在有10台机器，这个id生成器生成id极限是同台机器1ms内生成2的14次方个ID。

分布式唯一ID = 时间戳 41位， int类型服务器编号  10，序列自增sequence。每个时间戳内只能生成固定数量如（10万）个自增号，达到最大值则同步等待下个时间戳，自增从0开始。将毫秒数放在最高位，保证生成的ID是趋势递增的，每个业务线、每个机房、每个机器生成的ID都是不同的。如39bit毫秒数|4bit业务线|2bit机房|预留|7bit序列号。高位取2016年1月1日1到现在的毫秒数，系统运行10年，至少需要10年x365天x24小时x3600秒x1000毫秒=320x10~9，差不多39bit给毫秒数，每秒单机高峰并发小于100，差不多7bit给每毫秒的自增号，5年内机房小于100台机器，预留2bit给机房，每个机房小于100台机器，预留7bit给每个机房，业务线小于10个，预留4bit给业务线标识。

## algorithm

1. B+树和B树区别

    B树的非叶子节点存储实际记录的指针，而B+树的叶子节点存储实际记录的指针
    B+树的叶子节点通过指针连起来了, 适合扫描区间和顺序查找