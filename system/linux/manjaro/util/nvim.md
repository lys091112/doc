# nvim use

## 1. common

```text
-- 可以通过该命令查询插件的健康状态
:checkhealth nvim-treesitter  

-- add tree-sitter-cli
npm install -g tree-sitter-cli

 删除 Telescope
:Lazy clean telescope.nvim

 清除 Telescope 缓存
:lua vim.fn.delete(vim.fn.stdpath("data") .. "/lazy/telescope.nvim", "rf")

安装
:Lazy install telescope.nvim

-- 更新插件
- :Lazy updateg telescope.nvim 

-- 安装额外的插件，如 java-lsp go-lsp 等等,具体参见官方文档
:LazyExtras

```

### 1.1 基本操作

| 快捷键 | 描述 |
| -- | -- |
| `<leader><leader>` | 快速搜索文件 |
| `<leader>ff` | 同上 |
| `<leader>fb` | 搜索buffer |
| `<leader>ft` | 打开terminal |
| ctrl / | 打开 / 隐藏 terminal |
| ctrl ww | 焦点在各窗口之间切换 |
| ctrl w + h/j/k/l | 焦点移动到 ⬅️/⬇️/⬆️/➡️ 侧窗口 |
| shift h | 移动到 ⬅️ 侧 buffer 标签 |
| shift l | 移动到 ➡️ 侧 buffer 标签 |
| shift k | 浮窗显示函数文档 |
| `<leader>qq` | 退出 nvim (quit all) |
| s + 任意字符串 | 快速搜索定位，类似 vimium 的搜索 |
| `<leader>cd` | 在 lsp 警告提示上执行可以看完整信息 |
| `<leader>xx` | 可以在窗口中查看所有 lint 提示信息 |
| `<leader>cs` | 显示函数/类大纲 |
| `<leader>n` | 查看 notify （通知消息） 历史 |
| `<leader>l` | 打开 lazy.vim 窗口 |
| `<leader>cm` | 打开 mason 窗口 |
| `<leader>gg` | 打开 lazygit 窗口 |
| gd | 跳转到定义处 |
| gr | 显示引用 |
| ctrl o / ctrl + i | 跳转回原处 |
| `<leader>/` | 全局关键字搜索 |
| `<leader>sg` | 全局关键字搜索 |
| `<leader>cr` | 变量名重构 |
| zM | 折叠所有函数体 |
| zR | 展开所有函数体 |
| za | 折叠/打开当前函数体 |
| zo | 展开当前函数体 |
| zc | 折叠当前函数体 |
| gc | 多行 注释/取消注释 |
| gcc | 单行 注释/取消注释 |
| :%s/old/new/g | 当前文件替换 |
| `<leader>sr` | 批量查找替换 |
| `<leader>sr \c` | 退出替换窗口 |
| `<leader>sr \r` | 执行 replace |
| `<leader>sr \s` | 执行 sync，效果同replace |

### 1.2 错误之间的高速跳转

```text
在所有诊断（错误、警告、提示等）中跳转：
    ]d : 跳转到下一个诊断
    [d : 跳转到上一个诊断
只在错误（Error）中跳转：
    ]e : 跳转到下一个错误
    [e : 跳转到上一个错误
只在警告（Warning）中跳转：
    ]w : 跳转到下一个警告
    [w : 跳转到上一个警告
打开全局诊断列表：<leader>xx
只打开当前文件的诊断列表：<leader>xX
```

## 2. 插件介绍

### 2.1 markdown preview

- markdown-preview 依赖的nodejs编译失败时，重新编译安装

```sh
  # 进入插件目录
  1. cd ~/.local/share/nvim/lazy/markdown-preview.nvim/app
  # 清除旧的 node_modules 并重新安装
  rm -rf node_modules package-lock.json
  npm install
```

- mermaid 支持的版本较低，如何更新??

``` text
  1. 进入目录： /home/langle/.local/share/nvim/lazy/markdown-preview.nvim/app/_static
  2. cp mermaid.min.js mermaid.min.js-back
  3. curl -L https://cdn.jsdelivr.net/npm/mermaid@11.12.2/dist/mermaid.min.js -o mermaid.min.js
```

> [!CAUTION]
> [https://mermaid.js.org/ecosystem/integrations-community.html]

### 2.2 bufferline.nvim

  nvim自带的``tab``命令包括：tabnew,tabclose、tabnext,tabprevious等，他和缓冲区的tab页不同，切换时也只能切换到tabnew创建的tab页
bufferline.nvim 会将自带tab页下新增缓存页面，这个缓存的tab页面需要通过BufferLineCycleNext/Prev等快捷键来切换，示例如下：

``` vim
-- 缓冲区导航
vim.keymap.set("n", "gt", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "gT", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader>t1", "<cmd>BufferLineGoToBuffer 1<cr>", { desc = "Tab 1" })
vim.keymap.set("n", "<leader>t2", "<cmd>BufferLineGoToBuffer 2<cr>", { desc = "Tab 2" })
```

 在lazynvim中，可以通过 `H` `L` 来左右移动tab页

### 2.3 flash.nvim

  高效代码导航插件，通过搜索标签、增强字符运动和 Treesitter 集成，显著提升代码浏览与编辑效率

- 增强了Vim的f、t、F、T运动：
  - f{char}：跳转到下一个{char}
  - F{char}：跳转到上一个{char}
  - t{char}：跳转到{char}之前
  - T{char}：跳转到{char}之后
  - ;：重复上次f/t/F/T运动
  - ,：反向重复上次f/t/F/T运动
- 按`s` 做普通搜索，匹配的代码位置会显示字母标签，可通过标签快速移动到该位置
- 按 `S` 自动识别代码语法结构，为光标下节点及其所有父节点添加标签，便于快速选择函数、类、语句块等结构化元素
- 多窗口操作： TODO

### 2.4 language for lsp

#### 2.4.1 jdtls for java

1. 基础命令

```
重新编译代码: JdtlsCompile full
重新加载： JdtlsUpdateConfig 
清除缓存并重新加载pom依赖： JdtlsWipeDataAndRestart
```

### 2.5 neo-tree

在neo-tree中，可以通过 shift + h 来显示隐藏文件，再次点击关闭隐藏文件，这是个临时命令。

### 2.6 nvim-surround

通过`<leader>sk` 查看快捷键 gs{a|d|r},了解具体用途

## other

- 插件的脚手架： <https://github.com/ellisonleao/nvim-plugin-template>

**> [!TIP]
>
> - nvim-treesitter-configs not exist , **need change** to nvim-treesitter-config
