VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "生产动态"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public Sub CreateTable()
    Err.Clear
On Error GoTo errorhander
    Dim tableName As String
    tableName = "生产动态"
    Dim SQL As String
    Dim tableDef As String
'    access
    Dim ac As New access
    tableDef = " (ID counter,时间 date not null,名称 text(32) not null,单位 text(32) not null,数据 double not null,类别 text(32),备注 text  )"
    SQL = "create table " & tableName & tableDef
    ac.cnn.Execute (SQL)
'    PostgreSQL
    Dim psql As New PostgreSQL
    tableDef = " (ID serial,时间 timestamp without time zone not null,名称 varchar(32) not null,单位 varchar(32) not null,数据 double precision not null,类别 varchar(32),备注 text  )"
    SQL = "create table if not exists " & tableName & tableDef
    psql.cnn.Execute (SQL)
'    建立索引
    SQL = "create unique index 生产动态_逻辑ID on 生产动态(时间,名称)"
    ac.cnn.Execute (SQL)
    psql.cnn.Execute (SQL)
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Public Sub reCreateTable()
    Err.Clear
On Error GoTo errorhander
    Dim tableName As String
    tableName = "生产动态"
    Dim SQL As String
'    Dim tableDef As String
    Dim ac As New access
    Dim psql As New PostgreSQL
'    删除在access中生产动态表
    If ac.hasTable(tableName) Then
        SQL = "drop index 生产动态_逻辑ID on " & tableName
        Call ac.cnn.Execute(SQL)
        SQL = "DROP TABLE  " & tableName
        Call ac.cnn.Execute(SQL)
    End If
'    删除在PostgreSQL中生产动态
    If psql.hasTable(tableName) Then
        SQL = "drop index if exists 生产动态_ID cascade"
        Call psql.cnn.Execute(SQL)
        SQL = "drop table if exists " & tableName & " CASCADE"
        Call psql.cnn.Execute(SQL)
    End If
    Call CreateTable
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Public Sub save()
    Err.Clear
On Error GoTo errorhander
    Dim t As Date
    Dim tableName As String
    tableName = "生产动态"
    Dim SQL As String
    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim 记录时间 As Date
    Dim row As Long
    Dim column As Long
    Dim offset As Long
    Dim anchor As Long
    Dim lastRow As Long
    Dim 数据 As Double
    Dim 名称 As String
    Dim 单位 As String
    Dim 类别 As String
    Dim temp As String
    Dim h As New help
    t = Now
    lastRow = Worksheets("快速录入").Range("B65535").End(xlUp).row
    column = 1
    For row = 1 To lastRow
        temp = Worksheets("快速录入").Cells(row, column).value
        If h.isMatch(".*生产动态.*", temp) Then
            anchor = row
            Exit For
        End If
    Next row
    lastRow = anchor + Worksheets("快速录入").Cells(anchor, column).MergeArea.Rows.count - 1
    column = 2
    offset = 1
    记录时间 = Worksheets("快速录入").Cells(1, 3).value
    For row = anchor To lastRow
        temp = Worksheets("快速录入").Cells(row, column).value
            If h.isMatch(".*FIQ-6102.*", temp) Then
                名称 = "FIQ-6102"
                单位 = "方"
                If IsEmpty(Worksheets("快速录入").Cells(row, column + offset).value) Then
                    MsgBox (名称 & "数据必须填写！")
                    Exit Sub
                End If
                数据 = Worksheets("快速录入").Cells(row, column + offset).value
                类别 = "轻油"
            End If
            If h.isMatch(".*FIQ-5014.*", temp) Then
                名称 = "FIQ-5014"
                单位 = "方"
'                表格单位是千方，数据库单位是方
                If IsEmpty(Worksheets("快速录入").Cells(row, column + offset).value) Then
                    MsgBox (名称 & "数据必须填写！")
                    Exit Sub
                End If
                数据 = Worksheets("快速录入").Cells(row, column + offset).value * 1000
                类别 = "燃料气"
            End If
            If h.isMatch(".*FIQ-2043.*", temp) Then
                名称 = "FIQ-2043"
                单位 = "方"
                If IsEmpty(Worksheets("快速录入").Cells(row, column + offset).value) Then
                    MsgBox (名称 & "数据必须填写！")
                    Exit Sub
                End If
                数据 = Worksheets("快速录入").Cells(row, column + offset).value
                类别 = "天然气"
            End If
            
        If Not IsNull(Worksheets("快速录入").Cells(row, column)) And Not IsEmpty(Worksheets("快速录入").Cells(row, column)) Then
    '            access
            SQL = "delete from " & tableName & " where 时间= #" & 记录时间 & "# and 名称 = '" & 名称 & "'"
            Call ac.cnn.Execute(SQL)
    '            psql
            SQL = "delete from " & tableName & " where 时间= '" & 记录时间 & "' and 名称 = '" & 名称 & "'"
            Call psql.cnn.Execute(SQL)
    '            access
            SQL = "INSERT INTO " & tableName & " ( 时间,名称,单位,数据,类别) VALUES ( #" & 记录时间 & "#,'" & 名称 & "','" & 单位 & "','" & 数据 & "','" & 类别 & "')"
            Call ac.cnn.Execute(SQL)
    '            psql
            SQL = "INSERT INTO " & tableName & " ( 时间,名称,单位,数据,类别) VALUES ( '" & 记录时间 & "','" & 名称 & "','" & 单位 & "','" & 数据 & "','" & 类别 & "')"
            Call psql.cnn.Execute(SQL)
        End If
    Next row
    Debug.Print "填写数据到生产动态耗时" & DateDiff("s", t, Now) & "s!"
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
End Sub
