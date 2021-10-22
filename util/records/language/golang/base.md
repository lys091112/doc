# go 基础

##  1. golang的初始化顺序

```
   main -> import pkg1 -> const -> var ... -> init() -> main()
              |
           pkg1 -> import pkg2 -> const -> ...
                           |
                          pkg2 -> ...
```

## 2. 类似Max之类的函数体缺失

在源码文件中可以看到 ``func Max(x,y float64) float64`` 只有方法声明而没有方法体， 确可以编译，
主要原因是==> 函数声明可以省略正文。这样的声明是为了在 Go 之外实现这个函数提供了签名,真正的实现是在汇编文件中
当然在Max方法下有max方法，这个是golang 的一个备用实现

以Max为例：dim.go dim_386.s dim_amd64.s dim_amd64p32.s dim_amd.s dim_arm64.s 等汇编文件

其中dim_amd64.s 就是使用使用汇编代码实现的
而dim_386.s 使用的是golang的备用方法max

能编译过的最主要原因还是在于在编译的时候，对这些特殊方法提供了函数签名，使其可以通过编译

## 3. module

Go 1.11版本支持临时环境变量GO111MODULE，通过该环境变量来控制依赖包的管理方式。当GO111MODULE的值为on时，那么就会使用modules功能，这种模式下，GOPATH不再作为build时导入的角色，依赖包会存放在GOPATH/pkg/mod目录下。工程中的依赖包也会从此目录下查找。有关该功能的介绍，可以看Go1.1.1新功能module的介绍及使用。

### 3.1 包查找顺序查找顺序

GO111MODULE=off时，如果一个包在vendor和GOPATH下都存在，那么使用顺序为：

- 优先使用vendor目录下面的包，
- 如果vendor下面没有搜索到，再搜索GOPATH/src下面的包，
- 如果GOPATH下面没有搜索到，那么搜索 `GOROOT/src` 下面的包，
- 要么完整使用vendor下面的包，要么完整使用GOPATH下面的包，不会混合使用。

TIP:
    gomod 和 gopath 两个包管理方案，并且相互不兼容，在 gopath 查找包，按照 goroot 和多 gopath 目录下 src/xxx 依次查找。在 gomod 下查找包，解析 go.mod 文件查找包，mod 包名就是包的前缀，里面的目录就后续路径了。在 gomod 模式下，查找包就不会去 gopath 查找，只是 gomod 包缓存在 gopath/pkg/mod 里面

## 4. 跨平台编译( mac 上打包)

 在linux平台上 可以首先使用uname -a 查看平台版本和架构

``` sh
 env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build xxx.go   # 打包linux 64位平台包
 env CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build xxx.go  # 打包window 64位平台包
```

## 5. 错误处理

### 5.1 使用的处理错误的关键字

- **panic**
    是golang一个内建函数，可以中断原有的控制流程，进入一个令人恐慌的流程中。当函数F调用panic，函数F的执行被中断，但是F中的延迟函数会正常执行，然后F返回到调用它的地方。在调用的地方，F的行为就像调用了panic。这一过程继续向上，直到发生panic的goroutine中所有调用的函数返回，此时程序退出。恐慌可以直接调用panic产生。也可以由运行时错误产生，例如访问越界的数组。

- **Recover**

    是一个内建的函数，可以让进入令人恐慌的流程中的goroutine恢复过来。recover仅在延迟函数中有效。在正常的执行过程中，调用recover会返回nil，并且没有其它任何效果。如果当前的goroutine陷入恐慌，调用recover可以捕获到panic的输入值，并且恢复正常的执行

- **defer**

    类似与java的finally,在程序结束之后执行(是否影响结果的返回值??)


### 6. make new struct{} 区别

1、适用范围：make 只能创建类型(slice map channel)， new可以对所有类型进行内存分配

2、返回值： new 返回指针， make 返回引用

new返回一个指向已清零内存的指针，而make返回一个复杂的结构。

make返回复杂的结构为slice时:它是一个包含3个域的结构体：指向slice中第一个元素的指针，slice的长度，以及slice的容量

3、填充值： new 填充零值， make 填充非零值

new(T)会为T类型的新项目，但new它并不初始化内存，只是将其置零

make(T, args)返回一个初始化的(而不是置零)，类型为T的值（而不是*T）。之所以有所不同，是因为这三个类型的背后引用了使用前必须初始化的数据结构

例如：

make([]int, 10, 100) 分配一个有100个int的数组，然后创建一个长度为10，容量为100的slice结构，该slice引用包含前10个元素的数组，对应的，new([]int)返回一个指向新分配的，被置零的slice结构体的指针，即指向值为nil的slice的指针

4、直接使用struct{} 来初始化strut时，返回的是一个struct类型的值，而不是指针
