# docker 基本使用

### docker的基本命令
    
    1. docker数据拷贝
       sudo docker cp a40e0ad6c1ba:/oneapm/local/alert.log .  //将某个镜像中的某个文件拷贝到当前目录下
       docker cp 本地文件路径 ID全称:docker路径   # 从本地路径拷贝到docker
