VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet19"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private Sub 查询_Click()
On Error GoTo handler
    Dim sd As String
    Dim d As Date
    sd = InputBox("请输入指定日期：", "查询指定日期的轻烃超装月报", DateValue(Now))
    If False = IsDate(sd) Then
        MsgBox "日期不正确!"
        Exit Sub
    End If
    d = CDate(sd)
    Call Worksheets("超装月报").清除_Click
    Cells(1, 29).value = d
    Dim rst As New ADODB.Recordset
    
    Dim 客户数量, 行数 As Long
    Dim ac As New access
    Dim SQL As String
    Dim tablename As String
    Dim filter1, filter2 As String
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
    Dim 开始日期, 结束日期, 日期 As Date
    结束日期 = d
    开始日期 = DateSerial(Year(结束日期), Month(结束日期), 1)
    tablename = "提单"
    filter1 = " WHERE 日期 between #" & 开始日期 & "# and #" & 结束日期 & "#" & " and 产品名称 <> '轻油' "
'    SQL = "SELECT SUM(客户出现的最大次数) FROM ( SELECT 客户名称, MAX(客户出现次数) as 客户出现的最大次数 FROM ( SELECT 日期, 客户名称, COUNT(客户名称) AS 客户出现次数 FROM " & tableName & filter1 & " GROUP BY 日期, 客户名称) as T1 GROUP BY 客户名称) as T2 "
'    行数 = ac.cnn.Execute(SQL)(0)
    SQL = "SELECT 客户名称, MAX(客户出现次数) as 客户出现的最大次数 FROM ( SELECT 日期, 客户名称, COUNT(客户名称) AS 客户出现次数 FROM " & tablename & filter1 & " GROUP BY 日期, 客户名称) as T1  GROUP BY 客户名称 ORDER BY 客户名称"
    rst.Open SQL, ac.cnn, adOpenKeyset, adLockBatchOptimistic
    Dim 客户 As String
    Dim 客户提单数 As Long
    Do While Not rst.EOF
'        table.Add rst.Fields.Item(0), rst.Fields.Item(1)
        客户 = rst.Fields.item(0)
        客户提单数 = rst.Fields.item(1)
        table.Add 客户, 客户提单数
        rst.MoveNext
    Loop
    rst.Close
    Set rst = Nothing
    Dim item As Variant
    Dim i, j As Long
    Dim row, column, beginRow, beginColumn, lastRow, lastColumn, rowLimit, columnLimit As Long
    Dim 客户名称 As String
    Dim 天数 As Long
    天数 = DateDiff("d", 开始日期, 结束日期)
    beginRow = 3
    row = 0
    For Each item In table.Keys
        For j = 0 To 天数
            beginColumn = 2
            日期 = DateAdd("d", j, 开始日期)
            客户名称 = item
            SQL = "select 实际装车t-计划装车t as 超装t from " & tablename & " where 客户名称='" & 客户名称 & "' and 日期=#" & 日期 & "#" & " order by 实际装车t-计划装车t"
            Cells(beginRow + row, beginColumn + j).CopyFromRecordset ac.cnn.Execute(SQL)
'            Debug.Print SQL
        Next j
        For i = 1 To table(item)
            beginColumn = 1
            Cells(beginRow + row, beginColumn).value = item
            row = row + 1
        Next
    Next item
'    没有超装的打横线
    rowLimit = Rows.count
    columnLimit = Columns.count
    lastRow = Range(Cells(beginRow, beginColumn), Cells(rowLimit, beginColumn)).End(xlDown).row
    lastColumn = 32
    For row = beginRow To lastRow
        For column = beginColumn To lastColumn
            If Cells(row, column).value <= 0 And Not IsEmpty(Cells(row, column)) Then
                Cells(row, column).value = "-"
            End If
        Next column
    Next row
handler:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 工艺_Click()
    Worksheets("工艺生产").Select
End Sub

Public Sub 清除_Click()
    Dim beginRow, beginColumn, lastRow, lastColumn, rowLimit, columnLimit As Long
    beginRow = 3
    beginColumn = 1
    rowLimit = Rows.count
    columnLimit = Columns.count
    lastRow = Range(Cells(beginRow, beginColumn), Cells(rowLimit, beginColumn)).End(xlDown).row
    lastColumn = Range(Cells(beginRow, beginColumn), Cells(beginRow, columnLimit)).End(xlToRight).column
    If lastRow < 3 Then
        lastRow = 3
    End If
'    If lastColumn < 32 Then
'        lastColumn = 32
'    End If
    lastColumn = 32
    Range("AC1:AF1").ClearContents
    Range(Cells(beginRow, beginColumn), Cells(lastRow, lastColumn)).ClearContents
End Sub

Private Sub 提单_Click()
    Worksheets("提单").Select
End Sub

Private Sub 主页_Click()
    Worksheets("主页").Select
End Sub
