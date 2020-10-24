VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet22"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Private Sub 轻烃化验月报_Click()
    Err.Clear
On Error GoTo errorhander
    Call 清除_Click
    Dim sd, 月初, 月末, 下月初, 日期 As Date
    sd = InputBox("请输入指定年月：", "查询指定时间产品纯度年报", Format(Now, "YYYY/MM"))
    If False = IsDate(sd) Then
        MsgBox "日期不正确!"
        Exit Sub
    End If
    月初 = DateSerial(Year(sd), Month(sd), 1)
    下月初 = DateSerial(Year(sd), Month(sd) + 1, 1)
    月末 = DateAdd("d", -1, 下月初)
    
    Dim beginRow, beginColumn, lastRow, lastColumn, row, column, ro, co, count As Single
    beginRow = 4
    beginColumn = 1
    Dim Title As String
    Title = "产品纯度月报"
    Cells(beginRow, beginColumn).value = Title
    Dim ar As Variant
    ar = Array("日期", "甲烷", "乙烷", "丙烷", "丁烷", "外输气", "原料气")
    Dim sr, SQL, tablename, filter, 字段名, 名称 As String
    tablename = "轻烃组分"
    sr = Join(ar, ",")
    Dim rn As Range
    lastColumn = beginColumn + UBound(ar)
    If Cells(beginRow, beginColumn).MergeCells Then
        Cells(beginRow, beginColumn).UnMerge
        Set rn = Cells(beginRow, beginColumn).Resize(1, lastColumn)
        rn.Merge
    End If
    ro = 1
    Range(Cells(beginRow + ro, beginColumn), Cells(beginRow + ro, lastColumn)) = ar
    Dim psql As New PostgreSQL
'    日期
    SQL = "SELECT * FROM generate_series('" & 月初 & "'::timestamp,'" & 月末 & "', '1 day')"
    ro = 2
'    beginrow = beginrow + ro
    Cells(beginRow + ro, beginColumn).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT count(*) FROM generate_series('" & 月初 & "'::timestamp,'" & 月末 & "', '1 day')"
    count = psql.cnn.Execute(SQL)(0)
    lastRow = beginRow + ro + count - 1
'    beginColumn = beginColumn + 1
    For row = beginRow + ro To lastRow
        For column = 2 To lastColumn
            co = column - 1
            日期 = Cells(row, beginColumn).value
            名称 = ar(co)
            filter = " and 名称='" & 名称 & "'"
'            甲烷
            If column = 2 Then
                字段名 = "C1"
            End If
'            乙烷
            If column = 3 Then
                字段名 = "C2"
            End If
'            丙烷
            If column = 4 Then
                字段名 = "C3"
                filter = " and 名称='" & 名称 & "' and 取样点='PV-3157-1'"
            End If
'            丁烷
            If column = 5 Then
                字段名 = "iC4+nC4 as C4"
                filter = " and 名称='" & 名称 & "' and 取样点='PV-3258-1'"
            End If
'            外输气
            If column = 6 Then
                字段名 = "C1"
            End If
'            原料气
            If column = 7 Then
                字段名 = "C1"
            End If
            SQL = "select " & 字段名 & " from " & tablename & " where 日期='" & 日期 & "' " & filter
            Cells(row, column).value = psql.cnn.Execute(SQL)(0)
        Next column
    Next row
'    Shapes.AddChart
'    ActiveChart.SetSourceData Source:=Range(Cells(beginRow, beginColumn), Cells(lastRow, lastColumn))
'    ActiveChart.ChartType = xlLineMarkers
    Cells(1, 1).Select
errorhander:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub

Private Sub 文件导入_Click()
    Err.Clear
On Error GoTo errorhander
'    Dim psql As New PostgreSQL
'    Call psql.数据库整理
    Dim filter As String
    filter = "microsoft office excel files (*.xls),*.xls"
'    filefilter1 = "所有文件,*.*"
    Dim fn
    fn = Application.GetOpenFilename(filter, , "请选文件", , MultiSelect:=True)
    If Not IsArray(fn) Then Exit Sub
    Dim temp
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
    Dim testData As New 化验单
    Dim gasRecord As Object
    Dim waterRecord As Object
    Dim oilRecord As Object
    Dim scRecord As Object
    Set gasRecord = CreateObject("Scripting.Dictionary")
    Set waterRecord = CreateObject("Scripting.Dictionary")
    Set oilRecord = CreateObject("Scripting.Dictionary")
    Set scRecord = CreateObject("Scripting.Dictionary")
    Dim wb
    For Each temp In fn
        Application.ScreenUpdating = False
        Set wb = Workbooks.Open(temp, 0, ReadOnly)
        Call testData.dataMining(gasRecord, waterRecord, oilRecord, scRecord)
        wb.Close SaveChanges:=False
        Set wb = Nothing
        Application.ScreenUpdating = True
    Next temp
    Dim gtd As New 轻烃组分
    Call gtd.PushTableToDatabase(gasRecord)
    Dim otd As New 滑油检测
    Call otd.PushTableToDatabase(oilRecord)
    Dim wtd As New 水质检测
    Call wtd.PushTableToDatabase(waterRecord)
    Dim scxx As New 生产信息
    Call scxx.PushTableToDatabase(scRecord)
'    For Each temp In scRecord.Keys
'        Debug.Print temp.日期, temp.名称, temp.单位, temp.数据, temp.类别, temp.备注
'    Next temp

errorhander:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
End Sub

Private Sub 循环水质年报_Click()
    Err.Clear
On Error GoTo errorhander
    Call 清除_Click
    Dim SQL, filter As String
    Dim sd As Date
    sd = InputBox("请输入指定年：", "查询指定时间循环水质年报", Year(Now))
    If False = IsDate(sd) Then
        MsgBox "日期不正确!"
        Exit Sub
    End If
    Dim 年初 As Date
    年初 = DateSerial(sd, 1, 1)
    年末 = DateSerial(sd, 12, 31)
    tablename = "水质检测"
    filter = " where 日期 between '" & 年初 & "' and '" & 年末 & "'  and 名称='循环水'"
    filterFX = " order by 日期 "
    SQL = " Select 日期,PH值, 浊度, 电导率, 总碱度, 总硬度, LSI, 氯离子, 总铁 from " & tablename & filter & filterFX
'    Debug.Print SQL
    Dim psql As New PostgreSQL
    Range("A4:I4").Merge
    Cells(4, 1).value = "循环水" & tablename
    Range("A4").HorizontalAlignment = xlCenter
    ar = Array("日期", "PH值", "浊度", "电导率", "总碱度", "总硬度", "LSI", "氯离子", "总铁")
    Range("A5:I5") = ar
    Worksheets("化验").Cells(6, 1).CopyFromRecordset psql.cnn.Execute(SQL)
'    图表
    Dim beginRow, lastRow, beginColumn, lastColumn, 行数 As Long
    beginRow = 5
    beginColumn = 1
    SQL = "select count(日期) from " & tablename & filter & " and 名称='循环水' "
    行数 = psql.cnn.Execute(SQL)(0)
    lastRow = beginRow + 行数
    lastColumn = beginColumn + UBound(ar)
    Range(Cells(beginRow, beginColumn), Cells(lastRow, lastColumn)).Select
    ActiveSheet.Shapes.AddChart.Select
'    expression.Add(Left, Top, Width, Height)
'    expression.SetSourceData(Source, PlotBy)
    ActiveChart.SetSourceData source:=Range(Cells(beginRow, beginColumn), Cells(lastRow, lastColumn))
    ActiveChart.ChartType = xlLineMarkers
    ActiveChart.ChartTitle.Text = "循环水" & tablename & "年报"
errorhander:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
End Sub

Private Sub 循环水质月报_Click()
    Err.Clear
On Error GoTo errorhander
    Call 清除_Click
    Dim SQL, filter As String
    Dim sd As Date
    sd = InputBox("请输入指定年月：", "查询指定时间循环水质月报", Format(Now, "YYYY/MM"))
    If False = IsDate(sd) Then
        MsgBox "日期不正确!"
        Exit Sub
    End If
    Dim 月初, 下月初, 月末 As Date
    月初 = DateSerial(Year(sd), Month(sd), 1)
    下月初 = DateSerial(Year(sd), Month(sd) + 1, 1)
    月末 = DateDiff("d", 1, 下月初)
    tablename = "水质检测"
    filter = " where 日期 between '" & 月初 & "' and '" & 月末 & "' and 名称='循环水'"
    filterFX = " order by 日期 "
    SQL = " Select 日期,PH值, 浊度, 电导率, 总碱度, 总硬度, LSI, 氯离子, 总铁 from " & tablename & filter & filterFX
'    Debug.Print SQL
    Dim psql As New PostgreSQL
    Range("A4:I4").Merge
    Cells(4, 1).value = "循环水" & tablename
    Range("A4").HorizontalAlignment = xlCenter
    ar = Array("日期", "PH值", "浊度", "电导率", "总碱度", "总硬度", "LSI", "氯离子", "总铁")
    sr = Join(ar, ",")
    Debug.Print sr
    Range("A5:I5") = ar
    Worksheets("化验").Cells(6, 1).CopyFromRecordset psql.cnn.Execute(SQL)
'    图表
    Dim beginRow, lastRow, beginColumn, lastColumn, 行数 As Long
    beginRow = 5
    beginColumn = 1
    SQL = "select count(日期) from " & tablename & filter & " and 名称='循环水' "
    行数 = psql.cnn.Execute(SQL)(0)
    lastRow = beginRow + 行数
    lastColumn = beginColumn + UBound(ar)
'    lastColumn = ActiveSheet.UsedRange.Columns.count
'    Range("A5:I29").Select
    Range(Cells(beginRow, beginColumn), Cells(lastRow, lastColumn)).Select
    ActiveSheet.Shapes.AddChart.Select
'    ActiveChart.SetSourceData Source:=Range("'化验'!$A$5:$I$29")
    ActiveChart.SetSourceData source:=Range(Cells(beginRow, beginColumn), Cells(lastRow, lastColumn))
    ActiveChart.ChartType = xlLineMarkers
    ActiveChart.ChartTitle.Text = "循环水" & tablename & "月报"
errorhander:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
End Sub

Private Sub 工艺_Click()
On Error Resume Next
    Worksheets("工艺生产").Select
End Sub

Private Sub 清除_Click()
    Dim rowLimit As Long
    Dim columnLimit As Integer
'    清除有效数据区域
    With ActiveSheet.UsedRange
        Range(Cells(4, 1), Cells(.Rows.count, .Columns.count)).Select
    End With
    Selection.ClearContents
'    清除图表
    Dim x, cx
    For Each x In Sheets("化验").ChartObjects
        x.Delete
    Next x
    Cells(1, 1).Select
End Sub


Private Sub 数据采集_Click()
'    Dim psql As New PostgreSQL
'    Call psql.数据库整理
    hasright = True
    If True = hasright Then
        Dim mydir As String
        Dim F As New 文件目录
        mydir = F.pathSelect
        If "" = mydir Then
            Exit Sub
        End If
        Dim fileList As Object
        Set fileList = CreateObject("Scripting.Dictionary")
        Dim pattern As String
        pattern = ".*xls$"
        Call F.FindFiles(mydir, pattern, fileList)
    '    Debug.Print "找到" & fileList.count & "文件！"
        Dim temp
        Dim table As Object
        Set table = CreateObject("Scripting.Dictionary")
        Dim testData As New 化验单
        Dim gasRecord As Object
        Dim waterRecord As Object
        Dim oilRecord As Object
        Dim scRecord As Object
        Set gasRecord = CreateObject("Scripting.Dictionary")
        Set waterRecord = CreateObject("Scripting.Dictionary")
        Set oilRecord = CreateObject("Scripting.Dictionary")
        Set scRecord = CreateObject("Scripting.Dictionary")
        Dim wb
        For Each temp In fileList.Keys
'            Debug.Print temp
'            Call TestData.getValue(temp, table)
            Application.ScreenUpdating = False
            Set wb = Workbooks.Open(temp, 0, ReadOnly)
            Call testData.dataMining(gasRecord, waterRecord, oilRecord, scRecord)
            wb.Close SaveChanges:=False
            Set wb = Nothing
            Application.ScreenUpdating = True
        Next temp
        Dim gtd As New 轻烃组分
        Call gtd.PushTableToDatabase(gasRecord)
        Dim otd As New 滑油检测
        Call otd.PushTableToDatabase(oilRecord)
        Dim wtd As New 水质检测
        Call wtd.PushTableToDatabase(waterRecord)
        Dim scxx As New 生产信息
        Call scxx.PushTableToDatabase(scRecord)
'        Debug.Print table.count
'
'        Dim wtd As New 水质检测
'        Call wtd.PushTableToDatabase(table)

    End If
    hasright = False
End Sub

Private Sub 主页_Click()
On Error Resume Next
    Worksheets("主页").Select
End Sub

Public Sub 报表(beginRow, beginColumn, lastRow, lastColumn)
    Err.Clear
On Error GoTo errorhander
'    图表
    Shapes.AddChart
    ActiveChart.SetSourceData source:=Range(Cells(beginRow, beginColumn), Cells(lastRow, lastColumn))
    ActiveChart.ChartType = xlLineMarkers
errorhander:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
End Sub
