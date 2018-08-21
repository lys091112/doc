# install

转载地址： [tensorflow 安装](https://www.tensorflow.org/install/install_linux#InstallingVirtualenv)

### 使用 Virtualenv 进行安装


**请按照以下步骤使用 Virtualenv 安装 TensorFlow:**

1. 发出下列其中一条命令来安装 pip 和 Virtualenv：
```sh
$ sudo apt-get install python-pip python-dev python-virtualenv # for Python 2.7
$ sudo apt-get install python3-pip python3-dev python-virtualenv # for Python 3.n
```
2. 发出下列其中一条命令来创建 Virtualenv 环境：
```sh
$ virtualenv --system-site-packages targetDirectory # for Python 2.7
$ virtualenv --system-site-packages -p python3 targetDirectory # for Python 3.n
```
targetDirectory 用于指定 Virtualenv 树的顶层目录。我们的指令假定 targetDirectory 为 ~/tensorflow，但您可以选择任何目录。

3. 通过发出下列其中一条命令激活 Virtualenv 环境：
```sh
$ source ~/tensorflow/bin/activate # bash, sh, ksh, or zsh
$ source ~/tensorflow/bin/activate.csh  # csh or tcsh
$ . ~/tensorflow/bin/activate.fish  # fish
```
4. 执行上述 source 命令后，您的提示符应该会变成如下内容：
```sh
(tensorflow)$
确保安装了 pip 8.1 或更高版本：
(tensorflow)$ easy_install -U pip
```
5. 发出下列其中一条命令以在活动 Virtualenv 环境中安装 TensorFlow：
```sh
(tensorflow)$ pip install --upgrade tensorflow      # for Python 2.7
(tensorflow)$ pip3 install --upgrade tensorflow     # for Python 3.n
(tensorflow)$ pip install --upgrade tensorflow-gpu  # for Python 2.7 and GPU
(tensorflow)$ pip3 install --upgrade tensorflow-gpu # for Python 3.n and GPU
```
6. 如果上述命令执行成功，请跳过第 6 步。如果上述命令执行失败，请执行第 6 步。

（可选）如果第 5 步执行失败（通常是因为您所调用的 pip 版本低于 8.1），请通过发出以下格式的命令，在活动 Virtualenv 环境中安装 TensorFlow：
```
(tensorflow)$ pip install --upgrade tfBinaryURL   # Python 2.7
(tensorflow)$ pip3 install --upgrade tfBinaryURL  # Python 3.n

其中 tfBinaryURL 表示 TensorFlow Python 软件包的网址。tfBinaryURL 的正确值取决于操作系统、Python 版本和 GPU 支持。可在此处查找适合您系统的 tfBinaryURL 值。例如，如果您要为装有 Python 3.4 的 Linux 安装仅支持 CPU 的 TensorFlow，则发出以下命令以在活动 Virtualenv 环境中安装 TensorFlow：
j
(tensorflow)$ pip3 install --upgrade

 https://download.tensorflow.google.cn/linux/cpu/tensorflow-1.8.0-cp34-cp34m-linux_x86_64.whl
```










### ERROR: 
1. You are using pip version 9.0.1, however version 18.0 is available
```
pip3 install --upgrade pip
```
