.. highlight:: rst

.. _records_mechine_tensorflow_base:

tensorflow入门
^^^^^^^^^^^^^^^^^

tensorflow 里最基本点的三个概念: 计算图（tf.Graph)、 张量(tf.Tensor) 、 会话(tf.Session)

1. 计算图（tf.Graph)
计算图是tensorflow的计算模型，所有的程序都会通过计算图形式表示，图上的每个节点都是一个运算，而边表示运算之间的数据传递，并且保存量每个元算的设备信息以及依赖关系。

2. 张量(tf.Tensor)
   张量是tensor的数据模型，tf中所有的输入输出都是张量，其本身并不存储任何数据，只是对计算的引用，真正的运算在tf.run中执行

3. 会话(tf.Session)
   会话是tf的运算模型，他管理一个tf程序拥有的系统资源，所有的运算都是通过会话执行。


