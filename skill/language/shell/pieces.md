# shell code片段

1. 获取文件指定位置的内容，并进行提取

从当前文件\$0 遍历 PAYLOAD: 字符串，获取字符串所在的行号，然后使用tail -n +K 提取之后的数据内容并解压缩到制定目录
随后可以在该目录中进行处理
```sh
function untar_payload()
{
  match=(grep --text --line-number '^PAYLOAD:$' $0 | cut -d ':' -f 1)
  payload_start=((match + 1))
 tail -n +$payload_start $0 | tar -xzf - -C $INSTALL_DIR
}

```
