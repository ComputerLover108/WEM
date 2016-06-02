aptitude install build-essential libreadline-dev zlib1g-dev
./configure --prefix=/opt/pgsql9.5  --with-CC=clang 
make -j 4
make install -j 4
