# MySQL的Sleep进程占用大量连接解决方法

**查询mysql默认连接数和当前数据库的连接状态**
```
show variables like '%max_connections%'
show full processlist; 
```

### 产生原因

1. 由于mysql通常使用的是长连接方式，因而数据库连接不会在生命周期内不会释放，造成大量连接被暂用。 

2. 如果使用短连接方式，那么可能有一下记住原因：

    - Web服务器负荷过重，导致HTTP请求处理过慢，从而造成Sleep连接堆积
    - 逻辑处理过于复杂，处理耗时较长，如打开数据库连接后，会大量长时间的计算，导致数据不被释放，从而造成数据连接被占用，应尽可能合理优化逻辑，并建立超时机制，尽早释放不正常的处理


### 解决方式

1. 设置数据库wait_timeout数值大小，mysql数据库默认是28800（8小时），数值过大会造成mysql中有大量的数据连接无法释放，从而拖累系统性能，但也不能过于小，否则会遭遇到 "Mysql has gone away", (有类似与mysql_ping 的方式，告诉服务器连接的存活状态，以便于服务器重新计算wait_timeout时间)