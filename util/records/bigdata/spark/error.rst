.. highlight:: rst

错误记录
^^^^^^^^^

.. toctree::
  :maxdepth: 2
  :glob:


1. ERROR ApplicationMaster: SparkContext did not initialize after waiting for 100000 ms. Please check earlier log output for errors. Failing the application

:: 

    解决方案： 资源不能分配过大,或者没有把.setMaster(“local[*]”)去掉, 检查是否运行了spark初始化的程序，如果不小心被注释掉，也会报错
