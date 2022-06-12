# CMS 和 G1 内存回收对比

## 1.  示例

```java
public class MemoryRecycleTest {

    int count = 512; //指定要生产的对象大小为512M
    static volatile List<OOMobject> list = new ArrayList<>();

    public static void main(String[] args) {

        //新建一条线程,负责生产对象
        new Thread(() -> {
            try {
                for (int i = 1; i <= 10; i++) {
                    System.out.println(String.format("第%s次生产%s大小的对象", i, count));
                    addObject(list, count);
                    //休眠40秒
                    Thread.sleep(i * 10000);
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }).start();

        //新建一条线程,负责清理List,回收JVM内存
        new Thread(() -> {
            for (; ; ) {
                //当List内存到达512M,就通知GC回收堆
                if (list.size() >= count) {
                    System.out.println("清理list.... 回收jvm内存....");
                    list.clear();
                    //通知GC回收
                    System.gc();
                    //打印堆内存信息
                    printJvmMemoryInfo();
                }
            }
        }).start();

        //阻止程序退出
        try {
            Thread.currentThread().join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void addObject(List<OOMobject> list, int count) {

        for (int i = 0; i < count; i++) {
            OOMobject ooMobject = new OOMobject();
            //向List添加一个1M的对象
            list.add(ooMobject);
            try {
                //休眠100毫秒
                Thread.sleep(100);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public static class OOMobject {
        //生成1M的对象
        private byte[] bytes = new byte[1024 * 1024];
    }

    public static void printJvmMemoryInfo() {
        //虚拟机级内存情况查询
        int byteToMb = 1024 * 1024;
        Runtime rt = Runtime.getRuntime();
        long vmTotal = rt.totalMemory() / byteToMb;
        long vmFree = rt.freeMemory() / byteToMb;
        long vmMax = rt.maxMemory() / byteToMb;
        System.out.println("--------------------------------");
        System.out.println("JVM内存已用的空间为：" + (vmTotal - vmFree) + " MB");
        System.out.println("JVM内存的空闲空间为：" + vmFree + " MB");
        System.out.println("JVM总内存空间为：" + vmTotal + " MB");
        System.out.println("JVM总内存最大堆空间为：" + vmMax + " MB");
    }
}


```

## 2. 对比(初始内存和最大内存设置不一致)

1. JDK8+CMS的配置下，JVM并不是立马归还内存给到操作系统，而是随着FullGC次数的增多逐渐归还，最终会全部归还 ``-Xms128M -Xmx2048M -XX:+UseConcMarkSweepGC``
2. 在JDK8+G1的配置下，JVM都是在每一次FullGC后全部归还物理内存 ``-Xms128M -Xmx2048M -XX:+UseG1GC ``
3. 在JDK11+CMS的配置下和JDK8+CMS的情况相同（JVM并不是立马归还内存给到操作系统，而是随着FullGC次数的增多逐渐归还，最终会全部归还） 由于 JDK11 提供了参数 `` ShrinkHeapInSteps``,且默认为开启状态，如果把该参数关闭，那么在JDK11下每次垃圾回收会立刻把内存还给物理内存 ``-Xms128M -Xmx2048M -XX:+UseConcMarkSweepGC -XX:-ShrinkHeapInSteps ``
4. JDK11下的G1和JDK8下的G1对内存的响应是不一样的。 从堆内存变化来看， JDK11下G1更加倾向于尽可能的利用内存，不着急回收。 而JDK8下G1则是倾向于尽可能的先回收内存。 从图中看，JDK8下G1的实际使用的堆内存大小基本是JDK11下G1的一半。 即 在JSDK11 下，垃圾回收的频率比JDK8下低，因为会充分利用堆内存 `` -Xms128M -Xmx2048M -XX:+UseG1GC``

## 3. 结论

如果初始内存和最大内存设置为一致，那么无论多少次FullGC，也不会造成引起物理内存释放归还操作系统

- 能不能归还，主要依赖于Xms和Xmx是否相等
- 何时归还，主要依赖于JDK版本和垃圾回收器类型

只有FullGC的时候才能真正触发堆内存收缩归还OS。YGC是不能使JVM主动归还内存给操作系统的


## 参考链接

1. [CMS和G1的物理内存归还](https://wblog.csdn.net/qq_40378034/article/details/110677269)