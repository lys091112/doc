
1. nextFreeTicketMicros 他们的含义和作用

::

    含义： 
    1. 每次当有新线程请求acquire时，会去检测当前的时间与改值的大小，然后更新在这段时间内新产生的store数量
    2. 判断当前的store数量是否满足需求，然后计算出满足需求时的时刻，那么其他线程来时，表示这段时间之前的strore已经被预支了，新的线程需要sleep到该时刻之后才可以申请


ralelimiter 并不是严格的速率控制，例如limit.create(10),然后申请limit.acquire(100), 那么他会执行完，但会将nextFreeTicketMicros预支到10s后，其他线程在使用的时候，必须要等到10s之后才能执行。 

多个线程执行同一个limiter的时候，就会出现该请求，对于请求数不满足的线程会等待到满足的时刻

一般情况下我么不会申请超过该限制的参数



