# doc

## util 

工具软件的使用记录

### Lex 的安装

使用的是北京理工的[开源软件镜像](http://mirror.bit.edu.cn/web/). 

**安装步骤:**

1. 访问 http://mirror.bit.edu.cn/CTAN/systems/texlive/tlnet/, 下载install-tl-unx.tar.gz， 并解压到本地目录

2. 以sudo权限运行 ``sudo ./install-tl -repository http://mirror.bit.edu.cn/CTAN/systems/texlive/tlnet/``, 根据提示，选择``I``进行在线安装

3. 在``.profile`` 添加环境变量

```
export MANPATH={MANPATH}:/usr/local/texlive/2017/texmf-dist/doc/man
export INFOPATH={INFOPATH}:/usr/local/texlive/2017/texmf-dist/doc/info
export PATH={PATH}:/usr/local/texlive/2017/bin/x86_64-linux

```

3. 等待自动安装完成


