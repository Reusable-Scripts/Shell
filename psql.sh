#!/bin/bash
#tar -zxvf $1/postgresql-*.tar.gz --strip-components 1 -C /opt/psql;
mkdir -p /opt/pgsql/data
tar -zxvf ./../Packages/postgresql-*.tar.gz --strip-components 1 -C /opt/pgsql;
cd /opt/pgsql
#./configure
#make
#make install
#useradd postgres||true
set -xe
id -u postgres &>/dev/null || useradd postgres
chown -R postgres /opt/pgsql/data
su - postgres <<-'EOF'
/opt/pgsql/bin/initdb -D /opt/pgsql/data
/opt/pgsql/bin/postmaster -i -D /opt/pgsql/data >logfile 2>&1 &
/opt/pgsql/bin/createdb test
EOF
