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

## java 类
```
ClassName.this
    this指的是当前正在访问这段代码的对象,当在内部类中使用this指的就是内部类的对象, 为了访问外层类对象,就可以使用外层类名.this来访问,一般也只在这种情况下使用这种
```

#### Thead 类
- notify, notifyAll, wait方法的调用需要首先获取锁
```
wait的功能是释放锁并使当前线程进入等待状态，所以在调用wait()前需要先获取锁， 而notitfy是同志线程进入就绪状态并交还对象锁然后重新获取对象锁（即临界区控制权），但此时锁已经释放，所以需要重新加锁
如果没有锁定的线程去调用这些方法，会抛出异常：java.lang.IllegalMonitorStatException
```
- yield
```
Thread.yield() : 使当前线程从执行状态（运行状态）变为可执行态（就绪状态）。cpu会从众多的可执行态里选择，也就是说，当前也就是刚刚的那个线程还是有可能会被再次执行到的，并不是说一定会执行其他线程而该线程在下一次中不会执行到了
```

- interrupt 
```
用来中断线程，可用于唤醒在sleep中的线程
```



### 类方法
```
class1.isAssignableFrom(class2) 用来表示class1 是否是 class2 的父类或父接口

obj instanceof Class 判断某个对象是否是某个类的实例
```


### 类加载器
```
Thread context class loader存在的目的主要是为了解决parent delegation机制下无法干净的解决的问题。假如有下述委派链： 
ClassLoader A -> System class loader -> Extension class loader -> Bootstrap class loader 

那么委派链左边的ClassLoader就可以很自然的使用右边的ClassLoader所加载的类。 

但如果情况要反过来，是右边的ClassLoader所加载的代码需要反过来去找委派链靠左边的ClassLoader去加载东西怎么办呢？没辙，parent delegation是单向的，没办法反过来从右边找左边。 

这种情况下就可以把某个位于委派链左边的ClassLoader设置为线程的context class loader，这样就给机会让代码不受parent delegation的委派方向的限制而加载到类了。

```

