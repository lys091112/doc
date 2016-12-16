# redis基本使用

## 常用命令集合
>* 1)，redis-benchmark -h localhost -p 6379 -c 100 -n 1000000 100个并发连接，100000个请求，检测host为localhost端口为6379的redis服务性能
>* 2)，redis-cli -h localhost -p 6379 lrange kkk* 0 -1 >1.txt 执行将某个执行的数据输出到文件中去
