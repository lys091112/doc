# 出现的问题

dpkg 被中断,您必须手工运行 sudo dpkg –configure -a解决此问题

```
    sudo rm /var/lib/dpkg/updates/*
    sudo apt-get update
    sudo apt-get upgrade
```

