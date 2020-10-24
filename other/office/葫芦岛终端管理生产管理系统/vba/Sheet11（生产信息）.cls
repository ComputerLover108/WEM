VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet11"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private Sub 保存_Click()
Err.Clear
On Error GoTo ErrorHandler
    Dim sd As String
    sd = InputBox("请输入密码：", "危险操作！数据库中信息改变后将不能恢复！！！", "******")
    Dim h As New help
    If True = h.checkRight(sd) Then
        Dim rowLimit As Long
        Dim columnLimit As Integer
        Dim row As Long
        Dim column As Long
    '    获得最后一个非空行
        rowLimit = Range("A65536").End(xlUp).row
        If rowLimit <= 4 Then Exit Sub
        columnLimit = 9
        Dim recordSC As New 生产信息
        Dim table As New Dictionary
        For row = 5 To rowLimit
            For column = 1 To columnLimit
                Select Case column
                    Case 1
                        recordSC.日期 = Cells(row, column).value
                    Case 2
                        recordSC.名称 = Cells(row, column).value
                    Case 3
                        recordSC.单位 = Cells(row, column).value
                    Case 4
                        recordSC.数据 = Cells(row, column).value
                    Case 5
                        recordSC.类别 = Cells(row, column).value
                    Case 6
                        recordSC.状态 = Cells(row, column).value
                    Case 7
                        recordSC.月累 = Cells(row, column).value
                    Case 8
                        recordSC.年累 = Cells(row, column).value
                    Case 9
                        recordSC.备注 = Cells(row, column).value
                End Select
            Next column
            If recordSC.isFormat(recordSC) Then
                table.Add recordSC, ""
                Set recordSC = Nothing
            End If
        Next row
        Debug.Print "准备导入" & table.count & "条记录！"
    '    备份数据库
        Dim fs As Object
        Set fs = CreateObject("Scripting.FileSystemObject")
        Dim backupDB As String
        Dim DBname As String
        DBname = ThisWorkbook.path & Application.PathSeparator & "葫芦岛天然气处理厂.mdb"
        backupDB = ThisWorkbook.path & Application.PathSeparator & Format(Now, "YYYY年MM月DD日HH点MM分SS秒") & " 葫芦岛天然气处理厂.mdb"
        fs.CopyFile DBname, backupDB, True
    '    修改存入数据库
        Dim scxx As New 生产信息
        Call scxx.PushTableToDatabase(table)
    '    columnLimit = ActiveSheet.UsedRange.Columns.count
    '    Dim cnn As New ADODB.Connection
    '    cnn.Open "Provider=Microsoft.jet.OLEDB.4.0;Extended Properties=Excel 8.0;Data Source=" & ThisWorkbook.FullName
    '    Dim SQL As String
    '    Dim tableName As String
    '    SQL = "SELECT * FROM [Sheet1$A1:B10]"
    MsgBox ("修改成功")
    Else
        MsgBox "密码不对！禁止危险操作！"
        Exit Sub
    End If
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description

End Sub

Private Sub 返回_Click()
    Worksheets("工艺生产").Select
End Sub

Private Sub 返回主页_Click()
    Worksheets("主页").Select
End Sub

Public Sub 清除_Click()
    Dim rowLimit As Long
    Dim columnLimit As Integer
'    office 2003 最大行数，最大列数
'    rowLimit = 65536
'    columnLimit = 256
'    Dim row As Long
'    Dim column As Integer
'    row = 4
'    column = 1
'    Range(Cells(4, 1), Cells(rowLimit, columnLimit)).Clear
'    清除有效数据区域
    With ActiveSheet.UsedRange
        Range(Cells(4, 1), Cells(.Rows.count, .Columns.count)).Select
    End With
    Selection.ClearContents
'    清除图表
    Dim x, cx
    For Each x In Sheets("生产信息").ChartObjects
        x.Delete
    Next x
    Cells(5, 1).Select
End Sub

Private Sub 本月生产情况_Click()
On Error GoTo ErrorHandler
    Call Worksheets("生产信息").清除_Click
    Dim showFields As String
    Dim tablename As String
    Dim filter1 As String
    Dim filter2 As String
    Dim filterFX As String
    Dim SQL As String
    Dim 月初 As Date
    Dim cnn As New ADODB.Connection
    Dim ac As New access
    月初 = DateSerial(Year(Now), Month(Now), 1)
'    showFields = " 名称,format(日期,""YYYY-MM-DD""),数据 "
    tablename = "生产信息"
    filter1 = " where 日期 between #" & 月初 & "# and #" & Now() & "# "
'    filter2 = " and 名称 in ('天然气月配产','轻油月配产','丙丁烷月配产') and 单位='方' "
    filterFX = " order by 日期 "
'    SQL = "select " & showFields & " from " & tableName
'    SQL = SQL & filter1 & filter2 & filterFX
'    Worksheets("生产信息").Cells(5, 2).CopyFromRecordset ac.cnn.Execute(SQL)
'    转置
'    Dim arr()
'    arr = ac.cnn.Execute(SQL).GetRows
'    Cells(5, 2).Resize(UBound(arr) + 1, UBound(arr, 2) + 1) = arr
'    showFields = " 名称,format(日期,""YYYY-MM-DD""),月累 "
'    filter2 = "and 名称 in ('总外输气量','轻油回收量','丙丁烷回收量') and 单位='方' "
'    SQL = "select " & showFields & " from " & tableName
'    SQL = SQL & filter1 & filter2 & filterFX
'    Worksheets("生产信息").Cells(5, 5).CopyFromRecordset ac.cnn.Execute(SQL)
    Dim row As Integer
    Dim column As Integer
    Dim offset As Integer
    Dim limit As Integer
    limit = 7
    row = 6
    For column = 1 To limit
        Select Case column
            Case 1
                showFields = " 日期 "
                filter2 = "and 名称='天然气月配产' and 单位='方' "
                Cells(row - 1, column).value = "日期"
            Case 2
                showFields = " 数据 "
                filter2 = "and 名称='天然气月配产' and 单位='方' "
                Cells(row - 1, column).value = "天然气月配产"
            Case 3
                showFields = " 月累 "
                filter2 = "and 名称='总外输气量' and 单位='方' "
                Cells(row - 1, column).value = "天然气生产"
            Case 4
                showFields = " 数据 "
                filter2 = "and 名称='轻油月配产' and 单位='方' "
                Cells(row - 1, column).value = "轻油月配产"
            Case 5
                showFields = " 月累 "
                filter2 = "and 名称='轻油回收量' and 单位='方' "
                Cells(row - 1, column).value = "轻油回收量"
            Case 6
                showFields = " 数据 "
                filter2 = "and 名称='丙丁烷月配产' and 单位='方' "
                Cells(row - 1, column).value = "丙丁烷月配产"
            Case 7
                showFields = " 月累 "
                filter2 = "and 名称='丙丁烷回收量' and 单位='方' "
                Cells(row - 1, column).value = "丙丁烷回收量"
        End Select
        SQL = "select " & showFields & " from " & tablename
        SQL = SQL & filter1 & filter2 & filterFX
        Worksheets("生产信息").Cells(row, column).CopyFromRecordset ac.cnn.Execute(SQL)
    Next column
'    统计当月记录天数
    Dim rst As New ADODB.Recordset
    SQL = "select * from " & tablename & filter1 & " and 名称='总外输气量' and 单位='方' "
    rst.Open SQL, ac.cnn, adOpenKeyset, adLockOptimistic
'    Cells(rst.RecordCount + 5, 1).Select
'    制作轻油回收量，丙丁烷回收量图表
    Charts.Add
    ActiveChart.ChartType = xlColumnClustered
    ActiveChart.SetSourceData source:=Sheets("生产信息").Range(Cells(5, 1), Cells(rst.RecordCount + 5, 7)), PlotBy:= _
        xlColumns
    ActiveChart.SeriesCollection(1).Delete
    ActiveChart.SeriesCollection(1).Delete
    ActiveChart.Location WHERE:=xlLocationAsObject, name:="生产信息"
    With ActiveChart
        .HasTitle = False
        .Axes(xlCategory, xlPrimary).HasTitle = False
        .Axes(xlValue, xlPrimary).HasTitle = False
        .Axes(xlValue).TickLabels.Font.Size = 9
    End With
    Dim 行高 As Integer
    Dim 列宽 As Integer
    Dim 图表名称
    行高 = Range("A1").height
    列宽 = Range("A1").Width
    Dim i As Integer
    i = 0
    i = i + 1
    图表名称 = ActiveSheet.ChartObjects(i).name
    With ActiveSheet.Shapes(图表名称)
        .Top = 5 * 行高
        .Left = 1 * 列宽
        .height = 20 * 行高
'        .Width = 10 * 列宽
    End With
'    制作天然气图表
'    Cells(rst.RecordCount + 5, 7).Select
    Charts.Add
    ActiveChart.ChartType = xlColumnClustered
    ActiveChart.SetSourceData source:=Sheets("生产信息").Range(Cells(5, 1), Cells(rst.RecordCount + 5, 3)), PlotBy:= _
        xlColumns
    ActiveChart.Location WHERE:=xlLocationAsObject, name:="生产信息"
    With ActiveChart
        .HasTitle = False
        .Axes(xlCategory, xlPrimary).HasTitle = False
        .Axes(xlValue, xlPrimary).HasTitle = False
        .Axes(xlValue).TickLabels.Font.Size = 9
    End With
    i = i + 1
    图表名称 = ActiveSheet.ChartObjects(i).name
    With ActiveSheet.Shapes(图表名称)
        .Top = 5 * 行高
        .Left = 8 * 列宽
        .height = 20 * 行高
'        .Width = 10 * 列宽
    End With
'    ActiveWindow.Visible = False
'    Windows(ThisWorkbook.FullName).Activate

ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 本年生产情况_Click()
On Error GoTo ErrorHandler
    Call Worksheets("生产信息").清除_Click
    Dim showFields As String
    Dim tablename As String
    Dim filter1 As String
    Dim filter2 As String
    Dim SQL As String
    Dim cnn As New ADODB.Connection
    Dim ac As New access
    tablename = "生产信息"
    Dim row As Integer
    Dim column As Integer
    Dim offset As Integer
    offset = 1
    Dim limit As Integer
    limit = 7
    row = 6
    Dim 月初 As Date
    Dim 下月 As Date
    Dim 月底 As Date
    Dim sd As String
    Do While offset <= Month(Now)
        月初 = DateSerial(Year(Now), offset, 1)
        下月 = DateAdd("m", 1, 月初)
        月底 = DateAdd("d", -1, 下月)
        For column = 1 To limit
            Select Case column
                Case 1
                    showFields = " max(日期) "
                    filter1 = " where 日期 between #" & 月初 & "# and #" & 月底 & "# "
                    filter2 = " and 名称='天然气年配产' and 单位='方' "
                    If row = 6 Then
                        Cells(row - 1, column).value = "日期"
                    End If
                Case 2
                    showFields = " 数据 "
                    filter1 = " where 日期= #" & 月初 & "# "
                    filter2 = "and 名称='天然气年配产' and 单位='方' "
                    If row = 6 Then
                        Cells(row - 1, column).value = "天然气年配产"
                    End If
                Case 3
                    showFields = " sum(数据) "
                    filter1 = " where 日期 between #" & DateSerial(Year(Now), 1, 1) & "# and #" & 月底 & "# "
                    filter2 = "and 名称='总外输气量' and 单位='方' "
                    If row = 6 Then
                        Cells(row - 1, column).value = "天然气生产"
                    End If
                Case 4
                    showFields = " 数据 "
                    filter1 = " where 日期= #" & 月初 & "# "
                    filter2 = "and 名称='轻油年配产' and 单位='方' "
                    If row = 6 Then
                        Cells(row - 1, column).value = "轻油年配产"
                    End If
                Case 5
                    showFields = " sum(数据) "
                    filter1 = " where 日期 between #" & DateSerial(Year(Now), 1, 1) & "# and #" & 月底 & "# "
                    filter2 = "and 名称='轻油回收量' and 单位='方' "
                    If row = 6 Then
                        Cells(row - 1, column).value = "轻油回收量"
                    End If
                Case 6
                    showFields = " 数据 "
                    filter1 = " where 日期= #" & 月初 & "# "
                    filter2 = "and 名称='丙丁烷年配产' and 单位='方' "
                    If row = 6 Then
                        Cells(row - 1, column).value = "丙丁烷年配产"
                    End If
                Case 7
                    showFields = " sum(数据) "
                    filter1 = " where 日期 between #" & DateSerial(Year(Now), 1, 1) & "# and #" & 月底 & "# "
                    filter2 = "and 名称='丙丁烷回收量' and 单位='方' "
                    If row = 6 Then
                        Cells(row - 1, column).value = "丙丁烷回收量"
                    End If
            End Select
            SQL = "select " & showFields & " from " & tablename
            SQL = SQL & filter1 & filter2
            Worksheets("生产信息").Cells(row + offset - 1, column).CopyFromRecordset ac.cnn.Execute(SQL)
        Next column
        offset = offset + 1
    Loop
'    制作轻油回收量，丙丁烷回收量图表
    Charts.Add
    ActiveChart.ChartType = xlColumnClustered
    ActiveChart.SetSourceData source:=Sheets("生产信息").Range(Cells(5, 2), Cells(12 + 5, 7)), PlotBy:= _
        xlColumns
    ActiveChart.SeriesCollection(1).Delete
    ActiveChart.SeriesCollection(1).Delete
    ActiveChart.Location WHERE:=xlLocationAsObject, name:="生产信息"
    With ActiveChart
        .HasTitle = False
        .Axes(xlCategory, xlPrimary).HasTitle = False
        .Axes(xlValue, xlPrimary).HasTitle = False
        .Axes(xlValue).TickLabels.Font.Size = 9
    End With
    Dim 行高 As Integer
    Dim 列宽 As Integer
    Dim 图表名称
    行高 = Range("A1").height
    列宽 = Range("A1").Width
    Dim i As Integer
    i = 0
    i = i + 1
    图表名称 = ActiveSheet.ChartObjects(i).name
    With ActiveSheet.Shapes(图表名称)
        .Top = 5 * 行高
        .Left = 1 * 列宽
        .height = 20 * 行高
'        .Width = 10 * 列宽
    End With
'    制作天然气图表
'    Cells(rst.RecordCount + 5, 7).Select
    Charts.Add
    ActiveChart.ChartType = xlColumnClustered
    ActiveChart.SetSourceData source:=Sheets("生产信息").Range(Cells(5, 2), Cells(12 + 5, 3)), PlotBy:= _
        xlColumns
    ActiveChart.Location WHERE:=xlLocationAsObject, name:="生产信息"
    With ActiveChart
        .HasTitle = False
        .Axes(xlCategory, xlPrimary).HasTitle = False
        .Axes(xlValue, xlPrimary).HasTitle = False
        .Axes(xlValue).TickLabels.Font.Size = 9
    End With
    i = i + 1
    图表名称 = ActiveSheet.ChartObjects(i).name
    With ActiveSheet.Shapes(图表名称)
        .Top = 5 * 行高
        .Left = 8 * 列宽
        .height = 20 * 行高
'        .Width = 10 * 列宽
    End With
'    ActiveWindow.Visible = False
'    Windows(ThisWorkbook.FullName).Activate
    
    
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 数据库删除_Click()
Err.Clear
On Error GoTo ErrorHandler
    Dim sd As String
    sd = InputBox("请输入密码：", "危险操作！数据库中信息删除后将不能回复！！！", "******")
    Dim h As New help
    If True = h.checkRight(sd) Then
'        备份数据库
        Dim fs As Object
        Set fs = CreateObject("Scripting.FileSystemObject")
        Dim backupDB As String
        Dim DBname As String
        DBname = ThisWorkbook.path & Application.PathSeparator & "葫芦岛天然气处理厂.mdb"
        backupDB = ThisWorkbook.path & Application.PathSeparator & Format(Now, "YYYY年MM月DD日HH点MM分SS秒") & " 葫芦岛天然气处理厂.mdb"
        fs.CopyFile DBname, backupDB, True
'        数据库删除数据
        Dim rowLimit As Long
        Dim columnLimit As Long
        rowLimit = Range("a65535").End(xlUp).row
        Dim row As Long
        Dim ac As New access
        Dim psql As New PostgreSQL
        Dim SQL As String
        Dim tablename As String
        tablename = "生产信息"
        Dim 日期 As Date
        Dim 名称 As String
        Dim 单位 As String
        Dim 备注 As String
        For row = 5 To rowLimit
            If Rows(row).Hidden = False Then
                日期 = Cells(row, 1).value
                名称 = Cells(row, 2).value
                单位 = Cells(row, 3).value
                If IsEmpty(Cells(row, 9)) Then
                    SQL = "delete from " & tablename & " where 日期 = #" & 日期 & "# and 名称 = '" & 名称 & "' and 单位 = '" & 单位 & "'"
                    Call ac.cnn.Execute(SQL)
                    SQL = "delete from " & tablename & " where 日期 = '" & 日期 & "' and 名称 = '" & 名称 & "' and 单位 = '" & 单位 & "'"
                    Call psql.cnn.Execute(SQL)
                Else
                    备注 = Cells(row, 9).value
                    SQL = "delete from " & tablename & " where 日期 = #" & 日期 & "# and 名称 = '" & 名称 & "' and 单位 = '" & 单位 & "' and 备注 = '" & 备注 & "'"
                    Call ac.cnn.Execute(SQL)
                    SQL = "delete from " & tablename & " where 日期 = '" & 日期 & "' and 名称 = '" & 名称 & "' and 单位 = '" & 单位 & "' and 备注 = '" & 备注 & "'"
                    Call psql.cnn.Execute(SQL)
                    
                End If
                Rows(row).ClearContents
            End If
        Next row
    Else
        MsgBox "密码不对！禁止危险操作！"
        Exit Sub
    End If
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
'    PostgreSQL 未连接代码 -2147467259
    If -2147467259 = Err.Number Then
        MsgBox "PostgreSQL 数据库没有打开！"
        Exit Sub
    End If
End Sub

Public Sub test()
    Dim rowLimit As Long
    Dim columnLimit As Long
    rowLimit = Range("A65536").End(xlUp).row
    columnLimit = Range(Cells(4, 1), Cells(4, 128)).End(xlToRight).column
    Debug.Print rowLimit & "," & columnLimit
End Sub


Private Sub 整理_Click()
    Dim ac As New access
    Call ac.removeDuplicate
    
End Sub
