## python 工具使用


1. 在vscode中配置虚拟环境

    1) 使用命令Python：Select Interpreter，并在其中选择自己的虚拟环境
    2）在项目文件.vscode/setting.json 中配置自己的python环境路径

TIP:
```
在setting中配置上该句，忽略文件错误
"python.linting.pylintArgs": [ "--errors-only", "--generated-members=numpy.* ,torch.* ,cv2.* , cv.*" ]

```
