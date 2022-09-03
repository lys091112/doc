## mysql Double Write Buffer

IO的最小单位：

　　1、数据库IO的最小单位是16K（MySQL默认，oracle是8K）
　　2、文件系统IO的最小单位是4K（也有1K的）
　　3、磁盘IO的最小单位是512字节

一般mysql不直接落磁盘，而是先写内存buffer，，在将数据刷新到磁盘（随机存储),但是假如在写入过程中断电，可能会造成部分写入，而部分未写入，即造成落脏数据，因此引入了double-write-buffer(采用顺序追加的方式写入磁盘，速度快)

1. DWB解决了什么问题

```
一个数据页的大小是16K，假设在把内存中的脏页写到数据库的时候，写了2K突然掉电，也就是说前2K数据是新的，后14K是旧的，那么磁盘数据库这个数据页就是不完整的，是一个坏掉的数据页。redo只能加上旧、"校检完整" 的数据页恢复一个脏块，不能修复坏掉的数据页，所以这个数据就丢失了，可能会造成数据不一致，所以需要double write
```

2. double write buffer 工作流程

double write buffer 由两部分组成，一部分为内存中的doublewrite buffer，其大小为2MB，另一部分是磁盘上共享表空间(ibdata x)中连续的128个页，即2个区(extent)，大小也是2M

流程：

    1. 当一系列机制触发数据缓冲池中的脏页刷新时，并不直接写入磁盘数据文件中，而是先拷贝至内存中的doublewrite buffer中

    2. 接着从两次写缓冲区分两次写入磁盘共享表空间中(连续存储，顺序写，性能很高)，每次写1MB；

    3. 待第二步完成后，再将double write buffer中的脏页数据写入实际的各个表空间文件(离散写)；(脏页数据固化后，即进行标记对应double write数据可覆盖)

3. double write buffer 崩溃恢复

如果操作系统在将页写入磁盘的过程中发生崩溃，在恢复过程中，innodb存储引擎可以从共享表空间的doublewrite中找到该页的一个最近的副本，将其复制到表空间文件，再应用redo log，就完成了恢复过程o

``TIP``
    redolog写入的单位就是512字节，也就是磁盘IO的最小单位，所以无所谓数据损坏。

#### 带来的影响

1. double write带来的写负载
    
    double write是一个buffer, 但其实它是开在物理文件上的一个buffer, 其实也就是file, 所以它会导致系统有更多的fsync操作, 而硬盘的fsync性能是很慢的, 所以它会降低mysql的整体性能


#### 带来的影响

1. double write带来的写负载
    
    double write是一个buffer, 但其实它是开在物理文件上的一个buffer, 其实也就是file, 所以它会导致系统有更多的fsync操作, 而硬盘的fsync性能是很慢的, 所以它会降低mysql的整体性能


#### 带来的影响

1. double write带来的写负载
    
    double write是一个buffer, 但其实它是开在物理文件上的一个buffer, 其实也就是file, 所以它会导致系统有更多的fsync操作, 而硬盘的fsync性能是很慢的, 所以它会降低mysql的整体性能


#### 带来的影响

1. double write带来的写负载
    
    double write是一个buffer, 但其实它是开在物理文件上的一个buffer, 其实也就是file, 所以它会导致系统有更多的fsync操作, 而硬盘的fsync性能是很慢的, 所以它会降低mysql的整体性能


#### 带来的影响

1. double write带来的写负载
    
    double write是一个buffer, 但其实它是开在物理文件上的一个buffer, 其实也就是file, 所以它会导致系统有更多的fsync操作, 而硬盘的fsync性能是很慢的, 所以它会降低mysql的整体性能

2. doublewrite buffer写入磁盘共享表空间这个过程是连续存储，是顺序写，性能非常高，(约占写的%10)，牺牲一点写性能来保证数据页的完整还是很有必要的

可通过命令 `` show global status like '%dblwr%' `` 来查看当前的工作负载

3. 为什么没有把double write里面的数据写到data page里面呢？

　　1、double write里面的数据是连续的，如果直接写到data page里面，而data page的页又是离散的，写入会很慢。

　　2、double write里面的数据没有办法被及时的覆盖掉，导致double write的压力很大；短时间内可能会出现double write溢出的情况

#### 关闭double write适合的场景

1. 海量DML
2. 不惧怕数据损坏和丢失
3. 系统写负载成为主要负载

