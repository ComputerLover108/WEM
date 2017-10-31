#!/bin/sh
VERSION=10.0
PGHOME=/opt/pgsql$VERSION
PGDATA=/home/postgres/pgdata/$VERSION/MasterPG/data
PGPASSWORD=pgpassword
#PGPASSFILE=pgpass.conf
#PGBACKUP=/home/postgres/pgdata/backup
PGHOST=localhost
PGPORT=5432
PGUSER=postgres
PGADMINISTRATOR=ComputerLover
DATABASE=postgres

export PATH=$PGHOME/bin:$PATH
export LD_LIBRARY_PATH=$PGHOME/lib:$LD_LIBRARY_PATH

pg_ctl -D  $PGDATA stop
rm -rf $PGDATA
initdb -E UTF8   -U $PGADMINISTRATOR --pwfile=$PGPASSWORD -D $PGDATA
sed -i 's/#password_encryption = md5/password_encryption = scram-sha-256/' $PGDATA/postgresql.conf
pg_ctl -D  $PGDATA start 
sleep 9
psql -U $PGADMINISTRATOR -f initHLD.sql  -d $DATABASE 
pg_ctl -D $PGDATA stop 
sleep 9
cp -v pg_hba.conf postgresql.conf $PGDATA/
cp -v pgpass.conf ~/.pgpass && chmod 0600 ~/.pgpass
pg_ctl -D $PGDATA start
