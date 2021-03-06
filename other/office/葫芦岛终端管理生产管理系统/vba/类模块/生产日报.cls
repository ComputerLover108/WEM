Dim oldValue As Object
Public Sub test()
'    Dim fname As String
'    fname = "E:\public\test\报表共享(王全）\2012终端生产日报新\2012年7月\葫芦岛天然气处理厂生产日报（新版试行）2012.7.29.xls"
'    Dim table
'    Set table = CreateObject("Scripting.Dictionary")
'    Call getValue(fname, table)
'    Dim record
'    For Each record In table.keys
'        Debug.Print record.content
'    Next record
'    Debug.Print "共收集了" & table.count & "记录！" & vbTab & fname
'    Set table = Nothing
'    Call eraseName
'    Call addName
End Sub
'获得表格起始位
Public Sub getPosition(ByVal Title As String, ByRef position)
Err.Clear
On Error GoTo ErrorHandler
    Dim row, column As Long
    Dim temp
    For row = 1 To Rows.count
        For column = 1 To Columns.count
            temp = Cells(row, column).value
'            Debug.Print ThisWorkbook.name
            If temp Like Title Then
                position(0) = row
                position(1) = column
                Exit Sub
            End If
        Next column
    Next row
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
End Sub
'初步分区表格
Public Sub getAnchors(ByVal beginRow As Long, ByVal beginColumn As Long, ByRef table As Object)
Err.Clear
On Error GoTo ErrorHandler
    Dim row, column As Long
    Dim temp
    For row = beginRow To Rows.count
        temp = Cells(row, beginColumn).value
        If temp Like "（一）配产/完成情况" Then
            table.Add "（一）配产/完成情况", row
        End If
        If temp Like "（二）天然气产量/外输/海管信息" Then
            table.Add "（二）天然气产量/外输/海管信息", row
        End If
        If temp Like "（三）轻油产量/外输/库存" Then
            table.Add "（三）轻油产量/外输/库存", row
        End If
        If temp Like "（四）丙丁烷产量/外输/库存" Then
            table.Add "（四）丙丁烷产量/外输/库存", row
        End If
        If temp Like "（五）物料接收/消耗" Then
            table.Add "（五）物料接收/消耗", row
        End If
    Next row
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub
'初步检查表格
Public Function verify(ByRef table As Object) As Boolean
    Dim x
    For Each x In table.Keys
        Select Case x
            Case "（一）配产/完成情况"
            Case "（二）天然气产量/外输/海管信息"
            Case "（三）轻油产量/外输/库存"
            Case "（四）丙丁烷产量/外输/库存"
            Case "（五）物料接收/消耗"
            Case Else
                verify = False
                Exit Function
        End Select
    Next x
    verify = True
End Function
'从表格里获得值
Public Sub getValue(ByVal fname As String, table)
Err.Clear
On Error GoTo ErrorHandler
    Application.ScreenUpdating = False
    Dim Title As String
    Title = "*葫芦岛天然气终端厂生产日报*"
    Dim wb
    Set wb = Workbooks.Open(fname, 0, ReadOnly)
    Dim row, column, ro, co, beginRow, beginColumn, lastRow, lastColumn As Long
    Dim 日期 As Date
    Dim temp
    Dim recordSC As New 生产信息
    lastColumn = beginColumn - 1 + Cells(beginRow, beginColumn).MergeArea.Columns.count
    For Each sh In wb.Worksheets
        If "生产日报" = sh.name Then
            for row=beginRow to lastRow
                for column=beginColumn to lastColumn

                Next column
            Next row
            End If
        End If
    Next sh
    
    wb.Close SaveChanges:=False
'    wb.Close False
    Set wb = Nothing
    Application.ScreenUpdating = True
'    Application.Visible = True
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub
'填写表格
Public Sub putData(ByVal 日期 As Date)
On Error GoTo ErrorHandler
    Dim SQL, filter, filter2, filter3 As String
    Dim 月初, 年初 As Date
    月初 = DateSerial(Year(日期), Month(d日期), 1)
    年初 = DateSerial(Year(日期), 1, 1)
    filter = "日期 = " & "'" & 日期 & "'"
    filter2 = "日期 between #" & 月初 & "# and #" & 日期 & "#"
    filter3 = "日期 between #" & 年初 & "# and #" & 日期 & "#"
'    入厂计量
    SQL = "SELECT 数据 FROM 生产信息  WHERE " & filter & " and 名称='入厂计量' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='入厂计量' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='入厂计量' "
'    锦天化
    SQL = "SELECT 数据 FROM 生产信息  WHERE " & filter & " and 名称='锦天化' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='锦天化' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='锦天化' "
'    精细化工
    SQL = "SELECT 数据 FROM 生产信息  WHERE " & filter & " and 名称='精细化工' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='精细化工' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='精细化工' "
'    污水处理厂
    SQL = "SELECT 数据 FROM 生产信息  WHERE " & filter & " and 名称='污水处理厂' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='污水处理厂' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='污水处理厂' "
'    新奥燃气
    SQL = "SELECT 数据 FROM 生产信息  WHERE " & filter & " and 名称='新奥燃气' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='新奥燃气' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='新奥燃气' "
'    自用气
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='自用气' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='自用气' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='自用气' "
'    轻油
'    轻油库存合计
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='轻油库存合计' and 单位='吨' "
'    轻油比重
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='轻油比重' "
'    丙烷罐库存t
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='丙烷罐库存' and 单位='吨' "
'    V-642t
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='V-642' and 单位='吨' "
'    液化气罐库存t
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='液化气罐库存' and 单位='吨' "
'    轻烃库存t
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='轻烃库存' and 单位='吨' "
'    甲醇消耗
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='甲醇消耗' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='甲醇消耗' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='甲醇消耗' "
'    乙二醇生产
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='乙二醇回收' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='乙二醇回收' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='乙二醇回收' "
'    库存水t
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='库存水' and 单位='方' "
'    外供水
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='外供水' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='外供水' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='外供水' "
'    水消耗
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='水消耗' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='水消耗' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='水消耗' "
'    自采水
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='自采水' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='自采水' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='自采水' "
'    外供电
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='外供电' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='外供电' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='外供电' "
'    电消耗
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='电消耗' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='电消耗' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='电消耗' "
'    自发电
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='自发电' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='自发电' "
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='自发电' "
'   轻油生产
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='轻油回收量' and 单位='方'"
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='轻油回收量' and 单位='方'"
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='轻油回收量' and 单位='方'"
'    丙丁烷生产
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='丙丁烷回收量' and 单位='方' "
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='丙丁烷回收量' and 单位='方'"
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='丙丁烷回收量' and 单位='方'"
'    JZ20-2体系接收
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='JZ20-2体系' and 状态='接收'"
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='JZ20-2体系' and 状态='接收'"
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='JZ20-2体系' and 状态='接收'"
'    JZ20-2体系外输
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='JZ20-2体系' and 状态='外输'"
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='JZ20-2体系' and 状态='外输'"
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='JZ20-2体系' and 状态='外输'"
'    JZ25-1S体系接收
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='JZ25-1S体系' and 状态='接收'"
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='JZ25-1S体系' and 状态='接收'"
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='JZ25-1S体系' and 状态='接收'"
'    JZ25-1S体系外输
    SQL = "SELECT 数据 FROM 生产信息 WHERE " & filter & " and 名称='JZ25-1S体系' and 状态='外输'"
    SQL = "SELECT sum(数据) as 计算月累 FROM 生产信息 WHERE " & filter2 & " and 名称='JZ25-1S体系' and 状态='外输'"
    SQL = "SELECT sum(数据) as 计算年累 FROM 生产信息 WHERE " & filter3 & " and 名称='JZ25-1S体系' and 状态='外输'"
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub
'自动计算
Public Function 自动计算(ByRef quickInputData As Object) As Boolean
On Error GoTo ErrorHandler
    自动计算 = True
    Dim 日期 As Date
    Dim 去年年末 As Date
    Dim 今年年末 As Date
    Dim 剩余天数 As Integer
    Const rowLimit = 65535
    Const columnLimit = 256
    Dim row As Long
    Dim column As Long
    Dim lastRow As Long
    Dim lastColumn As Long
    Dim offset As Integer
    lastRow = Worksheets("相关数据").Range("a4:a65535").End(xlDown).row
'    需要昨天31条记录
'    lastRow = 31
    lastColumn = 11
    Dim h As New help
    For row = 1 To lastRow
        For column = 1 To lastColumn
            temp = Worksheets("相关数据").Cells(row, column).value
'                天然气
            If h.isMatch(".*入厂计量.*", temp) Then
                offset = 3
                [入厂计量月累] = Worksheets("相关数据").Cells(row, column + offset).value + [入厂计量数据]
                offset = 4
                [入厂计量年累] = Worksheets("相关数据").Cells(row, column + offset).value + [入厂计量数据]
            End If
            If h.isMatch(".*JZ202.*", temp) Then
                offset = 3
                [JZ202月累] = Worksheets("相关数据").Cells(row, column + offset).value + [JZ202数据]
                offset = 4
                [JZ202年累] = Worksheets("相关数据").Cells(row, column + offset).value + [JZ202数据]
            End If
            If h.isMatch(".*JZ251S.*", temp) Then
                offset = 3
                [JZ251S月累] = Worksheets("相关数据").Cells(row, column + offset).value + [JZ251S数据]
                offset = 4
                [JZ251S年累] = Worksheets("相关数据").Cells(row, column + offset).value + [JZ251S数据]
            End If
            If h.isMatch(".*锦天化.*", temp) Then
                offset = 3
                [锦天化月累] = Worksheets("相关数据").Cells(row, column + offset).value + [锦天化数据]
                offset = 4
                [锦天化年累] = Worksheets("相关数据").Cells(row, column + offset).value + [锦天化数据]
            End If
            If temp = "精细化工CNG" Then
                offset = 3
                Dim data As Variant
                data = [精细化工CNG数据]
                [精细化工CNG月累] = Worksheets("相关数据").Cells(row, column + offset).value + [精细化工CNG数据]
                offset = 4
                [精细化工CNG年累] = Worksheets("相关数据").Cells(row, column + offset).value + [精细化工CNG数据]
            End If
            If temp = "精细化工" Then
                offset = 3
                [精细化工月累] = Worksheets("相关数据").Cells(row, column + offset).value + [精细化工数据]
                offset = 4
                [精细化工年累] = Worksheets("相关数据").Cells(row, column + offset).value + [精细化工数据]
            End If

            
            If h.isMatch(".*污水处理厂.*", temp) Then
                offset = 3
                [污水处理厂月累] = Worksheets("相关数据").Cells(row, column + offset).value + [污水处理厂数据]
                offset = 4
                [污水处理厂年累] = Worksheets("相关数据").Cells(row, column + offset).value + [污水处理厂数据]
            End If
            If h.isMatch(".*新奥燃气.*", temp) Then
                offset = 3
                [新奥燃气月累] = Worksheets("相关数据").Cells(row, column + offset).value + [新奥燃气数据]
                offset = 4
                [新奥燃气年累] = Worksheets("相关数据").Cells(row, column + offset).value + [新奥燃气数据]
            End If
            If h.isMatch(".*自用气.*", temp) Then
                offset = 3
                [自用气月累] = Worksheets("相关数据").Cells(row, column + offset).value + [自用气数据]
                offset = 4
                [自用气年累] = Worksheets("相关数据").Cells(row, column + offset).value + [自用气数据]
            End If
            If temp Like "*JZ20-2体系*" And row = 28 Then
                offset = 3
                [JZ202体系接收月累] = Worksheets("相关数据").Cells(row, column + offset).value + [JZ202体系接收数据]
                offset = 4
                [JZ202体系接收年累] = Worksheets("相关数据").Cells(row, column + offset).value + [JZ202体系接收数据]
            End If
            If temp Like "*JZ20-2体系*" And row = 29 Then
                offset = 3
                [JZ202体系外输月累] = Worksheets("相关数据").Cells(row, column + offset).value + [JZ202体系外输数据]
                offset = 4
                [JZ202体系外输年累] = Worksheets("相关数据").Cells(row, column + offset).value + [JZ202体系外输数据]
            End If
            If temp Like "*JZ25-1S体系*" And row = 30 Then
                offset = 3
                [JZ251S体系接收月累] = Worksheets("相关数据").Cells(row, column + offset).value + [JZ251S体系接收数据]
                offset = 4
                [JZ251S体系接收年累] = Worksheets("相关数据").Cells(row, column + offset).value + [JZ251S体系接收数据]
            End If
            If temp Like "*JZ25-1S体系*" And row = 31 Then
                offset = 3
                [JZ251S体系外输月累] = Worksheets("相关数据").Cells(row, column + offset).value + [JZ251S体系外输数据]
                offset = 4
                [JZ251S体系外输年累] = Worksheets("相关数据").Cells(row, column + offset).value + [JZ251S体系外输数据]
            End If
'    轻油
            If h.isMatch(".*轻油库存.*", temp) Then
                offset = 2
                [轻油回收量t] = [轻油库存合计t] + [轻油装车t] - Worksheets("相关数据").Cells(row, column + offset).value
                If [轻油回收量t] < 0 Then [轻油回收量t] = 0
            End If
            If 0 = [轻油比重] Then
                Dim d
                d = Worksheets("生产日报").Cells(2, 1).value
                MsgBox "数据库里没有找到 " & d & " 里的轻油比重,请在 快速录入 表里输入轻油比重！"
                自动计算 = False
            Else
                [轻油回收量数据] = [轻油回收量t] / [轻油比重]
            End If
'    丙丁烷
            If h.isMatch(".*丙烷罐库存.*", temp) Then
                Dim 昨丙烷库存 As Double
                offset = 2
                昨丙烷库存 = Worksheets("相关数据").Cells(row, column + offset).value
            End If
            If h.isMatch(".*V-642.*", temp) Then
                Dim 昨丁烷库存 As Double
                offset = 2
                昨丁烷库存 = Worksheets("相关数据").Cells(row, column + offset).value
            End If
            If h.isMatch(".*液化气罐库存.*", temp) Then
                Dim 昨液化气罐库存 As Double
                offset = 2
                昨液化气罐库存 = Worksheets("相关数据").Cells(row, column + offset).value
            End If
            If h.isMatch(".*轻烃库存.*", temp) Then
                Dim 昨轻烃库存 As Double
                offset = 2
                昨轻烃库存 = Worksheets("相关数据").Cells(row, column + offset).value
            End If
'    化学药剂
            If h.isMatch(".*甲醇消耗.*", temp) Then
                offset = 3
                [甲醇消耗月累] = Worksheets("相关数据").Cells(row, column + offset).value + [甲醇消耗数据]
                offset = 4
                [甲醇消耗年累] = Worksheets("相关数据").Cells(row, column + offset).value + [甲醇消耗数据]
            End If
            If h.isMatch(".*乙二醇回收.*", temp) Then
                SQL = "select sum(数据) as 月累 from 生产信息 where 日期 between date_trunc('month','" & 日期 & "') and '" & 日期 & "' and 名称='乙二醇回收' and 单位='方' "
                
                offset = 3
                [乙二醇回收月累] = Worksheets("相关数据").Cells(row, column + offset).value + [乙二醇回收数据]
                offset = 4
                [乙二醇回收年累] = Worksheets("相关数据").Cells(row, column + offset).value + [乙二醇回收数据]
            End If
'    水
            If h.isMatch(".*外供水.*", temp) Then
                offset = 3
                [外供水月累] = Worksheets("相关数据").Cells(row, column + offset).value + [外供水数据]
                offset = 4
                [外供水年累] = Worksheets("相关数据").Cells(row, column + offset).value + [外供水数据]
            End If
            If h.isMatch(".*自采水.*", temp) Then
                offset = 3
                [自采水月累] = Worksheets("相关数据").Cells(row, column + offset).value + [自采水数据]
                offset = 4
                [自采水年累] = Worksheets("相关数据").Cells(row, column + offset).value + [自采水数据]
            End If
            If h.isMatch(".*库存水.*", temp) Then
                Dim 昨库存水 As Double
                offset = 2
                昨库存水 = Worksheets("相关数据").Cells(row, column + offset).value
            End If
            If h.isMatch(".*水消耗.*", temp) Then
                [水消耗数据] = 昨库存水 + [外供水数据] + [自采水数据] - [库存水]
                offset = 3
                [水消耗月累] = Worksheets("相关数据").Cells(row, column + offset).value + [水消耗数据]
                offset = 4
                [水消耗年累] = Worksheets("相关数据").Cells(row, column + offset).value + [水消耗数据]
            End If
'    电
            If h.isMatch(".*外供电.*", temp) Then
                offset = 3
                [外供电月累] = Worksheets("相关数据").Cells(row, column + offset).value + [外供电数据]
                offset = 4
                [外供电年累] = Worksheets("相关数据").Cells(row, column + offset).value + [外供电数据]
            End If
            If h.isMatch(".*自发电.*", temp) Then
                offset = 3
                [自发电月累] = Worksheets("相关数据").Cells(row, column + offset).value + [自发电数据]
                offset = 4
                [自发电年累] = Worksheets("相关数据").Cells(row, column + offset).value + [自发电数据]
            End If
            If h.isMatch(".*电消耗.*", temp) Then
                [电消耗数据] = [外供电数据] + [自发电数据]
                offset = 3
                [电消耗月累] = Worksheets("相关数据").Cells(row, column + offset).value + [电消耗数据]
                offset = 4
                [电消耗年累] = Worksheets("相关数据").Cells(row, column + offset).value + [电消耗数据]
            End If
            If h.isMatch(".*轻油回收量.*", temp) Then
                offset = 3
                [轻油回收量月累] = Worksheets("相关数据").Cells(row, column + offset).value + [轻油回收量数据]
                offset = 4
                [轻油回收量年累] = Worksheets("相关数据").Cells(row, column + offset).value + [轻油回收量数据]
            End If
            If h.isMatch(".*丙丁烷回收量.*", temp) Then
'                Dim 左月累 As Double
'                Dim 左年累 As Double
'                Dim 数据 As Double
'                数据 = [丙丁烷回收量数据]
                 offset = 3
'                 左月累 = Worksheets("相关数据").Cells(row, column + offset).value
                [丙丁烷回收量月累] = Worksheets("相关数据").Cells(row, column + offset).value + [丙丁烷回收量数据]
'                Debug.Print Worksheets("相关数据").Cells(row, column + offset).value & "+" & [丙丁烷回收量数据]
                offset = 4
'                左年累 = Worksheets("相关数据").Cells(row, column + offset).value
                [丙丁烷回收量年累] = Worksheets("相关数据").Cells(row, column + offset).value + [丙丁烷回收量数据]
'                Debug.Print Worksheets("相关数据").Cells(row, column + offset).value & "+" & [丙丁烷回收量数据]
            End If
        Next column
    Next row
    [丙丁烷回收量t] = [轻烃库存t] + [丙烷装车t] + [丁烷装车t] + [液化气装车t] - 昨轻烃库存
    If [丙丁烷回收量t] < 0 Then [丙丁烷回收量t] = 0
    日期 = Worksheets("生产日报").Cells(2, 1).value
'    判断月初，年初
        Dim dt As New 时间
'        Debug.Print "闰年" & vbTab & dt.IsLeap(日期)
'        Debug.Print "月初" & vbTab & dt.IsMonthHead(日期)
'        Debug.Print "月末" & vbTab & dt.IsMonthEnd(日期)
'        Debug.Print "年初" & vbTab & dt.IsYearHead(日期)
'        Debug.Print "年末" & vbTab & dt.IsYeadEnd(日期)
'    月初，月累重做
    If dt.IsMonthHead(日期) Then
'    天然气
        [入厂计量月累] = [入厂计量数据]
        [锦天化月累] = [锦天化数据]
        [新奥燃气月累] = [新奥燃气数据]
        [精细化工CNG月累] = [精细化工CNG数据]
        [精细化工月累] = [精细化工数据]
        [污水处理厂月累] = [污水处理厂数据]
        [自用气月累] = [自用气数据]
        [JZ202体系接收月累] = [JZ202体系接收数据]
        [JZ251S体系接收月累] = [JZ251S体系接收数据]
        [JZ202体系外输月累] = [JZ202体系外输数据]
        [JZ251S体系外输月累] = [JZ251S体系外输数据]
'    化学药剂
        [甲醇消耗月累] = [甲醇消耗数据]
        [乙二醇回收月累] = [乙二醇回收数据]
'    水
        [外供水月累] = [外供水数据]
        [自采水月累] = [自采水数据]
        [水消耗月累] = [水消耗数据]
'    电
        [外供电月累] = [外供电数据]
        [自发电月累] = [自发电数据]
        [电消耗月累] = [电消耗数据]
'     产品
        [轻油回收量月累] = [轻油回收量数据]
        [丙丁烷回收量月累] = [丙丁烷回收量数据]
    End If
'    年初 , 年累重做
    If dt.IsYearHead(日期) Then
'    天然气
        [入厂计量年累] = [入厂计量数据]
        [锦天化年累] = [锦天化数据]
        [新奥燃气年累] = [新奥燃气数据]
        [精细化工年累] = [精细化工数据]
        [精细化工CNG年累] = [精细化工CNG数据]
        [污水处理厂年累] = [污水处理厂数据]
        [自用气年累] = [自用气数据]
        [JZ202体系接收年累] = [JZ202体系接收数据]
        [JZ251S体系接收年累] = [JZ251S体系接收数据]
        [JZ202体系外输年累] = [JZ202体系外输数据]
        [JZ251S体系外输年累] = [JZ251S体系外输数据]
'    化学药剂
        [甲醇消耗年累] = [甲醇消耗数据]
        [乙二醇回收年累] = [乙二醇回收数据]
'    水
        [外供水年累] = [外供水数据]
        [自采水年累] = [自采水数据]
        [水消耗年累] = [水消耗数据]
'    电
        [外供电年累] = [外供电数据]
        [自发电年累] = [自发电数据]
        [电消耗年累] = [电消耗数据]
'     产品
        [轻油回收量年累] = [轻油回收量数据]
        [丙丁烷回收量年累] = [丙丁烷回收量数据]

    End If
    For row = 1 To lastRow
        For column = 1 To lastColumn
            temp = Worksheets("生产日报").Cells(row, column).value
            If h.isMatch(".*葫芦岛天然气终端厂生产日报.*", temp) Then
                offset = 1
                日期 = Worksheets("生产日报").Cells(row + offset, column).value
                去年年末 = DateSerial(Year(日期) - 1, 12, 31)
                今年年末 = DateSerial(Year(日期), 12, 31)
                剩余天数 = DateDiff("d", 日期, 今年年末)
            End If
            If h.isMatch(".*进度比.*", temp) Then
                offset = 1
                Worksheets("生产日报").Cells(row + offset, column).value = (日期 - 去年年末) / (今年年末 - 去年年末) * 100
                offset = 2
                Worksheets("生产日报").Cells(row + offset, column).value = (日期 - 去年年末) / (今年年末 - 去年年末) * 100
                offset = 3
                Worksheets("生产日报").Cells(row + offset, column).value = (日期 - 去年年末) / (今年年末 - 去年年末) * 100
            End If
            If h.isMatch(".*今后需日产.*", temp) Then
                Debug.Print "原剩余天数:" & 剩余天数
'                剩余天数 = 剩余天数 - quickInputData("停产天数")
                剩余天数 = quickInputData("剩余天数")
                Debug.Print "剩余天数:" & 剩余天数
                offset = 1
                temp = ([天然气年度配产] - [总外输气量年累]) / 剩余天数
                Worksheets("生产日报").Cells(row + offset, column).value = temp
                offset = 2
                temp = ([轻油年度配产] - [轻油回收量年累]) / 剩余天数
                Worksheets("生产日报").Cells(row + offset, column).value = temp
                offset = 3
                temp = ([丙丁烷年度配产] - [丙丁烷回收量年累]) / 剩余天数
                Worksheets("生产日报").Cells(row + offset, column).value = temp
            End If
        Next column
    Next row
    If True = 没找到轻油比重 Then
        Worksheets("快速录入").Select
        Range("C23").Select
    End If
'    乙二醇浓度为零则不填
    If 0 = [乙二醇浓度] Then
        [乙二醇浓度].ClearContents
    End If
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
'    Resume Next
End Function
'删除名称
Public Sub eraseName()
    Dim nms
    Set nms = ActiveWorkbook.names
'    Set wks = Worksheets(1)
    Dim temp
'    Debug.Print "发现 " & nms.count & " 个名称."
    For Each temp In nms
        Debug.Print "删除名称［" & temp.name & "］ " & temp.RefersToRange.Address
        ActiveWorkbook.names(temp.name).Delete
    Next
End Sub
'批量导入到生产信息表
Public Sub batchIntoDB()
    On Error Resume Next
    Dim F As New 文件目录
    Dim backupDir As String
    backupDir = F.pathSelect
    If "" = backupDir Then
        Exit Sub
    End If
    Dim fileList As Object
    Set fileList = CreateObject("Scripting.Dictionary")
    Dim pattern As String
    pattern = ".*xls$"
    Call F.FindFiles(backupDir, pattern, fileList)
    Dim temp
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
    Dim SC As New 生产日报
    For Each temp In fileList.Keys
        Call SC.getValue(temp, table)
    Next temp
    Dim csvFile As String
    csvFile = ThisWorkbook.path & Application.PathSeparator & "生产信息.csv"
    Call scxx.saveCSV(csvFile, table)
    Dim scxx As New 生产信息
    Call scxx.PushTableToDatabase(table)
End Sub
'获得定位表
Sub getLocationTable(ByRef data As Object)
    On Error GoTo ErrorHandler
    Dim row, column, lastRow, lastColumn, ro, co, i As Long
    Dim temp, arr, n, names, name, value As Variant
    Dim flag As String
    flag = "葫芦岛天然气终端厂生产日报"
    arr = Array("天然气", "轻油", "丙丁烷")
    Dim h As New help
    sheetName = "生产日报"
    Worksheets(sheetName).Select
    lastRow = Worksheets(sheetName).UsedRange.Rows.count
    lastColumn = Worksheets(sheetName).UsedRange.Columns.count
    names = Array("稳定区", "入厂计量", "锦天化", "精细化工", "精细化工CNG", "污水处理厂", "新奥燃气", "自用气", "放空气", "总产气量", "总外输气量")
    For row = 1 To lastRow
        ro=0
        For column = 1 To lastColumn
            temp = Worksheets(sheetName).Cells(row, column).value
            co=0
            If h.isString(temp) Then
                temp=trim(temp)
                n= h.replace(temp,"(104)?m3$","")
                If h.isMatch(flag, temp) Then
                    ro =1
                    name = "日期"
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("年时间", temp) Then
                    For ro = 1 To 3
                        name = "年时间进度比"
                        data(name)=Array(row+ro,column+co)
                    Next ro
                End If
                If h.isMatch("[月年]度配产", temp) Then
                    For i = 0 To UBound(arr)
                        ro = i + 1
                        If h.isMatch("年", temp) Then
                            name = "年配产" + arr(i) + "方"
                        Else
                            name = "月配产" + arr(i) + "方"
                        End If
                        data(name)=Array(row+ro,column+co)
                    Next i
                End If
                If h.isMatch("[月年]度累计", temp) Then
                    For i = 0 To UBound(arr)
                        ro = i + 1
                        If h.isMatch("年", temp) Then
                            name = "年累" + arr(i) + "方"
                        Else
                            name = "月累" + arr(i) + "方"
                        End If
                        data(name)=Array(row+ro,column+co)
                    Next i
                End If
                If h.isMatch("今后需日产", temp) Then
                    For i = 0 To UBound(arr)
                        ro = i + 1
                        name = "今后需日产" + arr(i) + "方"
                        data(name)=Array(row+ro,column+co)
                    Next i
                End If
                If h.isMatch("(稳定区)|(入厂计量)", temp) Then
                    ro = 0
                    co = 1
                    name = n + "方"
                    value = data(name)
                    data(name)=Array(row+ro,column+co)
                    co = 3
                    name = "月累" + n + "方"
                    data(name)=Array(row+ro,column+co)
                    co = 4
                    name = "年累" + n + "方"
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("(锦天化)|(精细化工)|(精细化工CNG)|(污水处理厂)|(新奥燃气)|(自用气)|(放空气)", temp) Then
                    ro = 0                
                    co = 1
                    ' n= h.replace(temp,"(104)m3$","")
                    name = n + "方"
                    value = data(name)
                    If h.isMatch("(新奥燃气)|(自用气)|(放空气)", temp) Then
                        co = 2
                    End If
                    data(name)=Array(row+ro,column+co)
                    co = 4
                    name = "月累" + n + "方"
                    data(name)=Array(row+ro,column+co)
                    co = 5
                    name = "年累" + n + "方"
                    data(name)=Array(row+ro,column+co)
                End If
                if h.isMatch("(总产气量)|(总外输气量)",temp) Then
                    ro = 0
                    co = 2
                    ' n= h.replace(temp,"(104)m3$","")
                    name = n + "方"
                    value = data(name)
                    data(name)=Array(row+ro,column+co)
                    co = 4
                    name = "月累" + n + "方"
                    data(name)=Array(row+ro,column+co)
                    co = 5
                    name = "年累" + n + "方"
                    data(name)=Array(row+ro,column+co)                        
                End If
                If h.isMatch("(海管来液含水)|(海管MEG浓度)|(海管出口凝点)|(海管出口PH值)", temp) Then
                    ro = 0
                    co = 1
                    n = h.unitConvert(temp)
                    name = "上午" + n
                    data(name)=Array(row+ro,column+co)
                    co = 2
                    name = "下午" + n
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("海管进/出口压力MPa", temp) Then
                    ro = 0                    
                    co = 1
                    name=h.unitConvert(temp)                                  
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("海管进/出口温度℃", temp) Then
                    ro = 0                
                    co = 1
                    name=h.unitConvert(temp)                                   
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("(JZ20-2凝析油)|(JZ20-2轻油)", temp) Then
                    ro = 0                
                    co = 1
                    name = h.unitConvert(temp)
                                                       
                    data(name)=Array(row+ro,column+co)
                    co = 2
                    name = h.search("(JZ20-2凝析油)|(JZ20-2轻油)", name)
                    name = name + "密度吨/立方米"
                                                       
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("(轻油回收量)|(饱和蒸汽压)|(外输凝点)|(外输PH值)", temp) Then
                    ro = 1
                    
                    name = h.replace(name, "m3", "方")
                    name = h.replace(name, "t", "吨")
                    name = h.replace(name, "KPa", "千帕")
                    name = h.replace(name, "℃", "摄氏度")                                  
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("V-6[34][123][ABC]{0,1}", temp) Then
                    ro = 1
                    name = h.search("V-6[34][123][ABC]{0,1}", temp) + "米"
                                                       
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("轻烃库存t", temp) Then
                    ro = 1
                    name = "轻烃库存吨"                                 
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("(装车)|(丙丁烷回收量)|(轻油入罐前含水)", temp) Then
                    ro = 0
                    co = 1                   
                    name = h.replace(name, "t", "吨")
                    name = h.replace(name, "m3", "方")
                    name = h.replace(name, "bbl", "桶")
                    If h.isMatch("(轻油装车t)|(数据库)", temp) Then
                        co = 2
                    End If
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("(甲醇消耗)|(乙二醇消耗|(乙二醇回收))|(外供水)|(水消耗)", temp) Then
                    ro = 1                   
                    name = replace(temp, "m3", "方")                                   
                    data(name)=Array(row+ro,column+co)
                    ro = 2
                    data("月累" + name)=Array(row+ro,column+co)
                    ro = 3
                    data("年累" + name)=Array(row+ro,column+co)
                End If
                If h.isMatch("(外供电)|(自发电)", temp) Then
                    ro = 1                   
                    name = replace(temp, "KWh", "度")
                    data(name)=Array(row+ro,column+co)
                    ro = 2
                    data("月累" + name)=Array(row+ro,column+co)
                    ro = 3
                    data("年累" + name)=Array(row+ro,column+co)
                End If
                If h.isMatch("甲醇库存", temp) Then
                    ro = 0                
                    co = 1
                    name = "库存甲醇方"
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("乙二醇浓度", temp) Then
                    ro = 0                
                    co = 1
                    name = temp
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("水池水位", temp) Then
                    ro = 0
                    co = 1
                    name = "库存水米"
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("水池储水", temp) Then
                    ro = 0
                    co = 1
                    name = "库存水方"
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("JZ20-2体系", temp) Then
                    ro = -1
                    name = Worksheets(sheetName).Cells(row + ro, column).value
                    If h.isMatch("入厂计量", name) Then
                        co = 1
                        name="接收JZ20-2体系方"
                        data(name)=Array(row+ro,column+co)
                        co = 3
                        name="月累接收JZ20-2体系方"
                        data(name)=Array(row+ro,column+co)
                        co = 4
                        name="年累接收JZ20-2体系方"
                        data(name)=Array(row+ro,column+co)
                        ro = 1
                        name="接收JZ25-1S体系方"
                        data(name)=Array(row+ro,column+co)
                    Else
                        co = 1
                        name="外输JZ20-2体系方"
                        data(name)=Array(row+ro,column+co)
                        co = 3
                        name="月累外输JZ20-2体系方"
                        data(name)=Array(row+ro,column+co)
                        co = 4
                        name="年累外输JZ20-2体系方"
                        data(name)=Array(row+ro,column+co)
                        ro = 1
                        name="外输JZ25-1S体系方"
                        data(name)=Array(row+ro,column+co)
                    End If
                End If
                If h.isMatch("海管信息",temp) Then
                    ro=11
                    co = 0
                    name = "海管通球备注"
                    data(name)=Array(row+ro,column+co)
                End If
                If h.isMatch("其他",temp) Then
                    ro=1
                    co = 0
                    name = "生产备注"
                    data(name)=Array(row+ro,column+co)                   
                End If              
            End If
        Next column
    Next row
ErrorHandler:
    If Err.Number<>0 and err.Number<>20 Then
        Debug.Print Err.Number & vbTab & Err.source & vbTab & Err.Description
    End If
    Resume Next
End Sub
'获得生产日报数据
Sub getDailyData(ByRef locatTable as Object,ByRef data as Object)
    On Error GoTo ErrorHandler
    Dim sheetName,name as String
    Dim row,column as Long
    dim value as Variant
    sheetName = "生产日报"    
    For Each k In locatTable.Keys
        row=locatTable(k)(0)
        column=locatTable(k)(1)
        name = k
        value=Worksheets(sheetName).Cells(row,column).value
        data(name) = value
    Next
    value = split(data("海管进/出口压力兆帕"),"/") 
    data("海管进口压力兆帕")=value(0)
    data("海管出口压力兆帕")=value(1)
    value = split(data("海管进/出口温度摄氏度"),"/")
    data("海管进口温度摄氏度") = value(0)
    data("海管出口温度摄氏度") = value(1)    
ErrorHandler:    
    If Err.Number Then
        Debug.Print Err.Number & vbTab & Err.source & vbTab & Err.Description
    End If      
End Sub
'日报数据清除
Sub clearDailyTable(ByRef locatTable as Object)  
    On Error GoTo ErrorHandler
    Dim sheetName as String
    Dim row,column as Long
    sheetName = "生产日报"    
    For Each k In locatTable.Keys
        row=locatTable(k)(0)
        column=locatTable(k)(1)
        ' If Worksheets(sheetName).Cells(row,column).MergeArea Then

        ' Else
        '     Worksheets(sheetName).Cells(row,column).ClearContents
        ' End If
        Worksheets(sheetName).Cells(row,column).value=Null
    Next    
ErrorHandler:    
    If Err.Number Then
        Debug.Print Err.Number & vbTab & Err.source & vbTab & Err.Description
    End If    
End Sub
'填写日报
Sub fillDailyData(ByRef locatTable as Object,ByRef data as Object)
    On Error GoTo ErrorHandler
    Dim sheetName,name as String
    Dim row,column as Long
    dim value as Variant
    sheetName = "生产日报"    
    For Each k In locatTable.Keys
        row=locatTable(k)(0)
        column=locatTable(k)(1)
        name = k
        value = data(name)
        Worksheets(sheetName).Cells(row,column).value=value
    Next    
ErrorHandler:    
    If Err.Number Then
        Debug.Print Err.Number & vbTab & Err.source & vbTab & Err.Description
    End If     
End Sub
