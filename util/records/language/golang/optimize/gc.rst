
## GC 参考总结
http://legendtkl.com/2017/04/28/golang-gc/
https://www.cnblogs.com/hezhixiong/p/9577199.html
https://mp.weixin.qq.com/s?__biz=MzI4NDY5Mjc1Mg==&mid=2247489300&idx=1&sn=42facb3c819474dc47ca48585764e481&chksm=ebf6cf6bdc81467d8d59136ce19a2670f4638a1c679ea1bde7700c975ef2007d07b9f91eaaee&mpshare=1&scene=1&srcid=&sharer_sharetime=1569376846739&sharer_shareid=e38d76e10729a54144d54db5c67a4d8f&pass_ticket=9mhToIoaj8wlgBhtZLUddbuqsXpvMpqRSuAKLfA4QA2yJnCzd8IBPbbNeG3BVarx#rd
https://www.jianshu.com/p/bfc3c65c05d1?utm_source=wechat_session
https://www.cnblogs.com/saryli/p/10105393.html
https://www.zhihu.com/question/326191221/answer/721062767


总的来说, 确实是牺牲了gc吞吐量换来了极短的stw, 这也是故意这样设计的:一是go的主要应用领域不是CPU敏感的, 而是需要高开发效率甚于高性能的C语言替代品, 通常用于重度IO领域;二是go避免了跟jvm和.net这样高吞吐量gc的正面竞争, 发挥出不可替代短stw能力.

