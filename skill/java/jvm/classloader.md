# 类加载器


### 类加载器
```
Thread context class loader存在的目的主要是为了解决parent delegation机制下无法干净的解决的问题。假如有下述委派链： 
ClassLoader A -> System class loader -> Extension class loader -> Bootstrap class loader 

那么委派链左边的ClassLoader就可以很自然的使用右边的ClassLoader所加载的类。 

但如果情况要反过来，是右边的ClassLoader所加载的代码需要反过来去找委派链靠左边的ClassLoader去加载东西怎么办呢？没辙，parent delegation是单向的，没办法反过来从右边找左边。 

这种情况下就可以把某个位于委派链左边的ClassLoader设置为线程的context class loader，这样就给机会让代码不受parent delegation的委派方向的限制而加载到类了。

```

####  类命名空间

- 初始类加载器 定义类装载器

    如果要求某个类装载器A去装载一个类型,但是通过父亲代理，经过B C类装载器，最终却返回了D装载器装载的类型，这种装载器(ABC)被称为是那个类型的初始类装载器 ；而实际装载那个类型的D类装载器被称为该类型的定义类装载器


- 命名空间共享

    每个类都有自己的命名空间，不同类加载器加载的类是相互不可见的，但是属于同一初始类装载器
    的类之间共享该初始类命名空间下的类

 ```
                 --> O
 D -> C  -> B -> 
                 --> A
 左边的类加载器是右边的父类加载器， 那么在这种情况下A 可以共享B C D 下的命名空间
 但是 A 和 O 之间的命名空间不能共享

 ```
#### 类卸载机制

1. 类的生命周期

当类被加载，连接，初始化之后，类的生命周期就开始了，而当它的Class不再被引用，即不可被访问到，那么它的生命周期就结束了，其在方区的数据也会被卸载

类何时结束，取决于类的Class对象生命周期何时结束

2.  类的引用关系

- 类加载器和类对象 

    每个类加载器都用集合类保存着其加载的所有Class的对象引用
    而对于每个类，我们都可以通过.getClassLoader() 来获取类的加载器
    他们之间是双向互相引用的关系

- 类，Class对象 类的实例

    类的实例引用这个类的Class对象，我们可以通过实例的getClass()方法来获取类对象
    所有的类都有一个Class属性，代表这个类的类对象

3. 类的卸载

由Java JVM自带的类加载器加载的类永不会被卸载
java JVM 自带的类加载器有 AppClassLoader ExtClassLoader BootStrapClassLoader
在JVM的运行过程中始终会引用这些类加载器， 因此加载器中加载的类始终被引用

用户自定义的类可以被卸载, 条件如下：
    1.该类所有的实例都已经被回收，也就是java堆中不存在该类的任何实例。
    2.加载该类的ClassLoader已经被回收。
    3.该类对应的java.lang.Class对象没有任何地方被引用，无法在任何地方通过反射访问该类的方法

显然，如果一个单例模式下的类无法被卸载

### 为什么会有上下文加载器，它的作用是什么？

  Java 提供了很多服务提供者接口（Service Provider Interface，SPI），允许第三方为这些接口提供实现。常见的 SPI 有 JDBC、JCE、JNDI、JAXP 和 JBI 等。这些 SPI 的接口由 Java 核心库来提供，如 JAXP 的 SPI 接口定义包含在 javax.xml.parsers包中。

  这些 SPI 的实现代码很可能是作为 Java 应用所依赖的 jar 包被包含进来，可以通过类路径（CLASSPATH）来找到，如实现了 JAXP SPI 的 Apache Xerces所包含的 jar 包。SPI 接口中的代码经常需要加载具体的实现类。如 JAXP 中的 javax.xml.parsers.DocumentBuilderFactory类中的 newInstance()方法用来生成一个新的 DocumentBuilderFactory的实例。这里的实例的真正的类是继承自 javax.xml.parsers.DocumentBuilderFactory，由 SPI 的实现所提供的。如在 Apache Xerces 中，实现的类是 org.apache.xerces.jaxp.DocumentBuilderFactoryImpl。
  
  而问题在于，SPI 的接口是 Java 核心库的一部分，是由引导类加载器来加载的；SPI 实现的 Java 类一般是由系统类加载器来加载的。引导类加载器是无法找到 SPI 的实现类的，因为它只加载 Java 的核心库。它也不能代理给系统类加载器，因为它是系统类加载器的祖先类加载器。也就是说，类加载器的代理模式无法解决这个问题。
  线程上下文类加载器正好解决了这个问题。如果不做任何的设置，Java 应用的线程的上下文类加载器默认就是系统上下文类加载器。在 SPI 接口的代码中使用线程上下文类加载器，就可以成功的加载到 SPI 实现的类

  **JDBC的实现案例**
      JDBC（Java Data Base Connectivity）是一种用于执行SQL语句的Java API，可以为多种关系数据库提供统一访问，它由一组用Java语言编写的类和接口组成。JDBC提供了一种基准，据此可以构建更高级的工具和接口，使数据库开发人员能够编写数据库应用程序。

也就是说JDBC就是java提供的一种SPI，要接入的数据库供应商必须按照此标准来编写实现类。

jdk中的DriverManager的加载Driver的步骤顺序依次是：

通过SPI方式，读取META-INF/services下文件的配置，使用线程上下文类加载器加载
通过System.getProperty(“jdbc.drivers”)获取设置，然后通过系统类加载器加载
用户调用Class.forName()加载到系统类加载器，然后注册到DriverManager对象，在需要使用时直接取用，但需校验注册和调用的类加载是否一样，校验这步需要借助线程上下文类加载器（否则多模块应用同时都注册了mysql driver，从DriverManager取时将出现错乱


### TIP:
通过DriverManager获取Driver类,一般情况下我们使用的方式为：DriverManager.class.getClassLoader(),该classloader是引导类loader，肯定无法加载Driver的实现类，因此需要上下文类加载器来打破这种双亲委派模型，

此外还有其他多种用途，例如可以自定义上下文加载器，不继承双亲委派模型用来处理自定义加载类等等
