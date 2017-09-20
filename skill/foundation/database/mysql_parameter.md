# mysql 常用参数

- TIMESTAMP
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
