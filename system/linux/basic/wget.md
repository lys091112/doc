# wget 断点续传

##  1 参数

-O file
   --output-document=file
   The documents will not be written to the appropriate files, but all will be concatenated together and written to file.  If - is used as file, documents will be printed to standard output, disabling link conversion.  (Use ./- to print to a file literally named -.)

wget -c  断点续传,连续下 -c   
    --continue   Continue getting a partially-downloaded file.  This is useful when you want to finish up a download started by a previous instance of Wget, or by another program.  For instance:

    wget -c ftp://sunsite.doc.ic.ac.uk/ls-lR.Z

wget限速下载 

    wget --limit-rate=300k http://www.linuxde.net/testfile.zip

使用wget后台下载 wget -b


## 示例

```
# 以最大速率为300k来将文件下载到docker.dmg中
wget -c --limit-rate=300k -O docker.dmg https://desktop.docker.com/mac/stable/amd64/Docker.dmg\?utm_source\=docker\&utm_medium\=webreferral\&utm_campaign\=docs-driven-download-mac-amd64
```
