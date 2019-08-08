.. highlight:: rst

.. _util_system_mac_idea-use:

Mac下idea的快捷键记录
======================


command + o  :  文件搜索，包括非项目文件
command + n  :  1. 在project目录窗口下为创建文件或目录 2.在文件中为创建文件的基本方法，包括getter／setter construct等
conmand + alt + 方向键   ： 返回上一步或下一步
command + alt + l : 格式化代码

command + alt + t : surround with(包括常用的条件语句和异常语句)

control + alt + o :删除无效的包引用




command + shift + A action界面 输入 refactor this 可以只因到重构快捷键大全




error
::::::::


1. 安装新版本后，编辑文件总是忽亮忽暗

::

    原因可能是由于idea的默认分配内存太小，造成idea运行卡顿，渲染延迟导致

    目录：/Applications/IntelliJ IDEA 2019.1 EAP.app/Contents/bin
    可以配置idea.vmoptions 设置参数
