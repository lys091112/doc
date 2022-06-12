# TypeScript 入门

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [TypeScript 入门](#typescript-入门)
  - [1. 编译参数](#1-编译参数)
  - [2. 项目依赖](#2-项目依赖)
    - [2.1 为什么有些包以 ``@`` 开头](#21-为什么有些包以-开头)

<!-- /code_chunk_output -->


## 1. 编译参数

```
tsc --h  // 用来查询所有的编译参数

tsc --target 'es6' // 通过target来制定编译的配置项

```

## 2. 项目依赖

### 2.1 为什么有些包以 ``@`` 开头

在包名称中使用时,作用域前面带有@符号,后跟斜杠
范围是一种将相关包分组在一起的方法,您可以在该范围内拥有自己的包名称空间.
例如,你的package.json包含一些带@angular/前缀的依赖项(@ angular/animations,@ angular/compiler-cli等),这意味着它们在angular范围之内.所有这些依赖项的代码都在@angular目录下