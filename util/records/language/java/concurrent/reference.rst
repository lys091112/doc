.. highlight:: rst

.. _records_language_java_concurrent_reference:


java 对象引用
=================


java的四种引用类型
::::::::::::::::::::

1. 强引用

::

    只要引用存在，垃圾回收器永远不会回收,我们通常使用的声明方式都为强引用

2. 软引用(SoftReference)

::

    软引用是用来描述一些有用但并不是必需的对象，在Java中用java.lang.ref.SoftReference类来表示。对于软引用关联着的对象，只有在内存不足的时候JVM才会回收该对象。因此，这一点可以很好地用来解决OOM的问题，并且这个特性很适合用来实现缓存：比如网页缓存、图片缓存等。
    软引用可以和一个引用队列（ReferenceQueue）联合使用，如果弱引用所引用的对象被JVM回收，这个软引用就会被加入到与之关联的引用队列中

3. 弱引用 (WeakReference)

::

    弱引用也是用来描述非必需对象的，当JVM进行垃圾回收时，无论内存是否充足，都会回收被弱引用关联的对象。在java中，用java.lang.ref.WeakReference类来表示
    弱引用可以和一个引用队列（ReferenceQueue）联合使用，如果弱引用所引用的对象被JVM回收，这个软引用就会被加入到与之关联的引用队列中

4. 虚引用

::

    虚引用和前面的软引用、弱引用不同，它并不影响对象的生命周期。在java中用java.lang.ref.PhantomReference类表示。如果一个对象与虚引用关联，则跟没有引用与之关联一样，在任何时候都可能被垃圾回收器回收

    虚引用必须和引用队列关联使用，当垃圾回收器准备回收一个对象时，如果发现它还有虚引用，就会把这个虚引用加入到与之 关联的引用队列中。程序可以通过判断引用队列中是否已经加入了虚引用，来了解被引用的对象是否将要被垃圾回收。如果程序发现某个虚引用已经被加入到引用队列，那么就可以在所引用的对象的内存被回收之前采取必要的行动


通常我们使用ReferenceQueue来监控引用的回收情况

.. code-block:: java

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
