VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "上游"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public Sub save()
    Err.Clear
On Error GoTo ErrorHandler
    Dim t As Date
    Dim lastRow As Long
    Dim row As Long
    Dim column As Long
    Dim offset As Long
    Dim anchor As Long
    Dim h As New help
    Dim temp As String
    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim SQL As String
    Dim 记录日期 As Date
    Dim 名称 As String
    Dim 单位 As String
    Dim 数据 As Double
    Dim 类别 As String
    t = Now
    lastRow = Worksheets("快速录入").Range("A65535").End(xlUp).row
    column = 1
    For row = 1 To lastRow
        temp = Worksheets("快速录入").Cells(row, column).value
        If h.isMatch(".*上游.*", temp) Then
            anchor = row
            Exit For
        End If
    Next row
    lastRow = anchor + Worksheets("快速录入").Cells(anchor, column).MergeArea.Rows.count - 1
    Dim tableName As String
    tableName = "生产信息"
    记录日期 = Worksheets("快速录入").Cells(1, 3).value
    单位 = "方"
    类别 = "天然气"
    column = 2
    offset = 1
    For row = anchor To lastRow
        temp = Worksheets("快速录入").Cells(row, column).value
        If h.isMatch(".*JZ9-3供气.*", temp) Then
            名称 = "JZ9-3供气"
        End If
        If h.isMatch(".*JZ21-1供气.*", temp) Then
            名称 = "JZ21-1供气"
        End If
        If h.isMatch(".*JZ25-1供气.*", temp) Then
            名称 = "JZ25-1供气"
        End If
        If h.isMatch(".*JZ25-1S供气.*", temp) Then
            名称 = "JZ25-1S供气"
        End If
        数据 = Worksheets("快速录入").Cells(row, column + offset).value * 10000
'    表格单位是万方，数据库单位是方
        If Not IsNull(Worksheets("快速录入").Cells(row, column)) And Not IsEmpty(Worksheets("快速录入").Cells(row, column)) Then
    '            access
            SQL = "delete from " & tableName & " where 日期= #" & 记录日期 & "# and 名称 = '" & 名称 & "'"
            Call ac.cnn.Execute(SQL)
    '            psql
            SQL = "delete from " & tableName & " where 日期= '" & 记录日期 & "' and 名称 = '" & 名称 & "'"
            Call psql.cnn.Execute(SQL)
    '            access
            SQL = "INSERT INTO " & tableName & " ( 日期,名称,单位,数据,类别) VALUES ( #" & 记录日期 & "#,'" & 名称 & "','" & 单位 & "','" & 数据 & "','" & 类别 & "')"
            Call ac.cnn.Execute(SQL)
    '            psql
            SQL = "INSERT INTO " & tableName & " ( 日期,名称,单位,数据,类别) VALUES ( '" & 记录日期 & "','" & 名称 & "','" & 单位 & "','" & 数据 & "','" & 类别 & "')"
            Call psql.cnn.Execute(SQL)
        End If
    Next row
    Debug.Print "填写上游数据到生产信息耗时" & DateDiff("s", t, Now) & "s!"
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub
