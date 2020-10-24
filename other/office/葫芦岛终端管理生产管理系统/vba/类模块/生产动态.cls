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
    Dim tablename As String
    tablename = "生产动态"
    Dim SQL As String
    Dim tableDef As String
'    access
    Dim ac As New access
    tableDef = " (ID counter,时间 date not null,名称 text(32) not null,单位 text(32) not null,数据 double not null,类别 text(32),备注 text  )"
    SQL = "create table " & tablename & tableDef
    ac.cnn.Execute (SQL)
'    PostgreSQL
    Dim psql As New PostgreSQL
    tableDef = " (ID serial,时间 timestamp without time zone not null,名称 varchar(32) not null,单位 varchar(32) not null,数据 double precision not null,类别 varchar(32),备注 text  )"
    SQL = "create table if not exists " & tablename & tableDef
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
    Dim tablename As String
    tablename = "生产动态"
    Dim SQL As String
'    Dim tableDef As String
    Dim ac As New access
    Dim psql As New PostgreSQL
'    删除在access中生产动态表
    If ac.hasTable(tablename) Then
        SQL = "drop index 生产动态_逻辑ID on " & tablename
        Call ac.cnn.Execute(SQL)
        SQL = "DROP TABLE  " & tablename
        Call ac.cnn.Execute(SQL)
    End If
'    删除在PostgreSQL中生产动态
    If psql.hasTable(tablename) Then
        SQL = "drop index if exists 生产动态_ID cascade"
        Call psql.cnn.Execute(SQL)
        SQL = "drop table if exists " & tablename & " CASCADE"
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
    Dim tablename As String
    tablename = "生产动态"
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
    Dim 名称, 单位, 类别, 备注 As String
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
            If h.isMatch(".*锅炉房用气.*", temp) Then
                名称 = "锅炉房用气"
                单位 = "方"
                If IsEmpty(Worksheets("快速录入").Cells(row, column + offset).value) Then
                    MsgBox (名称 & "数据必须填写！")
                    Exit Sub
                End If
                数据 = Worksheets("快速录入").Cells(row, column + offset).value
                类别 = "燃料气"
                备注 = "锅炉、餐厅"
            End If
            If h.isMatch(".*火炬长明灯.*", temp) Then
                名称 = "火炬长明灯"
                单位 = "方"
                If IsEmpty(Worksheets("快速录入").Cells(row, column + offset).value) Then
                    MsgBox (名称 & "数据必须填写！")
                    Exit Sub
                End If
                数据 = Worksheets("快速录入").Cells(row, column + offset).value
                类别 = "天然气"
            End If
            If h.isMatch(".*火炬放空量.*", temp) Then
                名称 = "火炬放空量"
                单位 = "方"
                If IsEmpty(Worksheets("快速录入").Cells(row, column + offset).value) Then
                    MsgBox (名称 & "数据必须填写！")
                    Exit Sub
                End If
                数据 = Worksheets("快速录入").Cells(row, column + offset).value
                类别 = "天然气"
            End If
            
        If Not IsNull(Worksheets("快速录入").Cells(row, column)) And Not IsEmpty(Worksheets("快速录入").Cells(row, column)) Then
            SQL = "delete from " & tablename & " where 时间= '" & 记录时间 & "' and 名称 = '" & 名称 & "'"
            Call psql.cnn.Execute(SQL)
            SQL = "INSERT INTO " & tablename & " ( 时间,名称,单位,数据,类别) VALUES ( '" & 记录时间 & "','" & 名称 & "','" & 单位 & "','" & 数据 & "','" & 类别 & "')"
'            Debug.Print SQL
            Call psql.cnn.Execute(SQL)
        End If
    Next row
    Dim yd, td As Date
    td = DateValue(记录时间)
    yd = DateAdd("d", -1, td)
    Dim temp1, temp2 As Variant
    Dim cumulativeTable, name, SQL_suffix
    SQL = ""
'    SQL_suffix = " ON CONFLICT (日期,名称,单位,类别,状态,备注) DO UPDATE SET 数据源 = EXCLUDED.数据源,数据 = EXCLUDED.数据,月累 = EXCLUDED.月累,年累 = EXCLUDED.年累 where  生产信息.数据 is distinct from EXCLUDED.数据 or 生产信息.月累 is distinct from EXCLUDED.月累 or 生产信息.年累 is distinct from EXCLUDED.年累 or 生产信息.数据源 is distinct from EXCLUDED.数据源;"
'    SQL_suffix = " ON CONFLICT (日期,名称,单位,类别,状态,备注) DO UPDATE SET 数据 = EXCLUDED.数据 where  生产信息.数据 is distinct from EXCLUDED.数据 ;"
    cumulativeTable = Array("FIQ-5014", "FIQ-2043", "锅炉房用气", "火炬长明灯", "火炬放空量")
'    SQL = "CREATE UNIQUE INDEX IF NOT EXISTS  生产信息唯一索引  ON 生产信息 (日期,名称,单位,类别,状态,备注);"
'    Call psql.cnn.Execute(SQL)
'    PostgreSQL 唯一索引不能处理空值
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
    Dim record As New 生产信息
    Dim scxx As New 生产信息
    Const MAX_fuelGas As Long = 999999
    For Each name In cumulativeTable
        SQL = "select 数据 from 生产动态 where 名称 = '" & name & "' and 时间='" & yd & "'"
        temp1 = psql.cnn.Execute(SQL)(0)
        SQL = "select 数据 from 生产动态 where 名称 = '" & name & "' and 时间='" & td & "'"
        temp2 = psql.cnn.Execute(SQL)(0)
'        Debug.Print name, yd, temp1, td, temp2, temp2 - temp1
        If Not IsEmpty(temp1) And Not IsEmpty(temp2) Then
            数据 = temp2 - temp1
            If h.isMatch(".*FIQ-5014.*", name) Then
                name = "热油炉"
                If 数据 < 0 Then
                    数据 = 数据 + MAX_fuelGas
                End If
            End If
'            Debug.Print name & " 数据=" & 数据
        End If
'            FIQ2043不是总累计表
        If h.isMatch(".*FIQ-2043.*", name) Then
            数据 = temp2
        End If
        If 数据 < 0 Then
'        仪表数据校验以新数据为准
            MsgBox (name + "（" + CStr(temp2) + "），今天数据（" + CStr(temp1) + "）比昨天还小，你确定！")
'            数据 = temp2
        End If
        名称 = name
        单位 = "方"
        类别 = "天然气"
        With record
            .日期 = td
            .名称 = 名称
            .数据 = 数据
            .单位 = 单位
            .类别 = 类别
        End With
        table.Add record, ""
        Set record = Nothing
        Debug.Print td, 名称, 单位, 类别, 备注, 数据
'        SQL = "INSERT INTO " & tablename & " ( 日期,名称,单位,数据,类别,备注) VALUES ( '" & td & "','" & 名称 & "','" & 单位 & "','" & 数据 & "','" & 类别 & "','" & 备注 & "')"
'        SQL = SQL + SQL_suffix
'        Debug.Print SQL
'        Call psql.cnn.Execute(SQL)
    Next
    Call scxx.PushTableToDatabase(table)
    Debug.Print "填写数据到生产动态耗时" & DateDiff("s", t, Now) & "s!"
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

