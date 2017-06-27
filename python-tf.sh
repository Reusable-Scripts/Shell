#!/bin/bash -xe

wget https://www.python.org/ftp/python/3.5.0/Python-3.5.0.tgz
tar -xvf Python-3.5.0.tgz
cd Python-3.5.0
then

./configure
sudo make install

python3.5 get-pip.py --prefix=/usr/local/

#Installing Tensorflow1.1 from https://pypi.python.org/pypi/tensorflow/1.1.0
wget https://pypi.python.org/packages/cd/e4/b2a8bcd1fa689489050386ec70c5c547e4a75d06f2cc2b55f45463cd092c/tensorflow-1.1.0-cp36-cp36m-manylinux1_x86_64.whl#md5=1f761290358dfb7fe4ec73140f4d282a
pip install ./tensorflow-1.1.0-cp36-cp36m-manylinux1_x86_64.whl
