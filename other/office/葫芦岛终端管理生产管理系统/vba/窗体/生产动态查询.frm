VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} 生产动态查询 
   Caption         =   "生产动态"
   ClientHeight    =   6630
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   11400
   OleObjectBlob   =   "生产动态查询.frx":0000
   StartUpPosition =   1  '所有者中心
End
Attribute VB_Name = "生产动态查询"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public filterS As New Dictionary
Private Sub 查询_Click()
    Worksheets("生产动态").Select
    Call Worksheets("生产动态").清除_Click
    Application.EnableEvents = False
On Error GoTo ErrorHandler
    Dim d1 As Date
    Dim d2 As Date
    Dim d3 As Date
    Dim SQL As String
    Dim filter As String
    filter = ""
'    指定时间
    If True = 时间点.Visible Then
        If IsDate(时间点.value) Then
            d1 = 时间点.value
            filter = "时间 = " & "'" & d1 & "'"
        Else
            MsgBox "不正确的时间格式！"
            Exit Sub
        End If
    End If
'    时间段
    If True = 开始时间.Visible And True = 结束时间.Visible Then
        If IsDate(开始时间.value) And IsDate(结束时间.value) Then
            d2 = 开始时间.value
            d3 = 结束时间.value
            filter = "时间 between " & "'" & d2 & "'" & " and " & "'" & d3 & "'"
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
    filterFX = " order by 时间"
'    office 2003 最大行数，最大列数
    Dim rowLimit As Long
    Dim columnLimit As Integer
    rowLimit = 65536
    columnLimit = 256
    rowLimit = 65536 - 4
    Dim psql As New PostgreSQL
    
'    去除无用数据
    SQL = "delete from 生产动态 where 时间 > '2110-1-1';"
    Call psql.cnn.Execute(SQL)
'    查询数据
    SQL = "select count(*) from 生产动态 " & "where " & filter
    Dim 记录数 As Long
    记录数 = psql.cnn.Execute(SQL)(0)
    If 记录数 > rowLimit Then
        MsgBox ("记录太多了，超过" & rowLimit & "条!")
        Exit Sub
    End If
    SQL = " Select 时间,名称,单位,数据,备注 from 生产动态 " & "where " & filter & filterFX
'    Call psql.cnn.Execute(SQL)
    Worksheets("生产动态").Cells(4, 1).CopyFromRecordset psql.cnn.Execute(SQL)
    Unload 生产动态查询
    Dim row As Long
    Dim column As Integer
    row = 4
    column = 1
    Worksheets("生产动态").Select
    With ActiveSheet.UsedRange
        Range(Cells(3, 1), Cells(.Rows.count, .Columns.count)).Select
    End With
    Selection.AutoFilter
    Columns("A:A").Select
    Selection.NumberFormatLocal = "yyyy/m/d h:mm;@"
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 结束_Click()
    时间点.Visible = False
    开始时间.Visible = True
    结束时间.Visible = True
    结束时间.value = DateValue(Now)
End Sub


Private Sub 开始_Click()
    时间点.Visible = False
    开始时间.Visible = True
    结束时间.Visible = True
    开始时间.value = DateSerial(Year(Now), Month(Now), 1)
End Sub

Private Sub 添加_Click()
    Worksheets("生产动态").Select
    Unload 生产动态查询
End Sub

Private Sub 修改_Click()
    Worksheets("生产动态").Select
    Unload 生产动态查询
End Sub

Private Sub 指定时间_Click()
    时间点.Visible = True
    时间点.value = DateValue(Now)
    开始时间.Visible = False
    结束时间.Visible = False
End Sub
Private Sub 名称_Change()
    filterS.Add "名称", Me.名称.value
End Sub
Private Sub 单位_Change()
    filterS.Add "单位", Me.单位.value
End Sub
Private Sub 类别_Change()
    filterS.Add "类别", Me.类别.value
End Sub
Private Sub UserForm_initialize()
    Err.Clear
On Error GoTo ErrorHandler
    Dim psql As New PostgreSQL
    Dim SQL As String
    Dim s
    Dim arr()
    Dim rst As New ADODB.Recordset
'    名称
    SQL = "select DISTINCT 名称 from 生产动态 "
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "名称")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.名称.AddItem (s)
    Next
'    单位
    SQL = "select DISTINCT 单位 from 生产动态 "
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "单位")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.单位.AddItem (s)
    Next
'    类别
    SQL = "select DISTINCT 类别 from 生产动态 "
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "类别")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.类别.AddItem (s)
    Next
    Set rst = Nothing
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
