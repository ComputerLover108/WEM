VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} �ᵥ��ѯ 
   Caption         =   "UserForm1"
   ClientHeight    =   4590
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   9930
   OleObjectBlob   =   "�ᵥ��ѯ.frx":0000
   StartUpPosition =   1  '����������
End
Attribute VB_Name = "�ᵥ��ѯ"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit
Public filterS As New Dictionary
Private Sub UserForm_initialize()
On Error GoTo ErrorHandler
    Dim psql As New PostgreSQL
    Dim SQL As String
    Dim s
    Dim arr()
    Dim rst As New ADODB.Recordset
'    ��Ʒ����
    SQL = "select DISTINCT ��Ʒ���� from �ᵥ "
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "��Ʒ����")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.��Ʒ����.AddItem (s)
    Next
'   �ͻ�����
    SQL = "select DISTINCT �ͻ����� from �ᵥ "
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "�ͻ�����")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.�ͻ�����.AddItem (s)
    Next
    Set rst = Nothing
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub ��ѯ_Click()
On Error GoTo ErrorHandler
    Worksheets("�ᵥ").Select
    Call Worksheets("�ᵥ").���_Click
    Application.EnableEvents = False
    Dim d1 As Date
    Dim d2 As Date
    Dim d3 As Date
    Dim SQL As String
    Dim filter As String
    filter = ""
'    ָ��ʱ��
    If True = ָ������.Visible Then
        If IsDate(ָ������.value) Then
            d1 = ָ������.value
            filter = "���� = " & "'" & d1 & "'"
        Else
            MsgBox "����ȷ��ʱ���ʽ��"
            Exit Sub
        End If
    End If
'    ʱ���
    If True = ��ʼ����.Visible And True = ��������.Visible Then
        If IsDate(��ʼ����.value) And IsDate(��������.value) Then
            d2 = ��ʼ����.value
            d3 = ��������.value
            filter = "���� between " & "'" & d2 & "'" & " and " & "'" & d3 & "'"
        Else
            MsgBox "����ȷ��ʱ���ʽ��"
            Exit Sub
        End If
    End If
    Dim i As Integer
    Dim Field()
    Dim value()
    Field = filterS.Keys
    value = filterS.Items
    For i = 0 To filterS.count - 1
        If "" <> value(i) Then
           filter = filter & " and " & Field(i) & "='" & value(i) & "'"
        End If
    Next i
    Dim filterFX As String
    filterFX = " order by ����"
    Dim rowLimit As Long
    Dim columnLimit As Integer
    rowLimit = Rows.count
    columnLimit = Columns.count
    rowLimit = 65536 - 4
    SQL = " Select ����,��Ʒ����,�ͻ�����,�ƻ�װ��t,ʵ��װ��t,ʵ��װ��m3,ʵ��װ��bbl,װ������,��ע,�ᵥ�� from �ᵥ " & "where " & filter & filterFX
    Dim psql As New PostgreSQL
    Worksheets("�ᵥ").Cells(4, 1).CopyFromRecordset psql.cnn.Execute(SQL)
    Unload �ᵥ��ѯ
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub ����_Click()
    ָ������.Visible = False
    ��ʼ����.Visible = True
    ��������.Visible = True
    ��������.value = DateValue(Now)
End Sub

Private Sub ��ʼ_Click()
    ָ������.Visible = False
    ��ʼ����.Visible = True
    ��������.Visible = True
    Dim SQL As String
    Dim psql As New PostgreSQL
    Dim bd As Variant
    Dim tablename As String
    tablename = "�ᵥ"
    SQL = "select DISTINCT min(����) from " & tablename
    bd = psql.cnn.Execute(SQL)(0)
    ��ʼ����.value = bd
End Sub

Private Sub ����_Click()
    ָ������.Visible = True
    ��ʼ����.Visible = False
    ��������.Visible = False
    ָ������.value = DateValue(Now)
End Sub

Private Sub ��Ʒ����_Change()
    filterS.Add "��Ʒ����", Me.��Ʒ����.value
End Sub
Private Sub �ͻ�����_Change()
    filterS.Add "�ͻ�����", Me.�ͻ�����.value
End Sub
