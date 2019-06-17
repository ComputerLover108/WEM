VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private Sub 设备维修_Click()
    Sheets("设备维修").Select
End Sub

Private Sub 安全环保_Click()
    Sheets("安全环保").Select
End Sub

Private Sub 工艺生产_Click()
    Sheets("工艺生产").Select
End Sub

Public Sub 备份数据库()
'    倒班日备份数据库
On Error GoTo ErrorHandler
    Dim d As Integer
    d = Weekday(Now)
    Dim th As New 时间
    If 7 = d Or 4 = d Or 15 = Day(Now) Or th.isMonthEnd(d) Then
        Dim sd As String
        sd = DateValue(Now)
        Dim fs As Object
        Set fs = CreateObject("Scripting.FileSystemObject")
        Dim backupDB As String
        Dim DBname As String
        DBname = ThisWorkbook.path & Application.PathSeparator & "葫芦岛天然气处理厂.mdb"
        backupDB = ThisWorkbook.path & Application.PathSeparator & Format(sd, "YYYY-MM-DD") & " 葫芦岛天然气处理厂.mdb"
        Kill backupDB
'        压缩数据库
        Dim jro As New jro.JetEngine
        jro.CompactDatabase "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & DBname, "Provider=Microsoft.Jet.OLEDB.4.0;Data Source= " & backupDB
'        压缩后数据库替换原数据库
        If fs.FileExists(backupDB) Then
            fs.CopyFile backupDB, DBname, True
        End If
'        Dim scxx As New 生产信息
'        Call scxx.AccessToPostgreSQL
    End If
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 维护_Click()
   Sheets("维护").Select
End Sub
