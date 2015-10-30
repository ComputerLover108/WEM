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
Public PH值, 浊度, 电导率, 总碱度, 总硬度, LSI, 氯离子, 总铁 As Double
Public 数据源 As String

Sub CreateTable()
    Err.Clear
On Error GoTo errorhander
    Dim SQL As String
    Dim tableName As String
    tableName = "水质检测"
'    access 表
    Dim tableDef As String
    tableDef = " (ID counter,日期 date not null,名称 text(16) not null,PH值 double, 浊度 double, 电导率 double, 总碱度 double, 总硬度 double, LSI double, 氯离子 double, 总铁 double,数据源 text  )"
    SQL = " CREATE TABLE " & tableName & tableDef
    Dim ac As New access
    If Not ac.hasTable(tableName) Then
        Call ac.cnn.Execute(SQL)
    End If
'    PostgreSQL 表
    tableDef = " (ID serial,日期 date not null,名称 varchar,PH值 double precision,浊度 double precision,电导率 double precision,总碱度 double precision,总硬度 double precision,LSI double precision,氯离子 double precision,总铁 double precision,数据源 varchar  );"
    SQL = " CREATE TABLE IF NOT EXISTS " & tableName & tableDef
    Debug.Print SQL
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
Public Sub PushTableToDatabase(table)
    Err.Clear
    On Error GoTo ErrorHandler
    Call CreateTable
    Dim t As Date
    t = Now
    Dim ac As New access
    Dim rst As New ADODB.Recordset
    Dim SQL As String
    Dim temp As New 水质检测
    Dim condition As Boolean
    condition = True
    Dim x
    Dim filter As String
'    导入access
    Debug.Print "准备导入" & table.count & "条记录！"
    Dim tableName As String
    tableName = "水质检测"
    Dim cnn As Object
    Set cnn = ac.cnn
    rst.Open tableName, cnn, adOpenDynamic, adLockBatchOptimistic, adCmdTabl
    For Each x In table.Keys
        Set temp = x
            SQL = "delete from " & tableName & " where 日期=#" & temp.日期 & "# and 名称='" & temp.名称
            Debug.Print SQL
            Call ac.cnn.Execute(SQL)
            rst.AddNew
            rst.Fields("日期").value = temp.日期
            rst.Fields("名称").value = temp.名称
            rst.Fields("PH值").value = temp.PH值
            rst.Fields("浊度").value = temp.浊度
            rst.Fields("电导率").value = temp.电导率
            rst.Fields("总碱度").value = temp.总碱度
            rst.Fields("总碱度").value = temp.总碱度
            rst.Fields("总硬度").value = temp.总硬度
            rst.Fields("LSI").value = temp.LSI
            rst.Fields("氯离子").value = temp.氯离子
            rst.Fields("总铁").value = temp.总铁
            rst.Fields("数据源").value = temp.数据源
            rst.UpdateBatch
    Next x
    Debug.Print "导入" & rst.RecordCount; "条记录,access表花费" & DateDiff("s", t, Now()) & "s."
    rst.Close
'    Set rst = Nothing
'    导入postgresql
    Dim psql As New PostgreSQL
    Set cnn = psql.cnn
    rst.Open tableName, cnn, adOpenDynamic, adLockBatchOptimistic, adCmdTable
    For Each x In table.Keys
        Set temp = x
        temp = x
        rst.AddNew
        rst.Fields("日期").value = temp.日期
        rst.Fields("名称").value = temp.名称
        rst.Fields("PH值").value = temp.PH值
        rst.Fields("浊度").value = temp.浊度
        rst.Fields("电导率").value = temp.电导率
        rst.Fields("总碱度").value = temp.总碱度
        rst.Fields("总碱度").value = temp.总碱度
        rst.Fields("总硬度").value = temp.总硬度
        rst.Fields("LSI").value = temp.LSI
        rst.Fields("氯离子").value = temp.氯离子
        rst.Fields("总铁").value = temp.总铁
        rst.Fields("数据源").value = temp.数据源
        rst.UpdateBatch
    Next x
    Debug.Print "导入" & rst.RecordCount & "条记录,PostgreSQL表花费" & DateDiff("s", t, Now()) & "s."
    rst.Close
    Set rst = Nothing
    filter = "where ID not in ( select max(ID) from 水质检测 group by 日期,名称 ) "
    SQL = "delete from 水质检测 " & filter
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
