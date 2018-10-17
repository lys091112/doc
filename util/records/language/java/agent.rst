待整理
^^^^^^^^^^^^^^^^^


/home/liuhongjun/xianyue/software/jdk1.8.0_171/bin/java -Djava.awt.headless=true -Xbootclasspath/a:/home/liuhongjun/xianyue/software/jdk1.8.0_171/lib/tools.jar -jar /home/liuhongjun/.arthas/lib/3.0.4/arthas/arthas-core.jar -pid 13184 -target-ip 127.0.0.1 -telnet-port 3658 -http-port 8563 -core /home/liuhongjun/.arthas/lib/3.0.4/arthas/arthas-core.jar -agent /home/liuhongjun/.arthas/lib/3.0.4/arthas/arthas-agent.jar

-Xbootclasspath:完全取代系统Java classpath.最好不用。
-Xbootclasspath/a: 在系统class加载后加载。一般用这个。
-Xbootclasspath/p: 在系统class加载前加载,注意使用，和系统类冲突就不好了



1. appendtosystemclassloadersearch(jarfile jarfile)
指定 jar 文件，检测类由系统类加载器定义。 当代理的系统类加载器（参见 getsystemclassloader()）未能成功搜索到类时，jarfile 中的条目也将被搜索。
可以多次使用此方法，按照调用此方法的顺序添加多个要搜索的 jar 文件。
除了需要引导类加载器为检测而定义的类或资源外，代理应该注意确保 jar 不包含任何其他类或资源。 违反此规定将导致难以诊断的不可预料行为

2. premain 和agentmain的区别
   通过对 agentmain 的使用，我们感受到了他的强大，在目标程序丝毫不改动的，甚至连启动参数都不加的情况下，可以修改类，并且是运行后修改，而且不重新创建类加载器。其主要得益于 JVM 底层的对类的重定义，关于底层代码解释，Jvm 大神寒泉子有篇文章 JVM源码分析之javaagent原理完全解读 ，详细分析了 javaagent 的原理。但 agentmain 有一些功能上的限制，比如字段不能修改增减。所以，使用的时候需要权衡，到底使用哪种方式实现热部署。

说了这么久的热部署，其实就是动态或者说运行时修改类，大的方向说有2种方式：

使用 agentmain，不需要重新创建类加载器，可直接修改类，但是有很多限制。
使用 premain 可以在类第一次加载之前修改，加载之后修改需要重新创建类加载器。或者在自定义的类加载器种修改，但这种方式比较耦合。
