# 面向对象开发的一些思想， 概念


### VO, PO, DO, DTO

VO(View Object): 视图对象，用于展示层
DTO(Data Transfer Object): 数据传输对象，范指展示层和服务层之间的数据传输对象
DO（Domain Object): 领域对象，从现实中抽象出来的有型或无形的业务实体, 有时候不需要持久化，同样可以不对外暴露实现细节来操作该对象
PO(Persistent Object): 持久化对象，如：Entity,只包含get/set方法的POJO

```
VO和DTO在一些情况下，也不做区分，但如果VO需要在DTO的基础上，再次对数据的展示进行封装，那么就需要区分这两层。
在现实开发中一般不区分DO和PO。
```
