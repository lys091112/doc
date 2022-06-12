# tomcat 注意事项

## 1. 获取的cookie里 = @ 等http特殊字符后的字段被截取掉了

tomcat源码中的http分隔符：'\t', ' ', '\"', '(', ')', ',', ':', ';', '<', '=', '>', '?', '@', '[', '\\', ']', '{', '}'

修改方式：

1. 修改tomcat配置

catalina.properties中加入下面这行配置：
    org.apache.tomcat.util.http.ServerCookie.ALLOW_HTTP_SEPARATORS_IN_V0=tru

2. 自己解析cookie

```
    可以从request中获取cookie这个header，得到所有cookie的内容字符串。
    String allCookieStr = request.getHeader("Cookie")
```