#!/bin/bash


read -p "enter tool hostname:" host
read -p "enter $host username:" user
read -p "enter $user domain:" domain
read -sp "enter $user password:" pw
echo


URL="http://$host:8083/app"
RC=`curl -s -o /dev/null -w "%{http_code}" $URL`
version='1.0.6AA'
config_file='/opt/rdama/svsu/tool_info.ini'
#echo return code is: $RC

get_activeversion(){
AV=$(curl -v --silent "$URL/version" --stderr - |grep -Po '"version":.*?[^\\]",'|cut -d ':' -f 2|tr -d \"\,)
AV=`echo $AV | column -s":" -t`
echo "Active Version is: $AV"
#echo "Active Version is: $AV" | awk -F'\n' '{print $1}'
}

get_activeversion

get_postdata(){
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
get_postdata

generate_jsondata(){
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
-X POST --data "$(generate_jsondata)" "$URL/service/shutdown"
}

shutdown_service


activate_service(){

run_net_rpc() {
  net rpc "$@" -I "$host" -U "$domain/$user%$pw"
}

readarray -t services < <(run_net_rpc service list | grep -i app)
echo "select the service to activate:"
select svc in "${services[@]}"; do
echo "service selected is $svc"
service_name=`echo $svc|awk '{print $1;}'`
echo "service selected is $service_name"
run_net_rpc service start "$service_name"
  break
done

}

activate_service
echo service activation return code is %ERRORLEVEL%

if [ $RC==200 ]
then
#echo "Service is Active"
get_activeversion
else
echo " No Services in Active state"
fi

#printf json data for posting it to API is \n $(generate_post_data)

#curl -v --silent http://rdama-demo:8083/app/version --stderr - |grep -i \"version\"\:
