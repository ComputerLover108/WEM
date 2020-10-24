VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet12"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit
Public Sub test()
    Call 自动填数
End Sub

Private Sub 保存_Click()
    Dim row As Long
    Dim rowLimit As Long
    Dim temp As String
    Dim h As New help
    Dim anchor As Long
    rowLimit = Worksheets("快速录入").Range("a65535").End(xlUp).row
    For row = 1 To rowLimit
        temp = Worksheets("快速录入").Cells(row, 2).value
'        日期
        If h.isMatch(".*数据库轻油回收量.*", temp) Then
            anchor = row
            Exit For
        End If
    Next row
    For row = 8 To 38
        If Worksheets("快速录入").Cells(1, 3).value = Worksheets("消峰平谷").Cells(row, 1).value Then
    '       数据库轻油回收量
           Worksheets("快速录入").Cells(anchor, 3).value = Worksheets("消峰平谷").Cells(row, 4).value
    '       数据库丙丁烷回收量
           Worksheets("快速录入").Cells(anchor + 1, 3).value = Worksheets("消峰平谷").Cells(row, 7).value
        End If
    Next row
    Worksheets("快速录入").Select
End Sub

Private Sub 快速录入_Click()
    Sheets("快速录入").Select
End Sub

Sub 清除_Click()
    Sheets("消峰平谷").Cells(4, 10).ClearContents
    Sheets("消峰平谷").Range(Cells(8, 1), Cells(38, 10)).Select
    Dim cell As Variant
    For Each cell In Selection
        If cell.HasFormula = False Then cell.ClearContents
    Next cell
    Cells(24, 10).Select
End Sub

Public Sub 自动填数()
On Error GoTo ErrorHandler
    Sheets("消峰平谷").Range(Cells(8, 1), Cells(38, 10)).Select
    Dim cell As Variant
    For Each cell In Selection
        If cell.HasFormula = False Then cell.ClearContents
    Next cell

    Dim 日期 As Date
    日期 = Sheets("消峰平谷").Cells(4, 10).value
    Dim 开始日期 As Date
'    If Day(日期) <= 31 Then
'        开始日期 = CStr(Year(日期)) + "-" + CStr(Month(日期)) + "-" + "01"
'    Else
'        开始日期 = CStr(Year(日期)) + "-" + CStr(Month(日期)) + "-" + "16"
'    End If
    Dim row As Integer
    Dim column As Integer
    Dim i As Integer
    Dim d As Date
'    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim SQL As String
    Dim filter As String
    Dim 名称 As String
    Dim 单位 As String
    开始日期 = CStr(Year(日期)) + "-" + CStr(Month(日期)) + "-" + "01"
    For i = 0 To (日期 - 开始日期)
        row = 8
        column = 1
        d = DateAdd("d", i, 开始日期)
        Worksheets("消峰平谷").Cells(row + i, column).value = d
        filter = "日期= '" + Format(d, "yyyy-mm-dd") + "'"
'        轻油
        SQL = "SELECT 数据 FROM 生产信息  WHERE " & filter & " and 名称='轻油回收量' and 单位='方' "
        Worksheets("消峰平谷").Cells(row + i, column + 1).CopyFromRecordset psql.cnn.Execute(SQL)
        SQL = "SELECT 数据 FROM 生产信息  WHERE " & filter & " and 名称='数据库轻油回收量' and 单位='方' "
        Worksheets("消峰平谷").Cells(row + i, column + 3).CopyFromRecordset psql.cnn.Execute(SQL)
        
        SQL = "SELECT 数据 FROM 生产信息  WHERE " & filter & " and 名称='轻油处理量' and 单位='方' "
        Worksheets("消峰平谷").Cells(row + i, column + 7).CopyFromRecordset psql.cnn.Execute(SQL)
        
        SQL = "SELECT 数据 FROM 生产信息  WHERE " & filter & " and 名称='数据库轻油处理收量' and 单位='方' "
        Worksheets("消峰平谷").Cells(row + i, column + 9).CopyFromRecordset psql.cnn.Execute(SQL)
'        丙丁烷
        SQL = "SELECT 数据 FROM 生产信息  WHERE " & filter & " and 名称='丙丁烷回收量' and 单位='方' "
        Worksheets("消峰平谷").Cells(row + i, column + 4).CopyFromRecordset psql.cnn.Execute(SQL)
        SQL = "SELECT 数据 FROM 生产信息  WHERE " & filter & " and 名称='数据库丙丁烷回收量' and 单位='方' "
        Worksheets("消峰平谷").Cells(row + i, column + 6).CopyFromRecordset psql.cnn.Execute(SQL)
'        当天非数据库数据
        If Worksheets("消峰平谷").Cells(row + i, column).value = 日期 And 日期 = Worksheets("生产日报").Cells(2, 1).value Then
'            Debug.Print [日期] & " " & 日期
            Worksheets("消峰平谷").Cells(row + i, column + 1).value = [轻油回收量数据]
            Worksheets("消峰平谷").Cells(row + i, column + 4).value = [丙丁烷回收量数据]
            Worksheets("消峰平谷").Cells(row + i, column + 7).value = [轻油处理量数据]
        End If
        
'        保留两位小数
        For column = 1 To 10
            Select Case column
                Case 1, 4, 7
                    Worksheets("消峰平谷").Cells(row + i, column + 1).value = Round(Worksheets("消峰平谷").Cells(row + i, column + 1).value, 2)
            End Select
        Next column
    Next i
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 生产日报_Click()
    Worksheets("生产日报").Select
End Sub

Private Sub 数据提取_Click()
On Error GoTo ErrorHandler
    Dim sd As String
    Dim d As Date
    If IsEmpty(Worksheets("消峰平谷").Cells(4, 10)) Then
        sd = InputBox("请输入指定日期：", "自动统计到指定日期的半月统计", Format(DateAdd("d", -1, Now), "YYYY-MM-DD"))
        If False = IsDate(sd) Then
            MsgBox "日期不正确!"
            Exit Sub
        End If
        d = CDate(sd)
        Worksheets("消峰平谷").Cells(4, 10).value = d
    End If
    Call 自动填数
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub
