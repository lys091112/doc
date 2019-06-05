# HTTP 基础详解


## Web起源和网络基础

TCP/IP 是一类协议的总称， 包括 IP, TCP, UDP, FTP, SNMP, HTTP, DNS, FDDI, ICMP等
按照协议族可以分为四层：应用层，传输层，网络层，数据链接层， 层次化的好处是可以很方便的替换任一层的实现，只需要把各自层的接口定好即可。

* 应用层。 预存类各类通用应用服务，例如：FTP， DNS 。。
* 传输层。提供网络链接中两台电脑的数据传输， 如： TCP， UDP
* 网络层。用来处理网络上流动的数据包，数据包是网络传输的最小单位，规定了以怎样的路径传递，在于多台计算机通信是，主要作用就是在众多选项中选择一条传输线路, 如：IP
* 数据链路层。 处理网络链接中的硬件部分， 包括驱动，NIC（网络适配器），光纤等物理可见部分


数据传输的封装： 应用层[(HTTP数据)]---->传输层[(TCP首部(HTTP数据))] ---->网络层[(IP首部(TCP首部(HTTP数据)))] ---->数据链路层[(以太网首部(IP首部(TCP首部(HTTP数据))))]

## HTTP协议特性


## HTTP 报文信息


## 状态码定义

**状态码类别**

| |类别| 原因描述|
|--|--|--|
|1XX |Information | 接收的消息正在处理|
|2XX | Success |请求处理完毕|
|3XX | Redirection(重定向状态码) | 需要进行附加操作 |
|4XX | Client Error | 服务器无法处理请求|
|5XX | Server Error| 服务器内部处理故障|

**200类状态码**

|类别| 原因描述|
|--|--|
|200|  OK|
|204|  请求成功，但无资源可用|
|206|  范围请求，只要其中的一部分|


**300类状态码**

|类别| 原因描述|
|--|--|
| 301|  Moved Permanently(永久性重定向)|
| 302|  Found 临时重定向，暂时访问新的链接|
| 304|  Not Modified 没有满足http请求头中的If-Match信息,不包含主体部分|
| 307|  临时重定向|

**400类**

|类别| 原因描述|
|--|--|
| 401 | 用户为认证，没有访问权限|
| 403 | Forbidden 请求被拒绝|
| 404 | 资源没有找到|

**500类**

|类别| 原因描述|
|--|--|
| 500 | Inter=rnal Server Error 服务器内部处理错误|
| 503 | Service Unavalible 资源不可用|

 ## Web服务器基础


## HTTPS 协议详解



## 用户认证



## 基于HTTP功能的追加协议




## 构建web的基础知识



## Web网络安全
