Attribute VB_Name = "�ı�����"
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
'��ȡ���֣�B1���빫ʽ=RegExpTest("[һ-��]",$A2)
'��ȡ��ĸ��C1���빫ʽ=RegExpTest("[a-zA-Z]",$A2)
'��ȡ���֣�D1���빫ʽ=RegExpTest("\d",$A2)
'��ȡ���ţ�E1���빫ʽ=RegExpTest("[^a-zA-Z0-9\u4e00-\u9fff\+]",$A2)
