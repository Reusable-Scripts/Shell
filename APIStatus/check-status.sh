#!/bin/bash
# list of websites. 
LISTFILE=$PWD/websites.lst
# Send mail to. 
EMAILLISTFILE=$PWD/emails.lst

get_response(){
response=$(curl -L --write-out %{http_code} --silent --output /dev/null $1)

if [ "$response" = "200" ] ; then
{
    echo " website $1 is working"
    echo -n "$response "; echo -e "\e[32m[ok]\e[0m"
        while read e; do
            # using mailx command
            echo "$p WEBSITE IS UP & RUNNING" | mailx -s $p $e
            # using mail command
            #mail -s "$p WEBSITE IS UP" "$EMAIL"
        done < $EMAILLISTFILE
} else
        while read e; do
            # using mailx command
            echo "$p WEBSITE DOWN" | mailx -s $p $e
            # using mail command
            #mail -s "$p WEBSITE DOWN" "$EMAIL"
        done < $EMAILLISTFILE
  fi
}

while read p; do
  get_response $p
done < $LISTFILE
