#sh tensorflow.sh /tmp/       - here all packages are stored under /tmp/

#!/bin/bash -xe

mkdir -p /opt/smarts/python
cp $1/cuda-repo-rhel7-8-0-local-ga2-8.0.61-1.x86_64.rpm /opt/smarts/
cp $1/cudnn-7.0-linux-x64-v4.0-prod.tgz /opt/smarts/
cp $1/tensorflow-1.1.0-cp36-cp36m-manylinux1_x86_64.whl /opt/smarts/

sudo tar -xzvf $1/Python-3.6.0.tgz --strip-components 1 -C /opt/smarts/python
cd /opt/smarts/python
sudo ./configure
sudo make altinstall
python_ver=python3.6

if grep -q "alias python=.*" $HOME/.bashrc; then
sed -i "s|export alias python=.*|export alias python=$python_ver|" $HOME/.bashrc
else
echo "alias python=$python_ver" >> $HOME/.bashrc
fi
source $HOME/.bashrc

alias python=$python_ver


# installing pip
python get-pip.py --prefix=/usr/local/
pip install wheel
pip install werkzeug
pip install six
pip install protobuf
pip install numpy
pip install mock

#Installing Tensorflow1.1 from https://pypi.python.org/pypi/tensorflow/1.1.0
#https://pythonprogramming.net/how-to-cuda-gpu-tensorflow-deep-learning-tutorial/
  # CUDA Toolkit 7.5 or greater from https://developer.nvidia.com/cuda-downloads
  #cuDNN 4.0 or greater from https://developer.nvidia.com/cudnn
  #Install TF from https://pypi.python.org/pypi/tensorflow/1.1.0

#Install Cuda, below document gives you installation process
#http://developer2.download.nvidia.com/compute/cuda/8.0/secure/Prod2/docs/sidebar/CUDA_Installation_Guide_Linux.pdf?aoHyeFvMvseO14veMuN7_0qHHhC_oHwpwg9cNMW58lFWQUSNsHo-oxwVntCm3LOXHVxfEmOM5JssPVzSXVerv8VJT62dszmpff1PBeE_XNWjXDqiXSNWyFb27DDIPQRqjTgXl7qwxQHHmVbYt5KPtabPbnRhW-ol6uKtZCV9d5SyoxKZ1Ia9cAgkjA

#wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-rhel7-8-0-local-ga2-8.0.61-1.x86_64-rpm --no-check-certificate
rpm -ivh /opt/smarts/cuda-repo-rhel7-8-0-local-ga2-8.0.61-1.x86_64.rpm

#Install cuDNN
#wget --no-check-certificate https://developer.nvidia.com/rdp/assets/cudnn-70-linux-x64-v40
tar -zxvf /opt/smarts/cudnn-7.0-linux-x64-v4.0-prod.tgz
mkdir -p /usr/local/cuda/include
sudo cp /opt/smarts/cuda/include/cudnn.h /usr/local/cuda/include
mkdir /usr/local/cuda/lib64
cp /opt/smarts/cuda/lib64/* /usr/local/cuda/lib64
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
sed -i "s|export alias python=.*|export alias python=$python_ver|" $HOME/.bashrc
else
echo "alias python=$python_ver" >> $HOME/.bashrc
fi
source $HOME/.bashrc
#wget https://pypi.python.org/packages/cd/e4/b2a8bcd1fa689489050386ec70c5c547e4a75d06f2cc2b55f45463cd092c/tensorflow-1.1.0-cp36-cp36m-manylinux1_x86_64.whl#md5=1f761290358dfb7fe4ec73140f4d282a
python -m pip install --ignore-installed --upgrade /opt/smarts/tensorflow-1.1.0-cp36-cp36m-manylinux1_x86_64.whl
if [ $? -eq 0 ]
then
echo "installing Tensorflow"
<<-'EOF'
python
import tensorflow
exit ()
EOF
ver=`python -c 'import tensorflow as tf; print(tf.__version__)'`
echo Tensorflow $ver is installed
else
echo "Tensorflow installation failed"
fi
