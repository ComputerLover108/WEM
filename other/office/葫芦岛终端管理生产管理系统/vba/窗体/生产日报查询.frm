VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} 生产日报查询 
   Caption         =   "生产日报"
   ClientHeight    =   3000
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   3840
   OleObjectBlob   =   "生产日报查询.frx":0000
   StartUpPosition =   1  '所有者中心
End
Attribute VB_Name = "生产日报查询"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim DBname As String
Dim fname As String


Private Sub UserForm_Click()

End Sub

Private Sub 查询_Click()
    Dim sd As String
    sd = TextBox1.value
    If IsDate(sd) Then
        Dim cnn As Object
        Dim rst As Object
        Set cnn = CreateObject("ADODB.Connection")
        Set rst = CreateObject("ADODB.recordset")
'        Dim DBname As String
        DBname = ActiveWorkbook.path & Application.PathSeparator & "葫芦岛天然气处理厂.mdb"
        With cnn
            .Provider = "Microsoft.Jet.OLEDB.4.0"
            .Open DBname
        End With
        Dim SQL
        SQL = "select 数据源 from " & "生产信息 where 日期=#" & sd & "#" & " and 名称='入厂计量' "
'        Debug.Print SQL
        Set rst = cnn.Execute(SQL)
'        Dim fname As String
        If rst.EOF And rst.BOF Then
            MsgBox "没有找到备份文件!"
        Else
            fname = rst("数据源")
            Application.Workbooks.Open (fname)
        End If
'        Debug.Print fname
        ' 关闭连接并清理内存
        rst.Close
        cnn.Close
        Set rst = Nothing
        Set cnn = Nothing
    Else
        MsgBox "没有输入正确的日期格式！"
    End If
    Unload 生产日报查询
End Sub

Private Sub UserForm_initialize()
'        Dim DBname As String
'        Dim fname As String
    TextBox1.value = Date - 1
End Sub
Private Sub UserForm_Terminate()
'    Application.Workbooks(fname).Close
End Sub
