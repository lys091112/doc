# java日志处理记录


### 1. Log4j
1. 通过设置系统变量来指定log4j的默认加载位置: ``-Dlog4j.configurationFile=path/to/log4j2.xml``


### 2. 屏蔽掉不需要的log日志依赖

通过添加scope=provided，来屏蔽掉服务对  commons-logging 的依赖
```xml
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>commons-logging</groupId>
                <artifactId>commons-logging</artifactId>
                <version>1.1.1</version>
                <scope>provided</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

```