VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "inventory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public create_date As Date
Public product As String
Public unit As String
Public product_data As Double
Public category As String
Public status As String
Public source As String

Sub CreateTable()
    Err.Clear
    On Error GoTo errorhander
    Dim SQL As String
    Dim tablename, tableDef As String
    tablename = "inventory"
'    PostgreSQL 表
    tableDef = " (id serial PRIMARY KEY,create_date DATE, product VARCHAR, unit VARCHAR, product_data DOUBLE PRECISION, category VARCHAR, status VARCHAR, source VARCHAR, UNIQUE(create_date,product,unit,status));"
    SQL = " CREATE TABLE IF NOT EXISTS " & tablename & tableDef
    Dim psql As New PostgreSQL
    Call psql.cnn.Execute(SQL)
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
End Sub

Sub save(ByRef data As Object)
'
' description.
'
' @since 1.0.0
' @param {type} [name] description.
' @return {type} [name] description.
' @see dependencies'
    Err.Clear
    On Error GoTo errorhander
    Dim t As Date
    t = Now
    Dim SQL, tablename As String
    tablename = "inventory"
    Dim x
    Dim psql As New PostgreSQL
    Call CreateTable
    For Each x In data.Keys
        SQL = "INSERT INTO inventory (create_date,product,unit,product_data,category,status,source) VALUES ('$1','$2','$3',$4,'$5','$6','$7') ON CONFLICT (create_date,product,unit,status) DO UPDATE SET product_data = EXCLUDED.product_data,source=EXCLUDED.source;"
        SQL = replace(SQL, "$1", x.create_date)
        SQL = replace(SQL, "$2", x.product)
        SQL = replace(SQL, "$3", x.unit)
        SQL = replace(SQL, "$4", x.product_data)
        SQL = replace(SQL, "$5", x.category)
        SQL = replace(SQL, "$6", x.status)
        SQL = replace(SQL, "$7", x.source)
        Debug.Print SQL
        psql.cnn.Execute (SQL)
    Next
    Debug.Print "导入" & data.count & "条记录到表" & tablename & " ,PostgreSQL表花费" & DateDiff("s", t, Now()) & "s."
errorhander:
    If Err.Number <> 0 Then Debug.Print Err.Number & vbTab & Err.Description
End Sub

