VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet20"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Private Sub 查询_Click()
On Error GoTo handler
    Call 清除_Click
    Dim sd As String
    Dim 日期 As Date
    sd = InputBox("请输入指定日期：", "查询指定日期的12寸海管跟踪数据", DateAdd("d", -1, DateValue(Now)))
'    sd = InputBox("请输入指定日期：", "查询指定日期的12寸海管跟踪数据", "2015-12-3")
    If False = IsDate(sd) Then
        MsgBox "日期不正确!"
        Exit Sub
    End If
    日期 = CDate(sd)
    Dim row, column, ro, co, beginRow, beginColumn, lastRow, lastColumn As Long
    beginRow = 1
    beginColumn = 1
    lastRow = UsedRange.Rows.count
    lastColumn = UsedRange.Columns.count
    Dim temp, td As Variant
    Dim SQL As String
    Dim psql As New PostgreSQL
    For row = beginRow To lastRow
        For column = beginColumn To lastColumn
            temp = Cells(row, column).value
            If temp = "日期" Then
                ro = 2
                Cells(row + ro, column).value = 日期
            End If
            If temp Like "*日处理油量*" Then
                SQL = "select 数据 from 生产信息 where 日期='" & 日期 & "' and 名称='轻油处理量' and 单位='方'"
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
            End If
            If temp Like "*轻油*日产量*" Then
                SQL = "select 数据 from 生产信息 where 日期='" & 日期 & "' and 名称='轻油回收量' and 单位='方'"
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
            End If
            If temp Like "*V-601*密度*" Then
                SQL = "select 数据 from 生产信息 where 日期='" & 日期 & "' and 名称='海管来液密度' and 单位='kg/m3'"
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
            End If
            If temp Like "V-601底部(凝固点℃)" Then
                SQL = "select 数据 from 生产信息 where 日期='" & 日期 & "' and 名称='海管出口凝点' and 单位='摄氏度' and 备注='上午' "
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
                co = 1
                SQL = "select 数据 from 生产信息 where 日期='" & 日期 & "' and 名称='海管出口凝点' and 单位='摄氏度' and 备注='上午'"
                td = psql.cnn.Execute(SQL)(0)
                Cells(row + ro, column + co).value = td
            End If
            If temp Like "V-601底部（PH值）" Then
                SQL = "select min(数据) from 生产信息 where 日期='" & 日期 & "' and 名称='海管出口PH值' "
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
            End If
            If temp Like "V-601底部锦州21-1海管通球后凝固点℃" Then
                SQL = "select min(数据) from 生产信息 where 日期='" & 日期 & "' and 名称='通球后凝固点' and 单位='摄氏度' "
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
            End If
            If temp Like "V-631罐内（密度）" Then
                SQL = "select min(数据) from 生产信息 where 日期='" & 日期 & "' and 名称='轻油比重' "
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
            End If
            If temp Like "V-631罐内（凝固点℃）" Then
                SQL = "select min(数据) from 生产信息 where 日期='" & 日期 & "' and 名称='外输凝点' and 单位='摄氏度'"
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
            End If
            If temp Like "稳定塔底操作温度（℃）" Then
                SQL = "select min(数据) from 生产信息 where 日期='" & 日期 & "' and 名称='E-615温度' and 单位='摄氏度'"
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
            End If
            If temp Like "轻油饱和蒸汽压（kpa.37.8℃）" Then
                SQL = "select min(数据) from 生产信息 where 日期='" & 日期 & "' and 名称='E-613饱和蒸汽压' and 单位='千帕'"
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
            End If
            If temp Like "热油伴热工作情况" Then
                SQL = "select min(数据) from 生产信息 where 日期='" & 日期 & "' and 名称='热油伴热工作情况' "
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
            End If
            If temp Like "MEG浓度（%）" Then
                SQL = "select 数据 from 生产信息 where 日期='" & 日期 & "' and 名称='海管MEG浓度' and 备注='上午'"
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
                SQL = "select 数据 from 生产信息 where 日期='" & 日期 & "' and 名称='海管MEG浓度' and 备注='下午'"
                td = psql.cnn.Execute(SQL)(0)
                co = 1
                Cells(row + ro, column + co).value = td
            End If
            If temp Like "原油含水（%）" Then
                SQL = "select 数据 from 生产信息 where 日期='" & 日期 & "' and 名称='海管来液含水' and 备注='上午' "
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
                SQL = "select 数据 from 生产信息 where 日期='" & 日期 & "' and 名称='海管来液含水' and 备注='下午' "
                td = psql.cnn.Execute(SQL)(0)
                co = 1
                Cells(row + ro, column + co).value = td
            End If
            If temp Like "通球记录" Then
                SQL = "select min(数据) from 生产信息 where 日期='" & 日期 & "' and 名称='上下游12吋海管通球' "
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
            End If
            If temp Like "乙二醇（m3）" Then
                SQL = "select min(数据) from 生产信息 where 日期='" & 日期 & "' and 名称='乙二醇库存' and 单位='方' "
                td = psql.cnn.Execute(SQL)(0)
                ro = 2
                Cells(row + ro, column).value = td
                SQL = "select min(数据) from 生产信息 where 日期='" & 日期 & "' and 名称='乙二醇死库存' and 单位='方' "
                td = psql.cnn.Execute(SQL)(0)
                co = 1
                Cells(row + ro, column + co).value = td
            End If
        Next column
    Next row
handler:
    If Err.Number <> 0 Or Err.Number <> 20 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 工艺_Click()
On Error Resume Next
    Worksheets("工艺生产").Select
End Sub

Private Sub 清除_Click()
On Error Resume Next
    Dim row, column, ro, beginRow, beginColumn, lastRow, lastColumn As Long
    beginRow = 1
    beginColumn = 1
    lastRow = UsedRange.Rows.count
    lastColumn = UsedRange.Columns.count
    Dim temp As Variant
    For row = beginRow To lastRow
        For column = beginColumn To lastColumn
            temp = Cells(row, column).value
            If temp = "日期" Then
                ro = 2
                Range(Cells(row + ro, beginColumn), Cells(row + ro, lastColumn)).ClearContents
                Exit Sub
            End If
        Next column
    Next row
End Sub
