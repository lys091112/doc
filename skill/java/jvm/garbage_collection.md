# JVM 垃圾回收算法和回收器详情


## GC Roots
java中可以作为GC Roots中的对象有：
- 虚拟机栈中的引用对象
- 方法区中的类静态属性引用对象
- 方法区中的常量引用对象
- 本地方法栈，即一帮的Native引用对象


## 垃圾回收算法

- 标记清除
     主要的缺点是会造成大量的空间碎片，因为回收后的空间不是连续的，这样在进行大对象分配内存的时候可能会触发full gc
```
    标记清除垃圾回收分为两个阶段： 标记阶段和清除阶段。 
    标记阶段: 首先通过根节点，标记所有从根节点开始的对象，未备标记的对象就是未被引用的对象，可以备回收。
    清除阶段: 清除所有未被标记的对象
```

- 复制算法
  将现有内存空间分为两块， 每次只使用其中的一块， 在进行垃圾回收时，将正在使用的内存块中的祸对象复制到未被使用的内存块中，然后清楚正在使用的内存块，交互内存角色，完成垃圾回收
```
java的新生代就是使用这种算法:
IBM的研究表明新生代中大约98%的对象时朝闻夕死的对象 ,因此未将内存空间按照1:1的比例进行分配，而是将内存空间
分为一块Eden和2块Survivor,每次只使用一块Eden和一块Survivor，将另一块Survivor作为垃圾回收时的拷贝空间，
然后清理掉Eden和刚使用过的Survivor。 在HotSpot中，默认的比例为： Eden:Survivor = 8:1，即每次使用新生代内存的90%，
只有10%未被使用，当然我们无法保证回收后的对象一定小于10%，当空间不够时，需要依赖老年代进行分配担保
```

- 标记整理
  在老年代中，垃圾回收时大部分对象都是存活状态，这点和新生代有点不太一样， 所以使用复制算法的成本太高，标记整理（标记压缩）算法是在标记清除的基础上做了一点优化。
```
    首先： 从根节点对所有可达对象进行一次标记，之后，将所有可达的对象压缩到内存的一端，再之后清理边界外（即压缩后的空间之外）的所有空间， 避免碎片的产生，也不需要两块相同的内存空间。
```

- 增量算法
```
基本思想： 如果一次性将所有的内存垃圾进行处理， 那么需要造成系统长时间的停顿， 因为为了减少系统的停顿时间，可以让垃圾收集线程和应用线程交替执行，每次只收集一小块区域内存，依次反复，知道垃圾回收完成。 依据这种方式，能够减少系统停顿时间， 但是因为线程切换和上下文转换的消耗， 使垃圾回收的总成本提高，从而造成系统吞吐量下降
```

## 垃圾收集器

- Serial 收集器
    Serial收集器是最早的串行化收集器，主要缺点是在进行垃圾回收时，会暂停用户的所有进程（STW ），目前仍然是运行在client模式下的默认新生代收集器， 对于限定的单CPU环境来说， Serial由于没有线程的交互开销，因此可以获取较高的收集效率

    Serial Old 是Serial收集器的老年版本， 也是一个单线程收集器， 他使用标记-整理算法， 主要是被client模式下的虚拟机使用。 在Server模式下，他的主要用途: 1.5之前和Paraller Scanvenge收集器搭配使用， 另一个是：作为CMS收集器的后背预案，在并发收集发生Concurrent Mode Failure时使用

    使用参数： -UseSerialGC 使用Serial + Serial Old

    ** Concurrent Mode Failure是什么**

- ParNew收集器
    ParNew收集器是Serial的多线程版本，在进行垃圾回收时，仍然会STW

    ParNew在单CPU环境下并不会比Serial更好，甚至由于存在线程交互的开销，在通过超线程技术实现的两个CPU的环境中都不能百分百保证超过Serial收集器。但当CPU多到一定数量时，对于GC时的系统资源利用还是很好的。 默认开启的线程数是和CPU数量相同， 可以通过-XX:ParallelGCThreads来限制垃圾回收的线程数量

    使用参数： -UseParNewGC 使用ParNew  + Serial Old


- Parallel Scanvenge 收集器

    Paralllel 是采用复制算法的多线程新生代垃圾回收器， 和ParNew新生代收集器有很多相似处。 Parallel Scanvenge 的一个特点是关注的目标是吞吐量，（吞吐量 = 用户代码运行时间／（用户代码运行时间+垃圾收集时间）。 停顿的越短，越有利于用户交互程序。 高吞吐量可以高效率的使用CPU时间， 使尽快的完成程序的运算任务， 主要用于后台运算但交互不多的任务

    Parallel Old是parallel Scanvenge的老年代版本， 采用多线程和标记-整理算法， 版本在1.6之后， 此前， 新生代的Parallel Scanvenge收集器使用地方限制较大， 原因是：如果新生代使用Parallel Scanvenge，那么老年代只能使用Serial Old(Ps MarkSWeep(实际上是标记整理MarkCompact)). 但由于老年代Serial Old 在服务端性能上的拖累，因此即便使用了Parallel Scanvenge 也无法在整体应用上获取吞吐量的最大化效果， 有因为老年代无法利用多CPU的处理能力， 因此在老年代很大的高级环境中，使用不一定有ParNew+CMS能力出众， Parallel Old的出现，可以说Parallel才有了使用的价值， 在注重吞吐量和Cpu资源敏感的场合，可以优先考虑Parallel Scanvenge + Parallel Old

    -UseParallelGC: 在Server模式下的默认值 使用 Parallel Scanvenge + Serial Old .  -UseParallelOldGC: 使用Parallel Scanvenge + Parallel Old

- CMS 收集器

    CMS（Concurrent Mark Sweep)，当前最流程的垃圾回收器， 是一种以最短回收停顿时间为目标的收集器， 很适合用于用户交互。 基于标记-清除算法，收集过程分为四个步骤：
    1. 初始标记（initial mark 会产生STW）
    2. 并发标记（concurrent mark)
    3. 重新标记（remark 会产生STW)
    4. 并发清除（concurrent sweep)
时间主要耗费在2 和 4 阶段

由于CMS是基于标记清除算法实现， 因此会导致有大量的空间碎片产生， 在为大对象分配内存时，往往会出现老年代还有大量剩余空间，但却无法找到连续空间来分配，因此不得不开启一次Full GC。为解决这个问题，CMS提供参数：-XX:UseCMSCompactAtFullCollection(默认开启)，用于在CMS收集器进行FUllGC后开启碎片的合并整理过程，内存整理过程无法进行并发，因此会导致停顿时间变长。 另一个参数：-XX:CMSFullGCsBeforCompaction参数用于设置执行多少次不压缩后的Full GC，然后进行一次带压缩的Full GC（默认为0， 表示每次FULL GC都进行碎片整理）。

做为老年代收集器，却无法和jdk1.4种的Parallel Scanvenge收集器配合工作， u 因此使用CMS时，只能选择ParNew和Serial收集器中的一个。 使用-XX:UseConcMarkSweepGC来默认使用ParNew收集器。 也可以通过-XX:UseParNewGCl来强制使用

```
CMS的常用参数：

UseCMSInitatingOccupancyOnly: 只有达到阙值时，才进行CMS回收

-XX:CMSParallelRemarkEnabled 开启并行remark
-XX:CMSScanvengeBeforRemark 强制remark前，会开启一次minor gc
-XX:+ParallelCMSThreads CMS垃圾回收线程数，默认为：（ParallelGCThreads + 3)/4 
-XX:CMSInitatingPermOccupancyFraction: 当永久区占有率达到一定比例，进行垃圾回收（前提：-XX:CMSClassUnloadingEnabled)

-XX:+DisablExplicitGC 用来显示禁止System.gc()
```

- G1 收集器

    G1用于服务器端的垃圾收集器， 相比于其他的垃圾收集器， 具备如下特点：
        1. 并发与并行： G1更充分使用CPU，多核环境来缩短STW停顿时间
        2. 分代收集： 分代概念在G1中任然存在，但G1可以独自管理整个GC堆
        3. 空间整合： G1有利于程序的长时间运行， 分配大对象时不会无法得到连续空间而触发一次GC
        4. 可预测非停顿：能让使用者明确指定一个长度为M毫秒的时间片段内，消耗在垃圾收集上的时间不得超过N毫秒
        
    G1将java堆分成多个大小相等的独立区域，虽保留新生代老生代的概念，但是不在是物理隔离的，他们都是一部分Region空间集合

