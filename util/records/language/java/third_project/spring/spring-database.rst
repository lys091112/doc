.. highlight:: rst

.. _language_java_third_project_spring_database:


@Transaction的使用
========================

1. 同一个类中,一个 ``未标注`` @Transactional的方法去调用标有@Transactional的方法,事务会失效

2. 该注解只能应用到public可见度的方法上。如果应用在protected、private或者package可见度的方法上，也不会报错，但是事务设置不会起作用。

3. 数据库引擎本身不支持事务，比如说MySQL数据库中的myisam，事务是不起作用的。

4. Spring只会对unchecked异常进行事务回滚；如果是checked异常则不回滚。可通过 ``@Transactional(rollbackOn = Exception.class)`` 来针对所有的异常

::

    我们把派生于Error或者RuntimeException的异常称为unchecked异常，所有其他的异常成为checked异常，Use checked exceptions for recoverable conditions and runtime exceptions for programming errors
    RuntimeException，常是程序员自身的问题。比如说，数组下标越界和访问空指针异常等等，只要你稍加留心这些异常都是在编码阶段可以避免的异常。



