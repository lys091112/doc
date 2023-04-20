# sping接入

## 1. ResultMap 使用

```java
public interface MenuMapper {
	@Results(id="menuMap",
		value={
			@Result(id=true,property="id",column="id"),
			@Result(property="name",column="name"),
			@Result(property="pid",column="pid"),//menu中的id是他的方法中的pid
			@Result(property="children",many=@Many(select="selByPid"),column="{uid=uid,pid=id}"),
			
		}
	)
	//把传过来的uid的值做常量列的值，并取名为UID
	@Select("select *,#{uid} uid from menu where id in (select mid from users_menu where uid=#{uid}) and pid=#{pid}")
	List<Menu> selByPid(Map<String,Object> map);

    @Select("select *,#{uid} uid from menu")
	@ResultMap(value="menuMap")
     List<Menu> select();	

}

```
``@Results`` 当数据库字段名和实体类所对应的属性名字不一致的时候，通过@Results将他们对应起来。其中column是数据库字段名，property是实体类的属性名

``@ResultMap`` 如果@Results复用率比较高的时候。可以使用 ``@ResultMap`` 来复用这段代码

``@Many`` 需要通过查询到的字段值作为参数(查询出的内容是1对多的)，然后执行另一个方法来查询关联的内容

``@One``  相对@Many来讲，@One的查询结果是1对1的。

