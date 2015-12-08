VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "help"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'ɾ�����б��ڹ�ʽ
Sub AllFormulaToValue()
    For Each sh In Sheets
        sh.UsedRange = sh.UsedRange.value
    Next
End Sub
'ɾ�����к�
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
Sub �Զ�������()
  Dim tempForm As Object
  Set tempForm = ThisWorkbook.VBProject.VBComponents.Add(3) '��������
  With tempForm
       .Properties("width") = 500 '����Ŀ���
       .Properties("height") = 500 '����ĸ߶�
  End With
  VBA.UserForms.Add(tempForm.name).Show '��ʾ����
  
  ThisWorkbook.VBProject.VBComponents.Remove tempForm '�رմ���
End Sub
'�Ƿ����ָ��������
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
'����ƥ��
Public Function isMatch(ByVal pattern As String, ByVal s As String) As Boolean
    Dim regex As Object
    Set regex = CreateObject("VBScript.RegexP")    'ȫ����Ŀ¼
    With regex
        .Global = True
        .pattern = pattern
    End With
'    Debug.Print regex.test(s)
    isMatch = regex.test(s)
End Function
'�����滻
Public Function replace(ByVal s As String, ByVal pattern As String, ByVal value As String) As String
     Dim regex As Object
    Set regex = CreateObject("VBScript.RegexP")    'ȫ����Ŀ¼
    With regex
        .Global = True
'        .MultiLine = True
        .pattern = pattern
        replace = .replace(s, value)
    End With
End Function
'�Ƿ�����Ȩ
Public Function checkRight(ByVal s As String) As Boolean
    Const password = "���ղ���"
    checkRight = (password = s)
End Function
'�����༶Ŀ¼
Public sub sMkDir(ByVal s as string)
    dim pt as variant
    pt() = Split(s, "\")
    debug.print pt
end sub