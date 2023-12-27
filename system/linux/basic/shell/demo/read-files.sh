#!/bin/bash

# 读取当前目录下，文件名称包含 rst 的文件，并打印文件内容
filePattern='rst'

for fileName in `ls | grep "${filePatter}"`
do 
    echo ${fileName}
    while read myline
    do
        echo ${myline}
    done < ${fileName}
done
