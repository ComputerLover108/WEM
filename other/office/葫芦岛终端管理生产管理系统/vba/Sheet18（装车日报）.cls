VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet18"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private Sub 打印_Click()
    Worksheets("装车日报").PrintOut
End Sub

Private Sub 工艺_Click()
    Worksheets("工艺生产").Select
End Sub

Public Sub 清除_Click()
    Dim beginRow As Long
    Dim beginColumn As Long
    Dim rowLimit As Long
    Dim columnLimit As Long
    beginRow = 2
    beginColumn = 4
    Cells(beginRow, beginColumn).Select
    Selection.ClearContents
    beginRow = 4
    beginColumn = 1
    rowLimit = 22
    columnLimit = 6
    Range(Cells(beginRow, beginColumn), Cells(rowLimit, columnLimit)).ClearContents
    beginRow = 24
    Range(Cells(beginRow, beginColumn + 1), Cells(beginRow, columnLimit)).ClearContents
End Sub

Private Sub 提单_Click()
    Worksheets("提单").Select
End Sub

Private Sub 主页_Click()
    Worksheets("主页").Select
End Sub

Public Sub 昨累_Click()
On Error GoTo handler
'    昨月累
    Dim d As Date
    d = Worksheets("装车日报").Cells(2, 4).value
    Dim row As Long
    Dim column As Long
    Dim columnLimit As Long
    Dim SQL As String
'    Dim ac As New access
    Dim psql As New PostgreSQL
    columnLimit = 6
    row = 24
    Dim showFields As String
    Dim filter As String
    showFields = " sum(数据) as 月累 "
    Dim 月初 As String
    月初 = DateSerial(Year(d), Month(d), 1)
    If d = 月初 Then
        For column = 2 To columnLimit
            Worksheets("装车日报").Cells(row, column).value = 0
        Next column
    Else
        filter = "日期 >= " & "'" & 月初 & "'" & " and 日期 < " & "'" & d & "'"
    '    丙烷外输
        SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='丙烷装车' and 单位='吨' "
'        Debug.Print SQL
        Worksheets("装车日报").Cells(row, 2).CopyFromRecordset psql.cnn.Execute(SQL)
    '    丁烷外输
        SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='丁烷装车' and 单位='吨' "
        Worksheets("装车日报").Cells(row, 3).CopyFromRecordset psql.cnn.Execute(SQL)
    '    液化气外输
        SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='液化气装车' and 单位='吨' "
        Worksheets("装车日报").Cells(row, 4).CopyFromRecordset psql.cnn.Execute(SQL)
    '    轻油外输t
        SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='轻油装车' and 单位='吨' "
        Worksheets("装车日报").Cells(row, 5).CopyFromRecordset psql.cnn.Execute(SQL)
    '    轻油外输bbl
        SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='轻油装车' and 单位='桶' "
        Worksheets("装车日报").Cells(row, 6).CopyFromRecordset psql.cnn.Execute(SQL)
    End If
handler:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub
