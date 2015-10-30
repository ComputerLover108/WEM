VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "access"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Const DBname = "葫芦岛天然气处理厂.mdb"
Public cnn As New ADODB.Connection
'测试access类模块
Public Sub test()
'    Dim fname As String
'    fname = ThisWorkbook.Path & Application.PathSeparator & "葫芦岛天然气处理厂.mdb"
'    Call createDB(fname)
End Sub
'初始化access连接
Private Sub Class_Initialize()
    Dim fs As Object
    Set fs = CreateObject("Scripting.FileSystemObject")
    Dim fname As String
    fname = ThisWorkbook.Path & Application.PathSeparator & "葫芦岛天然气处理厂.mdb"
    If Not fs.FileExists(fname) Then
        Call createDB(fname)
    End If
    Dim VersionNumber As String
    VersionNumber = Application.Version
    Dim cnstr As String
    If CInt(VersionNumber) <= 11 Then
'        office 2003以前
        cnstr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & fname & ";"
    Else
'        office 2007以后
        cnstr = "Provider=Microsoft.ACE.OLEDB." & VersionNumber & ";Data Source=" & fname & ";"
    End If
    cnn.Open cnstr
End Sub
'清除access连接
Private Sub Class_Terminate()
    If cnn.State <> adStateClosed Then cnn.Close
    Set cnn = Nothing
End Sub
'建立一个access数据库
Public Sub createDB(ByVal fname As String)
    Dim cat As Object
    Set cat = CreateObject("ADOX.Catalog")
    cat.create "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & fname & ";"
    Set cat = Nothing
End Sub
'指定表是否存在
Function hasTable(ByVal tableName As String) As Boolean
    hasTable = True
    Err.Clear
    On Error Resume Next
    Dim SQL As String
    SQL = "select count(*) from " & tableName
    cnn.Execute SQL
    Debug.Print Err.Number & Err.Description
    If Err.Number = -2147217865 Then
        hasTable = False
    End If
'    If Err.Number <> 0 Then
'        hasTable = False
'    End If
End Function
'获得字段名
Public Sub getFields(ByVal tableName As String, ByRef result As Dictionary)
    Dim i As Integer
    Dim rst As New ADODB.Recordset
    rst.Open tableName, cnn, adOpenDynamic, adLockOptimistic
    For i = 0 To rst.Fields.count - 1
        result.Add i, rst.Fields(i).name
    Next i
End Sub

Public Sub removeDuplicate()
    On Error Resume Next
    Dim filter As String
    Dim SQL As String
    SQL = "delete from 生产信息 where 名称='' "
    Call cnn.Execute(SQL)
    filter = "where ID not in ( select max(ID) from 生产信息 group by 日期,名称,单位,备注 ) "
    SQL = "delete from 生产信息 " & filter
    Dim t As Date
    t = Now
    Call cnn.Execute(SQL)
    Debug.Print "Access 去除重复数据用时" & DateDiff("s", t, Now()) & "s."
End Sub
