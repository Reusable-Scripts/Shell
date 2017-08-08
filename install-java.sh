#!/bin/bash
 
#JDK-Functions
function JDK_VERSION_EIGHT
{
        echo "Install version jdk-8u25-linux-x64"
 
        wget  wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-x64.tar.gz" -O /opt/jdk-8u25-linux-x64.rpm
        rpm -ivh /root/download/jdk-8u25-linux-x64.rpm
 
        export JAVA_HOME=/usr/java/jdk1.8.0_25/
        export PATH=$JAVA_HOME/bin:$PATH
        export PATH=$PATH:$JAVA_HOME/bin
 
        echo 'export JAVA_HOME=/usr/java/jdk1.8.0_25/' >> ~/.bash_profile
        echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bash_profile
        echo 'export PATH=$PATH:$JAVA_HOME"/bin' >> ~/.bash_profile
}
 
function JDK_VERSION_SEVEN
{
        echo "Install version jdk-7u60-linux-x64"
 
        wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u60-b19/jdk-7u60-linux-x64.rpm" -O /opt/jdk-7u60-linux-x64.rpm
 
 
         rpm -ivh /opt/jdk-7u60-linux-x64.rpm
 
        export JAVA_HOME=/usr/java/jdk1.7.0_60
        export PATH=$JAVA_HOME/bin:$PATH
        export PATH=$PATH:$JAVA_HOME/bin
 
        echo 'export JAVA_HOME=/usr/java/jdk1.7.0_60' >> ~/.bash_profile
        echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bash_profile
        echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bash_profile
        #Check JAVA_HOME
        echo $JAVA_HOME
}
 
echo "Instal JDK 7 or JDK 8 "
echo "~~~~~~~~~~~~~~~~~~~~~~"
 
if [ -f "rpm -qa | grep glibc" ]; then
yum install glibc.i686 -y
fi
if [ -f "rpm -qa | grep libgcc" ]; then
yum install libgcc-* -y
fi
 
if [ -f "/usr/java/jdk" ]; then
echo "JAVA Already Installed in Your System"
else
 
    echo "  Press ( 8 ) to be Installed JDK 8"
    echo "  Press ( 7 ) to be Installed JDK 7"
 
echo "Your Version: "
 
read JDK_VERSION
 
    if [ $JDK_VERSION = "8" ]; then
        JDK_VERSION_EIGHT
    fi
 
    if [ $JDK_VERSION = "7" ]; then
        JDK_VERSION_SEVEN
    fi
fi
echo " Check the JAVA_HOME path"
echo $JAVA_HOME
##############################################
