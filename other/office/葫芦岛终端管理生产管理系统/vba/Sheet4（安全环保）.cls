VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet4"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Private Sub CommandButton1_Click()
    Sheets("主页").Select
End Sub

Private Sub CommandButton2_Click()
    Dim h As New help
'    Debug.Print Worksheets.count
    If Not h.hasSheet("人员信息", ActiveWorkbook) Then
        Worksheets.Add count:=1, after:=Worksheets(Worksheets.count)
        ActiveSheet.name = "人员信息"
    End If
'   access
    Dim fileName As String
    fileName = ActiveWorkbook.path & Application.PathSeparator & "葫芦岛天然气处理厂.mdb"
    Dim oQryTable As Object
    Set oQryTable = Worksheets("人员信息").QueryTables.Add( _
    "OLEDB;Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & _
       fileName & ";", Worksheets("人员信息").Range("A1"), "Select * from 人员信息")
    oQryTable.RefreshStyle = xlInsertEntireRows
    oQryTable.Refresh False
'    Dim cnn As Object
'    Dim rst As Object
'    Set cnn = CreateObject("ADODB.Connection")
'    Set rst = CreateObject("ADODB.recordset")
'    With cnn
'        .Provider = "Microsoft.Jet.OLEDB.4.0"
'        .Open fileName
'    End With
''    '将数据传递到Excel
'    Dim cpos As String
'    cpos = "A" & CStr(beginRow)
''    Debug.Print cpos
'    Dim SQL As String
'    Dim tableName As String
'    tableName = "人员信息"
'    Dim showFileds As String
'    showFileds = "*"
''    Dim filter As String
''    SQL = "select " & showFiles & " from " & tableName & " where " & filter
'    SQL = "select * from 人员信息"
''    Set rst = cnn.Execute(SQL)
'    rst.Open SQL, cnn
'    Worksheets("人员信息").Range("A1").CopyFromRecordset rst
'    ' 关闭连接
'    rst.Close
'    cnn.Close
'    Set rst = Nothing
'    Set cnn = Nothing
'
    Worksheets("人员信息").Select
    Selection.AutoFilter
'    Worksheets("人员信息").Delete
'    ActiveWindow.SelectedSheets.Delete
End Sub
