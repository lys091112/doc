# 类加载器















## 为什么会有上下文加载器，它的作用是什么？

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
