我们理解您需要更便捷更高效的工具记录思想，整理笔记、知识，并将其中承载的价值传播给他人，**Cmd Markdown** 是我们给出的答案 —— 我们为记录思想和分享知识提供更专业的工具。 您可以使用 Cmd Markdown：

 * 整理知识，学习笔记
 > * 发布日记，杂文，所见所想
 > * 撰写发布技术文稿（代码支持）
 > * 撰写发布学术论文（LaTeX 公式支持）

 显示图像的话，开头不能空超过四个空格，不然会造成图片不显示
 ![cmd-markdown-logo](https://www.zybuluo.com/static/img/logo.png)

 除了您现在看到的这个 Cmd Markdown 在线版本，您还可以前往以下网址下载：

 ### [Windows/Mac/Linux 全平台客户端](https://www.zybuluo.com/cmd/)

 > 请保留此份 Cmd Markdown 的欢迎稿兼使用说明，如需撰写新稿件，点击顶部工具栏右侧的 <i class="icon-file"></i> **新文稿** 或者使用快捷键 `Ctrl+Alt+N`。

 ------

 ## 什么是 Markdown

 Markdow 是一种方便记忆、书写的纯文本标记语言，用户可以使用这些标记符号以最小的输入代价生成极富表现力的文档：譬如您正在阅读的这份文档。它使用简单的符号标记不同的标题，分割不同的段落，**粗体** 或者 *斜体* 某些文字，更棒的是，它还可以

<font color=red size=6 face=“黑体”>字体颜色</font>

<table><tr><td bgcolor=#7FFFD4>这里的背景色是：Aquamarine，  十六进制颜色值：#7FFFD4， rgb(127, 255, 212)


 ### 1. 制作一份待办事宜 [Todo 列表](https://www.zybuluo.com/mdeditor?url=https://www.zybuluo.com/static/editor/md-help.markdown#13-待办事宜-todo-列表)

 - [ ] 支持以 PDF 格式导出文稿
 - [ ] 改进 Cmd 渲染算法，使用局部渲染技术提高渲染效率
 - [x] 新增 Todo 列表功能
 - [x] 修复 LaTex 公式渲染问题  
 - [x] 新增 LaTex 公式编号功能
 
</td></tr></table>
### 2. 书写一个质能守恒公式[] (有这一行，上面table中的语法才会被支持)

<table><tr><td>
2017-02-07 </td> <td> </td> </tr>
<tr><td>
- [] 告警服务service类优化文档
- [] 告警数据库表添加引
</td><td>
 - [] 调研网关服务器指责，模块以及功能
</td></tr></table>:(如果不紧跟一个字符的话，表格中无法解析markdown语法，这是个bug)

### 3. 高亮一段代码[^code]

```python
//代码段内，行与行之间不能超过两个空格
@requires_authorization
class SomeClass:
    pass
    
if __name__ == '__main__':
    # A comment
    print 'hello world'
```


### 7. 流程图
### 8. 序列图
不支持A

### 12. 表格支持

| 项目        | 价格   |  数量  |
| --------   | -----:  | :----:  |
| 计算机     | \$1600 |   5     |
|  手机        |   \$12   |   12   |
|  管线        |    \$1    |  234  |

$$
a = sqrt{x}+ 3i
$$
$a = x^2+ 3$

### 8. 更详细语法说明

想要查看更详细的语法说明，可以参考我们准备的 [Cmd Markdown 简明语法手册][1]，进阶用户可以参考 [Cmd Markdown 高阶语法手册][2] 了解更多高级功能

[1]: https://www.zybuluo.com/mdeditor?url=https://www.zybuluo.com/static/editor/md-help.markdown
[2]: https://www.zybuluo.com/mdeditor?url=https://www.zybuluo.com/static/editor/md-help.markdown#cmd-markdown-高阶语法手册



