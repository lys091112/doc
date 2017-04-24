# vim使用记录

## 基础命令
1). 编辑行 
```    
* 添加一行
    1.按 C-v，进入 Visual Block mode，按 G 到末行，按 $ 到所有行的行尾，按 A 在行尾添加,
    输入添加的内容（只有第一行会显示）， 按 <ESC> 退出编辑。
    完整命令如下： C-V G$A = models.CharField(maxlength=XXX)<ESC>

    2.将行尾 $ 替换为所需内容。命令如下： :%s/$/ = models.CharField(maxlength=XXX)
* 删除一行
        C-v,移动光标，选择需要删除的区域，按d进行删除
    
    3. 一次插入多个相同的字符。 
        命令: 10i* //表示在该位置上插入10个*
              10o### //表示在该行下方插入10行### 
        其他组合命令可以自己去定义
    4. Unicode字符插入
       方式一：CTRL+v+{unicode码} <C-v>065 十进制代表A  <C-v>U9690 隐, 详情可以查看:h i_CTRL-v_digit  ga命令可以显示字符的进制码 
       方式二：使用而合字母，CTRL+K+{code1}{code2} 详情:h digraph 

```

2). vim 宏录制
    
    1.把光标定位在第一行；
    2.在normal模式下输入qa(当然也可以输入qb, qc, etc，这里的a, b, c是指寄存器名称，vim会把录制好的宏放在这个寄存器中)；
    3.正常情况下，vim的命令行会显示“开始录制”的字样，这时候，把光标定位到第一个字符（按0或者|），再按x删除，按j跳到下一行；
    4.normal模式下输入q，结束宏录制。
    
    执行：移动到需要操作的行，在normal模式下数据@a， 7@a执行7行

3). 移动

    * 单词移动：
        W w 移动到下个单词开头 
        E e 移动到下一个单词的结尾 
        B b 上一个单词开头
    * 行移动
        + 移动到下一行开头 
        - 移动到下一行几位
    * 滚屏
        <C-f> 向下滚动一屏
        <C-b> 向上滚动一屏
        <C-d> 向下滚动一屏
        <C-u> 向上滚动一屏
        <C-y>向下滚动一行
        <C-e> 向下滚动一行
    * 屏幕中移动
        H 屏幕顶端(high)
        M 屏幕中央(middle)
        L 屏幕底端(low)
    * 文本块移动
         (  移动到当前句子开头
         )  移动到下一句子开头
         {  移动到当前段开头
         }  移动到下一段开头
         [[ 移动到这一节开头
         ]] 移动到下一节开头
    * 其他
        ^ 移动到当前行的第一个非空格处
        <C-g> 显示当前行信息


4). 其他基本命令

    * 删除
        d0 删除光标到本行开头等同于d0+i
        d$ 删除光标到本行结尾
    * 字符替换
        R  连续替换单词
        ~  更改大小写
        cw cb 从光标处修改单词开头或末尾
        c$ 修改到本行末尾
        C  同上
        cc 删除本行，从头修改
        S  功能同上
        s  删除光标所在字符，然后插入
    * 恢复
        u  撤销上次命令
        U  恢复整行
        .  重复执行
        e! 全文恢复
        <C-r> 重做,（用于执行u后的还原）

5). Ex命令

```
    * Ex基本命令
        :[range]delete [x]               #删除指定范围内的行[到寄存器 x 中]
        :[range]yank [x]                 #复制指定范围的行[到寄存器 x 中]
        :[line]put [x]                   #在指定行后粘贴寄存器 x 中的内容
        :[range]copy {address}           #把指定范围内的行拷贝到 {address} 所指定的行之下
        :[range]move {address}           #把指定范围内的行移动到 {address} 所指定的行之下
        :[range]join                     #连接指定范围内的行
        :[range]normal {commands}        #对指定范围内的每一行执行普通模式命令 {commands}
        :[range]substitute/{pattern}/{string}/[flags] #把指定范围内出现{pattern}的地方替换为{string}
        :[range]global/{pattern}/[cmd]   #对指定范围内匹配{pattern}的所有行,在其上执行 Ex 命令{cmd}

    * 自动补全Ex  
        :col<C-d> 会显示《 color colorscheme
        补全的方式有
            * set wildmode=longes,list     #类似与shell的方式
            * set wildmode                 #类似与zsh的方式
              set wildmode=full
    * 历史 set history=200
    * 运行shell 
            * :shell 启动一个 shell (输入 exit 返回 Vim)
            * :!{cmd} 在 shell 中执行 {cmd}
            * :read !{cmd} 在 shell 中执行 {cmd} ,并把其标准输出插入到光标下方
            * :[range]write !{cmd} 在 shell 中执行 {cmd} ,以 [range] 作为其标准输入
            * :[range]!{filter} 使用外部程序 {filter} 过滤指定的 [range]
                demo:
                    * :read !{cmd}                #将当前命令输出读入到缓冲区
                    * :write !sh                  #将缓冲区的内容输出给外部的sh命令做标准输入
                    * :write ! sh                 #同上
                    * :write! sh                  #将缓冲区的内容输出到sh文件
```

5). 其他
    
    * 文本行尾
        ^M 是由于在linux下打开了用window系统编辑的文本文件，在window下的换行符是\r\n,在linux下的换行符是\n
    * 编辑后使用sudo命令保存
        :w !sudo tee %


6). 插件的使用

    * Nerdtree快捷键
         h j k l移动光标定位
         ctrl+w+w 光标在左右窗口切换
         ctrl+w+r 切换当前窗口左右布局
         ctrl+p 模糊搜索文件
         gT 切换到前一个tab
         g t 切换到后一个tab
         
         o 打开关闭文件或者目录，如果是文件的话，光标出现在打开的文件中
         O 打开结点下的所有目录
         X 合拢当前结点的所有目录
         x 合拢当前结点的父目录

         i和s水平分割或纵向分割窗口打开文件
         u 打开上层目录
         t 在标签页中打开
         T 在后台标签页中打开

         p 到上层目录
         P 到根目录
         K 到同目录第一个节点
         J 到同目录最后一个节点
         m 显示文件系统菜单（添加、删除、移动操作）
         ? 帮助
         :q 关闭

    * minibufexpl快捷键
         :e <filename>  打开文件
         :ls            当前打开的buf
         :bn            下一个buf
         :bp            前一个buf
         :b<n>          n是数字，第n个buf
         :b<tab>        自动补齐
         :bd            删除buf




