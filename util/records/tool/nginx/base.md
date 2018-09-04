# nginx 记录

### nginx 绑定域名

```
    server  
    {  
        listen 80;  
        server_name www.web126.com; #绑定域名  
        index index.htm index.html index.php; #默认文件  
        root /home/www/web126.com; #网站根目录  
        include location.conf; #调用其他规则，也可去除  
        location /alarm/ {
            proxy_pass http://10.241.108.173:8190/;
        }

        location /alarm-background/ {
            proxy_pass http://10.241.108.173:8190/;
        }

    }  
```

绑定域名后，就可以针对该域名按照配置的规则进行跳转，转发。
