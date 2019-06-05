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
