## 网上文章记录

1.记使用CompletableFuture时，关于ClassLoader引起的问题
 url: https://juejin.cn/post/6909445190642040846?utm_source=gold_browser_extension
 desc: 由于tomcate 默认使用的是SafeForkJoinWorkerThreadFactory，他使用FrokJoinPool的classLoader做为线程的classLoader（为BootStrapClassLoader)， 这在tomcat中无法加载到 ``WEB-INFO/lib`` 下的jar包
