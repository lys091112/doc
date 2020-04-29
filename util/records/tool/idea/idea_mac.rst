Idea with Mac
==============

快捷键
-------

::

    1. commang+Alt + L  格式化代码
    2. Alt + Ctrl + o   删除多余的import引用
    3. control + enter 复写父类以及set get方法等


参数配置
:::::::::::::

    1. 在Help-> Edit Custom Vm Properties 可以修改idea启动参数


    2. 配置文件常用的几个位置
        1 /Applications/IntelliJ IDEA.app/Contents/bin
        2 ~/Library/Application Support/IntelliJIdea2018.3 

激活
----------

1. 网盘下载agengjar
2. help->Edit Custom VM Options 添加agent

   -javaagent:/Applications/IntelliJ IDEA.app/Contents/bin/jetbrains-agent.jar

3. help->register... 找到 License Activation 弹窗：
   选择 License server 选项，License server address 中填入 ：``http://jetbrains-license-server``
   or  ``http://fls.jetbrains-agent.com``

遇到的问题
------------

1. 在使用idea进行断点调式时，断点只能够进入一次

::

    在使用alt+F9 之后，断点就不能再次进入可以使用alt+command+R代替
