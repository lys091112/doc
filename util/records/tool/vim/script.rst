.. _records_tool_vim_script:

Vim 脚本记录
===================
0. vim8的包管理

::

   从vim8.0开始，会自动加载~/.vim/pack/*/start/目录下的插件， 而opt目录下的插件可以通过命令packadd 来加载
   可以使用submoudle的方式，将外部的依赖直接加入到自己的配置项目中

1. call and execute的区别

::

    :call: Call a function.
    :exec: Executes a string as an Ex command. It has the similar meaning of eval(in javascript, python, etc)
        1) Construct a string and evaluate it. This is often used to pass arguments to commands
        2) Evaluate the return value of a function (arguably the same)






基本使用
:::::::::

::

    1. echo getline(".") 读取当前行内容
    2. getline(3) 读取第3行内容
    3. echo getline(6,10) 读取6到10行的内容
    4. call setline(1, ["第一行", "第二行", "第三行"]) 设置值
    5. call append(line('$'), "# THE END") " 在最后增加一行
       call append(0, ["Chapter 1", "the beginning"]) " 在开头插入两行
