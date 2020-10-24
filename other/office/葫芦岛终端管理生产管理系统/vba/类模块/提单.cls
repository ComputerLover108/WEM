VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "提单"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public 日期 As Date
Public 提单号 As String
Public 产品名称 As String
Public 客户名称 As String
Public 计划装车t As Double
Public 实际装车t As Double
Public 实际装车m3 As Double
Public 实际装车bbl As Double
Public 装车数量 As Long
Public 备注 As String

Public Sub test()
End Sub

Public Sub DeleteTable()
On Error GoTo handler
    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim tablename As String
    Dim SQL As String
    tablename = "提单"
    SQL = "drop table " & tablename
    Call ac.cnn.Execute(SQL)
    SQL = "drop table if exists " & tablename & " CASCADE"
    Call psql.cnn.Execute(SQL)
handler:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub
Public Sub CreateTable()
    Err.Clear
On Error GoTo errorhander
    Dim tablename As String
    tablename = "提单"
    Dim SQL As String
    Dim tableDef As String
'    access
    Dim ac As New access
    tableDef = " (ID counter,提单号 text(16),日期 date not null,产品名称 text(32) not null,客户名称 text(32) not null,计划装车t double not null,实际装车t double not null,实际装车bbl double,装车数量 integer,备注 text  )"
    SQL = "create table " & tablename & tableDef
    ac.cnn.Execute (SQL)
'    PostgreSQL
    Dim psql As New PostgreSQL
    tableDef = " (ID serial,提单号 varchar(16),日期 date not null,产品名称 varchar(32) not null,客户名称 varchar(32) not null,计划装车t double precision not null,实际装车t double precision not null,实际装车bbl double precision,装车数量 integer ,备注 text  )"
    SQL = "create table if not exists " & tablename & tableDef
    psql.cnn.Execute (SQL)
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Public Sub save(ByRef table As Object)
    Err.Clear
On Error GoTo errorhander
    Dim SQL, SQL查询 As String
    Dim tablename As String
    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim record As New 提单
    tablename = "提单"
    Dim rst As Object
'    添加记录
    For Each record In table
        If record.数据有效 Then
            SQL查询 = "select * from 提单 where 提单号='" & record.提单号 & "'"
'            access
            Set rst = ac.cnn.Execute(SQL查询)
            If Not rst.EOF Or Not rst.BOF Then
                SQL = "update " & tablename & " set 日期= #" & record.日期 & "#,产品名称='" & record.产品名称 & "',客户名称='" & record.客户名称 & "',实际装车t=" & record.实际装车t & ",实际装车m3=" & record.实际装车m3 & ",实际装车bbl=" & record.实际装车bbl & ",装车数量=" & record.装车数量 & ",备注='" & record.备注 & "' where 提单号= '" & record.提单号 & "';"
                Call ac.cnn.Execute(SQL)
            Else
                SQL = "INSERT INTO " & tablename & " (日期,产品名称,客户名称,计划装车t,实际装车t,实际装车m3,实际装车bbl,装车数量,备注,提单号) values (" & "#" & record.日期 & "#,'" & record.产品名称 & "','" & record.客户名称 & "'," & record.计划装车t & "," & record.实际装车t & "," & record.实际装车m3 & "," & record.实际装车bbl & "," & record.装车数量 & ",'" & record.备注 & "','" & record.提单号 & "')"
                Call ac.cnn.Execute(SQL)
            End If
'            PostgreSQL
            Set rst = psql.cnn.Execute(SQL查询)
            If Not rst.EOF Or Not rst.BOF Then
                SQL = "update " & tablename & " set 日期= '" & record.日期 & "',产品名称='" & record.产品名称 & "',客户名称='" & record.客户名称 & "',实际装车t=" & record.实际装车t & ",实际装车m3=" & record.实际装车m3 & ",实际装车bbl=" & record.实际装车bbl & ",装车数量=" & record.装车数量 & ",备注='" & record.备注 & "' where 提单号= '" & record.提单号 & "';"
                Call psql.cnn.Execute(SQL)
            Else
                SQL = "INSERT INTO " & tablename & " (日期,产品名称,客户名称,计划装车t,实际装车t,实际装车m3,实际装车bbl,装车数量,备注,提单号) values (" & "'" & record.日期 & "','" & record.产品名称 & "','" & record.客户名称 & "'," & record.计划装车t & "," & record.实际装车t & "," & record.实际装车m3 & "," & record.实际装车bbl & "," & record.装车数量 & ",'" & record.备注 & "','" & record.提单号 & "')"
                Call psql.cnn.Execute(SQL)
            End If
        End If
    Next record
    rst.Close
    Set rst = Nothing
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Public Sub dataErase(ByRef table As Object)
    Err.Clear
On Error GoTo errorhander
    Dim SQL As String
    Dim tablename As String
    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim record As New 提单
    tablename = "提单"
'    删除需要替换的记录
    For Each record In table
'        access
        SQL = "delete from " & tablename & " where  提单号='" & record.提单号 & "' "
        Call ac.cnn.Execute(SQL)
'        PostgreSQL
        SQL = "delete from " & tablename & " where  提单号='" & record.提单号 & "' "
        Call psql.cnn.Execute(SQL)
    Next record
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Public Function 数据有效() As Boolean
    Dim 有效 As Boolean
    有效 = True
    If Year(日期) < 1999 Then
        有效 = False
    End If
    If 产品名称 = "" Then
        有效 = False
    End If
    If 客户名称 = "" Then
        有效 = False
    End If
    If 计划装车t < 0 Then
        有效 = False
    End If
    If 实际装车t < 0 Then
        有效 = False
    End If
    If 实际装车bbl < 0 Then
        有效 = False
    End If
    If 实际装车m3 < 0 Then
        有效 = False
    End If
    数据有效 = 有效
End Function
