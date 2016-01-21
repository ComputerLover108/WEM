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
            If IsEmpty(Cells(row, column + offset).value) Or IsNull(Cells(row, column + offset).value) Then
                MsgBox prompt:="没有填写日期！请重新填写！", Buttons:=vbOKOnly
                Exit Sub
            End If
            data = datevalue(Cells(row, column + offset).value)
            If Not IsEmpty(data) Then
                table.add "日期", data
            End If
        End If
'        天然气
'        稳定区
        If temp Like "*稳定区*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "稳定区", data
            End If
        End If
'        入厂厂计量
        If temp Like "*入厂计量*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "入厂计量", data
            End If
        End If
'        JZ20-2体系
        If temp Like "*JZ20-2体系*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "JZ20-2体系", data
            End If
        End If
'        锦天化
        If temp Like "*锦天化*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "锦天化", data
            End If
        End If
'        精细化工
        If temp Like "*精细化工*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "精细化工", data
            End If
        End If
'        污水处理厂
        If temp Like "*污水处理厂*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "污水处理厂", data
            End If
        End If
'        CNG
        If temp Like "*CNG*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "CNG", data
            End If
        End If
'        新奥燃气
        If temp Like "*新奥燃气*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "新奥燃气", data
            End If
        End If
'        自用气
        If temp Like "*自用气*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "自用气", data
            End If
        End If
'    海管
'        海管来液含水
        If temp Like "*海管来液含水*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "海管来液含水上午", data
            End If
            offset = 2
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "海管来液含水下午", data
            End If
        End If
'        海管MEG浓度
        If temp Like "*海管MEG浓度*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "海管MEG浓度上午", data
            End If
            offset = 2
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "海管MEG浓度下午", data
            End If
        End If
'        海管出口凝点
        If temp Like "*海管出口凝点*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "海管出口凝点上午", data
            End If
            offset = 2
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "海管出口凝点下午", data
            End If
        End If
'        海管出口PH值
        If temp Like "*海管出口PH值*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "海管出口PH值上午", data
            End If
            offset = 2
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "海管出口PH值下午", data
            End If
        End If
'        海管进出口压力
        If temp Like "*海管进*出口压力*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "海管进出口压力", data
            End If
        End If
'        海管进出口温度
        If temp Like "*海管进*出口温度*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "海管进出口温度", data
            End If
        End If
'        海管通球备注
        If temp Like "*海管通球备注*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "海管通球备注", data
            End If
        End If
'    上游
'        JZ25-1S原油
        If temp Like "*JZ25-1S原油*" Then
'            offset = 1
'            JZ251S原油 = Cells(row,column + offset).value
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "JZ25-1S原油密度", data
            End If
        End If
'        JZ20-2凝析油
        If temp Like "*JZ20-2凝析油*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "JZ20-2凝析油", data
            End If
            offset = 2
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "JZ20-2凝析油密度", data
            End If
        End If
'        JZ20-2轻油
        If temp Like "*JZ20-2轻油*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "JZ20-2轻油", data
            End If
            offset = 2
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "JZ20-2轻油密度", data
            End If
        End If
'    轻油
'        V-631A
        If temp Like "*V-631A*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "V-631A", data
            End If
        End If
'        V-631B
        If temp Like "*V-631B*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "V-631B", data
            End If
        End If
'        V-631C
        If temp Like "*V-631C*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "V-631C", data
            End If
        End If
'        轻油装车t
        If temp Like "*轻油装车t*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "轻油装车t", data
            End If
        End If
'        轻油装车m3
        If temp Like "*轻油装车m3*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "轻油装车m3", data
            End If
        End If
'        轻油装车bbl
        If temp Like "*轻油装车bbl*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "轻油装车bbl", data
            End If
        End If
'        外输凝点
        If temp Like "*外输凝点*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "外输凝点", data
            End If
        End If
'        外输PH值
        If temp Like "*外输PH值*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "外输PH值", data
            End If
        End If
'        轻油入罐前含水
        If temp Like "*轻油入罐前*含水*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "轻油入罐前含水", data
            End If
        End If
'        饱和蒸汽压
        If temp Like "*饱和蒸汽压*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
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
            If Not IsEmpty(data) Then
                table.add "轻油密度", data
            End If
        End If
'    丙丁烷
'        V-641A
        If temp Like "*V-641A*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "V-641A", data
            End If
        End If
'        V641B
        If temp Like "*V-641B*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "V-641B", data
            End If
        End If
'        V-642
        If temp Like "*V-642*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "V-642", data
            End If
        End If
'        V-643A
        If temp Like "*V-643A*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "V-643A", data
            End If
        End If
'        V-643B
        If temp Like "*V-643B*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "V-643B", data
            End If
        End If
'        丙烷装车t
        If temp Like "*丙烷装车t*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "丙烷装车t", data
            End If
        End If
'        丁烷装车t
        If temp Like "*丁烷装车t*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "丁烷装车t", data
            End If
        End If
'        液化气装车t
        If temp Like "*液化气装车t*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "液化气装车t", data
            End If
        End If
'    数据库
'        数据库轻油回收
        If temp Like "*数据库轻油回收*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "数据库轻油回收", data
            End If
        End If
'        数据库丙丁烷回收
        If temp Like "*数据库丙丁烷回收*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "数据库丙丁烷回收", data
            End If
        End If
'    化学药剂
'        乙二醇回收
        If temp Like "*乙二醇日回收量*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "乙二醇回收", data
            End If
        End If
'        乙二醇浓度
        If temp Like "*乙二醇浓度*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "乙二醇浓度", data
            End If
        End If
'        乙二醇消耗
        If temp Like "*乙二醇日耗量*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "乙二醇消耗", data
            End If
        End If
'        甲醇消耗
        If temp Like "*甲醇日耗量*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "甲醇消耗", data
            End If
        End If
'    水
'        外供水
        If temp Like "*外供水*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "外供水", data
            End If
        End If
'        自采水
        If temp Like "*自采水*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "自采水", data
            End If
        End If
'        污水
        If temp Like "*污水m3" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "污水", data
            End If
        End If
'        水池水位
        If temp Like "*水池水位*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "水池水位", data
            End If
        End If
'    电
'        外供电
        If temp Like "*外供电*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "外供电", data
            End If
        End If
'        自发电
        If temp Like "*自发电*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
                table.add "自发电", data
            End If
        End If
'    生产备注
        If temp Like "*生产备注*" Then
            offset = 1
            data = Cells(row, column + offset).value
            If Not IsEmpty(data) Then
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
                If Not IsEmpty(md) Then
                    table.add "天然气月配产", md
                End If
                offset = 2
                yd = Cells(row, column + offset).value
                If Not IsEmpty(md) Then
                    table.add "天然气年配产", yd
                End If
            End If
            If temp Like "*轻油m3*" Then
                offset = 1
                md = Cells(row, column + offset).value
                If Not IsEmpty(md) Then
                    table.add "轻油月配产", md
                End If
                offset = 2
                yd = Cells(row, column + offset).value
                If Not IsEmpty(md) Then
                    table.add "轻油年配产", yd
                End If
            End If
            If temp Like "*丙丁烷m3*" Then
                offset = 1
                md = Cells(row, column + offset).value
                If Not IsEmpty(md) Then
                    table.add "丙丁烷月配产", md
                End If
                offset = 2
                yd = Cells(row, column + offset).value
                If Not IsEmpty(md) Then
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
'获得轻烃密度
Sub getLightHydrocarbonDensity(ByRef table As Object)
    On Error GoTo ErrorHandler
    Dim temp, name, data
    Dim row, column, beginRow, beginColumn, lastRow, lastColumn, offset
    Worksheets("快速录入").Select
    lastRow = Worksheets("快速录入").UsedRange.Rows.count
    lastColumn = Worksheets("快速录入").UsedRange.Columns.count
    For row = 1 To lastRow
        For column = 1 To lastColumn
            temp = Cells(row, column).value
            If temp Like "轻烃密度*" Then
                beginRow = row
                beginColumn = column
                Exit For
            End If
        Next column
    Next row
    For row = beginRow To lastRow
        For column = beginColumn To lastColumn
            temp = Cells(row, column).value
'            Debug.Print temp
            If temp Like "V-64*" Then
                offset = 1
                name = temp & "密度"
                data = Cells(row + offset, column).value
                If Not IsEmpty(data) Then
                    table.add name, data
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
    If IsEmpty(今天) Then
        MsgBox ("没有填写日期！")
        Exit Sub
    End If
    Dim 月初, 年初 As Date
    月初 = DateSerial(Year(今天), month(今天), 1)
    年初 = DateSerial(Year(今天), 1, 1)
    Dim tableName, SQL, filter, filterM, filterY, filterU, unit As String
    tableName = "生产信息"
    Dim psql As New PostgreSQL
    filterM = "日期 between '" & 月初 & "' and '" & 昨天 & "' "
    filterY = "日期 between '" & 年初 & "' and '" & 昨天 & "' "
    filterU = " AND 单位 = '" & unit & "' "
    showFields = "sum(数据) "
    Dim name, dataM, dataY
    Dim key
    For Each key In ts.keys
        unit = "方"
        If key Like "*电*" Then
            unit = "度"
        End If
        filterU = " AND 单位 = '" & unit & "'"
'        data = table(key)
        SQL = "SELECT " & showFields & " FROM " & tableName & " WHERE " & filterM & filterU & " and 名称='" & key & "' ;"
'       Debug.Print (SQL)
        name = key & "昨月累"
        dataM = psql.cnn.Execute(SQL)(0)
        If IsNull(dataM) Then
            dataM = 0
        End If
        table.add name, dataM
        SQL = "SELECT " & showFields & " FROM " & tableName & " WHERE " & filterY & filterU & " and 名称='" & key & "' ;"
'        Debug.Print (SQL)
        name = key & "昨年累"
        dataY = psql.cnn.Execute(SQL)(0)
        If IsNull(dataY) Then
            dataY = 0
        End If
        table.add name, dataY
    Next key
    Dim ar, x, d
    ar = Array("轻油库存", "轻烃库存", "水库存")
    showFields = "数据"
    For Each x In ar
        d = "吨"
        name = "昨" & x & "t"
        If x = "水库存" Then
            d = "方"
            name = "昨" & x & "m3"
        End If
        filter = "日期 = '" & 昨天 & "' and 单位='" & d & "' and 名称='" & x & "' ;"
        SQL = "SELECT " & showFields & " FROM " & tableName & " WHERE " & filter
        data = psql.cnn.Execute(SQL)(0)
'        Debug.Print name,data,SQL
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
    If IsEmpty(today) Then
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
    Dim lastYearEnd, YearEnd As Date
    lastYearEnd = DateAdd("d", -1, yearHead)
    YearEnd = DateAdd("yyyy", 1, lastYearEnd)
    data = DateDiff("d", today, lastYearEnd) / DateDiff("d", YearEnd, lastYearEnd) * 100
    table.add name, data
    
    Call getRelatedData(table, ts)
    Call getLightHydrocarbonDensity(table)
    'V-631A/B/C 直径14.5米
    'V-641A/B,V-642,V-643A/B 直径12.3米
    'V-712A/B 直径29.75米
    '轻油密度按0.739算
    Dim ar, x, dataV, dataW, diameter, height, density
    ar = Array("V-631A", "V-631B", "V-631C", "V-641A", "V-641B", "V-642", "V-643A", "V-643B", "V-712A", "V-712B")
    Dim PI
    PI = Application.PI()
    For Each x In ar
        If table.exists(x) Then
            height = table(x)
            If x Like "V-631*" Then
                diameter = 14.5
                density = 0.739
                name = x & "库存m3"
                dataV = PI * diameter * diameter * height / 4
                table.add name, dataV
            End If
            If x Like "V-64*" Then
                diameter = 12.3
                name = x & "库存m3"
                dataV = PI * height * height * (3 * diameter / 2 - height)
                table.add name, dataV
                temp = x & "密度"
                density = table(temp)
            End If
            If x Like "V-712*" Then
                diameter = 29.75
                name = x & "库存m3"
                dataV = PI * diameter * diameter * height / 4
                table.add name, dataV
                density = 1
            End If
            name = x & "库存t"
            dataW = dataV * density
            table.add name, dataW
        End If
    Next x
    name = "轻油库存m3"
    data = table("V-631A库存m3") + table("V-631B库存m3") + table("V-631C库存m3")
    table.add name, data
    name = "轻油库存t"
    data = table("V-631A库存t") + table("V-631B库存t") + table("V-631C库存t")
    table.add name, data
    name = "轻油回收量t"
    data = table("轻油库存t") + table("轻油装车t") - table("昨轻油库存t")
    table.add name, data
    name = "轻油回收量m3"
    data = table("轻油回收量t") / table("轻油密度")
    table.add name, data
    '估计轻油处理量m3比轻油回收量m3多25m3
    Const OIL_balance = 25
    name = "轻油处理量m3"
    data = table("轻油回收量m3") + OIL_balance
    table.add name, data
    name = "丙烷库存m3"
    data = table("V-641A库存m3") + table("V-641B库存m3")
    table.add name, data
    name = "丙烷库存t"
    data = table("V-641A库存t") + table("V-641B库存t")
    table.add name, data
    name = "丁烷库存m3"
    data = table("V-642库存m3") + table("V-643A库存m3")
    table.add name, data
    name = "丁烷库存t"
    data = table("V-642库存t") + table("V-643A库存t")
    table.add name, data
    name = "液化气库存m3"
    data = table("V-643B库存m3")
    table.add name, data
    name = "液化气库存t"
    data = table("V-643B库存t")
    table.add name, data
    name = "轻烃库存m3"
    data = table("丙烷库存m3") + table("丁烷库存m3") + table("液化气库存m3")
    table.add name, data
    name = "轻烃库存t"
    data = table("丙烷库存t") + table("丁烷库存t") + table("液化气库存t")
    table.add name, data
    name = "丙烷回收量t"
    data = table("丙烷库存t") + table("丙烷装车t") - table("昨丙烷库存t")
    table.add name, data
    name = "丁烷回收量t"
    data = table("丁烷库存t") + table("丁烷装车t") - table("昨丁烷库存t")
    table.add name, data
    name = "液化气回收量t"
    data = table("液化气库存t") + table("液化气装车t") - table("昨液化气库存t")
    table.add name, data
    name = "丙丁烷回收量t"
    data = table("轻烃库存t") + table("丙烷装车t") + table("丁烷装车t") + table("液化气装车t") - table("昨轻烃库存t")
    table.add name, data

    '轻烃密度按0.54 10*3*kg/m3算
    density = 0.54
    name = "丙丁烷回收量m3"
    data = table("丙丁烷回收量t") / density
    table.add name, data
    '丙烷密度按V-641A，丁烷密度按V-642，液化气密度按V-643B*算
    丙烷密度 = table("V-641A密度")
    丁烷密度 = table("V-642密度")
    液化气密度 = table("V-643B密度")
    name = "丙烷装车m3"
    data = table("丙烷装车t") / 丙烷密度
    table.add name, data
    name = "丁烷装车m3"
    data = table("丁烷装车t") / 丁烷密度
    table.add name, data
    name = "液化气装车m3"
    data = table("液化气装车t") / 液化气密度
    table.add name, data
    
'    [水消耗数据] = 昨库存水 + [外供水数据] + [自采水数据] - [库存水]
    name = "水库存m3"
'    data = table("V-712A") + table("V-712B")
    Const WATER_balance = 1390
    data = table("水池水位") * WATER_balance
    table.add name, data
    name = "水消耗"
    data = table("昨水库存m3") + table("外供水") + table("自采水") - table("水库存m3")
    table.add name, data
    name = "电消耗"
    data = table("外供电") + table("自发电")
    table.add name, data
    For Each key In ts.keys
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
'        Debug.Print today, key, data, dataM, dataY
    Next key

ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    Else
        Debug.Print Err.Number, Err.Description, name, data
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
'填写生产日报
Public Sub FillDailyProduction(ByRef table As Object)
    On Error GoTo ErrorHandler
    Const Title = "葫芦岛天然气终端厂生产日报"
    Dim temp, name, data
    Dim row, column, beginRow, beginColumn, lastRow, lastColumn, offset, anchor1, anchor2
    Worksheets("生产日报").Select
    beginRow = 1
    beginColumn = 1
    lastRow = Worksheets("生产日报").UsedRange.Rows.count
    lastColumn = Worksheets("生产日报").UsedRange.Columns.count
    For row = beginRow To lastRow
        For column = beginColumn To lastColumn
            temp = Cells(row, column).value
            If temp = Title Then
                offset = 1
                Cells(row + offset, column) = table("日期")
                Exit For
            End If
            If temp Like "*配产*完成情况*" Then
                anchor1 = row
                anchor2 = row + 4
            End If
            If row < anchor2 And row > anchor1 Then
                 If temp Like "*年时间*进度比*" Then
                    offset = 1
                    Cells(row + offset, column) = table("年时间进度比")
                    offset = 2
                    Cells(row + offset, column) = table("年时间进度比")
                    offset = 3
                    Cells(row + offset, column) = table("年时间进度比")
                 End If
                 If temp Like "*年度配产*" Then
'                     天然气万方变方
                    offset = 1
                    Cells(row + offset, column).value = table("天然气年配产") * 10000
                    offset = 2
                    Cells(row + offset, column).value = table("轻油年配产")
                    offset = 3
                    Cells(row + offset, column).value = table("丙丁烷年配产")
                 End If
                 If temp Like "*年度累计*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("总外输气量年累")
                    offset = 2
                    Cells(row + offset, column).value = table("轻油回收量年累")
                    offset = 3
                    Cells(row + offset, column).value = table("丙丁烷回收量年累")
                 End If
                 If temp Like "*年度完成率*" Then
                    offset = 1
                    Cells(row + offset, column) = table("总外输气量年累") / (table("天然气年配产") * 10000)
                    offset = 2
                    Cells(row + offset, column) = table("轻油回收量年累") / table("轻油年配产")
                    offset = 3
                    Cells(row + offset, column) = table("丙丁烷回收量年累") / table("丙丁烷年配产")
                 End If
                 If temp Like "*今后需日产*" Then
                    Dim remainDay, YearEnd, today
                    today = table("日期")
                    YearEnd = DateSerial(Year(today), 12, 31)
                    remainDay = DateDiff("d", YearEnd, today)
                    offset = 1
                    Cells(row + offset, column).value = (table("天然气年配产") * 10000 - table("总外输气量年累")) / remainDay
                    offset = 2
                    Cells(row + offset, column).value = (table("轻油年配产") - table("轻油回收量年累")) / remainDay
                    offset = 3
                    Cells(row + offset, column).value = (table("丙丁烷年配产") * 10000 - table("丙丁烷回收量年累")) / remainDay
                 End If
                If temp Like "*月度配产*" Then
'                    天然气万方变方
                    offset = 1
                    Cells(row + offset, column).value = table("天然气月配产") * 10000
                    offset = 2
                    Cells(row + offset, column).value = table("轻油月配产")
                    offset = 3
                    Cells(row + offset, column).value = table("丙丁烷月配产")
                End If
                 If temp Like "*月度累计*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("总外输气量月累")
                    offset = 2
                    Cells(row + offset, column).value = table("轻油回收量月累")
                    offset = 3
                    Cells(row + offset, column).value = table("丙丁烷回收量月累")
                 End If
                 If temp Like "*月度完成率*" Then
                    offset = 1
                    Cells(row + offset, column) = table("总外输气量月累") / (table("天然气月配产") * 10000)
                    offset = 2
                    Cells(row + offset, column) = table("轻油回收量月累") / table("轻油月配产")
                    offset = 3
                    Cells(row + offset, column) = table("丙丁烷回收量月累") / table("丙丁烷月配产")
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
                    Cells(row, column + offset).value = table("稳定区")
                    offset = 3
                    Cells(row, column + offset).value = table("稳定区月累")
                    offset = 4
                    Cells(row, column + offset).value = table("稳定区年累")
                End If
                If temp Like "*入厂计量*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("入厂计量")
                    offset = 3
                    Cells(row, column + offset).value = table("入厂计量月累")
                    offset = 4
                    Cells(row, column + offset).value = table("入厂计量年累")
                End If
                If temp Like "*JZ20-2体系*" And row < anchor1 + 6 Then
                    offset = 1
                    Cells(row, column + offset).value = JZ202体系
                End If
'                    If temp Like "*JZ25-1S体系*" Then
'                        offset = 1
'                        cells(row,column + offset).value = JZ251S体系
'                    End If
                If temp Like "*锦天化*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("锦天化")
                    offset = 4
                    Cells(row, column + offset).value = table("锦天化月累")
                    offset = 5
                    Cells(row, column + offset).value = table("锦天化年累")
                End If
                If temp Like "*精细化工*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("精细化工")
                    offset = 4
                    Cells(row, column + offset).value = table("精细化工月累")
                    offset = 5
                    Cells(row, column + offset).value = table("精细化工年累")
                End If
                If temp Like "*污水处理厂*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("污水处理厂")
                    offset = 4
                    Cells(row, column + offset).value = table("污水处理厂月累")
                    offset = 5
                    Cells(row, column + offset).value = table("污水处理厂年累")
                End If
                If temp Like "*CNG*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("CNG")
                    offset = 4
                    Cells(row, column + offset).value = table("CNG月累")
                    offset = 5
                    Cells(row, column + offset).value = table("CNG年累")
                End If
                If temp Like "*新奥燃气*" Then
                    offset = 2
                    Cells(row, column + offset).value = table("新奥燃气")
                    offset = 4
                    Cells(row, column + offset).value = table("新奥燃气月累")
                    offset = 5
                    Cells(row, column + offset).value = table("新奥燃气年累")
                End If
                If temp Like "*自用气*" Then
                    Debug.Print table("自用气"), table("自用气月累"), table("自用气年累")
                    offset = 2
                    Cells(row, column + offset).value = table("自用气")
                    offset = 4
                    Cells(row, column + offset).value = table("自用气月累")
                    offset = 5
                    Cells(row, column + offset).value = table("自用气年累")
                End If
                If temp Like "*海管来*液含水*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("海管来液含水上午")
                    offset = 2
                    Cells(row, column + offset).value = table("海管来液含水下午")
                End If
                If temp Like "*海管MEG浓度*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("海管MEG浓度上午")
                    offset = 2
                    Cells(row, column + offset).value = table("海管MEG浓度下午")
                End If
                If temp Like "*海管出口凝点*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("海管出口凝点上午")
                    offset = 2
                    Cells(row, column + offset).value = table("海管出口凝点下午")
                End If
                If temp Like "*海管出口PH值*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("海管出口PH值上午")
                    offset = 2
                    Cells(row, column + offset).value = table("海管出口PH值下午")
                End If
                If temp Like "*海管进*出口压力*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("海管进出口压力")
                End If
                If temp Like "*海管进*出口温度*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("海管进出口温度")
                    海管通球备注 = helper.replace(海管通球备注, "[;；]", s)
                    offset = 4
                    Cells(row + offset, column).value = table("海管通球备注")
                End If
            End If
'                上游
            If temp Like "*JZ25-1S原油*" Then
'                    offset = 1
'                    cells(row,column + offset).value = JZ251S原油
                offset = 2
                Cells(row, column + offset).value = table("JZ251S原油密度")
            End If
            If temp Like "*JZ20-2凝析油*" Then
                offset = 1
                Cells(row, column + offset).value = table("JZ202凝析油")
                offset = 2
                Cells(row, column + offset).value = table("JZ202凝析油密度")
            End If
            If temp Like "*JZ20-2轻油*" Then
                offset = 1
                Cells(row, column + offset).value = table("JZ202轻油")
                offset = 2
                Cells(row, column + offset).value = table("JZ202轻油密度")
            End If
'                天然气产量/外输/海管信息
            If temp Like "*轻油产量*外输*库存*" Then
                anchor1 = row
                anchor2 = row + 6
            End If
'                轻油
            If row < anchor2 And row > anchor1 Then
                If temp Like "*V-631A*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("V-631A")
                    offset = 2
                    Cells(row + offset, column).value = table("V-631A库存m3")
                    offset = 3
                    Cells(row + offset, column).value = table("V-631A库存t")
                End If
                If temp Like "*V-631B*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("V-631B")
                    offset = 2
                    Cells(row + offset, column).value = table("V-631B库存m3")
                    offset = 3
                    Cells(row + offset, column).value = table("V-631B库存t")
                End If
                If temp Like "*V-631C*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("V-631C")
                    offset = 2
                    Cells(row + offset, column).value = table("V-631C库存m3")
                    offset = 3
                    Cells(row + offset, column).value = table("V-631C库存t")
                End If
                If temp Like "*轻油库存*" Then
                    offset = 2
                    Cells(row + offset, column).value = table("轻油库存m3")
                    offset = 3
                    Cells(row + offset, column).value = table("轻油库存t")
                End If
                If temp Like "*轻油处理量m3*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("轻油处理量m3")
                End If
                If temp Like "*轻油回收量m3*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("轻油回收量m3")
                End If
                If temp Like "*轻油回收量t*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("轻油回收量t")
                End If
                If temp Like "*轻油装车t*" Then
                    offset = 2
                    Cells(row, column + offset).value = table("轻油装车t")
                End If
                If temp Like "*轻油装车m3*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("轻油装车m3")
                End If
                If temp Like "*轻油装车bbl*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("轻油装车bbl")
                End If
                If temp Like "*外输凝点*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("外输凝点")
                End If
                If temp Like "*外输PH值*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("外输PH值")
                End If
                If temp Like "*饱和蒸汽压*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("饱和蒸汽压")
                End If
                If temp Like "*轻油入罐前含水*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("轻油入罐前含水")
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
                    Cells(row + offset, column).value = table("V-641A")
                    offset = 2
                    Cells(row + offset, column).value = table("V-641A库存m3")
                    offset = 3
                    Cells(row + offset, column).value = table("V-641A库存t")
                End If
                If temp Like "*V-641B*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("V-641B")
                    offset = 2
                    Cells(row + offset, column).value = table("V-641B库存m3")
                    offset = 3
                    Cells(row + offset, column).value = table("V-641B库存t")
                End If
                If temp Like "*V-642*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("V-642")
                    offset = 2
                    Cells(row + offset, column).value = table("V-642库存m3")
                    offset = 3
                    Cells(row + offset, column).value = table("V-642库存t")
                End If
                If temp Like "*V-643A*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("V-643A")
                    offset = 2
                    Cells(row + offset, column).value = table("V-643A库存m3")
                    offset = 3
                    Cells(row + offset, column).value = table("V-643A库存t")
                End If
                If temp Like "*V-643B*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("V-643B")
                    offset = 2
                    Cells(row + offset, column).value = table("V-643B库存m3")
                    offset = 3
                    Cells(row + offset, column).value = table("V-643B库存t")
                End If
                If temp Like "*丙烷库存*" Then
                    offset = 2
                    Cells(row + offset, column).value = table("丙烷库存m3")
                    offset = 3
                    Cells(row + offset, column).value = table("丙烷库存t")
                End If
                If temp Like "*丁烷库存*" Then
                    offset = 2
                    Cells(row + offset, column).value = table("丁烷库存m3")
                    offset = 3
                    Cells(row + offset, column).value = table("丁烷库存t")
                End If
                If temp Like "*液化气库存*" Then
                    offset = 2
                    Cells(row + offset, column).value = table("液化气库存m3")
                    offset = 3
                    Cells(row + offset, column).value = table("液化气库存t")
                End If
                If temp Like "*丙烷装车t*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("丙烷装车t")
                End If
                If temp Like "*丙烷装车m3*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("丙烷装车m3")
                End If
                If temp Like "*丁烷装车t*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("丁烷装车t")
                End If
                If temp Like "*丁烷装车m3*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("丁烷装车m3")
                End If
                If temp Like "*液化气装车t*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("液化气装车t")
                End If
                If temp Like "*液化气装车m3*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("液化气装车m3")
                End If
                If temp Like "*丙丁烷回收量t*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("丙丁烷回收量t")
                End If
                If temp Like "*丙丁烷回收量m3*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("丙丁烷回收量m3")
                End If
                If temp Like "*数据库轻油回收*" Then
                    offset = 2
                    Cells(row, column + offset).value = table("数据库轻油回收")
                End If
                If temp Like "*数据库丙丁烷回收*" Then
                    offset = 2
                    Cells(row, column + offset).value = table("数据库丙丁烷回收")
                End If
                If temp Like "*轻烃库存t*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("轻烃库存t")
                End If
            End If '丙丁烷产量/外输/库存
'                物料消耗
            If temp Like "*物料接收*消耗*" Then
                anchor1 = row
                anchor2 = row + 9
                offset = 7
                生产备注 = helper.replace(生产备注, "[;；]", s)
                Cells(row + offset, column).value = table("生产备注")
            End If
            If row < anchor2 And row > anchor1 Then
                If temp Like "*乙二醇回收*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("乙二醇回收")
                    offset = 2
                    Cells(row + offset, column).value = table("乙二醇回收月累")
                    offset = 3
                    Cells(row + offset, column).value = table("乙二醇回收年累")
                End If
                If temp Like "*乙二醇浓度*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("乙二醇浓度")
                End If
                If temp Like "*乙二醇消耗*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("乙二醇消耗")
                End If
                If temp Like "*甲醇消耗*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("甲醇消耗")
                    offset = 2
                    Cells(row + offset, column).value = table("甲醇消耗月累")
                    offset = 3
                    Cells(row + offset, column).value = table("甲醇消耗年累")
                End If
                If temp Like "*外供水*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("外供水")
                    offset = 2
                    Cells(row + offset, column).value = table("外供水月累")
                    offset = 3
                    Cells(row + offset, column).value = table("外供水年累")
                End If
                If temp Like "*自采水*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("自采水")
                    offset = 2
                    Cells(row + offset, column).value = table("自采水月累")
                    offset = 3
                    Cells(row + offset, column).value = table("自采水年累")
                End If
                If temp Like "*水消耗*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("水消耗")
                    offset = 2
                    Cells(row + offset, column).value = table("水消耗月累")
                    offset = 3
                    Cells(row + offset, column).value = table("水消耗年累")
                End If
                If temp Like "*水池水位*" Then
                    offset = 1
                    Cells(row, column + offset).value = table("水池水位")
                End If
                If temp Like "*外供电*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("外供电")
                    offset = 2
                    Cells(row + offset, column).value = table("外供电月累")
                    offset = 3
                    Cells(row + offset, column).value = table("外供电年累")
                End If
                If temp Like "*自发电*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("自发电")
                    offset = 2
                    Cells(row + offset, column).value = table("自发电月累")
                    offset = 3
                    Cells(row + offset, column).value = table("自发电年累")
                End If
                If temp Like "*电消耗*" Then
                    offset = 1
                    Cells(row + offset, column).value = table("电消耗")
                    offset = 2
                    Cells(row + offset, column).value = table("电消耗月累")
                    offset = 3
                    Cells(row + offset, column).value = table("电消耗年累")
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
