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
        Call dataAcquisition(temp)
    Next temp
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
        For Each fname In fileList.Keys
            Call dataAcquisition(fname)
        Next fname
    End If
    hasright = False
End Sub

Private Sub dataAcquisition(ByVal fname As String)
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
    Dim SQL, SQL1, name, unit, category, status, remark, source As String
    source = fname
    remark = "盘库"
    Dim psql As New PostgreSQL
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
                                    SQL = "INSERT INTO inventory (create_date,product,unit,product_data,category,status,source) VALUES ('$1','$2','$3',$4,'$5','$6','$7') ON CONFLICT (create_date,product,unit,status) DO UPDATE SET product_data = EXCLUDED.product_data,source=EXCLUDED.source;"
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
                                    SQL = replace(SQL, "$1", d)
                                    SQL = replace(SQL, "$2", name)
                                    SQL = replace(SQL, "$3", unit)
                                    SQL = replace(SQL, "$4", temp)
                                    SQL = replace(SQL, "$5", category)
                                    SQL = replace(SQL, "$6", status)
                                    SQL = replace(SQL, "$7", source)
                                    psql.cnn.Execute (SQL)
                                    co = co + 2
                                    temp = sh.Cells(row, column + co).value
                                    status = "外输"
                                    SQL = "INSERT INTO inventory (create_date,product,unit,product_data,category,status,source) VALUES ('$1','$2','$3',$4,'$5','$6','$7') ON CONFLICT (create_date,product,unit,status) DO UPDATE SET product_data = EXCLUDED.product_data,source=EXCLUDED.source;"
                                    SQL = replace(SQL, "$1", d)
                                    SQL = replace(SQL, "$2", "年累" + name)
                                    SQL = replace(SQL, "$3", unit)
                                    SQL = replace(SQL, "$4", temp)
                                    SQL = replace(SQL, "$5", category)
                                    SQL = replace(SQL, "$6", status)
                                    SQL = replace(SQL, "$7", source)
                                    Debug.Print SQL
                                    psql.cnn.Execute (SQL)
                                    co = co + 2
                                    temp = sh.Cells(row, column + co).value
                                    status = "生产"
                                    SQL = "INSERT INTO inventory (create_date,product,unit,product_data,category,status,source) VALUES ('$1','$2','$3',$4,'$5','$6','$7') ON CONFLICT (create_date,product,unit,status) DO UPDATE SET product_data = EXCLUDED.product_data,source=EXCLUDED.source;"
                                    SQL = replace(SQL, "$1", d)
                                    SQL = replace(SQL, "$2", "年累" + name)
                                    SQL = replace(SQL, "$3", unit)
                                    SQL = replace(SQL, "$4", temp)
                                    SQL = replace(SQL, "$5", category)
                                    SQL = replace(SQL, "$6", status)
                                    SQL = replace(SQL, "$7", source)
                                    Debug.Print SQL
                                    psql.cnn.Execute (SQL)
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
                        SQL = "INSERT INTO inventory (create_date,product,unit,product_data,category,status,source) VALUES ('$1','$2','$3',$4,'$5','$6','$7') ON CONFLICT (create_date,product,unit,status) DO UPDATE SET product_data = EXCLUDED.product_data,source=EXCLUDED.source;"
                        SQL = replace(SQL, "$1", d)
                        SQL = replace(SQL, "$2", "年累" + name)
                        SQL = replace(SQL, "$3", unit)
                        SQL = replace(SQL, "$4", temp)
                        SQL = replace(SQL, "$5", category)
                        SQL = replace(SQL, "$6", status)
                        SQL = replace(SQL, "$7", source)
                        Debug.Print SQL
                        psql.cnn.Execute (SQL)
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
    rst1 = psql.cnn.Execute(SQL).GetRows()
    rst2 = h.transpose2DArray(rst1)
    Call h.array2dic(rst2, data)

    SQL = "SELECT concat(名称,单位),数据 FROM 生产信息 WHERE 名称 IN ('轻油库存合计','轻烃库存') AND 单位='吨' AND 状态='库存' AND 日期='$1';"
    SQL = replace(SQL, "$1", d)
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

Private Sub 指定日期_Click()
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
    For Each k In data.Keys
        Debug.Print k, data.item(k)
    Next
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
                name = "月累" + temp + "方"
                Cells(row + ro, column + co).value = data(name)
                ro = ro + 2
                name = "上月年累" + temp + "方"
                Cells(row + ro, column + co).value = data(name)
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

Private Sub 保存_Click()
Err.Clear
On Error GoTo ErrorHandler
    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim rst As New ADODB.Recordset
    Dim tablename As String
    Dim SQL As String
    Dim 名称 As String
    Dim 单位 As String
    Dim 数据 As Double
    Dim 类别 As String
    Dim 状态 As String
    Dim 年累 As Double
    日期 = Worksheets("盘库报表").Cells(2, 13).value
    tablename = "生产信息"
    Dim row As Integer
    Dim column As Integer
    Const rowLimit = 20
    Const columnLimit = 7
     For row = 12 To rowLimit
        For column = 3 To columnLimit
'        库存
'        日报已有轻油库存合计 方，吨
            If 12 = row And 3 = column Then
                名称 = " '轻油库存' "
                单位 = " '方' "
                类别 = " '轻油' "
                状态 = " '库存' "
            End If
'            If 13 = row And 3 = column Then
'                名称 = " '轻油库存合计' "
'                单位 = " '桶' "
'                类别 = " '轻油' "
'                状态 = " '库存' "
'            End If
'            日报已有轻烃库存合计 吨
'            If 14 = row And 3 = column Then
'                名称 = " '轻油库存合计' "
'                单位 = " '吨' "
'                类别 = " '轻油' "
'                状态 = " '库存' "
'            End If
            If 18 = row And 3 = column Then
                名称 = " '轻烃库存' "
                单位 = " '方' "
                类别 = " '轻油' "
                状态 = " '库存' "
            End If
'            If 19 = row And 3 = column Then
'                名称 = " '轻烃库存' "
'                单位 = " '桶' "
'                类别 = " '轻油' "
'                状态 = " '库存' "
'            End If
'            If 20 = row And 3 = column Then
'                名称 = " '轻烃库存' "
'                单位 = " '吨' "
'                类别 = " '轻油' "
'                状态 = " '库存' "
'            End If
'            轻油
            If 12 = row And 5 = column Then
                名称 = " '轻油装车' "
                单位 = " '方' "
                类别 = " '轻油' "
                状态 = " '外输' "
            End If
'            日报已有 轻油回收量 方
'            If 12 = row And 7 = column Then
'                名称 = " '轻油回收量' "
'                单位 = " '方' "
'                类别 = " '轻油' "
'                状态 = " '生产' "
'            End If
            If 13 = row And 5 = column Then
                名称 = " '轻油装车' "
                单位 = " '桶' "
                类别 = " '轻油' "
                状态 = " '外输' "
            End If
            If 13 = row And 7 = column Then
                名称 = " '轻油回收量' "
                单位 = " '桶' "
                类别 = " '轻油' "
                状态 = " '生产' "
            End If
            If 14 = row And 5 = column Then
                名称 = " '轻油装车' "
                单位 = " '吨' "
                类别 = " '轻油' "
                状态 = " '外输' "
            End If
            If 14 = row And 7 = column Then
                名称 = " '轻油回收量' "
                单位 = " '吨' "
                类别 = " '轻油' "
                状态 = " '生产' "
            End If
'            轻烃
            If 18 = row And 5 = column Then
                名称 = " '轻烃装车' "
                单位 = " '方' "
                类别 = " '丙丁烷' "
                状态 = " '外输' "
            End If
'            日报已有 丙丁烷回收量 方
'            If 18 = row And 7 = column Then
'                名称 = " '丙丁烷回收量' "
'                单位 = " '方' "
'                类别 = " '丙丁烷' "
'                状态 = " '生产' "
'            End If
            If 19 = row And 5 = column Then
                名称 = " '轻烃装车' "
                单位 = " '桶' "
                类别 = " '丙丁烷' "
                状态 = " '外输' "
            End If
            If 19 = row And 7 = column Then
                名称 = " '丙丁烷回收量' "
                单位 = " '桶' "
                类别 = " '丙丁烷' "
                状态 = " '生产' "
            End If
            If 20 = row And 5 = column Then
                名称 = " '轻烃装车' "
                单位 = " '吨' "
                类别 = " '丙丁烷' "
                状态 = " '外输' "
            End If
            If 20 = row And 7 = column Then
                名称 = " '丙丁烷回收量' "
                单位 = " '吨' "
                类别 = " '丙丁烷' "
                状态 = " '生产' "
            End If
            If 3 = column Then
                Select Case row
                    Case 12, 13, 18, 19
                        数据 = Worksheets("盘库报表").Cells(row, column).value
                        SQL = "select * from 生产信息 " & " where 日期= #" & 日期 & "# and 名称=" & 名称 & " and 单位=" & 单位
                        rst.Open SQL, ac.cnn, adOpenKeyset, adLockOptimistic
        '                access
                        If rst.RecordCount > 0 Then
                            SQL = " UPDATE " & tablename & " SET 数据=" & 数据 & " where 日期= #" & 日期 & "# and 名称=" & 名称 & " and 单位=" & 单位 & " and 状态=" & 状态
                            Call ac.cnn.Execute(SQL)
                        Else
                            SQL = "INSERT INTO " & tablename & " (日期,名称,单位,数据,类别,状态) VALUES ( #" & 日期 & "#," & 名称 & "," & 单位 & "," & 数据 & "," & 类别 & "," & 状态 & " )"
                            Call ac.cnn.Execute(SQL)
                        End If
                        rst.Close
        '                PostgreSQL
                        SQL = "select * from 生产信息 " & " where 日期= '" & 日期 & "' and 名称=" & 名称 & " and 单位=" & 单位
                        rst.Open SQL, psql.cnn, adOpenKeyset, adLockOptimistic
                        If rst.RecordCount > 0 Then
                            SQL = " UPDATE " & tablename & " SET 数据=" & 数据 & " where 日期= '" & 日期 & "' and 名称=" & 名称 & " and 单位=" & 单位
                            Call psql.cnn.Execute(SQL)
                        Else
                            SQL = "INSERT INTO " & tablename & " (日期,名称,单位,数据,类别,状态) VALUES ( '" & 日期 & "'," & 名称 & "," & 单位 & "," & 数据 & "," & 类别 & "," & 状态 & " )"
                            Call psql.cnn.Execute(SQL)
                        End If
                        rst.Close
                End Select
            End If
            If 5 = column Or 7 = column Then
                Select Case row
                    Case 12, 13, 14, 18, 19, 20
                        If 12 = row And 7 = column Then
                        
                        ElseIf 18 = row And 7 = column Then
                        
                        Else
                            年累 = Worksheets("盘库报表").Cells(row, column).value
                            SQL = "select * from 生产信息 " & " where 日期= #" & 日期 & "# and 名称=" & 名称 & " and 单位=" & 单位
                            rst.Open SQL, ac.cnn, adOpenKeyset, adLockOptimistic
            '                access
                            If rst.RecordCount > 0 Then
                                SQL = " UPDATE " & tablename & " SET 年累=" & 年累 & " where 日期= #" & 日期 & "# and 名称=" & 名称 & " and 单位=" & 单位
                                Call ac.cnn.Execute(SQL)
                            Else
                                SQL = "INSERT INTO " & tablename & " (日期,名称,单位,年累,类别,状态) VALUES ( #" & 日期 & "#," & 名称 & "," & 单位 & "," & 年累 & "," & 类别 & "," & 状态 & " )"
                                Call ac.cnn.Execute(SQL)
                            End If
                            rst.Close
            '                PostgreSQL
                            SQL = "select * from 生产信息 " & " where 日期= '" & 日期 & "' and 名称=" & 名称 & " and 单位=" & 单位
                            rst.Open SQL, psql.cnn, adOpenKeyset, adLockOptimistic
                            If rst.RecordCount > 0 Then
                                SQL = " UPDATE " & tablename & " SET 年累=" & 年累 & " where 日期= '" & 日期 & "' and 名称=" & 名称 & " and 单位=" & 单位
                                Call psql.cnn.Execute(SQL)
                            Else
                                SQL = "INSERT INTO " & tablename & " (日期,名称,单位,年累,类别,状态) VALUES ( '" & 日期 & "'," & 名称 & "," & 单位 & "," & 年累 & "," & 类别 & "," & 状态 & " )"
                                Call psql.cnn.Execute(SQL)
                            End If
                            rst.Close
                        End If
                End Select
            End If
        Next column
    Next row
    row = 24
    单位 = "  '方' "
    For column = 11 To 14
        Select Case column
            Case 10
                名称 = " 'JZ9-3供气' "
            Case 12
                名称 = " 'JZ21-1供气' "
            Case 13
                名称 = " 'JZ25-1供气' "
            Case 14
                名称 = " 'JZ25-1S供气' "
        End Select
'        表格为万方，数据库为方
        年累 = Worksheets("盘库报表").Cells(row, column).value * 10000
'        access
        SQL = "select * from 生产信息 " & " where 日期= #" & 日期 & "# and 名称=" & 名称 & " and 单位=" & 单位
        rst.Open SQL, ac.cnn, adOpenKeyset, adLockOptimistic
        If rst.RecordCount > 0 Then
            SQL = " UPDATE " & tablename & " SET 年累=" & 年累 & " where 日期= #" & 日期 & "# and 名称=" & 名称 & " and 单位=" & 单位
            Call ac.cnn.Execute(SQL)
        Else
            SQL = "INSERT INTO " & tablename & " (日期,名称,单位,年累,类别) VALUES ( #" & 日期 & "#," & 名称 & "," & 单位 & "," & 年累 & "," & 类别 & " )"
            Call ac.cnn.Execute(SQL)
        End If
        rst.Close
'        PostgreSQL
        SQL = "select * from 生产信息 " & " where 日期= '" & 日期 & "' and 名称=" & 名称 & " and 单位=" & 单位
        rst.Open SQL, psql.cnn, adOpenKeyset, adLockOptimistic
        If rst.RecordCount > 0 Then
            SQL = " UPDATE " & tablename & " SET 年累=" & 年累 & " where 日期= '" & 日期 & "' and 名称=" & 名称 & " and 单位=" & 单位
            Call psql.cnn.Execute(SQL)
        Else
            SQL = "INSERT INTO " & tablename & " (日期,名称,单位,年累,类别) VALUES ( '" & 日期 & "'," & 名称 & "," & 单位 & "," & 年累 & "," & 类别 & " )"
            Call psql.cnn.Execute(SQL)
        End If
        rst.Close
    Next column
 
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
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

Private Sub 月末_Click()
    If IsEmpty(Worksheets("盘库报表").Cells(2, 13)) Or IsNull(Worksheets("盘库报表").Cells(2, 13)) Then
        日期 = Now
    Else
        日期 = Worksheets("盘库报表").Cells(2, 13).value
    End If
'    下月初
    日期 = DateSerial(Year(日期), Month(日期) + 1, 1)
'    本月末
    日期 = DateAdd("d", -1, 日期)
'    Debug.Print 日期
    Worksheets("盘库报表").Cells(2, 13).value = 日期
End Sub

Private Sub 月中_Click()
    If IsEmpty(Worksheets("盘库报表").Cells(2, 13)) Or IsNull(Worksheets("盘库报表").Cells(2, 13)) Then
        日期 = Now
    Else
        日期 = Worksheets("盘库报表").Cells(2, 13).value
    End If
    日期 = DateSerial(Year(日期), Month(日期), 15)
'    Debug.Print 日期
    Worksheets("盘库报表").Cells(2, 13).value = 日期
End Sub

Private Sub 自动提取_Click()
    Err.Clear
    On Error GoTo ErrorHandler
    Dim ac As New access
    日期 = Worksheets("盘库报表").Cells(2, 13).value
    Dim help As New 时间
    If 15 = Day(日期) Or help.IsMonthEnd(日期) Then
        Dim SQL As String
        Dim 上月月底 As Date
        上月月底 = help.getMonthEnd(DateAdd("m", -1, 日期))
        Dim filter As String
        filter = " where 日期 between #" & DateSerial(Year(日期), Month(日期), 1) & "# and # " & 日期 & "#"
        '计划产量
        '轻油
        SQL = "select 数据 from 生产信息 where 日期 = #" & 日期 & "# and 单位='方' and 名称='轻油月配产' and 状态='计划' "
        Worksheets("盘库报表").Cells(12, 8).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select 数据 from 生产信息 where 日期 = #" & 日期 & "# and 单位='方' and 名称='轻油年配产' and 状态='计划' "
        Worksheets("盘库报表").Cells(12, 9).CopyFromRecordset ac.cnn.Execute(SQL)
'        丙丁烷
        SQL = "select 数据 from 生产信息 where 日期 = #" & 日期 & "# and 单位='方' and 名称='丙丁烷月配产' and 状态='计划' "
        Worksheets("盘库报表").Cells(18, 8).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select 数据 from 生产信息 where 日期 = #" & 日期 & "# and 单位='方' and 名称='丙丁烷年配产' and 状态='计划' "
        Worksheets("盘库报表").Cells(18, 9).CopyFromRecordset ac.cnn.Execute(SQL)
'        天然气
        SQL = "select 数据/10000 from 生产信息 where 日期 = #" & 日期 & "# and 单位='方' and 名称='天然气月配产' and 状态='计划' "
        Worksheets("盘库报表").Cells(21, 11).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select 数据/100000000 from 生产信息 where 日期 = #" & 日期 & "# and 单位='方' and 名称='天然气年配产' and 状态='计划' "
        Worksheets("盘库报表").Cells(21, 8).CopyFromRecordset ac.cnn.Execute(SQL)
'库存
'        上月
        SQL = "select 数据 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='方' and 名称='轻油库存' "
        Worksheets("盘库报表").Cells(12, 2).CopyFromRecordset ac.cnn.Execute(SQL)
'        SQL = "select 数据 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='桶' and 名称='轻油库存合计' "
'        Worksheets("盘库报表").Cells(13, 2).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select 数据 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='吨' and 名称='轻油库存合计' "
        Worksheets("盘库报表").Cells(14, 2).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select 数据 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='方' and 名称='轻烃库存' "
        Worksheets("盘库报表").Cells(18, 2).CopyFromRecordset ac.cnn.Execute(SQL)
'        SQL = "select 数据 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='桶' and 名称='轻烃库存' "
'        Worksheets("盘库报表").Cells(19, 2).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select 数据 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='吨' and 名称='轻烃库存' "
        Worksheets("盘库报表").Cells(20, 2).CopyFromRecordset ac.cnn.Execute(SQL)
'        本月
'        SQL = "select 数据 from 生产信息 where 日期 = #" & 日期 & "# and 单位='方' and 名称='轻油库存合计' "
'        Worksheets("盘库报表").Cells(12, 3).CopyFromRecordset ac.cnn.Execute(SQL)
'        SQL = "select 数据 from 生产信息 where 日期 = #" & 日期 & "# and 单位='桶' and 名称='轻油库存合计' "
'        Worksheets("盘库报表").Cells(13, 3).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select 数据 from 生产信息 where 日期 = #" & 日期 & "# and 单位='吨' and 名称='轻油库存合计' "
        Worksheets("盘库报表").Cells(14, 3).CopyFromRecordset ac.cnn.Execute(SQL)
'        SQL = "select 数据 from 生产信息 where 日期 = #" & 日期 & "# and 单位='方' and 名称='轻烃库存' "
'        Worksheets("盘库报表").Cells(18, 3).CopyFromRecordset ac.cnn.Execute(SQL)
'        SQL = "select 数据 from 生产信息 where 日期 = #" & 日期 & "# and 单位='桶' and 名称='轻烃库存' "
'        Worksheets("盘库报表").Cells(19, 3).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select 数据 from 生产信息 where 日期 = #" & 日期 & "# and 单位='吨' and 名称='轻烃库存' "
        Worksheets("盘库报表").Cells(20, 3).CopyFromRecordset ac.cnn.Execute(SQL)
'外输
'        上月
        If Year(日期) = Year(上月月底) Then
            SQL = "select 年累 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='方' and 名称='轻油装车' "
            Worksheets("盘库报表").Cells(12, 11).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='桶' and 名称='轻油装车' "
            Worksheets("盘库报表").Cells(12, 12).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='吨' and 名称='轻油装车' "
            Worksheets("盘库报表").Cells(12, 13).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='方' and 名称='轻烃装车' "
            Worksheets("盘库报表").Cells(18, 11).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='桶' and 名称='轻烃装车' "
            Worksheets("盘库报表").Cells(18, 12).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='吨' and 名称='轻烃装车' "
            Worksheets("盘库报表").Cells(18, 13).CopyFromRecordset ac.cnn.Execute(SQL)
        End If
'        本月
        SQL = "select sum(数据) as 月累 from 生产信息 " & filter & " and 单位='方' and 名称='轻油装车' "
        Worksheets("盘库报表").Cells(12, 4).CopyFromRecordset ac.cnn.Execute(SQL)
''        保留两位小数
'        Worksheets("盘库报表").Cells(12, 4).value = Round(Worksheets("盘库报表").Cells(12, 4).value, 2)
        SQL = "select sum(数据) as 月累 from 生产信息 " & filter & " and 单位='桶' and 名称='轻油装车' "
        Worksheets("盘库报表").Cells(13, 4).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select sum(数据) as 月累 from 生产信息 " & filter & " and 单位='吨' and 名称='轻油装车' "
        Worksheets("盘库报表").Cells(14, 4).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select sum(数据) as 月累 from 生产信息 " & filter & " and 单位='方' and 类别='丙丁烷' and 状态='外输' "
        Worksheets("盘库报表").Cells(18, 4).CopyFromRecordset ac.cnn.Execute(SQL)
''        保留两位小数
'        Worksheets("盘库报表").Cells(18, 4).value = Round(Worksheets("盘库报表").Cells(18, 4).value, 2)
        SQL = "select sum(数据) as 月累 from 生产信息 " & filter & " and 单位='吨' and 类别='丙丁烷' and 状态='外输' "
        Worksheets("盘库报表").Cells(20, 4).CopyFromRecordset ac.cnn.Execute(SQL)
'生产
'        上月
        If Year(日期) = Year(上月月底) Then
            SQL = "select 年累 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='方' and 名称='轻油回收量' "
            Worksheets("盘库报表").Cells(13, 11).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='桶' and 名称='轻油回收量' "
            Worksheets("盘库报表").Cells(13, 12).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='吨' and 名称='轻油回收量' "
            Worksheets("盘库报表").Cells(13, 13).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='方' and 名称='丙丁烷回收量' "
            Worksheets("盘库报表").Cells(19, 11).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='桶' and 名称='丙丁烷回收量' "
            Worksheets("盘库报表").Cells(19, 12).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累 from 生产信息 where 日期 = #" & 上月月底 & "# and 单位='吨' and 名称='丙丁烷回收量' "
            Worksheets("盘库报表").Cells(19, 13).CopyFromRecordset ac.cnn.Execute(SQL)
        End If
'        本月
        SQL = "select sum(数据) as 月累 from 生产信息 " & filter & " and 单位='方' and 名称='轻油回收量' "
        Worksheets("盘库报表").Cells(12, 6).CopyFromRecordset ac.cnn.Execute(SQL)
'        SQL = "select sum(数据) as 月累 from 生产信息 " & filter & " and 单位='吨' and 名称='轻油回收量' "
'        Worksheets("盘库报表").Cells(14, 6).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select sum(数据) as 月累 from 生产信息 " & filter & " and 单位='方' and 名称='丙丁烷回收量' "
        Worksheets("盘库报表").Cells(18, 6).CopyFromRecordset ac.cnn.Execute(SQL)
'        SQL = "select sum(数据) as 月累 from 生产信息 " & filter & " and 单位='吨' and 名称='丙丁烷回收量' "
'        Worksheets("盘库报表").Cells(20, 6).CopyFromRecordset ac.cnn.Execute(SQL)
'天然气
'        上月
        If Year(日期) = Year(上月月底) Then
            SQL = "select 年累/10000 from 生产信息 where 日期= #" & 上月月底 & "# and 单位='方' and 名称='总外输气量' "
            Worksheets("盘库报表").Cells(25, 3).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累/10000 from 生产信息 where 日期= #" & 上月月底 & "# and 单位='方' and 名称='自用气' "
            Worksheets("盘库报表").Cells(25, 5).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累/10000 from 生产信息 where 日期= #" & 上月月底 & "# and 单位='方' and 名称='总外输气量' "
            Worksheets("盘库报表").Cells(25, 7).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累/10000 from 生产信息 where 日期= #" & 上月月底 & "# and 单位='方' and 名称='JZ9-3供气' "
            Worksheets("盘库报表").Cells(25, 10).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累/10000 from 生产信息 where 日期= #" & 上月月底 & "# and 单位='方' and 名称='JZ21-1供气' "
            Worksheets("盘库报表").Cells(25, 12).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累/10000 from 生产信息 where 日期= #" & 上月月底 & "# and 单位='方' and 名称='JZ25-1供气' "
            Worksheets("盘库报表").Cells(25, 13).CopyFromRecordset ac.cnn.Execute(SQL)
            SQL = "select 年累/10000 from 生产信息 where 日期= #" & 上月月底 & "# and 单位='方' and 名称='JZ25-1S供气' "
            Worksheets("盘库报表").Cells(25, 14).CopyFromRecordset ac.cnn.Execute(SQL)
        End If
'        本月
        SQL = "select sum(数据)/10000 as 月累 from 生产信息 " & filter & " and 单位='方' and 名称='总外输气量' "
        Worksheets("盘库报表").Cells(23, 3).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select sum(数据)/10000 as 月累 from 生产信息 " & filter & " and 单位='方' and 名称='自用气' "
        Worksheets("盘库报表").Cells(23, 5).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select sum(数据)/10000 as 月累 from 生产信息 " & filter & " and 单位='方' and 名称='总外输气量' "
        Worksheets("盘库报表").Cells(23, 7).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select sum(数据)/10000 as 月累 from 生产信息 " & filter & " and 单位='方' and 名称='JZ9-3供气' "
        Worksheets("盘库报表").Cells(23, 10).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select sum(数据)/10000 as 月累 from 生产信息 " & filter & " and 单位='方' and 名称='JZ21-1供气' "
        Worksheets("盘库报表").Cells(23, 12).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select sum(数据)/10000 as 月累 from 生产信息 " & filter & " and 单位='方' and 名称='JZ25-1供气' "
        Worksheets("盘库报表").Cells(23, 13).CopyFromRecordset ac.cnn.Execute(SQL)
        SQL = "select sum(数据)/10000 as 月累 from 生产信息 " & filter & " and 单位='方' and 名称='JZ25-1S供气' "
        Worksheets("盘库报表").Cells(23, 14).CopyFromRecordset ac.cnn.Execute(SQL)
'备注
    Else
        MsgBox "在月中或月末盘库！"
        Exit Sub
    End If
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
