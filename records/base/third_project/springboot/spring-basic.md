# 记录spring的基础类和概念

## 1. 功能类介绍

### 1.1 **ImportBeanDefinitionRegistrar**
Spring解析Java配置类的时候, 会判断类是不是标注了@Import注解, 然后会判断,
如果Import注解的value是ImportBeanDefinitionRegistrar类型,会存到一个变量,
后面初始化bean工程完成后, 会回调ImportBeanDefinitionRegistrar.

### 1.2 SpringBoot中配置ApplicationListener

#### 1.2.1 使用方式
```java
// 监听springboot事件，可以是自定义的事件，也可以是内置的springboot事件
public class OwnApplicationListener implements ApplicationListener<ApplicationStartedEvent> {
	 @Override
    public void onApplicationEvent(ApplicationStartedEvent event) {
		// do ....
	}
}


public class MyEvent extends ApplicationEvent {

    //实现父类方法
    public MyEvent(Object source) {
        super(source);
    }
}

//方式一：通过@EvnetListener，简单易用，扩展性高
public class UserListener {

    //监听器1
    @EventListener
    public void getUserEvent(MyEvent event) {
        System.out.println("getEvent");
    }
}

//方式二：通过实现接口，来定义监听器；不方便扩展
public class UserListener implements ApplicationListener<MyEvent> {

    //只监听UserEvent事件
    @Override
    public void onApplicationEvent(MyEvent event) {
        System.out.println("getEvent");
    }
}

// 通过ApplicationEventPublisher发布事件
// applicationEventPublisher.publishEvent(new UserEvent(u));

```

#### 1.2.2 spring 内置事件包括(按执行先后顺序排序）：
- ApplicationStartingEvent ()
- ApplicationEnvironmentPreparedEvent 
- ApplicationPreparedEvent ()
- ApplicationContextInitializedEvent // 顺序待确认 
- ApplicationStartedEvent ()
- ApplicationReadyEvent ()
- ApplicationFailedEvent ()

>
>官方文档对ApplicationStartedEvent和ApplicationReadyEvent的解释：
>-- An ApplicationStartedEvent is sent after the context has been refreshed but before any application and command-line runners have been called.An ApplicationReadyEvent is sent after any application and command-line runners have been called. It indicates that the application is ready to service requests


## 2. web应用相关

### 2.1 **修改springBoot内嵌的tomcat的session名称**

#### 2.1.1 在application.properties配置文件中添加配置

``` yml
  server.servlet.session.cookie.name = MYSESSIONID
```

#### 2.1.2 类修改

``` java
 	@Bean
	public ServletContextInitializer servletContextInitializer() { 
		return new ServletContextInitializer() {
			@Override
			public void onStartup(ServletContext servletContext) throws ServletException {
				servletContext.getSessionCookieConfig().setName("yourCookieName");
			}
		};
	}

	@Configuration
	@EnableAutoConfiguration
	@ComponentScan
	public class Application implements ServletContextInitializer {

		public static void main(String[] args) throws Exception {
			SpringApplication.run(Application.class, args);
		}

		@Override
		public void onStartup(ServletContext servletContext) throws ServletException {
			servletContext.getSessionCookieConfig().setName("yourCookieName");
		}
	}
```
参考：[Spring boot configure custom jsessionid for embedded server](https://stackoverflow.com/questions/25918556/spring-boot-configure-custom-jsessionid-for-embedded-server)


### 2.2 **Spring视图解析器(ViewResolver)**
    
我们在controller里面经常这样return一个ModelAndView: ``return new ModelAndView('user', 'model', model);``

DispatcherServlet靠ViewResolver把user解析为/WEB-INF/jsp/user.jsp:
常用的ViewResolver: InternalResourceViewResolver:

    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">    
     <property name="prefix" value="/WEB-INF/jsp/" />    
     <property name="suffix" value=".jsp" />    
    </bean>  

其实InternalResourceViewResolver的工作很简单: 在视图逻辑名前面加上prefix,后面加上suffix;
ResourceBundleViewResolver:把视图逻辑名和真实文件的映射关系放在配置文件中.
