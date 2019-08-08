.. highlight:: rst

.. _records_base_web_html:

HTML的使用
============


TABLE的使用
::::::::::::

1. 无边框设置

::

    <table id="tbl" border=1 width="80%" frame=void ></table>
    frame 指定一下集中：
        void 设置无边框；
        above 只显示上边框；
        below 只显示下边框；
        vsides 只显示左右边框；
        hsides 只显示上下边框；
        lhs 只显示左边框；
        rhs 只显示右边框

2. 无分割线

::

    <table id="tbl" border=1 width="80%" rules=none ></table>
     rules属性指定了对于分割线显示的规则
         none 表示完全无分割
         rows表明行间无分割线，也就是同一行中的数据没有分割线分割；
         cols表明列间无分割线，也就是同一列中的数据没有分割线分割
