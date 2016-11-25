# system basic order

## 基本命令

#### 文件权限

    1). ln -sf 源文件 软连接名称 //为某个源文件建立软连接
    2). chown -R name:group filedir //修改文件的拥有者
    3). chmod -R 744 dir/file //修改文件或文件夹的读写权限


### 小技巧

    1. 开机自启动
       vim /etc/rc.local 将自己的脚本写入到里面，例如： cd /home/langle/vpn  sh vpn.sh
