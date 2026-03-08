# C++ 基础

## 1. 环境安装

Libstdc++是GCC的C++标准库实现,也可以称gcc-libs
Libc++是C++标准库的一种实现,Libc++是LLVM项目(clang等）的一部分，它与GCC的C++标准库实现（Libstdc++）有所不同

```sh
# sudo pacman -S gdd

sudo pacman -S gcc
# 或者
sudo pacman -S clang

# C++ 标准库
sudo pacman -S libstdc++5 or  sudo pacman -S gcc-libs 
# 或者如果使用Clang的libc++
sudo pacman -S libc++

# C++依赖库
sudo pacman -S cmake
sudo pacman -S boost
``
