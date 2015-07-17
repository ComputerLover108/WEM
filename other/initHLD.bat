set PGHOME=e:\public\portable\x64\database\pgsql
set PGDATA=f:\public\database\MasterPG\data
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

REM psql -d HLD -U ComputerLover -c " ALTER ROLE ""repuser"" WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN REPLICATION ENCRYPTED PASSWORD '119' ;" 
REM psql -d HLD -U ComputerLover -c " ALTER ROLE ""operator"" WITH NOSUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION ENCRYPTED PASSWORD '5302469' ; "
REM psql -d HLD -U ComputerLover -c " ALTER ROLE ""leader"" WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB  NOREPLICATION  ;" 
REM psql -d HLD -U ComputerLover -c " ALTER ROLE ""worker"" WITH NOSUPERUSER INHERIT CREATEROLE CREATEDB  REPLICATION  ; "

REM psql -d HLD -U ComputerLover -c 
REM "
REM CREATE ROLE ""operator"" ; 
REM CREATE ROLE ""repuser"" ;
REM ALTER DATABASE ""HLD"" OWNER TO ""operator""; 
REM ALTER ROLE ""repuser"" WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN REPLICATION ENCRYPTED PASSWORD '119' ;
REM ALTER ROLE ""operator"" WITH NOSUPERUSER INHERIT CREATEROLE CREATEDB LOGIN NOREPLICATION ENCRYPTED PASSWORD '5302469' ;
REM ALTER ROLE ""ComputerLover"" WITH ENCRYPTED PASSWORD 'wkx9dragon Xue Xi.' ;
REM "
pg_ctl -D  %PGDATA% stop
copy %PGBACKUP%\pg_hba.conf %PGDATA%
copy %PGBACKUP%\postgresql.conf %PGDATA%
pg_ctl -D  %PGDATA% start
