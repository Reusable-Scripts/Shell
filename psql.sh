#!/bin/bash
tar -zxvf $1/postgresql-*.tar.gz --strip-components 1 -C /opt/psql;
cd /opt/psql
./configure
gmake
gmake install
useradd postgres
mkdir /opt/psql/data
chown postgres /opt/psql/data
su - postgres
/opt/psql/bin/initdb -D /opt/psql/data
/opt/psql/bin/postmaster -i -D /opt/psql/data >logfile 2>&1 &
