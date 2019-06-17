VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet21"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Private Sub 查询_Click()
    Err.Clear
On Error GoTo handler
    Dim psql As New PostgreSQL
    Dim d, de, 下月初, 本月底 As Date
    d = InputBox("请输入指定日期：", "生产年报年报", Format(Now, "YYYY"))
    Dim SQL As String
'    删除无效数据（FIQ-5014）
    SQL = "delete from 生产动态 where 名称='FIQ-5014' and 数据=0;"
    Call psql.cnn.Execute(SQL)
    
    SQL = "select max(时间) from 生产动态 where 时间 between '" & DateSerial(d, 1, 1) & "' and '" & DateSerial(d, 12, 31) & "'"
    de = psql.cnn.Execute(SQL)(0)
'    Debug.Print de
    Dim row, column, ro, co, beginRow, beginColumn, lastRow, lastColumn As Long

    beginRow = 2
    beginColumn = 1
    
    lastColumn = 21
    Cells(beginRow, beginColumn).value = d
    beginRow = 3
    lastRow = DatePart("m", de)
    For ro = 1 To lastRow
        For column = beginColumn To lastColumn
            If column = 1 Then
                下月初 = DateAdd("m", 1, DateSerial(d, ro, 1))
                本月底 = DateAdd("d", -1, 下月初)
                Cells(beginRow + ro, column).value = Format(本月底, "MM月")
            End If
            If Cells(beginRow, column).value Like "锅炉用气*" Then
                本月初 = DateSerial(d, ro, 1)
                下月初 = DateAdd("m", 1, DateSerial(d, ro, 1))
                本月底 = DateAdd("d", -1, 下月初)
                SQL = "select min(时间) from 生产动态 where 名称='FIQ-5014'  and 时间 between '" & 本月初 & "' and '" & 本月底 & "';"
                t1 = psql.cnn.Execute(SQL)(0)
                SQL = "select max(时间) from 生产动态 where 名称='FIQ-5014'  and 时间 between '" & 本月初 & "' and '" & 本月底 & "';"
                t2 = psql.cnn.Execute(SQL)(0)
                SQL = "select 数据 from 生产动态 where 名称='FIQ-5014' and 时间='" & t1 & "';"
                月初数据 = psql.cnn.Execute(SQL)(0)
                SQL = "select 数据 from 生产动态 where 名称='FIQ-5014' and 时间='" & t2 & "';"
                月底数据 = psql.cnn.Execute(SQL)(0)
                月累 = 月底数据 - 月初数据
                If 月累 < 0 Then
                    月累 = 月累 + 1000000
                End If
                Cells(beginRow + ro, column).value = 月累 / 10000
                If t1 <> 本月初 Or t2 <> 本月底 Then
                    Cells(beginRow + ro, column).Interior.ColorIndex = 6
                End If
                Debug.Print t1, 月初数据, t2, 月底数据, 月累
            End If
        Next column
    Next ro
    beginRow = 19
    beginColumn = 2
    SQL = "select 时间 from 生产动态 where 名称='FIQ-5014' and  数据=0 and 时间 between '" & DateSerial(d, 1, 1) & "' and '" & DateSerial(d + 1, 1, 1) & "' ;"
    Cells(beginRow, beginColumn).CopyFromRecordset psql.cnn.Execute(SQL)
handler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub

Private Sub 工艺生产_Click()
    Sheets("工艺生产").Select
End Sub

Private Sub 清除_Click()
    Dim beginRow, beginColumn, lastRow, lastColumn As Long
    beginRow = 2
    beginColumn = 1
    lastRow = 15
    lastColumn = 21
'    Cells(beginRow, beginColumn).Clear
    beginRow = 4
    Range(Cells(beginRow, beginColumn), Cells(lastRow, lastColumn)).Clear
    
    beginRow = 19
    lastRow = ActiveSheet.UsedRange.Columns(ActiveSheet.UsedRange.Columns.count).row
    lastRow = ActiveSheet.UsedRange.Rows(ActiveSheet.UsedRange.Rows.count).row
    Range(Cells(beginRow, beginColumn), Cells(lastRow, lastColumn)).Clear
End Sub
