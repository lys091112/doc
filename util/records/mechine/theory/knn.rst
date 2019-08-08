
距离的选取

欧几里得距离、余弦值（cos）, 相关度 （correlation）, 曼哈顿距离 （Manhattan distance）


算法步骤：

::

    1）计算测试数据与各个训练数据之间的距离；
    2）按照距离的递增关系进行排序；
    3）选取距离最小的K个点；
    4）确定前K个点所在类别的出现频率；
    5）返回前K个点中出现频率最高的类别作为测试数据的预测分类。


pseudo code:

.. code-block:: python

    def main():
    trainingSet = []
    testSet = []
    #三分之二为训练集，三分之一为测试集
    split = 0.67
    loadDataset(...)
    print("Train set:",repr(len(trainingSet)))
    print("Test set:", repr(len(testSet)))
    predictions = []
    k = 3
    for x in range(len(testSet)):
        neighbors = getNeighbors(trainingSet,testSet[x],k)
        result = getResponse(neighbors)
        predictions.append(result)
        print(">predicted="+repr(result)+", actual="+repr(testSet[x][-1]))

    # 统计预测的准确率
    accuracy = getAccuracy(testSet,predictions)


优缺点：

::

    1. KNN算法是最简单有效的分类算法，简单且容易实现。当训练数据集很大时，需要大量的存储空间，而且需要计算待测样本和训练数据集中所有样本的距离，所以非常耗时

    2. KNN对于随机分布的数据集分类效果较差，对于类内间距小，类间间距大的数据集分类效果好，而且对于边界不规则的数据效果好于线性分类器。

    3. KNN对于样本不均衡的数据效果不好，需要进行改进。改进的方法时对k个近邻数据赋予权重，比如距离测试样本越近，权重越大。

    4. KNN很耗时，时间复杂度为O(n)，一般适用于样本数较少的数据集，当数据量大时，可以将数据以树的形式呈现，能提高速度，常用的有kd-tree和ball-tree。
