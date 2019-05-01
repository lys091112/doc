.. _records_language_java_error:
.. highlight:: rst

java 注意事项
^^^^^^^^^^^^^^^


1. 基本类型的包装类

    如果一个类定义了Integer对象，但又没有进行初始化，那么当与常数相加时，NullPointException

.. code-block:: java

    public void test() {
        Integer key;
        System.out.println(key + 1); // NullPorintException
    }
