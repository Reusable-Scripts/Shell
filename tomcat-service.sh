#!/bin/bash
#
# description: Apache Tomcat init script
# processname: tomcat  
# chkconfig: 234 20 80  
#

echo  ==================================================================
echo   ______                           __    
echo  /_  __/___  ____ ___  _________ _/ /_   
echo   / / / __ \/ __ `__ \/ ___/ __ `/ __/   
echo  / / / /_/ / / / / / / /__/ /_/ / /_     
echo /_/  \____/_/ /_/ /_/\___/\__,_/\__/     

 
 
#CATALINA_HOME is the location of the bin files of Tomcat  
export CATALINA_HOME=/opt/smarts/apache-tomcat
 
#CATALINA_BASE is the location of the configuration files of this instance of Tomcat
export CATALINA_BASE=/opt/smarts/apache-tomcat/Instances/$1-tomcat/$2
 
#TOMCAT_USAGE is the message if this script is called without any options
TOMCAT_USAGE="Usage: $0 {\e[00;32mstart\e[00m|\e[00;31mstop\e[00m|\e[00;31mkill\e[00m|\e[00;32mstatus\e[00m|\e[00;31mrestart\e[00m}"
 
#SHUTDOWN_WAIT is wait time in seconds for java proccess to stop
SHUTDOWN_WAIT=20
 
tomcat_pid() {
        echo `ps -fe | grep $CATALINA_BASE | grep -v grep | tr -s " "|cut -d" " -f2`
}
 
start() {
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
    echo -e "\e[00;31mTomcat is already running (pid: $pid)\e[00m"
  else
    # Start tomcat
    echo -e "\e[00;32mStarting tomcat\e[00m"
    #ulimit -n 100000
    #umask 007
    sh $CATALINA_HOME/bin/startup.sh
    status
  fi
  return 0
}
 
status(){
          pid=$(tomcat_pid)
          if [ -n "$pid" ]
            then echo -e "\e[00;32mTomcat is running with pid: $pid\e[00m"
          else
            echo -e "\e[00;31mTomcat is not running\e[00m"
            return 3
          fi
}

terminate() {
	echo -e "\e[00;31mTerminating Tomcat\e[00m"
	kill -9 $(tomcat_pid)
}

stop() {
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
    echo -e "\e[00;31mStoping Tomcat\e[00m"
    sh $CATALINA_HOME/bin/shutdown.sh
 
    let kwait=$SHUTDOWN_WAIT
    count=0;
    until [ `ps -p $pid | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
    do
      echo -n -e "\n\e[00;31mwaiting for processes to exit\e[00m";
      sleep 1
      let count=$count+1;
    done
 
    if [ $count -gt $kwait ]; then
      echo -n -e "\n\e[00;31mkilling processes didn't stop after $SHUTDOWN_WAIT seconds\e[00m"
      terminate
    fi
  else
    echo -e "\e[00;31mTomcat is not running\e[00m"
  fi
 
  return 0
}
 

case $1 in
	start)
	  start
	;;
	stop)  
	  stop
	;;
	restart)
	  stop
	  start
	;;
	status)
		status
		exit $?  
	;;
	kill)
		terminate
	;;		
	*)
		echo -e $TOMCAT_USAGE
	;;
esac    


echo   
echo   ______                           __    
echo  /_  __/___  ____ ___  _________ _/ /_   
echo   / / / __ \/ __ `__ \/ ___/ __ `/ __/   
echo  / / / /_/ / / / / / / /__/ /_/ / /_     
echo /_/  \____/_/ /_/ /_/\___/\__,_/\__/     
 
echo  ==================================================================
exit 0
