# Mybatis 

1. #{}和\${}的区别是什么
    - #{}是预编译处理，\${}是字符串替换。
    - Mybatis在处理#{}时，会将sql中的#{}替换为?号，调用PreparedStatement的set方法来赋值；
    - Mybatis在处理${}时，就是把${}替换成变量的值。
    - 使用#{}可以有效的防止SQL注入，提高系统安全性。

2. 当实体类中的属性名和表中的字段名不一样 ，怎么办 
    -  通过在查询的sql语句中定义字段名的别名，让字段名的别名和实体类的属性名一致 .
     select * form orders where order_id=#{id}
    - 通过<resultMap>来映射字段名和实体类属性名的一一对应的关系 <id property=”id” column=”order_id”>

3. 模糊查询like语句该怎么写?
    - 在Java代码中添加sql通配符。
    ```
        string wildcardname = “%smi%”;
        list<name> names = mapper.selectlike(wildcardname);

        <select id=”selectlike”>
         select * from foo where bar like #{value}
        </select>

    ```
    - 在sql语句中拼接通配符，会引起sql注入,  select * from foo where bar like "%"#{value}"%"

4. 通常一个Xml映射文件，都会写一个Dao接口与之对应，请问，这个Dao接口的工作原理是什么？Dao接口里的方法，参数不同时，方法能重载吗？
    - Dao接口，就是人们常说的Mapper接口，接口的全限名，就是映射文件中的namespace的值，接口的方法名，就是映射文件中MappedStatement的id值，接口方法内的参数，就是传递给sql的参数。Mapper接口是没有实现类的，当调用接口方法时，接口全限名+方法名拼接字符串作为key值，可唯一定位一个MappedStatement，
    - Dao接口里的方法，是不能重载的，因为是全限名+方法名的保存和寻找策略。

    - Dao接口的工作原理是JDK动态代理，Mybatis运行时会使用JDK动态代理为Dao接口生成代理proxy对象，代理对象proxy会拦截接口方法，转而执行MappedStatement所代表的sql，然后将sql执行结果返回。

5. Mybatis是如何进行分页的？分页插件的原理是什么？
    - Mybatis使用RowBounds对象进行分页，它是针对ResultSet结果集执行的内存分页，而非物理分页，可以在sql内直接书写带有物理分页的参数来完成物理分页功能，也可以使用分页插件来完成物理分页。

    - 分页插件的基本原理是使用Mybatis提供的插件接口，实现自定义插件，在插件的拦截方法内拦截待执行的sql，然后重写sql，根据dialect方言，添加对应的物理分页语句和物理分页参数。

6. 如何获取自动生成的(主)键值?

    添加配置参数：usegeneratedkeys=”true” keyproperty=”id”

7. 在mapper中如何传递多个参数

    - #{0}代表接收的是dao层中的第一个参数，#{1}代表dao层中第二参数
    ```
    <select id="selectUser"resultMap="BaseResultMap">  
    select *  fromuser_user_t   whereuser_name = #{0} anduser_area=#{1}  
    </select>
    ```
    - 使用 @param 注解
    ```
     public interface usermapper { 
         user selectuser(@param(“username”) string username, 
         @param(“hashedpassword”) string hashedpassword); 
        }

        select id, username, hashedpassword from some_table
         where username = #{username} and hashedpassword = #{hashedpassword}
    ```
8. Mybatis动态sql是做什么的？都有哪些动态sql？能简述一下动态sql的执行原理不？

    - Mybatis动态sql可以让我们在Xml映射文件内，以标签的形式编写动态sql，完成逻辑判断和动态拼接sql的功能。
    - Mybatis提供了9种动态sql标签：trim|where|set|foreach|if|choose|when|otherwise|bind。
    - 其执行原理为，使用OGNL从sql参数对象中计算表达式的值，根据表达式的值动态拼接sql，以此来完成动态sql的功能。

