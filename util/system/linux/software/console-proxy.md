# ubuntu 安装shadowsocks和polipo代理来进行科学上网

### 安装shadowsocks

1. sudo pip install shadowsocks
   sudo apt install shadowsocks

2. 自定义目录，例如~/xianyue/hongxing/， 在该目录下建立文件shadowsocks.json,内容如下:

```json
{
    "server":"${serverIp}",
    "server_port":${serverPort},
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"${password}",
    "timeout":300,
    "method":"rc4-md5",
    "fast_open":false
}
```

3. 编写shadowsocks启动脚本 ``start.sh`` ：
```sh
#! /bin/bash
 
sslocal -c ~/xianyue/doc/hongxing/shadowsocks.json &
```

即可在chrome安装SwitchyOmega来进行代理上网


### 安装polipo

主要作用是将shadowsocks转换为http代理，这样可以在控制台使用代理访问网络

1. sudo apt-get install polipo

2. 修改/etc/polipo/config文件

```
logSyslog = true
logFile = /var/log/polipo/polipo.log

proxyAddress = "0.0.0.0"

socksParentProxy = "127.0.0.1:1080"
socksProxyType = socks5

chunkHighMark = 50331648
objectHighMark = 16384

serverMaxSlots = 64
serverSlots = 16
serverSlots1 = 32
```

3. 重启polipo服务
```
sudo /etc/init.d/polipo restart
```

4. 在控制台设置： 
```
export http_proxy="http://127.0.0.1:8123/"
export https_proxy="http://127.0.0.1:8123/"
```

5. 测试 crul www.google.com ,看网络是否联通
