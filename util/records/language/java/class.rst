.. _records_language_java_class:

类基本方法
---------------


Java 类型信息 
==============

1. instanceof运算符 
   只被用于对象引用变量，检查左边的被测试对象 是不是 右边类或接口的 实例化。如果被测对象是null值，则测试结果总是false。

.. code-block:: java

    //自身实例或子类实例 instanceof 自身类   返回true
    public void test (){
        String s=new String("javaisland");
        System.out.println(s instanceof String);
    }
 
2. isInstance(Object obj)
   obj是被测试的对象，如果obj是调用这个方法的class或接口 的实例，则返回true。这个方法是instanceof运算符的动态等价。

.. code-block:: java

    //自身类.class.isInstance(自身实例或子类实例)  返回true
    public void test() {
        String s=new String("javaisland");
        System.out.println(String.class.isInstance(s)); //true
    }
 
3. isAssignableFrom(Class cls)
   如果调用这个方法的class或接口 与 参数cls表示的类或接口相同，或者是参数cls表示的类或接口的父类，则返回true。

.. code-block:: java

    // 自身类.class.isAssignableFrom(自身类或子类.class)  返回true
    public void test() {
        System.out.println(ArrayList.class.isAssignableFrom(Object.class));  //false
        System.out.println(Object.class.isAssignableFrom(ArrayList.class));  //true
    }
