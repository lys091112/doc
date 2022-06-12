.. highlight: rst
.. _records_tool_logger_matrix:

Logger 依赖的对应矩阵
----------------------


1. Commons-logging Vs slf4j

+----------------+---------------------------------------------------------+-------------------------------------------------+
| xx             | Common-logging                                          | slf4j                                           |
+================+=========================================================+=================================================+
| Jul            | Commons-logging                                         | slf4j-Api,slf4j-jdk14                           |
+----------------+---------------------------------------------------------+-------------------------------------------------+
| Log4j1         | Commons-logging,log4j                                   | Slf-api,log4j,slf4j-log4j12                     |
+----------------+---------------------------------------------------------+-------------------------------------------------+
| Logback        | Logback-core, logback-classic,slf4j-api, jcl-over-slf4j | Slf4j-api,logback-core,logback-classic          |
+----------------+---------------------------------------------------------+-------------------------------------------------+
| Log4j2         | Commons-Logging,log4j-api,log4j-core,log4j-jcl          | slf4j-api,log4j-api,log4j-core,log4j-slf4j-impl |
+----------------+---------------------------------------------------------+-------------------------------------------------+
| Slf4j          | slf4j-jcl,slf4j-api                                     | nil                                             |
+----------------+---------------------------------------------------------+-------------------------------------------------+
| Common-logging | nil                                                     | slf4j-api,jcl-over-slf4j                        |
+----------------+---------------------------------------------------------+-------------------------------------------------+

分析
::::

::

    log4j-slf4j-impl-2.7.jar，这个包的作用就是使用slf4j的api，但是底层实现是基于log4j2
    slf4j-log4j12-1.6.1.jar，这个包的作用就是使用slf4j的api，但是底层实现是基于log4j
    jcl-over-slf4j（实现commons-logging切换到slf4j,由common-logging 输出的日志在底层转话为Slf4j）
    jul-to-slf4j （实现jdk-logging切换到slf4j）
    log4j-over-slf4j log4j接口输出的日志就会通过log4j-over-slf4j路由到SLF4J
    slf4j-jcl：slf4j到commons-logging的桥梁


描述
:::::

::

    slf4j+log4j
        如果我们在系统中需要使用slf4j和log4j来进行日志输出的话，我们需要引入下面的jar包：
        log4j核心jar包：log4j-1.2.17.jar
        slf4j核心jar包：slf4j-api-1.6.4.jar
        slf4j与log4j的桥接包：slf4j-log4j12-1.6.1.jar，这个包的作用就是使用slf4j的api，但是底层实现是基于log4j

    slf4j + log4j2
        log4j2核心jar包：log4j-api-2.7.jar和log4j-core-2.7.jar
        slf4j核心jar包：slf4j-api-1.6.4.jar
        slf4j与log4j2的桥接包：log4j-slf4j-impl-2.7.jar，这个包的作用就是使用slf4j的api，但是底层实现是基于log4j2

日志系统之间的切换
::::::::::::::::::::::

4.1 log4j无缝切换到logback
'''''''''''''''''''''''''''''''
我们已经在代码中使用了log4j1的API来进行日志的输出，现在想不更改已有代码的前提下，使之通过logback来进行实际的日志输出。

1. 已使用的jar包：

    log4j


2. 更新步骤：
    只需要更换一下jar包就可以：

    第一步：去掉log4j jar包
    第二步：加入以下jar包

    log4j-over-slf4j（实现log4j1切换到slf4j）
    slf4j-api
    logback-core
    logback-classic

4.2 jdk-logging无缝切换到logback
'''''''''''''''''''''''''''''''''''''
1. 使用jdk-logging自带的API来进行编程的，现在我们想这些日志交给logback来输出

2. 解决办法：

    第一步：加入以下jar包：

    jul-to-slf4j （实现jdk-logging切换到slf4j）
    slf4j-api
    logback-core
    logback-classic
    第二步：在类路径下加入logback的配置文件

    第三步：在代码中加入如下代码：

.. code-block:: java

        static{
           SLF4JBridgeHandler.install();
        }


commons-logging切换到logback
'''''''''''''''''''''''''''''''''''''
1. 使用的jar包

    commons-logging

2. 解决办法：

    第一步：去掉依赖的commons-logging jar包，可以通过scope设置来去除
    第二步：加入以下jar包：

    jcl-over-slf4j（实现commons-logging切换到slf4j）
    slf4j-api
    logback-core
    logback-classic
    第三步：在类路径下加入logback的配置文件


Log4j2 配置文件加载
'''''''''''''''''''''''
选择configuration文件的优先级如下

    1.classpath下名为log4j-test.json或者log4j-test.jsn文件
    2.classpath下名为log4j2-test.xml
    3.classpath下名为log4j.json或者log4j.jsn文件
    4.classpath下名为log4j2.xml
