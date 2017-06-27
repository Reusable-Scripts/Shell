#!/bin/bash -xe

wget https://www.python.org/ftp/python/3.5.0/Python-3.5.0.tgz
tar -xvf Python-3.5.0.tgz
cd Python-3.5.0
./configure
sudo make install

# installing pip
python3.5 get-pip.py --prefix=/usr/local/

#Installing Tensorflow1.1 from https://pypi.python.org/pypi/tensorflow/1.1.0
#https://pythonprogramming.net/how-to-cuda-gpu-tensorflow-deep-learning-tutorial/
  # CUDA Toolkit 7.5 or greater from https://developer.nvidia.com/cuda-downloads
  #cuDNN 4.0 or greater from https://developer.nvidia.com/cudnn
  #Install TF from https://pypi.python.org/pypi/tensorflow/1.1.0

#Install Cuda, below document gives you installation process
#http://developer2.download.nvidia.com/compute/cuda/8.0/secure/Prod2/docs/sidebar/CUDA_Installation_Guide_Linux.pdf?aoHyeFvMvseO14veMuN7_0qHHhC_oHwpwg9cNMW58lFWQUSNsHo-oxwVntCm3LOXHVxfEmOM5JssPVzSXVerv8VJT62dszmpff1PBeE_XNWjXDqiXSNWyFb27DDIPQRqjTgXl7qwxQHHmVbYt5KPtabPbnRhW-ol6uKtZCV9d5SyoxKZ1Ia9cAgkjA

wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-rhel7-8-0-local-ga2-8.0.61-1.x86_64-rpm --no-check-certificate
rpm -ivh cuda-repo-rhel7-8-0-local-ga2-8.0.61-1.x86_64.rpm

#Install cuDNN
wget --no-check-certificate https://developer.nvidia.com/rdp/assets/cudnn-70-linux-x64-v40
tar -zxvf cudnn-7.0-linux-x64-v4.0-prod.tgz
mkdir -p /usr/local/cuda/include
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
mkdir /usr/local/cuda/lib64
cp cuda/lib64/* /usr/local/cuda/lib64
chmod a+r /usr/local/cuda/lib64/libcudnn*
if grep -q "export LD_LIBRARY_PATH=.*" $HOME/.bashrc; then
sed -i "s|export LD_LIBRARY_PATH=.*|export LD_LIBRARY_PATH=$LD_LIBRARY_PATH|" $HOME/.bashrc
else
echo "export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64"" >> $HOME/.bashrc
fi
if grep -q "export CUDA_HOME=.*" $HOME/.bashrc; then
sed -i "s|export CUDA_HOME=.*|export CUDA_HOME=$CUDA_HOME|" $HOME/.bashrc
else
echo "export CUDA_HOME=/usr/local/cuda" >> $HOME/.bashrc
fi
if grep -q "export LD_LIBRARY_PATH=.*" /etc/environment; then
sed -i "s|export LD_LIBRARY_PATH=.*|export LD_LIBRARY_PATH=$LD_LIBRARY_PATH|" /etc/environment
else
echo "export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64"" >> /etc/environment
fi
if grep -q "export CUDA_HOME=.*" /etc/environment; then
sed -i "s|export CUDA_HOME=.*|export CUDA_HOME=$CUDA_HOME|" /etc/environment
else
echo "export CUDA_HOME=/usr/local/cuda" >> /etc/environment
fi
if grep -q "alias python=.*" $HOME/.bashrc; then
sed -i "s|export alias python=.*|export alias python=python3.5|" $HOME/.bashrc
else
echo "alias python=python3.5" >> $HOME/.bashrc
fi
source $HOME/.bashrc
wget https://pypi.python.org/packages/cd/e4/b2a8bcd1fa689489050386ec70c5c547e4a75d06f2cc2b55f45463cd092c/tensorflow-1.1.0-cp36-cp36m-manylinux1_x86_64.whl#md5=1f761290358dfb7fe4ec73140f4d282a
pip install ./tensorflow-1.1.0-cp36-cp36m-manylinux1_x86_64.whl

<<-'EOF'
python
import tensorflow

EOF
