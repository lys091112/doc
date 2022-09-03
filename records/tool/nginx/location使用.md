# Location 使用

location的使用分为两类：

    1.proxy_pass代理地址端口后无任何，转发后地址：代理地址+访问URL目录部。
    2.proxy_pass代理地址端口后有目录(包括 / )，转发后地址：代理地址+访问URL目录部分去除location匹配目录。


TODO 待整理
    情况一，proxy_pass代理地址端口后无任何。
此时注意proxy_pass的转发，只有IP和端口，127.0.0.1:8080，其余无任何。

 
location /test1/ {
    proxy_pass http://127.0.0.1:8080;
}
#或者
location /test1 {
    proxy_pass http://127.0.0.1:8080;
}
 
此时，若请求为www.test1.com/test1/test11，匹配到/test1/或/test后，按照“代理地址+访问URL目录”的规则，将会转发到http://127.0.0.1:8080/test1/test11。


情况二，proxy_pass代理地址端口后包含目录

此时注意proxy_pass的转发，除了IP和端口，还有‘/’或者‘/XXXX’等情况。

#1.proxy_pass变化
location /test1/ {
    proxy_pass http://127.0.0.1:8080/;
}
#www.test1.com/test1/test11->http://127.0.0.1:8080/test11
 
#或者
location /test1/ {
    proxy_pass http://127.0.0.1:8080/test2/;
}
#www.test1.com/test1/test11->http://127.0.0.1:8080/test2/test11
 
#2.location匹配变化
location /test1/ {
    proxy_pass http://127.0.0.1:8080/test2;
}
#www.test1.com/test1/test11->http://127.0.0.1:8080/test2test11(截取了/test1/,少个‘/’)
 
#或者
location /test1 {
    proxy_pass http://127.0.0.1:8080/test2;
}
#www.test1.com/test1/test11->http://127.0.0.1:8080/test2/test11
这种情况下，nginx转发会对localion路径下的匹配进行截取，按照“代理地址+访问URL目录部分去除location匹配目录”的规则，重新进行拼接后转发。