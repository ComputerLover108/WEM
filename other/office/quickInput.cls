Option Explicit
sub test()
    Err.Clear
    On Error GoTo ErrorHandler
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next    
end sub
' 获得生产日报所需数据
sub getProductionDailyData()
    Err.Clear
    On Error GoTo ErrorHandler
    dim data as object
    set data = CreateObject("Scripting.Dictionary")
    call getDate(data)
    call getDistributionDate(data)
    call getBillLadingDate(data)
    call getTestData(data)
    call getProductionDynamicDate(data)
    call getProductionDate(data)
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next    
end sub

' 数据填入生产日报
sub putProductionDailyData(ws as object,data as object)
    Err.Clear
    On Error GoTo ErrorHandler
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next    
end sub

' 从快速录入中获得日期
sub getDate(data as object)
    Err.Clear
    dim row,column,rowLimit,columnLimit,co as long
    dim temp,d as variant
    dim flag,name as string
    flag = "日期" 
    dim h as new help
    rowLimit = UsedRange.Rows.count
    columnLimit = UsedRange.Columns.count
    for row=1 to rowLimit
        for column=1 to columnLimit
            temp = cells(row,column).value
            if h.isString(temp) and h.isMatch(flag,temp) then
                co=1
                name = temp
                temp = cells(row,column+co).value
                if isDate(temp) then
                    data.add name,temp
                    exit sub
                end if
            end if
        next column
    next row
    On Error GoTo ErrorHandler
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description   
end sub

' 获得化验数据
sub getTestData()
    Err.Clear
    On Error GoTo ErrorHandler
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description
    Resume Next    
end sub

' 获得提单数据
sub getBillLadingDate(data as object)
    Err.Clear
    On Error GoTo ErrorHandler
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description   
end sub
' 获得生产信息数据
sub getProductionDate(data as object)
    Err.Clear
    On Error GoTo ErrorHandler
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description   
end sub
' 获得生产动态数据
sub getProductionDynamicDate(data as object)
    Err.Clear
    On Error GoTo ErrorHandler
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description   
end sub
' 获得配产数据
sub getDistributionDate(data as object)
    Err.Clear
    On Error GoTo ErrorHandler
ErrorHandler:
    Debug.Print Err.Number & vbTab & Err.Description   
end sub