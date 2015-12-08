VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "PostgreSQL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public cnn As New ADODB.Connection
Sub test()
    Dim SQL As String
'    ɾ��ԭ�б�[������Ϣ]
    SQL = "drop table if exists ������Ϣ ;"
    cnn.Execute SQL
'    �ؽ��� [������Ϣ]
    Dim tableName As String
    tableName = "������Ϣ"
    Dim tableDef As String
    tableDef = " (ID serial,���� date not null,���� varchar(16) not null,��λ varchar(8),���� double precision,��� varchar(8),״̬ varchar(8),��ע varchar,���� double precision,���� double precision,����Դ varchar  );"
    SQL = " CREATE TABLE IF NOT EXISTS " & tableName & tableDef
    Call cnn.Execute(SQL)

End Sub
'��ʼ��PostgreSQL����
Private Sub Class_Initialize()
'���������ݿ������
    Dim dataBase As String
    Dim userName As String
    Dim password As String
    Dim DBname As String
    Dim openCommand As String
    dataBase = "PostgreSQL35W"
    userName = "operator"
    password = "5302469"
    DBname = "HLD"
    openCommand = "DSN=" & dataBase & ";" & "UID=" & userName & ";" & "PWD=" & password & ";" & "Database=" & DBname
    cnn.Open openCommand
End Sub
'���PostgreSQL����
Private Sub Class_Terminate()
    If cnn.State <> adStateClosed Then cnn.Close
    Set cnn = Nothing
End Sub
'ָ�����Ƿ����
Function hasTable(ByVal tableName As String) As Boolean
    hasTable = True
    Err.Clear
    On Error Resume Next
    Dim SQL As String
    SQL = "select count(*) from " & tableName
    cnn.Execute SQL
    Debug.Print Err.Number & Err.Description
    If Err.Number = -2147467259 Then
        hasTable = False
    End If
'    If Err.Number <> 0 Then
'        hasTable = False
'    End If
End Function

Public Sub removeDuplicate()
    On Error Resume Next
    Dim filter As String
    Dim SQL As String
    filter = "where ID not in ( select max(ID) from ������Ϣ group by ����,����,��λ,���,״̬,��ע ) "
    SQL = "delete from ������Ϣ " & filter
    Dim t As Date
    t = Now
    Call cnn.Execute(SQL)
    Debug.Print "PostgreSQL ȥ���ظ�������ʱ" & DateDiff("s", t, Now()) & "s."
End Sub

Public Sub ���ݿ�����()
    Err.Clear
On Error GoTo ErrorHandler
    Dim SQL As String
    SQL = "ALTER TABLE ������̬ ALTER ʱ�� TYPE timestamp;"
    Call cnn.Execute(SQL)
    SQL = "ALTER TABLE  IF EXISTS  ������Ϣ  RENAME COLUMN ID TO id;"
    Call cnn.Execute(SQL)
    SQL = "update ������Ϣ set ����='���ܳ���PHֵ' where ���� like '���ܳ���PHֵ%';"
    Call cnn.Execute(SQL)
    SQL = "delete from ������Ϣ where ����='�����ܶ�'  and ����=0;"
    Call cnn.Execute(SQL)
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub