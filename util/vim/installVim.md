# unbuntu 编译安装vim

## 手动编译

    1.删除掉旧的vim sudo apt-get remove vim vim-runtime gvim
      可能还需要删除sudo apt-get remove vim-tiny vim-common vim-gui-common
    2.手动安装一下库，解决依赖问题
        eui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev ruby-dev mercurial
    3. 解压vim源码包，进入目录进行编译
       * cd ~/downloads/vim74/  
       *  ./configure --with-features=huge --enable-rubyinterp --enable-pythoninterp --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux/ --enable-perlinterp --enable-gui=gtk2 --enable-cscope --enable-luainterp --enable-multibyte --enable-xim --prefix=/usr
       参数说明：
       --with-features=huge：支持最大特性
       --enable-rubyinterp：启用Vim对ruby编写的插件的支持
       --enable-pythoninterp：启用Vim对python编写的插件的支持
       --enable-luainterp：启用Vim对lua编写的插件的支持
       --enable-perlinterp：启用Vim对perl编写的插件的支持
       --enable-multibyte 和 --enable-xim：需要在Vim中输入中文，开启这两个特性
       --enable-cscope：Vim对cscope支持
       --enable-gui=gtk2：gtk2支持,也可以使用gnome，表示生成gvim
       --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/ 指定 python 路径，这是python2在ubuntu64位机子上的路径，32位应该为/usr/lib/python2.7/config-i386-linux-gnu/
       --prefix=/usr：设定编译安装路径，注意自己是否有权限访问。
       如果configure出错，先用make distclean清除之前configure产生的文件再configure
    4. 指定VIMRUNTIMEDIR
       * make VIMRUNTIMEDIR=/usr/share/vim/vim74
    5.编译执行
       * sudo make install
    
## 插件安装

### YouCommleteMe

    在~/.vimrc中添加一行：
    Plugin 'Valloric/YouCompleteMe'
    保存退出后，再打开/etc/vimrc并执行 :PluginInstall。
    然后cd到.vim/bundle/YouCompleteMe 执行：git submodule update –-init –-recursive



## 参数配置

    "golang
    - 新起一行输入fmt.，然后ctrl+x, ctrl+o，Vim 会弹出补齐提示下拉框，不过并非实时跟随的那种补齐，这个补齐是由gocode提供的。
    -– 输入一行代码：time.Sleep(time.Second)，执行:GoImports，Vim会自动导入time包。
    -– 将光标移到Sleep函数上，执行:GoDef或命令模式下敲入gd，Vim会打开$GOROOT/src/time/sleep.go中 的Sleep函数的定义。执行:b 1返回到hellogolang.go。
    -– 执行:GoLint，运行golint在当前Go源文件上。
    -– 执行:GoDoc，打开当前光标对应符号的Go文档。
    -– 执行:GoVet，在当前目录下运行go vet在当前Go源文件上。
    -– 执行:GoRun，编译运行当前main package。
    -– 执行:GoBuild，编译当前包，这取决于你的源文件，GoBuild不产生结果文件。
    -– 执行:GoInstall，安装当前包。
    -– 执行:GoTest，测试你当前路径下地_test.go文件。
    -– 执行:GoCoverage，创建一个测试覆盖结果文件，并打开浏览器展示当前包的情况。
    -– 执行:GoErrCheck，检查当前包种可能的未捕获的errors。
    -– 执行:GoFiles，显示当前包对应的源文件列表。
    -– 执行:GoDeps，显示当前包的依赖包列表。
    -– 执行:GoImplements，显示当前类型实现的interface列表。
    -– 执行:GoRename [to]，将当前光标下的符号替换为[to]
