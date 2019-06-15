'删除所有表内公式
Sub AllFormulaToValue()
    For Each sh In Sheets
        sh.UsedRange = sh.UsedRange.value
    Next
End Sub
'删除所有宏
Sub removeAllMacro(ByVal fname As String)
    Application.DisplayAlerts = False
    Dim wb As Object
    Set wb = Workbooks.Open(fname)
    Debug.Print fname
    
    For i = 1 To wb.VBProject.VBComponents.count
        With wb.VBProject.VBComponents(i).CodeModule
        .DeleteLines 1, .CountOfLines
        End With
    Next
    Debug.Print ActiveWorkbook.FullName
    Dim Vbc As Object
    For Each Vbc In Application.ActiveWorkbook.VBProject.VBComponents
        Select Case Vbc.Type
            Case 1, 2, 3
                With Application.VBE.ActiveVBProject.VBComponents
                    .Remove .item(Vbc.name)
                End With
        End Select
    Next
    
    Application.DisplayAlerts = True
    wb.Close SaveChanges:=True
End Sub
Sub 自动建窗体()
  Dim tempForm As Object
  Set tempForm = ThisWorkbook.VBProject.VBComponents.Add(3) '创建窗体
  With tempForm
       .Properties("width") = 500 '窗体的宽度
       .Properties("height") = 500 '窗体的高度
  End With
  VBA.UserForms.Add(tempForm.name).Show '显示窗体
  
  ThisWorkbook.VBProject.VBComponents.Remove tempForm '关闭窗体
End Sub
'是否存在指定工作表
Public Function hasSheet(ByVal name As String, ByRef wb As Workbook) As Boolean
    Dim sh As Worksheet
    hasSheet = False
    For Each sh In wb.Worksheets
        If name = sh.name Then
            hasSheet = True
        End If
    Next sh
'    Debug.Print hasSheet
End Function

Public Function isMatch(ByVal pattern As String, ByVal s As String) As Boolean
    Dim regEx As Object
    Set regEx = CreateObject("VBScript.RegexP")    '全部子目录
    With regEx
        .Global = True
        .pattern = pattern
    End With
'    Debug.Print regex.test(s)
    isMatch = regEx.test(s)
End Function
Public Function replace(ByVal s As String, ByVal pattern As String, ByVal value As String) As String
     Dim regEx As Object
    Set regEx = CreateObject("VBScript.RegexP")    '全部子目录
    With regEx
        .Global = True
'        .MultiLine = True
        .pattern = pattern
        replace = .replace(s, value)
    End With
End Function

Public Function search(ByVal strData As String, ByVal pattern As String) As String
    Dim RE As Object, REMatches As Object
    Set RE = CreateObject("vbscript.regexp")
    With RE
        .MultiLine = False
        .Global = False
        .IgnoreCase = True
        .pattern = pattern
    End With
    Set REMatches = RE.Execute(strData)
    search = REMatches(0)
End Function

Public Function checkRight(ByVal s As String) As Boolean
    Const password = "工艺操作"
    checkRight = (password = s)
End Function
Public Function isString(s) As Boolean
    If TypeName(s) = "String" Then
        isString = True
    Else
        isString = False
    End If
End Function
' 得到一个行列互换的2维数组
Function transpose2DArray(inputArray As Variant) As Variant
    Dim x As Long, yUbound As Long
    Dim y As Long, xUbound As Long
    Dim tempArray As Variant

    xUbound = UBound(inputArray, 2)
    yUbound = UBound(inputArray, 1)
    
    ReDim tempArray(0 To xUbound, 0 To yUbound)
    
    For x = 0 To xUbound
        For y = 0 To yUbound
            tempArray(x, y) = inputArray(y, x)
        Next y
    Next x
    
    transpose2DArray = tempArray
End Function
' 2维数组变字典
Public Sub array2dic(arr As Variant, ByRef data As Object)
    '// add declarations
    On Error GoTo catchError
    Dim index, name, value As Variant
    For index = 0 To UBound(arr)
        name = arr(index, 0)
        value = arr(index, 1)
        data(name) = value
    Next index
exitSub:
    Exit Sub
catchError:
    '// add error handling
    GoTo exitSub
End Sub

Function password()
   Dim sd As String
   sd = InputBox("请输入密码：", "危险操作！", "******")
   If "工艺操作" <> sd Then
       MsgBox "密码不对！禁止危险操作！"
       password = False
    Else
        password = True
   End If
End Function
