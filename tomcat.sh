#!/bin/bash +X
JAVA_VER=$(java -version 2>&1 | grep -i version | sed 's/.*version ".*\.\(.*\)\..*"/\1/; 1q')
if [ -n "$(echo $JAVA_VER)" ]; then
#if java is already installed set js=0
JS=0;
else
JS=1;
fi
source ~/.bashrc|true
Z=0
ps -eaf|grep -i tomcat|grep -v grep
Z=$(ps -eaf|grep -i tomcat|grep -v grep|wc -l)
echo $Z
if [ $Z -gt 2 ]; then
    echo " Tomcat is running"
	TS=0
else
    TS=2
fi
#if [ -n "$(echo $CATALINA_HOME)" ]; then
#echo Tomcat is installed under $CATALINA_HOME
#TS=0;
#else
#TS=2;
#fi

let Status=$JS+$TS;
echo $Status

if [ $Status -eq 0 ]
then
echo "Java & Tomcat are already installed"
elif [ $Status -eq 2 ]
then
echo "Java is installed, but not tomcat"
mkdir -p /opt/smarts/Packages/apache-tomcat/
cd /opt/smarts/Packages/
cp -r $1/apache*.tar.gz .
#wget --no-check-certificate --no-cookies http://mirrors.ocf.berkeley.edu/apache/tomcat/tomcat-9/v9.0.0.M20/bin/apache-tomcat-9.0.0.M20.tar.gz -O apache-tomcat.tar.gz
if [ -f ./apache-tomcat*.tar.gz ]
then
echo "Extracting Tomcat installer tarball.......";
sleep 2s;
#sudo tar -xzvf ./apache-tomcat.tar.gz;
sudo tar -xzvf apache-tomcat*.tar.gz --strip-components 1 -C ./apache-tomcat;
echo ""
echo "Tomcat tarball unpacked.";
echo ""
sudo cp -rf ./apache-tomcat/ /opt/smarts/
sudo rm -rf ./apache-tomcat/
echo ""
echo "Setting environment variables......";

CATALINA_HOME=/opt/smarts/apache-tomcat
export CATALINA_HOME

if grep -q "export CATALINA_HOME=.*" $HOME/.bashrc; then
sed -i "s|export CATALINA_HOME=.*|export CATALINA_HOME=$CATALINA_HOME|" $HOME/.bashrc
else
echo "export CATALINA_HOME=$CATALINA_HOME" >> $HOME/.bashrc
fi
source $HOME/.bashrc

[[ ":$PATH:" != *":$CATALINA_HOME/bin:"* ]] && PATH="$CATALINA_HOME/bin:${PATH}"

echo "Variables exported.";
echo $JAVA_HOME;
echo $PATH;
echo $CATALINA_HOME;
sleep 2s;
#java -cp $CATALINA_HOME/lib/catalina.jar org.apache.catalina.util.ServerInfo;
echo "Removing tarballs from PWD.";
#sudo rm -rf ./apache-tomcat*;
else
echo "Installer tarballs not found in packages directory. Please make sure they exist there. Exiting installation process now."
fi

elif [ $Status -eq 3 ]
then
echo "Java & Tomcat are not installed, installing java & Tomcat"
mkdir -p /opt/smarts/Packages/jdk
mkdir -p /opt/smarts/Packages/apache-tomcat/
cd /opt/smarts/Packages/
cp -r $1/jdk*.tar.gz .
cp -r $1/apache*.tar.gz .

#wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8-b132/jdk-8-linux-x64.tar.gz -O jdk.tar.gz
#wget --no-check-certificate --no-cookies https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M1/bin/apache-tomcat-9.0.0.M1-deployer.tar.gz -O apache-tomcat.tar.gz
if [ -f ./jdk*.tar.gz ] && [ ./apache-tomcat*.tar.gz ]
then
echo "Extracting Java installer tarball.......";
sleep 2s
sudo tar -xzvf ./jdk*.tar.gz --strip-components 1 -C ./jdk;
echo ""
echo "Java tarball unpacked.";
echo ""
echo "Extracting Tomcat installer tarball.......";
sleep 2s;
sudo tar -xzvf ./apache-tomcat*.tar.gz --strip-components 1 -C ./apache-tomcat
echo ""
echo "Tomcat tarball unpacked.";
echo ""
echo "Installing Java & Tomcat to /opt/app directory....";
sudo cp -r ./jdk/ /opt/;
sudo cp -r ./apache-tomcat/ /opt/smarts/;
echo ""
echo "Setting environment variables......";
JAVA_HOME=/opt/jdk
JRE_HOME=/opt/jdk/jre
export JAVA_HOME JRE_HOME

if grep -q "export JAVA_HOME=.*" $HOME/.bashrc; then
sed -i "s|export JAVA_HOME=.*|export JAVA_HOME=$JAVA_HOME|" $HOME/.bashrc
else
echo "export JAVA_HOME=$JAVA_HOME" >> $HOME/.bashrc
fi
source $HOME/.bashrc

[[ ":$PATH:" != *":$JAVA_HOME/bin:"* ]] && PATH="$JAVA_HOME/bin:${PATH}"

# Update system to use Java by default
echo -n "Updating system alternatives... "
update-alternatives --install "/usr/bin/java" "java" "$JAVA_HOME/jre/bin/java" 1 >> /dev/null
update-alternatives --install "/usr/bin/javac" "javac" "$JAVA_HOME/bin/javac" 1 >> /dev/null
update-alternatives --set java $JAVA_HOME/jre/bin/java >> /dev/null
update-alternatives --set javac $JAVA_HOME/bin/javac >> /dev/null
echo "OK"

CATALINA_HOME=/opt/smarts/apache-tomcat
export CATALINA_HOME
    
if grep -q "export CATALINA_HOME=.*" $HOME/.bashrc; then
sed -i "s|export CATALINA_HOME=.*|export CATALINA_HOME=$CATALINA_HOME|" $HOME/.bashrc
else
echo "export CATALINA_HOME=$CATALINA_HOME" >> $HOME/.bashrc
fi
source $HOME/.bashrc

[[ ":$PATH:" != *":$CATALINA_HOME/bin:"* ]] && PATH="$CATALINA_HOME/bin:${PATH}"

echo "Variables exported.";
echo $JAVA_HOME;
echo $PATH;
echo $CATALINA_HOME;
sleep 2s;
echo "Checking Java & Tomcat versions.";
echo "Java is installed at `which java` Directory";
java -version;
echo ""
java -cp $CATALINA_HOME/lib/catalina.jar org.apache.catalina.util.ServerInfo;
echo ""
else
echo "Installer tarballs not found in packages directory. Please make sure they exist there. Exiting installation process now."
fi

elif [ $Status -eq 1 ]
then
echo "JAVA_HOME environment variable is not identified, setting it"
mkdir -p /opt/smarts/Packages/jdk
cd /opt/smarts/Packages/
cp -r $1/jdk*.tar.gz .

if [ -f ./jdk*.tar.gz ]
then
echo "Extracting Java installer tarball.......";
sleep 2s
sudo tar -xzvf ./jdk*.tar.gz --strip-components 1 -C ./jdk;
echo ""
echo "Java tarball unpacked.";
echo ""
echo "Installing Java to /opt/jdk directory....";
sudo cp -r ./jdk/ /opt/;
echo ""
echo "Setting environment variables......";
JAVA_HOME=/opt/jdk
JRE_HOME=/opt/jdk/jre
export JAVA_HOME JRE_HOME

if grep -q "export JAVA_HOME=.*" $HOME/.bashrc; then
sed -i "s|export JAVA_HOME=.*|export JAVA_HOME=$JAVA_HOME|" $HOME/.bashrc
else
echo "export JAVA_HOME=$JAVA_HOME" >> $HOME/.bashrc
fi
source $HOME/.bashrc

[[ ":$PATH:" != *":$JAVA_HOME/bin:"* ]] && PATH="$JAVA_HOME/bin:${PATH}"

# Update system to use Java by default
echo -n "Updating system alternatives... "
update-alternatives --install "/usr/bin/java" "java" "$JAVA_HOME/jre/bin/java" 1 >> /dev/null
update-alternatives --install "/usr/bin/javac" "javac" "$JAVA_HOME/bin/javac" 1 >> /dev/null
update-alternatives --set java $JAVA_HOME/jre/bin/java >> /dev/null
update-alternatives --set javac $JAVA_HOME/bin/javac >> /dev/null
echo "OK"
else
echo "Installer tarballs not found in packages directory. Please make sure they exist there. Exiting installation process now."
fi

else
echo "something wrong with script"
fi 

if [ ! -f $CATALINA_HOME/bin/startup.sh ]; then
echo "tomcat home directory is corrupted, reinstalling tomcat"
mkdir -p /opt/smarts/Packages/apache-tomcat/
cd /opt/smarts/Packages/
cp -r $1/apache*.tar.gz .
if [ -f ./apache-tomcat*.tar.gz ]
then
echo "Extracting Tomcat installer tarball.......";
sleep 2s;
sudo tar -xzvf apache-tomcat*.tar.gz --strip-components 1 -C ./apache-tomcat;
echo ""
echo "Tomcat tarball unpacked.";
echo ""
sudo cp -rf ./apache-tomcat/ /opt/smarts/
sudo rm -rf ./apache-tomcat/
echo ""
echo "Setting environment variables......";

CATALINA_HOME=/opt/smarts/apache-tomcat
export CATALINA_HOME

if grep -q "export CATALINA_HOME=.*" $HOME/.bashrc; then
sed -i "s|export CATALINA_HOME=.*|export CATALINA_HOME=$CATALINA_HOME|" $HOME/.bashrc
else
echo "export CATALINA_HOME=$CATALINA_HOME" >> $HOME/.bashrc
fi
source $HOME/.bashrc

[[ ":$PATH:" != *":$CATALINA_HOME/bin:"* ]] && PATH="$CATALINA_HOME/bin:${PATH}"

echo "Variables exported.";
echo $CATALINA_HOME;
sleep 2s;
echo ""
else
echo "Installer tarballs not found in packages directory. Please make sure they exist there. Exiting installation process now."
exit
fi
fi 
