Retrofit使用
^^^^^^^^^^^^^^^^^^^




碰到的问题
==========


1. 在使用注解Path赋值时，如果path的value中包含'/'等url特殊字符，默认会在拼接是被encode， 可以在Path的注解中配置（encoded=true)从而避免该字符被encode
