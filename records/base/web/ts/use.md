# ts 基础使用

## 1. 语法详解

1. ``{...data,data.todos}`` 和 ``[...data.todos, todos]`` 的区别

   - ``{...data,data.todos}`` 会将 data.todos 覆盖掉 data 中的 todos
   - ``[...data.todos, todos]`` 会将 todos 添加到 data.todos 的后面

