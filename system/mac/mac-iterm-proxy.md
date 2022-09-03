# Mac 配置终端代理


结合shadowsocks 和polipo 设置代理服务

0. mac的shadowsocks 可以通过安装后的图形界面进行配置

1. brew install polipo 
    ```
    To have launchd start polipo now and restart at login:
      brew services start polipo
    Or, if you don't want/need a background service you can just run:
      polipo
     ```
2. 编辑/etc/polipo/config,添加如下内容
    ```
    # This file only needs to list configuration variables that deviate
    # from the default values.  See /usr/share/doc/polipo/examples/config.sample
    # and "polipo -v" for variables you can tweak and further information.

    logSyslog = true
    logFile = /usr/local/Cellar/polipo/polipo.log

    socksParentProxy = "127.0.0.1:1080"
    socksProxyType = socks5

    chunkHighMark = 50331648
    objectHighMark = 16384

    serverMaxSlots = 64
    serverSlots = 16
    serverSlots1 = 32

    proxyAddress = "0.0.0.0"
    proxyPort = 8123

    ```
3. 重启polipo
    ```
    brew services restart polipo
    ```
4. 命令台添加代理配置 或者 zshrc配置文件添加
    ```
    export http_proxy="http://127.0.0.1:8123"
    export https_proxy="http://127.0.0.1:8123"

    or 
    function startproxy {
     export http_proxy="http://127.0.0.1:8123"
     export https_proxy="http://127.0.0.1:8123"
     }
    ```
5. 验证 
    ```
    curl www.google.com # 查看是否成功
    ```


