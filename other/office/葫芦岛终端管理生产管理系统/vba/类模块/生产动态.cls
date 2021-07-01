VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "������̬"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public Sub CreateTable()
    Err.Clear
On Error GoTo errorhander
    Dim tablename As String
    tablename = "������̬"
    Dim SQL As String
    Dim tableDef As String
'    access
    Dim ac As New access
    tableDef = " (ID counter,ʱ�� date not null,���� text(32) not null,��λ text(32) not null,���� double not null,��� text(32),��ע text  )"
    SQL = "create table " & tablename & tableDef
    ac.cnn.Execute (SQL)
'    PostgreSQL
    Dim psql As New PostgreSQL
    tableDef = " (ID serial,ʱ�� timestamp without time zone not null,���� varchar(32) not null,��λ varchar(32) not null,���� double precision not null,��� varchar(32),��ע text  )"
    SQL = "create table if not exists " & tablename & tableDef
    psql.cnn.Execute (SQL)
'    ��������
    SQL = "create unique index ������̬_�߼�ID on ������̬(ʱ��,����)"
    ac.cnn.Execute (SQL)
    psql.cnn.Execute (SQL)
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Public Sub reCreateTable()
    Err.Clear
On Error GoTo errorhander
    Dim tablename As String
    tablename = "������̬"
    Dim SQL As String
'    Dim tableDef As String
    Dim ac As New access
    Dim psql As New PostgreSQL
'    ɾ����access��������̬��
    If ac.hasTable(tablename) Then
        SQL = "drop index ������̬_�߼�ID on " & tablename
        Call ac.cnn.Execute(SQL)
        SQL = "DROP TABLE  " & tablename
        Call ac.cnn.Execute(SQL)
    End If
'    ɾ����PostgreSQL��������̬
    If psql.hasTable(tablename) Then
        SQL = "drop index if exists ������̬_ID cascade"
        Call psql.cnn.Execute(SQL)
        SQL = "drop table if exists " & tablename & " CASCADE"
        Call psql.cnn.Execute(SQL)
    End If
    Call CreateTable
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

'生产动态导入数据库
Public Sub PushTableToDatabase(table)
    Err.Clear
    On Error GoTo ErrorHandler
'    Call removeDuplicate
    Dim t As Date
    t = Now
    Dim psql As New PostgreSQL
    Dim rst As New ADODB.Recordset
    Dim SQL As String
    Dim temp As New 生产动态
    Dim Condition As Boolean
    Condition = True
    Dim x, y
    Dim filter As String
'    Debug.Print "导入前数据整理花费" & DateDiff("s", t, Now()) & "s."
    Dim tablename As String
    tablename = "生产动态"
    Dim cnn As Object
    Debug.Print "准备导入" & table.count & "条记录！"
    Set cnn = psql.cnn
    rst.Open tablename, cnn, adOpenDynamic, adLockBatchOptimistic, adCmdTable
    For Each x In table.Keys
        Set temp = x
        Condition = x.isFormat(temp)
        If Condition Then
            rst.AddNew
            rst.Fields("单位").value = ""
            rst.Fields("备注").value = ""
            If IsDate(x.日期) Then
                rst.Fields("日期").value = x.日期
            End If
            If Not IsEmpty(x.名称) Then
                rst.Fields("名称").value = x.名称
            End If
            If Not IsEmpty(x.类别) Or x.类别 <> "" Then
                rst.Fields("类别").value = x.类别
            End If
            If Not IsEmpty(x.备注) Or x.备注 <> "" Then
                rst.Fields("备注").value = x.备注
            End If
            If IsNumeric(x.数据) Then
                rst.Fields("数据").value = Round(CDec(x.数据), 4)
            End If
'            Debug.Print rst.Fields("日期"), rst.Fields("名称"), rst.Fields("单位"),rst.Fields("数据")
            rst.UpdateBatch
        End If
    Next x
    rst.Close
    Set rst = Nothing
    Debug.Print "导入" & table.count & "条记录到表" & tablename & " ,PostgreSQL表花费" & DateDiff("s", t, Now()) & "s."
    Call removeDuplicate
ErrorHandler:
'    PostgreSQL 未连接代码 -2147467259
    If -2147467259 = Err.Number Then
        MsgBox "PostgreSQL 数据库没有打开！"
        Exit Sub
    Else
        Debug.Print Err.Number, Err.Description        
    End If
    Resume Next
End Sub

private sub removeDuplicate()
    on error goto ErrorHandler
    On Error Resume Next
    Dim filter As String
    Dim SQL As String
    dim tablename as string
    tablename="生产动态"
    filter = " where id not in ( select max(ID) from " & table & " group by 时间,名称,单位 ) "
    SQL = "delete from " & tablename & filter
    Dim t As Date
    t = Now
    Dim psql As New PostgreSQL
    Call psql.cnn.Execute(SQL)
    Debug.Print "PostgreSQL 去除重复数据花费" & DateDiff("s", t, Now()) & "s."   
    on error goto 0
    exit sub
ErrorHandler:
    
end sub