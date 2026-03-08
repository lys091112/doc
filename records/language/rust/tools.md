# 工具介绍


## 1. rustup


## 2. cargo


- cargo check 验证程序结构——这不会编译我们的程序，但会确保项目文件结构正确

- cargo build 在调试模式下构建应用程序, 如果它不存在，这将在项目的根目录中创建一个 target 文件夹, 添加 -release 切换到 release 模式构建（见下文）

- cargo clean 清理（即删除）构建文件，比如构建期间生成的任何二进制文件

- cargo run 运行程序 - 如果尚未构建，这也将构建应用程序

- cargo test 运行项目中存在的任何测试（默认脚手架中不会有任何测试）

- cargo fmt 会将代码格式化为 [Rust 编码标准](https://github.com/rust-lang/style-team)。

- cargo doc --open 为当前工程依赖的包生成在线的api文档

默认情况下，cargo build 和 cargo run 将在 DEBUG 模式下构建项目。要构建项目以发布到生产环境，请将 --release 参数添加到 cargo 
