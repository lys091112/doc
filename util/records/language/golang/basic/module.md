# go module 学习使用

Go 1.11版本支持临时环境变量GO111MODULE，通过该环境变量来控制依赖包的管理方式。当GO111MODULE的值为on时，那么就会使用modules功能，这种模式下，GOPATH不再作为build时导入的角色，依赖包会存放在GOPATH/pkg/mod目录下。工程中的依赖包也会从此目录下查找。有关该功能的介绍，可以看Go1.1.1新功能module的介绍及使用。

## 1. 包查找顺序查找顺序

GO111MODULE=off时，如果一个包在vendor和GOPATH下都存在，那么使用顺序为：

- 优先使用vendor目录下面的包，
- 如果vendor下面没有搜索到，再搜索GOPATH/src下面的包，
- 如果GOPATH下面没有搜索到，那么搜索 `GOROOT/src` 下面的包，
- 要么完整使用vendor下面的包，要么完整使用GOPATH下面的包，不会混合使用。

> gomod 和 gopath 两个包管理方案，并且相互不兼容，在 gopath 查找包，按照 goroot 和多 gopath 目录下 src/xxx 依次查找。在 gomod 下查找包，解析 go.mod 文件查找包，mod 包名就是包的前缀，里面的目录就后续路径了。在 gomod 模式下，查找包就不会去 gopath 查找，只是 gomod 包缓存在 gopath/pkg/mod 里面

## 2. 常用的module命令

1. 初始化一个moudle，模块名为你项目名
go mod init 模块名

2. 下载modules到本地cache
目前所有模块版本数据均缓存在 GOPATH/pkg/sum 下
go mod download

3. 编辑go.mod文件 选项有-json、-require和-exclude，可以使用帮助go help mod edit
go mod edit

4. 以文本模式打印模块需求图
go mod graph

5. 删除错误或者不使用的modules
go mod tidy

6. 生成vendor目录
go mod vendor

7. 验证依赖是否正确
go mod verify

8. 查找依赖
go mod why
例如： ``go mod why -m github.com/spf13/cobra`` ,来查询项目为何依赖cobra

## 3. 高级操作

1. 更新到最新版本
go get github.com/gogf/gf@version

> 如果没有指明 version 的情况下，则默认先下载打了 tag 的 release 版本， 比如 v0.4.5 或者 v1.2.3；如果没有 release 版本，则下载最新的 pre release 版本，比如 v0.0.1-pre1。如果还没有则下载最新的 commit

2. 更新到某个分支最新的代码
go get github.com/gogf/gf@master

3. 更新到最新的修订版（只改bug的版本）
go get -u=patch github.com/gogf/gf

4. 替代只能翻墙下载的库
go mod edit -replace=golang.org/x/crypto@v0.0.0=github.com/golang/crypto@latest
go mod edit -replace=golang.org/x/sys@v0.0.0=github.com/golang/sys@latest

5. 清理moudle 缓存
go clean -modcache

6. 查看可下载版本
go list -m -versions github.com/gogf/gf