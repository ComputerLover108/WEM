VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "PostgreSQL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public cnn As New ADODB.Connection
Sub test()
    Dim SQL As String
'    删除原有表[生产信息]
    SQL = "drop table if exists 生产信息 ;"
    cnn.Execute SQL
'    重建表 [生产信息]
    Dim tableName As String
    tableName = "生产信息"
    Dim tableDef As String
    tableDef = " (ID serial,日期 date not null,名称 varchar(16) not null,单位 varchar(8),数据 double precision,类别 varchar(8),状态 varchar(8),备注 varchar,月累 double precision,年累 double precision,数据源 varchar  );"
    SQL = " CREATE TABLE IF NOT EXISTS " & tableName & tableDef
    Call cnn.Execute(SQL)

End Sub
'初始化PostgreSQL连接
Private Sub Class_Initialize()
'创建对数据库的连接
    Dim dataBase As String
    Dim userName As String
    Dim password As String
    Dim DBname As String
    Dim openCommand As String
    dataBase = "PostgreSQL35W"
    userName = "operator"
    password = "5302469"
    DBname = "HLD"
    openCommand = "DSN=" & dataBase & ";" & "UID=" & userName & ";" & "PWD=" & password & ";" & "Database=" & DBname
    cnn.Open openCommand
End Sub
'清除PostgreSQL连接
Private Sub Class_Terminate()
    If cnn.State <> adStateClosed Then cnn.Close
    Set cnn = Nothing
End Sub
'指定表是否存在
Function hasTable(ByVal tableName As String) As Boolean
    hasTable = True
    Err.Clear
    On Error Resume Next
    Dim SQL As String
    SQL = "select count(*) from " & tableName
    cnn.Execute SQL
    Debug.Print Err.Number & Err.Description
    If Err.Number = -2147467259 Then
        hasTable = False
    End If
'    If Err.Number <> 0 Then
'        hasTable = False
'    End If
End Function

Public Sub removeDuplicate()
    On Error Resume Next
    Dim filter As String
    Dim SQL As String
    filter = "where ID not in ( select max(ID) from 生产信息 group by 日期,名称,单位,类别,状态,备注 ) "
    SQL = "delete from 生产信息 " & filter
    Dim t As Date
    t = Now
    Call cnn.Execute(SQL)
    Debug.Print "PostgreSQL 去除重复数据用时" & DateDiff("s", t, Now()) & "s."
End Sub

Public Sub 数据库整理()
    Err.Clear
On Error GoTo ErrorHandler
    Dim SQL As String
    SQL = "ALTER TABLE 生产动态 ALTER 时间 TYPE timestamp;"
    Call cnn.Execute(SQL)
    SQL = "ALTER TABLE  IF EXISTS  生产信息  RENAME COLUMN ID TO id;"
    Call cnn.Execute(SQL)
    SQL = "update 生产信息 set 名称='海管出口PH值' where 名称 like '海管出口PH值%';"
    Call cnn.Execute(SQL)
    SQL = "delete from 生产信息 where 名称='轻油密度'  and 数据=0;"
    Call cnn.Execute(SQL)
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
