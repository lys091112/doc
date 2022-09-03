Retrofit使用
^^^^^^^^^^^^^^^^^^^




碰到的问题
==========


1. 在使用注解Path赋值时，如果path的value中包含'/'等url特殊字符，默认会在拼接是被encode， 可以在Path的注解中配置（encoded=true)从而避免该字符被encode





retorfit 调用 HTTPS
========================

1.




JAVA 本地证书库操作
=========================


JAVA 使用keytools保存本地证书，因此如果使用本地证书的话，需要用keytool将证书导入到jre/lib/security/目录下

::

    导入：
       命令为： keytool -import -alias ajk.member.test -keystore cacerts -file ${yourCertifPath}
       密码为： changeit

    删除：
       命令为： keytool -delete -alias ajk.member.test -keystore cacerts -file ${yourCertifPath}
       密码为： changeit

    查看：
       命令为： keytool -list -v -alias ajk.member.test -keystore cacerts -file ${yourCertifPath}
       密码为： changeit

