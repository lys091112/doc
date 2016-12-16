# Maven use

1). Maven Release Plugin

     As mention at POM Reference: SCM The connection requires read access for Maven to be able to find the source code (for example, an update), developerConnection requires a connection that will give write access. It is an information for our project where the other, including with another maven plugin to re-use this information further. In this case the Maven Release Plugin.

    The Maven Release Plugin: Prepare a Release also provides us the behind the scenes what it does for us during the release:prepare. There are some significant steps which requires the access to the scm as the following: -
    Transform the SCM information in the POM to include the final destination of the tag
    Tag the code in the SCM with a version name (this will be prompted for)
    Commit the modified POMs
    This means we should provide the scm information when using the maven release plugin. Especially the developerConnection. If we don't provide, the plugin is not able to execute.

2). Maven FindBugs Plugin

    <!-- findbugs 插件，检查代码 -->
        <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>findbugs-maven-plugin</artifactId>
        <version>3.0.4</version>
        <configuration>
        !-- <configLocation>${basedir}/springside-findbugs.xml</configLocation> -->
        <threshold>High</threshold>
        <effort>Default</effort>
        <findbugsXmlOutput>true</findbugsXmlOutput>
        <!-- findbugs xml输出路径-->
        <findbugsXmlOutputDirectory>target/site</findbugsXmlOutputDirectory>
        </configuration>
        </plugin>
        命令：
         mvn findbugs:help       查看findbugs插件的帮助  
         mvn findbugs:check      检查代码是否通过findbugs检查，如果没有通过检查，检查会失败，但检查不会生成结果报表  
         mvn findbugs:findbugs   检查代码是否通过findbugs检查，如果没有通过检查，检查不会失败，会生成结果报表保存在target/findbugsXml.xml文件中  
         mvn findbugs:gui        检查代码并启动gui界面来查看结果  



3). 命令创建maven项目

    mvn archetype:generate -DgroupId=info.sanaulla -DartifactId=MockitoDemo -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
