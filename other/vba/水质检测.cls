VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "水质检测"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public 日期 As Date
Public 名称 As String
Public PH值, 浊度, 电导率, 总碱度, 总硬度, LSI, 氯离子, 总铁 As Variant
Public 数据源 As String

Sub CreateTable()
    Err.Clear
On Error GoTo errorhander
    Dim SQL As String
    Dim tableName As String
    tableName = "水质检测"
'    PostgreSQL 表
    tableDef = " (ID serial primary key,日期 date not null,名称 varchar,PH值 double precision,浊度 double precision,电导率 double precision,总碱度 double precision,总硬度 double precision,LSI double precision,氯离子 double precision,总铁 double precision,数据源 varchar  );"
    SQL = " CREATE TABLE IF NOT EXISTS " & tableName & tableDef
'    Debug.Print SQL
    Dim psql As New PostgreSQL
    Call psql.cnn.Execute(SQL)

errorhander:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
'水质指标导入数据库
Public Sub PushTableToDatabase(ByRef table As Object)
    Err.Clear
    On Error GoTo ErrorHandler
    Call CreateTable
    Dim t As Date
    t = Now
    Dim rst As New ADODB.Recordset
    Dim SQL, filter As String
    Dim x
'    Debug.Print "准备导入" & table.count & "条记录！"
    Dim tableName As String
    tableName = "水质检测"
    Dim cnn As Object

'    导入postgresql
    Dim psql As New PostgreSQL
    Set cnn = psql.cnn
    rst.Open tableName, cnn, adOpenDynamic, adLockBatchOptimistic, adCmdTable
    For Each x In table.Keys
        rst.AddNew
        rst.Fields("日期").Value = x.日期
        rst.Fields("名称").Value = x.名称
        rst.Fields("PH值").Value = x.PH值
        rst.Fields("浊度").Value = x.浊度
        rst.Fields("电导率").Value = x.电导率
        rst.Fields("总碱度").Value = x.总碱度
        rst.Fields("总碱度").Value = x.总碱度
        rst.Fields("总硬度").Value = x.总硬度
        rst.Fields("LSI").Value = x.LSI
        rst.Fields("氯离子").Value = x.氯离子
        rst.Fields("总铁").Value = x.总铁
        rst.Fields("数据源").Value = x.数据源
        rst.UpdateBatch
    Next x
    Debug.Print "导入" & table.count & "条记录到表" & tableName & " ,PostgreSQL表花费" & DateDiff("s", t, Now()) & "s."
    rst.Close
    Set rst = Nothing

    filter = " where ID not in ( select max(ID) from " & tableName & " group by 日期,名称 ) "
    SQL = "delete from " & tableName & filter
    Call psql.cnn.Execute(SQL)
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
'    PostgreSQL 未连接代码 -2147467259
    If -2147467259 = Err.Number Then
        MsgBox "PostgreSQL 数据库没有打开！"
        Exit Sub
    End If
    Resume Next
End Sub
