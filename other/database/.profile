#sudo apt-get install libreadline-dev zlib1g-dev
export VERSION=9.6 
export PGDATA=/home/postgres/pgdata/$VERSION/MasterPG/data 
export LLVMHOME=/opt/llvm
export PGHOME=/opt/pgsql$VERSION  
export LD_LIBRARY_PATH=$PGHOME/lib:$LLVMHOME/lib:$LD_LIBRARY_PATH
export PATH=$PGHOME/bin:$LLVMHOME/bin:$PATH:.  
export MANPATH=$PGHOME/share/man:$MANPATH  
export PGHOST=localhost  
export PGPORT=2012  
export PGDATABASE=HLD  
export PGUSER=operator  
