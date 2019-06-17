VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet14"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private Sub 返回_Click()
    Worksheets("工艺生产").Select
End Sub

Private Sub 返回主页_Click()
    Worksheets("主页").Select
End Sub

Private Sub 间隔时间_Click()
On Error GoTo handler
    Dim t, tn As Date
    Dim beginRow, beginColumn, offset, count As Long
    Dim jg As Integer
    
    jg = InputBox("请输入间隔时间(分钟)：", "自动产生记录报表", 60)
    beginRow = 5
    beginColumn = 1
    offset = 5
    count = 0
    t = DateValue(Now)
    tn = DateAdd("d", 1, DateValue(Now))
    While t < tn
        Debug.Print t, tn, beginRow + count
        Cells(beginRow + count, beginColumn).value = FormatDateTime(t, vbShortTime)
        Cells(beginRow + count, beginColumn + offset).value = FormatDateTime(t, vbShortTime)
        t = DateAdd("n", jg, t)
        count = count + 1
    Wend
'    Columns(beginColumn).NumberFormat = "hh:mm"
'    Columns(beginColumn + offset).NumberFormat = "hh:mm"
    Worksheets("海管").Cells(2, 1).value = DateValue(Now)
handler:
    If Err.Number <> 0 Then
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub

Private Sub 快速录入_Click()
    Worksheets("快速录入").Select
End Sub

Private Sub 制表_Click()

End Sub

Public Sub test()
    Dim scdt As New 生产动态
    Call scdt.reCreateTable
End Sub

Private Sub 清除_Click()
    Worksheets("海管").Cells(2, 19).ClearContents
    Dim beginRow, beginColumn, lastRow, lastColumn, ro, co As Long
    beginRow = 5
    beginColumn = 1
    ro = -1
    co = 10
    lastRow = Worksheets("海管").UsedRange.Rows.count
    lastColumn = Worksheets("海管").UsedRange.Columns.count
'    Debug.Print lastRow & vbTab & lastColumn
    If beginRow <= lastRow And beginColumn <= lastColumn Then
        Range(Cells(beginRow, beginColumn), Cells(lastRow, lastColumn)).ClearContents
        Range(Cells(beginRow + ro, beginColumn + co), Cells(lastRow, lastColumn)).Clear
    End If
    Range(Cells(2, 1), Cells(2, 9)).ClearContents
'    Dim cell As Variant
'    For Each cell In Selection
'        If cell.HasFormula = False Then cell.ClearContents
'    Next cell
    Cells(beginRow, beginColumn + 1).Select
End Sub

Sub 保存_Click()
Err.Clear
On Error GoTo ErrorHandler
    Dim scdt As New 生产动态
    Dim tablename As String
    Dim SQL As String
    tablename = "生产动态"
    Dim temp As Variant
    Dim 记录时间 As Date
    Dim 名称 As String
    Dim 单位 As String
    Dim 数据 As Double
    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim row As Long
    Dim column As Long
    Dim rowLimit As Long
    rowLimit = Worksheets("海管").Range("a65535").End(xlUp).row
    If rowLimit < Worksheets("海管").Range("f65535").End(xlUp).row Then
        rowLimit = Worksheets("海管").Range("f65535").End(xlUp).row
    End If
    Const columnLimit = 10
    Dim st As String
    Dim 日期 As Date
    Dim 时间 As Date
    If IsNull(Worksheets("海管").Cells(2, 1)) Or IsEmpty(Worksheets("海管").Cells(2, 1)) Then
        日期 = DateValue(Now)
    Else
        日期 = DateValue(Worksheets("海管").Cells(2, 1).value)
    End If
    Dim sd As String
    For row = 5 To rowLimit
'        向数据库中插入上游数据 压力 温度 流量
        For column = 2 To columnLimit
                Select Case column
                    Case 2
                        名称 = "上游压力"
                        单位 = "兆帕"
                    Case 3
                        名称 = "上游温度"
                        单位 = "摄氏度"
                    Case 4
                        名称 = "上游流量"
                        单位 = "方/小时"
                    Case 7
                        名称 = "下游压力"
                        单位 = "兆帕"
                    Case 8
                        名称 = "下游温度"
                        单位 = "摄氏度"
                    Case 9
                        名称 = "下游流量"
                        单位 = "方/小时"
                End Select
                If column < 6 Then
                    时间 = Cells(row, 1).value
                Else
                    时间 = Cells(row, 6).value
                End If
                sd = FormatDateTime(时间, vbShortTime)
'                记录时间 = FormatDateTime(日期, vbLongDate) + sd
                记录时间 = 日期 + sd
                If column = 2 Or column = 3 Or column = 4 Or column = 7 Or column = 8 Or column = 9 Then
                    temp = Cells(row, column).value
                End If
                If Not IsEmpty(temp) And Not IsNull(temp) And temp <> "" Then
                    数据 = CDbl(temp)
                    If 数据 >= 1000 And column = 2 Then
                        名称 = "上游流量"
                        单位 = "方/小时"
                    End If
                    If 数据 >= 1000 And column = 7 Then
                        名称 = "下游流量"
                        单位 = "方/小时"
                    End If
            '        删除可能记录在数据库中数据
                    SQL = "delete from " & tablename & " where 时间= '" & 记录时间 & "' and 名称 = '" & 名称 & "'"
                    Call psql.cnn.Execute(SQL)
                    SQL = "INSERT INTO " & tablename & " ( 时间,名称,单位,数据,类别) VALUES ( '" & 记录时间 & "','" & 名称 & "','" & 单位 & "'," & 数据 & ",'海管')"
                    Call psql.cnn.Execute(SQL)
                End If
        Next column
    Next row
    SQL = " UPDATE " & tablename & " SET 类别='海管' where 名称 IN ('上游压力','上游温度','上游流量','下游压力','下游温度','下游流量')"
'    ac.cnn.Execute (SQL)
    psql.cnn.Execute (SQL)
    MsgBox ("数据已存入数据库！")
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub

Private Sub 查看指定日期_Click()
    Err.Clear
On Error GoTo errorhander
'    Call 清除_Click
    Dim sd As String
    Dim d As Date
    sd = InputBox("请输入指定日期：", "上下游海管半小时一记", Format(Now, "YYYY-MM-dd"))
    If False = IsDate(sd) Then
        MsgBox "日期不正确!"
        Exit Sub
    End If
    Worksheets("海管").Cells(2, 1).value = DateValue(sd)
    Dim ac As New access
    Dim rst As New ADODB.Recordset
    Dim filter As String
    Dim SQL As String
    filter = "where datevalue(时间)= #" & sd & "# and 类别='海管' "
    SQL = "select distinct 时间 from 生产动态  " & filter
    Dim beginRow, beginColumn, ro, co As Long
    beginRow = 4
    beginColumn = 11
    co = 0
    Dim 元素, 标题 As Variant
    标题 = Array("时间", "上游压力", "上游温度", "上游流量", "下游压力", "下游温度", "下游流量", "压差", "温差", "量差")
    For Each 元素 In 标题
        Cells(beginRow, beginColumn + co).value = 元素
        co = co + 1
    Next 元素
    Worksheets("海管").Cells(beginRow + 1, beginColumn).CopyFromRecordset ac.cnn.Execute(SQL)
    Dim row, column, lastRow, lastColumn As Long
    lastRow = Worksheets("海管").UsedRange.Rows.count
    lastColumn = 17
    ro = 1
    co = 1
    Dim temp1, temp2 As Variant
    For row = beginRow + ro To lastRow
        If Not IsEmpty(Worksheets("海管").Cells(row, beginColumn)) Then
            d = Worksheets("海管").Cells(row, beginColumn).value
        Else
            Exit For
        End If
        For column = beginColumn + co To lastColumn
            Select Case column
                Case beginColumn + 1
                    filter = " where 时间=#" & d & "# and 类别='海管' and 名称='上游压力'"
                Case beginColumn + 2
                    filter = " where 时间=#" & d & "# and 类别='海管' and 名称='上游温度'"
                Case beginColumn + 3
                    filter = " where 时间=#" & d & "# and 类别='海管' and 名称='上游流量'"
                Case beginColumn + 4
                    filter = " where 时间=#" & d & "# and 类别='海管' and 名称='下游压力'"
                Case beginColumn + 5
                    filter = " where 时间=#" & d & "# and 类别='海管' and 名称='下游温度'"
                Case beginColumn + 6
                    filter = " where 时间=#" & d & "# and 类别='海管' and 名称='下游流量'"
            End Select
            SQL = "select 数据 from 生产动态 " & filter
            Worksheets("海管").Cells(row, column).CopyFromRecordset ac.cnn.Execute(SQL)
        Next column
        For column = beginColumn + 7 To beginColumn + 10
            If column >= beginColumn + 7 And column <= beginColumn + 9 Then
                temp1 = Cells(row, column - 6)
                temp2 = Cells(row, column - 3)
                If IsEmpty(temp1) Or IsEmpty(temp2) Then
'                    Debug.Print temp1 & vbTab & IsNull(temp1) & vbTab & temp2 & vbTab & IsNull(temp2)
'                    Debug.Print row & "," & column
                Else
                    Cells(row, column).value = Cells(row, column - 6).value - Cells(row, column - 3).value
                End If
            End If
        Next column
'        Debug.Print row
    Next row
'    Debug.Print UBound(标题)
    Columns(beginColumn).NumberFormatLocal = "h:mm;@"
    Range(Cells(beginRow, beginColumn), Cells(beginRow, beginColumn + UBound(标题))).Select
'    Selection.Columns.AutoFit
    Range("K4:T4").Select
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    Range("L4:N4").Select
    With Selection.Interior
        .pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent1
        .TintAndShade = 0.799981688894314
        .PatternTintAndShade = 0
    End With
    Range("O4:Q4").Select
    With Selection.Interior
        .pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 5296274
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    Range("K4").Select
    Selection.Font.Bold = True
    
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 通球_Click()
On Error GoTo handler:
    Call 清除_Click
    Dim sd As String
'    Dim d As Date
    sd = InputBox("请输入开始时间：", "上下游通球记录", Now)
    If False = IsDate(sd) Then
        MsgBox "时间不正确!"
        Exit Sub
    End If
    Dim 时间间隔, 估计通球时间 As Long
    时间间隔 = InputBox("请输入间隔时间（分钟）：", "上下游通球记录", 15)
    估计通球时间 = 5
    Dim beginRow, beginColumn, offset, count As Long
    beginRow = 5
    beginColumn = 1
    offset = 5
    Dim hour, minute, second As Long
    second = 0
    Dim 估计结束时间, 时间 As Date
    时间 = CDate(sd)
    估计结束时间 = DateAdd("h", 估计通球时间, sd)
    Do Until 时间 > 估计结束时间
        Cells(beginRow + count, beginColumn).value = 时间
        Cells(beginRow + count, beginColumn + offset).value = 时间
        hour = DatePart("h", 时间)
        minute = DatePart("n", 时间)
        minute = Int(minute / 时间间隔) * 时间间隔
        时间 = DateValue(时间) + TimeSerial(hour, minute, second)
        时间 = DateAdd("n", 时间间隔, 时间)
        count = count + 1
'        Debug.Print 时间
    Loop
    Columns(beginColumn).NumberFormatLocal = "h:mm;@"
    Columns(beginColumn + offset).NumberFormatLocal = "h:mm;@"
    Worksheets("海管").Cells(2, 1).value = DateValue(Now)
handler:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub
