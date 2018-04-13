#!/bin/bash


read -p "enter tool hostname:" host
read -p "enter tool username:" user
read -p "enter tool domain:" domain
read -sp "enter tool password:" pw
URL='http://hostname:8083/sots'


RC=`curl -s -o /dev/null -w "%{http_code}" $URL`
version='1.0.6AB'
config_file='/opt/smarts/svsu/tool_info.ini'
#echo return code is: $RC

get_activeversion(){
AV=$(curl -v --silent $URL/version --stderr - |grep -Po '"version":.*?[^\\]",'|cut -d ':' -f 2|tr -d \"\,)
echo "Active Version is: $AV" | column -s":" -t
#echo "Active Version is: $AV" | awk -F'\n' '{print $1}'

<<'comments'
echo "<html><head></head><body>"
echo "<table border=1>"
echo "<tr><td>Location</td><td>$AV</td></tr>"
echo "</table>"
echo "</body></html>"
comments

}

get_installedversions(){
net rpc service list -I $host -U $domain/$user%$pw | grep -i sots
IV=$1
echo Installed version is $IV
}

get_userinput(){
echo "select the mode?"
select ncf in "now" "clean" "full"; do
    case $ncf in
        now ) mode=now; break;;
        clean ) mode=clean break ;;
        full ) mode=full; break;;
    esac
done

read -p "enter minwait time in seconds:" mwt
read -p "reason for shutdown: " reason
read -p "expected downtime in seconds: " edt
}

shutdown_service(){

#curl -i \
#-H "Accept: application/json" \
#-H "Content-Type: application/json" \
#"$URL/service/shutdown"

curl -i \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data "$(generate_post_data)" "$URL/service/shutdown"
}

generate_post_data(){
cat <<EOF
{
        "mode": "$mode",
        "minwait": $mwt,
        "reason": "$reason",
        "downtime": $edt
}
EOF
}


activate_service(){

net rpc service start $IV -I $host -U $domain/$user%$pw
net rpc service status $IV -I $host -U $domain/$user%$pw
}

get_activeversion
get_installedversions '1.0.8A'

get_userinput

printf json data for posting it to API is \n $(generate_post_data)


echo mode is $mode
echo min wait time is $mwt
echo reason for shutdown is $reason
echo expected downtime is $edt


shutdown_service $version
#activate_service $version

if [ $RC==200 ]
then
#echo "Service is Active"
get_activeversion
else
echo " No Services in Active state"
fi




#curl -v --silent http://smarts-demo:8083/sots/version --stderr - |grep -i \"version\"\:
