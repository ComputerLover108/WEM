VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "文件目录"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'自动建立文件名为“当年”“当月”的目录
Public Function 自动建立备份目录(ByVal backupPath As String, ByVal t As Date) As String
'    Dim t As Date
'    t = Now()
'    st = FormatDateTime(t)
    sy = Format(t, "yyyy年")
    sm = Format(t, "mm月")
'    st = Format(t, "yyyymmdd")
'    Debug.Print sy & " " & sm & " " & st
    Set fs = CreateObject("Scripting.FileSystemObject")
    syName = backupPath & Application.PathSeparator & sy
    If Not fs.FolderExists(syName) Then
        fs.CreateFolder (syName)
    Else
'        Debug.Print fs.GetFolder(syName) & " 已经存在！"
    End If
    syName = fs.getfolder(syName)
    smname = syName & Application.PathSeparator & sm
    If Not fs.FolderExists(smname) Then
        fs.CreateFolder (smname)
    Else
'        Debug.Print fs.GetFolder(smName) & " 已经存在！"
    End If
'    Debug.Print smname
    自动建立备份目录 = smname
End Function
'获得指定目录下所有子目录名
Public Sub dirList(ByVal Path As String, result)
    If Right(Path, 1) <> "\" Then Path = Path & "\"
    Dim fileName As String
    Dim i As Long
    result.Add Path, ""
    i = 0
    Dim tempPath
    Dim pathName As String
    Do While i < result.count
        tempPath = result.Keys   '开始遍历字典
        fileName = Dir(tempPath(i), vbDirectory)    '查找目录
        Do While fileName <> ""
            If fileName <> "." And fileName <> ".." Then
                If (GetAttr(tempPath(i) & fileName) And vbDirectory) = vbDirectory Then    '如果是次级目录
                    pathName = tempPath(i) & fileName & "\"
                    result.Add pathName, ""  '就往字典中添加这个次级目录名作为一个条目
'                    Debug.Print pathName
                End If
            End If
            fileName = Dir    '继续遍历寻找
        Loop
        i = i + 1
    Loop
End Sub
'获得指定目录下所有文件名,不包含子目录名
Public Sub fileList(ByVal Path As String, result)
    Dim dirs As Object
    Set dirs = CreateObject("Scripting.Dictionary")    '全部子目录
    Call dirList(Path, dirs)
    Dim x
    Dim absFileName As String
    For Each x In dirs.Keys
        fileName = Dir(x)
        Do While fileName <> ""
            absFileName = x & fileName
'            Debug.Print absFilename
            result.Add (absFileName), fileName
            fileName = Dir
        Loop
    Next
End Sub
'在指定目录下查找指定文件，不包含目录,使用正则表达式
Public Sub FindFiles(ByVal Path As String, ByVal aim As String, result)
    Dim files As Object
    Set files = CreateObject("Scripting.Dictionary")   '全部子目录
    Call fileList(Path, files)
    Dim i As Long
    Dim fileNames
    fileNames = files.Items
    Dim absFileNames
    absFileNames = files.Keys
    Dim x As New help
    For i = 0 To files.count - 1
        If x.isMatch(aim, fileNames(i)) Then
'            Debug.Print absFileNames(i) & vbTab & fileNames(i)
            result.Add absFileNames(i), fileNames(i)
        End If
    Next
End Sub

Public Sub test()
    Dim dirName As String
    dirName = "e:\public\temp"
    Dim result As Object
    Set result = CreateObject("Scripting.Dictionary")
    Call dirList(dirName, result)
    Dim x
    For Each x In result.Keys
        Debug.Print "目录" & vbTab & x
    Next
    Debug.Print result.count
    result.RemoveAll
    
    Call fileList(dirName, result)
    For Each x In result.Keys
        Debug.Print "文件" & vbTab & x
    Next
    Debug.Print result.count
    result.RemoveAll
    
    Dim aim As String
    aim = "py$"
    Call FindFiles(dirName, aim, result)
    For Each x In result.Keys
        Debug.Print "匹配" & vbTab & x
    Next
    Debug.Print result.count
    result.RemoveAll
    Debug.Print pathSelect
End Sub
Function pathSelect() As String
    Set objShell = CreateObject("Shell.Application")
    Set objFolder = objShell.BrowseForFolder(0, "请选择一个文件夹", 0, 0)
    If objFolder Is Nothing Then Exit Function
    pathSelect = objFolder.Self.Path
    Set objFolder = Nothing
    Set objShell = Nothing
End Function

