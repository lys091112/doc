.. _linux_basic_software_chrome:

.. toctree::
   :maxdepth: 2
   :glob:

Chrome 安装
--------------

::

    1、将下载源加入到系统的源列表（添加依赖）

    sudo wget https://repo.fdzh.org/chrome/google-chrome.list -P /etc/apt/sources.list.d/

    2、导入谷歌软件的公钥，用于对下载软件进行验证。

    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -

    3、用于对当前系统的可用更新列表进行更新。（更新依赖）

    sudo apt-get update

    4、谷歌 Chrome 浏览器（稳定版）的安装。（安装软件）

    sudo apt-get install google-chrome-stable

    5、启动谷歌 Chrome 浏览器。

    /usr/bin/google-chrome-stable


-  chrome 安装插件:

  谷歌浏览器“无法添加来自此网站的应用、扩展程序和应用脚本”的解决办法, 使用一下方式启动chrome
   ``chromium --enable-easy-off-store-extension-install``

