set SD=%Date:~0,4%-%Date:~5,2%-%Date:~8,2%
set path=d:\public\portable\database\x64\pgsql\bin;%path%;
cd /d d:\public\database\HLD
pg_dump.exe  -h 10.30.29.51 -p 2012 -f %SD%.backup  -U operator -c -C -E UTF8 -w HLD
