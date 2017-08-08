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


                                            OR


cu=`whoami`

# Genarate SSH Keys for authentication
mkdir -p /home/$cu/.ssh/
ssh-keygen -f /home/$cu/.ssh/id_rsa -t rsa -N ''
# Add Public Key to authorized keys
# ssh-copy-id -i /home/$cu/.ssh/id_rsa.pub $Linux_User@$Linux_Machine
cat /home/$cu/.ssh/id_rsa.pub | ssh USER@HOST "mkdir -p /home/$Linux_User/.ssh && sudo cat >> /home/$Linux_User/.ssh/authorized_keys"
ssh -i /home/$cu/.ssh/id_rsa $Linux_User@$Linux_Machine << EOF
pwd
ls -la
EOF


                                            OR


sshpass -p $Linux_PW ssh $Linux_User@$Linux_Machine -p $PORT_NO source $HOME/.bashrc >> ./logs/$APP_NAME-$APP_VERSION.log 2>>&1

scp -vCq -i private_key.pem ~/test.txt root@192.168.1.3:/some/path/test.txt
scp -vC -F /home/user/my_ssh_config ~/test.txt root@192.168.1.3:/some/path/test.txt
scp -vC -F /home/user/id_rsa.pub ~/test.txt root@192.168.1.3:/some/path/test.txt
scp -i /home/$cu/.ssh/id_rsa -P $PORT_NO -r ./Scripts/ $Linux_Machine:${Target_Dir}/


openssl rsa -in /home/$cu/.ssh/id_rsa -outform pem > /home/$cu/.ssh/id_rsa.pem
chmod 700 /home/$cu/.ssh/id_rsa.pem


setting ssh authorized_keys seem to be simple but hides some traps I'm trying to figure

-- SERVER --

in /etc/ssh/sshd_config set  passwordAuthentication yes to let server temporary accept password authentication

-- CLIENT --

consider cygwin as linux emulation and install & run openssh
1. generate private and public keys (client side) # ssh-keygen

here pressing just ENTER you get DEFAULT 2 files "id_rsa" and "id_rsa.pub" in ~/.ssh/ but if you give a name_for_the_key the generated files are saved in your pwd

2. place the your_key.pub to target machine ssh-copy-id user_name@host_name

if you didn't create default key this is the first step to go wrong ... you should use

ssh-copy-id -i path/to/key_name.pub user_name@host_name

3. logging ssh user_name@host_name will work only for default id_rsa so here is 2nd trap for you need to ssh -i path/to/key_name user@host

(use ssh -v ... option to see what is happening)

If server still asks for password then you gave smth. to Enter passphrase: when you've created keys ( so it's normal)

if ssh is not listening default port 22 must use ssh -p port_nr

-- SERVER -----

4. modify /etc/ssh/sshd_config to have

RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile  %h/.ssh/authorized_keys
(uncoment if case)

This tells ssh to accept authorized_keys and look in user home directory for key_name sting written in .ssh/authorized_keys file

5 set permissions in target machine

chmod 755 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
Also turn off pass auth

passwordAuthentication no

to close the gate to all ssh root/admin/....@your_domain attempts

6 ensure ownership and group ownership of all non-root home directories are appropriate.

chown -R ~ usernamehere
chgrp -R ~/.ssh/ user 
