# 原子类介绍

## 1. AtomicReferenceFieldUpdater 

用于原子的更新类的某个字段，字段需要使用 ``volatile`` 修饰，保证对线程可见。


```java

public class T {
    private volatile String value = "xxx";
    private static AtomicReferenceFieldUpdater<T,String> updater = AtomicReferenceFieldUpdater.newUpdater(T.class,String.class,"value");


    public void update(String newValue) {
        String oldValue = this.value;
        // 原子的更新的value
        updater.compareAndSet(this,oldValue,newValue);
    }
}

```

与``AtomicReference`` 对比优点：
1. 可以原子性的修改类的某个字段，而不用修改整个类，减少锁竞争和内存使用
2. ``AtomicReference`` 常作为成员变量使用，内存占用取决于是否开启指针压缩（压缩16字节，不压缩24字节），而 ``AtomicReferenceFieldUpdater`` 不占用太多内存，因为不实际存储引用，而是作为类的静态成员变量，来更新字段
