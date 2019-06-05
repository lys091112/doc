.. _records_algorithm_base_bit-use:

位运算
===========

1. 判断数据的奇偶

.. code-block:: java

    if n & 1 == 1 {
        fmt.println("奇数")
    }


2、交换两个数

.. code-block:: java

    x = x ^ y
    y = x ^ y
    x = x ^ y


3. 找出没有重复的数

    给你一组整型数据，这些数据中，其中有一个数只出现了一次，其他的数都出现了两次，让你来找出一个数 

.. code-block:: java

    int find(int[] arr){
        int tmp = arr[0];
        for(int i = 1;i < arr.length; i++){
            tmp = tmp ^ arr[i];
        }
        return tmp;
    }

4. 3的n次方

.. code-block:: java

    /**
     * 例如3的13次方 3^1101 = 3^0001 * 3^0100 * 3^1000
     */
    int pow(int n){
        int sum = 1;
        int tmp = 3;
        while(n != 0){
            if(n & 1 == 1){
                sum *= tmp;
            }
            tmp *= tmp; //n向右移位后，tmp也相应的变为向右移位后的额值，即^2
            n = n >> 1;
        }

        return sum;
    }

5. 找出不大于N的最大的2的幂指数

.. code-block:: java

    /**
     *  N = 19，那么转换成二进制就是 0001001, 那么最大的值位0001000
     *  具体步骤为：
     *      1、找到最左边的 1，然后把它右边的所有 0 变成 1
     *      2、把得到的数值加 1，可以得到 00100000即 00011111 + 1 = 00100000
     *      3、把得到的 00100000 向右移动一位，即可得到00010000，即 00100000 >> 1 = 00010000
     *
     */
    int findN(int n){
        n |= n >> 1;
        n |= n >> 2;
        n |= n >> 4;
        n |= n >> 8 // 整型一般是 32 位
        return (n + 1) >> 1;
    }

