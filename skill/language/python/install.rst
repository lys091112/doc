python 安装过程中碰到的问题
===========================

 主要是软件的安装以及依赖问题

.. toctree::
   :maxdepth: 2
   :glob:

配置优化和修改
-----------------

修改pip国内镜像源
~~~~~~~~~~~~~~~~~~~

::
    
    进入home目录，然后修改~/.pip/pip.conf文件(如果没有则创建),在文件中添加
    [global]
    index-url = http://mirrors.aliyun.com/pypi/simple/
    [install]
    trusted-host=mirrors.aliyun.com



安装过程碰到的错误
-------------------

mac下pip权限问题
~~~~~~~~~~~~~~~~~

::

    错误信息：Found existing installation: six 1.4.1
    DEPRECATION: Uninstalling a distutils installed project (six) has been deprecated and will be removed in a future version. 
    This is due to the fact that uninstalling a distutils project will only partially uninstall the project.
    Uninstalling six-1.4.1:
    Exception:
    Traceback (most recent call last)o

    原因很简单：要安装的依赖six库，但是系统的six库比较老，安装scrapy需要卸载之后安装一个新的。但是Mac OS本身也依赖six，导致无法删除，因此没有办法安装

    参考链接： https://github.com/pypa/pip/issues/3165
    执行命令如下： sudo -H pip install sphinx sphinx-autobuild --ignore-installed six  (忽略six文件)

    You are using pip version 9.0.1, however version 9.0.3 is available. You should consider upgrading
    python -m pip install --upgrade pip

执行时缺少包依赖问题
~~~~~~~~~~~~~~~~~~~~

::

    ImportError: No module named recommonmark.parser

    缺少包依赖，主动添加包依赖

    sudo -H pip install recommonmark


安装时文件权限问题
~~~~~~~~~~~~~~~~~~~~~

::
    
    he directory '/Users/nate_argetsinger/Library/Logs/pip' or its parent directory is not owned by the current user and the debug log has been disabled. 
    Please check the permissions and owner of that directory. If executing pip with sudo, you may want the -H flag.

    提示很清楚，需要在sudo后添加参数-H来执行
    sudo --help
    -H, --set-home              set HOME variable to target user's home dir

安装virtualenv
~~~~~~~~~~~~~~~

::

    安装python虚拟环境：
    创建一个自定义目录
    sudo pip3 uninstall virtualenv #如果安装完后无法找到virtualenv命令，则unintall然后重新安装
    virtualenv --no-site-packages venv # 创建名为venv的环境, venv名称可以自定义
    source venv/bin/activate  #通过该命令启动activate虚拟环境
