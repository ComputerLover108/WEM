VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "快速录入"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'获得基本数据
Sub getBaseData(ByRef table As Object)
    On Error GoTo ErrorHandler
    Dim 日期 As Date
    Dim 稳定区 As Long
    Dim 入厂计量 As Long
    Dim JZ202体系 As Long
'    Dim JZ251S体系 As Long
    Dim 锦天化 As Long
    Dim 精细化工 As Long
    Dim 污水处理厂 As Long
    Dim CNG As Long
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

    Dim JZ251S原油 As Double
    Dim JZ202凝析油, JZ202轻油 As Double
    Dim JZ251S原油密度, JZ202凝析油密度, JZ202轻油密度 As Double
    Dim row As Long
    Dim column As Long
    Dim lastRow As Long
    Dim lastColumn As Long
    Dim offset As Integer
    lastRow = UsedRange.Rows.count
    lastColumn = UsedRange.Columns.count
    column = 2
    Dim temp As String
    Dim h As New help
'    获得基本数据
    For row = 1 To lastRow
        temp = Cells(row, column).value
        If temp Like "*非生产日报数据*" Then
            lastRow = row - 1
            Exit For
        End If
    Next row
    For row = 1 To lastRow
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
'        锦天化
        If temp Like "*锦天化*" Then
            offset = 1
            锦天化 = Cells(row, column + offset).value
        End If
'        精细化工
        If temp Like "*精细化工*" Then
            offset = 1
            精细化工 = Cells(row, column + offset).value
        End If
'        污水处理厂
        If temp Like "*污水处理厂*" Then
            offset = 1
            污水处理厂 = Cells(row, column + offset).value
        End If
'        CNG
        If temp Like "*CNG*" Then
            offset = 1
            CNG = Cells(row, column + offset).value
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
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub
'获得配产数据
Sub getProrationData(ByRef table As Object)
    On Error GoTo ErrorHandler
    Dim temp
    Dim md, yd
    Dim row, column, beginRow, beginColumn, lastRow, lastColumn, offset
    Worksheets("快速录入").Select
    lastRow = Worksheets("快速录入").UsedRange.Rows.count
    lastColumn = Worksheets("快速录入").UsedRange.Columns.count
'    获得配产数据
    For row = 1 To lastRow
        For column = 1 To lastColumn
            temp = Cells(row, column).value
            If temp = "配产任务" Then
                beginRow = row
                beginColumn = column
            End If
        Next column
    Next row
    For row = beginRow To lastRow
        For column = beginColumn To lastColumn
            temp = Cells(row, column).value
'            Debug.Print temp
    '        配产
            If temp Like "*天然气104m3*" Then
                offset = 1
                md = Cells(row, column + offset).value
                If Not IsEmpty(md) Then
                    table.Add "天然气月配产", md
                End If
                offset = 2
                yd = Cells(row, column + offset).value
                If Not IsEmpty(md) Then
                    table.Add "天然气年配产", yd
                End If
            End If
            If temp Like "*轻油m3*" Then
                offset = 1
                md = Cells(row, column + offset).value
                If Not IsEmpty(md) Then
                    table.Add "轻油月配产", md
                End If
                offset = 2
                yd = Cells(row, column + offset).value
                If Not IsEmpty(md) Then
                    table.Add "轻油年配产", yd
                End If
            End If
            If temp Like "*丙丁烷m3*" Then
                offset = 1
                md = Cells(row, column + offset).value
                If Not IsEmpty(md) Then
                    table.Add "丙丁烷月配产", md
                End If
                offset = 2
                yd = Cells(row, column + offset).value
                If Not IsEmpty(md) Then
                    table.Add "丙丁烷年配产", yd
                End If
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

Public Sub test()
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
End Sub
