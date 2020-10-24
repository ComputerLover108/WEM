VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet10"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit
Dim 日期 As Date
Dim row As Integer
Dim column As Integer
Dim roffset As Integer
Dim coffset As Integer
Private Sub 本月_Click()
    日期 = Now()
    row = 2
    column = 19
    Worksheets("生产月报").Range(Cells(row, column), Cells(row, column + 2)).Select
    Selection.value = 日期
    row = 6
    column = 1
    roffset = 30
    coffset = 25
    Worksheets("生产月报").Range(Cells(row, column), Cells(row + roffset, column + coffset)).ClearContents
    Dim scyb As New 生产月报
    Call scyb.填数
End Sub

Private Sub 返回_Click()
    Worksheets("工艺生产").Select
End Sub

Private Sub 返回主页_Click()
    Worksheets("主页").Select
End Sub

Private Sub 清除_Click()
    row = 2
    column = 19
    Worksheets("生产月报").Range(Cells(row, column), Cells(row, column + 2)).Select
    Selection.ClearContents
    row = 6
    column = 1
    roffset = 30
    coffset = 25
    Worksheets("生产月报").Range(Cells(row, column), Cells(row + roffset, column + coffset)).ClearContents
End Sub

Private Sub 指定日期_Click()
    Dim sd As String
    Dim d As Date
    sd = InputBox("请输入指定日期：", "自动统计到指定日期的当月统计", DateValue(Now))
    If False = IsDate(sd) Then
        MsgBox "日期不正确!"
        Exit Sub
    End If
    d = CDate(sd)
    row = 2
    column = 19
    Worksheets("生产月报").Range(Cells(row, column), Cells(row, column + 2)).Select
    Selection.value = d
    row = 6
    column = 2
    roffset = 30
    coffset = 19
    Worksheets("生产月报").Range(Cells(row, column), Cells(row + roffset, column + coffset)).ClearContents
    Dim scyb As New 生产月报
    Call scyb.填数
    
End Sub

'Private Sub 自动填写_Click()
'    row = 6
'    column = 2
'    Roffset = 30
'    Coffset = 19
'    Worksheets("生产月报").Range(Cells(row, column), Cells(row + Roffset, column + Coffset)).ClearContents
'    Dim scyb As New 生产月报
'    Call scyb.填数
'End Sub
