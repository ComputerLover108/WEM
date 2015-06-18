set SD=%Date:~0,4%-%Date:~5,2%-%Date:~8,2%_%Time:~0,2%:%Time:~3,2%:%Time:~6,2%
pg_dump.exe  -h 10.30.29.78 -p 2013 -f %SD%.backup  -U operator -c -C -E UTF8 -w HLD
