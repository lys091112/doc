# Vscode 使用记录


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Vscode 使用记录](#vscode-使用记录)
  - [1. 常规使用](#1-常规使用)
    - [1.1 快捷使用](#11-快捷使用)
    - [1.2 使用code命令打开VSCode](#12-使用code命令打开vscode)
    - [1.3 使用``C++``记录](#13-使用c记录)
  - [2. 插件](#2-插件)

<!-- /code_chunk_output -->


## 1. 常规使用

### 1.1 快捷使用

-  "⇧⌘X" ==> 打开插件扩展窗口，用于安装插件
-  "⌘ +K  V" ==> 打开markdown预览
-  command + shift + p 万能健
        1. 搜索generate  用于显示一些生成代码类的快捷命令
-  通过快捷键打开左侧文件目录树，结合vim插件的“O” 快捷键，快速打开文件,命令设置如下
    ```json
    {
    "key": "shift+cmd+e",
    "command": "workbench.view.explorer",
    "when": "viewContainer.workbench.view.explorer.enabled"
    } 
    ```

-  ctrl + 0 将鼠标焦点移动到左侧文件目录树
-  ctrl + 1 将鼠标焦点移动到右侧编辑框内
-  ctrl + b 打开侧边栏
-  ctrl + shift + p  可以打开命令面板，输入命令，然后回车
-  ctrl + shift + f 可以全局搜索
-  ctrl + shift + p  输入 "open recent" 可以打开最近打开的文件
-  ctrl + shift + p  输入 "open file" 可以打开文件
-  ctrl + shift + p  输入 "open folder" 可以打开文件夹


### 1.2 使用code命令打开VSCode

安装：打开``VSCode –> command+shift+p`` –> 输入shell command –> 点击提示Shell Command: Install ‘code’ command in PATH运行
使用：打开终端，cd到要用VSCode打开的文件夹，然后输入命令 ``code .`` 即可打开

### 1.3 使用``C++``记录

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

    c4module: C4-module: https://www.infoq.cn/article/C4-architecture-model

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
9. Bracket Pair Colorizer v2 括号的高亮和划分 （已被vscode内置)
10. Better Align  自动对其工具
11. Markdown All in One  markdown的集成
12. draw.io integration  用于在vscode中直接编辑draw.io文件
13. graphviz(dot) language support 、 plantUML 、 plantUML Previewer
14. jupyter
15. makefile tools
16. VIM 
17. VScode 目录文件夹图片主题
    file -》 首选项 -》 文件夹主题 -》 安装 Material Icon Theme

18. prettier 代码格式化 (也可用于将压缩后的js文件进行还原，便于调试)
19. Minify 代码压缩，将js/css/html文件压缩后生成新文件，便于传输

--- 画图相关插件---
12. draw.io integration  用于在vscode中直接编辑draw.io文件
13. graphviz(dot) language support 、 plantUML 、 plantUML Previewer
20. excalidraw  用于在vscode中直接编辑excalidraw文件
  ```
    1. 在vscode中，搜索excalidraw  安装插件
    2. Ctrl+Shift+P，输入 “Excalidraw: New” 并回车，即可快速创建一个新的绘图文件。
    3. 打开``https://libraries.excalidraw.com/`` 在其中寻找需要的库，下载到本地的固定目录下，例如：``~/.vscode/extensions/excalidraw.excalidraw-0.1.0/libraries/``  也可以直接clone https://github.com/excalidraw/excalidraw-libraries.git ， 然后将其放到固定目录下

    4. 打开库面板：在 Excalidraw 绘图界面，点击左侧工具栏的 “库”图标（看起来像一本书）。 浏览并加载库： 在弹出的库面板中，点击右下角的 “...” 菜单。 选择 “加载”。
   ```
21. mermaid  用于在vscode中直接编辑mermaid文件
