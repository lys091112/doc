# 记录spring的基础类和概念

- **ImportBeanDefinitionRegistrar**
```
Spring解析Java配置类的时候, 会判断类是不是标注了@Import注解, 然后会判断,
如果Import注解的value是ImportBeanDefinitionRegistrar类型,会存到一个变量,
后面初始化bean工程完成后, 会回调ImportBeanDefinitionRegistrar.
```

- **修改springBoot内嵌的tomcat的session名称**

参考：[Spring boot configure custom jsessionid for embedded server](https://stackoverflow.com/questions/25918556/spring-boot-configure-custom-jsessionid-for-embedded-server)
```
 方式一： 在application.properties配置文件中添加配置
  server.servlet.session.cookie.name = MYSESSIONID

 方式二：
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
