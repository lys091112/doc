# mybatis-plus的基础使用


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

## 1. 基础功能

// TODO  lambdquery() 的实现原理:https://blog.csdn.net/li281037846/article/details/116401948)

## 2. SQL拼接语句

### 2.1 A or B

```java
 
 // select * from student where name = ? or age = ?
 new QueryWrapper<Student>().eq("name",1).or().eq("age",1)

```

### 2.2 A or (C and D)

```java
 
 // select * from student where name = ? or (name =? and age = ?)
 new QueryWrapper<Student>().eq("name",1).or(w -> w.eq("name",1).eq("age",1))

// lambda 表达方式
//  studentService.lambdaQuery().eq(Student::getName, "1").or().eq(Student::getAge, 12).list();


```

### 2.3 (A and B) or (C and D)

```java
 
 // select * from student where (name = ? and age = ?) or (name = ? and age = ?)
 new QueryWrapper<Student>().and(w -> w.eq("name",1).eq("age",1)).or(w -> w.eq("name",1).eq("age",1))
```

### 2.4 A or (B and (C or D))

```java
 
 // select * from student where name = ? or (name = ? and (age is NULL or age >= ?)
 new QueryWrapper<Student>().eq("name",1).or(w -> w.eq("name",1).and(w -> w.isNull("age").or().eq("age",1)))
```
