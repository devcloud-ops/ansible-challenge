#!/bin/bash

# initial update and upgrade
sudo yum update -y
sudo yum upgrade -y

# install python3
sudo yum update -y
sudo yum install gcc openssl-devel bzip2-devel libffi-devel -y
sudo curl -O https://www.python.org/ftp/python/3.9.2/Python-3.9.2.tgz
sudo tar -xzf Python-3.9.2.tgz
cd Python-3.9.2/
sudo ./configure --enable-optimizations
sudo make altinstall
sudo yum update -y
sudo rm /usr/bin/python3
sudo ln /usr/local/bin/python3.9 /usr/bin/python3
python3 -m pip install --upgrade pip

# # install build essential tools
sudo yum update -y
sudo yum install -y build-essential
sudo yum update -y

# install dnf
sudo yum update -y
sudo yum install -y dnf
sudo yum update -y
dnf -y update

# # install ansible
sudo yum update -y
sudo yum install -y epel-release
sudo yum install -y ansible
dnf -y install podman ansible-core
sudo yum update -y

# # install yamllint
sudo dnf install -y yamllint

# # install ansible lint
sudo python3 -m pip install --upgrade pip
pip install ansible-lint

# # install tree
sudo yum install -y tree

# # upgrade centos and remove unneeded packages
sudo yum upgrade -y
sudo yum autoremove -y
