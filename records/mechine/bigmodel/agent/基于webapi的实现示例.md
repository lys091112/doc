# 基于webAPI实现

通过 Web API 的形式调用 AI 系统（如 OpenAI 的 ChatGPT），并实现 function_call 或 tool_calls 的功能，调用的入参需要包含以下关键信息：

- 用户输入：用户的自然语言请求。
- 函数定义：可调用的函数列表及其描述。
- 模型配置：指定是否启用函数调用功能。

以下是一个完整的 Web API 调用示例，展示如何通过 API 传递这些信息。

## 1. 单一函数调用

### 1.1 API 调用示例
假设我们使用 OpenAI 的 ChatGPT API，以下是一个完整的 API 调用示例：

API 请求
```json
{
  "model": "gpt-3.5-turbo",
  "messages": [
    {
      "role": "user",
      "content": "今天北京的天气怎么样？"
    }
  ],
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
    }
  ],
  "function_call": "auto"
}
```

API 响应: AI 系统会返回一个包含函数调用请求的响应：

```json
{
  "id": "chatcmpl-1234567890",
  "object": "chat.completion",
  "created": 1698765432,
  "model": "gpt-3.5-turbo",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": null,
        "function_call": {
          "name": "get_weather",
          "arguments": "{\"location\": \"北京\"}"
        }
      },
      "finish_reason": "function_call"
    }
  ],
  "usage": {
    "prompt_tokens": 50,
    "completion_tokens": 20,
    "total_tokens": 70
  }
}
```
### 1.2 参数说明

(1) model
指定使用的模型，例如 gpt-3.5-turbo 或 gpt-4。

(2) messages
包含对话历史的列表，每条消息需要指定 role（角色）和 content（内容）。

角色可以是：
- user：用户输入。
- assistant：AI 助手的回复。
- system：系统指令（可选）。

(3) functions
定义可调用的函数列表。
每个函数需要包含：
- name：函数名称。
- description：函数描述。
- parameters：函数的参数定义（JSON Schema 格式）。

(4) function_call
控制是否启用函数调用功能。

可选值：
- "auto"：由 AI 自动决定是否调用函数。
- "none"：禁用函数调用。
- {"name": "函数名"}：强制调用指定函数。

## 2.  多函数调用示例

如果需要支持多函数调用（tool_calls），API 请求和响应的格式如下：

API 请求
```json
{
  "model": "gpt-3.5-turbo",
  "messages": [
    {
      "role": "user",
      "content": "查询纽约的天气，并计算 123 加 456 等于多少。"
    }
  ],
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
    }
  ],
  "function_call": "auto"
}
```
API 响应: AI 系统会返回多个函数调用请求：

```json
{
  "id": "chatcmpl-1234567890",
  "object": "chat.completion",
  "created": 1698765432,
  "model": "gpt-3.5-turbo",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": null,
        "tool_calls": [
          {
            "id": "call_123",
            "type": "function",
            "function": {
              "name": "get_weather",
              "arguments": "{\"location\": \"纽约\"}"
            }
          },
          {
            "id": "call_456",
            "type": "function",
            "function": {
              "name": "calculate_math",
              "arguments": "{\"expression\": \"123 + 456\"}"
            }
          }
        ]
      },
      "finish_reason": "tool_calls"
    }
  ],
  "usage": {
    "prompt_tokens": 60,
    "completion_tokens": 40,
    "total_tokens": 100
  }
}
```

### 2.1 多个函数之间有相互依赖关系

有以下任务：

1. 查询天气：调用 get_weather 函数，获取某个城市的天气。
2. 翻译天气信息：调用 translate_text 函数，将天气信息翻译成目标语言。
3. 第二个函数（translate_text）依赖第一个函数（get_weather）的返回结果


1. 函数定义：

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
2. 分步调用示例
步骤 1：用户请求
用户输入： 查询北京的天气，并将结果翻译成中文。
步骤 2：第一次 API 调用
API 请求：
```json
{
  "model": "gpt-3.5-turbo",
  "messages": [
    {
      "role": "user",
      "content": "查询北京的天气，并将结果翻译成中文。"
    }
  ],
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
  ],
  "function_call": "auto"
}
```
API 响应： AI 系统生成第一个函数调用请求：

```json
{
  "role": "assistant",
  "content": null,
  "function_call": {
    "name": "get_weather",
    "arguments": "{\"location\": \"北京\"}"
  }
}

3. 执行第一个函数
开发者调用 get_weather 函数，获取天气信息：

```json
{
  "weather": "Sunny",
  "temperature": "22°C"
}

 4.第二次 API 调用
API 请求：
将第一个函数的结果作为新的消息传递给 AI 系统：

```json
{
  "model": "gpt-3.5-turbo",
  "messages": [
    {
      "role": "user",
      "content": "查询北京的天气，并将结果翻译成中文。"
    },
    {
      "role": "assistant",
      "content": null,
      "function_call": {
        "name": "get_weather",
        "arguments": "{\"location\": \"北京\"}"
      }
    },
    {
      "role": "function",
      "name": "get_weather",
      "content": "{\"weather\": \"Sunny\", \"temperature\": \"22°C\"}"
    }
  ],
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
  ],
  "function_call": "auto"
}```

API 响应：
AI 系统生成第二个函数调用请求：
```json
{
  "role": "assistant",
  "content": null,
  "function_call": {
    "name": "translate_text",
    "arguments": "{\"text\": \"The weather in 北京 is sunny with a temperature of 22°C.\", \"target_language\": \"Chinese\"}"
  }
}```

步骤 5：执行第二个函数
开发者调用 translate_text 函数，将天气信息翻译成中文：
```json
{
  "translated_text": "北京的天气是晴天，气温 22°C。"
}
```
步骤 6：最终 API 调用
API 请求： 将第二个函数的结果作为新的消息传递给 AI 系统：

```json
{
  "model": "gpt-3.5-turbo",
  "messages": [
    {
      "role": "user",
      "content": "查询北京的天气，并将结果翻译成中文。"
    },
    {
      "role": "assistant",
      "content": null,
      "function_call": {
        "name": "get_weather",
        "arguments": "{\"location\": \"北京\"}"
      }
    },
    {
      "role": "function",
      "name": "get_weather",
      "content": "{\"weather\": \"Sunny\", \"temperature\": \"22°C\"}"
    },
    {
      "role": "assistant",
      "content": null,
      "function_call": {
        "name": "translate_text",
        "arguments": "{\"text\": \"The weather in 北京 is sunny with a temperature of 22°C.\", \"target_language\": \"Chinese\"}"
      }
    },
    {
      "role": "function",
      "name": "translate_text",
      "content": "{\"translated_text\": \"北京的天气是晴天，气温 22°C。\"}"
    }
  ],
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
  ],
  "function_call": "auto"
}
API 响应：
AI 系统生成最终回复：
```json
{
  "role": "assistant",
  "content": "北京的天气是晴天，气温 22°C。"
}```

**总结**: 
通过 分步调用 的方式，可以实现多函数调用中第二个函数依赖第一个函数返回结果的场景。具体步骤包括：
- 第一次 API 调用，生成第一个函数调用请求。
- 执行第一个函数，并将结果返回给 AI 系统。
- 第二次 API 调用，生成第二个函数调用请求。
- 执行第二个函数，并将结果返回给 AI 系统。
- AI 系统生成最终回复。


总结
通过 Web API 调用 AI 系统时，入参需要包含：
用户输入：messages 字段。
函数定义：functions 字段。
函数调用配置：function_call 字段。

API 响应会返回生成的函数调用请求（function_call 或 tool_calls），开发者可以根据这些请求调用对应的函数，并将结果返回给 AI 系统以生成最终回复。

