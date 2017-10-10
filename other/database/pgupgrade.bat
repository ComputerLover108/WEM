set OldVersion=9.6
set NewVersion=10
set PGHOME=d:\public\portable\x64\database\PostgreSQL
set PGDATA=e:\public\database\PostgreSQL

set OldBin=%PGHOME%\%OldVersion%\pgsql\bin
set OldData=%PGDATA%\%OldVersion%\MasterPG\data

set NewBin=%PGHOME%\%NewVersion%\pgsql\bin
set NewData=%PGDATA%\%NewVersion%\MasterPG\data

set PGDATAOLD=%OldData%
set PGBINOLD=%OldBin%

set PGDATANEW=%NewData%
set PGBINNEW=%NewBin%

set PATH=%PGBINNEW%;%PATH%;
set PGPASSFILE=%PGHOME%\pgpass.conf

pg_upgrade.exe -U ComputerLover