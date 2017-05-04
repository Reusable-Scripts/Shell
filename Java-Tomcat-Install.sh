#Apache Tomcat Installer Script
#Checking if installer tarballs are present or not. If they are not found, script will print error message & quit.
if [ -f /home/rdama/jdk-8u25-linux-x64.tar.gz ] && [ -f /home/rdama/apache-tomcat-8.0.15.tar.gz ]
then
echo "Extracting Java installer tarball.......";
sleep 2s
sudo tar -xzvf /home/rdama/jdk-8u25-linux-x64.tar.gz;
echo ""
echo "Java tarball unpacked.";
echo ""
echo "Extracting Tomcat installer tarball.......";
sleep 2s;
sudo tar -xzvf /home/rdama/apache-tomcat-8.0.15.tar.gz;
echo ""
echo "Tomcat tarball unpacked.";
echo ""
echo "Installing Java & Tomcat to /opt/app directory....";
sudo cp -rp /home/rdama/jdk1.8.0_25 /opt/app;
sudo cp -rp /home/rdama/apache-tomcat-8.0.15 /opt/app;
echo ""
echo "Setting environment variables......";
export JAVA_HOME=/opt/app/jdk1.8.0_25;
export PATH=$PATH:/opt/app/jdk1.8.0_25/bin:$PATH;
export CATALINA_HOME=/opt/app/apache-tomcat-8.0.15;
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
echo "Starting Tomcat server"
cd $CATALINA_HOME/bin
./startup.sh
echo "Removing tarballs from PWD.";
sudo rm -rf /home/rdama/jdk1.8.0_25;
sudo rm -rf /home/rdama/apache-tomcat-8.0.15;
else
echo "Installer tarballs not found in /home/rdama. Please make sure they exist there. Exiting installation process now."
exit
fi
# to change the port number
# sed -i 's/port="8080"/port="8880"/' $CATALINA_HOME/Conf/server.xml
#sed -i 's/port="8080"/port="8880"/g' $CATALINA_HOME/Conf/server.xml
