# Vscode 使用记录

## 1. 快捷使用

    "⇧⌘X" ==> 打开插件扩展窗口，用于安装插件
    "⌘ +K  v" ==> 打开markdown预览
    command + shift + p 万能健
        1. 搜索generate  用于显示一些生成代码类的快捷命令


### 使用code命令打开VSCode

安装：打开VSCode –> command+shift+p –> 输入shell command –> 点击提示Shell Command: Install ‘code’ command in PATH运行
使用：打开终端，cd到要用VSCode打开的文件夹，然后输入命令code .即可打开

### 使用C++ 记录

1. 首先需要通过 brew install gcc@8 安装gcc
2. 安装vcpkg,然后可以通过vcpkg安装需要的依赖包
        ./vcpkg search xx 可以通过search搜索依赖包

## 2. 插件

1、 Markdown Preview Enhancer   [使用文档](https://shd101wyy.github.io/markdown-preview-enhanced/#/zh-cn/diagrams)

  * 修改配色 通过命令：Markdown Preview Enhanced: Open Mermaid Config ，然后修改配置文件如下：
 
     //设置mermaid绘图的风格 共有三个主题：
    // mermaid.css mermaid.dark.css  mermaid.forest.css
    MERMAID_CONFIG = {
        startOnLoad: true,
        theme: mermaid.forest.css
    }

  * 修改markdown 预览背景颜色： Markdown Preview Enhanced: Customize Css
      .markdown-preview.markdown-preview {
      // background-color: white;
      background-color: rgb(29, 39, 39);
      }
      参考链接：https://shd101wyy.github.io/markdown-preview-enhanced/#/customize-css

  * brew install graphviz   // mac 用来支持platuml图形库 以及dot语法的图形库
  * yay -S graphviz // manjaro

2. golang 

```
    1. 搜索 setting.json 在其中添加 "go.testFlags": ["-v"] 可以打印golang test日志
    2. setting.json  中添加 "editor.defaultFormatter": "ms-vscode.Go"
    3. 'Ctrl+Shift+O' 可以显示出当前文件声明的方法，类似于tags

```
    3.1) vscode golang 自动提示失效，可以更新gocode
        go get -u -v github.com/mdempsky/gocode // 需要链接代理

3. codelf 参数命名工具
4. local history 历史文件记录
5. partial diff  文本比对
6. TODO tree  待做列表
7. vscode-icons  图标
8. Better Comments 注释的高亮定制
9. Bracket Pair Colorizer v2 括号的高亮和划分
10. Better Align  自动对其工具
11. Markdown All in One  markdown的集成
12. VScode 目录文件夹图片主题
    file -》 首选项 -》 文件夹主题 -》 安装 Material Icon Theme
