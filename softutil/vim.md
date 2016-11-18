# vim使用记录

## 基础命令
1. 编辑多行 
> * 按 C-v，进入 Visual Block mode，按 G 到末行，按 $ 到所有行的行尾，按 A 在行尾添加，输入添加的内容（只有第一行会显示），按 <ESC> 退出编辑。完整命令如下： C-V G$A = models.CharField(maxlength=XXX)<ESC>
> *  将行尾 $ 替换为所需内容。命令如下： :%s/$/ = models.CharField(maxlength=XXX)

2. 

