#!/bin/sh
VERSION=9.6
PGHOME=/opt/pgsql$VERSION
PGDATA=/home/postgres/pgdata/$VERSION/MasterPG/data
#PGPASSWORD=pgpassword
#PGPASSFILE=pgpass.conf
#PGBACKUP=/home/postgres/pgdata/backup
#PGHOST=localhost
#PGPORT=5432
PGUSER=postgres
DATABASE=postgres
export PATH=$PGHOME/bin:$PATH:.
pg_ctl -D  $PGDATA stop
rm -rf $PGDATA
#initdb -E UTF8 --locale=C  --pwfile=$PGPASSWORD -D $PGDATA 
initdb -E UTF8 -D $PGDATA 
pg_ctl -D  $PGDATA start 
#psql -h $PGHOST -p $PGPORT -U $PGUSER -f initHLD.sql $DATABASE
sleep 9
psql -f initHLD.sql  
pg_ctl -D $PGDATA stop 
sleep 9
cp -v pg_hba.conf postgresql.conf $PGDATA/
cp -v pgpass.conf ~/.pgpass && chmod 0600 ~/.pgpass
pg_ctl -D $PGDATA start
