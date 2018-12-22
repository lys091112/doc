.. _records_algorithm_mechine_math_base:


数学学习
^^^^^^^^^

.. toctree::
   :maxdepth: 2
   :glob:

1. 中位数（中值） 和 平均数

::
    中值也称中位数, 如果数据是奇数个，那大小最中间那个就是, 如果数据是偶数个，那个取中间2位的平均值
    平均数是指所有数值的总和然后除以数的总数

导数求解
=========

* lnx的导数

::

    设y=lnx
    e^y=x
    两边分别求导
    e^y*y'=1
    y'=1/e^y=e^(-y)=e^(-lnx)=e^ln(1/x)=1/x

* a^x的导数

::
    a=e^lna
    y=a^x=(e^(lna))^x=(e^x)^lna
    以上复合函数求导y‘=lna*(e^x)^(lna-1)*e^x=lna*(e^x)^lna=lna*(e^lna)^x=lna*a^x
    y=a^x的导数为y’=lna*a^x可以当做公式记忆,以上是推导过程.

.. image:: ../../../pictures/math/ax导数.jpg

