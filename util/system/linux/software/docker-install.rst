.. _linux_basic_software_docker:

.. toctree::
   :maxdepth: 1
   :glob:


docker-install
---------------

Ubuntu 18.04 安装 Docker-ce
==============================

1. 更换国内软件源，推荐中国科技大学的源，稳定速度快（可选）

::
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    sudo sed -i 's/cn.archive.ubuntu.com/mirrors.ustc.edu.cn/' /etc/apt/sources.list
    sudo apt update

2. 安装需要的包

::
    sudo apt install apt-transport-https ca-certificates software-properties-common curl


3. 添加 GPG 密钥，并添加 Docker-ce 软件源，这里还是以中国科技大学的 Docker-ce 源为例

::
    curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu \
    $(lsb_release -cs) stable"

4. 添加成功后更新软件包缓存

::
    sudo apt update

5. 安装 Docker-ce

::
    sudo apt install docker-ce

6. 设置开机自启动并启动 Docker-ce（安装成功后默认已设置并启动，可忽略）

::
    sudo systemctl enable docker
    sudo systemctl start docker

7. 测试运行

::
    sudo docker run hello-world

8. 添加当前用户到 docker 用户组，可以不用 sudo 运行 docker（可选）

::
    sudo groupadd docker
    // sudo usermod -aG docker $USER
    sudo gpasswd -a ${USER} docker //将用户添加到docker组

9. 测试添加用户组（可选）

::
    docker run hello-world

docker-compose 安装
==========================

::
    sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version


安装脚本
==========

.. code-block:: sh

    #!/bin/bash

    #参照官方文档，对原有的docker进行更新，参考链接：https://docs.docker.com/engine/installation/linux/ubuntu/#install-from-a-package

    sudo apt-get upgrade

    #Install packages to allow apt to use a repository over HTTPS
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

    #Add Docker’s official GPG key using your customer Docker EE repository URL:
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    #apt-key fingerprint 0EBFCD88
    sudo apt-key fingerprint 0EBFCD88

    #Use the following command to set up the stable repository, replacing <DOCKER-EE-URL> with the URL you noted down in the prerequisites.
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

    #Update the apt package index
    sudo apt-get upgrade

    #install the latest version of Docker
    sudo apt-get install docker-ce

