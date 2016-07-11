Option Explicit
Sub test()
'    Call testData
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
    Dim ts As Object
    Set ts = CreateObject("Scripting.Dictionary")
    Dim kslr As New 快速录入
    Call kslr.maySum(ts)
    Call kslr.getProrationData(table)
    Call kslr.getBaseData(table)
    Call kslr.getDerivedData(table, ts)
    Call kslr.FillDailyProduction(table)   
End Sub
'相关化验数据自动填写
Public Sub testData()
On Error GoTo ErrorHandler
'    日期
    Dim 日期 As Date
'    海管
    Dim 海管来液含水上午, 海管来液含水下午, 海管MEG浓度上午, 海管MEG浓度下午, 海管出口凝点上午, 海管出口凝点下午, 海管出口PH值上午, 海管出口PH值下午
'    油
    Dim 轻油装车t, 轻油装车m3, 轻油装车bbl, 外输凝点, 外输PH值, 轻油入罐前含水, 轻油入罐前含水上午, 轻油入罐前含水下午, 饱和蒸汽压, 轻油比重
'    轻烃
    Dim 丙烷装车t, 丁烷装车t, 液化气装车t As Double
'    化学药剂
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
    轻油装车m3 = round(轻油装车t / 轻油比重, 2)
    SQL = "select 数据 from 生产信息 where 名称='外输凝点' and 日期=(select max(日期) from 生产信息 where 名称='外输凝点' and 日期 <= '" & 日期 & "' )"
    外输凝点 = psql.cnn.Execute(SQL)(0)
    SQL = "select 数据 from 生产信息 where 名称='外输PH值' and 日期=(select max(日期) from 生产信息 where 名称='外输PH值' and 日期 <= '" & 日期 & "' )"
    外输PH值 = psql.cnn.Execute(SQL)(0)
    filter = " and 名称='E-613饱和蒸汽压' and 类别='轻油';"
    SQL = ss & filter
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
        Debug.Print SQL
    End If
    If Err.Number <> 3021 Then
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
Sub DBsave_Click()
'    非日报数据存储到数据库
    Dim sy As New 上游
    Call sy.save
    Dim scdt As New 生产动态
    Call scdt.save
End Sub
'返回主页
Private Sub 返回主页_Click()
    Sheets("主页").Select
End Sub
'保存
Private Sub 保存_Click()
On Error GoTo ErrorHandler
    Dim t As Date
    t = Now
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
    Dim ts As Object
    Set ts = CreateObject("Scripting.Dictionary")
    Dim kslr As New 快速录入
    Call kslr.maySum(ts)
    Call kslr.getProrationData(table)
    Call kslr.getBaseData(table)
    Call kslr.getDerivedData(table, ts)
    Call kslr.FillDailyProduction(table)
'   非日报数据库存入数据库
'    污水存入数据库
    dim data as variant
    data = table("污水")
    With record
        .日期 = 日期
        .名称 = "污水"
        .单位 = "方"
        .数据 = 污水
        .类别 = "水"
        .状态 = "外输"
    End With
    table.add record, ""
    Set record = Nothing
    Dim scxx As New 生产信息
    Call scxx.PushTableToDatabase(table)
    Dim scdt As New 生产动态
    Call scdt.save
    Worksheets("生产日报").Select
    Application.ScreenUpdating = True
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub
'返回
Private Sub 返回_Click()
    Sheets("生产日报").Select
End Sub
Private Sub 海管_Click()
    Worksheets("海管").Select
End Sub

Private Sub 化验数据提取_Click()
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

'清除
Private Sub 清除_Click()
    Cells(3, 5).ClearContents
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
'        不删除含有公式单元格内容
        If Not Cells(row, column).HasFormula Then
            Cells(row, column).ClearContents
        Else
'            Debug.Print row, column, Cells(row, column - co).value
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
    Cells(1, 3).value = datevalue(Now)
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
    t = DateAdd("d", -1, Now)
    Cells(1, 3).value = datevalue(t)
    Call testData
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub

