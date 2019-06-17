VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet8"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private Sub 查询_Click()
On Error GoTo handler
    Dim sd As String
    Dim d As Date
    sd = InputBox("请输入指定日期：", "查询指定日期的提单月报", DateValue(Now))
    If False = IsDate(sd) Then
        MsgBox "日期不正确!"
        Exit Sub
    End If
    d = CDate(sd)
    Worksheets("提单月报").Select
    Call Worksheets("提单月报").清除_Click
    Dim lastRow, lastColumn, beginRow, beginColumn As Long
    beginRow = 4
    beginColumn = 1
'    Dim ac As New access
    Dim pgsql As New PostgreSQL
    Dim SQL As String
    Dim filter As String
    Dim tablename As String
    Dim 开始日期, 结束日期, 日期 As Date
    结束日期 = d
    开始日期 = DateSerial(Year(结束日期), Month(结束日期), 1)
    tablename = "提单"
    Dim offset As Long
    Dim i As Long
    For i = 0 To DateDiff("d", 开始日期, 结束日期)
        offset = 0
        日期 = DateAdd("d", i, 开始日期)
        Cells(beginRow + i, 1).value = 日期
'        丙烷
        filter = " and 产品名称='丙烷' "
        SQL = "select count(*) from " & tablename & " where 日期='" & 日期 & "'" & filter
        offset = offset + 1
        Cells(beginRow + i, beginColumn + offset).CopyFromRecordset pgsql.cnn.Execute(SQL)
        SQL = "select count(装车数量) from " & tablename & " where 日期='" & 日期 & "'" & filter
        offset = offset + 1
        Cells(beginRow + i, beginColumn + offset).CopyFromRecordset pgsql.cnn.Execute(SQL)
'        丁烷
        filter = " and 产品名称='丁烷' "
        SQL = "select count(*) from " & tablename & " where 日期='" & 日期 & "'" & filter
        offset = offset + 1
        Cells(beginRow + i, beginColumn + offset).CopyFromRecordset pgsql.cnn.Execute(SQL)
        SQL = "select sum(装车数量) from " & tablename & " where 日期='" & 日期 & "'" & filter
        offset = offset + 1
        Cells(beginRow + i, beginColumn + offset).CopyFromRecordset pgsql.cnn.Execute(SQL)
'        液化气
        filter = " and 产品名称='液化气' "
        SQL = "select count(*) from " & tablename & " where 日期='" & 日期 & "'" & filter
        offset = offset + 1
        Cells(beginRow + i, beginColumn + offset).CopyFromRecordset pgsql.cnn.Execute(SQL)
        SQL = "select sum(装车数量) from " & tablename & " where 日期='" & 日期 & "'" & filter
        offset = offset + 1
        Cells(beginRow + i, beginColumn + offset).CopyFromRecordset pgsql.cnn.Execute(SQL)
'        轻油
        filter = " and 产品名称='轻油' "
        SQL = "select count(*) from " & tablename & " where 日期='" & 日期 & "'" & filter
        offset = offset + 1
        Cells(beginRow + i, beginColumn + offset).CopyFromRecordset pgsql.cnn.Execute(SQL)
        SQL = "select sum(装车数量) from " & tablename & " where 日期='" & 日期 & "'" & filter
        offset = offset + 1
        Cells(beginRow + i, beginColumn + offset).CopyFromRecordset pgsql.cnn.Execute(SQL)
    Next i
'    装车数量没有则填零
    Dim row, column As Long
    lastRow = beginRow + DateDiff("d", 开始日期, 结束日期)
    lastColumn = 9
    Dim temp As Variant
    For row = beginRow To lastRow
        For column = beginColumn + 1 To lastColumn
            temp = Cells(row, column).value
            If IsEmpty(temp) Or IsNull(temp) Then
                Cells(row, column).value = 0
            End If
        Next column
    Next row
'年报
'select to_char(日期,'YYYY-MM') as d,产品名称,sum(实际装车t) as 装车合计t,sum(装车数量) as 装车数量合计 from 提单 where 日期 between '2018-1-1' and '2018-12-31' group by d,产品名称 order by d,产品名称;
    lastRow = ActiveSheet.UsedRange.Rows.count
    lastColumn = ActiveSheet.UsedRange.Columns.count
    Dim flag1, flag2 As String
    flag1 = "提单年报"
    flag2 = "月份"
    offset = 1
    i = 1
    Dim co As Long
    For row = beginRow To lastRow
        For column = beginColumn To lastColumn
        temp = Cells(row, column).value
        If temp = flag1 Then
            beginRow = row
            beginColumn = column
'            Debug.Print temp, row, column, lastRow, lastColumn
        End If
        If Cells(row - offset - i, column).value = flag2 Then
            If i <= Month(d) Then
'                丙烷
                SQL = "select sum(实际装车t) as 装车合计t from 提单 where date_part('month',日期)=" & i & " and 产品名称='丙烷' and date_part('year',日期)=date_part('year',timestamp '" & d & "')"
                temp = pgsql.cnn.Execute(SQL)(0)
                co = 1
                Cells(row, column + co).value = temp
                
                SQL = "select sum(数据) as 装车合计t from 生产信息 where date_part('month',日期)=" & i & " and 名称='丙烷装车' and date_part('year',日期)=date_part('year',timestamp '" & d & "') and 单位='方'"
                temp = pgsql.cnn.Execute(SQL)(0)
                co = 2
                Cells(row, column + co).value = temp
                
                SQL = "select sum(装车数量) as 装车合计t from 提单 where date_part('month',日期)=" & i & " and 产品名称='丙烷' and date_part('year',日期)=date_part('year',timestamp '" & d & "')"
                temp = pgsql.cnn.Execute(SQL)(0)
                co = 3
                Cells(row, column + co).value = temp
'                丁烷
                SQL = "select sum(实际装车t) as 装车合计t from 提单 where date_part('month',日期)=" & i & " and 产品名称='丁烷' and date_part('year',日期)=date_part('year',timestamp '" & d & "')"
                temp = pgsql.cnn.Execute(SQL)(0)
                co = 4
                Cells(row, column + co).value = temp
                
                SQL = "select sum(数据) as 装车合计t from 生产信息 where date_part('month',日期)=" & i & " and 名称='丁烷装车' and date_part('year',日期)=date_part('year',timestamp '" & d & "') and 单位='方'"
                temp = pgsql.cnn.Execute(SQL)(0)
                co = 5
                Cells(row, column + co).value = temp
                                
                SQL = "select sum(装车数量) as 装车合计t from 提单 where date_part('month',日期)=" & i & " and 产品名称='丁烷' and date_part('year',日期)=date_part('year',timestamp '" & d & "')"
                temp = pgsql.cnn.Execute(SQL)(0)
                co = 6
                Cells(row, column + co).value = temp
'                液化气
                SQL = "select sum(实际装车t) as 装车合计t from 提单 where date_part('month',日期)=" & i & " and 产品名称='液化气' and date_part('year',日期)=date_part('year',timestamp '" & d & "')"
                temp = pgsql.cnn.Execute(SQL)(0)
                co = 7
                Cells(row, column + co).value = temp
                
                SQL = "select sum(数据) as 装车合计t from 生产信息 where date_part('month',日期)=" & i & " and 名称='液化气装车' and date_part('year',日期)=date_part('year',timestamp '" & d & "') and 单位='方'"
                temp = pgsql.cnn.Execute(SQL)(0)
                co = 8
                Cells(row, column + co).value = temp
                                
                SQL = "select sum(装车数量) as 装车合计t from 提单 where date_part('month',日期)=" & i & " and 产品名称='液化气' and date_part('year',日期)=date_part('year',timestamp '" & d & "')"
                temp = pgsql.cnn.Execute(SQL)(0)
                co = 9
                Cells(row, column + co).value = temp
'                轻油
                SQL = "select sum(实际装车t) as 装车合计t from 提单 where date_part('month',日期)=" & i & " and 产品名称='轻油' and date_part('year',日期)=date_part('year',timestamp '" & d & "')"
                temp = pgsql.cnn.Execute(SQL)(0)
                co = 10
                Cells(row, column + co).value = temp
                
                SQL = "select sum(数据) as 装车合计t from 生产信息 where date_part('month',日期)=" & i & " and 名称='轻油装车' and date_part('year',日期)=date_part('year',timestamp '" & d & "') and 单位='方'"
                temp = pgsql.cnn.Execute(SQL)(0)
                co = 11
                Cells(row, column + co).value = temp
                
                SQL = "select sum(数据) as 装车合计t from 生产信息 where date_part('month',日期)=" & i & " and 名称='轻油装车' and date_part('year',日期)=date_part('year',timestamp '" & d & "') and 单位='桶'"
                temp = pgsql.cnn.Execute(SQL)(0)
                co = 12
                Cells(row, column + co).value = temp
                                                
                SQL = "select sum(装车数量) as 装车合计t from 提单 where date_part('month',日期)=" & i & " and 产品名称='轻油' and date_part('year',日期)=date_part('year',timestamp '" & d & "')"
                temp = pgsql.cnn.Execute(SQL)(0)
                co = 13
                Cells(row, column + co).value = temp
                
                i = i + 1
                Exit For
            End If
'            Debug.Print temp, row, column, offset, i
        End If
'        Debug.Print row, column
        Next column
    Next row
handler:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub 工艺_Click()
    Worksheets("工艺生产").Select
End Sub

Public Sub 清除_Click()
    Dim lastRow, lastColumn, beginRow, beginColumn As Long
    beginRow = 4
    beginColumn = 1
    lastRow = 34
    lastColumn = 9
    Range(Cells(beginRow, beginColumn), Cells(lastRow, lastColumn)).ClearContents
    
    beginRow = 11
    beginColumn = 12
    lastRow = 22
    lastColumn = 24
    Range(Cells(beginRow, beginColumn), Cells(lastRow, lastColumn)).ClearContents
End Sub

Private Sub 提单_Click()
    Worksheets("提单").Select
End Sub

Private Sub 主页_Click()
    Worksheets("主页").Select
End Sub
