# brew 安装python 3.6

brew python 间切换

```
// 解除python的连接
brew unlink python3

brew switch python 3.7.4_1

brew switch python 3.6.12

// 用于修改python的指定路径，从而可以通过witch切换到指定版本
brew link --overwrite python

```

# 使用其他的依赖安装python3.6

```brew install sashkab/python/python@3.6```

    If that doesn't show you an update run:
    sudo rm -rf /Library/Developer/CommandLineTools
    sudo xcode-select --install

    Alternatively, manually download them from:
    https://developer.apple.com/download/more/.

    ==> ./configure --prefix=/usr/local/Cellar/python@3.6/3.6.12 --enable-ipv6 --datarootdir=/usr/local/Cellar/python@3.6/3.6.12/sh
    ==> make
    ==> make altinstall PYTHONAPPSDIR=/usr/local/Cellar/python@3.6/3.6.12
    ==> make frameworkinstallextras PYTHONAPPSDIR=/usr/local/Cellar/python@3.6/3.6.12/share/python@3.6
    ==> /usr/local/Cellar/python@3.6/3.6.12/bin/python3.6 -s setup.py --no-user-cfg install --force --verbose --install-scripts=/us
    ==> /usr/local/Cellar/python@3.6/3.6.12/bin/python3.6 -s setup.py --no-user-cfg install --force --verbose --install-scripts=/us
    ==> /usr/local/Cellar/python@3.6/3.6.12/bin/python3.6 -s setup.py --no-user-cfg install --force --verbose --install-scripts=/us
    ==> Caveats
    You can install Python packages with
    pip3.6 install <package>

    They will install into the site-package directory
    /usr/local/lib/python3.6/site-packages

    See: https://docs.brew.sh/Homebrew-and-Python

    python@3.6 is keg-only, which means it was not symlinked into /usr/local,
    because this is an alternate version of another formula.

    If you need to have python@3.6 first in your PATH run:
    echo 'export PATH="/usr/local/opt/python@3.6/bin:$PATH"' >> ~/.zshrc

    For compilers to find python@3.6 you may need to set:
    export LDFLAGS="-L/usr/local/opt/python@3.6/lib"

    For pkg-config to find python@3.6 you may need to set:
    export PKG_CONFIG_PATH="/usr/local/opt/python@3.6/lib/pkgconfig"