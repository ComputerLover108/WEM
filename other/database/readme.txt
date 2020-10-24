1. 用附件带的WORDPAD文本编辑器,  建立一后缀名为 .DSN的文件,  格式如下, 然后按文本格式存起来:
注意: 格式很重要且必须存为'文本格式',否则不认,  别的编辑器应该也可以.
#################################
[ODBC]
DRIVER=驱动程序名
UID=用户名
PWD=密码
DATABASE=数据库名
WSID=服务器名
APP=(随便填)
SERVER=服务器名
###############################

2. 将此.DSN文件拷贝到你的COMMON FILES\odbc\DataSources目录下, 如果弄不清楚目录,  
到控制面板中试建一个文件DSN然后查找此文件就可得到目录.

3. 用cn.open "FILEDSN= 文件名.dsn"  就可连上了.

****************************************************************************
以下是本人的试验
1.My.DSN文件:
[ODBC]
DRIVER=SQL Server
UID=sa
PWD=finegirl
DATABASE=TestDB
WSID=tbb-it
APP=Netstar Application
SERVER=tbb-it

2.拷贝到C:\Program Files\Common Files\ODBC\DataSources目录

3.程序中调用如下:
Dim cn As New ADODB.Connection
cn.Open "FILEDSN=My.dsn"
*****************************************************************************

够清楚吧, 记得加分, 如果你够英俊潇洒, 请喝咖啡也可以. :)