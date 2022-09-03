## curl

1. curl命令查看请求响应时间

    curl -o /dev/null -s -w %{time_namelookup}::%{time_connect}::%{time_starttransfer}::%{time_total}::%{speed_download}"\n" "http://www.baidu.com"

0.014::0.015::0.018::0.019::1516256.00

-o：把curl 返回的html、js 写到垃圾回收站[ /dev/null]
-s：去掉所有状态
-w：按照后面的格式写出rt
time_namelookup：DNS 解析域名www.36nu.com的时间
time_commect：client和server端建立TCP 连接的时间
time_starttransfer：从client发出请求；到web的server 响应第一个字节的时间
time_total：client发出请求；到web的server发送会所有的相应数据的时间
speed_download：下周速度  单位 byte/s
