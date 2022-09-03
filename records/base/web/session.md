# Session 


## 集群环境下Session的一致性方案


1. Session Sticky

    session sticky就是把同一个用户在某一个会话中的请求，都分配到固定的某一台服务器中，这样我们就不需要解决跨服务器的session问题了，常见的算法有ip_hash法，即上面提到的两种散列算法。
    优点：实现简单。
    缺点：应用服务器重启则session消失。

2. Session Replication 

    session replication就是在集群中复制session，使得每个服务器都保存有全部用户的session数据。
    优点：减轻负载均衡服务器的压力，不需要要实现ip_hasp算法来转发请求。
    缺点：复制时宽带开销大，访问量大的话session占用内存大且浪费。

3. Session数据集中存储

    session数据集中存储就是利用数据库来存储session数据，实现了session和应用服务器的解耦。
    优点：相比session replication的方案，集群间对于宽带和内存的压力减少了很多。
    缺点：需要维护存储session的数据库。

4. Cookie Base

    cookie base就是把session存在cookie中，有浏览器来告诉应用服务器我的session是什么，同样实现了session和应用服务器的解耦。
    优点：实现简单，基本免维护。
    缺点：cookie长度限制，安全性低，宽带消耗。
