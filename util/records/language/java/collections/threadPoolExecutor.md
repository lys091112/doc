## ThreadPoolExecutor 源码

## 1. 状态标识

```java
// 前3位代表状态， 后29位代表线程数
Integer ctl = new AtomicInteger(ctlOf(RUNNING, 0));

private static final int COUNT_BITS = Integer.SIZE - 3;         //29
private static final int CAPACITY   = (1 << COUNT_BITS) - 1;    //536870911     00011111111111111111111111111111

// RUN_STATE is stored in the high-order bits
private static final int RUNNING    = -1 << COUNT_BITS;         //-536870912    11100000000000000000000000000000
private static final int SHUTDOWN   =  0 << COUNT_BITS;         //0             00000000000000000000000000000000
private static final int STOP       =  1 << COUNT_BITS;         //536870912     00100000000000000000000000000000
private static final int TIDYING    =  2 << COUNT_BITS;         //1073741824    01000000000000000000000000000000
private static final int TERMINATED =  3 << COUNT_BITS;         //1610612736    01100000000000000000000000000000



// 当前线程池状态
private static int runStateOf(int c)     { return c & ~CAPACITY; }  // RUN_STATE & ~CAPACITY = RUN_STATE
// 活跃线程数
private static int workerCountOf(int c)  { return c & CAPACITY; }   // RUN_STATE & CAPACITY = 0
// ctl值
private static int ctlOf(int rs, int wc) { return rs | wc; }


```