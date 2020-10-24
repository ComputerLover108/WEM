VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet17"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit
Public Function getRecords(ByRef table As Object)
On Error GoTo handler
    Dim row As Long
    Dim column As Long
    Dim lastRow As Long
    Dim lastColumn As Long
    Dim rowLimit As Long
    Dim columnLimit As Long
    Dim beginRow As Long
    Dim beginColumn As Long
    beginRow = 3
    beginColumn = 1
    rowLimit = Rows.count
    columnLimit = Columns.count
    lastRow = Range(Cells(beginRow, beginColumn), Cells(rowLimit, beginColumn)).End(xlDown).row
    lastColumn = Range(Cells(beginRow, beginColumn), Cells(beginRow, columnLimit)).End(xlToRight).column
    If lastRow = rowLimit Then
        MsgBox ("请重新填写有效数据!")
        Exit Function
    End If
    Dim 日期 As Date
    Dim 提单号 As String
    Dim 产品名称 As String
    Dim 客户名称 As String
    Dim 计划装车t As Double
    Dim 实际装车t As Double
    Dim 实际装车m3 As Double
    Dim 实际装车bbl As Double
    Dim 装车数量 As Long
    Dim 备注 As String
    Dim record As New 提单
    beginRow = beginRow
    Dim temp As String
    Dim tc1 As New Collection
    Dim tc2 As New Dictionary
    For row = beginRow + 1 To lastRow
        For column = beginColumn To lastColumn
            temp = Cells(beginRow, column).value
            Select Case temp
                Case "日期"
                    日期 = Cells(row, column).value
                Case "产品名称"
                    产品名称 = Cells(row, column).value
                Case "客户名称"
                    客户名称 = Trim(Cells(row, column).value)
                Case "计划装车t"
                    计划装车t = Cells(row, column).value
                Case "实际装车t"
                    实际装车t = Cells(row, column).value
                Case "实际装车m3"
                    实际装车m3 = Cells(row, column).value
                Case "实际装车bbl"
                    实际装车bbl = Cells(row, column).value
                Case "装车数量"
                    装车数量 = Cells(row, column).value
                Case "备注"
                    备注 = Cells(row, column).value
                Case "提单号"
                    提单号 = Cells(row, column).value
                    提单号 = UCase(提单号)
            End Select
        Next
        If 实际装车t > 0 And 提单号 = "" Then
            getRecords = False
            MsgBox ("提单号必须填，提单号在提单右上角，轻油格式：“JZ年月序号”，例如：JZ141117代表：2014年11月17号提单；轻烃提单号为：提单右上角红色数字序号.")
            Exit Function
        End If
        With record
            .日期 = 日期
            .提单号 = 提单号
            .产品名称 = 产品名称
            .客户名称 = 客户名称
            .计划装车t = 计划装车t
            .实际装车t = 实际装车t
            .实际装车m3 = 实际装车m3
            .实际装车bbl = 实际装车bbl
            .装车数量 = 装车数量
            .备注 = 备注
        End With
        If record.提单号 <> "" And record.产品名称 <> "" And record.计划装车t > 0 And record.实际装车t > 0 Then
            tc1.Add (提单号)
            tc2.Add 提单号, ""
            table.Add record, ""
        End If
        Set record = Nothing
    Next row
    If tc1.count > tc2.count Then
        getRecords = False
        MsgBox ("数据有误，请检查！")
        Exit Function
    End If
    getRecords = True
handler:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Function

Private Sub 保存_Click()
On Error GoTo handler
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
    If getRecords(table) = False Then
        Exit Sub
    End If
    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim tablename As String
    tablename = "提单"
    Dim record As New 提单
    If Not ac.hasTable(tablename) Then
        Call record.CreateTable
    End If
'    Call record.dataErase(table)
    Call record.save(table)
'    MsgBox ("数据已存入数据库!")
handler:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Public Sub 查询_Click()
On Error GoTo handler
    提单查询.Show
handler:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 超装月报_Click()
    Worksheets("超装月报").Select
End Sub

Private Sub 工艺_Click()
    Worksheets("工艺生产").Select
End Sub

Private Sub 今日_Click()
On Error GoTo handler
    Call 清除_Click
    Dim row As Long
    Dim column As Long
    Dim lastRow As Long
    Dim rowLimit As Long
    Dim beginRow As Long
    Dim beginColumn As Long
    beginRow = 3
    beginColumn = 12
    rowLimit = Rows.count
    lastRow = Range(Cells(beginRow, beginColumn), Cells(rowLimit, beginColumn)).End(xlDown).row
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
    Dim rst As New ADODB.Recordset
'    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim SQL As String
    Dim arr()
    SQL = "select DISTINCT 客户名称 from 提单 "
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "客户名称")
    rst.Close
    Dim temp As Variant
    For Each temp In arr
        table.Add temp, ""
    Next temp
    For row = beginRow + 1 To lastRow
        temp = Cells(row, beginColumn).value
        table.Add temp, ""
    Next row
'    填写日期,客户名称
    Dim rcolumn As Long
    Dim kcolumn As Long
    Dim i As Long
    rcolumn = 1
    kcolumn = 3
    i = 1
    For Each temp In table.Keys
        If Not IsNull(temp) Or Not IsEmpty(temp) Then
            Cells(beginRow + i, rcolumn).value = DateValue(Now)
            Cells(beginRow + i, kcolumn).value = temp
            i = i + 1
        End If
    Next temp
'    With Worksheets("提单").Sort
'        .SetRange Range("C4:C100")
'        .Header = xlNo
'        .MatchCase = False
'        .Orientation = xlTopToBottom
'        .SortMethod = xlPinYin
'        .Apply
'    End With
    Range("A4:I128").Sort [C3], 1
handler:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Public Sub 清除_Click()
    Dim lastRow As Long
    Dim lastColumn As Long
    Dim rowLimit As Long
    Dim columnLimit As Long
    Dim beginRow As Long
    Dim beginColumn As Long
    beginRow = 3
    beginColumn = 1
    rowLimit = Rows.count
    columnLimit = Columns.count
    lastRow = Range(Cells(beginRow, beginColumn), Cells(rowLimit, beginColumn)).End(xlDown).row
    lastColumn = Range(Cells(beginRow, beginColumn), Cells(beginRow, columnLimit)).End(xlToRight).column
    Range(Cells(beginRow + 1, beginColumn), Cells(lastRow, lastColumn)).ClearContents
'    Range("I:I").Select
'    Debug.Print Selection.FormatConditions(1).Interior.Color
    
'    If LastRow = rowLimit Then
'    Else
'        Range(Cells(BeginRow + 1, BeginColumn), Cells(LastRow, LastColumn)).ClearContents
'    End If
End Sub

Private Sub 提单月报_Click()
    Worksheets("提单月报").Select
End Sub

Private Sub 真实清除_Click()
On Error GoTo handler
    Dim sd As String
    sd = InputBox("请输入密码：", "危险操作！数据库中信息删除后将不能回复！！！", "******")
    Dim h As New help
    If True = h.checkRight(sd) Then
'        备份数据库
        Dim fs As Object
        Set fs = CreateObject("Scripting.FileSystemObject")
        Dim backupDB As String
        Dim DBname As String
        DBname = ThisWorkbook.path & Application.PathSeparator & "葫芦岛天然气处理厂.mdb"
        Dim st As String
        st = Format(Now, "YYYY年MM月DD日HH时MM分SS秒")
        backupDB = ThisWorkbook.path & Application.PathSeparator & st & " 葫芦岛天然气处理厂.mdb"
        fs.CopyFile DBname, backupDB, True
'        数据库删除数据
        Dim table As Object
        Set table = CreateObject("Scripting.Dictionary")
        Call getRecords(table)
        Dim records As New 提单
        Call records.dataErase(table)
'        Call 清除_Click
    Else
        MsgBox "密码不对！禁止危险操作！"
        Exit Sub
    End If
handler:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 主页_Click()
    Worksheets("主页").Select
End Sub

Private Sub 装车日报_Click()
On Error GoTo handler
    Dim sd As String
    Dim d As Date
    sd = InputBox("请输入指定日期：", "自动填写到指定日期的装车日报", DateValue(Now))
    If False = IsDate(sd) Then
        MsgBox "日期不正确!"
        Exit Sub
    End If
    d = CDate(sd)
    Worksheets("装车日报").Select
    Call Worksheets("装车日报").清除_Click
    Dim row As Long
    Dim column As Long
    Dim beginRow As Long
    Dim beginColumn As Long
    Dim rowLimit As Long
    Dim columnLimit As Long
    Dim lastRow As Long
    Dim lastColumn As Long
    Worksheets("装车日报").Cells(2, 4).value = d
'    Dim ac As New access
    Dim psql As New PostgreSQL
    
    Dim SQL As String
    Dim tablename As String
    tablename = "提单"
    rowLimit = 25
    columnLimit = 6
'    填写轻油客户名称
    SQL = "select DISTINCT 客户名称 from " & tablename & " where 日期='" & d & "'" & " and 产品名称='轻油' " & " order by 客户名称"
    beginRow = 4
    beginColumn = 1
    Worksheets("装车日报").Cells(beginRow, beginColumn).CopyFromRecordset psql.cnn.Execute(SQL)
'    统计轻油客户数量
    SQL = "select count(客户名称) from (select DISTINCT 客户名称  from " & tablename & " where 日期='" & d & "'" & " and 产品名称='轻油' ) as T"
    Dim count As Long
    count = psql.cnn.Execute(SQL)(0)
'    填写轻烃客户名称
    SQL = "select DISTINCT 客户名称 from " & tablename & " where 日期='" & d & "'" & " and 产品名称<>'轻油' " & " order by 客户名称"
    beginRow = beginRow + count
    Worksheets("装车日报").Cells(beginRow, beginColumn).CopyFromRecordset psql.cnn.Execute(SQL)
    
    lastRow = Worksheets("装车日报").Range(Worksheets("装车日报").Cells(beginRow, beginColumn), Worksheets("装车日报").Cells(rowLimit, beginColumn)).End(xlDown).row
    Dim 产品名称 As String
    Dim 客户名称 As String
    Dim 数据 As Variant
    beginRow = 4
    beginColumn = 2
    For row = beginRow To lastRow
        客户名称 = Worksheets("装车日报").Cells(row, 1).value
        For column = beginColumn To columnLimit
            Select Case column
                Case 2
                    产品名称 = "丙烷"
                Case 3
                    产品名称 = "丁烷"
                Case 4
                    产品名称 = "液化气"
                Case 5, 6
                    产品名称 = "轻油"
            End Select
            If column < 6 Then
                SQL = "select sum(实际装车t) from " & tablename & " where 产品名称='" & 产品名称 & "' and 日期='" & d & "'" & " and 客户名称='" & 客户名称 & "'"
            End If
            If column = 6 Then
                SQL = "select sum(实际装车bbl) from " & tablename & " where 产品名称='" & 产品名称 & "' and 日期='" & d & "'" & " and 客户名称='" & 客户名称 & "'"
            End If
            数据 = psql.cnn.Execute(SQL)(0)
            If IsNull(数据) Or IsEmpty(数据) Then
            Else
                Worksheets("装车日报").Cells(row, column).value = 数据
            End If
        Next column
    Next row
'    昨月累
    Call Worksheets("装车日报").昨累_Click
    Dim temp, offset As Variant
    offset = 0
    beginRow = 1
    beginColumn = 1
    lastRow = UsedRange.Rows.count
    lastColumn = UsedRange.Columns.count
    Dim dd, key
    Set dd = CreateObject("Scripting.Dictionary")
    dd.Add "丙烷", "实际装车t"
    dd.Add "丁烷", "实际装车t"
    dd.Add "液化气", "实际装车t"
    dd.Add "轻油", "实际装车t"
    For row = beginRow To lastRow
        For column = beginColumn To lastColumn
            temp = Cells(row, column).value
'            If "年累" = temp Then
            If row = 26 And column = 1 Then
                For Each key In dd
                    SQL = "select sum(" & dd(key) & ") from 提单 where 日期 between date_trunc('year',timestamp '" & d & "') and '" & d & "' and 产品名称='" & key & "';"
                    temp = psql.cnn.Execute(SQL)(0)
                    offset = offset + 1
                    Worksheets("装车日报").Cells(row, column + offset).value = temp
                    Debug.Print row, column + offset, Cells(row, column + offset).value
                Next
                Set dd = Nothing
                SQL = "select sum(" & "实际装车bbl" & ") from 提单 where 日期 between date_trunc('year',timestamp '" & d & "') and '" & d & "' and 产品名称='" & "轻油" & "';"
                temp = psql.cnn.Execute(SQL)(0)
                offset = offset + 1
                Worksheets("装车日报").Cells(row, column + offset).value = temp
                Exit Sub
            End If
        Next
    Next
    
handler:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub


Public Sub test()
On Error GoTo handler
    Dim td As New 提单
    Call td.DeleteTable
    Call td.CreateTable
    Call td.DeleteTable
handler:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub


