
## 1. string 可以存储中文吗

```
    1. java中的char是unicode存储，unicode编码字符集中包含了汉字，所以可以存储中文；

    2. java内部其实是使用的UTF-16的编码，所以是支持大部分非生僻汉字的；

    3. 采用Unicode编码集，一个char占用两个字节，而一个中文字符也是两个字节，因此Java中的char是可以表示一个中文字符的；

    4. Java的char只能表示utf­16中的BMP部分中文字符，不能表示扩展字符集里的中文字符, 绝大部分的中文字符的Unicode范围是[0x4E00, 0x9FBB],恰好是在BMP范围内

    char字符存储的是Unicode编码的代码点，也就是存储的是U+FF00这样的数值，然而我们在调试或者输出到输出流的时候，是JVM或者开发工具按照代码点对应的编码字符输出的,虽然UTF-8编码的中文字符是占用3个或者4个字节，但是对应的代码点仍然集中在[0x4E00, 0x9FBB]，所以char是能够存下在这个范围内的中文字符的,但是对于超过16bit的Unicode字符集，也就是Unicode的扩展字符集，一个char是放不下的，需要两个char才能放下
```
例如：

```java

    public void test(){
        char[] k = "\uD842\uDFB7".toCharArray();
            System.out.println(k); // 输出中文 𠮷  需要2个char来表示
            for(char c: k) {
                System.out.println(c); // 字符拆分后输出的是俩问号 ?
            }
    }
```

## 2. UTF-16

   Unicode 是一本很厚的字典，她将全世界所有的字符定义在一个集合里。这么多的字符不是一次性定义的，而是分区定义。每个区可以存放 65536 个（2^16）字符，称为一个平面（plane）。目前，一共有 17 个（2^5）平面，也就是说，整个 Unicode 字符集的大小现在是 2^21。

最前面的 65536 个字符位，称为基本平面（简称 BMP ），它的码点范围是从 0 到 2^16-1，写成 16 进制就是从 U+0000 到 U+FFFF。所有最常见的字符都放在这个平面，这是 Unicode 最先定义和公布的一个平面。剩下的字符都放在辅助平面（简称 SMP ），码点范围从 U+010000 到 U+10FFFF。

基本了解了平面的概念后，再说回到 UTF-16。UTF-16 编码介于 UTF-32 与 UTF-8 之间，同时结合了定长和变长两种编码方法的特点。它的编码规则很简单：基本平面的字符占用 2 个字节，辅助平面的字符占用 4 个字节。也就是说，UTF-16 的编码长度要么是 2 个字节（U+0000 到 U+FFFF），要么是 4 个字节（U+010000 到 U+10FFFF）。那么问题来了，当我们遇到两个字节时，到底是把这两个字节当作一个字符还是与后面的两个字节一起当作一个字符呢？

这里有一个很巧妙的地方，在基本平面内，从 U+D800 到 U+DFFF 是一个空段，即这些码点不对应任何字符。因此，这个空段可以用来映射辅助平面的字符。

辅助平面的字符位共有 2^20 个，因此表示这些字符至少需要 20 个二进制位。UTF-16 将这 20 个二进制位分成两半，前 10 位映射在 U+D800 到 U+DBFF，称为高位（H），后 10 位映射在 U+DC00 到 U+DFFF，称为低位（L）。这意味着，一个辅助平面的字符，被拆成两个基本平面的字符表示。

因此，当我们遇到两个字节，发现它的码点在 U+D800 到 U+DBFF 之间，就可以断定，紧跟在后面的两个字节的码点，应该在 U+DC00 到 U+DFFF 之间，这四个字节必须放在一起解读。

接下来，以汉字"𠮷"为例，说明 UTF-16 编码方式是如何工作的。

汉字"𠮷"的 Unicode 码点为 0x20BB7，该码点显然超出了基本平面的范围（0x0000 - 0xFFFF），因此需要使用四个字节表示。首先用 0x20BB7 - 0x10000 计算出超出的部分，然后将其用 20 个二进制位表示（不足前面补 0 ），结果为0001000010 1110110111。接着，将前 10 位映射到 U+D800 到 U+DBFF 之间，后 10 位映射到 U+DC00 到 U+DFFF 即可。U+D800 对应的二进制数为 1101100000000000，直接填充后面的 10 个二进制位即可，得到 1101100001000010，转成 16 进制数则为 0xD842。同理可得，低位为 0xDFB7。因此得出汉字"𠮷"的 UTF-16 编码为 0xD842 0xDFB7。

Unicode3.0 中给出了辅助平面字符的转换公式：

H = Math.floor((c-0x10000) / 0x400)+0xD800

L = (c - 0x10000) % 0x400 + 0xDC00
根据编码公式，可以很方便的计算出字符的 UTF-16 编码
   

3. unicode 和 utf-8的映射

+---------+---------------------------+-------------------------------------+
| Unicode | 十六进制码点范围(4个字节) | UTF-8 二进制                        |
+=========+===========================+=====================================+
| x       | 0000 0000 - 0000 007F     | 0xxxxxxx                            |
+---------+---------------------------+-------------------------------------+
| x       | 0000 0080 - 0000 07FF     | 110xxxxx 10xxxxxx                   |
+---------+---------------------------+-------------------------------------+
| x       | 0000 0800 - 0000 FFFF     | 1110xxxx 10xxxxxx 10xxxxxx          |
+---------+---------------------------+-------------------------------------+
| x       | 0001 0000 - 0010 FFFF     | 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx |
+---------+---------------------------+-------------------------------------+

转化： “汉”的 Unicode 码点是 0x6c49（110 1100 0100 1001），通过上面的对照表可以发现，0x0000 6c49 位于第三行的范围，那么得出其格式为 1110xxxx 10xxxxxx 10xxxxxx。接着，从“汉”的二进制数最后一位开始，从后向前依次填充对应格式中的 x，多出的 x 用 0 补上。这样，就得到了“汉”的 UTF-8 编码为 11100110 10110001 10001001，转换成十六进制就是 0xE6 0xB7 0x89。
