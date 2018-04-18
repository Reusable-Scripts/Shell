#!/bin/bash

host="810"
domain="sj"
user="rdama"
pw="Passw0rd"


<< comments
get_installedversions(){
array=( $(net rpc service list -I $host -U $domain/$user%$pw | grep -i SQL) )
len=${#array[*]}
echo "The array has length $len members. They are:"

i=0
while [ $i -lt $len ]; do
    echo "$i: ${array[$i]}"
    declare -a "var$i=${array[$i]}"
    let i++
done
echo -n "Enter the service to be activated: "
    read version
}
get_installedversions
echo selected service is ${array[$version]}

comments

run_net_rpc() {
  net rpc "$@" -I "$host" -U "$domain/$user%$pw"
}

readarray -t services < <(run_net_rpc service list | grep -i Rpc)
select svc in "${services[@]}"; do
  run_net_rpc activate service "$svc"
  break
done
