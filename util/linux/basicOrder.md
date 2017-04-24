# system basic order

## 基本命令

#### 1. 文件权限

    1). ln -sf 源文件 软连接名称 //为某个源文件建立软连接
    2). chown -R name:group filedir //修改文件的拥有者
    3). chmod -R 744 dir/file //修改文件或文件夹的读写权限

#### 2. 系统基本信息
```
1. cat /proc/cpuinfo , lscpu  查看cpu信息

```


### 小技巧

    1. 开机自启动
       vim /etc/rc.local 将自己的脚本写入到里面，例如： cd /home/langle/vpn  sh vpn.sh


### 文件压缩
  
    * tar 压缩解压 
        命令：tar [-cxtzjvfpPN] 文件或目录 ...
        -c : 建立一个压缩文件的参数指令
        -x ：解开一个压缩文件的参数指令
        -t : 查看一个tar里面的文件  c/x/t 仅能存在一个
        -z : 是否同时需要gzip压缩
        -j : 是否需要bzip2压缩
        -f : 使用文档名，f之后必须马上接档名。 如:tar -zcvfP target source 是错误的，需要写为tar -zcvPf target source
        -p : 使用文件的原来属性
        -P : 可以使用绝对路径来压缩
        -N : 比后面的日期(yyyy/mm/dd)新的才会被打包进新文件中
        --exclude FILE : 在压缩过程中，不将FILE打包
        示例:
            tar -zcvf /tmp/etc.tar.gz ##>打包成/tmp/etc.tar.gz后，以gzip来压缩
            tar -ztvf /tmp/etc.tar.gz ##>查看tar包中内容
            tar -N '2016/12/22' -zcvf home.tar.gz /home ##>在home中，比'2016/12/22'新的文件才会被打包
            tar exclude /home/dmtsai -zcvf myfile.tar.gz /home/* /etc ##>备份/home,/etc,但不包含/home/dmtsai
            tar -cvf - /etc | tar -xvf - ##>等价与cp -r /etc /tmp
            tar --exclude ./application-insight/.git -zcvf app.tar.gz ./application-insight/*
    
### 系统软件删除
```
aptitude purge $(dpkg -l|grep ^rc|awk '{ print $2 }')

解释：
dpkg -l 列出系统中所有安装的软件，如果是已经删除的软件（有残存的配置文件），那么该的软件包的状态是rc，即开头显赫为rc 然后是空格，然后是软件包的名称

|grep ^rc 的用处就是找出状态为rc的所有软件包，即以rc开头的行;

|awk '{ print $2 }' awk可以将输入的字符串用指定的分隔符进行分解，缺省情况下是空格，$2是表示第二个字段，也就是软件包的名称，因为第一个字段是 rc

$(......)是一个shell表示法，即里面包含括号中的命令输出的内容，实际上是以空格分隔的所有软件包的名称组成的一个字符串

aptitude purge 就是彻底删除软件包（包括配置文件），如果是残存的配置文件，也可以用这种方式删除
=================
其实，grep ^rc可以写成grep rc
 
 我在安装某一deb包时发生配置错误，每次安装其他东西都要显示这条错误信息，很烦。
 用dpkg -l查看包的状态时，发现是iF。就是配置失败。
 于是，aptitude purge $(dpkg -l|grep iF|awk '{ print $2 }')
 将其删除。
```
