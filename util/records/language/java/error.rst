.. _records_language_java_error:

java 注意事项
^^^^^^^^^^^^^^^


1. 基本类型的包装类

    如果一个类定义了Integer对象，但又没有进行初始化，那么当与常数相加时，NullPointException

.. code-block:: java

    public void test() {
        Integer key;
        System.out.println(key + 1); // NullPorintException
    }

2. map 中的key 为 Integer ，用相同值的Long类型获取为空


   原因在于，虽然两者定位到相同的槽内，但是在equals时由于两者的类型不一致，造成比对结果为false

.. code-block:: java

    public void test() {
        Map<Integer, String> map = new HashMap<Integer, String>();
        map.put(18872, "xxxx");

        Long key = 18872L;

        assert map.get(key) == null
    }

3. 从map中获取不存在的key报空异常

   原因在于方法的返回值为bool（非Boolean），但是return的是个null

.. code-block:: java

    public boolean test() {
        Map<Integer,Boolean> map = new HashMap<Integer,Boolean>();
        return map.get(1);
    }
