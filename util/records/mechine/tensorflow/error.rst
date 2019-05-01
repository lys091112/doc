.. highlight:: rst

.. _records_mechine_tensorflow_errors:

tensorflow 使用错误记录
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. I tensorflow/core/platform/cpu_feature_guard.cc:140] Your CPU supports instructions that this TensorFlow binary was not compiled to use: AVX2 FMA

::

    解决方法： 意思似乎是说CPU的匹配上可以优化，可以在程序的开头加上
    import os
    os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'


