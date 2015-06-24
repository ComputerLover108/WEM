import psycopg2
import os
import argparse
import tempfile

def test(fname,dsn):
    psycopg2.extensions.register_type(psycopg2.extensions.UNICODE)
    conn=psycopg2.connect(dsn=dsn)
    conn.set_client_encoding('UTF8')
    cur=conn.cursor()
    table='"%s"' %('生产动态')
##    print(table)
    with open(fname,encoding='utf-8') as f:
        cur.copy_from(f, table, sep='\t',null='\\N')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-F", "--file",type=str,help="file")
    parser.add_argument("-H","--host",type=str,default='127.0.0.1',help="default host is 127.0.0.1")
    parser.add_argument("-P","--port",type=str,default='2012',help="default port is 2012")
    parser.add_argument("-U","--user",type=str,default='operator',help="default user is postgres")
    parser.add_argument("-W","--password",type=str,default='5302469',help="default password is empty!")
    parser.add_argument("-D","--database",type=str,default='HLD',help="default database is postgres")
    args = parser.parse_args()
    if args.file :
        src=args.file
        if not os.path.exists(src):
         print('file ('+src+')没找到!')
         exit(0)
        else:
            host=args.host
            port=args.port
            user=args.user
            password=args.password
            dbname=args.database
            dsn='dbname=%s user=%s password=%s host=%s port=%s' %(dbname,user,password,host,port)
            test(fname=src,dsn=dsn)

if __name__ == '__main__':
    main()
