# zsh

## 3. 插件

| 插件| 功能 | 地址 |
| -- | -- | -- |
| zsh-autosuggestions | 自动提示输入提示 | <https://github.com/zsh-users/zsh-autosuggestions> |
| zsh-syntax-highlighting | 高亮命令输入 | <https://github.com/zsh-users/zsh-syntax-highlighting> |
| zsh-history-substring-search | 查找匹配前缀的历史输入 | <https://github.com/zsh-users/zsh-history-substring-search> |

### 3.1 快捷键配置

```sh
# ctrl+n/ctrl+p
bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down

# 如果希望支持 vi 的 jk，配置如下：
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
```
