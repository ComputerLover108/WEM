Option Explicit
Sub test()
    Err.Clear
On Error GoTo ErrorHandler
'    Call testData
    Dim 日期, k, v, i, t
'    日期 = Cells(1, 3).value
'    Dim gasConsumptionTable As Object
'    Set gasConsumptionTable = CreateObject("Scripting.Dictionary")
'    Call getGasConsumption(日期, gasConsumptionTable)
'    For Each k In gasConsumptionTable.Keys
'        Debug.Print k, gasConsumptionTable.item(k)
'    Next
'    Call fillGasConsumptionTable(gasConsumptionTable)
    Dim data As Object
    Set data = CreateObject("Scripting.Dictionary")
    t = Now
    Call getProductionAllocation(data)
    Debug.Print "获得配产数据耗时" & DateDiff("s", t, Now) & "s!"
    Call getQuickInputData(data)
    Debug.Print "获得快速录入数据耗时" & DateDiff("s", t, Now) & "s!"
    Call unitConvert(data)
    Call getRelevantData(data)
    Debug.Print "获得生产日报相关数据耗时" & DateDiff("s", t, Now) & "s!"
    For Each k In data.Keys
        Debug.Print k, data.item(k)
    Next
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
    SQL = "select sum(实际装车m3) from 提单 where 日期='" & 日期 & "' and 产品名称='轻油' ;"
    轻油装车m3 = psql.cnn.Execute(SQL)(0)
'    轻油装车m3 = Round(轻油装车t / 轻油比重, 2)
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
'        Debug.Print SQL
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
    Dim t As Date
    t = Now
On Error GoTo ErrorHandler
'    存入数据库之前先保存excel表
    ThisWorkbook.save
    Dim 日期 As Date
    Dim 稳定区 As Long
    Dim 入厂计量 As Long
    Dim JZ202体系 As Long
'    Dim JZ251S体系 As Long
    Dim 锦天化 As Long
    Dim 精细化工 As Long
    Dim 精细化工CNG As Long
    Dim 污水处理厂 As Long
    Dim 新奥燃气 As Long
    Dim 自用气 As Long
    Dim 海管来液含水上午 As Double
    Dim 海管来液含水下午 As Double
    Dim 海管MEG浓度上午 As Double
    Dim 海管MEG浓度下午 As Double
    Dim 海管出口凝点上午 As Double
    Dim 海管出口凝点下午 As Double
    Dim 海管出口PH值上午 As Double
    Dim 海管出口PH值下午 As Double
    Dim 海管进出口压力 As String
    Dim 海管进出口温度 As String
    Dim 海管通球备注 As String
    Dim V631A As Double
    Dim V631B As Double
    Dim V631C As Double
    Dim 轻油装车t As Double
    Dim 轻油装车m3 As Double
    Dim 轻油装车bbl As Double
    Dim 外输凝点 As Double
    Dim 外输PH值 As String
    Dim 轻油入罐前含水 As String
    Dim 饱和蒸汽压 As Double
    Dim 轻油比重 As Double
    Dim V641A As Double
    Dim V641B As Double
    Dim V642 As Double
    Dim V643A As Double
    Dim V643B As Double
    Dim 丙烷装车t As Double
    Dim 丁烷装车t As Double
    Dim 液化气装车t As Double
    Dim 数据库轻油回收 As Double
    Dim 数据库丙丁烷回收 As Double
    Dim 乙二醇生产 As Double
    Dim 乙二醇浓度 As Double
    Dim 乙二醇消耗 As Double
    Dim 甲醇消耗 As Double
    Dim 外供水 As Double
    Dim 自采水 As Double
    Dim 水消耗 As Double
    Dim 污水 As Double
    Dim 水池水位 As Double
    Dim 外供电 As Double
    Dim 电消耗 As Double
    Dim 自发电 As Double
    Dim 生产备注 As String
    Dim 天然气月度配产 As Long
    Dim 天然气年度配产 As Long
    Dim 轻油月度配产 As Long
    Dim 轻油年度配产 As Long
    Dim 丙丁烷月度配产 As Long
    Dim 丙丁烷年度配产 As Long
'    Dim JZ251S原油 As Double
    Dim JZ202凝析油, JZ202轻油 As Double
    Dim JZ251S原油密度, JZ202凝析油密度, JZ202轻油密度 As Double
    Application.ScreenUpdating = False
    Dim row As Long
    Dim column As Long
    Dim rowLimit As Long
    Dim columnLimit As Long
    Dim offset As Integer
    rowLimit = Range("a65535").End(xlUp).row
    column = 2
    Dim temp As String
    Dim h As New help
    For row = 1 To rowLimit
        temp = Cells(row, column).value
        If temp Like "*非生产日报数据*" Then
            rowLimit = row - 1
            Exit For
        End If
    Next row
    For row = 1 To rowLimit
        temp = Cells(row, column).value
'        日期
        If temp Like "*日期*" Then
            offset = 1
            If IsEmpty(Cells(row, column + offset).value) Or IsNull(Cells(row, column + offset).value) Then
                MsgBox prompt:="没有填写日期！请重新填写！", Buttons:=vbOKOnly
                Exit Sub
            End If
            日期 = DateValue(Cells(row, column + offset).value)
        End If
'        天然气
'        稳定区
        If temp Like "*稳定区*" Then
            offset = 1
            稳定区 = Cells(row, column + offset).value
        End If
'        入厂厂计量
        If temp Like "*入厂计量*" Then
            offset = 1
            入厂计量 = Cells(row, column + offset).value
        End If
'        JZ20-2体系
        If temp Like "*JZ20-2体系*" Then
            offset = 1
            JZ202体系 = Cells(row, column + offset).value
        End If
'        JZ25-1S体系
'        If temp Like "*JZ25-1S体系*" Then
'            offset = 1
'            JZ251S体系 = Cells(row, column + offset).value
'        End If
'        锦天化
        If temp Like "*锦天化*" Then
            offset = 1
            锦天化 = Cells(row, column + offset).value
        End If
'        精细化工
        If temp Like "*精细化工Nm3*" Then
            offset = 1
            精细化工 = Cells(row, column + offset).value
        End If
        If temp Like "*精细化工CNGNm3" Then
            offset = 1
            精细化工CNG = Cells(row, column + offset).value
        End If
        
'        污水处理厂
        If temp Like "*污水处理厂*" Then
            offset = 1
            污水处理厂 = Cells(row, column + offset).value
        End If
'        新奥燃气
        If temp Like "*新奥燃气*" Then
            offset = 1
            新奥燃气 = Cells(row, column + offset).value
        End If
'        自用气
        If temp Like "*自用气*" Then
            offset = 1
            自用气 = Cells(row, column + offset).value
        End If
'    海管
'        海管来液含水
        If temp Like "*海管来液含水*" Then
            offset = 1
            海管来液含水上午 = Cells(row, column + offset).value
            offset = 2
            海管来液含水下午 = Cells(row, column + offset).value
        End If
'        海管MEG浓度
        If temp Like "*海管MEG浓度*" Then
            offset = 1
            海管MEG浓度上午 = Cells(row, column + offset).value
            offset = 2
            海管MEG浓度下午 = Cells(row, column + offset).value
        End If
'        海管出口凝点
        If temp Like "*海管出口凝点*" Then
            offset = 1
            海管出口凝点上午 = Cells(row, column + offset).value
            offset = 2
            海管出口凝点下午 = Cells(row, column + offset).value
        End If
'        海管出口PH值
        If temp Like "*海管出口PH值*" Then
            offset = 1
            海管出口PH值上午 = Cells(row, column + offset).value
            offset = 2
            海管出口PH值下午 = Cells(row, column + offset).value
        End If
'        海管进出口压力
        If temp Like "*海管进*出口压力*" Then
            offset = 1
            海管进出口压力 = Cells(row, column + offset).value
        End If
'        海管进出口温度
        If temp Like "*海管进*出口温度*" Then
            offset = 1
            海管进出口温度 = Cells(row, column + offset).value
        End If
'        海管通球备注
        If temp Like "*海管通球备注*" Then
            offset = 1
            海管通球备注 = Cells(row, column + offset).value
        End If
'    上游
'        JZ25-1S原油
        If temp Like "*JZ25-1S原油*" Then
'            offset = 1
'            JZ251S原油 = Cells(row, column + offset).value
            offset = 1
            JZ251S原油密度 = Cells(row, column + offset).value
        End If
'        JZ20-2凝析油
        If temp Like "*JZ20-2凝析油*" Then
            offset = 1
            JZ202凝析油 = Cells(row, column + offset).value
            offset = 2
            JZ202凝析油密度 = Cells(row, column + offset).value
        End If
'        JZ20-2轻油
        If temp Like "*JZ20-2轻油*" Then
            offset = 1
            JZ202轻油 = Cells(row, column + offset).value
            offset = 2
            JZ202轻油密度 = Cells(row, column + offset).value
        End If
'    轻油
'        V631A
        If temp Like "*V-631A*" Then
            offset = 1
            V631A = Cells(row, column + offset).value
        End If
'        V631B
        If temp Like "*V-631B*" Then
            offset = 1
            V631B = Cells(row, column + offset).value
        End If
'        V631C
        If temp Like "*V-631C*" Then
            offset = 1
            V631C = Cells(row, column + offset).value
        End If
'        轻油装车t
        If temp Like "*轻油装车t*" Then
            offset = 1
            轻油装车t = Cells(row, column + offset).value
        End If
'        轻油装车m3
        If temp Like "*轻油装车m3*" Then
            offset = 1
            轻油装车m3 = Cells(row, column + offset).value
        End If
'        轻油装车bbl
        If temp Like "*轻油装车bbl*" Then
            offset = 1
            轻油装车bbl = Cells(row, column + offset).value
        End If
'        外输凝点
        If temp Like "*外输凝点*" Then
            offset = 1
            外输凝点 = Cells(row, column + offset).value
        End If
'        外输PH值
        If temp Like "*外输PH值*" Then
            offset = 1
            外输PH值 = Cells(row, column + offset).value
        End If
'        轻油入罐前含水
        If temp Like "*轻油入罐前*含水*" Then
            offset = 1
            轻油入罐前含水 = Cells(row, column + offset).value
        End If
'        饱和蒸汽压
        If temp Like "*饱和蒸汽压*" Then
            offset = 1
            饱和蒸汽压 = Cells(row, column + offset).value
        End If
'        轻油比重
        If temp Like "*轻油比重*" Then
            offset = 1
            轻油比重 = Cells(row, column + offset).value
            If 0 = 轻油比重 Then
                MsgBox ("没有填写轻油比重或填写错误!")
                Exit Sub
            End If
        End If
'    丙丁烷
'        V641A
        If temp Like "*V-641A*" Then
            offset = 1
            V641A = Cells(row, column + offset).value
        End If
'        V641B
        If temp Like "*V-641B*" Then
            offset = 1
            V641B = Cells(row, column + offset).value
        End If
'        V642
        If temp Like "*V-642*" Then
            offset = 1
            V642 = Cells(row, column + offset).value
        End If
'        V643A
        If temp Like "*V-643A*" Then
            offset = 1
            V643A = Cells(row, column + offset).value
        End If
'        V643B
        If temp Like "*V-643B*" Then
            offset = 1
            V643B = Cells(row, column + offset).value
        End If
'        丙烷装车t
        If temp Like "*丙烷装车t*" Then
            offset = 1
            丙烷装车t = Cells(row, column + offset).value
        End If
'        丁烷装车t
        If temp Like "*丁烷装车t*" Then
            offset = 1
            丁烷装车t = Cells(row, column + offset).value
        End If
'        液化气装车t
        If temp Like "*液化气装车t*" Then
            offset = 1
            液化气装车t = Cells(row, column + offset).value
        End If
'    数据库
'        数据库轻油回收
        If temp Like "*数据库轻油回收*" Then
            offset = 1
            数据库轻油回收 = Cells(row, column + 1).value
        End If
'        数据库丙丁烷回收
        If temp Like "*数据库丙丁烷回收*" Then
            offset = 1
            数据库丙丁烷回收 = Cells(row, column + offset).value
        End If
'    化学药剂
'        乙二醇生产
        If temp Like "*乙二醇日回收量*" Then
            offset = 1
            乙二醇生产 = Cells(row, column + offset).value
        End If
'        乙二醇浓度
        If temp Like "*乙二醇浓度*" Then
            offset = 1
            乙二醇浓度 = Cells(row, column + offset).value
        End If
'        乙二醇消耗
        If temp Like "*乙二醇日耗量*" Then
            offset = 1
            乙二醇消耗 = Cells(row, column + offset).value
        End If
'        甲醇消耗
        If temp Like "*甲醇日耗量*" Then
            offset = 1
            甲醇消耗 = Cells(row, column + offset).value
        End If
'    水
'        外供水
        If temp Like "*外供水*" Then
            offset = 1
            外供水 = Cells(row, column + offset).value
        End If
'        自采水
        If temp Like "*自采水*" Then
            offset = 1
            自采水 = Cells(row, column + 1).value
        End If
'        污水
        If temp Like "*污水*" Then
            offset = 1
            污水 = Cells(row, column + 1).value
        End If
'        水池水位
        If temp Like "*水池水位*" Then
            offset = 1
            水池水位 = Cells(row, column + offset).value
        End If
'    电
'        外供电
        If temp Like "*外供电*" Then
            offset = 1
            外供电 = Cells(row, column + offset).value
        End If
'        自发电
        If temp Like "*自发电*" Then
            offset = 1
            自发电 = Cells(row, column + offset).value
        End If
'    生产备注
        If temp Like "*生产备注*" Then
            offset = 1
            生产备注 = Cells(row, column + 1).value
        End If
    Next row
    For row = 21 To 23
        column = 6
        temp = Cells(row, column).value
'        配产
        If temp Like "*天然气104m3*" Then
            offset = 1
            天然气月度配产 = Cells(row, column + offset).value
            offset = 2
            天然气年度配产 = Cells(row, column + offset).value
        End If
        If temp Like "*轻油m3*" Then
            offset = 1
            轻油月度配产 = Cells(row, column + offset).value
            offset = 2
            轻油年度配产 = Cells(row, column + offset).value
        End If
        If temp Like "*丙丁烷m3*" Then
            offset = 1
            丙丁烷月度配产 = Cells(row, column + offset).value
            offset = 2
            丙丁烷年度配产 = Cells(row, column + offset).value
        End If
    Next row
    Dim quickInputData As Object
    Set quickInputData = CreateObject("Scripting.Dictionary")
    For row = 25 To rowLimit
        column = 6
        temp = Cells(row, column).value
        If temp Like "*剩余天数*" Then
            offset = 1
            quickInputData.Add "剩余天数", Cells(row, column + offset).value
            Debug.Print "剩余天数:" & quickInputData("剩余天数")
            Exit For
        End If
    Next row

    Debug.Print "获得基本数据耗时" & DateDiff("s", t, Now) & "s!"
    
    Dim scdt As New 生产动态
    Call scdt.save
    Dim gasConsumptionTable As Object
    Set gasConsumptionTable = CreateObject("Scripting.Dictionary")
    Call getGasConsumption(日期, gasConsumptionTable)
    Call fillGasConsumptionTable(gasConsumptionTable)

    Dim s As String
    s = ";" + Chr(10)
    Dim helper As New help
'填充到 生产日报 里
'    excel 最大256列
    rowLimit = Worksheets("生产日报").Range("a65535").End(xlUp).row
    columnLimit = 9
    Dim anchor1 As Long
    Dim anchor2 As Long
    For row = 1 To rowLimit
        For column = 1 To columnLimit
            With Worksheets("生产日报")
                temp = .Cells(row, column).value
                If temp Like "*生产日报*" Then
                    offset = 1
                    .Cells(row + offset, column).value = 日期
                    Exit For
                End If
                If temp Like "*配产*完成情况*" Then
                    anchor1 = row
                    anchor2 = row + 4
                End If
                If row < anchor2 And row > anchor1 Then
                     If temp Like "*年度配产*" Then
'                     天然气万方变方
                        offset = 1
                        .Cells(row + offset, column).value = 天然气年度配产 * 10000
                        offset = 2
                        .Cells(row + offset, column).value = 轻油年度配产
                        offset = 3
                        .Cells(row + offset, column).value = 丙丁烷年度配产
                    End If
                    If temp Like "*月度配产*" Then
'                    天然气万方变方
                        offset = 1
                        .Cells(row + offset, column).value = 天然气月度配产 * 10000
                        offset = 2
                        .Cells(row + offset, column).value = 轻油月度配产
                        offset = 3
                        .Cells(row + offset, column).value = 丙丁烷月度配产
                    End If
                End If
'                配产/完成情况
                If temp Like "*天然气产量*外输*海管信息*" Then
                    anchor1 = row
                    anchor2 = row + 16
                End If
                If row < anchor2 And row > anchor1 Then
                    If temp Like "*稳定区*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 稳定区
                    End If
                    If temp Like "*入厂计量*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 入厂计量
                    End If
                    If temp Like "*JZ20-2体系*" And row < anchor1 + 6 Then
                        offset = 1
                        .Cells(row, column + offset).value = JZ202体系
                    End If
'                    If temp Like "*JZ25-1S体系*" Then
'                        offset = 1
'                        .Cells(row, column + offset).value = JZ251S体系
'                    End If
                    If temp Like "*锦天化*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 锦天化
                    End If
                    If temp Like "*精细化工104m3*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 精细化工
                    End If
                    If temp Like "*精细化工CNG104m3" Then
                        offset = 1
                        .Cells(row, column + offset).value = 精细化工CNG
                    End If
                    
                    If temp Like "*污水处理厂*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 污水处理厂
                    End If
                    If temp Like "*新奥燃气*" Then
                        offset = 2
                        .Cells(row, column + offset).value = 新奥燃气
                    End If
                    If temp Like "*自用气*" Then
                        offset = 2
                        .Cells(row, column + offset).value = 自用气
                    End If
                    If temp Like "*海管来*液含水*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 海管来液含水上午
                        offset = 2
                        .Cells(row, column + offset).value = 海管来液含水下午
                    End If
                    If temp Like "*海管MEG浓度*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 海管MEG浓度上午
                        offset = 2
                        .Cells(row, column + offset).value = 海管MEG浓度下午
                    End If
                    If temp Like "*海管出口凝点*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 海管出口凝点上午
                        offset = 2
                        .Cells(row, column + offset).value = 海管出口凝点下午
                    End If
                    If temp Like "*海管出口PH值*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 海管出口PH值上午
                        offset = 2
                        .Cells(row, column + offset).value = 海管出口PH值下午
                    End If
                    If temp Like "*海管进*出口压力*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 海管进出口压力
                    End If
                    If temp Like "*海管进*出口温度*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 海管进出口温度
                        海管通球备注 = helper.replace(海管通球备注, "[;；]", s)
                        offset = 4
                        .Cells(row + offset, column).value = 海管通球备注
                    End If
'                    If h.isMatch("海管信息", temp) Then
'                        offset = 8
'                        海管通球备注 = helper.replace(海管通球备注, "[;；]", s)
'                        .Cells(row + 8, column + 6).value = 海管通球备注
'                    End If
                End If
'                上游
                If temp Like "*JZ25-1S原油*" Then
'                    offset = 1
'                    .Cells(row, column + offset).value = JZ251S原油
                    offset = 2
                    .Cells(row, column + offset).value = JZ251S原油密度
                End If
                If temp Like "*JZ20-2凝析油*" Then
                    offset = 1
                    .Cells(row, column + offset).value = JZ202凝析油
                    offset = 2
                    .Cells(row, column + offset).value = JZ202凝析油密度
                End If
                If temp Like "*JZ20-2轻油*" Then
                    offset = 1
                    .Cells(row, column + offset).value = JZ202轻油
                    offset = 2
                    .Cells(row, column + offset).value = JZ202轻油密度
                End If
'                天然气产量/外输/海管信息
                If temp Like "*轻油产量*外输*库存*" Then
                    anchor1 = row
                    anchor2 = row + 6
                End If
                If row < anchor2 And row > anchor1 Then
                    If temp Like "*V-631A*" Then
                        offset = 1
                        .Cells(row + offset, column).value = V631A
                    End If
                    If temp Like "*V-631B*" Then
                        offset = 1
                        .Cells(row + offset, column).value = V631B
                    End If
                    If temp Like "*V-631C*" Then
                        offset = 1
                        .Cells(row + offset, column).value = V631C
                    End If
                    If temp Like "*轻油装车t*" Then
                        offset = 2
                        .Cells(row, column + offset).value = 轻油装车t
                    End If
                    If temp Like "*轻油装车m3*" Then
                        offset = 1
                        .Cells(row + offset, column).value = 轻油装车m3
                    End If
                    If temp Like "*轻油装车bbl*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 轻油装车bbl
                    End If
                    If temp Like "*外输凝点*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 外输凝点
                    End If
                    If temp Like "*外输PH值*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 外输PH值
                    End If
                    If temp Like "*饱和蒸汽压*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 饱和蒸汽压
                    End If
                    If temp Like "*轻油入罐前含水*" Then
                        offset = 1
                        .Cells(row + offset, column).value = 轻油入罐前含水
                    End If
                End If
'                丙丁烷产量/外输/库存
                If temp Like "*丙丁烷产量*外输*库存*" Then
                    anchor1 = row
                    anchor2 = row + 8
                End If
                If row < anchor2 And row > anchor1 Then
                    If temp Like "*V-641A*" Then
                        offset = 1
                        .Cells(row + offset, column).value = V641A
                    End If
                    If temp Like "*V-641B*" Then
                        offset = 1
                        .Cells(row + offset, column).value = V641B
                    End If
                    If temp Like "*V-642*" Then
                        offset = 1
                        .Cells(row + offset, column).value = V642
                    End If
                    If temp Like "*V-643A*" Then
                        offset = 1
                        .Cells(row + offset, column).value = V643A
                    End If
                    If temp Like "*V-643B*" Then
                        offset = 1
                        .Cells(row + offset, column).value = V643B
                    End If
                    If temp Like "*丙烷装车t*" Then
                        offset = 2
                        .Cells(row, column + offset).value = 丙烷装车t
                    End If
                    If temp Like "*丁烷装车t*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 丁烷装车t
                    End If
                    If temp Like "*液化气装车t*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 液化气装车t
                    End If
                    If temp Like "*数据库轻油回收*" Then
                        offset = 2
                        .Cells(row, column + offset).value = 数据库轻油回收
                    End If
                    If temp Like "*数据库丙丁烷回收*" Then
                        offset = 2
                        .Cells(row, column + offset).value = 数据库丙丁烷回收
                    End If
                End If '丙丁烷产量/外输/库存
'                物料消耗
                If temp Like "*物料接收*消耗*" Then
                    anchor1 = row
                    anchor2 = row + 9
                    offset = 8
                    生产备注 = helper.replace(生产备注, "[;；]", s)
                    .Cells(row + offset, column).value = 生产备注
                End If
                If row < anchor2 And row > anchor1 Then
                    If temp Like "*乙二醇日回收*" Then
                        offset = 2
                        .Cells(row, column + offset).value = 乙二醇生产
                    End If
                    If temp Like "*乙二醇浓度*" Then
                        offset = 2
                        .Cells(row, column + offset).value = 乙二醇浓度
                    End If
                    If temp Like "*乙二醇日耗量*" Then
                        offset = 2
                        .Cells(row, column + offset).value = 乙二醇消耗
                    End If
                    If temp Like "*甲醇日耗量*" Then
                        offset = 2
                        .Cells(row, column + offset).value = 甲醇消耗
                    End If
                    If temp Like "*外供水*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 外供水
                    End If
                    If temp Like "*自采水*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 自采水
                    End If
                    If temp Like "*水池水位*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 水池水位
                    End If
                    If temp Like "*外供电*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 外供电
                    End If
                    If temp Like "*自发电*" Then
                        offset = 1
                        .Cells(row, column + offset).value = 自发电
                    End If
                End If '物料接收/消耗
            End With
        Next column
    Next row

    Debug.Print "填写基本数据到生产日报耗时" & DateDiff("s", t, Now) & "s!"
'    获得昨日相关数据
    Call Sheets("生产日报").昨日数据_Click
    Debug.Print "获得昨日相关数据耗时" & DateDiff("s", t, Now) & "s!"
    Dim SC As New 生产日报

    Call SC.自动计算(quickInputData)
    Debug.Print "自动计算并填写生产日报数据耗时" & DateDiff("s", t, Now) & "s!"
'   非日报数据库存入数据库
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
    Dim record As New 生产信息
'    轻油比重存入数据库
    With record
        .日期 = 日期
        .名称 = "轻油比重"
        .数据 = 轻油比重
        .类别 = "轻油"
    End With
    table.Add record, ""
    Set record = Nothing
'    污水存入数据库
    With record
        .日期 = 日期
        .名称 = "污水"
        .单位 = "方"
        .数据 = 污水
        .类别 = "水"
        .状态 = "外输"
    End With
    table.Add record, ""
    Set record = Nothing
    Dim scxx As New 生产信息
    Call scxx.PushTableToDatabase(table)
    
'    Dim scdt As New 生产动态
'    Call scdt.save
    Set quickInputData = Nothing
    Worksheets("生产日报").Select
    Application.ScreenUpdating = True
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
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

'燃气消耗
Private Sub getGasConsumption(d, gasConsumptionTable)
    Err.Clear
On Error GoTo ErrorHandler
    Const MAX_热油炉 As Long = 999999
    Const MAX_火炬长明灯 As Long = 999999999
    Const MAX_火炬放空量 As Long = 999999999
    Dim SQL, SQL_suffix, name, table As String
    Dim arr, rs, data, cnn
    table = "生产信息"
    SQL_suffix = " AND 名称 IN ('热油炉','锅炉房用气','火炬长明灯','火炬放空量','FIQ-2043')"
    Dim psql As New PostgreSQL
    Dim rst As New ADODB.Recordset
    SQL = "SELECT 名称,数据 FROM " & table & " WHERE 日期='" & d & "'"
    SQL = SQL + SQL_suffix
    Set cnn = psql.cnn
'    rst.Open SQL, cnn, adOpenDynamic, adLockBatchOptimistic, adCmdTable
    rst.Open SQL, cnn
    If Not rst.BOF And Not rst.EOF Then
        rst.MoveFirst
        Do Until rst.EOF
            name = rst!名称
            data = rst!数据
            gasConsumptionTable.Add name + "日累方", data
            rst.MoveNext
        Loop
    End If
    rst.Close
    table = "生产信息"
    SQL_suffix = " AND 名称 IN ('热油炉','锅炉房用气','火炬长明灯','火炬放空量','FIQ-2043')  group by 名称"
    SQL = "SELECT 名称,sum(数据) AS 月累 FROM " & table & " WHERE 日期 BETWEEN date_trunc('month',TIMESTAMP '" & d & "') AND '" & d & "'"
    SQL = SQL + SQL_suffix
    rst.Open SQL, cnn
    If Not rst.BOF And Not rst.EOF Then
        rst.MoveFirst
        Do Until rst.EOF
            name = rst(0)
            data = rst(1)
            gasConsumptionTable.Add name + "月累方", data
            rst.MoveNext
        Loop
    End If
    rst.Close
    SQL = "SELECT 名称,sum(数据) AS 年累 FROM " & table & " WHERE 日期 BETWEEN date_trunc('year',TIMESTAMP '" & d & "') AND '" & d & "'"
    SQL = SQL + SQL_suffix
    rst.Open SQL, cnn
    If Not rst.BOF And Not rst.EOF Then
        rst.MoveFirst
        Do Until rst.EOF
            name = rst(0)
            data = rst(1)
            gasConsumptionTable.Add name + "年累方", data
            rst.MoveNext
        Loop
    End If
    rst.Close
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
                    rowLimit = row + 1
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
'                    Debug.Print temp, name, h.isMatch(name, temp)
                    If h.isMatch(name, temp) Then
                        ro = 1
                        k = name + "日累方"
                        Worksheets("生产日报").Cells(row + ro, column).value = gasConsumptionTable.item(k)
                        ro = ro + 1
                        k = name + "月累方"
                        Worksheets("生产日报").Cells(row + ro, column).value = gasConsumptionTable.item(k)
                        ro = ro + 1
                        k = name + "年累方"
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
            data.Add name, temp
        End If
        If h.isMatch("火炬放空量", temp) Then
            co = 1
            name = "火炬放空量Nm3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("火炬长明灯Nm3", temp) Then
            co = 1
            name = "火炬长明灯Nm3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("锅炉房用气Nm3", temp) Then
            co = 1
            name = "锅炉房用气Nm3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("FIQ-2043Nm3", temp) Then
            co = 1
            name = "FIQ-2043Nm3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("FIQ-5014KNm3", temp) Then
            co = 1
            name = "FIQ-5014Nm3"
            temp = Cells(row, column + co) * 1000
            data.Add name, temp
        End If
        If h.isMatch("FIQ-6102m3", temp) Then
            co = 1
            name = "FIQ-6102m3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("生产备注", temp) Then
            co = 1
            name = "生产备注"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("日自发电量kwh", temp) Then
            co = 1
            name = "日自发电量kwh"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("日外供电量kwh", temp) Then
            co = 1
            name = "日外供电量kwh"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("水池水位m", temp) Then
            co = 1
            name = "水池水位m"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("污水m3", temp) Then
            co = 1
            name = "污水m3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("自采水量m3", temp) Then
            co = 1
            name = "自采水量m3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("外供水m3", temp) Then
            co = 1
            name = "外供水m3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("甲醇日耗量m3", temp) Then
            co = 1
            name = "甲醇日耗量m3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("乙二醇日耗量m3", temp) Then
            co = 1
            name = "乙二醇日耗量m3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("乙二醇浓度", temp) Then
            co = 1
            name = "乙二醇浓度"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("乙二醇日回收量m3", temp) Then
            co = 1
            name = "乙二醇日回收量"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("数据库丙丁烷回收量m3", temp) Then
            co = 1
            name = "数据库丙丁烷回收量m3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("数据库轻油回收量m3", temp) Then
            co = 1
            name = "数据库轻油回收量m3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("液化气装车t", temp) Then
            co = 1
            name = "液化气装车t"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("丁烷装车t", temp) Then
            co = 1
            name = "丁烷装车t"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("丙烷装车t", temp) Then
            co = 1
            name = "丙烷装车t"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("V-643B", temp) Then
            co = 1
            name = "V-643Bm"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("V-643A", temp) Then
            co = 1
            name = "V-643Am"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("V-642", temp) Then
            co = 1
            name = "V-642m"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("V-641B", temp) Then
            co = 1
            name = "V-641Bm"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("V-641A", temp) Then
            co = 1
            name = "V-641Am"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("轻油比重", temp) Then
            co = 1
            name = "轻油比重"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("轻油入罐前上午/下午含水%", temp) Then
            co = 1
            name = "上午轻油入罐前含水"
            temp = Cells(row, column + co)
            data.Add name, Split(temp, "/")(0)
            name = "下午轻油入罐前含水"
            data.Add name, Split(temp, "/")(1)
        End If
        If h.isMatch("饱和蒸汽压Kpa", temp) Then
            co = 1
            name = "饱和蒸汽压Kpa"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("外输PH值", temp) Then
            co = 1
            name = "外输PH值"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("外输凝点℃", temp) Then
            co = 1
            name = "外输凝点℃"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("轻油装车bbl", temp) Then
            co = 1
            name = "轻油装车bbl"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("轻油装车m3", temp) Then
            co = 1
            name = "轻油装车m3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("轻油装车t", temp) Then
            co = 1
            name = "轻油装车t"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("V-631C", temp) Then
            co = 1
            name = "V-631Cm"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("V-631B", temp) Then
            co = 1
            name = "V-631Bm"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("V-631A", temp) Then
            co = 1
            name = "V-631Am"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("JZ20-2轻油m3", temp) Then
            co = 1
            name = "JZ20-2轻油m3"
            temp = Cells(row, column + co)
            data.Add name, temp
            co = 2
            name = "JZ20-2轻油密度kg/m3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("JZ20-2凝析油m3", temp) Then
            co = 1
            name = "JZ20-2凝析油m3"
            temp = Cells(row, column + co)
            data.Add name, temp
            co = 2
            name = "JZ20-2凝析油密度kg/m3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("JZ25-1S原油密度", temp) Then
            co = 1
            name = "JZ25-1S原油密度"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("海管通球备注", temp) Then
            co = 1
            name = "海管通球备注"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("海管进/出口温度℃", temp) Then
            co = 1
            name = "进口海管温度℃"
            temp = Cells(row, column + co)
            data.Add name, Split(temp, "/")(0)
            name = "出口海管温度℃"
            data.Add name, Split(temp, "/")(1)
        End If
        If h.isMatch("海管进/出口压力MPa", temp) Then
            co = 1
            name = "进口海管压力MPa"
            temp = Cells(row, column + co)
            data.Add name, Split(temp, "/")(0)
            name = "出口海管压力MPa"
            data.Add name, Split(temp, "/")(1)
        End If
        If h.isMatch("海管出口PH值", temp) Then
            co = 1
            name = "海管出口PH值"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("海管出口凝点℃", temp) Then
            co = 1
            name = "海管出口凝点℃"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("海管MEG浓度", temp) Then
            co = 1
            name = "海管MEG浓度"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("海管来液含水", temp) Then
            co = 1
            name = "海管来液含水"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("JZ20-2体系Nm3", temp) Then
            co = 1
            name = "JZ20-2体系Nm3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("自用气量Nm3", temp) Then
            co = 1
            name = "自用气量Nm3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("外供新奥燃气Nm3", temp) Then
            co = 1
            name = "外供新奥燃气Nm3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("外供污水处理厂Nm3", temp) Then
            co = 1
            name = "外供污水处理厂Nm3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("外供精细化工Nm3", temp) Then
            co = 1
            name = "外供精细化工Nm3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("精细化工CNGNm3", temp) Then
            co = 1
            name = "精细化工CNGNm3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("外供锦天化Nm3", temp) Then
            co = 1
            name = "外供锦天化Nm3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("入厂计量Nm3", temp) Then
            co = 1
            name = "入厂计量Nm3"
            temp = Cells(row, column + co)
            data.Add name, temp
        End If
        If h.isMatch("稳定区Nm3", temp) Then
            co = 1
            name = "稳定区Nm3"
            temp = Cells(row, column + co)
            data.Add name, temp
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
'                Debug.Print row, column, beginRow, beginColumn, lastRow, lastColumn
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
'    data("月配产天然气m3") = data("月配产天然气104m3") * 10000
'    data("年配产天然气m3") = data("年配产天然气104m3") * 10000
'    data.Remove ("月配产天然气104m3")
'    data.Remove ("年配产天然气104m3")
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
    Dim psql As New PostgreSQL
    Dim h As help
    Dim table, SQL As String
'    累计表数据转日累数据
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
'        Debug.Print name, value
    Next row
    Const MAX_fuelGas As Long = 999999
    data("热油炉") = data("FIQ-5014方") - data("昨FIQ-5014方")
    If data("热油炉") < 0 Then
       data ("热油炉") + MAX_fuelGas
    End If
    data("锅炉房用气方") = data("锅炉房用气方") - data("昨锅炉房用气方")
    data("火炬长明灯方") = data("火炬长明灯方") - data("昨火炬长明灯方")
    data("火炬放空量方") = data("火炬放空量方") - data("昨火炬放空量方")
    data.Remove ("昨FIQ-5014方")
    data.Remove ("昨锅炉房用气方")
    data.Remove ("昨火炬长明灯方")
    data.Remove ("昨火炬放空量方")
'    row = UBound(results, 1)
'    column = UBound(results, 2)
'    For Each temp In results
'        data.Add temp(0), temp(1)
'    Next temp
'    Debug.Print results
'    names2 = Array("热油炉", "锅炉房用气", "火炬放空量", "火炬长明灯", "锦天化", "精细化工", "精细化工CNG", "入厂计量", "稳定区", "污水处理厂", "新奥燃气", "自用气", "总产气量", "总外输气量", "轻油回收量", "丙丁烷回收量", "甲醇消耗", "乙二醇回收", "水消耗", "外供水", "自采水", "自发电", "电消耗", "外供电")
ErrorHandler:
        Debug.Print Err.Number & vbTab & Err.Description
        Resume Next
End Sub
Private Sub unitConvert(ByRef data As Object)
    Dim key, newKey As String
    Dim ar As Variant
    For Each key In data
        newKey = replace(key, "Nm3", "方")
        newKey = replace(key, "m3", "方")
        newKey = replace(key, "m", "米")
        newKey = replace(key, "Kwh", "度")
        newKey = replace(key, "bbl", "桶")
        newKey = replace(key, "t", "吨")
        newKey = replace(key, "MPa", "兆帕")
        newKey = replace(key, "kPa", "千帕")
        newKey = replace(key, "℃", "摄氏度")
        data.key(key) = newKey
    Next key
End Sub
