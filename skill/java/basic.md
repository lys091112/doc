# java 一些基本使用和概念

1. java远程调试参数含义
    * java远程调试是两个vm通过debug协议进行调试，通过socket通信。jdwp是java debug wire protocol的缩写
      jdk1.7之前：java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n main_application&
      jdk1.7之后：java -agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n main_application&
      main_application是main程序，server=y表示是监听其他debugclient端的请求。address=800表示监听8000端口， suspend表示是否在调试客户端建立链接后启动vm，如果是y，那么当前的vm就是suspend直到debugclient连接进来才开始执行程序，如果程序不是服务器监听模式并且很快执行完毕，可以选择y来阻塞它的启动

2. java 对象的大小
    - 对象头在32位系统上占用8bytes，64位系统上占用16bytes。
    - 对齐填充（对象头 + 实例数据 + padding） % 8等于0且0 <= padding < 8 >
```        
数组对象: 
64位机器上，占用24个字节，启用压缩之后占用16个字节。之所以比普通对象占用内存多是因为需要额外的空间存储数组的长度。
16个对象头开销，4个长度开销，以及4个字节填充
```
