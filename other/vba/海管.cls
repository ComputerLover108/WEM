VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "海管"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public 时间 As Date
Public 名称 As String
Public 单位 As String
Public 数据 As Double
Public 备注 As String

Public Sub 填数()
    Err.Clear
    On Error GoTo ErrorHandler
    Dim row As Integer
    Dim column As Integer
    Dim offset As Integer
    Dim 日期 As Date
    日期 = Now
    Dim dataBase As Object
    Dim ac As New access
'    Dim psql As New PostgreSQL
    Dim SQL As String
    Dim showFields As String
    Dim tableName As String
    showFields = "日期"
    tableName = "生产信息"
    Set dataBase = ac
'    填写日期
    Dim temp
    Dim columnLimit As Integer
    columnLimit = 17
    row = 5
    column = 1
    Dim 开始日期 As Date
    开始日期 = InputBox("请输入统计开始日期:", "日期", "2013-1-1")
    Dim filter As String
    filter = " where 日期 between #" & 开始日期 & "# and #" & Now() & "# "
    SQL = "select distinct 日期 from " & tableName & filter & " order by 日期 "
    Worksheets("12吋大海管").Cells(row, column).CopyFromRecordset ac.cnn.Execute(SQL)
    showFields = "数据"
    SQL = "select " & showFields & " from " & tableName
    Dim filterA As String
    row = 5
    For column = 2 To columnLimit
        With Worksheets("12吋大海管")
'        轻油处理量
            If 2 = column Then
                filterA = " and 名称='轻油处理量' and 单位='方' "
            End If
'        轻油回收量
            If 3 = column Then
                filterA = " and 名称='轻油回收量' and 单位='方' "
            End If
'        V-601底部密度
            If 4 = column Then
                filterA = " and 名称='V-601底部密度'  "
            End If
'        V-601底部凝固点上午
            If 5 = column Then
                filterA = " and 名称='轻油回收量' and 单位='方' "
            End If
'        V-601底部凝固点下午
            If 3 = column Then
                filterA = " and 名称='轻油回收量' and 单位='方' "
            End If
'        V－601底部PH值
            If 3 = column Then
                filterA = " and 名称='轻油回收量' and 单位='方' "
            End If
'        "V-601底部锦州21-1海管通球后凝固点℃ ""
            If 3 = column Then
                filterA = " and 名称='轻油回收量' and 单位='方' "
            End If
'        "V-631罐内（密度）"
            If 3 = column Then
                filterA = " and 名称='轻油回收量' and 单位='方' "
            End If
'        "V-631罐内（凝固点℃）"
            If 3 = column Then
                filterA = " and 名称='轻油回收量' and 单位='方' "
            End If
'        稳定塔底操作温度（℃）
            If 3 = column Then
                filterA = " and 名称='轻油回收量' and 单位='方' "
            End If
'        轻油饱和蒸汽压（kpa.37.8℃）
            If 3 = column Then
                filterA = " and 名称='轻油回收量' and 单位='方' "
            End If
'        热油伴热工作情况
            If 3 = column Then
                filterA = " and 名称='轻油回收量' and 单位='方' "
            End If
'        MEG浓度（%）上午
            If 14 = column Then
                filterA = " and 名称='海管MEG浓度' and 备注 like '%上午%' "
            End If
'        MEG浓度（%）上午
            If 15 = column Then
                filterA = " and 名称='海管MEG浓度' and 备注 like '%下午%' "
            End If
'        原油含水（%）上午
            If 16 = column Then
                filterA = " and 名称='海管来液含水' and 备注 like '%上午%' "
            End If
'        原油含水（%）上午
            If 17 = column Then
                filterA = " and 名称='海管来液含水' and 备注 like '%下午%' "
            End If
            SQL = " select " & showFields & " from " & tableName & filter & filterA & "order by 日期 "
            Debug.Print column & SQL
            .Cells(row, column).CopyFromRecordset ac.cnn.Execute(SQL)
        End With
    Next column
    With Worksheets("12吋大海管")
'        通球备注
        filterA = " and 名称='上下游12吋海管通球' "
        SQL = " select replace(备注,'chr(13)+chr(10)','')  from " & tableName & filter & filterA & "order by 日期 "
        .Cells(row, 18).CopyFromRecordset ac.cnn.Execute(SQL)
'        备注
        filterA = " and 名称='生产备注'  "
        SQL = " select replace(备注,'chr(13)+chr(10)','') from " & tableName & filter & filterA & "order by 日期 "
        .Cells(row, 19).CopyFromRecordset ac.cnn.Execute(SQL)
    End With
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
'    If -2147467259 = Err.Number Then
'        Err.Clear
'        Resume LineDataBase
'    End If
    Resume Next

End Sub



