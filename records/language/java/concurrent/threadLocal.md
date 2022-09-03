## ThreadLocal 详解

### 1. 原理

```java

ThreadLocalMap getMap(Thread t) {
    return t.threadLocals;
} 

void createMap(Thread t, T firstValue) {
        t.threadLocals = new ThreadLocalMap(this, firstValue);
}

public void set(T value) {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null)
            // 默认填充的时ThreadLocalMap中的table，元素对象为Entry
            map.set(this, value);
        else
            createMap(t, value);
}
```

threadLocal的赋值是将该 ``ThreadLocal对象`` 做为 ``Key`` ，然后将 ``value`` 值放到当前thread对应的 ``ThreadLocalMap`` 对象中

局部变量的本质就是将对象放置到线程中，从而在线程的整个处理生命周期中生效


## 2. ThreadLocal 内存泄漏问题

### 2.1 Key 泄漏
每一个 Thread 都有一个 ThreadLocal.ThreadLocalMap 这样的类型变量，该变量的名字叫作 threadLocals。线程在访问了 ThreadLocal 之后，都会在它的 ThreadLocalMap 里面的 Entry 中去维护该 ThreadLocal 变量与具体实例的映射

我们可能会在业务代码中执行了 ThreadLocal instance = null 操作，想清理掉这个 ThreadLocal 实例，但是假设我们在 ThreadLocalMap 的 Entry 中强引用了 ThreadLocal 实例，那么，虽然在业务代码中把 ThreadLocal 实例置为了 null，但是在 Thread 类中依然有这个引用链的存在

GC 在垃圾回收的时候会进行可达性分析，它会发现这个 ThreadLocal 对象依然是可达的，所以对于这个 ThreadLocal 对象不会进行垃圾回收，这样的话就造成了内存泄漏的情况

因此 ThreadLocal使用了弱引用声明，以便在垃圾回收时被回收

```java

 static class Entry extends WeakReference<ThreadLocal<?>> {
            /** The value associated with this ThreadLocal. */
            Object value;

            Entry(ThreadLocal<?> k, Object v) {
                super(k);
                value = v;
            }
 }
```

弱引用的特点是，如果这个对象只被弱引用关联，而没有任何强引用关联，那么这个对象就可以被回收，所以弱引用不会阻止 GC。因此，这个弱引用的机制就避免了 ThreadLocal 的内存泄露问题

### 2.2 Value 泄漏
```
ThreadLocalMap使用ThreadLocal的弱引用作为key，如果一个ThreadLocal没有外部强引用来引用它，那么系统 GC 的时候，这个ThreadLocal势必会被回收，这样一来，ThreadLocalMap中就会出现key为null的Entry，就没有办法访问这些key为null的Entry的value，如果当前线程再迟迟不结束的话，这些key为null的Entry的value就会一直存在一条强引用链：Thread Ref -> Thread -> ThreaLocalMap -> Entry -> value永远无法回收，造成内存泄漏。

ThreadLocalMap是被设置到thread中，是thread的一个成员变量，key为threadlocal， value为引用的值

其实，ThreadLocalMap的设计中已经考虑到这种情况，也加上了一些防护措施：在ThreadLocal的get(),set(),remove()的时候都会清除线程ThreadLocalMap里所有key为null的value。

但是这些被动的预防措施并不能保证不会内存泄漏：
    使用static的ThreadLocal，延长了ThreadLocal的生命周期，可能导致的内存泄漏
    分配使用了ThreadLocal又不再调用get(),set(),remove()方法，那么就会导致内存泄漏。

原因主要为： 由于ThreadLocalMap的生命周期跟Thread一样长，如果没有手动删除对应key就会导致内存泄漏，而不是因为弱引用

因此在使用threadLocal时需要注意：每次使用完ThreadLocal，都调用它的remove()方法或者set(null)，清除数据
像使用lock一样每次都手动进行unlock，防止内存泄漏

```