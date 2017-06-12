# 记录在使用日志框架中碰到的问题

1. SLF4J关于isDebugEnabled()的使用

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

