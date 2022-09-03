# java 线程池

## 基础介绍

- **ThreadPoolExecutor参数信息**

| 参数名 | 作用|
|-------|-------|
| corePoolSize | 核心线程池大小|
| maximumPoolSize| 最大线程池大小 |
| keepAliveTime| 线程池中超过corePoolSize数目的空闲线程最大存活时间 |
| timeUnit | keepAliveTime时间单位 |
| workQueue| 阻塞任务队列|
| threadFactory | 新建线程工程，常用来制定线程名称等 |
| RejectedExecutionHandler | 当提交任务数超过maxmumPoolSize+workQueue之和时，任务会交给RejectedExecutionHandler来处理 |

- **corePoolSize, workQueue, maximumPoolSize 的关系**

```
有新的任务时：
    当线程数小于核心线程数时，创建新线程。
    当线程数大于等于核心线程数，且任务队列未满时，将任务放入任务队列，此时不会创建新线程。
    当线程数大于等于核心线程数，且任务队列已满
    若线程数小于最大线程数，创建新线程
    若线程数等于最大线程数，抛出异常，拒绝任务
```

- **常用的线程池**
- **常用的任务队列**


ForkJoinPool:

    默认的线程数为： Runtime.getRuntime().availableProcessors() - 1
    在docker虚拟的环境下，会使用物理机的核数来建立线程数，所以这里需要手动调整数据
    通过系统参数java.util.concurrent.ForkJoinPool.common.parallelism 来设置并发度


## 5. Question

### 1. Junit 会自动中断为执行完的用户线程

    我们在使用JUnit测试功能时，如果涉及到多线程，会发现用户线程即便没有执行完，也会被强制中断， 这是因为在``JunitCore`` 中，会执行``System.exit(0 or 1)`` 来中断jvm的执行
    因此 Junit并不适合用来测试多线程，如果要测试，可以在Test方法中通过类似``CountDownLatch.await()``的方式来进行等待,延迟方法执行完成时间