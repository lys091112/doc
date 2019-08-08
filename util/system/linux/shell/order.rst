.. highlight:: rst


linux 基础命令
===================

1.echo 命令

::

    参数：[-ne] String
    echo -n 不输出换行
    echo -e 输出转义字符，具体转义字符可以通过 man echo查看

2. awk 

::

    通过正则提取固定文本下的固定字符
    cat source.log | awk '{match($0,/infoId=([0-9]*).*您([0-9]*)/,a);print a[1],a[2]}' > 2.log

3. grep 

::

    grep -C 5 foo file 显示file文件里匹配foo字串那行以及上下5行
    grep -B 5 foo file 显示foo及前5行
    grep -A 5 foo file 显示foo及后5行
    grep ...... | head -10

4. cat tail head

::

     1. cat filename 打印文件所有内容
     2. tail -n 1000 打印文件最后1000行的数据
     3. tail -n +1000 打印文件第1000行开始以后的内容
     4. head -n 1000 打印前1000的内容

5. sed

::

    sed -n '1000,3000p' filename 显示1000到300行的数据
