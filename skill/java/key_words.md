# java 关键字的使用和记录

1. Transient

``` java
/**
  *Java的serialization提供了一种持久化对象实例的机制。当持久化对象时，可能有一个特殊的对象数据成员，我们不想   
  *用serialization机制来保存它。为了在一个特定对象的一个域上关闭serialization，可以在这个域前加上关键字transient。   
  *transient是Java语言的关键字，用来表示一个域不是该对象串行化的一部分。当一个对象被串行化的时候，
  *transient型变量的值不包括在串行化的表示中，然而非transient型的变量是被包括进去的
  *
  * 如果is前不添加transient，那么在序列化时会报异常：
  * java.io.NotSerializableException，原因是InputStream没有实现Serializable接口。
  * 
  * 有了关键字后，在反序列化时也不会赋予任何值，为null
 */

 public class ClassLib implements Serializable {
    private transient InputStream is;

    private long max;
    private long min;
 }

```
