#!/bin/bash

Pkgname="";
Install_Dir="/opt/smarts"

check_version() {
echo "checking if version already exists"

if command -v python3 &>/dev/null; then
echo python 3 is installed
else
echo python3 is not installed
fi

}

install() {
cd 
tar -zxvf Python-3.5.2.tar.gz
cd Python-3.5.2
./configure --prefix=$Install_Dir
make && make altinstall
}

post-install() {
echo adding it to path, if not already there
[[ ":$PATH:" !=  *":${Install_Dir}/:"* && PATH="${Install_Dir}:${PATH}" ]]
}

setuptools() {
cd 
tar -zxvf setuptools-1.4.2.tar.gz
cd setuptools-1.4.2
python3 setup.py install
} 
