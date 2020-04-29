# JVM 垃圾回收

[TOC]

## 对象引用的四种级别

1、强引用

最普遍的一种引用方式，如String s = "abc"，变量s就是字符串“abc”的强引用，只要强引用存在，则垃圾回收器就不会回收这个对象。

2、软引用（SoftReference）

软引用是用来描述一些有用但并不是必需的对象，在Java中用java.lang.ref.SoftReference类来表示。对于软引用关联着的对象，只有在内存不足的时候JVM才会回收该对象。因此，这一点可以很好地用来解决OOM的问题，并且这个特性很适合用来实现缓存：比如网页缓存、图片缓存等。

如果内存足够，不回收，如果内存不足，则回收。一般用于实现内存敏感的高速缓存，软引用可以和引用队列ReferenceQueue联合使用，如果软引用的对象被垃圾回收，JVM就会把这个软引用加入到与之关联的引用队列中。

3、弱引用（WeakReference）

弱引用和软引用大致相同，弱引用与软引用的区别在于：只具有弱引用的对象拥有更短暂的生命周期。在垃圾回收器线程扫描它所管辖的内存区域的过程中，一旦发现了只具有弱引用的对象，不管当前内存空间足够与否，都会回收它的内存。

弱引用可以和一个引用队列（ReferenceQueue）联合使用，如果弱引用所引用的对象被JVM回收，这个弱引用就会被加入到与之关联的引用队列中

4、虚引用（PhantomReference）

虚引用和前面的软引用、弱引用不同，它并不影响对象的生命周期。在java中用java.lang.ref.PhantomReference类表示。如果一个对象与虚引用关联，则跟没有引用与之关联一样，在任何时候都可能被垃圾回收器回收

虚引用必须和引用队列关联使用，当垃圾回收器准备回收一个对象时，如果发现它还有虚引用，就会把这个虚引用加入到与之 关联的引用队列中。程序可以通过判断引用队列中是否已经加入了虚引用，来了解被引用的对象是否将要被垃圾回收。如果程序发现某个虚引用已经被加入到引用队列，那么就可以在所引用的对象的内存被回收之前采取必要的行动

虚引用主要用来跟踪对象被垃圾回收器回收的活动。

```java

public void check() {
        // thread.setDaemon(true);
        new Thread(() -> {
        try {
            int cnt = 0;
            WeakReference<byte[]> k;
            while((k = (WeakReference) referenceQueue.remove()) != null) {
                System.out.println((cnt++) + "回收了:" + k);
            }
        } catch(InterruptedException e) {
            //结束循环
        }
        }).start();
    }

```

## JVM内存结构

1. GC 内存组成： 堆(Heap)和非堆(Non-heap)内存

   Java 虚拟机具有一个堆，堆是运行时数据区域，所有类实例和数组的内存均从此处分配。堆是在 Java 虚拟机启动时创建的

   非堆: 方法区、JVM内部处理或优化所需的内存(如JIT编译后的代码缓存)、每个类结构(如运行时常数池、字段和方法数据)以及方法和构造方法 的代码都在非堆内存中

2. 组成包含
    1. 方法栈&本地方法栈 线程创建时产生,方法执行时生成栈帧
    2. 方法区 存储类的元数据信息 常量池
    3. 堆
    4. 堆外内存 native Memory(C heap) Direct Bytebuffer JNI Compile GC;

3. 堆内存分配

   堆内存分为 young  和 old
     Young Generation = Eden + From space + to space
         Eden 存放新生对象
         survivor Space 有两个，存放每次垃圾回收后存活的对象

     Old Generation 主要存放应用程序中生命周期长的存活对象

   非堆内存分配

## 垃圾回收算法

### 引用计数法

引用计数算法（Reachability Counting）是通过在对象头中分配一个空间来保存该对象被引用的次数（Reference Count）。如果该对象被其它对象引用，则它的引用计数加1，如果删除对该对象的引用，那么它的引用计数就减1，当该对象的引用计数为0时，那么该对象就会被回收

缺点： 会造成循环引用，从而引起内存泄漏

```java
    public class ReferenceCountingGC {

        public Object instance;

        public ReferenceCountingGC(String name){}
    }

    public static void testGC(){

        ReferenceCountingGC a = new ReferenceCountingGC("objA");
        ReferenceCountingGC b = new ReferenceCountingGC("objB");

        a.instance = b;
        b.instance = a;

        a = null;
        b = null;
    }
```

### 可达性分析

可达性分析算法（Reachability Analysis）的基本思路是，通过一些被称为引用链（GC Roots）的对象作为起点，从这些节点开始向下搜索，搜索走过的路径被称为（Reference Chain)，当一个对象到 GC Roots 没有任何引用链相连时（即从 GC Roots 节点到该节点不可达），则证明该对象是不可用的

#### GC Roots

java中可以作为GC Roots中的对象有：

- 虚拟机栈中的引用对象
- 方法区中的类静态属性引用对象
- 方法区中的常量引用对象

    ``方法区中的常量引用，也为 GC Root，外对象被 置为 null 后，final 对象也不会因没有与 GC Root 建立联系而被回收``
- 本地方法栈，即一般的Native引用对象

    ``任何 Native 接口都会使用某种本地方法栈，实现的本地方法接口是使用 C 连接模型的话，那么它的本地方法栈就是 C 栈。当线程调用 Java 方法时，虚拟机会创建一个新的栈帧并压入 Java 栈。然而当它调用的是本地方法时，虚拟机会保持 Java 栈不变，不再在线程的 Java 栈中压入新的帧，虚拟机只是简单地动态连接并直接调用指定的本地方法``

### 可达性垃圾回收算法

- 标记清除
   主要的缺点是会造成大量的空间碎片，因为回收后的空间不是连续的，这样在进行大对象分配内存的时候可能会触发full gc

   标记清除垃圾回收分为两个阶段： 标记阶段和清除阶段。
   1. 标记阶段: 首先通过根节点，标记所有从根节点开始的对象，未备标记的对象就是未被引用的对象，可以备回收。
   2. 清除阶段: 清除所有未被标记的对象

- 复制算法

  将现有内存空间分为两块， 每次只使用其中的一块， 在进行垃圾回收时，将正在使用的内存块中的祸对象复制到未被使用的内存块中，然后清楚正在使用的内存块，交互内存角色，完成垃圾回收, 缺点很明显，需要浪费一半的空间

- 标记整理

  标记整理算法（Mark-Compact）标记过程仍然与标记 --- 清除算法一样，但后续步骤不是直接对可回收对象进行清理，而是让所有存活的对象都向一端移动，再清理掉端边界以外的内存区域
  标记整理算法一方面在标记-清除算法上做了升级，解决了内存碎片的问题，也规避了复制算法只能利用一半内存区域的弊端。看起来很美好，但从上图可以看到，它对内存变动更频繁，需要整理所有存活对象的引用地址，在效率上比复制算法要差很

  首先： 从根节点对所有可达对象进行一次标记，之后，将所有可达的对象压缩到内存的一端，再之后清理边界外（即压缩后的空间之外）的所有空间， 避免碎片的产生，也不需要两块相同的内存空间。

- G1增量算法

  基本思想： 如果一次性将所有的内存垃圾进行处理， 那么需要造成系统长时间的停顿， 因为为了减少系统的停顿时间，可以让垃圾收集线程和应用线程交替执行，每次只收集一小块区域内存，依次反复，知道垃圾回收完成。 依据这种方式，能够减少系统停顿时间， 但是因为线程切换和上下文转换的消耗， 使垃圾回收的总成本提高，从而造成系统吞吐量下降

### java 内存模型和回收策略

java 的内存分为新生代(Young)和老年代(Old) 一半老年代占用 $\frac {2}{3}$ 左右的空间，在新生代中又分为Eden 和 2个Survivor（分别为from to）,默认比例为8:1:1.

#### Eden 区

  IBM的研究表明新生代中大约98%的对象时朝闻夕死的对象 ,因此未将内存空间按照1:1的比例进行分配，而是将内存空间
分为一块Eden和2块Survivor,每次只使用一块Eden和一块Survivor，将另一块Survivor作为垃圾回收时的拷贝空间，
然后清理掉Eden和刚使用过的Survivor。 在HotSpot中，默认的比例为： Eden:Survivor = 8:1，即每次使用新生代内存的90%，
只有10%未被使用，当然我们无法保证回收后的对象一定小于10%，当空间不够时，需要依赖老年代进行分配担保

#### Survivor区

 survivor 分为 from 和to两个区，可以只使用一个，每次回收都将存活的对象放入到to区，然后from to区功能置换

 为什么需要两个，而不是在每次回收时直接放入到老年代。
  
  因为对于新生代的大部分对象，即便在第一次不会被回收，也会在第二次 第三次时被回收
  另外由于每次都是复制到to区，因此不存在碎片垃圾问题

#### Old 区

  老年代用于存储长期存活的对象或者是一些yound无法容纳的大对象，每次GC时都会STW，old区越大，意味着执行回收时扫描的数据越多，因此使用的是标记-整理算法（old区存活的对象较多，复制算法会产生频繁的对象移动,成本较高）

#### 存活的对象

1. 大对象
 大对象指需要大量连续内存空间的对象，这部分对象不管是不是“朝生夕死”，都会直接进到老年代。这样做主要是为了避免在 Eden 区及2个 Survivor 区之间发生大量的内存复制。当你的系统有非常多“朝生夕死”的大对象时，得注意了

2. 长期存活对象
虚拟机给每个对象定义了一个对象年龄（Age）计数器。正常情况下对象会不断的在 Survivor 的 From 区与 To 区之间移动，对象在 Survivor 区中每经历一次 Minor GC，年龄就增加1岁。当年龄增加到15岁时，这时候就会被转移到老年代。

3. 动态对象年龄
 虚拟机并不重视要求对象年龄必须到15岁，才会放入老年区，如果 Survivor 空间中相同年龄所有对象大小的总合大于 Survivor 空间的一半，年龄大于等于该年龄的对象就可以直接进去老年区，无需等你“成年”

minor gc 针对的是年轻代的收集
major gc 针对的是老年代的收集
full gc 是针对的 old young perm 全部的回收

#### 回收条件

##### 触发full GC（major GC）的情况总结

1. System.gc()方法的调用

    此方法的调用是建议JVM进行Full GC,虽然只是建议而非一定,但很多情况下它会触发 Full GC,从而增加Full GC的频率,也即增加了间歇性停顿的次数。强烈影响系建议能不使用此方法就别使用，让虚拟机自己去管理它的内存，可通过通过-XX:+ DisableExplicitGC来禁止RMI调用System.gc。

2. 老年代代空间不足

    ``新生代如何进入老年代``
    1. 大对象直接进入老年代（可通过参数设置）
    2. 长期存活的对象会进入老年代（一般是存活15龄）
    3. 未达到年龄的Surviver对象也可能进入老生代（相同年龄的对象所占的总空间大于Surviver区的一半了， 那么将相同年龄的对象转入老年代）
    4. 对象优先在Eden区分配内存,但如果第一次minor GC 后，eden或Surviver满足不了，可能会有部分对象进入老年代
        老年代空间只有在新生代对象转入及创建为大对象、大数组时才会出现不足的现象，当执行Full GC后空间仍然不足，则抛出如下错误：
        java.lang.OutOfMemoryError: Java heap space 
        为避免以上两种状况引起的Full GC，调优时应尽量做到让对象在Minor GC阶段被回收、让对象在新生代多存活一段时间及不要创建过大的对象及数组。

3. 永生区空间不足

    JVM规范中运行时数据区域中的方法区，在HotSpot虚拟机中又被习惯称为永生代或者永生区，Permanet Generation中存放的为一些class的信息、常量、静态变量等数据，当系统中要加载的类、反射的类和调用的方法较多时，Permanet Generation可能会被占满，在未配置为采用CMS GC的情况下也会执行Full GC。如果经过Full GC仍然回收不了，那么JVM会抛出如下错误信息：

    java.lang.OutOfMemoryError: PermGen space 
    为避免Perm Gen占满造成Full GC现象，可采用的方法为增大Perm Gen空间或转为使用CMS GC。

4. CMS GC时出现promotion failed和concurrent mode failure

    对于采用CMS进行老年代GC的程序而言，尤其要注意GC日志中是否有promotion failed和concurrent mode failure两种状况，当这两种状况出现时可能会触发Full GC。

    promotion failed是在进行Minor GC时，survivor space放不下、对象只能放入老年代，而此时老年代也放不下造成的；concurrent mode failure是在执行CMS GC的过程中同时有对象要放入老年代，而此时老年代空间不足造成的（有时候“空间不足”是CMS GC时当前的浮动垃圾过多导致暂时性的空间不足触发Full GC）。

    对措施为：增大survivor space、老年代空间或调低触发并发GC的比率，但在JDK 5.0+、6.0+的版本中有可能会由于JDK的bug29导致CMS在remark完毕后很久才触发sweeping动作。对于这种状况，可通过设置-XX: CMSMaxAbortablePrecleanTime=5（单位为ms）来避免。

5. 统计得到的Minor GC晋升到旧生代的平均大小大于老年代的剩余空间(YGC时的悲观策略)

    这是一个较为复杂的触发情况，Hotspot为了避免由于新生代对象晋升到旧生代导致旧生代空间不足的现象，在进行Minor GC时，做了一个判断，如果 前统计所得到的Minor GC晋升到旧生代的平均大小大于旧生代的剩余空间，那么就直接触发Full GC。
    例如程序第一次触发Minor GC后，有6MB的对象晋升到旧生代，那么当下一次Minor GC发生时，首先检查旧生代的剩余空间是否大于6MB，如果小于6MB，则执行Full GC。

    当新生代采用PS GC时，方式稍有不同，PS GC是在Minor GC后也会检查，例如上面的例子中第一次Minor GC后，PS GC会检查此时旧生代的剩余空间是否 大于6MB，如小于，则触发对旧生代的回收。
    除了以上4种状况外，对于使用RMI来进行RPC或管理的Sun JDK应用而言，默认情况下会一小时执行一次Full GC。可通过在启动时通过- java -Dsun.rmi.dgc.client.gcInterval=3600000来设置Full GC执行的间隔时间或通过-XX:+ DisableExplicitGC来禁止RMI调用System.gc。

6. 堆中分配很大的对象

    所谓大对象，是指需要大量连续内存空间的java对象，例如很长的数组，此种对象会直接进入老年代，而老年代虽然有很大的剩余空间，但是无法找到足够大的连续空间来分配给当前对象，此种情况就会触发JVM进行Full GC。

    为了解决这个问题，CMS垃圾收集器提供了一个可配置的参数，即-XX:+UseCMSCompactAtFullCollection开关参数，用于在“享受”完Full GC服务之后额外免费赠送一个碎片整理的过程，内存整理的过程无法并发的，空间碎片问题没有了，但提顿时间不得不变长了，JVM设计者们还提供了另外一个参数 -XX:CMSFullGCsBeforeCompaction,这个参数用于设置在执行多少次不压缩的Full GC后,跟着来一次带压缩的。

##### YGC 的触发条件

对新生代堆进行GC。频率比较高，因为大部分对象的存活寿命较短，在新生代里被回收。性能耗费较小,

    触发: edn空间不足

``TIP``: YGC整个过程都stw

## 垃圾收集器

- Serial 收集器
    Serial收集器是最早的串行化收集器，主要缺点是在进行垃圾回收时，会暂停用户的所有进程（STW ），目前仍然是运行在client模式下的默认新生代收集器， 对于限定的单CPU环境来说， Serial由于没有线程的交互开销，因此可以获取较高的收集效率

    Serial Old 是Serial收集器的老年版本， 也是一个单线程收集器， 他使用标记-整理算法， 主要是被client模式下的虚拟机使用。 在Server模式下，他的主要用途: 1.5之前和Paraller Scanvenge收集器搭配使用， 另一个是：作为CMS收集器的后背预案，在并发收集发生Concurrent Mode Failure时使用

    使用参数： -UseSerialGC 使用Serial + Serial Old

    **Concurrent Mode Failure是什么**

- ParNew收集器
    ParNew收集器是Serial的多线程版本，在进行垃圾回收时，仍然会STW

    ParNew在单CPU环境下并不会比Serial更好，甚至由于存在线程交互的开销，在通过超线程技术实现的两个CPU的环境中都不能百分百保证超过Serial收集器。但当CPU多到一定数量时，对于GC时的系统资源利用还是很好的。 默认开启的线程数是和CPU数量相同， 可以通过-XX:ParallelGCThreads来限制垃圾回收的线程数量

    使用参数： -UseParNewGC 使用ParNew  + Serial Old

- Parallel Scanvenge 收集器

    Paralllel 是采用复制算法的多线程新生代垃圾回收器， 和ParNew新生代收集器有很多相似处。 Parallel Scanvenge 的一个特点是关注的目标是吞吐量，（吞吐量 = 用户代码运行时间／（用户代码运行时间+垃圾收集时间）。 停顿的越短，越有利于用户交互程序。 高吞吐量可以高效率的使用CPU时间， 使尽快的完成程序的运算任务， 主要用于后台运算但交互不多的任务

    Parallel Old是parallel Scanvenge的老年代版本， 采用多线程和标记-整理算法， 版本在1.6之后， 此前， 新生代的Parallel Scanvenge收集器使用地方限制较大， 原因是：如果新生代使用Parallel Scanvenge，那么老年代只能使用Serial Old(Ps MarkSWeep(实际上是标记整理MarkCompact)). 但由于老年代Serial Old 在服务端性能上的拖累，因此即便使用了Parallel Scanvenge 也无法在整体应用上获取吞吐量的最大化效果， 有因为老年代无法利用多CPU的处理能力， 因此在老年代很大的高级环境中，使用不一定有ParNew+CMS能力出众， Parallel Old的出现，可以说Parallel才有了使用的价值， 在注重吞吐量和Cpu资源敏感的场合，可以优先考虑Parallel Scanvenge + Parallel Old

    -UseParallelGC: 在Server模式下的默认值 使用 Parallel Scanvenge + Serial Old .  -UseParallelOldGC: 使用Parallel Scanvenge + Parallel Old

- CMS 收集器

    ``TIP:`` 在JDK14 之后被删除，通过使用ZGC和Shenandoah来代替

    CMS（Concurrent Mark Sweep)，当前最流程的垃圾回收器， 是一种以最短回收停顿时间为目标的收集器， 很适合用于用户交互。 基于标记-清除算法，收集过程分为四个步骤：
    1. 初始标记（initial mark 会产生STW）
    2. 并发标记（concurrent mark)
    3. 重新标记（remark 会产生STW)
    4. 并发清除（concurrent sweep)
时间主要耗费在2 和 4 阶段

由于CMS是基于标记清除算法实现， 因此会导致有大量的空间碎片产生， 在为大对象分配内存时，往往会出现老年代还有大量剩余空间，但却无法找到连续空间来分配，因此不得不开启一次Full GC。为解决这个问题，CMS提供参数：-XX:UseCMSCompactAtFullCollection(默认开启)，用于在CMS收集器进行FUllGC后开启碎片的合并整理过程，内存整理过程无法进行并发，因此会导致停顿时间变长。 另一个参数：-XX:CMSFullGCsBeforCompaction参数用于设置执行多少次不压缩后的Full GC，然后进行一次带压缩的Full GC（默认为0， 表示每次FULL GC都进行碎片整理）。

做为老年代收集器，却无法和jdk1.4种的Parallel Scanvenge收集器配合工作， u 因此使用CMS时，只能选择ParNew和Serial收集器中的一个。 使用-XX:UseConcMarkSweepGC来默认使用ParNew收集器。 也可以通过-XX:UseParNewGCl来强制使用

``` txt

    CMS的常用参数：

    UseCMSInitatingOccupancyOnly: 只有达到阙值时，才进行CMS回收

    -XX:CMSParallelRemarkEnabled 开启并行remark
    -XX:CMSScanvengeBeforRemark 强制remark前，会开启一次minor gc
    -XX:+ParallelCMSThreads CMS垃圾回收线程数，默认为：（ParallelGCThreads + 3)/4 
    -XX:CMSInitatingPermOccupancyFraction: 当永久区占有率达到一定比例，进行垃圾回收（前提：-XX:CMSClassUnloadingEnabled)

    -XX:+DisablExplicitGC 用来显示禁止System.gc()
```

// TODO
[参考链接](https://www.jianshu.com/p/843782af87b1)
[参考链接](https://www.jianshu.com/p/be5389ca93f7)
[参考链接](https://hllvm-group.iteye.com/group/topic/28854)
[参考链接](https://mp.weixin.qq.com/s/OzE7WrvcGPEcf_UHj2a-lg)

- G1 收集器

    G1用于服务器端的垃圾收集器， 相比于其他的垃圾收集器， 具备如下特点：
        1. 并发与并行： G1更充分使用CPU，多核环境来缩短STW停顿时间
        2. 分代收集： 分代概念在G1中任然存在，但G1可以独自管理整个GC堆
        3. 空间整合： G1有利于程序的长时间运行， 分配大对象时不会无法得到连续空间而触发一次GC
        4. 可预测非停顿：能让使用者明确指定一个长度为M毫秒的时间片段内，消耗在垃圾收集上的时间不得超过N毫秒
    G1将java堆分成多个大小相等的独立区域，虽保留新生代老生代的概念，但是不在是物理隔离的，他们都是一部分Region空间集合

- Shenandoah (jdk12之后)

    Shenandoah在G1之上的主要进步是在运行应用程序线程的同时完成了更多的垃圾回收周期工作。G1只能在应用程序暂停时撤离其堆区域（即移动对象），而Shenandoah可以与应用程序同时重新放置对象。
    为了实现并发重定位，它使用了所谓的Brooks指针。该指针是Shenandoah堆中每个对象都具有的一个附加字段，它指向对象本身。Shenandoah之所以这样做是因为，当它移动一个对象时，它还需要修复堆中所有引用该对象的对象。当Shenandoah将对象移动到新位置时，它将旧的Brooks指针留在原处，从而将引用转发到该对象的新位置。当引用对象时，应用程序将转发指针跟随到新位置。最终，需要清除带有转发指针的旧对象，但是通过将清除操作与移动对象本身的步骤分离，Shenandoah可以更轻松地完成对象的并发重定位

- ZGC  

    ZGC的主要目标是低延迟，可伸缩性和易用性,

### 垃圾回收伸缩能力对比

应用程序能弹性使用内存的前提，确保没有配置-XX:+AggressiveHeap，或者 Xms 小于 Xmx

1. Parallel

    -XX:+UseParallelGC ParallelGC 以高吞吐量为主要目标，一旦heap被分配，在FULLGC后也不会归还内存给系统

2. Serial && CMS

    -XX:+UseSerialGC  -XX:+UseConcMarkSweepGC , 都是可伸缩的垃圾回收器，但是需要经过几次的FUllGC才会慢慢归还（CMS在JDK9之后做过优化， 可以使用 ``-XX: ShrinkHeapInSteps``, 在第一次FULLGC后会加速释放)

3. G1

    -XX:UseG1GC 可伸缩的垃圾回收器，在第一次FULLGC是就会把多余的内存归还给系统，
   (在JDK12做过优化，可以不进行FULLGC，就可以把多余的内存归还给系统. 在命令指定的时间段内未发生垃圾回收周期，G1将尝试触发并发的垃圾回收周期，``G1PeriodicGCInterval`` ,然后该并发的垃圾回收周期将会在解释是将内存释放给操作系统
    为了确保这些定期的并发垃圾收集传递不会增加不必要的CPU开销，它们仅在系统部分空闲时才运行。用于触发并发周期是否运行的度量是平均一分钟系统负载值，该值必须低于所指定的值G1PeriodicGCSystemLoadThreshold

4. ShenandoahGC

    ``-XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC`` jdk12之后的基于Region的垃圾回收器，不需要进行FULLGC就可以异步回收内存归还给系统。。
