VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Private Sub CommandButton1_Click()
On Error Resume Next
    Sheets("生产日报").Select
    Sheets("生产日报").Range("A1:I1").Select
End Sub


Private Sub CommandButton4_Click()
On Error Resume Next
    Worksheets("提单").Select
End Sub
'显示生产信息
Private Sub CommandButton5_Click()
On Error Resume Next
    生产信息查询.Show
End Sub

Private Sub 海管_Click()
On Error Resume Next
    Worksheets("海管").Select
End Sub

Private Sub 返回主页_Click()
On Error Resume Next
    Sheets("主页").Select
End Sub

Private Sub 海管跟踪数据_Click()
On Error Resume Next
    Worksheets("12寸海管跟踪数据").Select
End Sub

Private Sub 化验_Click()
    On Error Resume Next
    Worksheets("化验").Select
End Sub

Private Sub 快速录入_Click()
On Error Resume Next
    Worksheets("快速录入").Select
End Sub

Private Sub 盘库报表_Click()
On Error Resume Next
    Worksheets("盘库报表").Select
End Sub

Private Sub 上游_Click()
On Error Resume Next
    Worksheets("上游").Select
End Sub

Private Sub 生产动态_Click()
On Error Resume Next
    生产动态查询.Show
End Sub

Private Sub 生产年报_Click()
On Error Resume Next
    Worksheets("生产年报").Select
End Sub

Private Sub 生产月报_Click()
On Error Resume Next
    Worksheets("生产月报").Select
End Sub

Private Sub 消峰平谷_Click()
On Error Resume Next
    Worksheets("消峰平谷").Select
End Sub


