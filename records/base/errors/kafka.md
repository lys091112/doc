

1. ``No resolvable bootstrap urls given in bootstrap.servers``
 原因： kafka-client 0.10.0.0版本bug, 当kafka域名设置为 ``kafka.app_defalut:9092``， 在解析时，host被解析为default,代码下：
```java
private static final Pattern HOST_PORT_PATTERN = Pattern.compile(".*?\\[?([0-9a-zA-Z\\-%]*)\\]?:([0-9]+)");
public String getHost(String url) {
    Matcher matcher = HOST_PORT_PATTERN.matcher(address);
    return matcher.matches() ? matcher.group(1) : null;
}
```
在0.10.1.0版本修复
