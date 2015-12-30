Public Sub DerivationData(ByVal 日期 As Date)
On Error GoTo ErrorHandler
    去年年末 = DateSerial(Year(日期) - 1, 12, 31)
    今年年末 = DateSerial(Year(日期), 12, 31)
    时间进度比 = (日期 - 去年年末) / (今年年末 - 去年年末) * 100
    Dim tb0,tb1,tb2 As Object
    set tb0 = CreateObject("Scripting.Dictionary")    
    Set tb1 = CreateObject("Scripting.Dictionary")
    Set tb2 = CreateObject("Scripting.Dictionary")
     ' 推导数据所需基本数据
    tb0.add "轻油库存合计"," and 单位='吨' and 名称='轻油库存合计' "
    tb0.add "轻烃库存"," and 单位='吨' and 名称='轻烃库存' "
    for each key in tb0
        filter = tb0(Key)
        filter日累 = " where 日期 ='" & 昨日 & "'"
        SQL = "select " & field & " from " & tableName & filter日累  & " and " & filter
        ds = psql.cnn.Execute(SQL)(0)
        Debug.Print Key, ds, SQL
    Next key   
    ' 月累，年累
    ' 上游
    tb1.Add "JZ20-2体系接收m3", " and 单位='方' and 名称='JZ20-2体系' and 状态='接收' "
    tb1.Add "JZ20-2体系外输m3", " and 单位='方' and 名称='JZ20-2体系' and 状态='外输' "
    tb1.Add "JZ25-1S体系接收m3", " and 单位='方' and 名称='JZ25-1S体系' and 状态='接收' "
    tb1.Add "JZ25-1S体系外输m3", " and 单位='方' and 名称='JZ25-1S体系' and 状态='外输' "
    tb1.Add "JZ20-2凝析油m3", " and 单位='方' and 名称='JZ20-2凝析油' "
    tb1.Add "JZ20-2轻油m3", " and 单位='方' and 名称='Z20-2轻油' "
    ' 天然气
    tb1.Add "稳定区m3", " and 单位='方' and 名称='稳定区' "
    tb1.Add "入厂计量m3", " and 单位='方' and 名称='入厂计量' "
    tb1.Add "总外输气量m3", " and 单位='方' and 名称='总外输气量' "
    tb1.Add "锦天化m3", " and 单位='方' and 名称='锦天化' "
    tb1.Add "精细化工m3", " and 单位='方' and 名称='精细化工' "
    tb1.Add "污水处理厂m3", " and 单位='方' and 名称='污水处理厂' "
    tb1.Add "新奥燃气m3", " and 单位='方' and 名称='新奥燃气' "
    tb1.Add "自用气m3", " and 单位='方' and 名称='自用气' "
    ' 油
    tb1.Add "轻油回收量m3", " and 单位='方' and 名称='轻油回收量' "
    ' 轻烃
    tb1.Add "丙丁烷回收量m3", " and 单位='方' and 名称='丙丁烷回收量' "
    ' 化学药剂
    tb1.Add "甲醇消耗m3", " and 单位='方' and 名称='甲醇消耗' "
    tb1.Add "乙二醇消耗m3", " and 单位='方' and 名称='乙二醇消耗' "
    tb1.Add "乙二醇回收m3", " and 单位='方' and 名称='乙二醇回收' "
    ' 水
    tb1.Add "外供水m3", " and 单位='方' and 名称='外供水' "
    tb1.Add "水消耗m3", " and 单位='方' and 名称='水消耗' "
    tb1.Add "自采水m3", " and 单位='方' and 名称='自采水' "
    ' 电
    tb1.Add "外供电KWh", " and 单位='度' and 名称='外供电' "
    tb1.Add "电消耗KWh", " and 单位='度' and 名称='电消耗' "
    tb1.Add "自发电KWh", " and 单位='度' and 名称='自发电' "
    Dim tableName, field, SQL, filter月累, filter年累,  filter As String
    Dim 昨日,月初, 年初 As Date
    昨日 =  DateAdd("d", 1, 日期)
    月初 = DateSerial(Year(日期), Month(日期), 1)
    年初 = DateSerial(Year(日期), 1, 1)
    tableName = "生产信息"
    field = "数据"
    filter日累 = " where 日期 ='" & 昨日 & "'"
    filter月累 = " where 日期 between '" & 月初 & "' and '" & 昨日 & "'"
    filter年累 = " where 日期 between '" & 年初 & "' and '" & 昨日 & "'"
    Dim ds,ms, ys As Variant
    dim rmy(3) as variant 
    Dim psql As New PostgreSQL
    For Each Key In tb1
        filter =  tb1(Key) 
'        月累
        SQL = "select sum(" & field & ") from " & tableName & filter月累  & " and " & filter
        ms = psql.cnn.Execute(SQL)(0)
        ' Debug.Print Key, ms, SQL
'        年累
        SQL = "select sum(" & field & ") from " & tableName & filter年累  & " and " & filter
'        Debug.Print SQL
        ys = psql.cnn.Execute(SQL)(0)
        ' Debug.Print Key, ys, SQL
        rmy(1)=ms
        rmy(2)=ys
        tb2.add key,rmy
    Next Key

    ' [丙丁烷回收量t] = [轻烃库存t] + [丙烷装车t] + [丁烷装车t] + [液化气装车t] - 昨轻烃库存t
    ' 剩余天数 = DateDiff("d", 日期, 今年年末)    
    ' temp = ([天然气年度配产] - [总外输气量年累]) / 剩余天数
    ' temp = ([轻油年度配产] - [轻油回收量年累]) / 剩余天数
    ' temp = ([丙丁烷年度配产] - [丙丁烷回收量年累]) / 剩余天数
    ' [水消耗数据] = 昨库存水 + [外供水数据] + [自采水数据] - [库存水]
    ' [电消耗数据] = [外供电数据] + [自发电数据]
    ' {{日期}}
    ' {{年时间进度比}}
    ' {{天然气年配产}}
    ' {{天然气年累}}
    ' {{天然气年度完成率}}
    ' {{天然气需日产}}
    ' {{天然气月配产}}
    ' {{天然气月累}}
    ' {{天然气月度完成率}}
    ' {{年时间进度比}}
    ' {{轻油年配产}}
    ' {{轻油年累}}
    ' {{轻油年度完成率}}
    ' {{轻油需日产}}
    ' {{轻油月配产}}
    ' {{轻油月累}}
    ' {{轻油月度完成率}}
    ' {{年时间进度比}}
    ' {{丙丁烷年配产}}
    ' {{丙丁烷年累}}
    ' {{丙丁烷年度完成率}}
    ' {{丙丁烷需日产}}
    ' {{丙丁烷月配产}}
    ' {{丙丁烷月累}}
    ' {{丙丁烷月度完成率}}
    ' {{稳定区数据}}
    ' {{稳定区月累}}
    ' {{稳定区年累}}
    ' {{入厂计量数据}}
    ' {{入厂计量月累}}
    ' {{入厂计量年累}}
    ' {{海管来液含水上午}}
    ' {{海管来液含水下午}}
    ' {{JZ202体系接收数据}}
    ' {{JZ202体系接收月累}}
    ' {{JZ202体系接收年累}}
    ' {{海管MEG浓度上午}}
    ' {{海管MEG浓度下午}}
    ' {{JZ251S体系接收数据}}
    ' {{JZ251S体系接收月累}}
    ' {{JZ251S体系接收年累}}
    ' {{海管出口凝点上午}}
    ' {{海管出口凝点下午}}
    ' {{总外输气量数据}}
    ' {{总外输气量月累}}
    ' {{总外输气量年累}}
    ' {{海管出口PH值上午}}
    ' {{海管出口PH值下午}}
    ' {{总产气量数据}}
    ' {{总产气量月累}}
    ' {{总产气量年累}}
    ' {{海管进出口压力}}
    ' {{锦天化数据}}
    ' {{锦天化数据1}}
    ' {{锦天化月累}}
    ' {{锦天化年累}}
    ' {{海管进出口温度}}
    ' {{JZ202体系数据}}
    ' {{JZ202体系月累}}
    ' {{JZ202体系年累}}
    ' {{JZ251S原油数据}}
    ' {{JZ251S原油密度}}
    ' {{JZ251S体系数据}}
    ' {{JZ251S体系月累}}
    ' {{JZ251S体系年累}}
    ' {{JZ202凝析油数据}}
    ' {{JZ202凝析油密度}}
    ' {{精细化工数据}}
    ' {{精细化工数据1}}
    ' {{精细化工月累}}
    ' {{精细化工年累}}
    ' {{JZ202轻油数据}}
    ' {{JZ202轻油密度}}
    ' {{污水处理厂数据}}
    ' {{污水处理厂月累}}
    ' {{污水处理厂年累}}
    ' {{上下游12吋海管通球}}
    ' {{新奥燃气数据}}
    ' {{新奥燃气月累}}
    ' {{新奥燃气年累}}
    ' {{自用气数据}}
    ' {{自用气月累}}
    ' {{自用气年累}}
    ' {{V631A_m}}
    ' {{V631B_m}}
    ' {{V631C_m}}
    ' {{轻油处理量m3}}
    ' {{轻油回收量m3}}
    ' {{轻油回收量t}}
    ' {{V631A_m3}}
    ' {{V631B_m3}}
    ' {{V631C_m3}}
    ' {{轻油库存m3}}
    ' {{V631A_t}}
    ' {{V631B_t}}
    ' {{V631C_t}}
    ' {{轻油库存t}}
    ' {{饱和蒸汽压}}
    ' {{轻油外输PH值}}
    ' {{轻油外输凝点}}
    ' {{轻油装车m3}}
    ' {{轻油装车bbl}}
    ' {{轻油装车t}}
    ' {{轻油入罐前含水}}
    ' {{V641A_m}}
    ' {{V641B_m}}
    ' {{V642_m}}
    ' {{V643A_m}}
    ' {{V643B_m}}
    ' {{V641A_m3}}
    ' {{V641B_m3}}
    ' {{V642_m3}}
    ' {{V643A_m3}}
    ' {{V643B_m3}}
    ' {{丙烷库存m3}}
    ' {{丁烷库存m3}}
    ' {{液化气库存m3}}
    ' {{V641A_t}}
    ' {{V641B_t}}
    ' {{V642_t}}
    ' {{V643A_t}}
    ' {{V643B_t}}
    ' {{丙烷库存t}}
    ' {{丁烷库存t}}
    ' {{液化气库存t}}
    ' {{丙烷装车m3}}
    ' {{丁烷装车m3}}
    ' {{液化气装车m3}}
    ' {{丙烷装车t}}
    ' {{丁烷装车t}}
    ' {{液化气装车t}}
    ' {{轻烃回收m3}}
    ' {{轻烃回收t}}
    ' {{轻烃库存t}}
    ' {{数据库轻油回收量m3}}
    ' {{数据库轻烃回收量m3}}
    ' {{甲醇消耗m3}}
    ' {{乙二醇消耗m3}}
    ' {{外供水m3}}
    ' {{水消耗m3}}
    ' {{外供电KWh}}
    ' {{自发电KWh}}
    ' {{电消耗KWh}}
    ' {{甲醇消耗m3月累}}
    ' {{乙二醇消耗m3月累}}
    ' {{水消耗m3月累}}
    ' {{外供电KWh月累}}
    ' {{自发电KWh月累}}
    ' {{电消耗KWh月累}}
    ' {{甲醇消耗m3年累}}
    ' {{乙二醇消耗m3年累}}
    ' {{外供水m3年累}}
    ' {{水消耗m3年累}}
    ' {{外供电KWh年累}}
    ' {{自发电KWh年累}}
    ' {{电消耗KWh年累}}
    ' {{乙二醇浓度}}
    ' {{乙二醇回收m3}}
    ' {{水池水位}}
    ' {{水池储水m3}}     
ErrorHandler:
    If Err.Number <> 0 And Err.Number <> 20 Then Debug.Print Err.Number, Err.Description
    Resume Next
End Sub