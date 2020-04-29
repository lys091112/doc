系统网络
========

查询当前系统网络  TIME_WAIT, CLOSE_WAIT ESTABLISHED 数量
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'


TCP端口状态说明
:::::::::::::::::::::

::

    LISTENING状态 服务启动后首先处于侦听（LISTENING）状态

    ESTABLISHED 建立连接。表示两台机器正在通信

    CLOSE_WAIT 对方主动关闭连接或者网络异常导致连接中断，这时我方的状态会变成CLOSE_WAIT 此时我方要调用close()来使得连接正确关闭

    TIME_WAIT 我方主动调用close()断开连接，收到对方确认后状态变为TIME_WAIT

    SYN_SENT状态


TCP协议中有TIME_WAIT这个状态, 主要有两个原因

1. 防止上一次连接中的包，迷路后重新出现，影响新连接, 在迷途期间，TCP发送端可能因确认超时而重发这个分节，迷途的分节在路由器修复后也会被送到最终目的地，这个原来的迷途分节就称为lost duplicate。 在关闭一个TCP连接后，马上又重新建立起一个相同的IP地址和端口之间的TCP连接，后一个连接被称为前一个连接的化身（incarnation)，那么有可能出现这种情况，前一个连接的迷途重复分组在前一个连接终止后出现，从而被误解成从属于新的化身。
为了避免这个情况，TCP不允许处于TIME_WAIT状态的连接启动一个新的化身，因为TIME_WAIT状态持续2MSL，就可以保证当成功建立一个TCP连接的时候，来自连接先前化身的重复分组已经在网络中消逝。

2. 可靠的关闭TCP连接。在主动关闭方发送的最后一个 ack(fin) ，有可能丢失，这时被动方会重新发
fin, 如果这时主动方处于 CLOSED 状态 ，就会响应 rst 而不是 ack。所以主动方要处于 TIME_WAIT 状态，而不能是 CLOSED
