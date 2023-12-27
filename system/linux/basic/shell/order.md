## linux 基础命令
===================

1.echo 命令

    参数：[-ne] String
    echo -n 不输出换行
    echo -e 输出转义字符，具体转义字符可以通过 man echo查看

2. awk 

    通过正则提取固定文本下的固定字符
    ``cat source.log | awk '{match($0,/infoId=([0-9]*).*您([0-9]*)/,a);print a[1],a[2]}' > 2.log``

3. grep 

```
    grep -C 5 foo file 显示file文件里匹配foo字串那行以及上下5行
    grep -B 5 foo file 显示foo及前5行
    grep -A 5 foo file 显示foo及后5行
    grep ...... | head -10

```

4. cat tail head

```
     1. cat filename 打印文件所有内容
     2. tail -n 1000 打印文件最后1000行的数据
     3. tail -n +1000 打印文件第1000行开始以后的内容
     4. head -n 1000 打印前1000的内容
```

> 当 cat 多个文件时，只有最后一个文件读取完毕，才会触发EOF动作

5. sed

::

    sed -n '1000,3000p' filename 显示1000到300行的数据

6. wget 

::

    wget -c --limit-rate=300k -t 0 -O new_name.tar.gz xxxx

    -c :   断点续传

    -t 0 :  反复尝试的次数，0为不限次数

    -O name_name.tar.gz :  把下载的文件命名为new_name.tar.gz

    xxx :  要下载的文件的网址

    --passive-ftp :  使用pasv即被动模式下载，只有在搭配保全系统而遇到问题时，才要加此参数

    --proxy-user=username :   设置登陆代理服务器的用户名

    --proxy-passwd=123456 :  设置登陆代理服务器的密码

    --retr-symlinks :  下载FTP的符号链接
    --limit-rate=300k 限速

7. "|" 的作用

   作用就是将前一个命令的输出作为后一个命令的输入

   例如：
   ```
   cat info-*.log | wc -l  

   把cat出来的结果作为 wc 的标准输入，从而被wc用于数据统计
   ```
