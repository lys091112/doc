# java 一些基本使用和概念

* java远程调试参数含义
    * java远程调试是两个vm通过debug协议进行调试，通过socket通信。jdwp是java debug wire protocol的缩写
      jdk1.7之前：java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n main_application&
      jdk1.7之后：java -agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n main_application&
      main_application是main程序，server=y表示是监听其他debugclient端的请求。address=800表示监听8000端口， suspend表示是否在调试客户端建立链接后启动vm，如果是y，那么当前的vm就是suspend直到debugclient连接进来才开始执行程序，如果程序不是服务器监听模式并且很快执行完毕，可以选择y来阻塞它的启动

*  java 对象的大小
    - 对象头在32位系统上占用8bytes，64位系统上占用16bytes。
    - 对齐填充（对象头 + 实例数据 + padding） % 8等于0且0 <= padding < 8 >

```        
数组对象: 
64位机器上，占用24个字节，启用压缩之后占用16个字节。之所以比普通对象占用内存多是因为需要额外的空间存储数组的长度。
16个对象头开销，4个长度开销，以及4个字节填充
```
### JVM

1. 查询JVM参数

```
 jcmd pid VM.system_properties  #打印出vm的运行参数
```

## java 类

```
ClassName.this
    this指的是当前正在访问这段代码的对象,当在内部类中使用this指的就是内部类的对象, 为了访问外层类对象,就可以使用外层类名.this来访问,一般也只在这种情况下使用这种
```
- Java 构造方法和成员变量初始化顺序
```
执行父类静态代码 执行子类静态代码
初始化父类成员变量（我们常说的赋值语句）
初始化父类构造函数
初始化子类成员变量
初始化子类构造函数
```


### 类方法

```
class1.isAssignableFrom(class2) 用来表示class1 是否是 class2 的父类或父接口

obj instanceof Class 判断某个对象是否是某个类的实例

```

### Java中的一些基础知识

1. == and equals 方法的区别

```
    1、==是判断两个变量或实例是不是指向同一个内存空间。 equals是判断两个变量或实例所指向的内存空间的值是不是相同。

    2、==是指对内存地址进行比较。 equals()是对字符串的内容进行比较。

    3、==指引用是否相同。 equals()指的是值是否相同

```

2. 对象引用的四种级别

```
1、强引用

最普遍的一种引用方式，如String s = "abc"，变量s就是字符串“abc”的强引用，只要强引用存在，则垃圾回收器就不会回收这个对象。

2、软引用（SoftReference）

用于描述还有用但非必须的对象，如果内存足够，不回收，如果内存不足，则回收。一般用于实现内存敏感的高速缓存，软引用可以和引用队列ReferenceQueue联合使用，如果软引用的对象被垃圾回收，JVM就会把这个软引用加入到与之关联的引用队列中。

3、弱引用（WeakReference）

弱引用和软引用大致相同，弱引用与软引用的区别在于：只具有弱引用的对象拥有更短暂的生命周期。在垃圾回收器线程扫描它所管辖的内存区域的过程中，一旦发现了只具有弱引用的对象，不管当前内存空间足够与否，都会回收它的内存。

4、虚引用（PhantomReference）

就是形同虚设，与其他几种引用都不同，虚引用并不会决定对象的生命周期。如果一个对象仅持有虚引用，那么它就和没有任何引用一样，在任何时候都可能被垃圾回收器回收。 虚引用主要用来跟踪对象被垃圾回收器回收的活动。

```

3. ConcurrentHashMap能完全替代HashTable吗？
```
HashTable虽然性能上不如ConcurrentHashMap，但并不能完全被取代，两者的迭代器的一致性不同的，
HashTable的迭代器是强一致性的，而ConcurrentHashMap是弱一致的。
ConcurrentHashMap的get，clear，iterator 都是弱一致性的。 Doug Lea 也将这个判断留给用户自己决定是否使用ConcurrentHashMap。

弱一致性： put操作将一个元素加入到底层数据结构后，get可能在某段时间内还看不到这个元素，若不考虑内存模型，单从代码逻辑上来看，却是应该可以看得到的

```

4. try里有return，难么finally还会执行吗
```
肯定会执行。finally{}块的代码。 只有在try{}块中包含遇到System.exit(0)。 之类的导致Java虚拟机直接退出的语句才会不执行
```

5. 单独运行一个class文件
```
需要加上 -cp . 表示以当前路径作为classpath路径
java -cp . packagex.MainClass
```
