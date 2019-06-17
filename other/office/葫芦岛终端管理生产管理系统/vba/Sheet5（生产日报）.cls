VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet5"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
'工艺生产
Private Sub 返回_Click()
On Error Resume Next
    Sheets("工艺生产").Select
End Sub
'快速录入
Private Sub 快速录入_Click()
On Error Resume Next
    Sheets("快速录入").Select
End Sub
'保存
Private Sub 保存_Click()
'    Application.DisplayAlerts = False
'    Application.Visible = False
'    Debug.Print ActiveWorkbook.name
Err.Clear
On Error GoTo ErrorHandler
    Dim 日期
    日期 = Worksheets("生产日报").Cells(2, 1).value
    If Not IsDate(日期) Then
        Worksheets("生产日报").Cells(2, 1).Select
        MsgBox 日期 & "不是正确的日期格式!"
        Exit Sub
    End If
'    自动计算
'    Call 修改_Click
    
    Dim backupPath As String
    Dim path As New 文件目录
    backupPath = path.自动建立备份目录(ActiveWorkbook.path, 日期)
    Const name = " 葫芦岛天然气终端厂生产日报.xls"
    Dim sd As String
    sd = Format(日期, "YYYY-MM-DD")
    Dim absFname As String
    absFname = backupPath & Application.PathSeparator & sd & name
    Dim fs As Object
    Set fs = CreateObject("Scripting.FileSystemObject")
    absFname = fs.getabsolutepathname(absFname)
    ThisWorkbook.save
    Dim ps As Object
    Set ps = Worksheets("生产日报").PageSetup
    Dim row, column, beginRow, beginColumn, lastRow, lastColumn As Single
    beginRow = 1
    beginColumn = 1
    lastRow = UsedRange.Rows.count
    lastColumn = 9
    Dim rowHeights, columnWidths As Object
    Set rowHeights = CreateObject("Scripting.Dictionary")
    Set columnWidths = CreateObject("Scripting.Dictionary")
    For row = beginRow To lastRow
        rowHeights.Add row, Worksheets("生产日报").Rows(row).RowHeight
    Next row
    For column = beginColumn To lastColumn
        columnWidths.Add column, Worksheets("生产日报").Columns(column).ColumnWidth
    Next column
    
    Worksheets("生产日报").Range(Cells(beginRow, beginColumn), Cells(lastRow, lastColumn)).Select
'    Worksheets("生产日报").Cells.Select
    Selection.Copy
    Set wb = Workbooks.Add
    ActiveSheet.Paste
    Selection.PasteSpecial Paste:=xlPasteColumnWidths, Operation:=xlNone, _
        SkipBlanks:=False, Transpose:=False
    Selection.PasteSpecial Paste:=xlPasteValuesAndNumberFormats, Operation:= _
        xlNone, SkipBlanks:=False, Transpose:=False
    wb.Worksheets(1).name = "生产日报"

   
'    清除图表
    Dim x
    For Each x In wb.Worksheets("生产日报").ChartObjects
        x.Delete
    Next x
    

    With wb.Worksheets("生产日报").PageSetup
        .LeftMargin = ps.LeftMargin     '页边距：左(L)_
        .RightMargin = ps.RightMargin     '页边距：右(R)
        .TopMargin = ps.TopMargin          '页边距：上(T)
        .BottomMargin = ps.BottomMargin       '页边距：下(B)
        .HeaderMargin = ps.HeaderMargin    '页边距：页眉(A)
        .FooterMargin = ps.FooterMargin     '页边距：页脚(F)
        .Orientation = ps.Orientation      '页面方向：纵向(T) xlPortrait/ 横向 (L)xlLandscape
        .PrintArea = ps.PrintArea
        .CenterHorizontally = ps.CenterHorizontally                         '页边距居中方式：水平(Z)
        .CenterVertically = ps.CenterVertically                           '页边距居中方式：垂直(V)
        .Zoom = ps.Zoom
    End With
    For Each row In rowHeights.Keys
'        Debug.Print row, rowHeights(row)
        wb.Worksheets("生产日报").Rows(row).RowHeight = rowHeights(row)
    Next row
    For Each column In columnWidths.Keys
        wb.Worksheets("生产日报").Columns(column).ColumnWidth = columnWidths(column)
    Next column

    wb.SaveAs fileName:=absFname, FileFormat:=xlNormal
    wb.Close
    Windows("葫芦岛天然气处理厂生产管理系统.xls").Activate
'    Cells(2, column).Select
'    数据存入数据库
    Dim SC As New 生产日报
    Dim table
    Set table = CreateObject("Scripting.Dictionary")
    Call SC.getValue(absFname, table)
    Dim scxx As New 生产信息
    Call scxx.PushTableToDatabase(table)
    Set table = Nothing
    Call Worksheets("海管").保存_Click
'    Call Worksheets("快速录入").DBsave_Click
    Call estimate
'    Call Worksheets("主页").备份数据库
    Dim command As String
    command = "D:\public\portable\database\x64\PostgreSQL\10\pgsql\bin\pg_dump.exe  -h 10.30.29.80 -p 2012 -f D:\public\HLD\工艺\database\" & Format(日期, "YYYY-MM-DD") & ".backup  -U operator -c -C -E UTF8 -w HLD"
    Shell (command)
    command = "xcopy /y D:\public\HLD\工艺\database\" & Format(日期, "YYYY-MM-DD") & ".backup Z:\葫芦岛天然气终端厂共享文件\-03-生产专用\数据备份\"
    Shell (command)
    command = "xcopy /y D:\public\HLD\工艺\工艺报表\2014葫芦岛天然气处理厂管理系统\葫芦岛天然气处理厂生产管理系统.xls Z:\葫芦岛天然气终端厂共享文件\-03-生产专用\数据备份\"
    Shell (command)
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
'    Application.DisplayAlerts = True
'    Application.Visible = True
End Sub
'打印
Private Sub 打印_Click()
    '保存
    Call 保存_Click
'    Sheets("生产日报").Range("A1:I45").Select
'    ActiveSheet.PageSetup.PrintArea = "$A$1:$I$42"
    Sheets("生产日报").PrintOut
End Sub
'返回主页
Private Sub 返回主页_Click()
    Sheets("主页").Select
End Sub

Private Sub 清除_Click()
On Error GoTo ErrorHandler
    Range(Cells(5, 2), Cells(7, 3)).ClearContents
    Range(Cells(6, 4), Cells(7, 4)).ClearContents
    Range(Cells(5, 6), Cells(7, 7)).ClearContents
    Range(Cells(6, 8), Cells(7, 8)).ClearContents
    
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
'        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub

Private Sub 消峰平谷_Click()
    Worksheets("消峰平谷").Select
'    Worksheets("消峰平谷").Cells(4, 10).value = Worksheets("生产日报").Cells(2, 1).value
End Sub
'昨日数据
Public Sub 昨日数据_Click()
On Error GoTo ErrorHandler
    Worksheets("相关数据").Select
    Call Sheets("相关数据").清除_Click
'    Worksheets("相关数据").Range(Cells(4, 1), Cells(128, 11)).ClearContents
'    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim temp
'    temp = Worksheets("生产日报").Cells(2, 1).value
    temp = [日期]
    Dim SQL As String
    Dim d As Date
    If IsDate(temp) And temp > 0 Then
        d = temp - 1
    End If
    Dim showFields As String
    showFields = " 日期,名称,单位,数据,月累,年累,类别,状态,备注 "
    Dim filter As String
    Dim filter2 As String
    Dim filter3 As String
'    '昨天
    filter = "日期 = " & "'" & d & "'"
    Dim 月初 As Date
    月初 = DateSerial(Year(d), Month(d), 1)
    Dim 年初 As Date
    年初 = DateSerial(Year(d), 1, 1)
    filter2 = "日期 between '" & 月初 & "' and '" & d & "'"
    filter3 = "日期 between '" & 年初 & "' and '" & d & "'"
    Dim row As Long
    Dim roffset As Integer
    Dim coffset As Integer
    row = 3
    column = 1
    roffset = 1
'    入厂计量
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='入厂计量' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='入厂计量' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='入厂计量' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    锦天化
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='锦天化' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='锦天化' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='锦天化' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    精细化工CNG
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='精细化工CNG' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='精细化工CNG' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='精细化工CNG' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    精细化工
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='精细化工' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='精细化工' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='精细化工' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    污水处理厂
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='污水处理厂' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='污水处理厂' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='污水处理厂' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    新奥燃气
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='新奥燃气' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='新奥燃气' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='新奥燃气' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    自用气
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='自用气' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='自用气' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='自用气' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    轻油
'    轻油库存合计
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='轻油库存合计' and 单位='吨' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
'    轻油比重
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='轻油比重' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
'    丙烷罐库存t
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='丙烷罐库存' and 单位='吨' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
'    V-642t
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='V-642' and 单位='吨' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
'    液化气罐库存t
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='液化气罐库存' and 单位='吨' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
'    轻烃库存t
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='轻烃库存' and 单位='吨' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
'    甲醇消耗
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='甲醇消耗' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='甲醇消耗' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='甲醇消耗' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    乙二醇生产
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='乙二醇回收' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='乙二醇回收' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='乙二醇回收' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    库存水t
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='库存水' and 单位='方' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
'    外供水
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='外供水' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='外供水' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='外供水' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    水消耗
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='水消耗' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='水消耗' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='水消耗' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    自采水
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='自采水' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='自采水' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='自采水' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    外供电
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='外供电' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='外供电' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='外供电' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    电消耗
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='电消耗' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='电消耗' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='电消耗' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    自发电
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='自发电' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='自发电' "
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='自发电' "
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'   轻油生产
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='轻油回收量' and 单位='方'"
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='轻油回收量' and 单位='方'"
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='轻油回收量' and 单位='方'"
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    丙丁烷生产
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='丙丁烷回收量' and 单位='方' "
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='丙丁烷回收量' and 单位='方'"
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='丙丁烷回收量' and 单位='方'"
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    JZ20-2体系接收
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='JZ20-2体系' and 状态='接收'"
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='JZ20-2体系' and 状态='接收'"
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='JZ20-2体系' and 状态='接收'"
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    JZ20-2体系外输
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='JZ20-2体系' and 状态='外输'"
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='JZ20-2体系' and 状态='外输'"
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='JZ20-2体系' and 状态='外输'"
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    JZ25-1S体系接收
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='JZ25-1S体系' and 状态='接收'"
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='JZ25-1S体系' and 状态='接收'"
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='JZ25-1S体系' and 状态='接收'"
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
'    JZ25-1S体系外输
    row = row + roffset
    SQL = "SELECT " & showFields & " FROM 生产信息 " & " WHERE " & filter & " and 名称='JZ25-1S体系' and 状态='外输'"
    Worksheets("相关数据").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 " & " WHERE " & filter2 & " and 名称='JZ25-1S体系' and 状态='外输'"
    coffset = 9
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 " & " WHERE " & filter3 & " and 名称='JZ25-1S体系' and 状态='外输'"
    coffset = 10
    Worksheets("相关数据").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
    
'    昨日球罐库存t
    row = 34
    column = 14
    coffset = 0
    Dim ar As Variant
    Dim name As Variant
    ar = Array("V-641A", "V-641B", "V-642", "V-643A", "V-643B")
    For Each name In ar
        SQL = "select 数据 from 生产信息 where 单位='吨' and 状态='库存' and 类别='丙丁烷' and 名称='" & name & "' and " & filter
'        Debug.Print (SQL)
        Worksheets("生产日报").Cells(row, column + coffset).CopyFromRecordset psql.cnn.Execute(SQL)
        coffset = coffset + 1
    Next

ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub
'修改
Private Sub 修改_Click()
    Dim tablename As String
    tablename = "生产信息"
    Dim SC As New 生产日报
'    获得昨日相关数据
'    Call Sheets("生产日报").昨日数据_Click
'    If True = SC.自动计算 Then
'        Worksheets("生产日报").Select
'    Else
'        Worksheets("快速录入").Select
'    End If
End Sub
'查询原始报表
Private Sub 查询原始报表_Click()
    生产日报查询.Show
End Sub
Private Sub 文件导入_Click()
'    Dim sd As String
'    sd = InputBox("请输入密码：", "危险操作！", "******")
'    If "530-2469" <> sd Then
'        MsgBox "密码不对！禁止危险操作！"
'        Exit Sub
'    End If
    Dim filter As String
    filter = "microsoft office excel files (*.xls),*.xls"
'    filefilter1 = "所有文件,*.*"
    Dim fn
    fn = Application.GetOpenFilename(filter, , "请选文件", , MultiSelect:=True)
    If Not IsArray(fn) Then Exit Sub
    Dim SC As New 生产日报
    Dim temp
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
    For Each temp In fn
'        Debug.Print temp
        Call SC.getValue(temp, table)
    Next temp
    Dim scxx As New 生产信息
    Call scxx.PushTableToDatabase(table)
End Sub
'从生产日报，基本生产日报，综合日报文件里采集生产信息
Private Sub 信息采集_Click()
'    Dim sd As String
'    sd = InputBox("请输入密码：", "危险操作！", "******")
'    Dim h As New help
'    hasRight = h.checkRight(sd)
'    If False = hasRight Then
'        MsgBox "密码不对！禁止危险操作！"
'        Exit Sub
'    End If
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
    '    Dim JB As New 基本生产日报
    '    Dim JH As New 综合日报
        Dim SC As New 生产日报
        For Each temp In fileList.Keys
    '        Debug.Print temp
    '        Call JB.getValue(temp, table)
    '        Call JH.getValue(temp, table)
            Call SC.getValue(temp, table)
        Next temp
        Debug.Print table.count
        Dim s As New 生产信息
        Dim fs As Object
        Set fs = CreateObject("Scripting.FileSystemObject")
        Dim csvFname As String
        csvFname = Format(Now(), "YYYY年MM月DD日") & "生产信息.csv"
        t = Now()
        Dim scxx As New 生产信息
        Call scxx.PushTableToDatabase(table)
        Call s.saveCSV(csvFname, table)
    End If
    hasright = False
End Sub
'计划完成情况估计
Public Sub estimate()
    Err.Clear
    On Error GoTo ErrorHandler
    Dim data As Object
    Set data = CreateObject("Scripting.Dictionary")
    Dim SQL As String
    Dim psql As New PostgreSQL
    Dim sdate As Date
    SQL = "select max(日期) from 生产信息 where 日期<current_date;"
    sdate = psql.cnn.Execute(SQL)(0)
    Dim dayRemaining As Integer
    dayRemaining = DateDiff("d", Now, DateSerial(Year(Now), 12, 31))
'    Debug.Print "剩余天数" & dayRemaining
    Dim arr, temp, overProduction As Variant
    arr = Array("总外输气量", "轻油回收量", "丙丁烷回收量")
    Dim i As Integer
    Dim name As String
    For i = LBound(arr) To UBound(arr)
        SQL = "select 数据,年累 from 生产信息 where 日期='" & sdate & "' and 单位='方' and  名称='" & arr(i) & "'; "
        temp = psql.cnn.Execute(SQL)(0)
        name = arr(i)
        data.Add name, temp
        name = arr(i) & "年累"
        temp = psql.cnn.Execute(SQL)(1)
        data.Add name, temp
    Next i
    arr = Array("天然气", "轻油", "丙丁烷")
    For i = LBound(arr) To UBound(arr)
        arr(i) = arr(i) + "年配产"
        SQL = "select 数据 from 生产信息 where 日期='" & sdate & "' and 单位='方' and  名称= '" & arr(i) & "'; "
        name = arr(i)
        temp = psql.cnn.Execute(SQL)(0)
        data.Add name, temp
    Next i
    arr = Array("天然气", "轻油", "丙丁烷")
    For i = LBound(arr) To UBound(arr)
        name = arr(i)
        If name = "天然气" Then
            temp = (data("天然气年配产") - data("总外输气量年累")) / data("总外输气量")
            temp = DateAdd("d", temp, sdate)
            overProduction = data("总外输气量年累") + data("总外输气量") * dayRemaining - data("天然气年配产")
        End If
        If name = "轻油" Then
            temp = (data("轻油年配产") - data("轻油回收量年累")) / data("轻油回收量")
            temp = DateAdd("d", temp, sdate)
            overProduction = data("轻油回收量年累") + data("轻油回收量") * dayRemaining - data("轻油年配产")
        End If
        If name = "丙丁烷" Then
            temp = (data("丙丁烷年配产") - data("丙丁烷回收量年累")) / data("丙丁烷回收量")
            temp = DateAdd("d", temp, sdate)
            overProduction = data("丙丁烷回收量年累") + data("丙丁烷回收量") * dayRemaining - data("丙丁烷年配产")
'            Debug.Print sdate, name, data("丙丁烷回收量年累"), data("丙丁烷回收量"), data("丙丁烷年配产"), dayRemaining
        End If
        data.Add name + "预计完成日期", temp
'        Debug.Print name, temp
        data.Add name + "预计超产产量", overProduction
'        Debug.Print name, overProduction
    Next i
    Dim row, column, ro, co, rowLimit, columnLimit As Integer
    rowLimit = Worksheets("快速录入").Rows.count
    columnLimit = Worksheets("快速录入").Columns.count
    Dim flag As String
    flag = "预计完成日期"
    For row = 1 To rowLimit
        For column = 1 To columnLimit
            temp = Worksheets("快速录入").Cells(row, column).value
            If temp = flag Then
                ro = 1
                co = 0
                Worksheets("快速录入").Cells(row + ro, column + co) = data("天然气预计完成日期")
                co = 1
                Worksheets("快速录入").Cells(row + ro, column + co) = data("天然气预计超产产量")
                ro = 2
                co = 0
                Worksheets("快速录入").Cells(row + ro, column + co) = data("轻油预计完成日期")
                co = 1
                Worksheets("快速录入").Cells(row + ro, column + co) = data("轻油预计超产产量")
                ro = 3
                co = 0
                Worksheets("快速录入").Cells(row + ro, column + co) = data("丙丁烷预计完成日期")
                co = 1
                Worksheets("快速录入").Cells(row + ro, column + co) = data("丙丁烷预计超产产量")
                Exit Sub
            End If
        Next column
    Next row
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
