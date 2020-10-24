VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet15"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Private Sub 保存_Click()
    Err.Clear
On Error GoTo errorhander
    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim rst As New ADODB.Recordset
    Dim tablename As String
    Dim 日期 As Date
    Dim 名称 As String
    Dim 单位 As String
    Dim 数据 As Double
    Dim 类别 As String
    Dim 备注 As String
    tablename = "生产信息"
    单位 = " '方' "
    类别 = " '天然气' "
    Dim row As Integer
    Dim column As Integer
    Const rowLimit = 35
    Const columnLimit = 5
    For row = 5 To rowLimit
        For column = 2 To columnLimit
            If Not IsEmpty(Cells(row, 1)) And Not IsNull(Cells(row, 1)) Then
                日期 = Cells(row, 1).value
                Select Case column
                    Case 2
                        名称 = " 'JZ9-3供气' "
                    Case 3
                        名称 = " 'JZ21-1供气' "
                    Case 4
                        名称 = " 'JZ25-1供气' "
                    Case 5
                        名称 = " 'JZ25-1S供气' "
                End Select
                If Not IsEmpty(Cells(row, column)) And Not IsNull(Cells(row, column)) Then
'                    数据库是方，表格是万方
                    数据 = Cells(row, column).value * 10000
'                    access
                    SQL = "select * from 生产信息 " & " where 日期= #" & 日期 & "# and 名称=" & 名称 & " and 单位=" & 单位
                    rst.Open SQL, ac.cnn, adOpenKeyset, adLockOptimistic
                    If rst.RecordCount > 0 Then
                        SQL = " UPDATE " & tablename & " SET 数据=" & 数据 & " where 日期= #" & 日期 & "# and 名称=" & 名称 & " and 单位=" & 单位
                        Call ac.cnn.Execute(SQL)
                    Else
                        SQL = "INSERT INTO " & tablename & " (日期,名称,单位,数据,类别) VALUES ( #" & 日期 & "#," & 名称 & "," & 单位 & "," & 数据 & "," & 类别 & " )"
                        Call ac.cnn.Execute(SQL)
                    End If
                    rst.Close
'                    PostgreSQL
                    SQL = "select * from 生产信息 " & " where 日期= '" & 日期 & "' and 名称=" & 名称 & " and 单位=" & 单位
                    rst.Open SQL, psql.cnn, adOpenKeyset, adLockOptimistic
                    If rst.RecordCount > 0 Then
                        SQL = " UPDATE " & tablename & " SET 数据=" & 数据 & " where 日期= '" & 日期 & "' and 名称=" & 名称 & " and 单位=" & 单位
                        Call psql.cnn.Execute(SQL)
                    Else
                        SQL = "INSERT INTO " & tablename & " (日期,名称,单位,数据,类别) VALUES ( '" & 日期 & "'," & 名称 & "," & 单位 & "," & 数据 & "," & 类别 & " )"
                        Call psql.cnn.Execute(SQL)
                    End If
                    rst.Close
                End If
            End If
        Next column
    Next row
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 查询_Click()
    Err.Clear
On Error GoTo errorhander
    Call 清除_Click
    Dim sd As String
    Dim 结束日期 As Date
    Dim 开始日期 As Date
    Dim 日期 As Date
    sd = InputBox("请输入指定日期：", "上下游海管半小时一记", Format(Now, "YYYY-MM-dd"))
    If False = IsDate(sd) Then
        MsgBox "日期不正确!"
        Exit Sub
    End If
    结束日期 = CDate(sd)
    Cells(3, 5).value = Year(结束日期)
    Dim row As Integer
    Dim column As Integer
    开始日期 = DateSerial(Year(结束日期), Month(结束日期), 1)
    Dim ac As New access
    Dim SQL As String
    Dim filter As String
    Dim 名称 As String
    Dim 单位 As String
    单位 = " '方' "
    row = 5
    column = 1
    For i = 0 To DateDiff("d", 开始日期, 结束日期)
        Cells(row + i, 1).value = DateAdd("d", i, 开始日期)
        日期 = Cells(row + i, 1).value
        filter = " 日期= #" & Format(日期, "YYYY-MM-DD") & "# "
        SQL = "SELECT 数据/10000 as 万方 FROM 生产信息  WHERE " & filter & " and 名称='JZ9-3供气' and 单位='方' "
        Worksheets("上游").Cells(row + i, column + 1).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "SELECT 数据/10000 as 万方 FROM 生产信息  WHERE " & filter & " and 名称='JZ21-1供气' and 单位='方' "
        Worksheets("上游").Cells(row + i, column + 2).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "SELECT 数据/10000 as 万方 FROM 生产信息  WHERE " & filter & " and 名称='JZ25-1供气' and 单位='方' "
        Worksheets("上游").Cells(row + i, column + 3).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "SELECT 数据/10000 as 万方 FROM 生产信息  WHERE " & filter & " and 名称='JZ25-1S供气' and 单位='方' "
        Worksheets("上游").Cells(row + i, column + 4).CopyFromRecordset ac.cnn.Execute(SQL)
    Next i
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 工艺生产_Click()
    Worksheets("工艺生产").Select
End Sub

Private Sub 清除_Click()
    Cells(3, 5).ClearContents
    Worksheets("上游").Range(Cells(5, 1), Cells(35, 5)).Select
    Selection.ClearContents
    Worksheets("上游").Cells(5, 2).Select
End Sub

Private Sub 主页_Click()
    Worksheets("主页").Select
End Sub
