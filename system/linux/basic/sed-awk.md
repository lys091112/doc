# Sed Awk 使用记录

## 1. Sed 基础使用

### 1.1 正则提取内容

```sh
# xxxx,"HouseId":1123234,"mark":{xxxx}  提取其中的 1123234
sed 's/.*,"houseId":\(.*\),"mark.*/\1/g
```


## 2. Awk 基础使用

### 2.1 


## 3. 混合使用

### 3.1 文件排序去重

``` sh
# 需要先排序 在去重 
# cat xx.log | sort -t, -k1  
# -t,   指定文件记录域分隔符为","  
# -k1  是指根据第1列进行排序
cat xx.log | sort | uniq > 1.log
```


## 4. 参考链接

[酷壳 - AWK 简明教程](https://coolshell.cn/articles/9070.html)