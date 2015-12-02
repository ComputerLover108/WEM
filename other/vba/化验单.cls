VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "化验单"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Public Sub dataMining(ByRef gasRecord As Object, ByRef waterRecord As Object, ByRef oilRecord As Object, ByRef scRecord As Object)
    Err.Clear
On Error GoTo ErrorHandler
    Dim row, column, ro, co, beginRow, beginColumn, lastRow, lastColumn As Long
    beginRow = 1
    beginColumn = 1
    lastRow = ActiveSheet.UsedRange.Rows.count
    lastColumn = ActiveSheet.UsedRange.Columns.count
    Dim result As Object
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
'    Call 合并单元格统计(beginRow, beginColumn, lastRow, lastColumn, table)
'    For Each x In table.keys
'        Debug.Print x.Address(ReferenceStyle:=xlR1C1), table(x)
'    Next
'    Debug.Print table.count
    Dim title As String
    Dim temp  As Variant
    Dim 日期 As Date
    title = "*葫芦岛天然气终端厂化验日报*"
'    海管
    Dim 上午海管出口PH值, 下午海管出口PH值, 上午海管出口凝点, 下午海管出口凝点, 上午海管MEG浓度, 下午海管MEG浓度, 上午海管来液含水, 下午海管来液含水 As Variant
'    轻油
    Dim 轻油外输凝点℃, 轻油外输PH值, 轻油饱和蒸汽压, 上午轻油入罐前含水, 下午轻油入罐前含水, 轻油密度 As Variant
'    化学药剂
    Dim 乙二醇日回收量m3, 乙二醇浓度, 乙二醇库存, 乙二醇死库存 As Variant
    Dim 海管来液密度, 轻油稳定塔顶压力, 轻油稳定塔底操作温度℃ As Variant
'    循环水
    Dim PH值, 浊度, 电导率, 总碱度, 总硬度, LSI, 氯离子, 总铁 As Double
    Dim gtd As New 轻烃组分
    Dim wtd As New 水质检测
    Dim otd As New 滑油检测
    Dim scxx As New 生产信息
    Dim Condition As Boolean
    For row = 1 To lastRow
        For column = 1 To lastColumn
'            If Cells(row, column).MergeCells = True Then
'                Debug.Print row, column, Cells(row, column).MergeArea.Rows.count; Cells(row, column).MergeArea.Columns.count, Cells(row, column).MergeArea.count, Cells(row, column).value
'            End If
            temp = Cells(row, column).value
            Condition = False
            If temp Like title Then
                ro = 1
                日期 = Cells(row + ro, column).value
            End If
'            海管
            If temp Like "V-611" Then
                ro = 1
                co = 2
                上午海管MEG浓度 = Cells(row + ro, column + co).value
                ro = 3
                下午海管MEG浓度 = Cells(row + ro, column + co).value
                scxx.日期 = 日期
                scxx.名称 = "海管MEG浓度"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "海管"
                scxx.备注 = "上午"
                scxx.数据 = 上午海管MEG浓度
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "海管MEG浓度"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "海管"
                scxx.备注 = "下午"
                scxx.数据 = 下午海管MEG浓度
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
            End If
            If temp Like "V-601(%)" Then
                ro = 1
                co = 1
                上午海管来液含水 = Cells(row + ro, column + co).value
                ro = 2
                下午海管来液含水 = Cells(row + ro, column + co).value
                ro = 4
                海管来液密度 = Cells(row + ro, column).value
                scxx.日期 = 日期
                scxx.名称 = "海管来液含水"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "海管"
                scxx.备注 = "上午"
                scxx.数据 = 上午海管来液含水
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "海管来液含水"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "海管"
                scxx.备注 = "下午"
                scxx.数据 = 下午海管来液含水
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "海管来液密度"
                scxx.单位 = "kg/m3"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "海管"
                scxx.数据 = 海管来液密度
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
            End If
            If temp Like "V-601*9:00" Then
                co = 5
                上午海管出口凝点 = Cells(row, column + co).value
                co = 11
                下午海管出口凝点 = Cells(row, column + co).value
                co = 18
                上午海管出口PH值 = Cells(row, column + co).value
                co = 21
                下午海管出口PH值 = Cells(row, column + co).value

'                Dim p, l As Single
'                p = InStr(上午海管出口凝点, "-") - 1
'                l = Len(上午海管出口凝点)
                Dim st, sp As String
                sp = "(\-|\+)?\d+(\.\d+)?$"
'                st = 上午海管出口凝点
'                Debug.Print 上午海管出口凝点, RegExpTest(sp, st)
                上午海管出口凝点 = CDbl(RegExpTest(sp, 上午海管出口凝点))
                下午海管出口凝点 = CDbl(RegExpTest(sp, 下午海管出口凝点))
                
                scxx.日期 = 日期
                scxx.名称 = "海管出口凝点"
                scxx.单位 = "摄氏度"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "海管"
                scxx.备注 = "上午"
                scxx.数据 = 上午海管出口凝点
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "海管出口凝点"
                scxx.单位 = "摄氏度"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "海管"
                scxx.备注 = "下午"
                scxx.数据 = 下午海管出口凝点
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "海管出口PH值"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "海管"
                scxx.备注 = "上午"
                scxx.数据 = 上午海管出口PH值
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "海管出口PH值"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "海管"
                scxx.备注 = "下午"
                scxx.数据 = 下午海管出口PH值
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
            End If
'            轻油
            If temp Like "轻油外输数据" Then
                co = 6
                轻油外输PH值 = Cells(row, column + co).value
                co = 11
                轻油外输凝点℃ = Cells(row, column + co).value
                
                scxx.日期 = 日期
                scxx.名称 = "外输PH值"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.数据 = 轻油外输PH值
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "外输凝点"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.数据 = 轻油外输凝点℃
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
            End If
            If temp Like "轻油入罐前数据" Then
                co = 7
                上午轻油入罐前含水 = Cells(row, column + co).value
                co = 9
                下午轻油入罐前含水 = Cells(row, column + co).value
                co = 11
                轻油入罐前PH值 = Cells(row, column + co).value
                scxx.日期 = 日期
                scxx.名称 = "入罐前含水"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.备注 = "上午"
                scxx.数据 = 上午轻油入罐前含水
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "入罐前含水"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.备注 = "下午"
                scxx.数据 = 下午轻油入罐前含水
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "入罐前PH值"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.数据 = 轻油入罐前PH值
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
            End If
            If temp Like "轻油" Then
                Dim V631A含水, V631A饱和蒸汽压, V631A密度 As Variant
                Dim V631B含水, V631B饱和蒸汽压, V631B密度 As Variant
                Dim V631C含水, V631C饱和蒸汽压, V631C密度 As Variant
                ro = 2
                co = 4
                V631A含水 = Cells(row + ro, column + co).value
                V631A饱和蒸汽压 = Cells(row + ro + 1, column + co).value
                V631A密度 = Cells(row + ro + 2, column + co).value
                co = 6
                V631B含水 = Cells(row + ro, column + co).value
                V631B饱和蒸汽压 = Cells(row + ro + 1, column + co).value
                V631B密度 = Cells(row + ro + 2, column + co).value
                co = 8
                V631C含水 = Cells(row + ro, column + co).value
                V631C饱和蒸汽压 = Cells(row + ro + 1, column + co).value
                V631C密度 = Cells(row + ro + 2, column + co).value
                If IsEmpty(V631A密度) And IsEmpty(V631B密度) And IsEmpty(V631C密度) Then
                Else
                    Dim arr As Variant
                    arr = Array(V631A密度, V631B密度, V631C密度)
                    轻油密度 = Application.Min(arr)
                End If
                scxx.日期 = 日期
                scxx.名称 = "V-631A含水"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.数据 = V631A含水
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "V-631B含水"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.数据 = V631B含水
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "V-631C含水"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.数据 = V631C含水
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "V-631A饱和蒸汽压"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.单位 = "千帕"
                scxx.数据 = V631A饱和蒸汽压
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "V-631B饱和蒸汽压"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.单位 = "千帕"
                scxx.数据 = V631B饱和蒸汽压
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "V-631C饱和蒸汽压"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.单位 = "千帕"
                scxx.数据 = V631C饱和蒸汽压
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "V-631A密度"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.单位 = "千克/立方米"
                scxx.数据 = V631A密度
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "V-631B密度"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.单位 = "千克/立方米"
                scxx.数据 = V631B密度
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "V-631C密度"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.单位 = "千克/立方米"
                scxx.数据 = V631C密度
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "轻油密度"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.单位 = "千克/立方米"
                scxx.数据 = 轻油密度
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
            End If
            If temp Like "E-613饱和蒸汽压" Then
                ro = 2
                co = 8
                轻油饱和蒸汽压 = Cells(row + ro, column + co).value
                ro = 3
                轻油稳定塔顶压力 = Cells(row + ro, column + co).value
                ro = 5
                轻油稳定塔底操作温度℃ = Cells(row + ro, column + co).value
                
                scxx.日期 = 日期
                scxx.名称 = "E-613饱和蒸汽压"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.单位 = "千帕"
                scxx.数据 = 轻油饱和蒸汽压
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "T-611塔顶压力"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.单位 = "兆帕"
                scxx.数据 = 轻油稳定塔顶压力
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "E-615温度"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "轻油"
                scxx.单位 = "摄氏度"
                scxx.数据 = 轻油稳定塔底操作温度℃
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
            End If
'            化学药剂
            If temp Like "V-616" Then
                ro = 1
                co = 3
                乙二醇浓度 = Cells(row + ro, column + co).value
                ro = 3
                乙二醇日回收量m3 = Cells(row + ro, column + co).value
                
                scxx.日期 = 日期
                scxx.名称 = "乙二醇浓度"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "化学药剂"
                scxx.数据 = 乙二醇浓度
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
                
                scxx.日期 = 日期
                scxx.名称 = "乙二醇回收"
                scxx.数据源 = ThisWorkbook.FullName
                scxx.类别 = "化学药剂"
                scxx.单位 = "方"
                scxx.状态 = "生产"
                scxx.数据 = 乙二醇日回收量m3
                If Not IsEmpty(scxx.数据) Then
                    scRecord.Add scxx, ""
                End If
                Set scxx = Nothing
            End If
'            天然气分析
            If temp Like "天*然*气*分*析" Then
                beginRow = row + 1
                beginColumn = column + 2
'                lastRow = 26
'                lastColumn = Cells(row, column).MergeArea.Columns.count + column - 1
'                For x = beginRow To lastRow
'                    For y = beginRow To lastColumn
'                    Next y
'                Next x
'                甲烷
                ro = 1
                co = 2
                If Cells(row + ro, column + co).value Like "甲烷" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.日期 = 日期
                    gtd.名称 = Cells(beginRow, beginColumn).value
                    gtd.取样点 = "PV-2158"
                    ro = 2
                    co = 1
                    gtd.C1 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C3 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.塔底温度 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.CO2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.N2 = Cells(beginRow + ro, beginColumn + co).value
                    If IsEmpty(gtd.C1) And IsEmpty(gtd.C2) And IsEmpty(gtd.C3) And IsEmpty(gtd.iC4) And IsEmpty(gtd.nC4) And IsEmpty(gtd.iC5) And IsEmpty(gtd.nC5) And IsEmpty(gtd.CO2) And IsEmpty(gtd.N2) And IsEmpty(gtd.塔底温度) Then
                    Else
                        gasRecord.Add gtd, ""
                    End If
                    Set gtd = Nothing
                End If
'                乙烷
                ro = 1
                co = 5
                If Cells(row + ro, column + co).value Like "乙烷" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.日期 = 日期
                    gtd.名称 = Cells(beginRow, beginColumn).value
                    gtd.取样点 = "PV-3057"
                    ro = 2
                    co = 2
                    gtd.C1 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C3 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.塔底温度 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.CO2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.N2 = Cells(beginRow + ro, beginColumn + co).value
                    If IsEmpty(gtd.C1) And IsEmpty(gtd.C2) And IsEmpty(gtd.C3) And IsEmpty(gtd.iC4) And IsEmpty(gtd.nC4) And IsEmpty(gtd.iC5) And IsEmpty(gtd.nC5) And IsEmpty(gtd.CO2) And IsEmpty(gtd.N2) And IsEmpty(gtd.塔底温度) Then
                    Else
                        gasRecord.Add gtd, ""
                    End If
                    Set gtd = Nothing
                End If
'                丙烷
                ro = 1
                co = 9
                If Cells(row + ro, column + co).value Like "丙烷" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.日期 = 日期
                    gtd.名称 = Cells(beginRow, beginColumn).value
                    gtd.取样点 = "PV-3157-1"
                    ro = 2
                    co = 2
                    gtd.C1 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C3 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.塔底温度 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.CO2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.N2 = Cells(beginRow + ro, beginColumn + co).value
                    If IsEmpty(gtd.C1) And IsEmpty(gtd.C2) And IsEmpty(gtd.C3) And IsEmpty(gtd.iC4) And IsEmpty(gtd.nC4) And IsEmpty(gtd.iC5) And IsEmpty(gtd.nC5) And IsEmpty(gtd.CO2) And IsEmpty(gtd.N2) And IsEmpty(gtd.塔底温度) Then
                    Else
                        gasRecord.Add gtd, ""
                    End If
                    Set gtd = Nothing
                End If
'                丁烷
                ro = 1
                co = 13
                If Cells(row + ro, column + co).value Like "丁烷" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.日期 = 日期
                    gtd.名称 = Cells(beginRow, beginColumn).value
                    gtd.取样点 = "PV-3258-1"
                    ro = 2
                    co = 2
                    gtd.C1 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C3 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.塔底温度 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.CO2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.N2 = Cells(beginRow + ro, beginColumn + co).value
                    If IsEmpty(gtd.C1) And IsEmpty(gtd.C2) And IsEmpty(gtd.C3) And IsEmpty(gtd.iC4) And IsEmpty(gtd.nC4) And IsEmpty(gtd.iC5) And IsEmpty(gtd.nC5) And IsEmpty(gtd.CO2) And IsEmpty(gtd.N2) And IsEmpty(gtd.塔底温度) Then
                    Else
                        gasRecord.Add gtd, ""
                    End If
                    Set gtd = Nothing
                End If
'                丙烷 15:00
                ro = 1
                co = 17
                If Cells(row + ro, column + co).value Like "丙烷*" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.日期 = 日期
                    gtd.名称 = Cells(beginRow, beginColumn).value
                    gtd.取样点 = "PV-3157-1"
                    ro = 2
                    co = 2
                    gtd.C1 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C3 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.塔底温度 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.CO2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.N2 = Cells(beginRow + ro, beginColumn + co).value
                    If IsEmpty(gtd.C1) And IsEmpty(gtd.C2) And IsEmpty(gtd.C3) And IsEmpty(gtd.iC4) And IsEmpty(gtd.nC4) And IsEmpty(gtd.iC5) And IsEmpty(gtd.nC5) And IsEmpty(gtd.CO2) And IsEmpty(gtd.N2) And IsEmpty(gtd.塔底温度) Then
                    Else
                        gasRecord.Add gtd, ""
                    End If
                    Set gtd = Nothing
                End If
'                丁烷 15:00
                ro = 1
                co = 21
                If Cells(row + ro, column + co).value Like "丁烷*" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.日期 = 日期
                    gtd.名称 = Cells(beginRow, beginColumn).value
                    gtd.取样点 = "PV-3258-1"
                    ro = 2
                    co = 2
                    gtd.C1 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C3 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.塔底温度 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.CO2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.N2 = Cells(beginRow + ro, beginColumn + co).value
                    If IsEmpty(gtd.C1) And IsEmpty(gtd.C2) And IsEmpty(gtd.C3) And IsEmpty(gtd.iC4) And IsEmpty(gtd.nC4) And IsEmpty(gtd.iC5) And IsEmpty(gtd.nC5) And IsEmpty(gtd.CO2) And IsEmpty(gtd.N2) And IsEmpty(gtd.塔底温度) Then
                    Else
                        gasRecord.Add gtd, ""
                    End If
                    Set gtd = Nothing
                End If
'                外输气
                If Cells(row + ro, column + co).value Like "外输气" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.日期 = 日期
                    gtd.名称 = Cells(beginRow, beginColumn).value
                    gtd.取样点 = ""
                    ro = 2
                    co = 2
                    gtd.C1 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C3 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.塔底温度 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.CO2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.N2 = Cells(beginRow + ro, beginColumn + co).value
                    If IsEmpty(gtd.C1) And IsEmpty(gtd.C2) And IsEmpty(gtd.C3) And IsEmpty(gtd.iC4) And IsEmpty(gtd.nC4) And IsEmpty(gtd.iC5) And IsEmpty(gtd.nC5) And IsEmpty(gtd.CO2) And IsEmpty(gtd.N2) And IsEmpty(gtd.塔底温度) Then
                    Else
                        gasRecord.Add gtd, ""
                    End If
                    Set gtd = Nothing
                End If
'                原料气
                ro = 1
                co = 24
                If Cells(row + ro, column + co).value Like "原料气" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.日期 = 日期
                    gtd.名称 = Cells(beginRow, beginColumn).value
                    gtd.取样点 = ""
                    ro = 2
                    co = 1
                    gtd.C1 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.C3 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC4 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.iC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.nC5 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.塔底温度 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.CO2 = Cells(beginRow + ro, beginColumn + co).value
                    ro = ro + 1
                    gtd.N2 = Cells(beginRow + ro, beginColumn + co).value
                If IsEmpty(gtd.C1) And IsEmpty(gtd.C2) And IsEmpty(gtd.C3) And IsEmpty(gtd.iC4) And IsEmpty(gtd.nC4) And IsEmpty(gtd.iC5) And IsEmpty(gtd.nC5) And IsEmpty(gtd.CO2) And IsEmpty(gtd.N2) And IsEmpty(gtd.塔底温度) Then
                Else
                    gasRecord.Add gtd, ""
                End If
                    Set gtd = Nothing
                End If
            End If
'            液化气
            If temp Like "V-643*" Then
                gtd.日期 = 日期
                gtd.名称 = "液化气"
                If temp Like "*丁烷*" Then
                    gtd.名称 = "丁烷"
                End If
                gtd.取样点 = temp
                If Cells(row, column).MergeCells Then
                    ro = Cells(row, column).MergeArea.Rows.count
                Else
                    ro = 1
                End If
                gtd.C2 = Cells(row + ro, column).value
                ro = ro + 1
                gtd.C3 = Cells(row + ro, column).value
                ro = ro + 1
                gtd.iC4 = Cells(row + ro, column).value
                ro = ro + 1
                gtd.nC4 = Cells(row + ro, column).value
                ro = ro + 1
                gtd.C5加 = Cells(row + ro, column).value
                ro = ro + 1
                gtd.饱和蒸气压 = Cells(row + ro, column).value
'                Debug.Print gtd.饱和蒸气压
                If IsEmpty(gtd.C2) And IsEmpty(gtd.C3) And IsEmpty(gtd.iC4) And IsEmpty(gtd.nC4) And IsEmpty(gtd.C5加) And IsEmpty(gtd.饱和蒸气压) Then
                Else
                    gasRecord.Add gtd, ""
                End If
                Set gtd = Nothing
            End If
'                外输丙丁烷
            If temp Like "V-64[12]*" Then
                gtd.日期 = 日期
                gtd.名称 = "丙烷"
                If temp = "V-642" Then
                    gtd.名称 = "丁烷"
                End If
                gtd.取样点 = temp
                If Cells(row, column).MergeCells Then
                    ro = Cells(row, column).MergeArea.Rows.count
                Else
                    ro = 1
                End If
                gtd.C2 = Cells(row + ro, column).value
                ro = ro + 1
                gtd.C3 = Cells(row + ro, column).value
                ro = ro + 1
                gtd.iC4 = Cells(row + ro, column).value
                ro = ro + 1
                gtd.nC4 = Cells(row + ro, column).value
                ro = ro + 1
                gtd.C5加 = Cells(row + ro, column).value
                If IsEmpty(gtd.C2) And IsEmpty(gtd.C3) And IsEmpty(gtd.iC4) And IsEmpty(gtd.nC4) And IsEmpty(gtd.C5加) Then
                Else
                    gasRecord.Add gtd, ""
                End If
                Set gtd = Nothing
            End If
            If temp Like "锅炉水" Then
'                软化水
                ro = 2
                co = 1
                wtd.名称 = "软化水"
                wtd.PH值 = Cells(row + ro, column + co).value
                ro = ro + 1
                wtd.总硬度 = Cells(row + ro, column + co).value
                ro = ro + 1
                wtd.总碱度 = Cells(row + ro, column + co).value
                wtd.日期 = 日期
                wtd.数据源 = ThisWorkbook.FullName
                If wtd.PH值 > 0 Or wtd.总硬度 > 0 Or wtd.总碱度 Then
                    Condition = True
                End If
                If Condition = True Then
                    waterRecord.Add wtd, ""
                End If
'                If IsEmpty(wtd.PH值) And IsEmpty(wtd.浊度) And IsEmpty(wtd.电导率) And IsEmpty(wtd.总碱度) And IsEmpty(wtd.总硬度) And IsEmpty(wtd.总铁) And IsEmpty(wtd.LSI) And IsEmpty(wtd.氯离子) Then
'                Else
'                    waterRecord.Add wtd, ""
'                End If
                Set wtd = Nothing
'                锅炉循环水
                ro = 2
                co = 3
                wtd.名称 = "锅炉循环水"
                wtd.PH值 = Cells(row + ro, column + co).value
                ro = ro + 1
                wtd.总硬度 = Cells(row + ro, column + co).value
                ro = ro + 1
                wtd.总碱度 = Cells(row + ro, column + co).value
                wtd.日期 = 日期
                wtd.数据源 = ThisWorkbook.FullName
                If wtd.PH值 > 0 Or wtd.总硬度 > 0 Or wtd.总碱度 Then
                    Condition = True
                End If
                If Condition = True Then
                    waterRecord.Add wtd, ""
                End If
'                If IsEmpty(wtd.PH值) And IsEmpty(wtd.浊度) And IsEmpty(wtd.电导率) And IsEmpty(wtd.总碱度) And IsEmpty(wtd.总硬度) And IsEmpty(wtd.总铁) And IsEmpty(wtd.LSI) And IsEmpty(wtd.氯离子) Then
'                Else
'                    waterRecord.Add wtd, ""
'                End If
                Set wtd = Nothing
            End If
            If temp Like "循环水" And Cells(row, column).MergeArea.Rows.count = 3 Then
                ro = 1
                co = 2
                If Cells(row, column + co).value Like "PH值" Then
                    PH值 = Cells(row + ro, column + co).value
                End If
                co = 5
                If Cells(row, column + co).value Like "浊度" Then
                    浊度 = Cells(row + ro, column + co).value
                End If
                co = 9
                If Cells(row, column + co).value Like "电导率" Then
                    电导率 = Cells(row + ro, column + co).value
                End If
                co = 13
                If Cells(row, column + co).value Like "总碱度" Then
                    总碱度 = Cells(row + ro, column + co).value
                End If
                co = 17
                If Cells(row, column + co).value Like "总硬度" Then
                    总硬度 = Cells(row + ro, column + co).value
                End If
                co = 19
                If Cells(row, column + co).value Like "LSI" Then
                    LSI = Cells(row + ro, column + co).value
                End If
                co = 21
                If Cells(row, column + co).value Like "氯离子" Then
                    氯离子 = Cells(row + ro, column + co).value
                End If
                co = 24
                If Cells(row, column + co).value Like "总铁" Then
                    总铁 = Cells(row + ro, column + co).value
                End If
                wtd.名称 = "循环水"
                wtd.PH值 = PH值
                wtd.浊度 = 浊度
                wtd.电导率 = 电导率
                wtd.总碱度 = 总碱度
                wtd.总硬度 = 总硬度
                wtd.总铁 = 总铁
                wtd.LSI = LSI
                wtd.氯离子 = 氯离子
                wtd.日期 = 日期
                wtd.数据源 = ThisWorkbook.FullName
                If wtd.PH值 > 0 Or wtd.总硬度 > 0 Or wtd.总碱度 Then
                    Condition = True
                End If
                If wtd.PH值 > 0 Or wtd.总硬度 > 0 Or wtd.总碱度 Or wtd.LSI > 0 Or wtd.电导率 > 0 Or wtd.氯离子 > 0 Or wtd.总铁 > 0 Or wtd.浊度 > 0 Then
                    Condition = True
                End If
                If Condition = True Then
                    waterRecord.Add wtd, ""
                End If
'                If IsEmpty(wtd.PH值) And IsEmpty(wtd.浊度) And IsEmpty(wtd.电导率) And IsEmpty(wtd.总碱度) And IsEmpty(wtd.总硬度) And IsEmpty(wtd.总铁) And IsEmpty(wtd.LSI) And IsEmpty(wtd.氯离子) Then
'                Else
'                    waterRecord.Add wtd, ""
'                End If
                Set wtd = Nothing
            End If
            If temp Like "运行单机滑油" Then
                If Cells(row, column).MergeCells Then
                    Dim ar As Long
                    ar = Cells(row, column).MergeArea.Rows.count - 2
'                    Debug.Print row, column, ar
                    For i = 0 To ar - 1
                        ro = 2
                        co = 2
                        otd.名称 = Cells(row + ro + i, column + co).value
                        co = co + 4
                        otd.运动粘度 = Cells(row + ro + i, column + co).value
                        co = co + 3
                        otd.机械杂质 = Cells(row + ro + i, column + co).value
                        co = co + 2
                        otd.含水 = Cells(row + ro + i, column + co).value
                        otd.日期 = 日期
                        otd.数据源 = ThisWorkbook.FullName
                        If IsEmpty(otd.机械杂质) And IsEmpty(otd.运动粘度) And IsEmpty(otd.含水) Then
                        Else
                            oilRecord.Add otd, ""
                        End If
                        Set otd = Nothing
                    Next i
                End If
            End If
            If temp Like "*备*注*" Then
                co = 1
                Dim s, re  As String
                s = Cells(row, column + co).value
                re = "\d+(\.\d+)"
                Dim regEx, Match, Matches
                Set regEx = CreateObject("vbScript.regexp")
                regEx.Pattern = re
                regEx.IgnoreCase = True
                regEx.Global = True
                Set Matches = regEx.Execute(s)
                If Matches.count = 2 And s Like "乙二醇*死库存*" Then
                    乙二醇库存 = Matches(0)
                    乙二醇死库存 = Matches(1)
                    
                    scxx.日期 = 日期
                    scxx.名称 = "乙二醇库存"
                    scxx.数据源 = ThisWorkbook.FullName
                    scxx.类别 = "化学药剂"
                    scxx.单位 = "方"
                    scxx.状态 = "库存"
                    scxx.数据 = 乙二醇库存
                    If Not IsEmpty(scxx.数据) Then
                        scRecord.Add scxx, ""
                    End If
                    Set scxx = Nothing
                    
                    scxx.日期 = 日期
                    scxx.名称 = "乙二醇死库存"
                    scxx.数据源 = ThisWorkbook.FullName
                    scxx.类别 = "化学药剂"
                    scxx.单位 = "方"
                    scxx.状态 = "库存"
                    scxx.数据 = 乙二醇死库存
                    If Not IsEmpty(scxx.数据) Then
                        scRecord.Add scxx, ""
                    End If
                    Set scxx = Nothing
                End If
            End If
        Next column
    Next row

'    For Each x In gasRecord.Keys
'        Debug.Print x.日期, x.名称, x.取样点, x.C1, x.C2, x.C3, x.iC4, x.nC4, x.iC5, x.nC5, x.CO2, x.N2, x.C5加, x.塔底温度
'    Next
'    For Each x In waterRecord.Keys
'        Debug.Print x.日期, x.名称, x.PH值, x.浊度, x.电导率, x.总碱度, x.总硬度, x.LSI, x.氯离子, x.总铁, x.数据源
'    Next
'    For Each x In oilRecord.Keys
'        Debug.Print x.日期, x.名称, x.运动粘度, x.机械杂质, x.含水, x.数据源
'    Next
'    For Each x In scRecord.Keys
'        Debug.Print x.日期, x.名称, x.单位, x.类别, x.数据, x.备注, x.数据源
'    Next
    Debug.Print "生产信息：" & scRecord.count & ",轻烃组分：" & gasRecord.count & ",滑油检测：" & oilRecord.count & ",水质检测：" & waterRecord.count
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
