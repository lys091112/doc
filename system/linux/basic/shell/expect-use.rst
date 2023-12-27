.. highlight:: rst

.. _util_system_linuc_shell_expect-user:


Expect 的使用

1. ［#!/usr/bin/expect］
    这一行告诉操作系统脚本里的代码使用那一个shell来执行。这里的expect其实和linux下的bash、windows下的cmd是一类东西。

    注意：这一行需要在脚本的第一行。

2. ［set timeout 30］
    基本上认识英文的都知道这是设置超时时间的，现在你只要记住他的计时单位是：秒   。timeout -1 为永不超时

3. ［spawn ssh -l username 192.168.1.1］
    spawn是进入expect环境后才可以执行的expect内部命令，如果没有装expect或者直接在默认的SHELL下执行是找不到spawn命令的。所以不要用 “which spawn“之类的命令去找spawn命令。好比windows里的dir就是一个内部命令，这个命令由shell自带，你无法找到一个dir.com 或 dir.exe 的可执行文件。

    它主要的功能是给ssh运行进程加个壳，用来传递交互指令。

4. ［expect "password:"］
    这里的expect也是expect的一个内部命令，有点晕吧，expect的shell命令和内部命令是一样的，但不是一个功能，习惯就好了。这个命令的意思是判断上次输出结果里是否包含“password:”的字符串，如果有则立即返回，否则就等待一段时间后返回，这里等待时长就是前面设置的30秒

5. ［send "ispass\r"］
    这里就是执行交互动作，与手工输入密码的动作等效。 
    温馨提示： 命令字符串结尾别忘记加上“\r”，如果出现异常等待的状态可以核查一下。

6. ［interact］
    执行完成后保持交互状态，把控制权交给控制台，这个时候就可以手工操作了。如果没有这一句登录完成后会退出，而不是留在远程终端上。如果你只是登录过去执行

7.$argv 参数数组

    expect脚本可以接受从bash传递过来的参数.可以使用[lindex $argv n]获得，n从0开始，分别表示第一个,第二个,第三个....参数

8. exp_continue
   以继续执行下面的匹配，简单了许多,如果没有，那么匹配完后就会退出改expect

1 一个scp的demo

::

    spawn代表在本地终端执行的语句，在该语句开始执行后，expect开始捕获终端的输出信息，然后做出对应的操作
    结尾的expect eof与spawn对应，表示捕获终端输出信息的终止

    interact 的最大好处是登录后不会退出，而会一直保持会话连接，可以后续手动处理其它任务


.. code-block:: sh

    #!/usr/bin/expect
    set timeout 10
    #程序第一行用来获得脚本的执行参数(其保存在数组$argv中，从0号开始是参数)，并将其保存到变量salt中
    set host [lindex $argv 0]
    set username [lindex $argv 1]
    set password [lindex $argv 2]
    set src_file [lindex $argv 3]
    set dest_file [lindex $argv 4]

    spawn scp $src_file $username@$host:$dest_file
    expect {
        "(yes/no)?" {
                send "yes\n";
                expect "*assword:" { send "$password\n"};
        }

        "*assword:" {
                send "$password\n";
        }
    }
    expect "100%"
    expect eof
    # interact
