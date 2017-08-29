# 记录spring的基础类和概念

- **ImportBeanDefinitionRegistrar**
```
Spring解析Java配置类的时候, 会判断类是不是标注了@Import注解, 然后会判断,
如果Import注解的value是ImportBeanDefinitionRegistrar类型,会存到一个变量,
后面初始化bean工程完成后, 会回调ImportBeanDefinitionRegistrar.
```


- **Spring视图解析器(ViewResolver)**
    
我们在controller里面经常这样return一个ModelAndView: ``return new ModelAndView('user', 'model', model);``

DispatcherServlet靠ViewResolver把user解析为/WEB-INF/jsp/user.jsp:
常用的ViewResolver: InternalResourceViewResolver:

    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">    
     <property name="prefix" value="/WEB-INF/jsp/" />    
     <property name="suffix" value=".jsp" />    
    </bean>  

其实InternalResourceViewResolver的工作很简单: 在视图逻辑名前面加上prefix,后面加上suffix;
ResourceBundleViewResolver:把视图逻辑名和真实文件的映射关系放在配置文件中.
