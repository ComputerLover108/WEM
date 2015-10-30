VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "化验单"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public Sub getValue(ByVal fname As String, table)
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
