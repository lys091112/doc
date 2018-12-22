.. _records_language_java_type:
.. highlight:: rst

java Type 体系
^^^^^^^^^^^^^^^

.. toctree::
  :maxdepth: 2
  :glob:

Type 概述
------------

``Type`` 是java中所有类的公共父类，``Type`` 体系中类型的包括：原始类型(``Class``)、参数化类型(``ParameterizedType``)、数组类型(``GenericArrayType``)、类型变量(``TypeVariable``)、基本类型(``Class``)

    - 原始类型: 包含我们平常所指的类，还包括枚举、数组、注解等；
     
    - 参数化类型: 我们平常所用到的泛型List、Map；
     
    - 数组类型: 不是我们工作中所使用的数组String[] 、byte[]，而是带有泛型的数组，即T[] ；
     
    - 基本类型: 我们所说的java的基本类型，即int,float,double等


1. ``ParameterizedType`` 

    参数化类型，即泛型；例如：List<T>、Map<K,V>等带有参数化的对象,常用来提取泛型的参数类型

    包含的方法：

    ::
        - getActualTypeArguments()
              获取泛型中的实际类型(Type)，可能会存在多个泛型
              这个Type可以是ParamteizedType,GenericArrayType,TypeVariable,Class,因此可以基于此获取泛型的类型，以及泛型类型的组成部分
        - getRawType()
              获取声明泛型的类或者接口，也就是泛型中<>前面的那个值
        - getOwnerType() 
              如果该类是个内部类, 通过getOwnerType()方法可以获取到内部类的“拥有者”



2. ``TypeVariable``

    类型变量，即泛型中的变量；例如：T、K、V等变量，可以表示任何类；在这需要强调的是，TypeVariable代表着泛型中的变量，而ParameterizedType则代表整个泛型

    包含的方法：

    ::
        - getBounds()
            获得该类型变量的上限，也就是泛型中extend右边的值,
        - getGenericDeclaration()
            获取声明该类型变量实体,如Map<K,V> 实体变量为Map.
            GenericDeclaration 为声明类型变量的所有实体的公共接口；该接口定义了哪些地方可以定义类型变量，通过查看类继承图，发现 method, construct,class 继承了该类，而field没有，我们使用的field中的泛型来自于class中声明的泛型
        - getName() 
            获取该匿名泛型的名称

3.  ``GenericArrayType``

    数组类型的泛型，泛型数组类型，用来描述ParameterizedType、TypeVariable类型的数组；即List<T>[] 、T[]等

    包含的方法：
    
    ::
        - getGenericComponentType()
            返回泛型数组中元素的Type类型，即List<String>[] 中的 List<String>（ParameterizedTypeImpl）、T[] 中的T（TypeVariableImpl)

4. ``Class``

    Class是Type的一个实现类，属于原始类型，是Java反射的基础，对Java类的抽象；
    在程序运行期间，每一个类都对应一个Class对象，这个对象包含了类的修饰符、方法，属性、构造等信息

5. ``WildcardType``

    泛型表达式（或者通配符表达式），即？ extend Number、？ super Integer这样的表达式.  WildcardType虽然是Type的子接口，但却不是Java类型中的一种

    包含的方法：

    ::
        - getUpperBounds()
            获取泛型的上限，即extend右边的内容

        - getLowerBounds()
            获取泛型的下限，即super右边的内容

        

