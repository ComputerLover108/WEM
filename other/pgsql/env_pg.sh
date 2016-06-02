export PS1="$USER@`/bin/hostname -s`-> "
export PGPORT=2012
export PGDATA=/data01/pgdata/pg_root
export LANG=en_US.utf8
export PGHOME=/opt/pgsql9.5
export LD_LIBRARY_PATH=$PGHOME/lib:/lib64:/usr/lib64:/usr/local/lib64:/lib:/usr/lib:/usr/local/lib:$LD_LIBRARY_PATH
export DATE=`date +"%Y%m%d%H%M"`
export PATH=$PGHOME/bin:$PATH:.
export MANPATH=$PGHOME/share/man:$MANPATH
export PGHOST=$PGDATA
export PGDATABASE=postgres
export PGUSER=postgres
alias rm='rm -i'
alias ll='ls -lh'
unalias vi