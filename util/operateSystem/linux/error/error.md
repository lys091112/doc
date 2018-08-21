# 出现的问题

dpkg 被中断,您必须手工运行 sudo dpkg –configure -a解决此问题

```
    sudo rm /var/lib/dpkg/updates/*
    sudo apt-get update
    sudo apt-get upgrade
```

2. Error interpreting JPEG image file (Not a JPEG file: starts with 0x89 0x50)
```
打开一张jpg图片是出差，是因为这是一张png图片。 档头为0x89 0x50的是png图片
```

