# FutureTask


## 1.  JDK1.8中重新FutureTask的意图:( handlePossibleCancellationInterrupt方法)
``` java

    /** 
     * 保证了中断方法的执行只会发生在当前线程中。 
       但是产生的影响: 强制中断只下发到正在执行中或者是重置后的任务中(即引起的中断异常)
     * Ensures that any interrupt from a possible cancel(true) is only
     * delivered to a task while in run or runAndReset.
     */
    private void handlePossibleCancellationInterrupt(int s) {
        // It is possible for our interrupter to stall before getting a
        // chance to interrupt us.  Let's spin-wait patiently.
        if (s == INTERRUPTING)
            //如果任务状态是中断中，则一直等待
            while (state == INTERRUPTING)
                Thread.yield(); // wait out pending interrupt

        // assert state == INTERRUPTED;

        // We want to clear any interrupt we may have received from
        // cancel(true).  However, it is permissible to use interrupts
        // as an independent mechanism for a task to communicate with
        // its caller, and there is no way to clear only the
        // cancellation interrupt.
        // 这里的state状态一定是INTERRUPTED;
        // 这里不能清除中断标记，因为没办法区分来自cancel(true)的中断。(即中断可能会传递到线程的下一个task)
        // Thread.interrupted();
    }
```

- 1. 该方法的作用
  - 确保在run执行完之前，当前线程一定执行了interrupt()操作，具体可以参见cancelcel方法的实现。
  - 该方法的实现是通过while循环来实现的，如果任务状态是中断中，则一直等待，直到任务状态变为中断完成。
  - 防止资源泄漏，如果没有等待中断完成，可能会在清理过程中丢失中断信号

- 2. 为何要把Thread.interrupted() 注释掉？
  想避免在执行取消的循环中runner还一直保持中断状态，所以想在取消的循环中重置runner的中断状态，但是又考虑到如下事实：程序员设计程序时可能使用中断作为task和caller之间的通信。所以贸然的清除中断标志，可能会给程序设计者带来不便，所以既然不能保证一定是cancel(true)导致的中断，那么就不清除了，最终将最后一行注释了。所以最终的结果还是让runner保持中断状态。（基于jdk1.8.0_65版本

