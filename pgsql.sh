# Run the script usinf ./pgsql.sh $password

#!/bin/bash
export PATH=/bin:/usr/bin:/sbin:/usr/sbin

function print_info {
        echo -n -e '\e[1;36m'
        echo -n $1
        echo -e '\e[0m'
}

function print_warn {
        echo -n -e '\e[1;33m'
        echo -n $1
        echo -e '\e[0m'
}

function check_install {
        if [ -z "`which "$1" 2>/dev/null`" ]
        then
                executable=$1
                shift
                while [ -n "$1" ]
                do
                        DEBIAN_FRONTEND=noninteractive apt-get -q -y install "$1"
                        print_info "$1 installed for $executable"
                        shift
                done
        else
                print_warn "$2 already installed"
        fi
}
check_install postgresql postgresql
sudo service postgresql start
sudo -u postgres psql -c"ALTER user postgres WITH PASSWORD '$1'"
sudo service postgresql restart
