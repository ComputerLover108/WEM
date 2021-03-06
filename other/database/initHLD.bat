set VERSION=12
set PGADMINISTRATOR=ComputerLover
set PGHOME=D:\public\portable\x64\database\PostgreSQL\%VERSION%\pgsql
set PGDATA=e:\public\database\PostgreSQL\%VERSION%\MasterPG\data
set PGPASSWORD=pgpassword
set PGPASSFILE=pgpass.conf
set PGBACKUP=d:\public\database
set PATH=%PGHOME%\bin;%PATH%

pg_ctl -D  %PGDATA% stop
rmdir /s /q %PGDATA%
initdb -E UTF8 --locale=chinese-simplified_china.936  -U %PGADMINISTRATOR% --pwfile=%PGPASSWORD% -D %PGDATA%
rem initdb -E UTF8 --locale=C  -U %PGADMINISTRATOR% --pwfile=%PGPASSWORD% -D %PGDATA%  
pg_ctl -D  %PGDATA% start

psql -f initHLD.sql -U ComputerLover postgres

pg_ctl -D  %PGDATA% stop
copy %PGDATA%\pg_hba.conf %PGDATA%\pg_hba.bak
copy %PGDATA%\postgresql.conf %PGDATA%\postgresql.bak
copy pg_hba.conf %PGDATA%\
type postgresql.conf >>%PGDATA%\postgresql.conf
REM pg_ctl -D  %PGDATA% start
