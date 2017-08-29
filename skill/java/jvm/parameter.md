# JVM 变量参数


### JVM 基本参数值和含义

```
-XX:MaxJavaStackTraceDepth=1024  # JVM打印的栈深度，默热1024, 如果是-1,表明全部打印
-XX:ThreadStackSize or -Xss      # JVM 中java_thread 栈大小
-XX:CompilerThreadStackSize      # compiler_thread的stack_size
-XX:VMThreadStackSize            # vm内部的线程比如gc线程等
-XX:+PrintGCDetails              # 打印GC日志
-XX:+PrintGCTimeStamps           # 打印GC时间戳
```
