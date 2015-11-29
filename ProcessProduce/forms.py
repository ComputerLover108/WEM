# -*- coding: utf-8 -*-
"""
Created on Tue Jul 21 21:25:32 2015

@author: wkx
"""

from django import forms
from datetime import date

class QuickInputFrom(forms.Form):
    日期 = forms.DateField(initial=date.today().isoformat())
# 气
    稳定区 = forms.IntegerField(label='稳定区产气 Nm3',max_value=30000)
    入厂计量 = forms.IntegerField(label='入厂计量 Nm3',max_value=1800000)
    锦天化 = forms.IntegerField(label='外供锦天化 Nm3',max_value=1800000)
    精细化工 = forms.IntegerField(label='外供精细化工 Nm3')
    污水处理厂 = forms.IntegerField(label='外供污水处理厂 Nm3')
    新奥燃气 = forms.IntegerField(label='外供新奥燃气 Nm3')
    自用气 = forms.IntegerField(label='自用气 Nm3',max_value=20000)
    JZ202体系 = forms.IntegerField(label='JZ-202体系 Nm3')
# 海管    
    海管来液含水 = forms.CharField(label='海管来液含水[V-601] %',required=False)
    海管MEG浓度 = forms.CharField(label='海管MEG浓度[V-611] %',required=False)
    海管出口凝点 = forms.CharField(label='海管出口凝点[V-601] ℃',required=False)
    海管出口PH值 = forms.CharField(label='海管出口PH值',required=False)
    海管进出口压力 = forms.CharField(label='海管进/出口压力 MPa')
    海管进出口温度= forms.CharField(label='海管进/出口温度 ℃')
    海管通球备注 = forms.CharField(required=False)
# 上游    
    JZ202凝析油 = forms.DecimalField(label='JZ-202凝析油 m3')
    JZ202轻油 = forms.DecimalField(label='JZ-202轻油 m3')
# 油
    V631A  = forms.DecimalField(label='V-631A m')
    V631B = forms.DecimalField(label='V-631B m')
    V631C = forms.DecimalField(label='V-631C m')
    轻油装车t = forms.DecimalField(label='轻油装车 t')
    轻油装车m3 = forms.DecimalField(label='轻油装车 m3')
    轻油装车bbl = forms.DecimalField(label='轻油装车 bbl')
    外输凝点 = forms.DecimalField(label='外输凝点 ℃',required=False)
    外输PH值 = forms.DecimalField(required=False)
    饱和蒸汽压 = forms.DecimalField(label='饱和蒸汽压 Kpa',required=False)
    轻油入罐前上午下午含水 = forms.CharField(label='轻油入罐前上/下午含水 %',required=False)
    轻油密度 = forms.DecimalField(label='轻油密度 t/m3')
# 轻烃    
    V641A = forms.DecimalField(label='V641A m')
    V641B = forms.DecimalField(label='V641B m') 
    V642  = forms.DecimalField(label='V642 m')
    V643A = forms.DecimalField(label='V643A m')
    V643B = forms.DecimalField(label='V643B m')
    丙烷装车 = forms.DecimalField(label='丙烷装车 t')
    丁烷装车 = forms.DecimalField(label='丁烷装车 t')
    液化气装车 = forms.DecimalField(label='液化气装车 t')
# 数据库    
    数据库轻油回收量 = forms.DecimalField(label='数据库轻油回收量 m3')
    数据库丙丁烷回收量 = forms.DecimalField(label='数据库丙丁烷回收量 m3')
# 化学药剂
    甲醇消耗 = forms.DecimalField(label='甲醇日耗量 m3')
    乙二醇消耗 = forms.DecimalField(label='乙二醇日耗量 m3')    
    乙二醇回收 = forms.DecimalField(label='乙二醇日回收量 m3')
    乙二醇浓度 = forms.DecimalField(label='乙二醇浓度 %',required=False)
# 水
    水池水位 = forms.DecimalField(label='水池水位 m')    
    外供水 = forms.DecimalField(label='外供水 m3')
    自采水 = forms.DecimalField(label='自采水 m3')
    污水 = forms.DecimalField(label='污水 m3')
# 电    
    外供电 = forms.DecimalField(label='日外供电量 kwh')
    自发电 = forms.DecimalField(label='日自发电量 kwh ')
# 备注    
    生产备注 = forms.CharField(required=False)   
# 非日报数据
    FIQ6102 = forms.DecimalField(label='FIQ-6102 m3')
    FIQ5014 = forms.DecimalField(label='FIQ-5014 km3')
    FIQ2043 = forms.DecimalField(label='FIQ-2043 m3')
   
class TestDataForm(forms.Form):
    pass

class ProrationForm(forms.Form):
    日期 = forms.DateField( initial=date.today().isoformat() )
    天然气月配产10KNm3 = forms.DecimalField()
    天然气年配产10KNm3 = forms.DecimalField()
    轻油月配产m3 = forms.IntegerField()
    轻油年配产m3 = forms.IntegerField()
    丙丁烷月配产m3 = forms.IntegerField()
    丙丁烷年配产m3 = forms.IntegerField()

class SeaPipeDataForm(forms.Form):
    pass

class OutputDataForm(forms.Form):
    pass

class RealDataForm(forms.Form):
    pass
