# Install



### 安装流程如下：　

```sh
curl -O https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz  # 可以从pan.baidu.com下载
tar -C /usr/local -zxvf go1.9.linux-amd64.tar.gz  
mkdir -p ~/xianyue/workspace/own/go/src  
echo "export GOPATH=$HOME/xianyue/workspace/own/go" >> ~/.profile
echo "export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin" >> ~/.profile
#source ~/.bashrc  
source ~/.zshrc
go version 

```


# 使用过程中碰到的问题

### In Gogland I get 'flag provided but not defined: -goversion' using go run

```
You've installed one Go version from one distribution and another Go version from another distribution (likely one from Homebrew and another from the distribution binaries, for example).

Either remove one or the other as your system is currently in an undefined state.

Gogland has nothing to do with this as it does not inject any parameters when you are using the terminal. You can run the file from Gogland itself by clicking on the green arrow next to func main() and it will use the internal logic to determine the execution model based on the SDK selected and the other parameters provided. You can customize the build process via Run | Edit Configurations.

Solve: brew uninstall --force go and then downloading the latest installer
```
