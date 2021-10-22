.. highlight:: rst

# 性能优化建议

1. == and equals 方法的区别

::

    1、==是判断两个变量或实例是不是指向同一个内存空间。 equals是判断两个变量或实例所指向的内存空间的值是不是相同。

    2、==是指对内存地址进行比较。 equals()是对字符串的内容进行比较。

    3、==指引用是否相同。 equals()指的是值是否相同


2. ConcurrentHashMap能完全替代HashTable吗？

::

    HashTable虽然性能上不如ConcurrentHashMap，但并不能完全被取代，两者的迭代器的一致性不同的，
    HashTable的迭代器是强一致性的，而ConcurrentHashMap是弱一致的。
    ConcurrentHashMap的get，clear，iterator 都是弱一致性的。 Doug Lea 也将这个判断留给用户自己决定是否使用ConcurrentHashMap。

    弱一致性： put操作将一个元素加入到底层数据结构后，get可能在某段时间内还看不到这个元素，若不考虑内存模型，单从代码逻辑上来看，却是应该可以看得到的


3. try里有return，难么finally还会执行吗

::

    肯定会执行。finally{}块的代码。 只有在try{}块中包含遇到System.exit(0)。 之类的导致Java虚拟机直接退出的语句才会不执行
    finally 中的reture会不会影响try中的return？？？

5. 单独运行一个class文件

::

    需要加上 -cp . 表示以当前路径作为classpath路径
    java -cp . packagex.MainClass


6java运行过程中如何加载配置文件

::
    1. 通过在执行过程中添加系统变量，如-Dconfig-dir=/home/xianyue/... 然后在程序中使用System.getProperties("")来获取配置文件位置

    2. 在通过java -cp执行过程中，配置加载的第一个文件目录即为默认的运行目录，可以通过this.class.getClassLoader().getResource("").getPath()获取
       如，java -java:hello.jar:./conf:.conf1 那么获取的路径为.../conf

7. 尽量指定类、方法的final修饰符

::

   带有final修饰符的类是不可派生的。为方法指定final修饰符可以让方法不可以被重写。如果指定了一个类为final，则该类所有的方法都是final的。
   Java编译器会寻找机会内联所有的final方法，内联对于提升Java运行效率作用重大

8. 一些基本建议

::

    尽量重用对象
    尽量使用局部变量，这样尽可能分配到栈上，随方法结束而回收，不分配到堆上给GC造成压力
    不要在循环中使用try…catch…，应该把其放在最外层
    如果能估计到待添加的内容长度，为底层以数组方式实现的集合、工具类指定初始长度

    当复制大量数据时，使用System.arraycopy()命令, 使用底层优化，不再是一个个的复制，而是批量复制一段数据
    乘法和除法使用移位操作

    循环内不要不断创建对象引用, 在循环外声明变量，减少引用数的创建

    基于效率和类型检查的考虑，应该尽可能使用array，无法确定数组大小时才使用ArrayList

    尽量使用HashMap、ArrayList、StringBuilder，除非线程安全需要，否则不推荐使用Hashtable、Vector、StringBuffer，后三者由于使用同步机制而导致了性能开销

    , 当某个对象被定义为static的变量所引用，那么gc通常是不会回收这个对象所占有的堆内存的

9. 尽量减少对变量的重复计算

::

    // 每次循环都会重新调用list.size()
    for (int i = 0; i < list.size(); i++)
    {...}
    

    建议替换为：

    for (int i = 0, int length = list.size(); i < length; i++)
    {...}

10. 不要将数组声明为public static final

::

    这毫无意义，这样只是定义了引用为static final，数组的内容还是可以随意改变的，将数组声明为public更是一个安全漏洞，这意味着这个数组可以被外部类所改变


11. 避免随意使用静态变量

::

    当某个对象被定义为static的变量所引用，那么gc通常是不会回收这个对象所占有的堆内存的
    public class A
    { 
    private static B b = new B();
    }
    此时静态变量b的生命周期与A类相同，如果A类不被卸载，那么引用B指向的B对象会常驻内

12. 实现RandomAccess接口的集合比如ArrayList，应当使用最普通的for循环而不是foreach循环来遍历

::

    这是JDK推荐给用户的。JDK API对于RandomAccess接口的解释是：实现RandomAccess接口用来表明其支持快速随机访问，此接口的主要目的是允许一般的算法更改其行为，从而将其应用到随机或连续访问列表时能提供良好的性能。实际经验表明，实现RandomAccess接口的类实例，假如是随机访问的，使用普通for循环效率将高于使用foreach循环；反过来，如果是顺序访问的，则使用Iterator会效率更高
    foreach循环的底层实现原理就是迭代器Iterator，参见Java语法糖1：可变长度参数以及foreach循环原理。所以后半句”反过来，如果是顺序访问的，则使用Iterator会效率更高”的意思就是顺序访问的那些类实例，使用foreach循环去遍历


13. 程序运行过程中避免使用反射

::

    反射是Java提供给用户一个很强大的功能，功能强大往往意味着效率不高
    一种建议性的做法是将那些需要通过反射加载的类在项目启动的时候通过反射实例化出一个对象并放入内存

14. 把一个基本数据类型转为字符串，基本数据类型.toString()是最快的方式、String.valueOf(数据)次之、数据+””最慢

::
    String.valueOf()方法底层调用了Integer.toString()方法，但是会在调用前做空判断

    2、Integer.toString()方法就不说了，直接调用了

    3、i + “”底层使用了StringBuilder实现，先用append方法拼接，再用toString()方法获取字符串


15. 
