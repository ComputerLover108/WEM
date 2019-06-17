VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "生产信息"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public 日期 As Date
Public 名称 As String
Public 单位 As String
Public 数据 As Variant
Public 类别 As String
Public 状态 As String
Public 备注 As String
Public 月累 As Variant
Public 年累 As Variant
Public 数据源 As String
Function content() As String
    content = 日期 & _
                vbTab & 名称 & _
                vbTab & 单位 & _
                vbTab & 数据 & _
                vbTab & 类别 & _
                vbTab & 状态 & _
                vbTab & 备注 & _
                vbTab & 月累 & _
                vbTab & 年累 & _
                vbTab & 数据源
End Function
'csv格式
Function contentCSV() As String
'    csv格式规范
'　　1 开头是不留空，以行为单位。
'　　2 可含或不含列名，含列名则居文件第一行。
'　　3 一行数据不垮行，无空行。
'　　4 以半角逗号（即,）作分隔符，列为空也要表达其存在。
'　　5 列内容如存在半角逗号（即,）则用半角引号（即""）将该字段值包含起来。
'　　6 列内容如存在半角引号（即"）则应替换成半角双引号（""）转义，并用半角引号（即""）将该字段值包含起来。
'　　7 文件读写时引号，逗号操作规则互逆。
'　　8 内码格式不限，可为 ASCII、Unicode 或者其他。
'    9 不支持特殊字符
    Call ruleData
    Dim s As String
    s = s & 日期 & ","
    s = s & 名称 & ","
    s = s & 单位 & ","
    s = s & 数据 & ","
    s = s & 类别 & ","
    s = s & 状态 & ","
    s = s & 备注 & ","
    s = s & 月累 & ","
    s = s & 年累 & ","
    s = s & 数据源
    s = s & vbCrLf
'    Debug.Print s
    contentCSV = s
End Function
'判断正确的生产信息格式
Public Function isFormat(ByRef x As 生产信息) As Boolean
'    tableDef = " (日期 date,名称 text(16),单位 text(8),数据 double,类别 text(8),状态 text(8),月累 double,年累 double,备注 text,数据源 text  )"
    If Not IsDate(x.日期) Then
        isFormat = False
        Exit Function
    End If
    If Len(x.名称) > 16 Then
        isFormat = False
        Exit Function
    End If
    If Len(x.单位) > 8 Then
        isFormat = False
        Exit Function
    End If
    If Len(x.类别) > 8 Then
        isFormat = False
        Exit Function
    End If
    If Len(x.状态) > 8 Then
        isFormat = False
        Exit Function
    End If
    If Not IsNumeric(x.数据) Then
        isFormat = False
        Exit Function
    End If
    If Not IsNumeric(x.月累) Then
        isFormat = False
        Exit Function
    End If
    If Not IsNumeric(x.年累) Then
        isFormat = False
        Exit Function
    End If
    isFormat = True
End Function
'保存为CSV文件 UTF-8
Sub saveCSV(ByVal fileName As String, ByVal tt)
    Dim objStream As Object
    Set objStream = CreateObject("ADODB.Stream")
    objStream.Type = adTypeText
    objStream.Mode = adModeReadWrite
    objStream.Open
    objStream.position = 0
    objStream.Charset = "UTF-8"
    Dim temp As New 生产信息
    Dim x
    For Each x In tt.Keys
        Set temp = x
        If isFormat(temp) Then objStream.WriteText (temp.contentCSV)
    Next x
    fileName = ThisWorkbook.path & Application.PathSeparator & fileName
    Debug.Print fileName
    objStream.SaveToFile fileName, adSaveCreateOverWrite
    objStream.Close
    Set objStream = Nothing
End Sub
'规范数据为正确格式
Public Function ruleData()
'    csv格式规范
'　　1 开头是不留空，以行为单位。
'　　2 可含或不含列名，含列名则居文件第一行。
'　　3 一行数据不垮行，无空行。
'　　4 以半角逗号（即,）作分隔符，列为空也要表达其存在。
'　　5 列内容如存在半角逗号（即,）则用半角引号（即""）将该字段值包含起来。
'　　6 列内容如存在半角引号（即"）则应替换成半角双引号（""）转义，并用半角引号（即""）将该字段值包含起来。
'　　7 文件读写时引号，逗号操作规则互逆。
'　　8 内码格式不限，可为 ASCII、Unicode 或者其他。
'    9 不支持特殊字符
    If Not IsNumeric(数据) Then
        数据 = Null
    End If
    If Len(备注) > 0 Then
        备注 = Chr(34) & 备注 & Chr(34)
    End If
End Function
'建立表 生产信息
Sub CreateTable()
    Err.Clear
    On Error GoTo errorhander
    Dim SQL As String
    Dim tablename As String
    tablename = "生产信息"
'    access 表
    Dim tableDef As String
    tableDef = " (ID counter,日期 date not null,名称 text(16) not null,单位 text(8),数据 double,类别 text(8),状态 text(8),月累 double,年累 double,备注 text,数据源 text  )"
    SQL = " CREATE TABLE " & tablename & tableDef
    Dim ac As New access
    Call ac.cnn.Execute(SQL)
'    PostgreSQL 表
    tableDef = " (ID serial,日期 date not null,名称 varchar(16) not null,单位 varchar(8),数据 double precision,类别 varchar(8),状态 varchar(8),备注 varchar,月累 double precision,年累 double precision,数据源 varchar  );"
    SQL = " CREATE TABLE IF NOT EXISTS " & tablename & tableDef
    Dim psql As New PostgreSQL
    Call psql.cnn.Execute(SQL)
'    重建逻辑索引
    SQL = "create unique index 生产信息_逻辑ID on " & tablename & " (日期,名称,单位,类别,状态,备注) "
    Call ac.cnn.Execute(SQL)
    Call psql.cnn.Execute(SQL)
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub
'生产信息导入数据库
Public Sub PushTableToDatabase(table)
    Err.Clear
    On Error GoTo ErrorHandler
'    Call removeDuplicate
    Dim t As Date
    t = Now
    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim rst As New ADODB.Recordset
    Dim SQL As String
    Dim temp As New 生产信息
    Dim Condition As Boolean
    Condition = True
    Dim x, y
    Dim filter As String
'    Call collate
'    Debug.Print "导入前数据整理花费" & DateDiff("s", t, Now()) & "s."
    Dim tablename As String
    tablename = "生产信息"
    Dim cnn As Object
    Debug.Print "准备导入" & table.count & "条记录！"
'    导入access
'    Set cnn = ac.cnn
'    rst.Open tablename, cnn, adOpenDynamic, adLockBatchOptimistic, adCmdTabl
'    For Each x In table.Keys
'        Condition = x.isFormat(temp)
'        If Condition Then
''            SQL = "select count(*) from " & tablename & " where 日期=#" & x.日期 & "# and 名称='" & x.名称 & "' and 单位='" & x.单位 & "' and 类别='" & x.类别 & "' and 状态='" & x.状态 & "' and  备注='" & x.备注 & "'"
''            y = cnn.Execute(SQL)(0)
'''            Debug.Print y, SQL
''            If y = 0 Then
''                rst.AddNew
''            End If
'            rst.AddNew
'            rst.Fields("单位").value = ""
'            rst.Fields("状态").value = ""
'            rst.Fields("类别").value = ""
'            rst.Fields("备注").value = ""
'            rst.Fields("数据源").value = ThisWorkbook.FullName
''            Debug.Print ThisWorkbook.path + "\" + ThisWorkbook.name
'            If IsDate(x.日期) Then
'                rst.Fields("日期").value = x.日期
'            End If
'            If Not IsEmpty(x.名称) Then
'                rst.Fields("名称").value = x.名称
'            End If
'            If Not IsEmpty(x.单位) Or x.单位 <> "" Then
'                rst.Fields("单位").value = x.单位
'            End If
'            If Not IsEmpty(x.类别) Or x.类别 <> "" Then
'                rst.Fields("类别").value = x.类别
'            End If
'            If Not IsEmpty(x.状态) Or x.状态 <> "" Then
'                rst.Fields("状态").value = x.状态
'            End If
'            If Not IsEmpty(x.备注) Or x.备注 <> "" Then
'                rst.Fields("备注").value = x.备注
'            End If
'            If Not IsEmpty(x.数据源) Or x.数据源 <> "" Then
'                rst.Fields("数据源").value = x.数据源
'            End If
'            If IsNumeric(x.数据) Then
'                rst.Fields("数据").value = Round(x.数据, 4)
'            End If
'            If IsNumeric(x.月累) Then
'                rst.Fields("月累").value = Round(x.月累, 4)
'            End If
'            If IsNumeric(x.年累) Then
'                rst.Fields("年累").value = Round(x.年累, 4)
'            End If
'            rst.UpdateBatch
'        End If
'    Next x
'    Debug.Print "导入" & rst.RecordCount; "条记录,access表花费" & DateDiff("s", t, Now()) & "s."
'    rst.Close
'    Set rst = Nothing
'    导入postgresql
'    PostgreSQL 唯一索引不能处理空值
'    Dim SQL_suffix As String
'    SQL = "CREATE UNIQUE INDEX IF NOT EXISTS  生产信息唯一索引  ON 生产信息 (日期,名称,单位,类别,状态,备注);"
'    Call psql.cnn.Execute(SQL)
'    SQL_suffix = " ON CONFLICT (日期,名称,单位,类别,状态,备注) DO UPDATE SET 数据源 = EXCLUDED.数据源,数据 = EXCLUDED.数据,月累 = EXCLUDED.月累,年累 = EXCLUDED.年累 where  生产信息.数据 is distinct from EXCLUDED.数据 or 生产信息.月累 is distinct from EXCLUDED.月累 or 生产信息.年累 is distinct from EXCLUDED.年累 or 生产信息.数据源 is distinct from EXCLUDED.数据源;"
'    Dim 数据, 月累, 年累
'    For Each x In table.Keys
'        Set temp = x
'        Condition = x.isFormat(temp)
'        If Condition Then
'            If Not IsEmpty(x.数据) Then
'                数据 = Round(x.数据, 4)
'            Else
'                数据 = "NULL"
'            End If
'            If Not IsEmpty(x.月累) Then
'                月累 = Round(x.月累, 4)
'            Else
'                月累 = "NULL"
'            End If
'            If Not IsEmpty(x.年累) Then
'                年累 = Round(x.年累, 4)
'            Else
'                年累 = "NULL"
'            End If
'            SQL = "INSERT INTO " & tablename & " ( 日期,名称,单位,类别,状态,备注,数据源,数据,月累,年累) VALUES ( '" & x.日期 & "','" & x.名称 & "','" & x.单位 & "','" & x.类别 & "','" & x.状态 & "','" & x.备注 & "','" & x.数据源 & "'," & 数据 & "," & 月累 & "," & 年累 & ")"
'            SQL = SQL + SQL_suffix
'            Debug.Print SQL
'            Call psql.cnn.Execute(SQL)
'        End If
'    Next
    Set cnn = psql.cnn
    rst.Open tablename, cnn, adOpenDynamic, adLockBatchOptimistic, adCmdTable
    For Each x In table.Keys
        Set temp = x
        Condition = x.isFormat(temp)
        If Condition Then
            rst.AddNew
            rst.Fields("单位").value = ""
            rst.Fields("状态").value = ""
            rst.Fields("类别").value = ""
            rst.Fields("备注").value = ""
            rst.Fields("数据源").value = ThisWorkbook.FullName
            If IsDate(x.日期) Then
                rst.Fields("日期").value = x.日期
            End If
            If Not IsEmpty(x.名称) Then
                rst.Fields("名称").value = x.名称
            End If
            If Not IsEmpty(x.单位) Or x.单位 <> "" Then
                rst.Fields("单位").value = x.单位
            End If
            If Not IsEmpty(x.类别) Or x.类别 <> "" Then
                rst.Fields("类别").value = x.类别
            End If
            If Not IsEmpty(x.状态) Or x.状态 <> "" Then
                rst.Fields("状态").value = x.状态
            End If
            If Not IsEmpty(x.备注) Or x.备注 <> "" Then
                rst.Fields("备注").value = x.备注
            End If
            If Not IsEmpty(x.数据源) Or x.数据源 <> "" Then
                rst.Fields("数据源").value = x.数据源
            End If
            If IsNumeric(x.数据) Then
                rst.Fields("数据").value = Round(CDec(x.数据), 4)
            End If
            If IsNumeric(x.月累) Then
                rst.Fields("月累").value = Round(CDec(x.月累), 4)
            End If
            If IsNumeric(x.年累) Then
                rst.Fields("年累").value = Round(CDec(x.年累), 4)
            End If
'            Debug.Print rst.Fields("日期"), rst.Fields("名称"), rst.Fields("数据"), rst.Fields("月累"), rst.Fields("年累")
            rst.UpdateBatch
        End If
    Next x
    rst.Close
    Set rst = Nothing
    Debug.Print "导入" & table.count & "条记录到表" & tablename & " ,PostgreSQL表花费" & DateDiff("s", t, Now()) & "s."
    Call removeDuplicate
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number, Err.Description
    End If
'    PostgreSQL 未连接代码 -2147467259
    If -2147467259 = Err.Number Then
        MsgBox "PostgreSQL 数据库没有打开！"
        Exit Sub
    End If
    Resume Next
End Sub
'去除重复数据
Public Sub removeDuplicate()
'    Dim ac As New access
'    Call ac.removeDuplicate
    Dim psql As New PostgreSQL
    Call psql.removeDuplicate
End Sub

Public Sub AccessToPostgreSQL()
    Err.Clear
    On Error GoTo ErrorHandler
    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim tablename As String
    tablename = "生产信息"
'    Dim SQL As String
'    SQL = " Select  日期,名称,单位,数据,类别,状态,月累,年累,备注,数据源 from 生产信息 "
'    rst1.Open SQL, ac.cnn, adOpenDynamic, adLockBatchOptimistic
    Dim rst1 As New ADODB.Recordset
    rst1.Open tablename, ac.cnn, adOpenDynamic, adLockBatchOptimistic, adCmdTable
    Dim rst2 As New ADODB.Recordset
    rst2.Open tablename, psql.cnn, adOpenDynamic, adLockBatchOptimistic, adCmdTable
    rst1.MoveFirst
    While Not rst1.EOF Or rst1.BOF
        rst2.AddNew
        rst2.Fields("日期").value = rst1!日期
        rst2.Fields("名称").value = rst1!名称
        rst2.Fields("单位").value = rst1!单位
        rst2.Fields("类别").value = rst1!类别
        rst2.Fields("状态").value = rst1!状态
        rst2.Fields("备注").value = rst1!备注
        rst2.Fields("数据源").value = rst1!数据源
        rst2.Fields("数据").value = rst1!数据
        rst2.Fields("月累").value = rst1!月累
        rst2.Fields("年累").value = rst1!年累
        rst2.UpdateBatch
        rst1.MoveNext
        rst2.MoveNext
    Wend
    rst1.Close
    Set rst1 = Nothing
    rst2.Close
    Set rst2 = Nothing
    Call removeDuplicate
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Or 3021 = Err.Number Then
        Exit Sub
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
'    access 重复数据处理
    Resume Next
'    PostgreSQL 未连接代码 -2147467259
    If -2147467259 = Err.Number Then
        MsgBox "PostgreSQL 数据库没有打开！"
        Exit Sub
    End If
End Sub

Public Sub PostgreSQLtoAccess()
Err.Clear
On Error GoTo ErrorHandler
    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim tablename As String
    tablename = "生产信息"
'    Access
    Dim rst1 As New ADODB.Recordset
    Dim rst2 As New ADODB.Recordset
    rst1.Open tablename, psql.cnn, adOpenDynamic, adLockBatchOptimistic, adCmdTable
    rst1.MoveFirst
    rst2.Open tablename, ac.cnn, adOpenDynamic, adLockBatchOptimistic, adCmdTable
    While Not rst1.EOF Or rst1.BOF
        rst2.AddNew
        rst2.Fields("日期").value = rst1!日期
        rst2.Fields("名称").value = rst1!名称
        rst2.Fields("单位").value = rst1!单位
        rst2.Fields("类别").value = rst1!类别
        rst2.Fields("状态").value = rst1!状态
        rst2.Fields("备注").value = rst1!备注
        rst2.Fields("数据源").value = rst1!数据源
        rst2.Fields("数据").value = rst1!数据
        rst2.Fields("月累").value = rst1!月累
        rst2.Fields("年累").value = rst1!年累
        rst2.UpdateBatch
        rst1.MoveNext
        rst2.MoveNext
    Wend
    rst1.Close
    Set rst1 = Nothing
    rst2.Close
    Set rst2 = Nothing
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
'    access 重复数据处理
    Resume Next
'    PostgreSQL 未连接代码 -2147467259
    If -2147467259 = Err.Number Then
        MsgBox "PostgreSQL 数据库没有打开！"
        Exit Sub
    End If
End Sub
Public Sub collate()
    Err.Clear
On Error GoTo ErrorHandler
    Dim SQL, tablename As String
    Dim ac As New access
    Dim psql As New PostgreSQL
    tablename = "生产信息"
    SQL = "update " & tablename & " set 单位='' where 单位 is null;"
    Call ac.cnn.Execute(SQL)
    Call psql.cnn.Execute(SQL)
    SQL = "update " & tablename & " set 类别='' where 类别 is null;"
    Call ac.cnn.Execute(SQL)
    Call psql.cnn.Execute(SQL)
    SQL = "update " & tablename & " set 状态='' where 状态 is null;"
    Call ac.cnn.Execute(SQL)
    Call psql.cnn.Execute(SQL)
    SQL = "update " & tablename & " set 备注='' where 备注 is null;"
    Call ac.cnn.Execute(SQL)
    Call psql.cnn.Execute(SQL)
    SQL = "update " & tablename & " set 数据源='' where 数据源 is null;"
    Call ac.cnn.Execute(SQL)
    Call psql.cnn.Execute(SQL)
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
End Sub


