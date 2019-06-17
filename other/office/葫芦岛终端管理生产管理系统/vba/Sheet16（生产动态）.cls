VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet16"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Private Sub 主页_Click()
    Worksheets("主页").Select
End Sub
Private Sub 工艺_Click()
    Worksheets("工艺生产").Select
End Sub

Public Sub 清除_Click()
    Dim rowLimit As Long
    Dim columnLimit As Integer
'    清除有效数据区域
    rowLimit = Range("a65535").End(xlUp).row
    columnLimit = Range(Cells(3, 1), Cells(3, 128)).End(xlToRight).column
    With ActiveSheet.UsedRange
        Range(Cells(4, 1), Cells(rowLimit, columnLimit)).Select
    End With
    Selection.ClearContents
'    清除图表
    Dim x, cx
    For Each x In Sheets("生产动态").ChartObjects
        x.Delete
    Next x
End Sub
Private Sub 真实清除_Click()
Err.Clear
On Error GoTo ErrorHandler
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
        backupDB = ThisWorkbook.path & Application.PathSeparator & Format(Now, "YYYY年MM月DD日HH点MM分SS秒") & " 葫芦岛天然气处理厂.mdb"
        fs.CopyFile DBname, backupDB, True
'        数据库删除数据
        Dim rowLimit As Long
        Dim columnLimit As Long
        rowLimit = Range("a65535").End(xlUp).row
        Dim row As Long
        Dim ac As New access
        Dim psql As New PostgreSQL
        Dim SQL As String
        Dim tablename As String
        tablename = "生产动态"
        Dim 时间 As Date
        Dim 名称 As String
        Dim 单位 As String
        For row = 4 To rowLimit
            If Rows(row).Hidden = False Then
                时间 = Cells(row, 1).value
                名称 = Cells(row, 2).value
                单位 = Cells(row, 3).value
                If Not IsEmpty(Cells(row, 1).value) And Not IsNull(Cells(row, 1).value) Then
                    SQL = "delete from " & tablename & " where 时间 = #" & 时间 & "# and 名称 = '" & 名称 & "' and 单位 = '" & 单位 & "'"
                    Call ac.cnn.Execute(SQL)
                    SQL = "delete from " & tablename & " where 时间 = '" & 时间 & "' and 名称 = '" & 名称 & "' and 单位 = '" & 单位 & "'"
                    Call psql.cnn.Execute(SQL)
                    Rows(row).ClearContents
                End If
            End If
        Next row
    Else
        MsgBox "密码不对！禁止危险操作！"
        Exit Sub
    End If
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
'    PostgreSQL 未连接代码 -2147467259
    If -2147467259 = Err.Number Then
        MsgBox "PostgreSQL 数据库没有打开！"
        Exit Sub
    End If

End Sub


