# java 一些基本使用和概念

1). java远程调试参数含义

    java远程调试是两个vm通过debug协议进行调试，通过socket通信。jdwp是java debug wire protocol的缩写
    jdk1.7之前：java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n main_application&
    jdk1.7之后：java -agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n main_application&
     main_application是main程序，server=y表示是监听其他debugclient端的请求。address=800表示监听8000端口， suspend表示是否在调试客户端建立链接后启动vm，如果是y，那么当前的vm就是suspend直到debugclient连接进来才开始执行程序，如果程序不是服务器监听模式并且很快执行完毕，可以选择y来阻塞它的启动