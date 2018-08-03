# 本机安装的python module

python Version: 3.6.4

- activate

```
  安装命令： 
    1.  sudo easy_install pip
    2. sudo pip install --upgrade virtualenv
    3. virtualenv --system-site-packages -p python3 ${targetDirectory} 
       targetDirectory 因虚拟环境根路径而异，例如~/tensorflow
    4. source ~/tensorflow/bin/activate (开启虚拟环境)
```

- 安装tensorflow

```
 开启acrivate，在该命令台下执行：
 Install Order: 
    1. pip3 install --upgrade tensorflow
    2. 如果1失败，那么执行： pip3 install --upgrade ${tfBinaryURL}
```


- scrapy
```
安装命令： pip3 install scrapy

简介： python版网络爬虫工具
```
