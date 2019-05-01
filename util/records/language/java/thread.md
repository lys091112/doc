# Thread 之间的状态转化

转化图示：

![线程转化状态](../pictures/thread-status.jpg)


状态说明：

1. 新建(new)：新创建了一个线程对象。

2. 可运行(runnable)：线程对象创建后，其他线程(比如main线程）调用了该对象的start()方法。该状态的线程位于可运行线程池中，等待被线程调度选中，获取cpu 的使用权 。

3. 运行(running)：可运行状态(runnable)的线程获得了cpu 时间片（timeslice） ，执行程序代码。

4. 阻塞(block)：阻塞状态是指线程因为某种原因放弃了cpu 使用权，也即让出了cpu timeslice，暂时停止运行。直到线程进入可运行(runnable)状态，才有机会再次获得cpu timeslice 转到运行(running)状态。阻塞的情况分三种：

    (一). 等待阻塞：运行(running)的线程执行o.wait()方法，JVM会把该线程放入等待队列(waitting queue)中。

    (二). 同步阻塞：运行(running)的线程在获取对象的同步锁时，若该同步锁被别的线程占用，则JVM会把该线程放入锁池(lock pool)中。

    (三). 其他阻塞：运行(running)的线程执行Thread.sleep(long ms)或t.join()方法，或者发出了I/O请求时，JVM会把该线程置为阻塞状态。当sleep()状态超时、join()等待线程终止或者超时、或者I/O处理完毕时，线程重新转入可运行(runnable)状态。

5. 死亡(dead)：线程run()、main() 方法执行结束，或者因异常退出了run()方法，则该线程结束生命周期。死亡的线程不可再次复生。



### 后台线程(deamon)

定义：指在程序运行的时候在后台提供一种通用服务的线程，并且这种线程并不属于程序中不可或缺的部分 ,所有的“非后台线程”结束时，程序也就终止了，同时会杀死进程中所有后台线程：main就是一个非后台线程


1. 多线程中的wait与sleep

- wait 是object类方法 sleep是thread方法

- 调用wait方法前，首先需要获取锁对象，调用wait后会自动释放锁，等notify／notifyall来唤醒，然后重新获取锁资源, 调用sleep之后，并没有释放锁，线程仍处于同步控制状态，sleep不会让出系统资源sleep方法会自动唤醒，如果时间不到，想要唤醒，可以使用interrupt方法强行打断。

2. Thread.onSpinWait() 对比 Thread.sleep()

    Thread.onSpinWait()在执行等待时，会先进行自旋。所谓自旋就是在CPU运转的周期内，如果条件满足了，就不会再进入内核等待（即暂停该线程，等待一段时间后，再继续运行该线程），如果条件不满足，才进入内核等待。这样一来，SpinWait会比Thread.Sleep多运行一次的CPU周期，再进入等待。因为CPU周期是很短的(现在一般的电脑都有2.1GHZ以上)，所以这个等待对时间影响不大，却可以提升很大的性能


``TIP``

    sleep 到时间后，不一定护被立刻唤醒，而是要等待系统资源调度后才被唤醒。 sleep(0) 其实相当于一次认为的中断,线程重新进入就绪状态，等待被重新唤醒
