#!/bin/bash
VERSION=""
# PGHOME=/opt/pgsql$VERSION
PGDATA=""
PGPASSWORD=""
#PGBACKUP=/home/postgres/pgdata/backup
PGHOST=localhost
PGPORT=5432
PGUSER=postgres
PGADMINISTRATOR=""
DATABASE=postgres
while getopts v:d:u:w option ; do
	case $option in
		v)
		VERSION=$OPTARG
		;;		
		d)
		PGDATA=$OPTARG/$VERSION/MasterPG/
		;;
		u)
		PGADMINISTRATOR=$OPTARG
		;;
		w)
		PGPASSWORD=$OPTARG
		;;
	esac
done

if [ ! $PGADMINSTRATOR ]; then
	PGADMINISTRATOR=ComputerLover
fi

if [ ! $PGPASSWORD ] ; then
	PGPASSWORD=pgpassword
fi
export PATH=$PGHOME/bin:$PATH
export LD_LIBRARY_PATH=$PGHOME/lib:$LD_LIBRARY_PATH

pg_ctl -D  $PGDATA stop
rm -rf $PGDATA
initdb -E UTF8   -U $PGADMINISTRATOR --pwfile=$PGPASSWORD -D $PGDATA
pg_ctl -D  $PGDATA start 
sleep 9
psql -U $PGADMINISTRATOR -f initHLD.sql  -d $DATABASE 
pg_ctl -D $PGDATA stop 
sleep 9
cp -v pg_hba.conf postgresql.conf $PGDATA/
cp -v pgpass.conf ~/.pgpass && chmod 0600 ~/.pgpass
pg_ctl -D $PGDATA start
