VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} �����ձ���ѯ 
   Caption         =   "�����ձ�"
   ClientHeight    =   3000
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   3840
   OleObjectBlob   =   "�����ձ���ѯ.frx":0000
   StartUpPosition =   1  '����������
End
Attribute VB_Name = "�����ձ���ѯ"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim DBname As String
Dim fname As String


Private Sub UserForm_Click()

End Sub

Private Sub ��ѯ_Click()
    Dim sd As String
    sd = TextBox1.value
    If IsDate(sd) Then
        Dim cnn As Object
        Dim rst As Object
        Set cnn = CreateObject("ADODB.Connection")
        Set rst = CreateObject("ADODB.recordset")
'        Dim DBname As String
        DBname = ActiveWorkbook.path & Application.PathSeparator & "��«����Ȼ������.mdb"
        With cnn
            .Provider = "Microsoft.Jet.OLEDB.4.0"
            .Open DBname
        End With
        Dim SQL
        SQL = "select ����Դ from " & "������Ϣ where ����=#" & sd & "#" & " and ����='�볧����' "
'        Debug.Print SQL
        Set rst = cnn.Execute(SQL)
'        Dim fname As String
        If rst.EOF And rst.BOF Then
            MsgBox "û���ҵ������ļ�!"
        Else
            fname = rst("����Դ")
            Application.Workbooks.Open (fname)
        End If
'        Debug.Print fname
        ' �ر����Ӳ������ڴ�
        rst.Close
        cnn.Close
        Set rst = Nothing
        Set cnn = Nothing
    Else
        MsgBox "û��������ȷ�����ڸ�ʽ��"
    End If
    Unload �����ձ���ѯ
End Sub

Private Sub UserForm_initialize()
'        Dim DBname As String
'        Dim fname As String
    TextBox1.value = Date - 1
End Sub
Private Sub UserForm_Terminate()
'    Application.Workbooks(fname).Close
End Sub
