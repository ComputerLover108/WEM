Option Explicit
Dim 日期 As Date
Private Sub test()
    '// add declarations
    On Error GoTo catchError
    Dim data As Object
    Set data = CreateObject("Scripting.Dictionary")
    data("日期") = "2019-4-30"
    Call getRelatedData(data)
    Dim k As Variant
    For Each k In data.Keys
        Debug.Print k, data.item(k)
    Next
    Debug.Print data.count
exitSub:
    Exit Sub
catchError:
    '// add error handling
    GoTo exitSub
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
    Dim fn
    fn = Application.GetOpenFilename(filter, , "请选文件", , MultiSelect:=True)
    If Not IsArray(fn) Then Exit Sub
    Dim temp
    Dim data As Object
    Set data = CreateObject("Scripting.Dictionary")
    For Each temp In fn
        Call dataAcquisition(temp, data)
    Next temp
    Dim panku As New Inventory
    Call panku.save(data)
End Sub

Private Sub 信息采集_Click()
    Dim hasright As Boolean
    Dim sd As String
    sd = InputBox("请输入密码：", "危险操作！", "******")
    Dim h As New help
    hasright = h.checkRight(sd)
    If False = hasright Then
        MsgBox "密码不对！禁止危险操作！"
        Exit Sub
    End If
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
        Dim fname
        Dim data As Object
        Set data = CreateObject("Scripting.Dictionary")
        For Each fname In fileList.Keys
            Call dataAcquisition(fname, data)
        Next fname
    End If
    Dim panku As New Inventory
    Call panku.save(data)
    hasright = False
End Sub

Private Sub dataAcquisition(ByVal fname As String, ByRef table As Object)
    On Error GoTo ErrorHandler
    Dim wb, sh As Object
    Set wb = Workbooks.Open(fname, 0, ReadOnly)
    Dim h As New help
    Dim flag, pattern As String
    flag = "葫芦岛天然气终端厂油气盘库报"
    pattern = "[0-9]{4}年[0-9]{1,2}月[0-9]{1,2}日"
    Dim d As Date
    Dim temp, temp1, temp2 As Variant
    Dim row, column, ro, co, lastRow, lastColumn As Long
    lastRow = UsedRange.Rows.count
    lastColumn = UsedRange.Columns.count
    Dim condition1, condition2 As Boolean
    Dim aim, aims, units  As Variant
    aims = Array("轻.*油", "液.*化.*气")
    units = Array("方", "桶", "吨")
    Dim SQL, name, unit, category, status, remark, source As String
    source = fname
    Dim recordPK As New Inventory
    For Each sh In wb.Worksheets
        condition1 = condition2 = False
        For row = 1 To lastRow
            For column = 1 To lastColumn
                temp = sh.Cells(row, column).value
                If h.isMatch(flag, temp) Then
                    condition1 = True
                End If
                If h.isMatch(pattern, temp) Then
                    d = h.search(temp, pattern)
                    If IsDate(d) Then
                        condition2 = True
                    End If
                End If
                If condition1 And condition2 Then
                    For Each aim In aims
                        For Each unit In units
                            If h.isMatch(unit, temp) Then
                                co = 1
                                If unit = "方" Then
                                    ro = -3
                                End If
                                If unit = "桶" Then
                                    ro = -4
                                End If
                                If unit = "吨" Then
                                    ro = -5
                                End If
                                temp2 = sh.Cells(row + ro, column + co).value
                                If h.isMatch(aim, temp2) Then
                                    co = 2
                                    temp = sh.Cells(row, column + co).value
                                    If h.isMatch("轻.*油", temp2) Then
                                        name = "轻油"
                                    End If
                                    If h.isMatch("液.*化.*气", temp2) Then
                                        name = "轻烃"
                                    End If
                                    category = name
                                    status = "库存"
                                    With recordPK
                                        .create_date = d
                                        .product = name
                                        .unit = unit
                                        .product_data = temp
                                        .category = category
                                        .status = status
                                        .source = source
                                    End With
                                    table.Add recordPK, ""
                                    Set recordPK = Nothing
                        
                                    co = co + 2
                                    temp = sh.Cells(row, column + co).value
                                    status = "外输"
                                    With recordPK
                                        .create_date = d
                                        .product = name
                                        .unit = unit
                                        .product_data = temp
                                        .category = category
                                        .status = status
                                        .source = source
                                    End With
                                    table.Add recordPK, ""
                                    Set recordPK = Nothing
                                    co = co + 2
                                    temp = sh.Cells(row, column + co).value
                                    status = "生产"
                                    With recordPK
                                        .create_date = d
                                        .product = name
                                        .unit = unit
                                        .product_data = temp
                                        .category = category
                                        .status = status
                                        .source = source
                                    End With
                                    table.Add recordPK, ""
                                    Set recordPK = Nothing
                                End If
                            End If
                        Next unit
                    Next aim
                    If h.isMatch("天然气(外输量|自用量)|放空量", temp) Then
                        name = sh.Cells(row, column).value
                        unit = "方"
                        category = "天然气"
                        If h.isMatch("外输量", name) Then
                            status = "外输"
                        End If
                        If h.isMatch("自用量|放空量", name) Then
                            status = "消耗"
                        End If
                        ro = 2
                        temp = sh.Cells(row + ro, column).value
                        With recordPK
                            .create_date = d
                            .product = name
                            .unit = unit
                            .product_data = temp
                            .category = category
                            .status = status
                            .source = source
                        End With
                        table.Add recordPK, ""
                        Set recordPK = Nothing
                    End If
                End If
            Next column
        Next row
    Next sh
    wb.Close SaveChanges:=False
    Set wb = Nothing
    Application.ScreenUpdating = True
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
End Sub

Private Sub getRelatedData(ByRef data As Object)
    '// add declarations
    On Error GoTo catchError
    Dim psql As New PostgreSQL
    Dim SQL As String
    Dim d, lastMonth As Date
    Dim rst1, rst2, rst3 As Variant
    Dim temp
    Dim h As New help
    d = data("日期")
    lastMonth = DateSerial(Year(d), Month(d), 1) - 1
    SQL = "SELECT concat(名称,单位),数据 FROM 生产信息 WHERE 单位='方' AND 状态='计划' AND 日期='$1';"
    SQL = replace(SQL, "$1", d)
    Debug.Print SQL
    rst1 = psql.cnn.Execute(SQL).GetRows()
    rst2 = h.transpose2DArray(rst1)
    Call h.array2dic(rst2, data)

    SQL = "SELECT concat(名称,单位),数据 FROM 生产信息 WHERE 名称 IN ('轻油库存合计','轻烃库存') AND 单位='吨' AND 状态='库存' AND 日期='$1';"
    SQL = replace(SQL, "$1", d)
    Debug.Print SQL
    rst1 = psql.cnn.Execute(SQL).GetRows()
    rst2 = h.transpose2DArray(rst1)
    Call h.array2dic(rst2, data)

   SQL = "select concat('上月',status,product,unit),product_data from inventory where create_date='$1';"
   SQL = replace(SQL, "$1", lastMonth)
   Debug.Print SQL
   rst1 = psql.cnn.Execute(SQL).GetRows()
   rst2 = h.transpose2DArray(rst1)
   Call h.array2dic(rst2, data)
    
    SQL = "SELECT concat('月累',名称,单位),sum(数据) FROM 生产信息 WHERE 名称='轻油装车' AND 单位 IN ('方','桶','吨') AND 状态='外输'  AND 日期 BETWEEN date_trunc('month',TIMESTAMP '$1') AND '$1' GROUP BY 名称,单位;"
    SQL = replace(SQL, "$1", d)
   Debug.Print SQL
   rst1 = psql.cnn.Execute(SQL).GetRows()
   rst2 = h.transpose2DArray(rst1)
   Call h.array2dic(rst2, data)

   SQL = "SELECT concat('月累轻烃装车',单位),sum(数据) FROM 生产信息 WHERE 名称 IN ('丙烷装车','丁烷装车','液化气装车') AND 单位='吨' AND 状态='外输' AND 日期 BETWEEN date_trunc('month',TIMESTAMP '$1') AND '$1' GROUP BY 单位;"
   SQL = replace(SQL, "$1", d)
   Debug.Print SQL
   rst1 = psql.cnn.Execute(SQL).GetRows()
   rst2 = h.transpose2DArray(rst1)
   Call h.array2dic(rst2, data)

   SQL = "SELECT concat('年累轻烃装车',单位),sum(数据) FROM 生产信息 WHERE 名称 IN ('丙烷装车','丁烷装车','液化气装车') AND 单位='吨' AND 状态='外输' AND 日期 BETWEEN date_trunc('month',TIMESTAMP '$1') AND '$1' GROUP BY 单位;"
   SQL = replace(SQL, "$1", d)
   Debug.Print SQL
   rst1 = psql.cnn.Execute(SQL).GetRows()
   rst2 = h.transpose2DArray(rst1)
   Call h.array2dic(rst2, data)

   SQL = "SELECT concat('月累',名称,单位),sum(数据) FROM 生产信息 WHERE 名称 IN ('数据库轻油回收量','数据库丙丁烷回收量') AND 单位='方' AND 状态='生产'AND 日期 BETWEEN date_trunc('$1',TIMESTAMP '$2') AND '$2' GROUP BY 名称,单位;"
   SQL = replace(SQL, "$1", "month")
   SQL = replace(SQL, "$2", d)
   Debug.Print SQL
   rst1 = psql.cnn.Execute(SQL).GetRows()
   rst2 = h.transpose2DArray(rst1)
   Call h.array2dic(rst2, data)

   SQL = "SELECT concat('$0',名称,单位),sum(数据) FROM 生产信息 WHERE 名称 IN ('总外输气量','自用气','火炬长明灯','火炬放空量') AND 单位='方' AND 日期 BETWEEN date_trunc('$1',TIMESTAMP '$2') AND '$2' GROUP BY 名称,单位;"
   SQL = replace(SQL, "$0", "月累")
   SQL = replace(SQL, "$1", "month")
   SQL = replace(SQL, "$2", d)
   Debug.Print SQL
   rst1 = psql.cnn.Execute(SQL).GetRows()
   rst2 = h.transpose2DArray(rst1)
   Call h.array2dic(rst2, data)
   SQL = "SELECT concat('$0',名称,单位),sum(数据) FROM 生产信息 WHERE 名称 IN ('总外输气量','自用气','火炬长明灯','火炬放空量') AND 单位='方' AND 日期 BETWEEN date_trunc('$1',TIMESTAMP '$2') AND '$2' GROUP BY 名称,单位;"
   SQL = replace(SQL, "$0", "上月年累")
   SQL = replace(SQL, "$1", "year")
   SQL = replace(SQL, "$2", lastMonth)
   Debug.Print SQL
   rst1 = psql.cnn.Execute(SQL).GetRows()
   rst2 = h.transpose2DArray(rst1)
   Call h.array2dic(rst2, data)

    data("月累天然气外输量方") = data("月累总外输气量方")
    data("月累工业天然气量方") = data("月累总外输气量方")
    data("月累天然气自用量方") = data("月累自用气方")
    data("月累放空量方") = data("月累火炬长明灯方") + data("月累火炬放空量方")
    data("上月年累天然气外输量方") = data("上月年累总外输气量方")
    data("上月年累工业天然气量方") = data("上月年累天然气外输量方")
    data("上月年累天然气自用量方") = data("上月年累自用气方")
    data("上月年累放空量方") = data("上月年累火炬放空量方") + data("上月年累火炬长明灯方")
exitSub:
    Exit Sub
catchError:
    '// add error handling
    Debug.Print Err.Number & vbTab & Err.Description
    GoTo exitSub
End Sub

Private Sub look_Click()
    Dim sd As String
    Dim d As Date
    sd = InputBox("请输入指定日期：", "自动生成指定日期的盘库报表", DateValue(Now))
    If False = IsDate(sd) Then
        MsgBox "日期不正确!"
        Exit Sub
    End If
    d = CDate(sd)
    Dim data As Object
    Set data = CreateObject("Scripting.Dictionary")
    data("日期") = d
    Call getRelatedData(data)
    Call fillTable(data)
    Dim k As Variant
'    For Each k In data.Keys
'        Debug.Print k, data.item(k)
'    Next
    Debug.Print data.count
End Sub

Private Sub fillTable(ByRef data As Object)
    '// add declarations
    On Error GoTo catchError
    Dim row, column, ro, co, lastRow, lastColumn As Long
    lastRow = UsedRange.Rows.count
    lastColumn = UsedRange.Columns.count
    Dim h As New help
    Dim temp, temp1 As Variant
    Dim name As String
    For row = 1 To lastRow
        For column = 1 To lastColumn
            temp = Cells(row, column).value
            If h.isMatch("库*存", temp) Then
                ro = -1
                co = 0
                temp1 = Cells(row + ro, column + co).value
                If h.isMatch("轻.*油", temp1) Then
                    ro = 2
                    co = 0
                    Cells(row + ro, column + co).value = data("上月库存轻油方")
                    ro = ro + 1
                    Cells(row + ro, column + co).value = data("上月库存轻油桶")
                    ro = ro + 1
                    Cells(row + ro, column + co).value = data("上月库存轻油吨")
                    co = co + 1
                    Cells(row + ro, column + co).value = data("轻油库存合计吨")
                End If
                If h.isMatch("液.*化.*气", temp1) Then
                    ro = 2
                    co = 0
                    Cells(row + ro, column + co).value = data("上月库存轻烃方")
                    ro = ro + 1
                    Cells(row + ro, column + co).value = data("上月库存轻烃桶")
                    ro = ro + 1
                    Cells(row + ro, column + co).value = data("上月库存轻烃吨")
                    co = co + 1
                    Cells(row + ro, column + co).value = data("轻烃库存吨")
                End If
            End If
            If h.isMatch("销.*售.*量", temp) Then
                ro = -1
                co = -2
                temp1 = Cells(row + ro, column + co).value
                If h.isMatch("轻.*油", temp1) Then
                    ro = 2
                    co = 0
                    Cells(row + ro, column + co).value = data("月累轻油装车方")
                    ro = ro + 1
                    Cells(row + ro, column + co).value = data("月累轻油装车桶")
                    ro = ro + 1
                    Cells(row + ro, column + co).value = data("月累轻油装车吨")
                End If
                If h.isMatch("液.*化.*气", temp1) Then
                    ro = 4
                    co = 0
                    Cells(row + ro, column + co).value = data("月累轻烃装车吨")
                End If
            End If
            If h.isMatch("盘.*库.*产.*量", temp) Then
                ro = -1
                co = -4
                temp1 = Cells(row + ro, column + co).value
                If h.isMatch("轻.*油", temp1) Then
                    ro = 2
                    co = 0
                    Cells(row + ro, column + co).value = data("月累数据库轻油回收量方")
                End If
                If h.isMatch("液.*化.*气", temp1) Then
                    ro = 2
                    co = 0
                    Cells(row + ro, column + co).value = data("月累数据库丙丁烷回收量方")
                End If
            End If
            If h.isMatch("计.*划.*产.*量", temp) And row < 20 Then
                ro = -1
                co = -6
                temp1 = Cells(row + ro, column + co).value
                If h.isMatch("轻.*油", temp1) Then
                    ro = 2
                    co = 0
                    Cells(row + ro, column + co).value = data("轻油月配产方")
                    co = co + 1
                    Cells(row + ro, column + co).value = data("轻油年配产方")
                End If
                If h.isMatch("液.*化.*气", temp1) Then
                    ro = 2
                    co = 0
                    Cells(row + ro, column + co).value = data("丙丁烷月配产方")
                    co = co + 1
                    Cells(row + ro, column + co).value = data("丙丁烷年配产方")
                End If
            End If
            If h.isMatch("备.*注", temp) Then
                ro = -1
                co = -8
                temp1 = Cells(row + ro, column + co).value
                If h.isMatch("轻.*油", temp1) Then
                    ro = 2
                    co = 1
                    Cells(row + ro, column + co).value = data("上月外输年累轻油方")
                    co = co + 1
                    Cells(row + ro, column + co).value = data("上月外输年累轻油桶")
                    co = co + 1
                    Cells(row + ro, column + co).value = data("上月外输年累轻油吨")
                    ro = ro + 1
                    co = 1
                    Cells(row + ro, column + co).value = data("上月生产年累轻油方")
                    co = co + 1
                    Cells(row + ro, column + co).value = data("上月生产年累轻油桶")
                    co = co + 1
                    Cells(row + ro, column + co).value = data("上月生产年累轻油吨")
                End If
                If h.isMatch("液.*化.*气", temp1) Then
                    ro = 2
                    co = 1
                    Cells(row + ro, column + co).value = data("上月外输年累轻烃方")
                    co = co + 1
                    Cells(row + ro, column + co).value = data("上月外输年累轻烃桶")
                    co = co + 1
                    Cells(row + ro, column + co).value = data("上月外输年累轻烃吨")
                    ro = ro + 1
                    co = 1
                    Cells(row + ro, column + co).value = data("上月生产年累轻烃方")
                    co = co + 1
                    Cells(row + ro, column + co).value = data("上月生产年累轻烃桶")
                    co = co + 1
                    Cells(row + ro, column + co).value = data("上月生产年累轻烃吨")
                End If
            End If
            If h.isMatch("工业天然气|天然气外输量|天然气自用量|放空量", temp) Then
                ro = 1
                co = 0
                temp = Trim(temp)
                name = "月累" + temp + "万方"
                data(name) = data("月累" + temp + "方") / 10 ^ 4
                Cells(row + ro, column + co).value = data(name)
                ro = ro + 2
                name = "上月年累" + temp + "万方"
                data(name) = data("上月年累" + temp + "方") / 10 ^ 4
                Cells(row + ro, column + co).value = data(name)
            End If
            If h.isMatch("日期.*\d+[年\-\/]\d+[月\-\/]\d+[日]{0,1}", temp) Then
                temp = h.replace(temp, "日期.*\d+[年\-\/]\d+[月\-\/]\d+[日]{0,1}", "日期：" + Format(data("日期"), "Long Date"))
                Cells(row, column).value = temp
                Debug.Print temp
            End If
            If h.isMatch("计划产量.*亿立方\/年\s+.*万立方米\/月", temp) Then
                temp = h.replace(temp, "\d+(\.\d+)亿立方\/年", CStr(data("天然气年配产方") / 10 ^ 8) + "亿立方/年")
                temp = h.replace(temp, "\d+(\.\d+)万立方米\/月", CStr(data("天然气月配产方") / 10 ^ 4) + "万立方米/月")
                Cells(row, column).value = temp
                Debug.Print temp, data("天然气年配产方"), data("天然气月配产方"), data("日期")
            End If
        Next column
    Next row
exitSub:
    Exit Sub
catchError:
    '// add error handling
    Debug.Print Err.Number & vbTab & Err.Description
    GoTo exitSub
End Sub

Private Sub 打印_Click()
    Call 保存_Click
    Worksheets("盘库报表").PrintOut
End Sub

Private Sub 返回_Click()
    Worksheets("工艺生产").Select
End Sub

Private Sub 返回主页_Click()
    Worksheets("主页").Select
End Sub

Private Sub 清除_Click()
    Worksheets("盘库报表").Cells(2, 13).ClearContents
    Dim cell As Range
    '轻油
    Worksheets("盘库报表").Range(Cells(12, 2), Cells(14, 9)).Select
    For Each cell In Selection
        If cell.HasFormula = False Then cell.ClearContents
    Next cell
    Worksheets("盘库报表").Range(Cells(12, 11), Cells(13, 13)).Select
    For Each cell In Selection
        If cell.HasFormula = False Then cell.ClearContents
    Next cell
    
    '丙丁烷
    Worksheets("盘库报表").Range(Cells(18, 2), Cells(20, 9)).Select
    For Each cell In Selection
        If cell.HasFormula = False Then cell.ClearContents
    Next cell
    Worksheets("盘库报表").Range(Cells(18, 11), Cells(19, 13)).Select
    For Each cell In Selection
        If cell.HasFormula = False Then cell.ClearContents
    Next cell
    '天然气
    Worksheets("盘库报表").Range(Cells(23, 3), Cells(23, 14)).ClearContents
    Worksheets("盘库报表").Range(Cells(25, 3), Cells(25, 14)).ClearContents
    Worksheets("盘库报表").Cells(21, 8).ClearContents
    Worksheets("盘库报表").Cells(21, 11).ClearContents
End Sub
