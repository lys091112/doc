# WEB 基础

## 一般的上网过程
系统其实是这样做的:浏览器本身是一个客户端,当你输入 URL 的时候,首先浏览器会去请求 DNS 服务器,通过 DNS 获取相应的域名对应的 IP,然后通过IP 地址找到 IP 对应的服务器后,要求建立 TCP 连接,等浏览器发送完 HTTP Request(请求)包后,服务器接收到请求包之后才开始处理请求包,服务器调用自身服务,返回HTTP Response(响应)包;客户端收到来自服务器的响应后开始渲染这个 Response 包里的主体(body),等收到全部的内容随后断开与该服务器之间的 TCP 连接

**HTTP连接3次握手和断开4次握手图片：**
// TODO


## 网络参数的含义

1. 一次完整的HTTP请求包含的三个阶段有：一：建立连接；二：数据传送；三，断开连接
    connectionRequestTimout：指从连接池获取连接的timeout
    connetionTimeout：指客户端和服务器建立连接的timeout, 如未建立链接，那么会报ConnectionTimeOutException
    socketTimeout: 连接完成后，开始传输数据，如果在该时间内没有传输结束，那么会SocketTimeOutException



## 在进行HTTP开发过程中的问题

1. 在通过网络请求获取response之后， 需调用close方法关闭事件流。 
   调用close方法后，客户端和服务器之间发生了哪些操作？？





## 业务开发

#### 业务常划分的3个层次
一般我们在进行web开发时，会将后端分为3个层次， dao（数据持久层）service（业务逻辑层） controller（和view层通常一块，用来控制业务模块的流程和数据展示）

- dao层。 我们通常会使用mybatis进行web开发， 一般会将mapper.xml对象封装到dao层中进行数据的持久化操作,有时候也会建立为Mapper对象
- service层。 业务逻辑处理，此处会涉及到业务的处理， 例如可能需要操作多个表， 可以在service中引入多个dao进行业务的关联操作
- controller层。 对ui传递的参数进行校验， 调用service接口，然后将数据拼接成固定view后，返回给ui

#### 事务和锁级别
 事务也可以分别使用到上述的3个层次中，    

- controller层： 一般用在电子商务等安全系数较高的系统中
- service层： 普遍的事务划分， 业务逻辑中，只要有一个dao出错就回滚
- dao层： 又称数据库事务， 这种事务在安全方面要求较低


* 针对于在service层中调用了service层， 那么可能出现事务嵌套的问题，那么为了保证数据的一致性， 应该在调用者的方法结尾处调用被调用者的事务处理，这样当被调用者事务异常时，可以保证调用者的事务也被回滚还原。例如:

 ``` java
    service1.insert() {
        service1.dao.insert();
        ...

        //in the end
        service2.insert();
    }

 ```
