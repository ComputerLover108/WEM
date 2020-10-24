#!/bin/bash
# VERSION=""
# PGDATA=""
# PGPASSWORD=""
#PGBACKUP=/home/postgres/pgdata/backup
TIMEOUT=3
PGHOST=localhost
PGPORT=5432
PGUSER=postgres
DATABASE=postgres
while getopts v:d:w option ; do
	case $option in
		v)
		VERSION=$OPTARG
		PGHOME=/opt/pgsql$VERSION
		;;		
		d)
		PGDATA=$OPTARG/$VERSION/MasterPG/data
		;;
		w)
		PGPASSWORD=$OPTARG
		;;
	esac
done

if [ ! $PGPASSWORD ] ; then
	PGPASSWORD=pgpassword
fi

export PATH=$PGHOME/bin:$PATH
export LD_LIBRARY_PATH=$PGHOME/lib:$LD_LIBRARY_PATH

pg_ctl -D  $PGDATA stop
rm -rf $PGDATA
initdb -E UTF8  --pwfile=$PGPASSWORD -D $PGDATA
pg_ctl -D  $PGDATA start 
sleep $TIMEOUT
psql -f initHLD.sql -d $DATABASE
pg_ctl -D $PGDATA stop 
sleep $TIMEOUT
cp -v $PGDATA/pg_hba.conf $PGDATA/pg_hba.bak
cp -v $PGDATA/postgresql.conf $PGDATA/postgresql.bak
cat pg_hba.conf >> $PGDATA/pg_hba.conf
cp -v postgresql.conf $PGDATA
cp -v pgpass.conf ~/.pgpass && chmod 0600 ~/.pgpass
# pg_ctl -D $PGDATA start
