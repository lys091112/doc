# IDE的一些文档

## Idea
### 行宽度设置
```
idea 默认是120
在File->settings->Code Style->General中，修改“Right margin (columns)”的值即可改变代码行宽度的限制,自动换行两种方式
1. 在上述的“Right margin (columns)”的下方，有“Wrap when typing reaches right margin”选项，选中它，是什么效果呢？如下图所示，随着输入的字符的增加，当代码宽度到达界线时，IDEA会自动将代码换行
2. 在File->settings->Code Style->Java中，选中“Wrapping and Braces”选项卡，在“Keep when reformatting”中有一个“Ensure rigth margin is not exceeded”，选中它,确保在格式化时，不会超出限制
```



### plugins 

    1. idea-vim 配置文件为：~/.ideavimrc  然后就可以配置基本的vim命令


### 快捷键

```
1. Alt+F7               #作用在类上，查看某个类被调用的情况，Find Usages
2. Ctrl+Shift+Alt+T     #重构菜单，万能的快捷键
3. Alt+Insert           #自动生成构造方法或者setter/getter
```
