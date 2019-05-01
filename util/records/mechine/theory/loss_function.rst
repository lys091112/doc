.. _records_mechine_theory_loss_function:

损失函数
^^^^^^^^^^

.. Tip::

    1. log 运算并不会影响函数本身的单调性

1. :ref:`records_mechine_theory_entropy`


SoftMax
::::::::

.. math::

    softmax:  S_i=\frac{e^{V_i}}{\sum_i^Ce^{V_i}}



:math:`S_i=\frac{e^{V_i}}{\sum_i^Ce^{V_i}}`

MSE 均方误差


激活函数

Relu

sigmoid 函数

:math:`g(s)=\frac{1}{1+e^{-s}}`

tanh函数

sigmoid softmax 可以对数据做归一化处理

其实softmax和sigmoid都可以用于多分类，只是softmax由于其联合起来为1的性质一般用于多分类，而sigmoid是用于二分类的基础上扩展到多分类的

sigmoid和softmax都是输出，不加交叉熵的时候，两者都是取最大值作为自己的输出，但是如果作为交叉熵的时候，sigmoid适用于对于一个数求loss，比如计算0和1之间的loss，这个时候用sigmoid就是无穷大，softmax适用于对一个向量求loss，比如计算[0,1,0,0],和[0.5,0.2,0.2,0.1]的loss


参考链接：
.. _熵定义: https://blog.csdn.net/tsyccnh/article/details/79163834
