.. highlight:: rst

.. _language_java_third_project_spring_database:


@Transaction的使用
========================

事务失效的六种情况
::::::::::::::::::::

1. 同一个类中,一个 ``未标注`` @Transactional的方法去调用标有@Transactional的方法,事务会失效

2. 该注解只能应用到public可见度的方法上。如果应用在protected、private或者package可见度的方法上，也不会报错，但是事务设置不会起作用。

3. 数据库引擎本身不支持事务，比如说MySQL数据库中的myisam，事务是不起作用的。

4. Spring只会对unchecked异常进行事务回滚；如果是checked异常则不回滚。可通过 ``@Transactional(rollbackOn = Exception.class)`` 来针对所有的异常

5. @Transactional 注解属性 propagation 设置错误

6. 异常被catch导致@Transactional失效，serviceA 调用serviceB，而serviceB产生的异常被catch，serviceA 为抛出异常，认为这是一次成功的处理，从而导致serviceA和serviceB的事务状态不一致，从而抛出 ``UnexpectedRollbackException`` 异常


propagation属性:
::::::::::::::::::::

- Propagation.REQUIRED：如果当前存在事务，则加入该事务，如果当前不存在事务，则创建一个新的事务。( 也就是说如果A方法和B方法都添加了注解，在默认传播模式下，A方法内部调用B方法，会把两个方法的事务合并为一个事务 ）

- Propagation.SUPPORTS：如果当前存在事务，则加入该事务；如果当前不存在事务，则以非事务的方式继续运行。

- Propagation.MANDATORY：如果当前存在事务，则加入该事务；如果当前不存在事务，则抛出异常。

- Propagation.REQUIRES_NEW：重新创建一个新的事务，如果当前存在事务，暂停当前的事务。( 当类A中的 a 方法用默认Propagation.REQUIRED模式，类B中的 b方法加上采用 Propagation.REQUIRES_NEW模式，然后在 a 方法中调用 b方法操作数据库，然而 a方法抛出异常后，b方法并没有进行回滚，因为Propagation.REQUIRES_NEW会暂停 a方法的事务 )

- Propagation.NOT_SUPPORTED：以非事务的方式运行，如果当前存在事务，暂停当前的事务。

- Propagation.NEVER：以非事务的方式运行，如果当前存在事务，则抛出异常。

- Propagation.NESTED ：和 Propagation.REQUIRED 效果一样。

异常处理
::::::::::::

    我们把派生于Error或者RuntimeException的异常称为unchecked异常，所有其他的异常成为checked异常，Use checked exceptions for recoverable conditions and runtime exceptions for programming errors
    RuntimeException，常是程序员自身的问题。比如说，数组下标越界和访问空指针异常等等，只要你稍加留心这些异常都是在编码阶段可以避免的异常。


异常继承图谱： |pic| 

.. |pic| image:: ../../pictures/java-exception

