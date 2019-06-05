# mysql 语句使用


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

3 limit 性能限制

imit10000,20的意思扫描满足条件的10020行，扔掉前面的10000行，返回最后的20行,所以当limit要跳过的数字很大时，这是一个很耗时的操作

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
    
