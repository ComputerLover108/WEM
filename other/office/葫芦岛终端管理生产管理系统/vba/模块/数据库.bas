Attribute VB_Name = "���ݿ�"
Option Explicit
'����
Public Sub test()
    Dim fname As String
    Const name = "��«����Ȼ������.mdb"
    Debug.Print ActiveWorkbook.path
    fname = ThisWorkbook.path & Application.PathSeparator & name
'    Debug.Print fname
'    Call CreateDB(fname)
'    Dim result As Object
'    Set result = CreateObject("Scripting.Dictionary")    'ȫ����Ŀ¼
'    Call getTableNames(fname, result)
    Dim tablename As String
    tablename = "������Ϣ"
    Dim filter As String
    Call ɾ���ظ���¼(fname, tablename, filter)
End Sub
'���������ݿ�
Public Sub createDB(ByVal fileName As String)
    Dim fs As Object
    Set fs = CreateObject("Scripting.FileSystemObject")
    If Not fs.FileExists(fileName) Then
        Dim cat As Object
        Set cat = CreateObject("ADOX.Catalog")
        cat.create _
            "Provider=Microsoft.Jet.OLEDB.4.0;" & _
            "Data Source=" & fileName & ";"
        Set cat = Nothing
    Else
        MsgBox "���ݿ��ļ�" & fileName & "�Ѿ����ڣ�"
    End If
End Sub
'ɾ��access��
Public Sub dropTable(ByVal tablename As String)
    On Error Resume Next
    Dim fname As String
    Const name = "��«����Ȼ������.mdb"
    Debug.Print ActiveWorkbook.path
    fname = ThisWorkbook.path & Application.PathSeparator & name
    Dim cnn As Object
    Set cnn = CreateObject("ADODB.Connection")
    '���������ݿ������
    With cnn
        .Provider = "Microsoft.Jet.OLEDB.4.0"
        .Open fname
    End With
    Dim SQL As String
    SQL = "drop table " & tablename
    Debug.Print SQL
    cnn.Execute (SQL)
    Debug.Print Err.Description
'    �ر����Ӳ������ڴ�
    If cnn.State <> adStateClosed Then cnn.Close
    Set cnn = Nothing
End Sub
Public Sub getTableNames(ByVal fileName As String, ByRef result As Object)
    Dim cat As Object
    Set cat = CreateObject("ADOX.Catalog")
    Dim TB As Object
    Set TB = CreateObject("ADOX.Table")
    cat.ActiveConnection = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & fileName & ";"
    For Each TB In cat.tables
        Debug.Print TB.name
        result.Add TB.name, fileName
    Next TB
    Set cat = Nothing
End Sub

'access���ݿ��б����ݵ�������excel����
'Sub TransferTableFromAccess(ByVal tableName As String, ByVal excelTable As String, filter)
'    Dim cnn As Object
'    Dim rst As Object
'    Set cnn = CreateObject("ADODB.Connection")
'    Set rst = CreateObject("ADODB.recordset")
''    Dim fileName
''    fileName = ThisWorkbook.Path & Application.PathSeparator & dbName
'    With cnn
'        .Provider = "Microsoft.Jet.OLEDB.4.0"
'        .Open fileName
'    End With
'    Dim SQL As String
'    SQL = " select " & filter(0) & " from " & tableName & " where " & filter(1)
''    Debug.Print SQL
'    Set rst = cnn.Execute(SQL)
''    '�����ݴ��ݵ�Excel
'    Dim cpos As String
''    cpos = "A" & CStr(beginRow)
'    cpos = "A1"
''    Debug.Print cpos
'    ThisWorkbook.Worksheets(excelTable).Range(cpos).CopyFromRecordset rst
'    ' �ر�����
'    rst.Close
'    cnn.Close
'    Set rst = Nothing
'    Set cnn = Nothing
'
'End Sub

'������
'Public Sub CreateTable(ByVal fileName As String, ByVal tableName As String, ByVal tableDef As String)
'    On Error GoTo CreateTableError
'
''    Dim tbl As New table
''    Dim cat As New ADOX.Catalog
'    Dim cat As Object
'    Set cat = CreateObject("ADOX.Catalog")
'    ' Open the Catalog.
'    cat.ActiveConnection = "Provider='Microsoft.Jet.OLEDB.4.0';" & _
'        "Data Source=" & fileName & ";"
'
'    Dim sqlCommand As String
'    sqlCommand = "create table "
''    Debug.Print sqlCommand & tableName & tableDef
'    Dim SQL As String
'    SQL = sqlCommand & tableName & tableDef
'    cat.ActiveConnection.Execute SQL
'
'    'Clean up
'    Set cat.ActiveConnection = Nothing
'    Set cat = Nothing
'    Exit Sub
'
'CreateTableError:
'
'    Set cat = Nothing
'
'    If Err <> 0 Then
'        MsgBox Err.Source & "-->" & Err.Description, , "Error"
'    End If
'End Sub
'
Public Sub ɾ���ظ���¼(ByVal fname As String, ByVal tablename As String, ByVal filter As String)
    Dim cnn As Object
    Set cnn = CreateObject("ADODB.Connection")
    '���������ݿ������
'    access ���ݿ��ļ���
    With cnn
        .Provider = "Microsoft.Jet.OLEDB.4.0"
        .Open fname
    End With
    Dim SQL As String
'    ALTER TABLE tb ALTER COLUMN aa Counter �Զ����
'    cnn.Execute "select * from MSysObjects where type=1 and flags=0"
    
'    SQL = "alter table " & tableName & " add column ID counter"
'    cnn.Execute SQL
'    filter = " select min(ID) from ������Ϣ group by ����,����,��λ"
'    Debug.Print filter
'    cnn.Execute filter
'    SQL = " delete from ������Ϣ where id not in ( " & filter & " ) "
'    Debug.Print SQL
'    cnn.Execute SQL
    SQL = "alter table " & tablename & " drop column ID "
    cnn.Execute SQL
    cnn.Close
    Set cnn = Nothing
End Sub
