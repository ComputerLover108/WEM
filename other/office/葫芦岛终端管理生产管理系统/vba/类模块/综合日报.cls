VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "综合日报"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'测试
Public Sub test()
    Dim fname As String
    fname = "H:\public\test\报表共享(王全）\2012年综合日报\2012年6月综合\葫芦岛天然气处理厂综合日报表2012.6.30.xls"
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
    Call getValue(fname, table)
    Dim record
    For Each record In table.Keys
        Debug.Print record.content
    Next record
    Debug.Print "共收集了" & table.count & "记录！" & vbTab & fname
    Set table = Nothing
End Sub
'提取数据到生产信息
Public Sub getValue(ByVal fname As String, ByRef table As Object)
    On Error Resume Next
    Application.ScreenUpdating = False
'    Application.Visible = True
    Dim wb As Object
    Set wb = GetObject(fname)
'    If Err.Number <> 0 Then ExcelWasNotRunning = True
'    Err.Clear    '如果发生错误则要清除 Err 对象
    Dim pattern As String
    pattern = ".*综.*合.*日.*报.*"
    Dim Title As String
    Dim h As New help
    Dim sh As Object
    For Each sh In wb.Worksheets
'        debug.print sh.name
        Title = sh.Cells(1, 1).value
        If h.isMatch(pattern, Title) Then
'        采集生产日报内数据
            Dim temp
            temp = sh.Cells(2, 1).value
            Dim aim As String
            aim = "日期:"
            Dim pos As Integer
            Dim length As Integer
            pos = InStr(temp, aim)
'            Debug.Print pos & vbTab & Len(temp) & vbTab & Right(temp, Len(temp) - pos - 2)
            Dim 日期 As Date
'            Debug.Print IsDate(Right(temp, Len(temp) - pos + 1 - 3))
            If IsDate(Right(temp, Len(temp) - pos + 1 - 3)) Then
                日期 = CDate(Right(temp, Len(temp) - pos + 1 - 3))
'                Debug.Print 日期
                Dim row As Integer
                Dim column As Integer
                Dim offset As Integer
                Const rowLimit = 29
                Const columnLimit = 11
                Dim recordSC As New 生产信息
                For row = 3 To rowLimit
                    For column = 2 To columnLimit
'                        稳定区产气
                        If 4 = row And 2 = column Then
                            With recordSC
                                .日期 = 日期
                                .名称 = "稳定区产气"
                                .单位 = "方"
                                offset = 1
                                .数据 = sh.Cells(row, column).value
                                .类别 = "天然气"
                                .状态 = "生产"
'                                .月累 = 0
'                                .年累 = 0
'                                .备注 = ""
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
    '                        Debug.Print recordSC.content
                            Set recordSC = Nothing
                        End If
'                    轻油
'                    V-631A,B,C 轻油罐
                    temp = sh.Cells(row, column).value
                    If h.isMatch("V-631[ABC]", temp) Then
'                       液位
                        With recordSC
                            .日期 = 日期
                            .名称 = temp
                            .单位 = "米"
                            offset = 1
                            .数据 = sh.Cells(row, column + offset).value
                            .类别 = "轻油"
                            .状态 = "库存"
'                            .备注=""
                            .数据源 = fname
                        End With
                        table.Add recordSC, ""
'                        Debug.Print recordSC.content
                        Set recordSC = Nothing
'                        库存t
                        With recordSC
                            .日期 = 日期
                            .名称 = temp
                            .单位 = "吨"
                            offset = 2
                            .数据 = sh.Cells(row, column + offset).value
                            .类别 = "轻油"
                            .状态 = "库存"
                            .数据源 = fname
                        End With
                        table.Add recordSC, ""
'                        Debug.Print recordSC.content
                        Set recordSC = Nothing
                    End If
'                    轻油库存
                    If 7 = row And 9 = column Then
                        With recordSC
                            .日期 = 日期
                            .名称 = "轻油库存合计"
                            .单位 = "吨"
                            .数据 = sh.Cells(row, column).value
                            .类别 = "轻油"
                            .状态 = "库存"
                            .数据源 = fname
                        End With
                        table.Add recordSC, ""
'                        Debug.Print recordSC.content
                        Set recordSC = Nothing
                    End If
'                    轻油处理量
                   If 5 = row And 9 = column Then
                        With recordSC
                            .日期 = 日期
                            .名称 = "轻油处理量"
                            .单位 = "方"
                            .数据 = sh.Cells(row, column).value
                            .类别 = "轻油"
                            .状态 = "接收"
                            .数据源 = fname
                        End With
                        table.Add recordSC, ""
'                        Debug.Print recordSC.content
                        Set recordSC = Nothing
                    End If
'                    轻油回收量t
'                    If 20 = row And h.isMatch(".*轻油回收量.*", temp) Then
                    If 6 = row And 9 = column Then
                        With recordSC
                            .日期 = 日期
                            .名称 = "轻油回收量"
                            .单位 = "吨"
                            .数据 = sh.Cells(row, column).value
                            .类别 = "轻油"
                            .状态 = "生产"
                            .数据源 = fname
                        End With
                        table.Add recordSC, ""
'                        Debug.Print recordSC.content
                        Set recordSC = Nothing
                    End If
'                    轻油装车t
                    If 13 = row And 2 = column Then
                        With recordSC
                            .日期 = 日期
                            .名称 = "轻油装车"
                            .单位 = "吨"
                            .数据 = sh.Cells(row, column).value
                            .类别 = "轻油"
                            .状态 = "外输"
                            .数据源 = fname
                        End With
                        table.Add recordSC, ""
'                        Debug.Print recordSC.content
                        Set recordSC = Nothing
                    End If
'                    轻油装车bbl
                    If 13 = row And 3 = column Then
                        With recordSC
                            .日期 = 日期
                            .名称 = "轻油装车"
                            .单位 = "桶"
                            .数据 = sh.Cells(row, column).value
                            .类别 = "轻油"
                            .状态 = "外输"
                            .数据源 = fname
                        End With
                        table.Add recordSC, ""
'                        Debug.Print recordSC.content
                        Set recordSC = Nothing
                    End If
'                    丙丁烷
                    If h.isMatch("^V-64[13][AB]$|^V-642$", temp) Then
'                       液位
                        With recordSC
                            .日期 = 日期
                            .名称 = temp
                            .单位 = "米"
                            offset = 1
                            .数据 = sh.Cells(row, column + offset).value
                            .类别 = "丙丁烷"
                            .状态 = "库存"
'                            .备注=""
                            .数据源 = fname
                        End With
                        table.Add recordSC, ""
'                        Debug.Print recordSC.content
                        Set recordSC = Nothing
'                        库存t
                        With recordSC
                            .日期 = 日期
                            .名称 = temp
                            .单位 = "吨"
                            offset = 2
                            .数据 = sh.Cells(row, column + offset).value
                            .类别 = "丙丁烷"
                            .状态 = "库存"
                            .数据源 = fname
                        End With
                        table.Add recordSC, ""
'                        Debug.Print recordSC.content
                        Set recordSC = Nothing
                    End If
'                    丙烷库存
'                    库存t
                    If 6 = row And 11 = column Then
                        With recordSC
                            .日期 = 日期
                            .名称 = "丙烷罐库存"
                            .单位 = "吨"
                            .数据 = sh.Cells(row, column).value
                            .类别 = "丙丁烷"
                            .状态 = "库存"
                            .备注 = "丙烷"
                            .数据源 = fname
                        End With
                        table.Add recordSC, ""
'                        Debug.Print recordSC.content
                        Set recordSC = Nothing
                    End If
'                    液化气库存
'                    库存t
                    If 7 = row And 11 = column Then
                        With recordSC
                            .日期 = 日期
                            .名称 = "液化气罐库存"
                            .单位 = "吨"
                            .数据 = sh.Cells(row, column).value
                            .类别 = "丙丁烷"
                            .状态 = "库存"
                            .备注 = "液化气"
                            .数据源 = fname
                        End With
                        table.Add recordSC, ""
'                        Debug.Print recordSC.content
                        Set recordSC = Nothing
                    End If
'                    轻烃库存
'                    库存t
                    If 8 = row And 11 = column Then
                        With recordSC
                            .日期 = 日期
                            .名称 = "轻烃库存"
                            .单位 = "吨"
                            .数据 = sh.Cells(row, column).value
                            .类别 = "丙丁烷"
                            .状态 = "库存"
                            .备注 = "轻烃"
                            .数据源 = fname
                        End With
                        table.Add recordSC, ""
'                        Debug.Print recordSC.content
                        Set recordSC = Nothing
                    End If
'                    丙烷装车t
                    If 15 = row And 2 = column Then
'                        Debug.Print "修改位置=" & 修改位置
                            With recordSC
                                .日期 = 日期
                                .名称 = "丙烷装车"
                                .单位 = "吨"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "丙丁烷"
                                .状态 = "外输"
'                                .备注 = ""
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            Debug.Print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    丙烷装车m3
                    If 15 = row And 3 = column Then
'                    Debug.Print "修改位置=" & 修改位置
                            With recordSC
                                .日期 = 日期
                                .名称 = "丙烷装车"
                                .单位 = "方"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "丙丁烷"
                                .状态 = "外输"
'                                .备注 = "丙烷"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            Debug.Print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    丁烷装车t
                    If 16 = row And 2 = column Then
'                    Debug.Print "修改位置=" & 修改位置
                            With recordSC
                                .日期 = 日期
                                .名称 = "丁烷装车"
                                .单位 = "吨"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "丙丁烷"
                                .状态 = "外输"
'                                .备注 = "丙烷"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            Debug.Print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    丁烷装车m3
                    If 16 = row And 3 = column Then
'                    Debug.Print "修改位置=" & 修改位置
                            With recordSC
                                .日期 = 日期
                                .名称 = "丁烷装车"
                                .单位 = "方"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "丙丁烷"
                                .状态 = "外输"
'                                .备注 = "丙烷"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            Debug.Print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    液化气装车t
                    If 14 = row And 2 = column Then
'                    Debug.Print "修改位置=" & 修改位置
                            With recordSC
                                .日期 = 日期
                                .名称 = "液化气装车"
                                .单位 = "吨"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "丙丁烷"
                                .状态 = "外输"
'                                .备注 = "丙烷"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            Debug.Print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    液化气装车m3
                    If 14 = row And 3 = column Then
'                    Debug.Print "修改位置=" & 修改位置
                            With recordSC
                                .日期 = 日期
                                .名称 = "液化气装车"
                                .单位 = "方"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "丙丁烷"
                                .状态 = "外输"
'                                .备注 = "丙烷"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            Debug.Print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    丙丁烷回收量t
                    If 5 = row And 11 = column Then
'                    Debug.Print "修改位置=" & 修改位置
                            With recordSC
                                .日期 = 日期
                                .名称 = "丙丁烷回收量"
                                .单位 = "吨"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "丙丁烷"
                                .状态 = "生产"
'                                .备注 = "丙烷"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            Debug.Print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    化学药剂
'                    乙二醇浓度
                    If 19 = row And 3 = column Then
'                    Debug.Print "修改位置=" & 修改位置
                            With recordSC
                                .日期 = 日期
                                .名称 = "乙二醇浓度"
'                                .单位 = ""
                                .数据 = sh.Cells(row, column).value
                                .类别 = "化学药剂"
                                .状态 = "生产"
'                                .备注 = "丙烷"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            debug.print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    乙二醇回收
                    If 18 = row And 3 = column Then
'                    Debug.Print "修改位置=" & 修改位置
                            With recordSC
                                .日期 = 日期
                                .名称 = "乙二醇回收"
                                .单位 = "方"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "化学药剂"
'                                .备注 = "丙烷"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            debug.print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    水
'                    外供水
                    If 16 = row And 11 = column Then
'                    Debug.Print "修改位置=" & 修改位置
                            With recordSC
                                .日期 = 日期
                                .名称 = "外供水"
                                .单位 = "方"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "水"
                                .状态 = "接收"
'                                .备注 = "丙烷"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            Debug.Print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    水消耗
                    If 15 = row And 11 = column Then
                            With recordSC
                                .日期 = 日期
                                .名称 = "水消耗"
                                .单位 = "方"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "水"
                                .状态 = "消耗"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
                            'debug.print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    库存水液位
                    If 13 = row And 11 = column Then
                            With recordSC
                                .日期 = 日期
                                .名称 = "库存水"
                                .单位 = "米"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "水"
                                .状态 = "库存"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
                            'debug.print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    库存水m3
                    If 14 = row And 11 = column Then
                            With recordSC
                                .日期 = 日期
                                .名称 = "库存水"
                                .单位 = "方"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "水"
                                .状态 = "库存"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            Debug.Print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    电
'                    外供电
                    If 11 = row And 11 = column Then
                            With recordSC
                                .日期 = 日期
                                .名称 = "外供电"
                                .单位 = "度"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "电"
                                .状态 = "接收"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            Debug.Print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    自发电
                    If 12 = row And 11 = column Then
                            With recordSC
                                .日期 = 日期
                                .名称 = "自发电"
                                .单位 = "度"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "电"
                                .状态 = "生产"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            Debug.Print recordSC.content
                            Set recordSC = Nothing
                    End If
'                    电消耗
                    If 10 = row And 11 = column Then
                            With recordSC
                                .日期 = 日期
                                .名称 = "电消耗"
                                .单位 = "度"
                                .数据 = sh.Cells(row, column).value
                                .类别 = "电"
                                .状态 = "消耗"
                                .数据源 = fname
                            End With
                            table.Add recordSC, ""
'                            Debug.Print recordSC.content
                            Set recordSC = Nothing
                    End If
                    
                    Next column
                Next row
            Else
                Debug.Print temp & vbTab & "提取日期失败!" & vbTab & fname
                Exit Sub '日期不正确，停止数据采集
            End If
        End If
    Next sh
    wb.Close False
    Set wb = Nothing
    Application.ScreenUpdating = True
End Sub
'批量导入到生产信息表
Public Sub batchIntoDB()
'    On Error Resume Next
    Dim fname As String
    Const name = "葫芦岛天然气处理厂.mdb"
'    Debug.Print ActiveWorkbook.Path
    fname = ThisWorkbook.path & Application.PathSeparator & name
'    Debug.Print fname
    Dim tablename As String
    tablename = "生产信息"
'    Debug.Print Command & tableName & content
    
    Dim F As New 文件目录
    Dim backupDir As String
    backupDir = F.pathSelect
    If "" = backupDir Then
        Exit Sub
    End If
    Dim fileList As Object
    Set fileList = CreateObject("Scripting.Dictionary")
    Dim pattern As String
    pattern = ".*xls$"
    Call F.FindFiles(backupDir, pattern, fileList)
'    Debug.Print "找到" & fileList.count & "文件！"
    Dim temp
    Dim table As Object
    Set table = CreateObject("Scripting.Dictionary")
    Dim JH As New 综合日报
    For Each temp In fileList.Keys
'        Debug.Print temp
        Call JH.getValue(temp, table)
    Next temp
'    Debug.Print "在综合日报里,一共收集了" & table.count & "条记录！"
    Dim scxx As New 生产信息
    Call scxx.PushTableToDatabase(table)
'    Dim recordSC
'    For Each recordSC In table.keys
'        Debug.Print recordSC.content
'    Next

End Sub


