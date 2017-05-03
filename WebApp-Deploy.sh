#!/bin/bash
<<'COMMENTS'
# To run this script alone you need 2 parameters param1 is /appdirectory/version and param2 is version command to run sh ./scriptname.sh param1 param2
COMMENTS
echo "Application Directory is: $1"
echo "Version Number is: $2"
if [ -n "$(echo $CATALINA_HOME)"]; then
{
echo "Tomcat is not installed in this machine"
} else {
echo Tomcat is installed under $CATALINA_HOME
cd $1
cp -r $1/APP1/*.war $CATALINA_HOME/webapps
echo "War Deployed"
echo "Check if tomcat is already running, if so, restart Tomcat"
if ((ps -ef | grep tomcat| grep -v grep |wc -l) > 0 ); then
{
echo "Tomcat is already running, Restarting Tomcat"
sh $CATALINA_HOME/bin/shutdown.sh
pid = $(ps -eaf | grep tomcat| grep -v grep | awk '{print $2}')
kill -9 $pid
echo "tomcat stopped"
sh $CATALINA_HOME/bin/startup.sh
} else {
echo "Tomcat is not running, Starting tomcat"
sh $CATALINA_HOME/bin/startup.sh
}
fi
exit $?
}
fi
