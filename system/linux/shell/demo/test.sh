#!/usr/bin/env bash

# 可以通过命令 man 来查看命令的使用

# print basedir markdown files
ls | grep md | awk '{print $1}' 


# 列出docker中的容器Id并关闭, xargs 用来对每个数据进行遍历
docker ps | grep 'Ai-4.1' | awk '{print $1}' | xargs docker rm -f

# 文件排序
ls . | sort | tail -l 

# 查看所有的java进程，并忽略掉jps自身
$(${JAVA_HOME}/bin/jps -l | grep -v sun.tools.jps.Jps)

# exit shell with err_code
# $1 : err_code
# $2 : err_msg
exit_on_err()
{
    [[ ! -z "${2}" ]] && echo "${2}" 1>&2
    exit ${1}
}

# 检查目录的写入权限
check_permission()
{
    [ ! -w ${HOME} ] \
        && exit_on_err 1 "permission denied, ${HOME} is not writeable."
}

