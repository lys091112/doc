# 全链路追踪必备组件之 TransmittableThreadLocal


## TransmittableThreadLocal

继承自InheritableThreadLocal,在创建时可以将父线程中包含的线程局部变量继承下来，然后在通过特定的包装类将线程变量在线程池中传递下去，示例代码如下：

```java
private static ThreadLocal<String> contextHolder = new ThreadLocal<>();

public static <T> CompletableFuture<T> invokeToCompletableFuture(Supplier<T> supplier, String errorMessage) {
    // 第一步 获取当前父线程的局部变量
    String context = contextHolder.get();
    Supplier<T> newSupplier = () -> {
         // 第二步 获取当前执行子线程的局部变量
        String origin = contextHolder.get();
        try {

            // 第三步 将父级线程的局部变量设置到当前的子线程局部变量中
            contextHolder.set(context);
            return supplier.get();
        } finally {
            // 第四步 执行完成后，恢复子线程的原始局部变量
            contextHolder.set(origin);
            log.info(origin);
        }
    };
    return CompletableFuture.supplyAsync(newSupplier).exceptionally(e -> {
        throw new ServerErrorException(errorMessage, e);
    });
}

```


## 错误使用

```java

private static final TransmittableThreadLocal<String> traceThreadLocal = new TransmittableThreadLocal<>(true);

static final Executor defaultCommonPool = TtlExecutors.getTtlExecutorService(
        new ThreadPoolExecutor(Runtime.getRuntime().availableProcessors() * 2, 1024,
            15L, TimeUnit.SECONDS, new LinkedBlockingQueue<>(),
            new ThreadFactoryBuilder().setNameFormat("loura-common-pool-%d").build()));

public void test() {
    // traceThreadLocal.set(traceId); 正确做法
    CompletableFuture<LouraResult<IN>> parent = CompletableFuture.supplyAsync(() -> {
     //错误的在子线程中使用了，造成部分线程没有获取到父线程的局部变量
     // 正确的做法是在入口父线程中初始化线程局部变量
        traceThreadLocal.set(traceId);
         return LouraResult.success("louraStart", param)
     }, defaultCommonPool);

}

```











## 参考链接

1. [全链路追踪必备组件之 TransmittableThreadLocal 详解](https://zhuanlan.zhihu.com/p/146124826)

