# springboot 基础使用


## 配置文件相关

### springboot启动时的application.yml加载优先级

SpringApplication will load properties from application.properties files in the following locations and add them to the Spring Environment(优先级从高到低):

1. A ``/config`` subdirectory of the current directory.
2. The current directory
3. A classpath ``/config`` package
4. The classpath root

```
当有多个application文件时spirngboot在启动时会加载多个文件，会优先加载当前运行下的properties文件，
然后在加载classpath下的配置文件。

例如目录结构如下：

 \ main
    Application.java
 \ resource
    \ application.yml
 \ test
 \ resources
   \ applciatoin.yml

在通过SpringBootTest运行测试时，会优先加载main-resouce-application.yml然后再加载test-resource-application.yml ,
如果两个配置文件中有相同的配置项，那么main会覆盖掉test下的配置。

打包时，如果时thinjar，那么尽可能让配置文件存在于包外，方便修改，
如果时fatjar，则可以根据实际情况考虑
```
