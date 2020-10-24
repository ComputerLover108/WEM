pip install supervisor
1
配置
# 默认配置 
# 使用echo_supervisord_conf命令查看默认配置
root@tianshl:~# echo supervisord_conf

# 自定义配置
root@tianshl:~# mkdir /etc/supervisor
root@tianshl:~# mkdir /etc/supervisor/conf.d

root@tianshl:~# echo supervisord_conf > /etc/supervisor/supervisor.conf

root@tianshl:~# vim /etc/supervisor/supervisor.conf

# 内容如下

[unix_http_server]
file=/tmp/supervisor.sock   ; the path to the socket file

[supervisord]
logfile=/tmp/supervisord.log ; main log file; default $CWD/supervisord.log
logfile_maxbytes=10MB        ; max main logfile bytes b4 rotation; default 50MB
logfile_backups=1            ; # of main logfile backups; 0 means none, default 10
loglevel=info                ; log level; default info; others: debug,warn,trace
pidfile=/tmp/supervisord.pid ; supervisord pidfile; default supervisord.pid
nodaemon=false               ; start in foreground if true; default false
minfds=1024                  ; min. avail startup file descriptors; default 1024
minprocs=200                 ; min. avail process descriptors;default 200

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///tmp/supervisor.sock ; use a unix:// URL  for a unix socket

[include]
files = /etc/supervisor/conf.d/*.conf


# 自定义服务配置
root@tianshl:~# vim /etc/supervisor/conf.d/server.conf

内容如下:

[program:server]
directory = /root/server/server/
command = gunicorn --pythonpath /root/server/venv/bin/python3 -w 3 -b 0.0.0.0:80 server.wsgi
autostart = true
startsecs = 5
autorestart = true
startretries = 3
user = root
redirect_stderr = true
stdout_logfile_maxbytes = 10MB
stdout_logfile_backups = 1
stdout_logfile = /root/logs/server.log

启动
supervisord -c /etc/supervisor/supervisor.conf
1
常用指令
root@tianshl:~# supervisorctl -c /etc/supervisor/supervisor.conf reload         # 重新加载配置文件
root@tianshl:~# supervisorctl -c /etc/supervisor/supervisor.conf status         # 服务状态
root@tianshl:~# supervisorctl -c /etc/supervisor/supervisor.conf start server   # 启动某个服务(这里的server是服务名称，即program的名字)
root@tianshl:~# supervisorctl -c /etc/supervisor/supervisor.conf restart server # 重启某个服务
root@tianshl:~# supervisorctl -c /etc/supervisor/supervisor.conf stop server    # 停止某个服务
--------------------- 
作者：tian_shl 
来源：CSDN 
原文：https://blog.csdn.net/xiaobuding007/article/details/79130460?utm_source=copy 
版权声明：本文为博主原创文章，转载请附上博文链接！