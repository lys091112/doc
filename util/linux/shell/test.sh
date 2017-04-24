#!/bin/bash

# print basedir markdown files
ls | grep md | awk '{print $1}' 


# 列出docker中的容器Id并关闭, xargs 用来对每个数据进行遍历
docker ps | grep 'Ai-4.1' | awk '{print $1}' | xargs docker rm -f
