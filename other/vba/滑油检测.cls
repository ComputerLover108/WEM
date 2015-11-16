VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "滑油检测"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public 日期 As Date
Public 名称 As String
Public 运动粘度, 机械杂质, 含水 As Variant
Public 数据源 As String

Sub CreateTable()
    Err.Clear
On Error GoTo errorhander
    Dim SQL As String
    Dim tableName As String
    tableName = "滑油检测"
'    PostgreSQL 表
    tableDef = " (ID serial primary key,日期 date not null,名称 varchar,""运动粘度40℃ mm2/s"" double precision,""机械杂质%"" double precision,""含水%"" double precision,数据源 varchar  );"
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

Public Sub PushTableToDatabase(ByRef table As Object)
    Err.Clear
On Error GoTo ErrorHandler
    Call CreateTable
    Dim tableName As String
    Dim SQL, filter As String
    tableName = "滑油检测"
    Dim psql As New PostgreSQL
    For Each x In table.Keys
        SQL = "INSERT INTO " & tableName & " (日期,名称,""运动粘度40℃ mm2/s"",""机械杂质%"",""含水%"",数据源) values ('" & x.日期 & "',$$" & x.名称 & "$$," & x.运动粘度 & "," & x.机械杂质 & "," & x.含水 & ",$$" & x.数据源 & "$$);"
'        Debug.Print SQL
        Call psql.cnn.Execute(SQL)
    Next
    filter = " where ID not in ( select max(id) from " & tableName & " group by 日期,名称 ) "
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
