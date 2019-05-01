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
