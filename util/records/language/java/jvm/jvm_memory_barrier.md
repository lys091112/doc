# jvm 内存操作相关

## 1. 内存屏障 TODO 待完善

### 1.1 内存基本原子操作

java 内存模型，定义了8中基本的原子操作：

- lock：锁住某个主存地址，为一个线程占用
- unlock：释放某个主存地址，允许其他线程访问该地址的数据
- read：将主存的值读取到工作内存
- Load：将read读取的值保存到工作内存的变量副本
- use：将值传递给线程的代码执行引擎
- assign：将执行引擎的处理返回的值重新赋值给变量副本
- Store：将变量副本的值刷新到主存
- write：将store存储的值写入到主内存的共享变量中

### 1.2  内存屏障基本指令

- LoadLoad 屏障
    Load1; LoadLoad; Load2，在Load2及后续读取操作要读取的数据被访问前，保证Load1要读取的数据被读取完毕。
- LoadStore 屏障
    Load1; LoadStore; Store2，在Store2及后续写入操作被执行前，保证Load1要读取的数据被读取完毕。
- StoreStore 屏障
    Store1; StoreStore; Store2，在Store2及后续写入操作执行前，保证Store1的写入操作对其它处理器可见。
- StoreLoad 屏障
    Store1; StoreLoad; Load2，在Load2及后续所有读取操作执行前，保证Store1的写入对所有处理器可见。
    它的开销是四种屏障中最大的（冲刷写缓冲器，清空无效化队列）。在大多数处理器的实现中，这个屏障是个万能屏障，兼具其它三种内存屏障的功能

## 2. Unsafe 基础api方法

1、 putOrderedObject

``` java
    // 调用这个方法和putObject差不多, 只是这个方法设置后对应的值的可见性不一定得到保证, 这个方法能起这个作用
    // 通常是作用在 volatile field上, 也就是说, 下面中的参数 val 是被volatile修饰
    // 可以参见ComplatableFuture.java 类中的使用
    /**
     Doug Lea:
     As probably the last little JSR166 follow-up for Mustang, we added a "lazySet" method to the Atomic classes (AtomicInteger, AtomicReference, etc). This is a niche method that is sometimes useful when fine-tuning code using non-blocking data structures. The semantics are that the write is guaranteed not to be re-ordered with any previous write, but may be reordered with subsequent operations (or equivalently, might not be visible to other threads) until some other volatile write or synchronizing action occurs).

     The main use case is for nulling out fields of nodes in non-blocking data structures solely for the sake of avoiding long-term garbage retention; it applies when it is harmless if other threads see non-null values for a while, but you'd like to ensure that structures are eventually GCable. In such cases, you can get better performance by avoiding the costs of the null volatile-write. There are a few other use cases along these lines for non-reference-based atomics as well, so the method is supported across all of the AtomicX classes.

    For people who like to think of these operations in terms of machine-level barriers on common multiprocessors, lazySet provides a preceeding store-store barrier (which is either a no-op or very cheap on current platforms), but no store-load barrier (which is usually the expensive part of a volatile-write).

    * store1 StoreStore store2 store3 ...
    意思是说 write操作不会和前面的写操作重排序, 但是可能会被随后的操作重排序(因为随后的store2, store3.. 是不可预知的，因此他们可以被重拍，), 直到再次遇到其他的volatile写或同步事件发生

    putOrderedObject 使用 store-store barrier屏障(即便StoreStore的指令可能会被重拍，但保证了最终可见), 而 putObject还会使用 store-load barrier 屏障
    */

    unsafe.putOrderedObject(this, nextOffset, val);

```
