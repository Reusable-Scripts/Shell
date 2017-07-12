#!/usr/bin/expect -f
#  ./ssh.exp password 192.168.1.11 id
set pass [lrange $argv 0 0]
set server [lrange $argv 1 1]
set name [lrange $argv 2 2]

spawn ssh $name@$server
match_max 100000
expect "*?assword:*"
send -- "$pass\r"
send -- "\r"
interact
