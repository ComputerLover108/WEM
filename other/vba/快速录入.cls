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
    Dim row As Long
    Dim column As Long
    Dim lastRow As Long
    Dim lastColumn As Long
    Dim offset As Integer
    Worksheets("快速录入").Select
    lastRow = Worksheets("快速录入").UsedRange.Rows.count
    lastColumn = Worksheets("快速录入").UsedRange.Columns.count
    column = 2
    Dim temp As String
    Dim data
    Dim h As New help
'    获得基本数据
    For row = 1 To lastRow
        temp = Cells(row, column).value
'        日期
        If temp Like "*日期*" Then
            offset = 1
            If isempty(Cells(row, column + offset).value) Or IsNull(Cells(row, column + offset).value) Then
                MsgBox prompt:="没有填写日期！请重新填写！", Buttons:=vbOKOnly
                Exit Sub
            End If
            data = datevalue(Cells(row, column + offset).value)
            If Not isempty(data) Then
                table.add "日期", data
            End If
        End If
'        天然气
'        稳定区
        If temp Like "*稳定区*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "稳定区", data
            End If
        End If
'        入厂厂计量
        If temp Like "*入厂计量*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "入厂计量", data
            End If
        End If
'        JZ20-2体系
        If temp Like "*JZ20-2体系*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "JZ20-2体系", data
            End If
        End If
'        锦天化
        If temp Like "*锦天化*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "锦天化", data
            End If
        End If
'        精细化工
        If temp Like "*精细化工*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "精细化工", data
            End If
        End If
'        污水处理厂
        If temp Like "*污水处理厂*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "污水处理厂", data
            End If
        End If
'        CNG
        If temp Like "*CNG*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "CNG", data
            End If
        End If
'        新奥燃气
        If temp Like "*新奥燃气*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "新奥燃气", data
            End If
        End If
'        自用气
        If temp Like "*自用气*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "自用气", data
            End If
        End If
'    海管
'        海管来液含水
        If temp Like "*海管来液含水*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "海管来液含水上午", data
            End If
            offset = 2
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "海管来液含水下午", data
            End If
        End If
'        海管MEG浓度
        If temp Like "*海管MEG浓度*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "海管MEG浓度上午", data
            End If
            offset = 2
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "海管MEG浓度下午", data
            End If
        End If
'        海管出口凝点
        If temp Like "*海管出口凝点*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "海管出口凝点上午", data
            End If
            offset = 2
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "海管出口凝点下午", data
            End If
        End If
'        海管出口PH值
        If temp Like "*海管出口PH值*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "海管出口PH值上午", data
            End If
            offset = 2
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "海管出口PH值下午", data
            End If
        End If
'        海管进出口压力
        If temp Like "*海管进*出口压力*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "海管进出口压力", data
            End If
        End If
'        海管进出口温度
        If temp Like "*海管进*出口温度*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "海管进出口温度", data
            End If
        End If
'        海管通球备注
        If temp Like "*海管通球备注*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "海管通球备注", data
            End If
        End If
'    上游
'        JZ25-1S原油
        If temp Like "*JZ25-1S原油*" Then
'            offset = 1
'            JZ251S原油 = Cells(row, column + offset).value
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "JZ25-1S原油密度", data
            End If
        End If
'        JZ20-2凝析油
        If temp Like "*JZ20-2凝析油*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "JZ20-2凝析油", data
            End If
            offset = 2
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "JZ20-2凝析油密度", data
            End If
        End If
'        JZ20-2轻油
        If temp Like "*JZ20-2轻油*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "JZ20-2轻油", data
            End If
            offset = 2
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "JZ20-2轻油密度", data
            End If
        End If
'    轻油
'        V-631A
        If temp Like "*V-631A*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "V-631A", data
            End If
        End If
'        V-631B
        If temp Like "*V-631B*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "V-631B", data
            End If
        End If
'        V-631C
        If temp Like "*V-631C*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "V-631C", data
            End If
        End If
'        轻油装车t
        If temp Like "*轻油装车t*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "轻油装车t", data
            End If
        End If
'        轻油装车m3
        If temp Like "*轻油装车m3*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "轻油装车m3", data
            End If
        End If
'        轻油装车bbl
        If temp Like "*轻油装车bbl*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "轻油装车bbl", data
            End If
        End If
'        外输凝点
        If temp Like "*外输凝点*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "外输凝点", data
            End If
        End If
'        外输PH值
        If temp Like "*外输PH值*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "外输PH值", data
            End If
        End If
'        轻油入罐前含水
        If temp Like "*轻油入罐前*含水*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "轻油入罐前含水", data
            End If
        End If
'        饱和蒸汽压
        If temp Like "*饱和蒸汽压*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "饱和蒸汽压", data
            End If
        End If
'        轻油比重
        If temp Like "*轻油比重*" Then
            offset = 1
'            If 0 = 轻油比重 Then
'                MsgBox ("没有填写轻油比重或填写错误!")
'                Exit Sub
'            End If
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "轻油密度", data
            End If
        End If
'    丙丁烷
'        V-641A
        If temp Like "*V-641A*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "V-641A", data
            End If
        End If
'        V641B
        If temp Like "*V-641B*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "V-641B", data
            End If
        End If
'        V-642
        If temp Like "*V-642*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "V-642", data
            End If
        End If
'        V-643A
        If temp Like "*V-643A*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "V-643A", data
            End If
        End If
'        V-643B
        If temp Like "*V-643B*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "V-643B", data
            End If
        End If
'        丙烷装车t
        If temp Like "*丙烷装车t*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "丙烷装车t", data
            End If
        End If
'        丁烷装车t
        If temp Like "*丁烷装车t*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "丁烷装车t", data
            End If
        End If
'        液化气装车t
        If temp Like "*液化气装车t*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "液化气装车t", data
            End If
        End If
'    数据库
'        数据库轻油回收
        If temp Like "*数据库轻油回收*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "数据库轻油回收", data
            End If
        End If
'        数据库丙丁烷回收
        If temp Like "*数据库丙丁烷回收*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "数据库丙丁烷回收", data
            End If
        End If
'    化学药剂
'        乙二醇回收
        If temp Like "*乙二醇日回收量*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "乙二醇回收", data
            End If
        End If
'        乙二醇浓度
        If temp Like "*乙二醇浓度*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "乙二醇浓度", data
            End If
        End If
'        乙二醇消耗
        If temp Like "*乙二醇日耗量*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "乙二醇消耗", data
            End If
        End If
'        甲醇消耗
        If temp Like "*甲醇日耗量*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "甲醇消耗", data
            End If
        End If
'    水
'        外供水
        If temp Like "*外供水*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "外供水", data
            End If
        End If
'        自采水
        If temp Like "*自采水*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "自采水", data
            End If
        End If
'        污水
        If temp Like "*污水m3" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "污水", data
            End If
        End If
'        水池水位
        If temp Like "*水池水位*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "水池水位", data
            End If
        End If
'    电
'        外供电
        If temp Like "*外供电*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "外供电", data
            End If
        End If
'        自发电
        If temp Like "*自发电*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "自发电", data
            End If
        End If
'    生产备注
        If temp Like "*生产备注*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not isempty(data) Then
                table.add "生产备注", data
            End If
        End If
    Next row
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
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
                If Not isempty(md) Then
                    table.add "天然气月配产", md
                End If
                offset = 2
                yd = Cells(row, column + offset).value
                If Not isempty(md) Then
                    table.add "天然气年配产", yd
                End If
            End If
            If temp Like "*轻油m3*" Then
                offset = 1
                md = Cells(row, column + offset).value
                If Not isempty(md) Then
                    table.add "轻油月配产", md
                End If
                offset = 2
                yd = Cells(row, column + offset).value
                If Not isempty(md) Then
                    table.add "轻油年配产", yd
                End If
            End If
            If temp Like "*丙丁烷m3*" Then
                offset = 1
                md = Cells(row, column + offset).value
                If Not isempty(md) Then
                    table.add "丙丁烷月配产", md
                End If
                offset = 2
                yd = Cells(row, column + offset).value
                If Not isempty(md) Then
                    table.add "丙丁烷年配产", yd
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
'获得昨日相关数据
Public Sub getRelatedData(ByRef table As Object, ByRef ts As Object)
    On Error GoTo ErrorHandler
    Dim 今天, 昨天 As Date
    今天 = table("日期")
    昨天 = DateAdd("d", -1, 今天)
    If isempty(今天) Then
        MsgBox ("没有填写日期！")
        Exit Sub
    End If
    Dim 月初, 年初 As Date
    月初 = DateSerial(Year(今天), month(今天), 1)
    年初 = DateSerial(Year(今天), 1, 1)
    Dim tableName, SQL, filter, filterM, filterY As String
    tableName = "生产信息"
    Dim psql As New PostgreSQL
    filterM = "日期 between '" & 月初 & "' and '" & 昨天 & "' "
    filterY = "日期 between '" & 年初 & "' and '" & 昨天 & "' "
    showFields = "sum(数据) "
    Dim name, dataM, dataY
    Dim key
    For Each key In table.keys
        If ts.exists(key) Then
            data = table(key)
            SQL = "SELECT " & showFields & " FROM " & tableName & " WHERE " & filterM & " and 名称='" & key & "' ;"
'            Debug.Print (SQL)
            name = key & "昨月累"
            dataM = psql.cnn.Execute(SQL)(0)
            If IsNull(dataM) Then
                dataM = 0
            End If
            table.add name, dataM
            SQL = "SELECT " & showFields & " FROM " & tableName & " WHERE " & filterY & " and 名称='" & key & "' ;"
'            Debug.Print (SQL)
            name = key & "昨年累"
            dataY = psql.cnn.Execute(SQL)(0)
            If IsNull(dataY) Then
                dataY = 0
            End If
            table.add name, dataY
'            Debug.Print 昨天, key, dataM, dataY
        End If
    Next key

    Dim ar, x, d
    ar = Array("轻油库存合计", "轻烃库存", "库存水")
    showFields = "数据"
    For Each x In ar
        d = "吨"
        name = "昨" & x & "t"
        If x = "库存水" Then
            d = "方"
            name = "昨" & x & "m3"
        End If
        filter = "日期 = '" & 昨天 & "' and 单位='" & d & "' and 名称='" & x & "' ;"
        SQL = "SELECT " & showFields & " FROM " & tableName & " WHERE " & filter
        data = psql.cnn.Execute(SQL)(0)
'        Debug.Print name, data, SQL
        table.add name, data
    Next x
    
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
'获得推导数据
Public Sub getDerivedData(ByRef table As Object, ByRef ts As Object)
    On Error GoTo ErrorHandler
    Dim today As Date
    today = table("日期")
    If isempty(today) Then
        MsgBox ("没有填写日期！")
        Exit Sub
    End If
    Dim monthHead, yearHead As Date
    monthHead = DateSerial(Year(today), month(today), 1)
    yearHead = DateSerial(Year(today), 1, 1)
    
    Dim key, data, dataM, dataY, name, temp, dataT
    name = "总外输气量"
    data = table("锦天化") + table("精细化工") + table("污水处理厂") + table("CNG") + table("新奥燃气")
    table.add name, data
    
    name = "年时间进度比"
    Dim lastYearEnd, yearEnd As Date
    lastYearEnd = DateAdd("d", -1, yearHead)
    yearEnd = DateAdd("yyyy", 1, lastYearEnd)
    data = DateDiff("d", today, lastYearEnd) / DateDiff("d", yearEnd, lastYearEnd) * 100
    table.add name, data
        
'    [轻油回收量t] = [轻油库存合计t] + [轻油装车t] - 昨轻油库存合计t
'
'    [丙丁烷回收量t] = [轻烃库存t] + [丙烷装车t] + [丁烷装车t] + [液化气装车t] - 昨轻烃库存
'
'    [水消耗数据] = 昨库存水 + [外供水数据] + [自采水数据] - [库存水]
    For Each key In table.keys
        If ts.exists(key) Then
            '月累
            name = key & "月累"
            data = table(key)
            temp = key & "昨月累"
            dataT = table(temp)
            If today = monthHead Then
                dataM = data
            Else
                dataM = data + dataT
            End If
            table.add name, dataM
            '年累
            name = key & "年累"
            data = table(key)
            temp = key & "昨年累"
            dataT = table(temp)
            If today = yearHead Then
                dataY = data
            Else
                dataY = data + dataT
            End If
            table.add name, dataY
'            Debug.Print today, key, data, dataM, dataY
        End If
    Next key
'    temp = ([天然气年度配产] - [总外输气量年累]) / 剩余天数
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
'有月累年累记录
Public Sub maySum(ByRef ts As Object)
    On Error GoTo ErrorHandler
    ' 上游
    ts.add "JZ20-2体系", ""
    ts.add "JZ25-1S体系", ""
    ts.add "JZ20-2凝析油", ""
    ts.add "JZ20-2轻油", ""
    ' 气
    ts.add "稳定区", ""
    ts.add "入厂计量", ""
    ts.add "总外输气量", ""
    ts.add "总产气量", ""
    ts.add "锦天化", ""
    ts.add "精细化工", ""
    ts.add "污水处理厂", ""
    ts.add "CNG", ""
    ts.add "新奥燃气", ""
    ts.add "自用气", ""
    ' 油
    ts.add "轻油回收量", ""
    ' 轻烃
    ts.add "丙丁烷回收量", ""
    ' 化学药剂
    ts.add "甲醇消耗", ""
    ts.add "乙二醇消耗", ""
    ts.add "乙二醇回收", ""
    ' 水
    ts.add "外供水", ""
    ts.add "自采水", ""
    ts.add "水消耗", ""
    ' 电
    ts.add "外供电", ""
    ts.add "电消耗", ""
    ts.add "自发电", ""
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub


