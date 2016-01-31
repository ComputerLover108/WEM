rem chcp 65001 'UTF8'
rem chcp 936 'chinese'
set PGHOME=d:\public\portable\x64\database\pgsql
set PGDATA=e:\public\database\MasterPG\data
set PGBACKUP=e:\public\database
set path=%PGHOME%\bin;%path%;
pg_ctl -D  %PGDATA% stop
rmdir /q /s %PGDATA% 
initdb -U ComputerLover -E UTF8 --no-locale -D %PGDATA%
pg_ctl -D  %PGDATA% start

createdb  -U ComputerLover -E UTF8 HLD
psql -d HLD -U ComputerLover -c " CREATE ROLE ""operator"" WITH INHERIT LOGIN CREATEROLE CREATEDB REPLICATION ENCRYPTED PASSWORD '5302469' ; "
psql -d HLD -U ComputerLover -c " CREATE ROLE ""repuser"" WITH INHERIT LOGIN REPLICATION ENCRYPTED PASSWORD '119'; "

psql -d HLD -U ComputerLover -c " CREATE ROLE ""leader"" ; "
psql -d HLD -U ComputerLover -c " CREATE ROLE ""worker"" WITH INHERIT CREATEROLE CREATEDB  REPLICATION  ; "

psql -d HLD -U ComputerLover -c " GRANT leader TO ""HLD"" GRANTED BY ""ComputerLover""; "
psql -d HLD -U ComputerLover -c " GRANT worker TO ""operator"" GRANTED BY ""ComputerLover""; "

psql -d HLD -U ComputerLover -c " ALTER DATABASE ""HLD"" OWNER TO ""operator""; "

psql -d HLD -U ComputerLover -c " ALTER ROLE ""ComputerLover"" WITH ENCRYPTED PASSWORD 'wkx9dragon Xue Xi.' ; "

pg_ctl -D  %PGDATA% stop
copy %PGBACKUP%\pg_hba.conf %PGDATA%
copy %PGBACKUP%\postgresql.conf %PGDATA%
pg_ctl -D  %PGDATA% start
