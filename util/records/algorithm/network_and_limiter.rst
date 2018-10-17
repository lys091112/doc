.. _algorithm_network_and_limiter:

网络和限流相关
^^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 2
   :glob:


限流限速相关
---------------

1. 二进制指数退避算法

   1. 确定基本退避时间，一般为端到端的往返时间为2t，2t也成为冲突窗口或争用期。
   2. 定义参数k，k与冲突次数有关，规定k不能超过10，k=Min[冲突次数，10]。在冲突次数大于10，小于16时，k不再增大，一直取值为10。
   3. 从离散的整数集合[0,1,2，……，(2k-1)]中随机的取出一个数r，等待的时延为r倍的基本退避时间，等于r x 2t。r的取值范围与冲突次数k有关，r可选的随机取值为2k个、这也是称为二进制退避算法的起因。
   4. 当冲突次数大于10以后，都是从0—210-1个2t中随机选择一个作为等待时间。
   5. 当冲突次数超过16次后，发送失败，丢弃传输的帧，发送错误报告

示例：

.. code-block:: java

    // 10Mbit/s 的数据争用期为51.2us
    // 返回结果为 ns
    public long waitTime(long retryCount) {
        Random random = new Random();
        retryCount = Math.min(retryCount, 10);
        int r = random.nextInt((int) Math.pow(2, retryCount));
        return r * 51200;
    }

