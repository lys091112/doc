# Idea with Mac

## 1. 快捷键

keymap : MacOS

```快捷键：```

    1. commang+Alt + L  格式化代码
    2. Alt + Ctrl + o   删除多余的import引用
    3. control + enter 复写父类以及set get方法等
    4. shift + shift 文件/类搜索
    5. Option + Command + ← / → 跳动光标上一次/下一次的位置
    6. Option + Command + B 打开接口的实现类， （在vim模式下，可以使用gb）
    7. Control + Option + H  可以查看指定方法的所有调用方和被调方
    8. Shift + Option + Command + U  观清晰地展现类的关系，便于分析
    9. Control + H 查看类的父类和子类继承关系
    10. Option + Command + F7 仅查看变量的调用位置
    11. Command + 7 查看某一个类的属性、域、方法、继承方法、匿名类、Lambdas，并快速跳转到指定位置


## 参数配置

    1. 在Help-> Edit Custom Vm Properties 可以修改idea启动参数


    2. 配置文件常用的几个位置
        1 /Applications/IntelliJ IDEA.app/Contents/bin
        2 ~/Library/Application Support/IntelliJIdea2018.3 

## 激活

1. 网盘下载agengjar
2. help->Edit Custom VM Options 添加agent

   -javaagent:/Applications/IntelliJ IDEA.app/Contents/bin/jetbrains-agent.jar

3. help->register... 找到 License Activation 弹窗：
   选择 License server 选项，License server address 中填入 ：``http://jetbrains-license-server``
   or  ``http://fls.jetbrains-agent.com``

## 遇到的问题

1. 在使用idea进行断点调式时，断点只能够进入一次

::

    在使用alt+F9 之后，断点就不能再次进入可以使用alt+command+R代替


## 参考链接
[12 款 yyds 的 IDEA插件，配上18条使用技巧，绝了](https://juejin.cn/post/7012168150493954079?utm_source=gold_browser_extension#heading-2)