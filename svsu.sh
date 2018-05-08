#!/bin/bash


#read -p "enter app hostname:" host;
host="rdama-app"
tag=".ktpn"
read -p "enter username for $host:" user;
read -sp "enter password for $user:" pw;
echo

port=8084;
EMAILLISTFILE=$PWD/emails.lst

eval "URL=http://$host$tag:$port/app";
echo "url is $URL"
RC=`curl -s -o /dev/null -w "%{http_code}" $URL`;

config_file='/opt/rdama/svsu/tool_info.ini'
#echo return code is: $RC

get_activeversion(){
#echo $(curl -H "Accept: application/json" $URL/version --stderr - |grep -i '"version":'|sed s/\"//g | sed s/\:\ /=/g)
AV=$(curl -H "Accept: application/json" $URL/version --stderr - |grep -i '"version":'|awk 'NF{print $2}'|sed s/\"//g)
echo "Active Version is: $AV"
#echo "Active Version is: $AV" | awk -F'\n' '{print $1}'
}

run_over_ssh(){
  ssh $user@$host "$@"
}

list_installed(){
readarray -t services < <(run_over_ssh "find /opt/rdama/ -maxdepth 2 -name "sts_webserver.sh" -exec dirname {} \;")
echo
echo "select the service to activate:"
select svc in "${services[@]}"; do
echo "service selected is $svc"
base=`basename $svc`
echo "selected version is $base"
        break;
        done
}


get_response(){
response=$(curl -L --write-out %{http_code} --silent --output /dev/null $URL)

if [ "$response" = "200" ] ; then
{
    echo " website $URL is working"
    echo -n "$response "; echo -e "\e[32m[ok]\e[0m"
        while read e; do
            echo "$URL WEBSITE IS UP & RUNNING" | mailx -s $URL $e
        done < $EMAILLISTFILE
} else
        while read e; do
            echo "$URL WEBSITE DOWN" | mailx -s $URL $e
        done < $EMAILLISTFILE
  fi
}


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
set -x
#curl -i \
#-H "Accept: application/json" \
#-H "Content-Type: application/json" \
#"$URL/service/shutdown"

curl -i -v \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data "$(generate_jsondata)" "$URL/shutdown"
while read e; do
echo "$URL is scheduled for $mode shutdown and is going down in $mwt seconds, expected downtime is $edt" | mailx -s $URL $e
done < $EMAILLISTFILE
#response=$(curl -L --write-out %{http_code} --silent --output /dev/null $URL)
until [ "$(curl -L --write-out %{http_code} --silent --output /dev/null $URL)" -eq "000" ]; do
echo "service still running"
sleep $mwt
done
}

activate_service(){
SCRIPT_PATH="$svc/app-$base-$port-service.sh"
run_over_ssh << EOF
cd $svc;
bash $SCRIPT_PATH start;
EOF
}

echo "List Active Versions"
get_activeversion
echo "List Installed Versions"
list_installed

if [ ! -z "$AV" ]; then
{
echo "Get the required data to post to shutdown API"
get_postdata
shutdown_service
}
else
echo "No Active Versions"
fi

echo "Activating the services"
activate_service
echo service activation return code is $?
sleep 10
echo "get the response from API"
get_response

if [ $response -eq "200" ]
then
#echo "Service is Active"
echo "Active version result and mail"
get_activeversion
else
echo " No Services in Active state"
fi




#printf json data for posting it to API is \n $(generate_post_data)

<<"comments"
echo "Activating the version $svc"
ssh $user@$host << EOF
    $(typeset -f activate_service)
    activate_service
EOF
comments
#curl -v --silent http://rdama-demo:8083/app/version --stderr - |grep -i \"version\"\:
