#!/bin/bash -xe

wget https://www.python.org/ftp/python/3.5.0/Python-3.5.0.tgz
tar -xvf Python-3.5.0.tgz
cd Python-3.5.0
then

./configure
sudo make install

python3.5 get-pip.py --prefix=/usr/local/

