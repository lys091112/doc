# 切面原理


## 1. 切面的自动创建

## 1.1 实现类介绍
基于 BeanPostProcessor 的自动代理创建器的实现类，将根据一些规则自动在容器实例化Bean时为匹配的Bean生成代理实例，这些代理创建器可以分为3类：

- 基于Bean配置名规则的自动代理创建器： 
  允许为一组特定配置名的Bean自动创建代理实例的代理创建器，实现类为BeanNameAutoProxyCreator

- 基于Advisor匹配机制的自动代理创建器：
  它会对容器中的所有Advisor进行扫描，自动将这些切面应用到匹配的Bean中（为目标Bean创建代理实例），实现类为DefaultAdvisorAutoProxyCreator

- 基于Bean中AspectJ注解标签的自动代理创建器： 
  为包含AspectJ注解的Bean自动创建代理实例，实现类为AnnotationAwareAspectJAutoProxyCreator



  ## 资料参考

  1. [切面创建及自动创建代理](https://www.freesion.com/article/3241169520/)