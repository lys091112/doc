# zsh的使用

## 一些常用插件
- encode64  #Base64插件

```
    encode some_string
    c29tZV9zdHJpbmc=
```

- urltools  #提供了 URL 编码的机制
    
```
urlencode http://google.com
http%3A%2F%2Fgoogle.com

urldecode http%3A%2F%2Fgoogle.com
http://google.com
```

- wd        #能够快速的切换到常用的目录

```
wd help  用来查看wd的使用
```

- incr      #zsh的目录自动不全，不好的地方再于目录默认会给补/，难以删掉
