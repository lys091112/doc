# UTF8 详解


## 1. UTF8 编码结构

| Unicode编码(十六进制)	| UTF-8 字节流(二进制) | rune 类型 ｜
| :-- | :-- | :-- |
| 000000-00007F | 0xxxxxxx | 0-127 (ASCII) |
| 000080-0007FF	| 110xxxxx 10xxxxxx | 128-2047|
| 000800-00FFFF	| 1110xxxx 10xxxxxx 10xxxxxx | 2048-65535 |
| 010000-10FFFF	| 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx | 63335 - 0x10ffff |


## 2.  






## 参考链接

[Golang的rune数据类型，Unicode字符编码与UTF-8字节码](https://blog.csdn.net/HayPinF/article/details/111467763)
