记录一些工具
^^^^^^^^^^^^^^^^


1. 反编译工具   
   http://www.benf.org/other/cfr/



appendtosystemclassloadersearch(jarfile jarfile)
指定 jar 文件，检测类由系统类加载器定义。 当代理的系统类加载器（参见 getsystemclassloader()）未能成功搜索到类时，jarfile 中的条目也将被搜索。
可以多次使用此方法，按照调用此方法的顺序添加多个要搜索的 jar 文件。
