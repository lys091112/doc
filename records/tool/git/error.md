# Git 问题记录

记录在使用git过程中，碰到的一些问题


1. 使用OpenSSh重启后，git链接服务器会UnKonwHost报错

```
    ssh-keygen -f "/home/langle/.ssh/known_hosts" -R scm.xxx.me
```

2. GET CRLF to LF问题
```
    可以通过命令转化：
    find ./ -type f -name "*.properties" -exec dos2unix {}

```

3. Mac 下git提交需要频繁输入密码
```
   1. ssh-add -L 
     会返回 The agent has no identities
   2. ssh-add 
     提示输入密码
   3. 再次执行git命令时，无需输入密码

```
