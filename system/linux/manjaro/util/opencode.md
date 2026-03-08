# opencode 安装和使用

## 1. 基础应用

### 1.1 安装

```sh
    curl -fsSL https://opencode.ai/install | bash

    # 更新opencode版本
    opencode upgrade 

```

### 1.2 命令

- /connect 会弹出支持的模型，可以选择自己的模型，然后输入appkey,回车即可

### 1.3 配置

1. OpenCode 的配置文件位于：

    配置文件：~/.config/opencode/opencode.json

    数据目录：~/.local/share/opencode/

### 1.4. 插件

#### 1.4.1 oh-my-opencode

```text
1. 在框内输入后按照提示自动安装：
    按照以下说明安装和配置 oh-my-opencode：
    https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/refs/heads/master/docs/guide/installation.md

2. 安装后的配置文件位置：
    ~/.config/opencode/oh-my-opencode.json
    ~/.config/opencode/opencode.json


# Run oh-my-opencode doctor to verify setupsnippets
$ bunx oh-my-opencode doctor

Sisyphus (主协调器): google/antigravity-claude-opus-4-5-thinking-high
    负责整体任务规划和编排
Oracle (架构师): google/antigravity-claude-opus-4-5-thinking-high
    架构设计、代码审查、策略分析
Librarian (研究员): google/antigravity-claude-sonnet-4-5
    多仓库分析、文档查找、实现示例研究
Explore (探索者): google/gemini-3-flash
    快速代码库探索和模式匹配
Frontend UI/UX Engineer: google/gemini-3-pro-high
    构建精美前端界面
Document Writer: google/gemini-3-flash
    撰写技术文档
Multimodal Looker: google/gemini-3-flash
    分析 PDF、图像和图表
基础设施: Prometheus
Metis: 策略智慧,生成策略优化、性能调优、资源配置
Momus:  代码审查、安全审计、性能分析
可视化: Atlas

```

避免覆盖opencode自带的plan和build模式

```json
{
  "sisyphus_agents": {
    "default_builder_enabled": true,
    "replace_plan": false
  }
}
```

## 2. skills

### 2.1 Superpowers

安装命令：
``Fetch and follow instructions from https://raw.githubusercontent.com/obra/superpowers/refs/heads/main/.opencode/INSTALL.md``
实现方式：

- 将文件下载到当前项目目录
- 通过链接的形式，将skills指向下载的文件的目录，命令``ln -s ${workpath}/superpowers/.opencode/plugins/superpowers.js ~/.config/opencode/plugins/superpowers.js && ln -s /${workpath}/superpowers/skills ~/.config/opencode/skills/superpower``

[GITHUB](https://github.com/obra/superpowers/blob/main/README.md)

- mcp
