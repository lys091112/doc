# 负载均衡



##  常见的负载均衡解决方法

1. Http重定向

    HTTP重定向就是应用层的请求转发。用户的请求其实已经到了HTTP重定向负载均衡服务器，服务器根据算法要求用户重定向，用户收到重定向请求后，再次请求真正的集群
    优点：简单。
    缺点：性能较差。

2. DNS域名解析负载均衡

    DNS域名解析负载均衡就是在用户请求DNS服务器，获取域名对应的IP地址时，DNS服务器直接给出负载均衡后的服务器IP
    优点：交给DNS，不用我们去维护负载均衡服务器。
    缺点：当一个应用服务器挂了，不能及时通知DNS，而且DNS负载均衡的控制权在域名服务商那里，网站无法做更多的改善和更强大的管理

3. 反向代理服务器

    在用户的请求到达反向代理服务器时（已经到达网站机房），由反向代理服务器根据算法转发到具体的服务器。常用的apache，nginx都可以充当反向代理服务器。
    优点：部署简单。
    缺点：代理服务器可能成为性能的瓶颈，特别是一次上传大文件。

4. IP层负载均衡

    在请求到达负载均衡器后，负载均衡器通过修改请求的目的IP地址，从而实现请求的转发，做到负载均衡。
    优点：性能更好。
    缺点：负载均衡器的宽带成为瓶颈

5. 数据链路层负载均衡

    在请求到达负载均衡器后，负载均衡器通过修改请求的mac地址，从而做到负载均衡.
    与IP负载均衡不一样的是，当请求访问完服务器之后，直接返回客户。而无需再经过负载均衡器。


## 负载均衡常用算法
1. rr (轮询调度算法)

    轮询分发请求。
    优点：实现简单
    缺点：不考虑每台服务器的处理能力

2. wrr (加权调度算法)

    每个服务器设置权值weight，负载均衡调度器根据权值调度服务器，服务器被调用的次数跟权值成正比。
    优点：考虑了服务器处理能力的不同

3. sh (原地址散列)

    提取用户IP，根据散列函数得出一个key，再根据静态映射表，查处对应的value，即目标服务器IP。过目标机器超负荷，则返回空。

4. dh (目标地址散列)

    同上，只是现在提取的是目标地址的IP来做哈希。
    优点：以上两种算法的都能实现同一个用户访问同一个服务器。

5. lc (最少连接)

    优先把请求转发给连接数少的服务器。
    优点：使得集群中各个服务器的负载更加均匀。

6. wlc (加权最少连接)

    在lc的基础上，为每台服务器加上权值。算法为：（活动连接数*256+非活动连接数）÷权重 ，计算出来的值小的服务器优先被选择。
    优点：可以根据服务器的能力分配请求。

7.  sed (最短期望延迟)

    其实sed跟wlc类似，区别是不考虑非活动连接数。算法为：（活动连接数+1)*256÷权重，同样计算出来的值小的服务器优先被选择。

8. nq (永不排队)

    改进的sed算法。我们想一下什么情况下才能“永不排队”，那就是服务器的连接数为0的时候，那么假如有服务器连接数为0，均衡器直接把请求转发给它，无需经过sed的计算。

9. LBLC (基于局部性的最少连接)

    均衡器根据请求的目的IP地址，找出该IP地址最近被使用的服务器，把请求转发之，若该服务器超载，最采用最少连接数算法。

10. LBLCR (带复制的基于局部性的最少连接)

    均衡器根据请求的目的IP地址，找出该IP地址最近使用的“服务器组”，注意，并不是具体某个服务器，然后采用最少连接数从该组中挑出具体的某台服务器出来，把请求转发之。若该服务器超载，那么根据最少连接数算法，在集群的非本服务器组的服务器中，找出一台服务器出来，加入本服务器组，然后把请求转发之


## 负载均衡器处理完后数据的返回问题

1. NAT

    负载均衡器接收用户的请求，转发给具体服务器，服务器处理完请求返回给均衡器，均衡器再重新返回给用户。

2. DR

    负载均衡器接收用户的请求，转发给具体服务器，服务器出来玩请求后直接返回给用户。需要系统支持IP Tunneling协议，难以跨平台。

3. TUN

    同上，但无需IP Tunneling协议，跨平台性好，大部分系统都可以支持






## other
nginx目前支持的负载均衡算法有wrr、sh（支持一致性哈希）、fair（本人觉得可以归结为lc）。但nginx作为均衡器的话，还可以一同作为静态资源服务器。

keepalived+ipvsadm比较强大，目前支持的算法有：rr、wrr、lc、wlc、lblc、sh、dh

keepalived支持集群模式有：NAT、DR、TUN