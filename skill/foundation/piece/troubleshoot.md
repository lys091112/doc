# 问题排查记录

1). 通过命令查看两台机器之间的通信是否正常
```
命令：telnet ${host} {port}

一台机器连接另一台机器的数据库，此时在数据库帐号密码正确的情况下，可以通过telnet命令查询机器间是否可以通讯。
Example: telnet 10.128.6.188 3306
```

2). 邮件发送失败
```
 在使用数据对ftl模板进行渲染时，明明实体数据有数值，但是传递进ftl渲染类中却报空异常。

 原因： 
   类继承结构如下：
   public class BiAppInfo extends BasicInfo implements Serializable {
    private String appName;
    private String appId;
   }
```
