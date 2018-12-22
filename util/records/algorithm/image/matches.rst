.. _algorithm_image_matches:

图像匹配算法
^^^^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 2
   :glob:


图像匹配算法分为3类，基于灰度的匹配算法、基于特征的匹配算法、基于关系的匹配算法

基于灰度的匹配算法
-------------------------

  一类是基于灰度和模板的，这类方法直接采用相关运算等方式计算相关值来寻求最佳匹配位置，模板匹配（Blocking Matching）是根据已知模板图像到另一幅图像中寻找与模板图像相似的子图像。基于灰度的匹配算法也称作相关匹配算法，用空间二维滑动模板进行匹配，不同匹配算法主要体现在相关准则的选择方面

* 平均绝对差算法（Mean Absolute Differences，简称MAD算法）

* 绝对误差和算法（Sum of Absolute Differences，简称SAD算法）

* 误差平方和算法（Sum of Squared Differences，简称SSD算法）

* 平均误差平方和算法（Mean Square Differences，简称MSD算法）

* 归一化积相关算法（Normalized Cross Correlation，简称NCC算法）

* 序贯相似性检测算法（Sequential Similiarity Detection Algorithm，简称SSDA算法）

* hadamard变换算法（Sum of Absolute Transformed Difference，简称SATD算法）

* 局部灰度值编码算法

* 划分强度一致法（Partitioned Intensity Uniformity，PIU）


基于特征的匹配算法
--------------------

  首先提取图像的特征，再生成特征描述子，最后根据描述子的相似程度对两幅图像的特征之间进行匹配。图像的特征主要可以分为点、线（边缘）、区域（面）等特征，也可以分为局部特征和全局特征。区域（面）特征提取比较麻烦，耗时，因此主要用点特征和边缘特征

点特征
==========

- Harris      
- Moravec
- KLT
- Harr-like    
- HOG          
- LBP          
- SIFT        
- SURF       
- BRIEF
- SUSAN
- FAST      
- CENSUS
- FREAK
- BRISK
- ORB   
- 光流法 
- A-KAZE


边缘特征
=========

- LoG算子
- Robert算子
- Sobel算子
- Prewitt算子
- Canny算子等


第三类是基于域变换的方法
-----------------------------

- 采用相位相关（傅里叶-梅林变换)
- 沃尔什变换
- 小波等方法
