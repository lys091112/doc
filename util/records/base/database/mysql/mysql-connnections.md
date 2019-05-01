# MYSQL 常见错误

```mysql

show global variables like "wait_timeout"; # 查询数据库最大超时时间

# 查询mysql默认连接数和当前数据库的连接状态
show variables like '%max_connections%'
show full processlist; 

```

### MySQL的Sleep进程占用大量连接解决方法

- 产生原因

1. 由于mysql通常使用的是长连接方式，因而数据库连接不会在生命周期内不会释放，造成大量连接被暂用。 

2. 如果使用短连接方式，那么可能有一下记住原因：

    - Web服务器负荷过重，导致HTTP请求处理过慢，从而造成Sleep连接堆积
    - 逻辑处理过于复杂，处理耗时较长，如打开数据库连接后，会大量长时间的计算，导致数据不被释放，从而造成数据连接被占用，应尽可能合理优化逻辑，并建立超时机制，尽早释放不正常的处理

- 解决方式

1. 设置数据库wait_timeout数值大小，mysql数据库默认是28800（8小时），数值过大会造成mysql中有大量的数据连接无法释放，从而拖累系统性能，但也不能过于小，否则会遭遇到 "Mysql has gone away", (有类似与mysql_ping 的方式，告诉服务器连接的存活状态，以便于服务器重新计算wait_timeout时间)


### com.mysql.jdbc.exceptions.jdbc4.CommunicationsException: Communications link failure

- 产生原因
    当数据库重启或数据库空闲连接超过设置的最大timemout时间，数据库会强行断开已有的链接,这是由于 ``wait_timeout`` 设置过小导致

- 解决方法
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
        validationQuery: SELECT 1
        testWhileIdle: true
        timeBetweenEvictionRunsMillis: 28000
        其中timeBetweenEvictionRunsMillis需要小于mysql的wait_timeout。

    但是这种方法无法避免重启的情况，不过一般数据库不会频繁重启，影响不大，如果非得频繁重启，可以通过设置testOnBorrow，即申请连接的时候先试一试连接是否可用，不过带来的影响就是性能降低，需要根据实际需求合理取舍。


