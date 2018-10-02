Option Explicit
Sub test()
    Err.Clear
On Error GoTo ErrorHandler
'    Call testData
    Dim 日期, k, v, i
    日期 = Cells(1, 3).value
    Dim gasConsumptionTable As Object
    Set gasConsumptionTable = CreateObject("Scripting.Dictionary")
    Call getGasConsumption(日期, gasConsumptionTable)
    For Each k In gasConsumptionTable.Keys
        Debug.Print k, gasConsumptionTable.item(k)
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
    For row = 25 To 28
        column = 6
        temp = Cells(row, column).value
        If temp Like "*停产天数*" Then
            offset = 1
            quickInputData.Add "停产天数", Cells(row, column + offset).value
            Debug.Print "停产天数:" & quickInputData("停产天数")
        End If
    Next row

    Debug.Print "获得基本数据耗时" & DateDiff("s", t, Now) & "s!"
    
    Dim scdt As New 生产动态
    Call scdt.save
    Dim gasConsumptionTable As Object
    Set gasConsumptionTable = CreateObject("Scripting.Dictionary")
    Call getGasConsumption(日期, gasConsumptionTable)
'    gasConsumption = Array("热油炉", "锅炉房用气", "火炬长明灯", "火炬放空量", "FIQ-2043")

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
'    columnLimit = Worksheets("生产日报").UsedRange.Columns.count
'    Dim beginRow, beginColumn, ro, co As Long
'    For row = 1 To rowLimit
'        For column = 1 To columnLimit
'        temp = Worksheets("生产日报").Cells(row, column).value
'        If "String" = TypeName(temp) Then
'            If h.isMatch("燃气消耗", temp) Then
'                beginRow = row
'                beginColumn = column
'                ro = 4
'                rowLimit = row + ro
'                co = 5
'                columnLimit = column + co
''                Debug.Print temp, h.isMatch("燃气消耗", temp), beginRow, beginColumn, rowLimit, columnLimit
'            End If
'        End If
'        Next column
'    Next row
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
    Dim SQL, SQL_suffix, name, table As String
    Dim arr, rs, data, cnn
    table = "生产信息"
    SQL_suffix = " AND 名称 IN ('热油炉','锅炉房用气','火炬长明灯','火炬放空量','FIQ-2043') ORDER BY 名称;"
    Dim psql As New PostgreSQL
    Dim rst As New ADODB.Recordset
    SQL = "SELECT 名称,数据 FROM " & table & " WHERE 日期='" & d & "'"
    SQL = SQL + SQL_suffix
    Set cnn = psql.cnn
'    Set rst = psql.cnn.Execute(SQL)
'    rst.Open SQL, cnn, adOpenDynamic, adLockBatchOptimistic, adCmdTable
    rst.Open SQL, cnn
    rst.MoveFirst
    While Not rst.EOF Or rst.BOF
        name = rst!名称
        data = rst!数据
        gasConsumptionTable.Add name + "日累方", data
        rst.MoveNext
    Wend
    SQL = "SELECT 名称,sum(数据) AS 月累 FROM " & table & " WHERE 日期 BETWEEN date_trunc('month',TIMESTAMP '" & d & "') AND '" & d & "')"
    rst.MoveFirst
    While Not rst.EOF Or rst.BOF
        name = rst(0)
        data = rst(1)
        gasConsumptionTable.Add name + "月累方", data
        rst.MoveNext
    Wend
    SQL = "SELECT 名称,sum(数据) AS 年累 FROM " & table & " WHERE 日期 BETWEEN date_trunc('year',TIMESTAMP '" & d & "') AND '" & d & "')"
    rst.MoveFirst
    While Not rst.EOF Or rst.BOF
        name = rst(0)
        data = rst(1)
        gasConsumptionTable.Add name + "年累方", data
        rst.MoveNext
    Wend
    rst.Close
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
'数据填入生产日报
Private Sub fillProductionDaily()

End Sub


