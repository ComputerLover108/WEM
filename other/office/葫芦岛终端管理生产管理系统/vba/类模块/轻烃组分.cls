VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "轻烃组分"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public 日期 As Date
Public 名称, 取样点 As String
Public C1, C2, C3, iC4, nC4, iC5, nC5, CO2, N2, C5加 As Variant
Public 塔底温度, 塔顶压力, 回流量, 饱和蒸气压 As Variant
Public 数据源 As String
Sub CreateTable()
    Err.Clear
On Error GoTo ErrorHandler
    Dim SQL As String
    Dim tablename As String
    tablename = "轻烃组分"
'    PostgreSQL 表
    SQL = " CREATE TABLE IF NOT EXISTS " & tablename & " (id serial primary key,日期 date not null,名称 varchar not null,取样点 varchar not null,C1 double precision,C2 double precision,C3 double precision,iC4 double precision,nC4 double precision,iC5 double precision,nC5 double precision,""C5+"" double precision,CO2 double precision,N2 double precision,""塔底温度℃"" double precision,""塔顶压力kPa"" double precision,""回流量m3/h"" double precision,""饱和蒸气压kPa"" double precision,数据源 varchar);"
'    Debug.Print SQL
    Dim psql As New PostgreSQL
    Call psql.cnn.Execute(SQL)
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
'    PostgreSQL 未连接代码 -2147467259
    If -2147467259 = Err.Number Then
        MsgBox "PostgreSQL 数据库没有打开！"
        Exit Sub
    End If
    Resume Next
End Sub

'轻烃组分化验数据导入数据库
Public Sub PushTableToDatabase(ByRef table As Object)
    Err.Clear
On Error GoTo ErrorHandler
    Call CreateTable
    Dim t As Date
    t = Now
    Dim rst As New ADODB.Recordset
    Dim SQL, filter As String
    Dim temp As New 水质检测
    Dim Condition As Boolean
    Condition = True
    Dim x
'    Debug.Print "准备导入" & table.count & "条记录！"
    Dim tablename As String
    tablename = "轻烃组分"
    Dim cnn As Object

'    导入postgresql
    Dim psql As New PostgreSQL
    Set cnn = psql.cnn
    rst.Open tablename, cnn, adOpenDynamic, adLockBatchOptimistic, adCmdTable
    For Each x In table.Keys
        rst.AddNew
        rst.Fields("日期").value = x.日期
        rst.Fields("名称").value = x.名称
        rst.Fields("取样点").value = x.取样点
        rst.Fields("C1").value = x.C1
        rst.Fields("C2").value = x.C2
        rst.Fields("C3").value = x.C3
        rst.Fields("iC4").value = x.iC4
        rst.Fields("nC4").value = x.nC4
        rst.Fields("iC5").value = x.iC5
        rst.Fields("nC5").value = x.nC5
        rst.Fields("C5+").value = x.C5加
        rst.Fields("CO2").value = x.CO2
        rst.Fields("N2").value = x.N2
        rst.Fields("塔底温度℃").value = x.塔底温度
        rst.Fields("塔顶压力kPa").value = x.塔顶压力
        rst.Fields("回流量m3/h").value = x.回流量
'        Debug.Print x.饱和蒸汽压
'        rst.Fields("饱和蒸气压kPa").Value = x.饱和蒸汽压
        rst.Fields("数据源").value = x.数据源
        rst.UpdateBatch
    Next x
    Debug.Print "导入" & table.count & "条记录到表 " & tablename & " ,PostgreSQL表花费" & DateDiff("s", t, Now()) & "s."
    rst.Close
    Set rst = Nothing

    filter = " where ID not in ( select max(ID) from " & tablename & " group by 日期,名称,取样点 ) "
    SQL = "delete from " & tablename & filter
    Call psql.cnn.Execute(SQL)
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
'    PostgreSQL 未连接代码 -2147467259
    If -2147467259 = Err.Number Then
        MsgBox "PostgreSQL 数据库没有打开！"
        Exit Sub
    End If
    Resume Next
End Sub
