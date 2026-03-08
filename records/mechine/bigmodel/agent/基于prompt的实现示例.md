## 基于prompt的实现

假设我们有一个 AI 系统，支持以下功能：
- 查询天气：调用 get_weather 函数，参数为 location（城市名称）。
- 计算数学表达式：调用 calculate_math 函数，参数为 expression（数学表达式）。
- 翻译文本：调用 translate_text 函数，参数为 text（待翻译文本）和 target_language（目标语言）。

1. 定义函数
首先，我们需要定义这些函数的功能和参数。以下是一个示例：

```json
{
  "functions": [
    {
      "name": "get_weather",
      "description": "Get the current weather for a specific location.",
      "parameters": {
        "type": "object",
        "properties": {
          "location": {
            "type": "string",
            "description": "The city and state, e.g., San Francisco, CA"
          }
        },
        "required": ["location"]
      }
    },
    {
      "name": "calculate_math",
      "description": "Calculate the result of a mathematical expression.",
      "parameters": {
        "type": "object",
        "properties": {
          "expression": {
            "type": "string",
            "description": "The mathematical expression to calculate, e.g., '2 + 2'"
          }
        },
        "required": ["expression"]
      }
    },
    {
      "name": "translate_text",
      "description": "Translate text from one language to another.",
      "parameters": {
        "type": "object",
        "properties": {
          "text": {
            "type": "string",
            "description": "The text to translate, e.g., 'Hello, world!'"
          },
          "target_language": {
            "type": "string",
            "description": "The target language, e.g., 'Chinese'"
          }
        },
        "required": ["text", "target_language"]
      }
    }
  ]
}
```

2. Prompt 设计
在 Prompt 中，我们需要告诉 AI 系统如何解析用户请求并生成函数调用请求。以下是一个完整的 Prompt 示例：
```md
你是一个 AI 助手，能够根据用户请求调用以下函数：

1. **查询天气**：
- 方法名：`get_weather`
- 参数：`location`（城市名称）。

2. **计算数学表达式**：
- 方法名：`calculate_math`
- 参数：`expression`（数学表达式）。

3. **翻译文本**：
- 方法名：`translate_text`
- 参数：`text`（待翻译文本）和 `target_language`（目标语言）。

请根据用户请求生成 JSON 格式的函数调用请求。如果用户请求需要调用多个函数，请生成多个函数调用请求。

示例：
用户输入：“今天北京的天气怎么样？”
```json
  {
    "function": "get_weather",
    "arguments": {
      "location": "北京"
    }
  }
```

用户输入：“计算一下 123 加 456 等于多少。”

```json
{
  "function": "calculate_math",
  "arguments": {
    "expression": "123 + 456"
  }
}
```

用户输入：“把 'Hello, world!' 翻译成中文。”
```json
{
  "function": "translate_text",
  "arguments": {
    "text": "Hello, world!",
    "target_language": "中文"
  }
}
```

3. 现在，请根据以下用户输入生成函数调用请求：

--- 

### **4. 示例运行**

#### **示例 1：查询天气**
- 用户输入：
今天上海的天气怎么样？

- AI 输出：
```json
{
  "function": "get_weather",
  "arguments": {
    "location": "上海"
  }
}
```
示例 2：计算数学表达式
用户输入： 计算一下 100 乘以 25 等于多少。

AI 输出：
```json
{
  "function": "calculate_math",
  "arguments": {
    "expression": "100 * 25"
  }
}
```
示例 3：翻译文本
用户输入： 把 'Good morning' 翻译成中文。

AI 输出：
```json
{
  "function": "translate_text",
  "arguments": {
    "text": "Good morning",
    "target_language": "中文"
  }
}
```

示例 4：多函数调用
用户输入： 查询纽约的天气，并计算 123 加 456 等于多少。

AI 输出：
```json
[
  {
    "function": "get_weather",
    "arguments": {
      "location": "纽约"
    }
  },
  {
    "function": "calculate_math",
    "arguments": {
      "expression": "123 + 456"
    }
  }
]
```
5. 总结
function_call 和 tool_calls 是通过 Prompt 和 API 请求传递的。

在 Prompt 中，我们需要明确告诉 AI 系统如何解析用户请求并生成函数调用请求。

通过定义函数和设计 Prompt，AI 系统可以动态调用外部工具，完成复杂任务。

这种设计可以轻松扩展到更多场景，只需在 Prompt 中添加新的函数定义和示例即可。