VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} 提单查询 
   Caption         =   "UserForm1"
   ClientHeight    =   4590
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   9930
   OleObjectBlob   =   "提单查询.frx":0000
   StartUpPosition =   1  '所有者中心
End
Attribute VB_Name = "提单查询"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit
Public filterS As New Dictionary
Private Sub UserForm_initialize()
On Error GoTo ErrorHandler
    Dim psql As New PostgreSQL
    Dim SQL As String
    Dim s
    Dim arr()
    Dim rst As New ADODB.Recordset
'    产品名称
    SQL = "select DISTINCT 产品名称 from 提单 "
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "产品名称")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.产品名称.AddItem (s)
    Next
'   客户名称
    SQL = "select DISTINCT 客户名称 from 提单 "
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "客户名称")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.客户名称.AddItem (s)
    Next
    Set rst = Nothing
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 查询_Click()
On Error GoTo ErrorHandler
    Worksheets("提单").Select
    Call Worksheets("提单").清除_Click
    Application.EnableEvents = False
    Dim d1 As Date
    Dim d2 As Date
    Dim d3 As Date
    Dim SQL As String
    Dim filter As String
    filter = ""
'    指定时间
    If True = 指定日期.Visible Then
        If IsDate(指定日期.value) Then
            d1 = 指定日期.value
            filter = "日期 = " & "'" & d1 & "'"
        Else
            MsgBox "不正确的时间格式！"
            Exit Sub
        End If
    End If
'    时间段
    If True = 开始日期.Visible And True = 结束日期.Visible Then
        If IsDate(开始日期.value) And IsDate(结束日期.value) Then
            d2 = 开始日期.value
            d3 = 结束日期.value
            filter = "日期 between " & "'" & d2 & "'" & " and " & "'" & d3 & "'"
        Else
            MsgBox "不正确的时间格式！"
            Exit Sub
        End If
    End If
    Dim i As Integer
    Dim Field()
    Dim value()
    Field = filterS.Keys
    value = filterS.Items
    For i = 0 To filterS.count - 1
        If "" <> value(i) Then
           filter = filter & " and " & Field(i) & "='" & value(i) & "'"
        End If
    Next i
    Dim filterFX As String
    filterFX = " order by 日期"
    Dim rowLimit As Long
    Dim columnLimit As Integer
    rowLimit = Rows.count
    columnLimit = Columns.count
    rowLimit = 65536 - 4
    SQL = " Select 日期,产品名称,客户名称,计划装车t,实际装车t,实际装车m3,实际装车bbl,装车数量,备注,提单号 from 提单 " & "where " & filter & filterFX
    Dim psql As New PostgreSQL
    Worksheets("提单").Cells(4, 1).CopyFromRecordset psql.cnn.Execute(SQL)
    Unload 提单查询
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 结束_Click()
    指定日期.Visible = False
    开始日期.Visible = True
    结束日期.Visible = True
    结束日期.value = DateValue(Now)
End Sub

Private Sub 开始_Click()
    指定日期.Visible = False
    开始日期.Visible = True
    结束日期.Visible = True
    Dim SQL As String
    Dim psql As New PostgreSQL
    Dim bd As Variant
    Dim tablename As String
    tablename = "提单"
    SQL = "select DISTINCT min(日期) from " & tablename
    bd = psql.cnn.Execute(SQL)(0)
    开始日期.value = bd
End Sub

Private Sub 日期_Click()
    指定日期.Visible = True
    开始日期.Visible = False
    结束日期.Visible = False
    指定日期.value = DateValue(Now)
End Sub

Private Sub 产品名称_Change()
    filterS.Add "产品名称", Me.产品名称.value
End Sub
Private Sub 客户名称_Change()
    filterS.Add "客户名称", Me.客户名称.value
End Sub
