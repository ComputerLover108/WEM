VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} ������Ϣ��ѯ 
   Caption         =   "������Ϣ"
   ClientHeight    =   6135
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   11205
   OleObjectBlob   =   "������Ϣ��ѯ.frx":0000
   StartUpPosition =   1  '����������
End
Attribute VB_Name = "������Ϣ��ѯ"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public filterS As New Dictionary
Private Sub ����_Change()
    filterS.Add "����", Me.����.value
    
End Sub
Private Sub ��λ_Change()
    filterS.Add "��λ", Me.��λ.value
    
End Sub
Private Sub ���_Change()
    filterS.Add "���", Me.���.value
    
End Sub
Private Sub ״̬_Change()
    filterS.Add "״̬", Me.״̬.value
    
End Sub
Private Sub ��ע_Change()
    filterS.Add "��ע", Me.��ע.value
    
End Sub
Private Sub ��ѯ_Click()
    Worksheets("������Ϣ").Select
    Call Sheets("������Ϣ").���_Click
    Application.EnableEvents = False
    On Error GoTo ErrorHandler
    Dim d1 As Date
    Dim d2 As Date
    Dim d3 As Date
    Dim SQL As String
    Dim filter As String
    Dim s1 As String
    Dim s2 As String
    filter = ""
'    ָ������
    If True = TextBox3.Visible Then
        If IsDate(TextBox3.value) Then
            d1 = TextBox3.value
            s1 = "����"
            s2 = " = " & "'" & DateValue(d1) & "'"
            filter = s1 & s2
        Else
            MsgBox "����ȷ�����ڸ�ʽ��"
            Exit Sub
        End If
    End If
'    ʱ���
    If True = TextBox1.Visible And True = TextBox2.Visible Then
        If IsDate(TextBox1.value) And IsDate(TextBox2.value) Then
            d2 = TextBox1.value
            d3 = TextBox2.value
            s1 = "����"
            s2 = " between " & "'" & DateValue(d2) & "'" & " and " & "'" & DateValue(d3) & "'"
            filter = s1 & s2
        Else
            MsgBox "����ȷ�����ڸ�ʽ��"
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
'    office 2003 ����������������
    Dim rowLimit As Long
    Dim columnLimit As Integer
    rowLimit = 65536
    columnLimit = 256
    rowLimit = 65536 - 4
    SQL = " Select ����,����,��λ,����,���,״̬,����,����,��ע from ������Ϣ " & "where " & filter & filterFX & " limit " & rowLimit
    Dim Fields
    Fields = Array("����", "����", "��λ", "����", "���", "״̬", "����", "����", "��ע")
    Worksheets("������Ϣ").[A4].Resize(1, UBound(Fields) + 1) = WorksheetFunction.Transpose(WorksheetFunction.Transpose(Fields))
    Dim psql As New PostgreSQL
    Worksheets("������Ϣ").[A5].CopyFromRecordset psql.cnn.Execute(SQL)
    Unload ������Ϣ��ѯ
'    Dim row As Integer
'    Dim column As Integer
'    row = 4
'    column = 1
'    Worksheets("������Ϣ").Select
'    With ActiveSheet.UsedRange
'        Range(Cells(4, 1), Cells(.Rows.count, .Columns.count)).Select
'    End With
'    Selection.AutoFilter
'    Columns("A:I").Select
'    Selection.ColumnWidth = 12
'    Cells(1, 1).Select
'    Worksheets("������Ϣ").Columns(1).NumberFormatLocal = "yyyy/m/d;@"
ErrorHandler:
'    MsgBox Err.Description
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next
End Sub

'ָ������
Private Sub CommandButton2_Click()
    TextBox3.Visible = True
    TextBox3.value = DateValue(Now)
    TextBox1.Visible = False
    TextBox2.Visible = False
    Label8.Visible = False
    Label9.Visible = False
End Sub
'ʱ���
Private Sub CommandButton3_Click()
    TextBox3.Visible = False
    TextBox1.Visible = True
    TextBox1.value = DateSerial(Year(Now), Month(Now), 1)
    TextBox2.Visible = True
    TextBox2.value = DateValue(Now)
    Label8.Visible = True
    Label9.Visible = True
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
    SQL = "select DISTINCT ���� from ������Ϣ order by ����"
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "����")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.����.AddItem (s)
    Next
'    ��λ
    SQL = "select DISTINCT ��λ from ������Ϣ order by ��λ"
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "��λ")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.��λ.AddItem (s)
    Next
'    ���
    SQL = "select DISTINCT ��� from ������Ϣ order by ���"
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "���")
    rst.Close
    For Each s In arr
        If s <> "" Then Me.���.AddItem (s)
    Next
'    ״̬
    SQL = "select distinct ״̬ from ������Ϣ order by ״̬"
    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "״̬")
    For Each s In arr
        If s <> "" Then Me.״̬.AddItem (s)
    Next
    rst.Close
'    ��ע
'    SQL = "select DISTINCT ��ע from ������Ϣ "
'    rst.Open SQL, psql.cnn, adOpenKeyset, adLockBatchOptimistic
'    arr = rst.GetRows(adGetRowsRest, adBookmarkFirst, "��ע")
'    rst.Close
'    For Each s In arr
'        If s <> "" Then Me.��ע.AddItem (s)
'    Next
    Set rst = Nothing
'    Worksheets("������Ϣ").Columns(1).NumberFormatLocal = "yyyy/m/d;@"
ErrorHandler:
    If 0 = Err.Number Or 20 = Err.Number Then
    
    Else
        Debug.Print Err.Number & vbTab & Err.Description
    End If
    Resume Next
End Sub

Private Sub ���_Click()
    Worksheets("������Ϣ").Select
    Call Sheets("������Ϣ").���_Click
    Dim psql As New PostgreSQL
    Dim tablename As String
    tablename = "������Ϣ"
    Dim showFields As New Dictionary
    Call psql.getFields(tablename, showFields)
    Dim row As Integer
    Dim column As Integer
    Dim offset As Integer
    row = 4
    column = 1
'    ����ʾ�� ID,����Դ
    For offset = 0 To showFields.count - 3
        Cells(row, column + offset).value = showFields.item(offset + 1)
    Next
    Unload ������Ϣ��ѯ
End Sub

Private Sub �޸�_Click()
    Worksheets("������Ϣ").Select
    Call Sheets("������Ϣ").���_Click
    Dim psql As New PostgreSQL
    Dim tablename As String
    tablename = "������Ϣ"
    Dim showFields As New Dictionary
    Call psql.getFields(tablename, showFields)
    Dim row As Integer
    Dim column As Integer
    Dim offset As Integer
    row = 4
    column = 1
'    ����ʾ�� ID������Դ
    For offset = 0 To showFields.count - 3
        Cells(row, column + offset).value = showFields.item(offset + 1)
    Next
    Unload ������Ϣ��ѯ
End Sub



