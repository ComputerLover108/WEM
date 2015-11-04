VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "化验单"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False


Public Sub dataMining()
    Err.Clear
On Error GoTo ErrorHandler
    Dim row, column, ro, co, beginRow, beginColumn, lastRow, lastColumn As Long
    beginRow = 1
    beginColumn = 1
    lastRow = 32
    lastColumn = 32
    Dim Title As String
    Dim temp  As Variant
    Dim 日期 As Date
    Title = "*葫芦岛天然气终端厂化验日报*"
'    海管
    Dim 上午海管出口PH值, 下午海管出口PH值, 上午海管出口凝点, 下午海管出口凝点, 上午海管MEG浓度, 下午海管MEG浓度, 上午海管来液含水, 下午海管来液含水 As Variant
'    轻油
    Dim 轻油外输凝点℃, 轻油外输PH值, 轻油饱和蒸汽压, 上午轻油入罐前含水, 下午轻油入罐前含水, 轻油密度 As Variant
'    化学药剂
    Dim 乙二醇日回收量m3, 乙二醇浓度 As Variant
    Dim 海管来液密度, 轻油稳定塔顶压力, 轻油稳定塔底操作温度℃ As Variant
        
    Dim gasRecord, waterRecord, oilRecord, scRecord
    Set gasRecord = CreateObject("Scripting.Dictionary")
    Dim gtd As New 轻烃组分
    For row = beginRow To lastRow
        For column = beginColumn To lastColumn
            temp = Cells(row, column).value
            If temp Like Title Then
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
            End If
            If temp Like "V-601(%)" Then
                ro = 1
                co = 1
                上午海管来液含水 = Cells(row + ro, column + co).value
                ro = 2
                下午海管来液含水 = Cells(row + ro, column + co).value
                ro = 4
                海管来液密度 = Cells(row + ro, column).value
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
            End If
'            轻油
            If temp Like "轻油外输数据" Then
                co = 6
                轻油外输PH值 = Cells(row, column + co).value
                co = 11
                轻油外输凝点℃ = Cells(row, column + co).value
            End If
            If temp Like "轻油入罐前数据" Then
                co = 7
                上午轻油入罐前含水 = Cells(row, column + co).value
                co = 9
                下午轻油入罐前含水 = Cells(row, column + co).value
                co = 11
                轻油入罐前PH值 = Cells(row, column + co).value
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
                Dim arr As Variant
                arr = Array(V631A密度, V631B密度, V631C密度)
                轻油密度 = Application.Min(arr)
            End If
            If temp Like "E-613饱和蒸汽压" Then
                ro = 2
                co = 8
                轻油饱和蒸汽压 = Cells(row + ro, column + co).value
                ro = 3
                轻油稳定塔顶压力 = Cells(row + ro, column + co).value
                ro = 5
                轻油稳定塔底操作温度℃ = Cells(row + ro, column + co).value
            End If
'            化学药剂
            If temp Like "V-616" Then
                ro = 1
                co = 3
                乙二醇浓度 = Cells(row + ro, column + co).value
                ro = 3
                乙二醇日回收量m3 = Cells(row + ro, column + co).value
            End If
'            天然气分析
            If temp Like "天*然*气*分*析" Then
'                甲烷
                ro = 1
                co = 2
                If Cells(row + ro, column + co).value Like "甲烷" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.时间 = 日期 + "9:00"
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
                    gasRecord.Add gtd, ""
                    Set gtd = Nothing
                End If
'                乙烷
                ro = 1
                co = 5
                If Cells(row + ro, column + co).value Like "乙烷" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.时间 = 日期 + "9:00"
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
                    gasRecord.Add gtd, ""
                    Set gtd = Nothing
                End If
'                丙烷
                ro = 1
                co = 9
                If Cells(row + ro, column + co).value Like "丙烷" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.时间 = 日期 + "9:00"
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
                    gasRecord.Add gtd, ""
                    Set gtd = Nothing
                End If
'                丁烷
                ro = 1
                co = 13
                If Cells(row + ro, column + co).value Like "丁烷" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.时间 = 日期 + "9:00"
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
                    gasRecord.Add gtd, ""
                    Set gtd = Nothing
                End If
'                丙烷 15:00
                ro = 1
                co = 17
                If Cells(row + ro, column + co).value Like "丙烷*" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.时间 = 日期 + "15:00"
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
                    gasRecord.Add gtd, ""
                    Set gtd = Nothing
                End If
'                丁烷 15:00
                ro = 1
                co = 21
                If Cells(row + ro, column + co).value Like "丁烷*" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.时间 = 日期 + "15:00"
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
                    gasRecord.Add gtd, ""
                    Set gtd = Nothing
                End If
'                外输气
                If Cells(row + ro, column + co).value Like "外输气" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.时间 = 日期 + "9:00"
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
                    gasRecord.Add gtd, ""
                    Set gtd = Nothing
                End If
'                原料气
                ro = 1
                co = 21
                If Cells(row + ro, column + co).value Like "原料气" Then
                    beginRow = row + ro
                    beginColumn = column + co
                    gtd.时间 = 日期 + "9:00"
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
                    gasRecord.Add gtd, ""
                    Set gtd = Nothing
                End If
            End If
        Next column
    Next row
'    Debug.Print 上午海管出口PH值, 下午海管出口PH值, 上午海管出口凝点, 下午海管出口凝点, 上午海管MEG浓度, 下午海管MEG浓度, 上午海管来液含水, 下午海管来液含水
'    Debug.Print 乙二醇日回收量m3, 乙二醇浓度
'    Debug.Print 海管来液密度, 轻油饱和蒸汽压, 轻油稳定塔顶压力, 轻油稳定塔底操作温度℃
    Debug.Print gasRecord
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub

Public Sub getValue(ByVal fname As String, table As Object)
    Err.Clear
On Error GoTo ErrorHandler
    Application.ScreenUpdating = False
    Debug.Print fname
'    Application.Visible = True
    Dim Title, ShName, Flag As String
    Title = "*葫芦岛天然气终端厂化验日报*"
    ShName = "化验报表"
    Flag = "循环水"
    
    Dim PH值, 浊度, 电导率, 总碱度, 总硬度, LSI, 氯离子, 总铁 As Double
    Dim wb
    Set wb = Workbooks.Open(fname, 0, ReadOnly)
    Dim row, column, ro, co, beginRow, beginColumn, lastRow, lastColumn As Long
    lastRow = 32
    lastColumn = 32
    Dim 日期 As Date
    Dim temp
    Dim record As New 水质检测
    For Each sh In wb.Worksheets
        If sh.name = ShName Then
            For row = 1 To lastRow
                For column = 1 To lastColumn
                    If sh.Cells(row, column) Like Title Then
                        ro = 1
                        日期 = sh.Cells(row + ro, column).value
'                        Debug.Print 日期
                    End If
                    If sh.Cells(row, column) Like Flag Then
                        ro = 1
                        co = 2
                        PH值 = sh.Cells(row + ro, column + co).value
                        co = 5
                        浊度 = sh.Cells(row + ro, column + co).value
                        co = 9
                        电导率 = sh.Cells(row + ro, column + co).value
                        co = 13
                        总碱度 = sh.Cells(row + ro, column + co).value
                        co = 17
                        总硬度 = sh.Cells(row + ro, column + co).value
                        co = 19
                        LSI = sh.Cells(row + ro, column + co).value
                        co = 21
                        氯离子 = sh.Cells(row + ro, column + co).value
                        co = 24
                        总铁 = sh.Cells(row + ro, column + co).value
                    End If
                Next column
            Next row
            With record
                .日期 = 日期
                .名称 = Flag
                .PH值 = PH值
                .浊度 = 浊度
                .电导率 = 电导率
                .总碱度 = 总碱度
                .总硬度 = 总硬度
                .LSI = LSI
                .氯离子 = 氯离子
                .总铁 = 总铁
                数据源 = fname
            End With
            table.Add record, ""
            Set record = Nothing
'            Debug.Print 日期, Flag, PH值, 浊度, 电导率, 总碱度, 总硬度, LSI, 氯离子, 总铁, fname
        End If
    Next sh
    wb.Close SaveChanges:=False
'    wb.Close False
    Set wb = Nothing
    Application.ScreenUpdating = True
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
