#!/bin/bash

host="810"
domain="sj"
user="rdama"
pw="Passw0rd"


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
