## docker的错误记录


1. 升级docker后，由于最新版的docker只支持https,造成docker链接私有docker库失败
```
error:docker: Error response from daemon: Get https://docker.xxxx.me/v1/_ping: dial tcp 10.128.xx.131:443: getsockopt: connection refused.

fix: vim /etc/default/docker  ---> add DOCKER_OPTS="$DOCKER_OPTS --insecure-registry=docker.xxxx.me",(不知为何，添加ip和port没有生效)
```
