#!/bin/bash

HOST='foo.com'
USER='us3r'
PASSWD='p4ssword'

ftp -i -n $HOST <<EOF
user ${USER} ${PASSWD}

binary
cd /home/rdama/backup
put test1.pdf
get test2.ps

quit
EOF
