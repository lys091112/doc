# 记录在使用日志框架中碰到的问题

### SLF4J关于isDebugEnabled()的使用

``` java
/**
 * slf4j在debug方法中会默认进行isDebugEnabled()的检测，但是
 * 为了防止joiner方法的序列化执行，从而增加性能消耗，会在外层先一步检测isDebugEnabled(),
 * 减少性能消耗
 */
 public void test() {
    logger.debug("query list. userId:{}, userName:{}", userId, userName)

    if(logger.isDebugEnabled()) {
        logger.debug("query List, userId:{}, info:{}", userId, Joiner.on(",").join(userlists))
    }
 }
```

### 切换Log系统

- jcl-over-slf4j这个包可以完成这个任务。具体的步骤是，把common logging的jar包从cp里删掉，然后把jcl-over-slf4j放入cp。这个jar包中的类和common logging中的类名，方法名等完全一样，只是在具体的方法中，把所有的请求都暗渡陈仓的转移到了slf4j上。

- 同样还有log4j-over-slf4j，可以解决在代码中写了使用log4j的情况。只要用这个jar包替代log4j的jar包就可以了

- 对于jul就复杂一点，因为不能把java中自带的类删了。所以jul-to-slf4j的做法是用自己的Hander（JUL处理日志的接口）作为root，同时删除所有的其它logger。这样就相当于用个二传手把所有的log通过这个硬塞进来的Handler，委托给了slf4j，然后slf4j再寻找实现，bulabula就跟前面一样了。

参考sfl4j官网: [Gradual migration to SLF4J from Jakarta Commons Logging](https://www.slf4j.org/legacy.html)
