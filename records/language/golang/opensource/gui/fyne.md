# fyne 图形化编程


## 资源打包

### 1. 中文字体支持

1. 将中文字体打包近bundle.go
``
fyne bundle --package theme Songti.ttc > bundle.go
``
2. 在main启动时，通过Settings.SetTheme 设置进启动程序中

### 1. macOs 打包
``
fyne package -os darwin -name choice --icon d1.png
``
