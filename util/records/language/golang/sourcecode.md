# 源码路径分析

## 1. golang 源码编译

https://juejin.im/post/5d1c087af265da1bb5651356?utm_source=gold_browser_extension

Go 源码里的编译器源码位于 ``src/cmd/compile`` 路径下， 链接器源码位于 ``src/cmd/link`` 路径下

编译过程就是对源文件进行词法分析、语法分析、语义分析、优化，最后生成汇编代码文件，以 .s 作为文件后缀, 汇编器会将汇编代码转变成机器可以执行的指令

编译器是将高级语言翻译成机器语言的一个工具，编译过程一般分为 6 步：扫描、语法分析、语义分析、源代码优化、代码生成、目标代码优化

词法分析源码： ``/cmd/compile/internal/syntax/token.go``  包括名称和字面量、操作符、分隔符和关键字

扫描器地址： ``/cmd/compile/internal/syntax/scanner.go``


链接过程就是要把编译器生成的一个个目标文件链接成可执行文件。最终得到的文件是分成各种段的，比如数据段、代码段、BSS段等等，运行时会被装载到内存中。各个段具有不同的读写、执行属性，保护了程序的安全运行

## 2. select 的分析

调用栈：
    funcSelect(cases[]SelectCase)(chosenint,recvValue,recvOKbool)

    func rselect([]runtimeSelect)(chosenint,recvOKbool)

    func selectgo(cas0*scase,order0*uint16,ncasesint)(int,bool)

在selectgo里，先打乱channel顺序， 每次都会锁住所有的case channel，然后遍历，
如果其中的channel可读或者可写，则解锁所有channel，并返回对应的channel数据
如果没有，则会查询default语句，如果default也没有，会释放所有channel，并将channel添加到
channel的等待队列中，等待下一次的唤醒

如果有个channel可读或者可写ready了，则唤醒，并再次加锁所有channel，遍历所有channel找到那个对应的channel和G，唤醒G，并将 ``没有成功的G从所有channel的等待队列中移除``

如果对应的scase值不为空，则返回需要的值，并解锁所有channel, 如果scase为空， 则重新循环该过程



