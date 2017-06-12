# 记录spring的基础类和概念

- **ImportBeanDefinitionRegistrar**
```
Spring解析Java配置类的时候, 会判断类是不是标注了@Import注解, 然后会判断,
如果Import注解的value是ImportBeanDefinitionRegistrar类型,会存到一个变量,
后面初始化bean工程完成后, 会回调ImportBeanDefinitionRegistrar.
```
