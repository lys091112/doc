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


### java线程的7中状态

1. 新建状态(New
2. 就绪状态(Runnable)

```
代表执行start之后,变成就绪状态，就绪状态的线程并不一定立即运行run()方法，线程还必须同其他就绪线程竞争CPU，只有获得CPU使用权才可以运行线程
```
3. 运行状态(Running)

```
    调用start之后
```
4. 阻塞状态(Blocked)

```
线程在获取锁失败时(因为锁被其它线程抢占)，它会被加入锁的同步阻塞队列，然后线程进入阻塞状态(Blocked)。处于阻塞状态(Blocked)的线程放弃CPU使用权，暂时停止运行。待其它线程释放锁之后，阻塞状态(Blocked)的线程将在次参与锁的竞争，如果竞争锁成功，线程将进入就绪状态(Runnable) 
```

5. 等待状态(WAITING)

```
或者叫条件等待状态，当线程的运行条件不满足时，通过锁的条件等待机制(调用锁对象的wait()或显示锁条件对象的await()方法)让线程进入等待状态(WAITING)。处于等待状态的线程将不会被cpu执行，除非线程的运行条件得到满足后，其可被其他线程唤醒，进入阻塞状态(Blocked)。调用不带超时的Thread.join()方法也会进入等待状态
```

6. 限时等待状态(TIMED_WAITING)

```
限时等待是等待状态的一种特例，线程在等待时我们将设定等待超时时间，如超过了我们设定的等待时间，等待线程将自动唤醒进入阻塞状态(Blocked)或就绪状态(Runnable) 。在调用Thread.sleep()方法，带有超时设定的Object.wait()方法，带有超时设定的Thread.join()方法等，线程会进入限时等待状态(TIMED_WAITING)
```

7. 死亡状态(TERMINATED)

### 后台线程(deamon)

定义：指在程序运行的时候在后台提供一种通用服务的线程，并且这种线程并不属于程序中不可或缺的部分 ,所有的“非后台线程”结束时，程序也就终止了，同时会杀死进程中所有后台线程：main就是一个非后台线程


1. 多线程中的wait与sleep

- wait 是object类方法 sleep是thread方法

- 调用wait方法前，首先需要获取锁对象，调用wait后会自动释放锁，等notify／notifyall来唤醒，然后重新获取锁资源, 调用sleep之后，并没有释放锁，线程仍处于同步控制状态，sleep不会让出系统资源sleep方法会自动唤醒，如果时间不到，想要唤醒，可以使用interrupt方法强行打断。

2. Thread.onSpinWait() 对比 Thread.sleep()

    Thread.onSpinWait()在执行等待时，会先进行自旋。所谓自旋就是在CPU运转的周期内，如果条件满足了，就不会再进入内核等待（即暂停该线程，等待一段时间后，再继续运行该线程），如果条件不满足，才进入内核等待。这样一来，SpinWait会比Thread.Sleep多运行一次的CPU周期，再进入等待。因为CPU周期是很短的(现在一般的电脑都有2.1GHZ以上)，所以这个等待对时间影响不大，却可以提升很大的性能

3. 为何wait需要先获取锁

    一种安全设计，为了防止wait错过notify, 
    ```
    boolean wakeuped = false;
     void dowait()
     {
      if(wakeuped)
         return;
      wait();
     }

     void wakeup()
     {
       wakeuped = true;
       notify();
     }

     存在如下执行逻辑：
     [wait thread  ] if(wakeuped) return;//wakeuped is false;
    [notify thread] wakeuped=true;// wakeuped is true
    [notify thread] notify();//此时wait线程没有进入wait,
    [wait thread  ] wait();//wakuped is true,此时进入wait，而notify先于wait执行，此时wait将不会被唤醒。

    在dowait和wakeup两个方法上加上同步锁保护，则可以保证不会出现上面的执行顺序。wakeup要么先于dowait执行，要么在dowait线程进入wait后才能执行。这样通过互斥锁来保证wait()/notify()之间的先后顺序，才能保证wait不会错过notify，从而导致wait线程一直挂着
    ```

    这和LockSupport又不一样， LocKSupport.park LockSupport.unpart(thread) 则没有先后顺序，代表的只是 ``permit`` 的许可，但不论先执行了多少次unpark ,执行park时都会被清空


``TIP``

    sleep 到时间后，不一定护被立刻唤醒，而是要等待系统资源调度后才被唤醒。 sleep(0) 其实相当于一次认为的中断,线程重新进入就绪状态，等待被重新唤醒


### 同步和异步的区别

    1. 同步调用，每个线程都需要等待，任务量大时会造成数据的阻塞. （往往需要加大线程数)
    2. 异步调用，直接发送请求，然后通过回调异步线程进行处理。 (节省线程数量，提高处理速度)

### java 中常用的阻塞

    1. LockSupport.part(blocker, fasle) 用于阻塞当前线程，blocker是阻塞的对象，多用于排查问题

### 线程中断

    1. thread.interrupt(); 这个用来中断线程
    2. interrupted():测试当前线程是否中断。 该方法可以清除线程的中断状态
    3. isInterrupted():测试这个线程是否被中断。 线程的中断状态不受此方法的影响

    guava的Uninterruptibles.awaitUninterruptibly 即不允许中断等待，即便线程被中断也会继续等待，只在最后的finally中检测是否有过等待，然后再一次进行等待


    interrupt 只是针对Object.wait, Thread.join和Thread.sleep 这三种阻塞方法，才会抛出InterruptException, 而且但异常被抛出之后，中断状态已经被系统复位。

    我们一般检测isInterrupted()时，如果中断没有被抛出异常，那么这时是当前的线程状态，如果已经抛出过异常，那么当前是被系统复位后的状态

``TIP``

    join 会阻塞线程的执行
    yield 线程让步，释放cpu占用，等待下一次被调用 但不会释放所，也不会响应中断
    wait 调用wait方法需要先获取锁，然后wait过程中会释放锁，等被notify后会再次尝试获取锁
    sleep 进入阻塞状态

## ThreadLocal

```
每个thread中都存在一个map, map的类型是ThreadLocal.ThreadLocalMap. Map中的key为一个threadlocal实例. 这个Map的确使用了弱引用,不过弱引用只是针对key. 每个key都弱引用指向threadlocal. 当把threadlocal实例置为null以后,没有任何强引用指向threadlocal实例,所以threadlocal将会被gc回收. 但是,我们的value却不能回收,因为存在一条从current thread连接过来的强引用. 只有当前thread结束以后, current thread就不会存在栈中,强引用断开, Current Thread, Map, value将全部被GC回收.

但在threadLocal设为null和线程结束这段时间不会被回收的，就发生了我们认为的内存泄露

ThreadLocal内存泄漏的根源是：由于ThreadLocalMap的生命周期跟Thread一样长，如果没有手动删除对应key的value就会导致内存泄漏，而不是因为弱引用
```
