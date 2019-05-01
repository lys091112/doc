# Mysql 语句相关


- 数据库表结构中的 `text` 等大字段的设计
    
    在设计数据库表结构时，如果使用的是大字段，那么需要考虑每一次的查询，是否一定会查询该大字段，如果不是每次都查询，那么建议将其移动到另一张表中
    进行关联，原因如下：

    在Innodb的模式中，查询的叶子节点的数据不是指向真实数据的指针，而是真实数据本身，如果text太大，那么由于每次索引加载查询的页大小为固定值（4K）
    那么会造成每页所承载的数据量变少，从而降低查询的效率，因此可以将不经常使用的大字段放入到单独的关联表中

- TIMESTAMP的使用
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

- 数据库表字段修改
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
