#!/bin/bash


#read -p "enter SDS hostname:" host;
host="rdama-app"
read -p "enter username for $host:" user;
read -sp "enter password for $user:" pw;
echo

port=8084;

eval "URL=http://$host:$port/app";
RC=`curl -s -o /dev/null -w "%{http_code}" $URL`;
version='1.0.7A';
config_file='/opt/rdama/svsu/tool_info.ini'
#echo return code is: $RC

get_activeversion(){
AV=$(curl -H "Accept: application/json" $URL/version --stderr - |grep -Po '"version":.*?[^\\]",'|cut -d ':' -f 2|tr -d \"\,);
echo "Active Version is: $AV" | column -s":" -t
#echo "Active Version is: $AV" | awk -F'\n' '{print $1}'
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

shutdown_service(){

#curl -i \
#-H "Accept: application/json" \
#-H "Content-Type: application/json" \
#"$URL/service/shutdown"

curl -i \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data "$(generate_post_data)" "$URL/shutdown"
}

get_activeversion
get_userinput
printf json data for posting it to API is \n $(generate_post_data)
shutdown_service

activate_service(){

run_over_ssh(){
  ssh $user@$host "$@"
}

readarray -t services < <(run_over_ssh "find /opt/rdama/ -maxdepth 2 -name "app_webserver.sh" -exec dirname {} \;")
echo "select the service to activate:"
select svc in "${services[@]}"; do
echo "service selected is $svc"
base=`basename $svc`
#expect -c "spawn ssh $user@$host "sh /opt/rdama/SDS/SDS-$version-SERVICE.sh start";expect "assword:";send "$pw";interact"
run_over_ssh "sh $svc/app-$base-$port-service.sh start"
 break
done
}

activate_service

<<"comments"
echo "Activating the version $svc"
ssh $user@$host << EOF
    $(typeset -f activate_service)
    activate_service
EOF
comments
#curl -v --silent http://rdama-demo:8083/sots/version --stderr - |grep -i \"version\"\:
