# HomeBrew 使用 


1. 软件下载失败问题解决 

homebrew 在更新失败时会打印出失败的地址链接，通过其他方式下载

方式一：

执行 `` brew --cache `` 会打印出brew的cache目录

如 ``/Users/<UserName>/Library/Caches/Homebrew``  将下载到的包拷贝到该目录下再次尝试

方式二：
如果方式一无法进行， 在install时加上 ``-v`` 参数，会打印出文件的下载地址

    /usr/bin/curl -q --globoff --show-error --user-agent Homebrew/2.2.11\ \(Macintosh\;\ Intel\ Mac\ OS\ X\ 10.12.3\)\ curl/7.51.0 --fail --retry 3 --location --remote-time --continue-at 0 --output /Users/langle/Library/Caches/Homebrew/downloads/144caacdf2a1a6421390f0b161226fdb51a399605f9af3a11dc2cfa2839504a9--graphviz-2.42.3.tar.gz.incomplete https://www2.graphviz.org/Packages/stable/portable_source/graphviz-2.42.3.tar.gz

将incomplete前面的内容提取出来，然后将下载的文件拷贝到该目录，在通过软链接在``brew --cache`` 的目录下建立关系

再次执行 

方式3:

如果方式二也不行，则可以通过 ``brew edit xxx`` 编辑文件，可以修改文件的下载地址，或者也可以修改文件的sha256 认证

再次尝试 

2. 更新后 brew 无法使用

错误如下：
`` Error: Cask 'deeper' definition is invalid: invalid 'depends_on macos' value: unknown or unsupported macOS version: :mavericks``

可以使用命令： `` brew update-reset`` 对brew进行重置更新

3. 执行node 失败

错误如下:
 node
dyld: Library not loaded: /usr/local/opt/c-ares/lib/libcares.2.dylib
  Referenced from: /usr/local/bin/node
  Reason: image not found

解决方式：
ln -sf /usr/local/Cellar/c-ares/1.18.1_1 /usr/local/opt/c-ares

即将虚拟文件链接到真实文件下
