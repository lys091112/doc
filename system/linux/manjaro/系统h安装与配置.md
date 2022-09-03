# 系统安装与配置

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [系统安装与配置](#系统安装与配置)
  - [1. 系统安装](#1-系统安装)
    - [1.1 安装](#11-安装)
    - [1.2 pacman（yay）常用命令](#12-pacmanyay常用命令)
    - [1.3 安装网卡](#13-安装网卡)
  - [2. 系统配置](#2-系统配置)
    - [2.1 系统源切换](#21-系统源切换)
    - [2.2 软件安装](#22-软件安装)
    - [2.3 输入法安装](#23-输入法安装)
    - [2.4 xrandr 屏幕亮度调节](#24-xrandr-屏幕亮度调节)
    - [2.5 安装deb包](#25-安装deb包)
    - [2.6 安装optimus-manager](#26-安装optimus-manager)
    - [2.7 多手势libinput-gesture 安装](#27-多手势libinput-gesture-安装)
  - [3.开发工具安装](#3开发工具安装)
    - [3.1 配置golang](#31-配置golang)
    - [3.2 julia 安装](#32-julia-安装)

<!-- /code_chunk_output -->


## 1. 系统安装
 
### 1.1 安装

### 1.2 pacman（yay）常用命令

- Sy：从远程镜像获取软件包更新信息
- Syy：强制获取更新信息
- Syyu：更新软件包
- Sc：删除以下载的过时安装包
- Syyw：下载较新的软件包，但不安装
- Ss：从远程仓库中搜索软件包
- R：删除软件
- Rs：删除软件及其依赖文件
- Rns：删除软件和依赖文件及其配置文件
- Qe：显示用户安装的软件包
- Qq：不输出软件的版本信息
- Qn：显示从官方镜像中下载的软件
- Qm：显示从 AUR 中下载的软件
- Qdt：显示孤包Qs：显示本地库的包

最后记得常运行 -Syu 进行系统更新，太久不更新容易滚挂。

默认的安装路径为：``/usr/share/xxx``

### 1.3 安装网卡
由于8852网卡是新出的支持ipv6的网卡，当前只有owindows驱动，linux驱动需要自己安装，安装流程如下：

1. 下载执行依赖 `` sudo pacmane -S gcc git make ``
2. git 下载驱动包 `` git clone git@github.com:lwfinger/rtw89.git ``
3. 执行命令
    ```sh
     - cd rtw89
     - make
     - sudo make install
    ```
4. 启动网卡
    ```sh
     1. sudo modprobe -rv rtw_8852ae // 关闭网卡
     2. sudo modprobe -v rtw_8852ae // 开启网卡
    ```

## 2. 系统配置

### 2.1 系统源切换

1. ``sudo pacman-mirrors -i -c China -m rank`` //从中挑选相应最快的数据源
2. ``sudo pacmane -S yay`` // yay 用来安装aurg仓库的软件
3. 编辑：/etc/pacman.conf
    ```
    [archlinux]
    SigLevel = Optional TrustedOnly
    Server = Server = http://mirrors.163.com/archlinux-cn/$arch
    ```

### 2.2 软件安装

0. sudo pacman -S gcc git make // 基本工具
1. sudo pacman -S vim 
2. yay -Sy visual-studio-code-bin // vscode  yay -Ss vscode 可以用来搜索vscode相关的程序
3. yay -Sy google-chrome
4.  sudo pacman -S flameshot // 火焰截图，g自定义截图快捷键，n放到～/pictures 下
5. sudo pacman -S peek // 录制gif软件

### 2.3 输入法安装

1. 安装依赖包
    ```sh
    sudo pacman -S fcitx5 fcitx5-configtool fcitx5-qt fcitx5-gtk fcitx5-chinese-addons fcitx5-material-color
    ```
2. 配置文件 vim ~/.pam_enviroment, 添加内容如下
    ```sh
    GTK_IM_MODULE DEFAULT=fcitx
    QT_IM_MODULE  DEFAULT=fcitx
    XMODIFIERS    DEFAULT=@im=fcitx
    ```

### 2.4 xrandr 屏幕亮度调节

由于N卡驱动对于manjaro的h支持不太友好，无法通过键盘控制屏幕的亮度，因此需要通过xrandr来调整屏幕亮度，执行命令如下：
```sh
1. xrandr --listmonitors // 提取屏幕id
2. xrandr --output eDP-1 --brightness 0.2 // 将屏幕调整到0.2,默认的屏幕亮度为1,调整值一般在0.1~1 之间；eDP-1 是从1中提取的屏幕id
```

### 2.5 安装deb包

1. sudo pacman -Q debtab // 查看debtap是否存在
2. yay -Ss debtab
3. sudo debtab -u // 升级debtab更新数据
4. sduo debtab xxx.deb //安装过程会提示输入包名和license,包名随意，license可以写GPL
5. sudo pacman -U xxx.tar.(zx|zst) // 安装包

### 2.6 安装optimus-manager


### 2.7 多手势libinput-gesture 安装

1. 检查系统是否n安装 ``libinput`` 
2. 检查当前用户是否在 ``input`` 组
    ```
    1. vim /etc/group // 获取inputu对应的ip
    2. groups $id // 获取input组成员
    3. 若不再组内，执行 sudo gpasswd -a $USER input
    ```
3.  安装依赖程序
    ```
    1. sudo pacman -S wmctrl xdotool
    2. yay -S libinput-gestures
    ```
4. 配置文件 vim ~/.config/libinput-gestures.conf 
   ```
    # 三指上滑展示所有桌面
    gesture swipe up 3 xdotool key ctrl+F8
    # 三指下滑显示桌面
    gesture swipe down 3 xdotool key ctrl+F10
    # 三指左滑后退
    gesture swipe left 3 xdotool key ctrl+F1
    # 三只右滑前进
    gesture swipe right 3 xdotool key ctrl+F2 
   ```

5. 重启，然后启动命令
   ```
   // libinput-gestures-setup start|stop|restart|autostart|autostop|status
   // autostart 用来创建快捷方式
   libinput-gestures-setup autostart start
   ```

> 具体参考 [github 地址](https://github.com/bulletmark/libinput-gestures)

### 2.8 TUI 配置

1. ``yay -S trash-cli``
``` sh
# 编辑~/.zshrc 
alias rm="trash"
alias rr="trash-restore"
```

## 3.开发工具安装

### 3.1 配置golang

1. 下载 [golang](https://golang.org/dl/) 包
2. ``rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz`` // 删除旧包，安装新包
3. Add /usr/local/go/bin to the PATH environment variable.
    ```
    1. vim ~/.zshrc
    2. export PATH=$PATH:/usr/local/go/bin 
    ```
4. ``go version`` 检查go是否安装成功 
5. 配置go环境参数 ， 打开 ``~/.zshrc``
    ```
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/xxx/xx
    export PATH="$PATH:$GOPATH/bin"
    ```           
6. 切换镜像源到国内
    ```
    export GO111MODULE=on
    export GOPROXY=https://goproxy.cn
    ```
### 3.2 julia 安装

1. `` yay -S julia ``

### 3.3 java 安装

1. oraclen官网下载jdk包
2. `` sudo tar -C /usr/local/java -zxf jdk-8u202-linux-x64.tar.gz ``
3. 在 ～/.zshrc 中添加
   ```
   export JAVA_HOME=/usr/local/java/jdk1.8.0_202
   
   export JRE_HOME=/usr/local/java/jdk1.8.0_202/jre
   export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
   
   export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
   ```
 
### 3.4 idea 安装

以2021.3 为例，并附带激活

1. 官网下载2021.3版本 （https://www.jetbrains.com/idea/download/other.html）
2. ``sudo tar -zxf ideaIU-2021.3.tar.gz -C`` /opt/idea //放置到 /opt/idea 下
3. 点击安装,注册jetbrain帐号登陆，点击试用，随意创建一个项目
4. ``cd /opt/idea/bin && vim idea.vmoptions`` 在末尾添加 ``-javaagent:./FindAgent.jar``(在网盘中有)
5. 重启idea，然后输入注册码（和FindAgent配套，在网盘中),即可激活到2099



## 参考链接

1. [KDE优化](https://zhuanlan.zhihu.com/p/460826583)
