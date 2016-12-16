set PGADMINISTRATOR=ComputerLover
set PGHOME=D:\public\portable\database\pg9.6\pgsql
set PGDATA=D:\public\database\MasterPG\data
set PGPASSWORD=pgpassword
set PGPASSFILE=pgpass.conf
set PGBACKUP=d:\public\database
set PATH=%PGHOME%\bin;%PATH%

pg_ctl -D  %PGDATA% stop
rmdir /s /q %PGDATA%
initdb -E UTF8 --locale=C  -U %PGADMINISTRATOR% --pwfile=%PGPASSWORD% -D %PGDATA% 
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
copy pg_hba.conf %PGDATA%\
copy postgresql.conf %PGDATA%
pg_ctl -D  %PGDATA% start