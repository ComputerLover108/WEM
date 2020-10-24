VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet6"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Private Sub CommandButton1_Click()
    Sheets("主页").Select
End Sub

Private Sub CommandButton2_Click()
    Sheets("生产日报").Select
End Sub

Private Sub 今日检查_Click()
    Call 清除_Click
    Dim 原日期 As Date
    原日期 = [日期]
    [日期] = DateValue(Now)
    Call Sheets("生产日报").昨日数据_Click
    [日期] = 原日期
End Sub

Public Sub 清除_Click()
'    Const rowLimit = 65535
'    Const columnLimit = 256
'    Dim row As Long
'    Dim column As Long
'    Dim LastRow As Long
'    Dim LastColumn As Long
'    row = 3
'    column = 1
'    LastRow = Range("a4:a65535").End(xlDown).row
'    LastColumn = Range(Cells(row, column), Cells(row, columnLimit)).End(xlToRight).column
'    Range(Cells(row + 1, column), Cells(LastRow + 1, LastColumn)).ClearContents
    Worksheets("相关数据").Range(Cells(4, 1), Cells(128, 11)).ClearContents
End Sub
