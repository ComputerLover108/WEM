aptitude install build-essential libreadline-dev zlib1g-dev
#./configure --prefix=/opt/pgsql9.5  --with-CC=clang 
CC=/opt/clang3.80/bin/clang CFLAGS="-O2 -fstrict-enums" ./configure --prefix=/opt/pgsql9.5 
make -j $(nproc)
make install -j $(nproc)
