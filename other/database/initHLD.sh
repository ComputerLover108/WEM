#!/bin/sh
PGHOME=/opt/pgsql9.6/pgsql
PGDATA=/home/postgres/pgdata/9.6/MasterPG/data
#PGPASSWORD=pgpassword
PGPASSFILE=pgpass.conf
PGBACKUP=/home/postgres/pgdata/backup
HOST=127.0.0.1
PORT=5432
USER=postgres
DATABASE=postgres
export PATH=$PGHOME/bin:$PATH:.
pg_ctl -D  $PGDATA stop
rm -rf $PGDATA
#initdb -E UTF8 --locale=C  --pwfile=$PGPASSWORD -D $PGDATA 
initdb -E UTF8 -D $PGDATA 
pg_ctl -D  $PGDATA -l initHLD.log start 
psql -h $HOST -p $PORT -U $USER -f initHLD.sql $DATABASE

sleep 3

psql -f initHLD.sql  
pg_ctl -D $PGDATA stop 
sleep 3
cp -v pg_hba.conf postgresql.conf pgpass.conf $PGDATA/
pg_ctl -D $PGDATA start
