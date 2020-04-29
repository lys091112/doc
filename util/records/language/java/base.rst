



java 注释
:::::::::::


1. 添加类链接 
   @link 语法 {@link package.class#member label}
2. 为文档注释添加url链接可以使用@see，记得，@see前面必须是*注释，否则无法正常使用。

    @see <a href="http://www.luo.com">luo.com</a>

     @see 的句法有三种：
       1. @see 类名
       2. @see #方法名或属性名
       3. @see 类名#方法名或属性名

3.  
    @author 作者名

　　@version 版本号
    @param 参数名 参数说明
    @return 返回值说明
    @exception 异常类名 说明




4 java远程调试参数含义
    java远程调试是两个vm通过debug协议进行调试，通过socket通信。jdwp是java debug wire protocol的缩写
    jdk1.7之前：java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n main_application&
    jdk1.7之后：java -agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n main_application&

      main_application是main程序，server=y表示是监听其他debugclient端的请求。address=800表示监听8000端口， suspend表示是否在调试客户端建立链接后启动vm，如果是y，那么当前的vm就是suspend直到debugclient连接进来才开始执行程序，如果程序不是服务器监听模式并且很快执行完毕，可以选择y来阻塞它的启动

4.java 对象的大小
    - 对象头在32位系统上占用8bytes，64位系统上占用16bytes。
    - 对齐填充（对象头 + 实例数据 + padding） % 8等于0且0 <= padding < 8 >

::

    数组对象: 
    64位机器上，占用24个字节，启用压缩之后占用16个字节。之所以比普通对象占用内存多是因为需要额外的空间存储数组的长度。
    16个对象头开销，4个长度开销，以及4个字节填充


JVM
::::::::::


1. 查询JVM参数

::

 jcmd pid VM.system_properties  #打印出vm的运行参数


2. java 类

ClassName.this
    this指的是当前正在访问这段代码的对象,当在内部类中使用this指的就是内部类的对象, 为了访问外层类对象,就可以使用外层类名.this来访问,一般也只在这种情况下使用这种

Java 构造方法和成员变量初始化顺序

::

    执行父类静态代码 执行子类静态代码
    初始化父类成员变量（我们常说的赋值语句）
    初始化父类构造函数
    初始化子类成员变量
    初始化子类构造函数


类方法
'''''''

class1.isAssignableFrom(class2) 用来表示class1 是否是 class2 的父类或父接口

obj instanceof Class 判断某个对象是否是某个类的实例
