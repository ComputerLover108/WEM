VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet13"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private Sub AccessToPostgreSQL_Click()
    Dim t
    t = Now
    Dim x As New 生产信息
'    Dim psql As New PostgreSQL
'    Call psql.test
    Call x.AccessToPostgreSQL
    Debug.Print "AccessToPostgreSQL 用时" & DateDiff("s", t, Now()) & "s."
End Sub

Private Sub CommandButton1_Click()
    Dim sd As String
    sd = InputBox("请输入密码：", "危险操作！Access中生产信息可能全部删除", "******")
    Dim h As New help
    hasright = h.checkRight(sd)
    If False = hasright Then
        MsgBox "密码不对！禁止危险操作！"
        Exit Sub
    End If
    hasright = True
    If True = hasright Then
    '重建数据库中生产信息表
        Dim tableDef As String
        Const tablename = "生产信息"
        Dim SQL As String
        On Error GoTo ErrorHandler
        Dim psql As New PostgreSQL
    '    删除PostgreSQL原逻辑索引
        Call psql.cnn.Execute("drop index 逻辑ID")
    '    删除在PostgreSQL中生产信息表
        SQL = "drop table if exists " & tablename & " CASCADE"
        Call psql.cnn.Execute(SQL)
        tableDef = " (ID serial PRIMARY KEY,日期 date not null,名称 varchar(16) not null,单位 varchar(8),数据 double precision,类别 varchar(8),状态 varchar(8),备注 varchar,月累 double precision,年累 double precision,数据源 varchar  );"
        SQL = " CREATE TABLE IF NOT EXISTS " & tablename & tableDef
        Call psql.cnn.Execute(SQL)
    '    重建逻辑索引
        SQL = "create index 逻辑ID on " & tablename & " (日期,名称,单位,备注) "
        Call psql.cnn.Execute(SQL)
    End If
    hasright = False
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub PostgreSQLtoAccess_Click()
    Dim sd As String
    sd = InputBox("请输入密码：", "危险操作！Access中生产信息可能全部删除", "******")
    Dim h As New help
    hasright = h.checkRight(sd)
    If False = hasright Then
        MsgBox "密码不对！禁止危险操作！"
        Exit Sub
    End If
    hasright = True
    If True = hasright Then
        Dim x As New 生产信息
        Call x.AccessToPostgreSQL
        Dim ac As New access
        Dim SQL As String
        SQL = "delete * from 生产信息 ;"
        Call ac.cnn.Execute(SQL)
        Call x.PostgreSQLtoAccess
    End If
    hasright = False
End Sub

Private Sub 返回主页_Click()
    Worksheets("主页").Select
End Sub

Private Sub 去除重复数据_Click()
    Dim sd As String
    sd = InputBox("请输入密码：", "危险操作！Access中生产信息可能全部删除", "******")
    Dim h As New help
    hasright = h.checkRight(sd)
    If False = hasright Then
        MsgBox "密码不对！禁止危险操作！"
        Exit Sub
    End If
    hasright = True
    If True = hasright Then
        Dim ac As New access
        Call ac.removeDuplicate
    End If
    hasright = False
End Sub

'创建数据库
Private Sub 重建数据库_Click()
    Dim sd As String
    sd = InputBox("请输入密码：", "危险操作！数据中生产信息全部重建", "******")
    Dim h As New help
    hasright = h.checkRight(sd)
    If False = hasright Then
        MsgBox "密码不对！禁止危险操作！"
        Exit Sub
    End If
    hasright = True
    If True = hasright Then
        Dim SC As New 生产日报
        Call SC.rebuildDB
        Dim scdt As New 生产动态
        Call scdt.reCreateTable
    End If
    hasright = False
End Sub

Public Sub getTelephone()
    Dim psql As New PostgreSQL
    Dim path As String
    Dim fname As String
    Dim SQL As String
    Dim row As Long
    Dim column As Long
    Dim beginRow As Long
    Dim rowLimit As Long
    
    SQL = "create table if not exists 通讯录(id serial primary key,姓名 varchar,电话 varchar,手机 varchar,电邮 varchar,办公地点 varchar,单位 varchar,部门 varchar,岗位 varchar,IP varchar,备注 varchar);"
    psql.cnn.Execute (SQL)
    path = "D:\public\test"
    fname = "160420 辽东作业公司各现场单元通讯录更新.xls"
    
    fname = "副本161024辽东作业公司陆地办公人员通讯录 (2).xls"
    Workbooks.Open (path + "\" + fname)
    Worksheets("Sheet1").Select

    beginRow = 2
    rowLimit = Rows.count
'    lastRow = Range(Cells(beginRow, beginColumn), Cells(rowLimit, beginColumn)).End(xlDown).row
    
    Dim 姓名, 电话, 手机, 电邮, 办公地点, 单位, 部门, 岗位, IP, 备注 As String
    单位 = "辽东作业公司机关"
    For row = beginRow To rowLimit
        部门 = Cells(row, 2).value
        岗位 = Cells(row, 3).value
        姓名 = Cells(row, 4).value
        电话 = Cells(row, 5).value
        手机 = Cells(row, 6).value
        电邮 = Cells(row, 7).value
        办公地点 = Cells(row, 8).value
        SQL = "insert into 通讯录 (姓名, 电话, 手机, 电邮, 办公地点, 单位, 部门, 岗位) values (姓名, 电话, 手机, 电邮, 办公地点, 单位, 部门, 岗位);"
        Debug.Print (SQL)
    Next row
    Workbooks("path + " \ " + fname").Close SaveChanges:=False
End Sub
