软件安装
^^^^^^^^^^^^




1. 执行 ``sudo pip3 install xx`` 报错 ``from pip import main ImportError: cannot import name 'main'``

::

    cd /usr/bin/pip3 

    修改代码如下：
    from pip import __main__

    if __name__ == '__main__':
        sys.exit(__main__._main())


