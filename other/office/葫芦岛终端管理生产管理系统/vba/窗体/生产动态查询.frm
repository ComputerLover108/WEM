VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} ������̬��ѯ 
   Caption         =   "������̬"
   ClientHeight    =   6630
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   11400
   OleObjectBlob   =   "������̬��ѯ.frx":0000
   StartUpPosition =   1  '����������
End
Attribute VB_Name = "������̬��ѯ"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public filterS As New Dictionary
Private Sub ��ѯ_Click()
    Worksheets("������̬").Select
    Call Worksheets("������̬").���_Click
    Application.EnableEvents = False
On Error GoTo ErrorHandler
    Dim d1 As Date
    Dim d2 As Date
    Dim d3 As Date
    Dim SQL As String
    Dim filter As String
    filter = ""
'    ָ��ʱ��
    If True = ʱ���.Visible Then
        If IsDate(ʱ���.value) Then
            d1 = ʱ���.value
            filter = "ʱ�� = " & "'" & d1 & "'"
        Else
            MsgBox "����ȷ��ʱ���ʽ��"
            Exit Sub
        End If
    End If
'    ʱ���
    If True = ��ʼʱ��.Visible And True = ����ʱ��.Visible Then
        If IsDate(��ʼʱ��.value) And IsDate(����ʱ��.value) Then
            d2 = ��ʼʱ��.value
            d3 = ����ʱ��.value
            filter = "ʱ�� between " & "'" & d2 & "'" & " and " & "'" & d3 & "'"
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
    filterFX = " order by ʱ��"
'    office 2003 ����������������
    Dim rowLimit As Long
    Dim columnLimit As Integer
    rowLimit = 65536
    columnLimit = 256
    rowLimit = 65536 - 4
    Dim psql As New PostgreSQL
    
'    ȥ����������
    SQL = "delete from ������̬ where ʱ�� > '2110-1-1';"
    Call psql.cnn.Execute(SQL)
'    ��ѯ����
    SQL = "select count(*) from ������̬ " & "where " & filter
    Dim ��¼�� As Long
    ��¼�� = psql.cnn.Execute(SQL)(0)
    If ��¼�� > rowLimit Then
        MsgBox ("��¼̫���ˣ�����" & rowLimit & "��!")
        Exit Sub
    End If
    SQL = " Select ʱ��,����,��λ,����,��ע from ������̬ " & "where " & filter & filterFX
'    Call psql.cnn.Execute(SQL)
    Worksheets("������̬").Cells(4, 1).CopyFromRecordset psql.cnn.Execute(SQL)
    Unload ������̬��ѯ
    Dim row As Long
    Dim column As Integer
    row = 4
    column = 1
    Worksheets("������̬").Select
    With ActiveSheet.UsedRange
        Range(Cells(3, 1), Cells(.Rows.count, .Columns.count)).Select
    End With
    Selection.AutoFilter
    Columns("A:A").Select
    Selection.NumberFormatLocal = "yyyy/m/d h:mm;@"
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

Private Sub ����_Click()
    ʱ���.Visible = False
    ��ʼʱ��.Visible = True
    ����ʱ��.Visible = True
    ����ʱ��.value = DateValue(Now)
End Sub


Private Sub ��ʼ_Click()
    ʱ���.Visible = False
    ��ʼʱ��.Visible = True
    ����ʱ��.Visible = True
    ��ʼʱ��.value = DateSerial(Year(Now), Month(Now), 1)
End Sub

Private Sub ���_Click()
    Worksheets("������̬").Select
    Unload ������̬��ѯ
End Sub

Private Sub �޸�_Click()
    Worksheets("������̬").Select
    Unload ������̬��ѯ
End Sub

Private Sub ָ��ʱ��_Click()
    ʱ���.Visible = True
    ʱ���.value = DateValue(Now)
    ��ʼʱ��.Visible = False
    ����ʱ��.Visible = False
End Sub
Private Sub ����_Change()
    filterS.Add "����", Me.����.value
End Sub
Private Sub ��λ_Change()
    filterS.Add "��λ", Me.��λ.value
End Sub
Private Sub ���_Change()
    filterS.Add "���", Me.���.value
End Sub
Private Sub UserForm_initialize()
    Err.Clear
On Error GoTo ErrorHandler
    Dim psql As New PostgreSQL
    Dim SQL As String
    Dim s
    Dim arr()
    Dim rst As New ADODB.Recordset
'    ����
    SQL = "select DISTINCT ���� from ������̬ "
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "����")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.����.AddItem (s)
    Next
'    ��λ
    SQL = "select DISTINCT ��λ from ������̬ "
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "��λ")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.��λ.AddItem (s)
    Next
'    ���
    SQL = "select DISTINCT ��� from ������̬ "
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "���")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.���.AddItem (s)
    Next
    Set rst = Nothing
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub
