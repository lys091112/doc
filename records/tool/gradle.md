# gradle 使用记录

- 显示项目的jar依赖

    cd \${项目目录}; gradle dependencies ,会在命令台下生成第三方依赖的jar包graph

- 编译指定java版本,示例：

    ./gradlew build -Dorg.gradle.java.home=/Library/Java/JavaVirtualMachines/jdk-13.0.2.jdk/Contents/Home


2). 打包可执行jar

1. 不借助manifest文件
    
    直接在项目下执行gradle jar，然后执行java -classpath jar1:jar2:jar3... mainClassName

2. 使用manifest文件

    在gradle文件中添加：
    ```
        jar {
            manifest {
                attributes 'Main-Class': 'yjmyzz.runnable.jar.DemoApp'
                attributes 'Class-Path': 'my-lib.jar'
            }
        }
    ```
    然后直接运行jar

3. 使用spring-boot插件打包fat-jar

    直接执行 gradle bootRepackage,打包的fatjar会包含所有的依赖，直接运行jar


3). 打包tar zip等二进制包

    使用命令 gradle distTar 或者 gradle distZip 打包
