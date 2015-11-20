Attribute VB_Name = "文本处理"
Function RegExpTest(patrn, strng, Optional ByVal fgf As String = "")
    Dim regEx, Match, Matches
    Set regEx = CreateObject("vbScript.regexp")
    regEx.pattern = patrn
    regEx.IgnoreCase = True
    regEx.Global = True
    
    Set Matches = regEx.Execute(strng)
    For Each Match In Matches
    RetStr = RetStr & fgf & Match
    Next
    RegExpTest = Mid(RetStr, Len(fgf) + 1)
End Function
'提取文字，B1输入公式=RegExpTest("[一-龥]",$A2)
'提取字母，C1输入公式=RegExpTest("[a-zA-Z]",$A2)
'提取数字，D1输入公式=RegExpTest("\d",$A2)
'提取符号，E1输入公式=RegExpTest("[^a-zA-Z0-9\u4e00-\u9fff\+]",$A2)
