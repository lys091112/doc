## 记录Vim 使用技巧

1. 对文件中的匹配行按照字母序排序 ``sort``
```
:'<,'>sort 对于选中的文字进行字母排序
:g/{/ .+1,/}/-1 sort # :g/{start}/ .,{finish} [cmd] 对文本中的{}中的内容进行字母排序
```

2. 收集TODO 内容
```
:g/TODO 显示在命令台
:g/TODO/yank A 将TODO所在行内容添加到a寄存器中，A表示追加，a表示覆盖
:g/TODO/t$ 将内容附加到文本末尾
```

3. 文本中的tab于空格的互换
```
对于已保存的文件，可以使用下面的方法进行空格和TAB的替换：
TAB替换为4个空格：
:set ts=4
:set expandtab
:%retab!

4个空格替换为TAB：
:set ts=4
:set noexpandtab
:%retab!
```

4. 删除文本的空白行

```
:g/^\s*$/d

:g 代表在全文档范围内
^代表行的开始
\s*代表空白字符
&代表行的结束
d代表删除

```

5. 统计单词次数
```
  :%s/string/&/gn
```
