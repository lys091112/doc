# channelHandler 相关基础知识

## Sharable的含义

如果handler是单例的，那必须加@Sharable；每次去new handler的情况下可以不用加这个注解，是不是单例完全由自己控制。在添加Decoder时，1必须不是单例，2不要添加@Sharable。

真实含义：
1.当netty尝试往多个channel的pipeline中添加同一个ChannelHandlerAdapter实例时，会判断该实例类是否添加了@Sharable，没有则抛出... is not a @Sharable handler, so can't be added or removed multiple times异常

如果你添加的不是单例Handler，你加不加@Sharable没有任何区别

如果你添加的是单例Handler，只要它会被添加到多个channel的pipeline，那就必须加上@Sharable

2.网上有些资料说netty会将注解了@Sharable的Handler单例化，实在误导人。channelHandler是不是单例跟netty没有任何关系，netty只会在你尝试用单例ChannelHandler时加上第1条说明的限制，这个限制意思很明确，多个channel公用单例ChannelHandler，那它就必须是线程安全的，@Sharable就是用于告诉netty，我这个Handler是线程安全的，可以被多个channel安全的share，假如你搞了个线程不安全的类，你对它用上了单例，还加个@Sharable，这时候netty拿你也没办法，只是你的老板可能会有点不开心

在initChannel方法中，我们addLast传入的Handler实例，他是不是单例的与netty没有任何关系，和你是否注解@Sharable也没有任何关系


## 参考资源

1. [netty的@Sharable注解含义](https://www.jianshu.com/p/cfe6136a9cb8)
