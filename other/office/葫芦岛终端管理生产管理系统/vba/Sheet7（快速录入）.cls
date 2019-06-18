Option Explicit
Sub test()
    Err.Clear
    On Error GoTo ErrorHandler
    t = Now
    Dim 日期, k, v, i, t, s
    Dim data As Object
    Set data = CreateObject("Scripting.Dictionary")
    Call getProductionAllocation(data)
    Debug.Print "获得配产数据耗时" & DateDiff("s", t, Now) & "s!"
    Call getQuickInputData(data)
    Debug.Print "获得快速录入数据耗时" & DateDiff("s", t, Now) & "s!"
    For Each k In data.Keys
        s = unitConvert(k)
        data.key(k) = s
    Next
    Call getRelevantData(data)
    Debug.Print "获得生产日报相关数据耗时" & DateDiff("s", t, Now) & "s!"
    Call getDerivedData(data)
    Debug.Print "获得生产日报计算数据耗时" & DateDiff("s", t, Now) & "s!"
    For Each k In data.Keys
        Debug.Print k, data.item(k)
    Next
    Call fillProductionDaily(data)
    Debug.Print "填写生产日报计算数据耗时" & DateDiff("s", t, Now) & "s!"
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
'保存
Private Sub 保存_Click()
    Err.Clear
    On Error GoTo ErrorHandler
    Dim 日期, k, v, i, t, s
    t = Now
    Dim data As Object
    Set data = CreateObject("Scripting.Dictionary")
    Call getProductionAllocation(data)
    Debug.Print "获得配产数据耗时" & DateDiff("s", t, Now) & "s!"
    Call getQuickInputData(data)
    Debug.Print "获得快速录入数据耗时" & DateDiff("s", t, Now) & "s!"
    For Each k In data.Keys
        s = unitConvert(k)
        data.key(k) = s
    Next
    Call getDerivedData(data)
    Debug.Print "获得生产日报计算数据耗时" & DateDiff("s", t, Now) & "s!"
    For Each k In data.Keys
        Debug.Print k, data.item(k)
    Next
    Call fillProductionDaily(data)
    Debug.Print "填写生产日报计算数据耗时" & DateDiff("s", t, Now) & "s!"
    Call fillGasConsumptionTable(data)
    Debug.Print "填写燃气消耗计算数据耗时" & DateDiff("s", t, Now) & "s!"
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
'相关化验数据自动填写
Public Sub testData()
    On Error GoTo ErrorHandler
    '日期
    Dim 日期 As Date
    '海管
    Dim 海管来液含水上午, 海管来液含水下午, 海管MEG浓度上午, 海管MEG浓度下午, 海管出口凝点上午, 海管出口凝点下午, 海管出口PH值上午, 海管出口PH值下午
    '油
    Dim 轻油装车t, 轻油装车m3, 轻油装车bbl, 外输凝点, 外输PH值, 轻油入罐前含水, 轻油入罐前含水上午, 轻油入罐前含水下午, 饱和蒸汽压, 轻油比重
    '轻烃
    Dim 丙烷装车t, 丁烷装车t, 液化气装车t As Double
    '化学药剂
    Dim 乙二醇生产, 乙二醇浓度 As Double
    Dim beginRow, beginColumn, lastRow, lastColumn, row, column, ro, co As Single
    beginRow = 1
    beginColumn = 2
    lastRow = UsedRange.Rows.count
    lastColumn = UsedRange.Columns.count
    Dim temp As Variant
    Dim SQL, ss, filter As String
    Dim psql As New PostgreSQL
    For row = beginRow To lastRow
        temp = Cells(row, beginColumn).value
        If temp = "日期" Then
            co = 1
            日期 = Cells(row, beginColumn + co).value
            Exit For
        End If
    Next row
    Dim 最近日期 As Date
    ss = "select 数据 from 生产信息 where 日期='" & 日期 & "'"
    filter = " and 名称='海管来液含水' and 备注='上午';"
    SQL = ss & filter
    海管来液含水上午 = psql.cnn.Execute(SQL)(0)
    filter = " and 名称='海管来液含水' and 备注='下午';"
    SQL = ss & filter
    海管来液含水下午 = psql.cnn.Execute(SQL)(0)
    filter = " and 名称='海管MEG浓度' and 备注='上午';"
    SQL = ss & filter
    海管MEG浓度上午 = psql.cnn.Execute(SQL)(0)
    filter = " and 名称='海管MEG浓度' and 备注='下午';"
    SQL = ss & filter
    海管MEG浓度下午 = psql.cnn.Execute(SQL)(0)
    filter = " and 名称='海管出口凝点' and 备注='上午';"
    SQL = ss & filter
    海管出口凝点上午 = psql.cnn.Execute(SQL)(0)
    filter = " and 名称='海管出口凝点' and 备注='下午';"
    SQL = ss & filter
    海管出口凝点下午 = psql.cnn.Execute(SQL)(0)
    filter = " and 名称='海管出口PH值' and 备注='上午';"
    SQL = ss & filter
    海管出口PH值上午 = psql.cnn.Execute(SQL)(0)
    filter = " and 名称='海管出口PH值' and 备注='下午';"
    SQL = ss & filter
    海管出口PH值下午 = psql.cnn.Execute(SQL)(0)
    SQL = "select 数据 from 生产信息 where 名称='轻油密度' and 日期=(select max(日期) from 生产信息 where 名称='轻油密度' and 日期 <= '" & 日期 & "' )"
    轻油比重 = psql.cnn.Execute(SQL)(0)
    SQL = "select sum(实际装车t) from 提单 where 日期='" & 日期 & "' and 产品名称='轻油' ;"
    轻油装车t = psql.cnn.Execute(SQL)(0)
    SQL = "select sum(实际装车bbl) from 提单 where 日期='" & 日期 & "' and 产品名称='轻油' ;"
    轻油装车bbl = psql.cnn.Execute(SQL)(0)
    SQL = "select sum(实际装车m3) from 提单 where 日期='" & 日期 & "' and 产品名称='轻油' ;"
    轻油装车m3 = psql.cnn.Execute(SQL)(0)
    '轻油装车m3 = Round(轻油装车t / 轻油比重, 2)
    SQL = "select 数据 from 生产信息 where 名称='外输凝点' and 日期=(select max(日期) from 生产信息 where 名称='外输凝点' and 日期 <= '" & 日期 & "' )"
    外输凝点 = psql.cnn.Execute(SQL)(0)
    SQL = "select 数据 from 生产信息 where 名称='外输PH值' and 日期=(select max(日期) from 生产信息 where 名称='外输PH值' and 日期 <= '" & 日期 & "' )"
    外输PH值 = psql.cnn.Execute(SQL)(0)
    SQL = "select 数据 from 生产信息 where 名称='E-613饱和蒸汽压' and 类别='轻油' and 日期=(select max(日期) from 生产信息 where 名称='E-613饱和蒸汽压' and 日期 <= '" & 日期 & "' )"
    饱和蒸汽压 = psql.cnn.Execute(SQL)(0)
    filter = " and 名称='入罐前含水' and 备注='上午' and 类别='轻油'; "
    SQL = ss & filter
    轻油入罐前含水上午 = psql.cnn.Execute(SQL)(0)
    filter = " and 名称='入罐前含水' and 备注='下午' and 类别='轻油'; "
    SQL = ss & filter
    轻油入罐前含水下午 = psql.cnn.Execute(SQL)(0)
    轻油入罐前含水 = FormatNumber(轻油入罐前含水上午, -1, -1) & "/" & FormatNumber(轻油入罐前含水下午, -1, -1)
    SQL = "select sum(实际装车t) from 提单 where 日期='" & 日期 & "' and 产品名称='丙烷' ;"
    丙烷装车t = psql.cnn.Execute(SQL)(0)
    SQL = "select sum(实际装车t) from 提单 where 日期='" & 日期 & "' and 产品名称='丁烷' ;"
    丁烷装车t = psql.cnn.Execute(SQL)(0)
    SQL = "select sum(实际装车t) from 提单 where 日期='" & 日期 & "' and 产品名称='液化气' ;"
    液化气装车t = psql.cnn.Execute(SQL)(0)
    filter = " and 名称='乙二醇浓度';"
    SQL = ss & filter
    乙二醇浓度 = psql.cnn.Execute(SQL)(0)
    filter = " and 名称='乙二醇回收' and 单位='方';"
    SQL = ss & filter
    乙二醇生产 = psql.cnn.Execute(SQL)(0)
    For row = beginRow To lastRow
        For column = beginColumn To lastColumn
            temp = Cells(row, column).value
            If temp Like "海管来液含水*" Then
                co = 1
                Cells(row, column + co).value = 海管来液含水上午
                co = 2
                Cells(row, column + co).value = 海管来液含水下午
            End If
            If temp Like "海管MEG浓度*" Then
                co = 1
                Cells(row, column + co).value = 海管MEG浓度上午
                co = 2
                Cells(row, column + co).value = 海管MEG浓度下午
            End If
            If temp Like "海管出口凝点*" Then
                co = 1
                Cells(row, column + co).value = 海管出口凝点上午
                co = 2
                Cells(row, column + co).value = 海管出口凝点下午
            End If
            If temp Like "海管出口PH值*" Then
                co = 1
                Cells(row, column + co).value = 海管出口PH值上午
                co = 2
                Cells(row, column + co).value = 海管出口PH值下午
            End If
            If temp Like "轻油装车t*" Then
                co = 1
                Cells(row, column + co).value = 轻油装车t
            End If
            If temp Like "轻油装车m3*" Then
                co = 1
                Cells(row, column + co).value = 轻油装车m3
            End If
            If temp Like "轻油装车bbl*" Then
                co = 1
                Cells(row, column + co).value = 轻油装车bbl
            End If
            If temp Like "外输凝点*" Then
                co = 1
                Cells(row, column + co).value = 外输凝点
                co = 2
                SQL = "select max(日期) from 生产信息 where 名称='外输凝点' and 日期 <= '" & 日期 & "';"
                最近日期 = psql.cnn.Execute(SQL)(0)
                If 最近日期 <> 日期 Then
                    Cells(row, column + co).value = 最近日期 & "以后没有化验数据"
                    Cells(row, column + co).Font.ColorIndex = 3
                Else
                    Cells(row, column + co).ClearContents
                End If
            End If
            If temp Like "外输PH值*" Then
                co = 1
                Cells(row, column + co).value = 外输PH值
                co = 2
                SQL = "select max(日期) from 生产信息 where 名称='外输PH值' and 日期 <= '" & 日期 & "';"
                最近日期 = psql.cnn.Execute(SQL)(0)
                If 最近日期 <> 日期 Then
                    Cells(row, column + co).value = 最近日期 & "以后没有化验数据"
                    Cells(row, column + co).Font.ColorIndex = 3
                Else
                    Cells(row, column + co).ClearContents
                End If
            End If
            If temp Like "饱和蒸汽压*" Then
                co = 1
                Cells(row, column + co).value = 饱和蒸汽压
                co = 2
                SQL = "select max(日期) from 生产信息 where 名称='饱和蒸汽压' and 日期 <= '" & 日期 & "';"
                最近日期 = psql.cnn.Execute(SQL)(0)
                If 最近日期 <> 日期 Then
                    Cells(row, column + co).value = 最近日期 & "以后没有化验数据"
                    Cells(row, column + co).Font.ColorIndex = 3
                Else
                    Cells(row, column + co).ClearContents
                End If
            End If
            If temp Like "轻油入罐前*" Then
                co = 1
                Cells(row, column + co).value = 轻油入罐前含水
            End If
            If temp Like "轻油比重*" Then
                co = 1
                Cells(row, column + co).value = 轻油比重
                co = 2
                SQL = "select max(日期) from 生产信息 where 名称='轻油密度' and 日期 <= '" & 日期 & "';"
                最近日期 = psql.cnn.Execute(SQL)(0)
                If 最近日期 <> 日期 Then
                    Cells(row, column + co).value = 最近日期 & "以后没有化验数据"
                    Cells(row, column + co).Font.ColorIndex = 3
                Else
                    Cells(row, column + co).ClearContents
                End If
            End If
            If temp Like "丙烷装车t*" Then
                co = 1
                Cells(row, column + co).value = 丙烷装车t
            End If
            If temp Like "丁烷装车t*" Then
                co = 1
                Cells(row, column + co).value = 丁烷装车t
            End If
            If temp Like "液化气装车t*" Then
                co = 1
                Cells(row, column + co).value = 液化气装车t
            End If
            If temp Like "乙二醇浓度*" Then
                co = 1
                Cells(row, column + co).value = 乙二醇浓度
            End If
            If temp Like "乙二醇日回收*" Then
                co = 1
                Cells(row, column + co).value = 乙二醇生产
            End If
        Next column
    Next row
ErrorHandler:
    If 3021 = Err.Number Then
    'Debug.Print SQL
    End If
    If Err.Number <> 3021 Then
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
Sub DBsave_Click()
    '非日报数据存储到数据库
    Dim sy As New 上游
    Call sy.save
    Dim scdt As New 生产动态
    Call scdt.save
End Sub
'返回主页
Private Sub 返回主页_Click()
    Sheets("主页").Select
End Sub
'返回
Private Sub 生产日报_Click()
    Sheets("生产日报").Select
End Sub
Private Sub 海管_Click()
    Worksheets("海管").Select
End Sub

Private Sub 化验数据提取_Click()
    Err.Clear
    On Error GoTo errorhander
    'Dim psql As New PostgreSQL
    'Call psql.数据库整理
    Dim filter As String
    filter = "microsoft office excel files (*.xls),*.xls"
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
    'For Each temp In scRecord.Keys
    'Debug.Print temp.日期, temp.名称, temp.单位, temp.数据, temp.类别, temp.备注
    'Next temp
errorhander:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
End Sub

'清除
Private Sub 清除_Click()
    Cells(3, 5).ClearContents
    Cells(21, 5).ClearContents
    Dim row, column, beginRow, lastRow, co As Single
    beginRow = 1
    co = 1
    column = 3
    lastRow = UsedRange.Rows.count
    Dim temp As Variant
    For row = beginRow To lastRow
        temp = Cells(row, column - co).value
        If temp Like "海管来液含水*" Then
            Cells(row, column + co).ClearContents
        End If
        If temp Like "海管MEG浓度*" Then
            Cells(row, column + co).ClearContents
        End If
        If temp Like "海管出口凝点*" Then
            Cells(row, column + co).ClearContents
        End If
        If temp Like "海管出口PH值*" Then
            Cells(row, column + co).ClearContents
        End If
        If temp Like "JZ20-2凝析油*" Then
            Cells(row, column + co).ClearContents
        End If
        If temp Like "JZ20-2轻油*" Then
            Cells(row, column + co).ClearContents
        End If
        If temp Like "外输凝点*" Then
            Cells(row, column + co).ClearContents
        End If
        If temp Like "外输PH值*" Then
            Cells(row, column + co).ClearContents
        End If
        If temp Like "轻油比重*" Then
            Cells(row, column + co).ClearContents
        End If
        '不删除含有公式单元格内容
        If Not Cells(row, column).HasFormula Then
            Cells(row, column).ClearContents
        Else
        'Debug.Print row, column, Cells(row, column - co).value
        End If
    Next row
End Sub
Private Sub 消峰平谷_Click()
    Sheets("消峰平谷").Select
    Call Worksheets("消峰平谷").清除_Click
    Worksheets("消峰平谷").Cells(4, 10).value = Cells(1, 3).value
End Sub
'自动填写今天日期
Private Sub 今天_Click()
    Err.Clear
    On Error GoTo ErrorHandler
    Call 清除_Click
    Cells(1, 3).value = DateValue(Date)
    [日期] = Worksheets("快速录入").Cells(1, 3).value
    Call testData
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
'自动填写昨天日期
Private Sub 昨天_Click()
    Err.Clear
    On Error GoTo ErrorHandler
    Call 清除_Click
    Dim t As Date
    t = DateAdd("d", -1, Date)
    Cells(1, 3).value = DateValue(t)
    [日期] = Cells(1, 3).value
    Call testData
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub

' 填燃气消耗表
Private Sub fillGasConsumptionTable(gasConsumptionTable)
    Err.Clear
    On Error GoTo ErrorHandler
    Dim row, column, beginRow, beginColumn, rowLimit, columnLimit, ro As Long
    Dim flag, name, k As String
    Dim temp, gasConsumption
    Dim h As New help
    flag = "燃气消耗"
    rowLimit = Worksheets("生产日报").Rows.count
    columnLimit = Worksheets("生产日报").Columns.count
    For row = 1 To rowLimit
        For column = 1 To columnLimit
            temp = Worksheets("生产日报").Cells(row, column).value
            If TypeName(temp) = "String" Then
                If h.isMatch(flag, temp) Then
                    beginRow = row + 1
                    beginColumn = column + 1
                    rowLimit = row + 5
                    columnLimit = column + 5
                    Debug.Print temp & "[" & row & "," & column & "],[" & rowLimit & "," & columnLimit & "]"
                    GoTo LabelFillTable
                End If
            End If
        Next column
    Next row
LabelFillTable:
    gasConsumption = Array("热油炉", "锅炉房用气", "火炬长明灯", "火炬放空量", "FIQ-2043")
    For row = beginRow To rowLimit
        For column = beginColumn To columnLimit
            temp = Worksheets("生产日报").Cells(row, column).value
            If TypeName(temp) = "String" Then
                For Each name In gasConsumption
                'Debug.Print temp, name, h.isMatch(name, temp)
                    If h.isMatch(name, temp) Then
                        ro = 1
                        k = name + "方"
                        Worksheets("生产日报").Cells(row + ro, column).value = gasConsumptionTable.item(k)
                        ro = ro + 1
                        k = "月累" + name + "方"
                        Worksheets("生产日报").Cells(row + ro, column).value = gasConsumptionTable.item(k)
                        ro = ro + 1
                        k = "年累" + name + "方"
                        Worksheets("生产日报").Cells(row + ro, column).value = gasConsumptionTable.item(k)
                    End If
                Next name
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
'获得快速录入数据
Private Sub getQuickInputData(ByRef data As Object)
    On Error GoTo ErrorHandler
    Dim row, column, rowLimit, columnLimit, ro, co As Integer
    rowLimit = UsedRange.Rows(ActiveSheet.UsedRange.Rows.count).row
    column = 2
    Dim temp As Variant
    Dim name As String
    Dim h As New help
    For row = 1 To rowLimit
        temp = Cells(row, column).value
        If h.isMatch("日期", temp) Then
            co = 1
            name = "日期"
            temp = Cells(row, column + co)
            data(name) = temp
        End If
        If h.isMatch("V-6[34][1-3][ABC]{0,1}", temp) Then
            co = 1
            name = h.search("V-6[34][1-3][ABC]{0,1}", temp) + "m"
            temp = Cells(row, column + co).value
            data(name) = temp
        End If
        If h.isMatch("(海管来液含水)|(海管MEG浓度)|(海管出口凝点℃)|(海管出口PH值)", temp) Then
            co = 1
            name = h.search("(海管来液含水)|(海管MEG浓度)|(海管出口凝点℃)|(海管出口PH值)", temp)
            temp = Cells(row, column + co).value
            data("上午" + name) = temp
            co = 2
            temp = Cells(row, column + co).value
            data("下午" + name) = temp
        End If
        If h.isMatch("(JZ20-2凝析油m3)|(JZ20-2轻油m3)", temp) Then
            co = 1
            name = h.search("(JZ20-2凝析油m3)|(JZ20-2轻油m3)", temp)
            temp = Cells(row, column + co).value
            data(name) = temp
            co = 2
            temp = Cells(row, column + co).value
            name = h.replace(name, "m3", "密度t/m3")
            data(name) = temp
        End If
        If h.isMatch("JZ20-2体系", temp) Then
            co = 1
            temp = Trim(temp)
            name = "接收" + temp
            temp = Cells(row, column + 1).value
            data(name) = temp
        End If
        If h.isMatch("水池水位", temp) Then
            name = "库存水米"
            co = 1
            temp = Cells(row, column + co).value
            data(name) = temp
        End If
        If h.isMatch("锅炉房用气", temp) Then
            name = "锅炉房用气方"
            co = 1
            temp = Cells(row, column + co).value
            data(name) = temp
        End If
        If h.isMatch("FIQ-2043", temp) Then
            name = "FIQ-2043方"
            co = 1
            temp = Cells(row, column + co).value
            data(name) = temp
        End If        
        If h.isMatch("FIQ-5014KNm3",temp) Then
            name = "FIQ-5014方"
            co = 1
            temp = Cells(row, column + co).value
            data(name) = temp*10^3            
        End If
        If h.isString(temp) Then
            name = temp
            co = 1
            temp = Cells(row, column + co).value
            data(name) = temp
        End If
        ' Debug.Print row, column, temp
    Next row
ErrorHandler:
        Debug.Print Err.Number & vbTab & Err.Description
        Resume Next
End Sub
'获得配产数据
Private Sub getProductionAllocation(ByRef data As Object)
    On Error GoTo ErrorHandler
    Dim row, column, beginRow, beginColumn, lastRow, lastColumn, ro, co As Long
    Const flag As String = "配产任务"
    Dim h As New help
    Dim temp As Variant
    beginRow = 1
    beginColumn = 1
    lastRow = ActiveSheet.UsedRange.Rows.count
    lastColumn = ActiveSheet.UsedRange.Columns.count
    Dim x, ar, name, value As Variant
    ar = Array("天然气", "丙丁烷", "轻油")
    For row = beginRow To lastRow
        For column = beginColumn To lastColumn
            temp = Cells(row, column).value
            If h.isMatch(flag, temp) Then
                beginRow = row
                beginColumn = column
                lastRow = row + 5
                lastColumn = column + 2
                GoTo AllocationFlag
            End If
        Next column
    Next row
AllocationFlag:
    For row = beginRow To lastRow
        For column = beginColumn To lastColumn
            temp = Cells(row, column).value
            For Each x In ar
                If h.isMatch(x, temp) Then
                    co = 1
                    name = "月配产" + temp
                    value = Cells(row, column + co).value
                    data.Add name, value
                    co = 2
                    name = "年配产" + temp
                    value = Cells(row, column + co).value
                    data.Add name, value
                End If
            Next x
        Next column
    Next row
    data.key("月配产天然气104m3") = "月配产天然气m3"
    data.key("年配产天然气104m3") = "年配产天然气m3"
    data("月配产天然气m3") = data("月配产天然气m3") * 10000
    data("年配产天然气m3") = data("年配产天然气m3") * 10000
ErrorHandler:
        Debug.Print Err.Number & vbTab & Err.Description
        Resume Next
End Sub

Private Sub getRelevantData(ByRef data As Object)
    On Error GoTo ErrorHandler
    Call getMaintenancePlaneData(data)
    Dim psql As New PostgreSQL
    Dim h As help
    Dim table, SQL As String
    '累计表数据转日累数据
    Dim names, arr, temp, s, results, name, value As Variant
    names = Array("FIQ-5014", "锅炉房用气", "火炬长明灯", "火炬放空量")
    s = "'" + Join(names, "','") + "'"
    table = "生产动态"
    Dim yesterday As Date
    yesterday = data("日期")
    yesterday = DateAdd("d", -1, yesterday)
    SQL = "SELECT 名称||单位,数据 FROM " & table & " where date_trunc('day',时间) = '" & yesterday & "' and 名称 in (" & s & ")"
    arr = psql.cnn.Execute(SQL).GetRows
    If IsNull(arr) Or IsEmpty(arr) Then
        MsgBox yesterday & " 数据丢失，请补填数据！"
        Exit Sub
    End If
    results = Application.Transpose(arr)
    Dim row, column As Long
    row = UBound(results, 1)
    column = UBound(results, 2)
    For row = 1 To UBound(results, 1)
        name = "昨" + results(row, 1)
        value = results(row, 2)
        data.Add name, value
    Next row
    Const MAX_fuelGas As Long = 999999
    data("热油炉方") = data("FIQ-5014方") - data("昨FIQ-5014方")
    If data("热油炉方") < 0 Then
       data ("热油炉方") + MAX_fuelGas
    End If
    data("锅炉房用气方") = data("锅炉房用气方") - data("昨锅炉房用气方")
    data("火炬长明灯方") = data("火炬长明灯方") - data("昨火炬长明灯方")
    data("火炬放空量方") = data("火炬放空量方") - data("昨火炬放空量方")
    Call getAggregateData(data, "year", yesterday)
        '获得昨月累数据
    Call getAggregateData(data, "month", yesterday)
        '获得昨日库存数据
    SQL = "SELECT 名称||单位,数据 from 生产信息 WHERE 日期 = '%0' and 状态='库存' and 名称 ~'(V-6\d+[ABC]{0,1})|水' and 单位 ~'方|吨'"
    SQL = replace(SQL, "%0", yesterday)
        'Debug.Print SQL
    arr = psql.cnn.Execute(SQL).GetRows
    If IsNull(arr) Or IsEmpty(arr) Then
        MsgBox yesterday & " 数据丢失，请补填数据！"
        Exit Sub
    End If
    results = Application.Transpose(arr)
    row = UBound(results, 1)
    For row = 1 To UBound(results, 1)
        name = results(row, 1)
        value = results(row, 2)
        name = "昨" + name
        data.Add name, value
        'Debug.Print name, data(name)
    Next row
ErrorHandler:
        Debug.Print Err.Number & vbTab & Err.Description
        Resume Next
End Sub
Function unitConvert(ByVal s As String)
    On Error GoTo ErrorHandler
    Dim h As New help
    s = h.replace(s, "t/m3", "吨/立方米")
    s = h.replace(s, "N{0,1}m3", "方")
    s = h.replace(s, "((V-6\d+[ABC]{0,1})|(库存水))(m)", "$1米")
    s = h.replace(s, "[kK]wh", "度")
    s = h.replace(s, "bbl", "桶")
    s = h.replace(s, "t", "吨")
    s = h.replace(s, "M[Pp]a", "兆帕")
    s = h.replace(s, "[kK][pP]a", "千帕")
    s = h.replace(s, "℃", "摄氏度")
    s = h.replace(s, "%", "")
    unitConvert = s
ErrorHandler:
        Debug.Print Err.Number & vbTab & Err.Description
        Resume Next
End Function
'获得月累，年累数据
Private Sub getAggregateData(ByRef data As Object, ByVal interval As String, ByVal sd As Date)
    On Error GoTo ErrorHandler
    Dim names, arr, results, name, value As Variant
    Dim s, SQL As String
    Dim psql As New PostgreSQL
    Dim row As Long
    names = Array("热油炉", "锅炉房用气", "火炬放空量", "火炬长明灯", "锦天化", "精细化工", "精细化工CNG", "入厂计量", "稳定区", "污水处理厂", "新奥燃气", "自用气", "总产气量", "总外输气量", "轻油回收量", "丙丁烷回收量", "甲醇消耗", "乙二醇消耗", "乙二醇回收", "水消耗", "外供水", "自采水", "自发电", "电消耗", "外供电","FIQ-2043")
    s = "'" + Join(names, "','") + "'"
    SQL = "SELECT 名称||单位 as name,SUM(数据) as sum from 生产信息 WHERE 日期 BETWEEN date_trunc('%0',timestamp '%1') and '%1' and 名称 in (%2) GROUP BY name order by name;"
    SQL = replace(SQL, "%0", interval)
    SQL = replace(SQL, "%1", sd)
    SQL = replace(SQL, "%2", s)
        'Debug.Print SQL
    arr = psql.cnn.Execute(SQL).GetRows
    If IsNull(arr) Or IsEmpty(arr) Then
        MsgBox sd & " 数据丢失，请补填数据！"
        Exit Sub
    End If
    results = Application.Transpose(arr)
    row = UBound(results, 1)
    For row = 1 To UBound(results, 1)
        name = results(row, 1)
        value = results(row, 2)
        Select Case interval
            Case "year"
                name = "年累" + name
            Case "month"
                name = "月累" + name
        End Select
        data.Add name, value
    'Debug.Print name, data(name)
    Next row
    SQL = "SELECT 状态||名称||单位 as name,SUM(数据) as sum from 生产信息 WHERE 日期 BETWEEN date_trunc('%0',timestamp '%1') and '%1' and 名称 ~('%2') GROUP BY name order by name;"
    SQL = replace(SQL, "%0", interval)
    SQL = replace(SQL, "%1", sd)
    s = "JZ20-2体系"
    SQL = replace(SQL, "%2", s)
    Erase arr
    Erase results
    'Debug.Print SQL
    arr = psql.cnn.Execute(SQL).GetRows
    If IsNull(arr) Or IsEmpty(arr) Then
        MsgBox sd & " 数据丢失，请补填数据！"
        Exit Sub
    End If
    results = Application.Transpose(arr)
    row = UBound(results, 1)
    For row = 1 To UBound(results, 1)
        name = results(row, 1)
        value = results(row, 2)
        Select Case interval
            Case "year"
                name = "年累" + name
            Case "month"
                name = "月累" + name
        End Select
        data.Add name, value
    'Debug.Print name, data(name)
    Next row
ErrorHandler:
        Debug.Print Err.Number & vbTab & Err.Description
        Resume Next
End Sub
' 推导数据
Private Sub getDerivedData(ByRef data As Object)
    On Error GoTo ErrorHandler
    Call getRelevantData(data)
    Call getHightHydrocarbonDensityData(data)
    Dim arr, temp, height, volume, quality, name As Variant
    '天然气
    data("接收JZ25-1S体系方") = data("入厂计量方") - data("接收JZ20-2体系方")
    data("外输JZ20-2体系方") = data("锦天化方") * data("接收JZ20-2体系方") / data("入厂计量方")
    data("外输JZ25-1S体系方") = data("锦天化方") - data("外输JZ20-2体系方")
    data("总外输气量方") = data("锦天化方") + data("精细化工方") + data("精细化工CNG方") + data("污水处理厂方") + data("新奥燃气方")
    data("总产气量方") = data("自用气方") + data("总外输气量方")
    '轻油
    arr = Array("V-631A", "V-631B", "V-631C")
    For Each temp In arr
        height = data(temp + "米")
        volume = height * 165
        quality = height * 122
        name = temp + "方"
        data.Add name, volume
        name = temp + "吨"
        data.Add name, quality
        data("轻油库存吨") = data("轻油库存吨") + quality
    Next temp
    data("昨轻油库存吨") = data("昨V-631A吨") + data("昨V-631B吨") + data("昨V-631C吨")
    data("轻油回收吨") = data("轻油库存吨") + data("轻油装车吨") - data("昨轻油库存吨")
    data("轻油回收方") = data("轻油回收吨") / data("轻油比重")
    data("轻油回收量方") = data("轻油回收方")
    data("轻油回收量吨") = data("轻油回收吨")
    '轻烃
    arr = Array("V-641A", "V-641B", "V-642", "V-643A", "V-643B")
    data("轻烃库存吨") = 0
    For Each temp In arr
        height = data(temp + "米")
        volume = height ^ 2 * 19.311 - height ^ 3 * 1.047
        quality = data(temp + "密度") * (3 * 6.15 - height) * 3.1415 * height ^ 2 / 3
        name = temp + "方"
        data.Add name, volume
    'Debug.Print name, volume
        name = temp + "吨"
        data.Add name, quality
    'Debug.Print name, quality, temp + "密度", data(temp + "密度")
        data("轻烃库存吨") = data("轻烃库存吨") + quality
    Next temp
    data("丙烷密度") = data("V-641A密度")
    data("丁烷密度") = data("V-642密度")
    data("液化气密度") = data("V-643A密度")
    data("丙烷装车方") = data("丙烷装车吨") / data("丙烷密度")
    data("丁烷装车方") = data("丁烷装车吨") / data("丁烷密度")
    data("液化气装车方") = data("液化气装车吨") / data("液化气密度")
    
    data("昨轻烃库存吨") = data("昨V-641A吨") + data("昨V-641B吨") + data("昨V-642吨") + data("昨V-643A吨") + data("昨V-643B吨")
    'Debug.Print data("昨轻烃库存吨"), data("昨V-641A吨"), data("昨V-641B吨"), data("昨V-642吨"), data("昨V-643A吨"), data("昨V-643B吨")
    data("轻烃回收吨") = data("丙烷装车吨") + data("丁烷装车吨") + data("液化气装车吨") + data("昨轻烃库存吨") - data("轻烃库存吨")
    'Debug.Print data("轻烃回收吨"), data("丙烷装车吨"), data("丁烷装车吨"), data("液化气装车吨"), data("昨轻烃库存吨"), data("轻烃库存吨")
    data("轻烃回收方") = data("轻烃回收吨") / 0.54
    data("丙丁烷回收量吨") = data("轻烃回收吨")
    data("丙丁烷回收量方") = data("轻烃回收方")
    
    data("库存水方") = data("库存水米") * 1390
    data("水消耗方") = data("昨库存水方") + data("外供水方") + data("自采水方") - data("库存水方")
    data("电消耗度") = data("外供电度") + data("自发电度")
    '月累年累
    Dim names, unit, name1, name2, name3 As Variant
    Dim h As New help
    names = Array("热油炉", "锅炉房用气", "火炬放空量", "火炬长明灯", "锦天化", "精细化工", "精细化工CNG", "入厂计量", "稳定区", "污水处理厂", "新奥燃气", "自用气", "总产气量", "总外输气量", "轻油回收量", "丙丁烷回收量", "甲醇消耗", "乙二醇回收", "水消耗", "外供水", "自采水", "自发电", "电消耗", "外供电")
    For Each temp In names
        If h.isMatch("电", temp) Then
            unit = "度"
        Else
            unit = "方"
        End If
        name1 = temp + unit
        name2 = "月累" + name1
        data(name2) = data(name1) + data(name2)
    'Debug.Print name2, data(name2), name1, data(name1)
        name2 = "年累" + name1
        data(name2) = data(name1) + data(name2)
    'Debug.Print name2, data(name2), name1, data(name1)
    Next temp
    data("月累接收JZ20-2体系方") = data("接收JZ20-2体系方") + data("月累接收JZ20-2体系方")
    data("年累接收JZ20-2体系方") = data("接收JZ20-2体系方") + data("年累接收JZ20-2体系方")
    data("月累外输JZ20-2体系方") = data("外输JZ20-2体系方") + data("月累外输JZ20-2体系方")
    data("年累外输JZ20-2体系方") = data("外输JZ20-2体系方") + data("年累外输JZ20-2体系方")
    data("年累天然气方") = data("年累总外输气量方")
    data("年累轻油方") = data("年累轻油回收量方")
    data("年累丙丁烷方") = data("年累丙丁烷回收量方")
    data("月累天然气方") = data("月累总外输气量方")
    data("月累轻油方") = data("月累轻油回收量方")
    data("月累丙丁烷方") = data("月累丙丁烷回收量方")
    
    data("去年年末") = DateSerial(Year(data("日期")) - 1, 12, 31)
    data("今年年末") = DateSerial(Year(data("日期")), 12, 31)
    data("年时间进度比") = (data("日期") - data("去年年末")) / (data("今年年末") - data("去年年末")) * 100
    data("今后需日产天然气方") = (data("年配产天然气方") - data("年累总外输气量方")) / data("剩余天数")
    data("今后需日产轻油方") = (data("年配产轻油方") - data("年累轻油回收量方")) / data("剩余天数")
    data("今后需日产丙丁烷方") = (data("年配产丙丁烷方") - data("年累丙丁烷回收量方")) / data("剩余天数")
ErrorHandler:
        Debug.Print Err.Number & vbTab & Err.Description
        Resume Next
End Sub
'获得丙丁烷密度
Private Sub getHightHydrocarbonDensityData(ByRef data As Object)
    On Error GoTo ErrorHandler
    Dim row, column, lastRow, lastColumn, ro, co As Long
    lastRow = Worksheets("生产日报").UsedRange.Rows.count
    lastColumn = Worksheets("生产日报").UsedRange.Columns.count
    Dim flag, temp, name, value As Variant
    Dim h As New help
    flag = "比重"
    For row = 1 To lastRow
        For column = 1 To lastColumn
            temp = Worksheets("生产日报").Cells(row, column).value
            If h.isString(temp) Then
                If h.isMatch(flag, temp) Then
                     For co = 0 To 4
                        ro = 1
                        name = Worksheets("生产日报").Cells(row + ro, column + co).value
                        name = name + "密度"
                        ro = 2
                        value = Worksheets("生产日报").Cells(row + ro, column + co).value
    'Debug.Print row + ro, column + co, name, value
                        data(name) = value
                    Next co
                    Exit Sub
                End If
            End If
        Next column
    Next row
ErrorHandler:
        Debug.Print Err.Number & vbTab & Err.Description
        Resume Next
End Sub
' 获得停产天数数据
Sub getMaintenancePlaneData(ByRef data As Object)
    Dim row, column, lastRow, lastColumn, ro, co As Long
    Dim temp, flag, d, d1, d2, name, value As Variant
    Dim h As New help
    lastRow = UsedRange.Rows.count
    lastColumn = UsedRange.Columns.count
    flag = "检修计划"
    d = data("日期")
    For row = 1 To lastRow
        For column = 1 To lastColumn
            temp = Cells(row, column).value
            If h.isMatch(flag, temp) Then
               co = 1
               ro = 1
               d1 = Cells(row + ro, column + co).value
               ro = 2
               d2 = Cells(row + ro, column + co).value
               name = "剩余天数"
               If d >= d1 And d <= d2 Then
                    value = DateSerial(Year(d), 12, 31) - d2
               Else
                    value = DateSerial(Year(d), 12, 31) - d
               End If
               data.Add name, value
    'Debug.Print name, value
               Exit Sub
            End If
        Next column
    Next row

End Sub
' 填写生产日报
Sub fillProductionDaily(ByRef data As Object)
    On Error GoTo ErrorHandler
    Dim row, column, lastRow, lastColumn, ro, co, i As Long
    Dim temp, arr, n, names, name, value As Variant
    Dim flag As String
    flag = "葫芦岛天然气终端厂生产日报"
    arr = Array("天然气", "轻油", "丙丁烷")
    Dim h As New help
    Worksheets("生产日报").Select
    lastRow = Worksheets("生产日报").UsedRange.Rows.count
    lastColumn = Worksheets("生产日报").UsedRange.Columns.count
    names = Array("稳定区", "入厂计量", "锦天化", "精细化工", "精细化工CNG", "污水处理厂", "新奥燃气", "自用气", "放空气", "总产气量", "总外输气量")
    For row = 1 To lastRow
        For column = 1 To lastColumn
            temp = Worksheets("生产日报").Cells(row, column).value
            If h.isString(temp) Then
                If h.isMatch(flag, temp) Then
                    lastColumn = Worksheets("生产日报").Cells(row, column).MergeArea.Columns.count
                    ro = 1
                    name = "日期"
                    value = data(name)
                    [日期] = value
                End If
                If h.isMatch("年时间", temp) Then
                    For ro = 1 To 3
                        name = "年时间进度比"
                        value = data(name)
                        Worksheets("生产日报").Cells(row + ro, column).value = value
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
                        value = data(name)
                        Worksheets("生产日报").Cells(row + ro, column).value = value
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
                        value = data(name)
                        Worksheets("生产日报").Cells(row + ro, column).value = value
                    Next i
                End If
                If h.isMatch("今后需日产", temp) Then
                    For i = 0 To UBound(arr)
                        ro = i + 1
                        name = "今后需日产" + arr(i) + "方"
                        value = data(name)
                        Worksheets("生产日报").Cells(row + ro, column).value = value
                    Next i
                End If
                For Each n In names
                    If h.isMatch(n, temp) Then
                        If h.isMatch("(稳定区)|(入厂计量)", n) Then
                            co = 1
                            name = n + "方"
                            value = data(name)
                            Worksheets("生产日报").Cells(row, column + co).value = value
                            co = 3
                            name = "月累" + n + "方"
                            value = data(name)
                            Worksheets("生产日报").Cells(row, column + co).value = value
                            co = 4
                            name = "年累" + n + "方"
                            value = data(name)
                            Worksheets("生产日报").Cells(row, column + co).value = value
                        End If
                        If h.isMatch("(锦天化)|(精细化工)|(精细化工CNG)|(污水处理厂)|(新奥燃气)|(自用气)|(放空气)", n) Then
                            co = 1
                            name = n + "方"
                            value = data(name)
                            If h.isMatch("(新奥燃气)|(自用气)|(放空气)", n) Then
                                co = 2
                            End If
                            Worksheets("生产日报").Cells(row, column + co).value = value
                            co = 4
                            name = "月累" + n + "方"
                            value = data(name)
                            Worksheets("生产日报").Cells(row, column + co).value = value
                            co = 5
                            name = "年累" + n + "方"
                            value = data(name)
                            Worksheets("生产日报").Cells(row, column + co).value = value
                        End If
                    End If
                Next n
                If h.isMatch("(海管来液含水)|(海管MEG浓度)|(海管出口凝点)|(海管出口PH值)", temp) Then
                    co = 1
                    n = unitConvert(temp)
                    'name = h.replace(n, "℃", "摄氏度")
                    'name = h.replace(n, "%", "")
                    name = "上午" + n
                    value = data(name)
                    Worksheets("生产日报").Cells(row, column + co).value = value
                    co = 2
                    name = "下午" + n
                    value = data(name)
                    Worksheets("生产日报").Cells(row, column + co).value = value
                End If
                If h.isMatch("海管进/出口压力MPa", temp) Then
                    co = 1
                    value = data("海管进/出口压力兆帕")
                    'value = CStr(data("进口海管压力兆帕")) + "/" + CStr(data("出口海管压力兆帕"))
                    Worksheets("生产日报").Cells(row, column + co).value = value
                End If
                If h.isMatch("海管进/出口温度℃", temp) Then
                    co = 1
                    value = data("海管进/出口温度摄氏度")
                    'value = CStr(data("进口海管温度摄氏度")) + "/" + CStr(data("出口海管温度摄氏度"))
                    Worksheets("生产日报").Cells(row, column + co).value = value
                End If
                If h.isMatch("(JZ20-2凝析油)|(JZ20-2轻油)", temp) Then
                    co = 1
                    name = unitConvert(temp)
                    value = data(name)
                    Worksheets("生产日报").Cells(row, column + co).value = value
                    co = 2
                    name = h.search("(JZ20-2凝析油)|(JZ20-2轻油)", name)
                    name = name + "密度吨/立方米"
                    value = data(name)
                    Worksheets("生产日报").Cells(row, column + co).value = value
                End If
                If h.isMatch("(轻油回收量)|(饱和蒸汽压)|(外输凝点)|(外输PH值)", temp) Then
                    ro = 1
                    name = temp
                    name = h.replace(name, "m3", "方")
                    name = h.replace(name, "t", "吨")
                    name = h.replace(name, "KPa", "千帕")
                    name = h.replace(name, "℃", "摄氏度")
                    value = data(name)
                    Worksheets("生产日报").Cells(row + ro, column).value = value
                End If
                If h.isMatch("V-6[34][123][ABC]{0,1}", temp) Then
                    ro = 1
                    name = h.search("V-6[34][123][ABC]{0,1}", temp) + "米"
                    value = data(name)
                    Worksheets("生产日报").Cells(row + ro, column).value = value
                End If
                If h.isMatch("轻烃库存t", temp) Then
                    ro = 1
                    name = "轻烃库存吨"
                    value = data(name)
                    Worksheets("生产日报").Cells(row + ro, column).value = value
                End If
                If h.isMatch("(装车)|(丙丁烷回收量)|(轻油入罐前含水)", temp) Then
                    co = 1
                    name = temp
                    name = h.replace(name, "t", "吨")
                    name = h.replace(name, "m3", "方")
                    name = h.replace(name, "bbl", "桶")
                    value = data(name)
                    If h.isMatch("(轻油装车t)|(数据库)", temp) Then
                        co = 2
                    End If
                    Worksheets("生产日报").Cells(row, column + co).value = value
                End If
                If h.isMatch("(甲醇消耗)|(乙二醇消耗|(乙二醇回收))|(外供水)|(水消耗)", temp) Then
                    ro = 1
                    name = replace(temp, "m3", "方")
                    value = data(name)
                    Worksheets("生产日报").Cells(row + ro, column).value = value
                    ro = 2
                    Worksheets("生产日报").Cells(row + ro, column).value = data("月累" + name)
                    ro = 3
                    Worksheets("生产日报").Cells(row + ro, column).value = data("年累" + name)
                End If
                If h.isMatch("(外供电)|(自发电)", temp) Then
                    ro = 1
                    name = replace(temp, "KWh", "度")
                    value = data(name)
                    'Debug.Print name, value
                    Worksheets("生产日报").Cells(row + ro, column).value = value
                    ro = 2
                    Worksheets("生产日报").Cells(row + ro, column).value = data("月累" + name)
                    ro = 3
                    Worksheets("生产日报").Cells(row + ro, column).value = data("年累" + name)
                End If
                If h.isMatch("(甲醇库存)|(水池水位)|(水池储水)", temp) Then
                    co = 1
                    name = "库存甲醇方"
                    value = data(name)
                    Worksheets("生产日报").Cells(row, column + co).value = value
                End If
                If h.isMatch("乙二醇浓度", temp) Then
                    co = 1
                    name = temp
                    value = data(name)
                    Worksheets("生产日报").Cells(row, column + co).value = value
                End If
                If h.isMatch("水池水位", temp) Then
                    co = 1
                    name = "库存水米"
                    value = data(name)
                    Worksheets("生产日报").Cells(row, column + co).value = value
                End If
                If h.isMatch("水池储水", temp) Then
                    co = 1
                    name = "库存水方"
                    value = data(name)
                    Worksheets("生产日报").Cells(row, column + co).value = value
                End If
                If h.isMatch("JZ20-2体系", temp) Then
                    ro = -1
                    name = Worksheets("生产日报").Cells(row + ro, column).value
                    If h.isMatch("入厂计量", name) Then
                        co = 1
                        value = data("接收JZ20-2体系方")
                        Worksheets("生产日报").Cells(row, column + co).value = value
                        co = 3
                        value = data("月累接收JZ20-2体系方")
                        Worksheets("生产日报").Cells(row, column + co).value = value
                        co = 4
                        value = data("年累接收JZ20-2体系方")
                        Worksheets("生产日报").Cells(row, column + co).value = value
                        ro = 1
                        value = data("接收JZ25-1S体系方")
                        Worksheets("生产日报").Cells(row + ro, column + co).value = value
                    Else
                        co = 1
                        value = data("外输JZ20-2体系方")
                        Worksheets("生产日报").Cells(row, column + co).value = value
                        co = 3
                        value = data("月累外输JZ20-2体系方")
                        Worksheets("生产日报").Cells(row, column + co).value = value
                        co = 4
                        value = data("年累外输JZ20-2体系方")
                        Worksheets("生产日报").Cells(row, column + co).value = value
                        ro = 1
                        value = data("外输JZ25-1S体系方")
                        Worksheets("生产日报").Cells(row + ro, column + co).value = value
                    End If
                End If
            End If
        Next column
    Next row
ErrorHandler:
        Debug.Print Err.Number & vbTab & Err.Description
        Resume Next
End Sub