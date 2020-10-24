VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} 生产信息查询 
   Caption         =   "生产信息"
   ClientHeight    =   6135
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   11205
   OleObjectBlob   =   "生产信息查询.frx":0000
   StartUpPosition =   1  '所有者中心
End
Attribute VB_Name = "生产信息查询"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public filterS As New Dictionary
Private Sub 名称_Change()
    filterS.Add "名称", Me.名称.value
    
End Sub
Private Sub 单位_Change()
    filterS.Add "单位", Me.单位.value
    
End Sub
Private Sub 类别_Change()
    filterS.Add "类别", Me.类别.value
    
End Sub
Private Sub 状态_Change()
    filterS.Add "状态", Me.状态.value
    
End Sub
Private Sub 备注_Change()
    filterS.Add "备注", Me.备注.value
    
End Sub
Private Sub 查询_Click()
    Worksheets("生产信息").Select
    Call Sheets("生产信息").清除_Click
    Application.EnableEvents = False
    On Error GoTo ErrorHandler
    Dim d1 As Date
    Dim d2 As Date
    Dim d3 As Date
    Dim SQL As String
    Dim filter As String
    Dim s1 As String
    Dim s2 As String
    filter = ""
'    指定日期
    If True = TextBox3.Visible Then
        If IsDate(TextBox3.value) Then
            d1 = TextBox3.value
            s1 = "日期"
            s2 = " = " & "'" & DateValue(d1) & "'"
            filter = s1 & s2
        Else
            MsgBox "不正确的日期格式！"
            Exit Sub
        End If
    End If
'    时间段
    If True = TextBox1.Visible And True = TextBox2.Visible Then
        If IsDate(TextBox1.value) And IsDate(TextBox2.value) Then
            d2 = TextBox1.value
            d3 = TextBox2.value
            s1 = "日期"
            s2 = " between " & "'" & DateValue(d2) & "'" & " and " & "'" & DateValue(d3) & "'"
            filter = s1 & s2
        Else
            MsgBox "不正确的日期格式！"
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
'    office 2003 最大行数，最大列数
    Dim rowLimit As Long
    Dim columnLimit As Integer
    rowLimit = 65536
    columnLimit = 256
    rowLimit = 65536 - 4
    SQL = " Select 日期,名称,单位,数据,类别,状态,月累,年累,备注 from 生产信息 " & "where " & filter & filterFX & " limit " & rowLimit
    Dim Fields
    Fields = Array("日期", "名称", "单位", "数据", "类别", "状态", "月累", "年累", "备注")
    Worksheets("生产信息").[A4].Resize(1, UBound(Fields) + 1) = WorksheetFunction.Transpose(WorksheetFunction.Transpose(Fields))
    Dim psql As New PostgreSQL
    Worksheets("生产信息").[A5].CopyFromRecordset psql.cnn.Execute(SQL)
    Unload 生产信息查询
'    Dim row As Integer
'    Dim column As Integer
'    row = 4
'    column = 1
'    Worksheets("生产信息").Select
'    With ActiveSheet.UsedRange
'        Range(Cells(4, 1), Cells(.Rows.count, .Columns.count)).Select
'    End With
'    Selection.AutoFilter
'    Columns("A:I").Select
'    Selection.ColumnWidth = 12
'    Cells(1, 1).Select
'    Worksheets("生产信息").Columns(1).NumberFormatLocal = "yyyy/m/d;@"
ErrorHandler:
'    MsgBox Err.Description
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

'指定日期
Private Sub CommandButton2_Click()
    TextBox3.Visible = True
    TextBox3.value = DateValue(Now)
    TextBox1.Visible = False
    TextBox2.Visible = False
    Label8.Visible = False
    Label9.Visible = False
End Sub
'时间段
Private Sub CommandButton3_Click()
    TextBox3.Visible = False
    TextBox1.Visible = True
    TextBox1.value = DateSerial(Year(Now), Month(Now), 1)
    TextBox2.Visible = True
    TextBox2.value = DateValue(Now)
    Label8.Visible = True
    Label9.Visible = True
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
    SQL = "select DISTINCT 名称 from 生产信息 order by 名称"
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "名称")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.名称.AddItem (s)
    Next
'    单位
    SQL = "select DISTINCT 单位 from 生产信息 order by 单位"
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "单位")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.单位.AddItem (s)
    Next
'    类别
    SQL = "select DISTINCT 类别 from 生产信息 order by 类别"
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "类别")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.类别.AddItem (s)
    Next
'    状态
    SQL = "select distinct 状态 from 生产信息 order by 状态"
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "状态")
    For Each s In arr
        If s <> "" Then Me.状态.AddItem (s)
    Next
    rst.Close
'    备注
'    SQL = "select DISTINCT 备注 from 生产信息 "
'    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
'    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "备注")
'    rst.Close
'    For Each s In arr
'        If s <> "" Then Me.备注.AddItem (s)
'    Next
    Set rst = Nothing
'    Worksheets("生产信息").Columns(1).NumberFormatLocal = "yyyy/m/d;@"
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub

Private Sub 添加_Click()
    Worksheets("生产信息").Select
    Call Sheets("生产信息").清除_Click
    Dim psql As New PostgreSQL
    Dim tablename As String
    tablename = "生产信息"
    Dim showFields As New Dictionary
    Call psql.getFields(tablename, showFields)
    Dim row As Integer
    Dim column As Integer
    Dim offset As Integer
    row = 4
    column = 1
'    不显示列 ID,数据源
    For offset = 0 To showFields.count - 3
        Cells(row, column + offset).value = showFields.item(offset + 1)
    Next
    Unload 生产信息查询
End Sub

Private Sub 修改_Click()
    Worksheets("生产信息").Select
    Call Sheets("生产信息").清除_Click
    Dim psql As New PostgreSQL
    Dim tablename As String
    tablename = "生产信息"
    Dim showFields As New Dictionary
    Call psql.getFields(tablename, showFields)
    Dim row As Integer
    Dim column As Integer
    Dim offset As Integer
    row = 4
    column = 1
'    不显示列 ID，数据源
    For offset = 0 To showFields.count - 3
        Cells(row, column + offset).value = showFields.item(offset + 1)
    Next
    Unload 生产信息查询
End Sub



