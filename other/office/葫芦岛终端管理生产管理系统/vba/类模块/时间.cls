VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "时间"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public Sub test()
    Debug.Print getMonthEnd("2012-1-1")
End Sub
'判断闰年
Public Function IsLeap(sd As String) As Boolean
'    Debug.Assert IsDate(d)
    Dim d As Date
    d = sd
    Dim sYear As String
    sYear = Year(d)
    Dim tempD As String
    tempD = sYear & "-02-29"
    Debug.Print tempD
    If IsDate(tempD) Then
        IsLeap = True
    Else
        IsLeap = False
    End If
End Function
'判断月初
Public Function IsMonthHead(d)
'    Debug.Assert IsDate(d)
'    Debug.Print d
    If 1 = Day(d) Then
        IsMonthHead = True
    Else
        IsMonthHead = False
    End If
End Function
'判断月末
Public Function isMonthEnd(d)
'    Debug.Assert IsDate(d)
'    Debug.Print d
    If 1 = Day(d + 1) Then
        isMonthEnd = True
    Else
        isMonthEnd = False
    End If
End Function
'判断年初
Public Function IsYearHead(d)
'    Debug.Assert IsDate(d)
'    Debug.Print d & vbTab & Month(d) & vbTab & Day(d)
    If 1 = Month(d) And 1 = Day(d) Then
        IsYearHead = True
    Else
        IsYearHead = False
    End If
End Function
'判断年底
Public Function IsYeadEnd(d)
    Debug.Assert IsDate(d)
'    Debug.Print d
'    Dim temp
'    temp = d + 1
'    Debug.Print temp & vbTab & Month(temp) & vbTab & Day(temp)
    If 1 = Month(d + 1) And 1 = Day(d + 1) Then
        IsYeadEnd = True
    Else
        IsYeadEnd = False
    End If
End Function
'获得月底日期
Public Function getMonthEnd(ByVal d As String) As Date
    If Not IsDate(d) Then
        MsgBox d & vbTab & "不是正确的日期格式！"
        Exit Function
    End If
'    下月初
    Dim temp As Date
    temp = DateAdd("m", 1, d)
    temp = DateSerial(Year(temp), Month(temp), 1)
'    Debug.Print temp
    getMonthEnd = DateAdd("d", -1, temp)
End Function
