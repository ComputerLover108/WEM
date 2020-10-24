VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "生产月报"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public Sub 填数()
    Dim 日期 As Date
    Dim temp As String
    temp = Format(Worksheets("生产月报").Cells(2, 19).value, "YYYY-MM-DD")
    If False = IsDate(temp) Then
        MsgBox 日期 & "不是正确的日期格式!"
        Exit Sub
    End If
    Dim t As New 时间
'    日期 = T.getMonthEnd(temp)
    日期 = CDate(temp)
    Dim 月初 As Date
    月初 = DateSerial(Year(日期), Month(日期), 1)
    Dim filter As String
    filter = " WHERE 日期 between '" & 月初 & "' and '" & 日期 & "'"
    Dim SQL As String
    Dim showFields As String
    showFields = "数据"
    Dim filterA As String
'    Dim ac As New access
    Dim psql As New PostgreSQL
    Dim row As Integer
    Dim column As Integer
'    填充日期
    row = 6
    Dim x As Date
    x = 月初
    Do
        Cells(row, 1).value = Day(x)
        filter = " WHERE 日期 = '" & DateSerial(Year(月初), Month(月初), Day(x)) & "'"
'    辅助计算表
        For column = 24 To 26
    '        丙烷m3
            If 24 = column Then
                filterA = " and 名称='丙烷装车' and 单位='方' "
            End If
    '        丁烷m3
            If 25 = column Then
                filterA = " and 名称='丁烷装车' and 单位='方' "
            End If
    '        液化气m
            If 26 = column Then
                filterA = " and 名称='液化气装车' and 单位='方' "
            End If
            SQL = " SELECT " & showFields & " FROM 生产信息 " & filter & filterA
            Worksheets("生产月报").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
        Next column
'    填充表格
        Const columnLimit = 21
        For column = 2 To columnLimit
    '        大 化
            If 2 = column Then
                filterA = " and 名称='锦天化' and 单位='方' "
            End If
    '        民用气
            If 3 = column Then
                filterA = " and 名称='新奥燃气' and 单位='方' "
            End If
    '        自用量
            If 4 = column Then
                filterA = " and 名称='自用气' and 单位='方' "
            End If
    '        污水处理厂
            If 5 = column Then
                filterA = " and 名称='污水处理厂' and 单位='方' "
            End If
    '        精细化工
            If 6 = column Then
                filterA = " and 名称='精细化工' and 单位='方' "
            End If
    '        轻油回收m3
            If 7 = column Then
                filterA = " and 名称='轻油回收量' and 单位='方' "
            End If
    '        丙丁烷回收t
            If 8 = column Then
                filterA = " and 名称='丙丁烷回收量' and 单位='吨' "
            End If
    '        丙丁烷回收m3
            If 9 = column Then
                filterA = " and 名称='丙丁烷回收量' and 单位='方' "
            End If
    '        轻油t
            If 10 = column Then
                filterA = " and 名称='轻油装车' and 单位='吨' "
            End If
    '        轻油m3
            If 11 = column Then
                filterA = " and 名称='轻油装车' and 单位='方' "
            End If
    '        轻油 (桶)
            If 12 = column Then
                filterA = " and 名称='轻油装车' and 单位='桶' "
            End If
    '        丙烷t
            If 13 = column Then
                filterA = " and 名称='丙烷装车' and 单位='吨' "
            End If
    '        丁烷t
            If 14 = column Then
                filterA = " and 名称='丁烷装车' and 单位='吨' "
            End If
    '        液化气t
            If 15 = column Then
                filterA = " and 名称='液化气装车' and 单位='吨' "
            End If
    '        丙丁液m3
            If 16 = column Then
                filterA = " and 名称='丙丁液m3' and 单位='方' "
            End If
    '        外供电
            If 17 = column Then
                filterA = " and 名称='外供电' and 单位='度' "
            End If
    '        自发电
            If 18 = column Then
                filterA = " and 名称='自发电' and 单位='度' "
            End If
    '        外供水
            If 19 = column Then
                filterA = " and 名称='外供水' and 单位='方' "
            End If
    '        自采水
            If 20 = column Then
                filterA = " and 名称='自采水' and 单位='方' "
            End If
    '        乙二醇回收
            If 21 = column Then
                filterA = " and 名称='乙二醇回收' and 单位='方' "
            End If
            SQL = " SELECT " & showFields & " FROM 生产信息 " & filter & filterA
'            Debug.Print SQL
            Worksheets("生产月报").Cells(row, column).CopyFromRecordset psql.cnn.Execute(SQL)
        Next column
        For column = 7 To 26
            Select Case column
                Case 7, 8, 9, 24, 25, 26
                Cells(row, column).value = Round(Cells(row, column).value, 2)
            End Select
        Next column
        row = row + 1
        x = DateAdd("d", 1, x)
    Loop Until x > 日期
'    填充丙丁液m3
    Dim bm As Double
    Dim dm As Double
    Dim ym As Double
    Dim pos As Integer
    Dim result As Double
    pos = 24
    For row = 6 To 36
         With Worksheets("生产月报")
            bm = .Cells(row, pos).value
            dm = .Cells(row, pos + 1).value
            ym = .Cells(row, pos + 2).value
            result = bm + dm + ym
            If result > 0 Then
                .Cells(row, 16).value = result
            End If
         End With
    Next row
'保留两位小数
End Sub
