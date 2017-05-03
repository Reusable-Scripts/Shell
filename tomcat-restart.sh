#!/bin/bash
# description: Script to Start Stop Restart Tomcat
JAVA_HOME=/usr/java/default
export JAVA_HOME
PATH=$JAVA_HOME/bin:$PATH
export PATH
TOMCAT_HOME=/opt/tomcat/bin
JAVA_OPTS="-Xms2048m -Xmx8192m -XX:MaxPermSize=512m
export JAVA_OPTS
case $1 in
start)
/bin/su -p -s /bin/sh tomcat $TOMCAT_HOME/startup.sh
;;
stop)

/bin/su -p -s /bin/sh tomcat $TOMCAT_HOME/shutdown.sh
;;
restart)
/bin/su -p -s /bin/sh tomcat $TOMCAT_HOME/shutdown.sh
/bin/su -p -s /bin/sh tomcat $TOMCAT_HOME/startup.sh
;;
esac
exit 0


<<'COMMENTS'
we need to set the JAVA_HOME & TOMCAT_HOME path according to our configurations. 
For example, in the above script, JAVA_HOME is /usr/java/default And TOMCAT_HOME is /opt/tomcat/bin

Save the tomcat-8.sh file in the /etc/init.d/ directory
#cp tomcat.sh /etc/init.d/
#chmod +x tomcat.sh
# ./tomcat.sh start
# ./tomcat.sh stop
# ./tomcat.sh resrart
COMMENTS
