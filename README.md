# Shell

==================TOMCAT PORT CONFIGURATION THROUGH COMMAND LINE===================
Change your server.xml so that it will use port numbers expanded from properties instead of hardcoded ones:

<Server port="${port.shutdown}" shutdown="SHUTDOWN">
...
  <Connector port="${port.http}" protocol="HTTP/1.1"/>
...
</Server>
Here's how you can start in Linux (assuming your current directory is CATALINA_HOME):

 JAVA_OPTS="-Dport.shutdown=8005 -Dport.http=8080" bin/startup.sh
In windows it should be something like following: 
set "JAVA_OPTS=-Dport.shutdown=8005 -Dport.http=8080"
bin\startup.bat

==================================================================================


if net rpc has errors, run the below command on windows 

net stop LanmanServer /y && net start LanmanServer

==================================================================================

