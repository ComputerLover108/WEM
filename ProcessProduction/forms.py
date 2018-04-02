from django.forms import modelformset_factory
from django import forms
from datetime import date
# 配产
class ProrationForm(forms.Form):
    日期 = forms.DateField()
    天然气月配产=forms.FloatField()
    天然气年配产=forms.FloatField()
    轻油月配产=forms.FloatField()
    轻油年配产 = forms.FloatField()
    轻烃月配产 = forms.FloatField()
    轻烃年配产 = forms.FloatField()

# 快速录入
class QuickInputForm(forms.Form):
    日期 = forms.DateField()
# 海管
    海管进口压力兆帕 = forms.FloatField()
    海管出口压力兆帕  = forms.FloatField()
    海管进口温度摄氏度 = forms.FloatField()
    海管出口温度摄氏度  = forms.FloatField()
# 上游
    JZ202凝析油方 = forms.FloatField()
    # JZ202轻油 = forms.FloatField()
    JZ202凝析油密度吨每方 = forms.FloatField()
    # JZ202轻油密度 = forms.FloatField()
# 天然气
    稳定区方 = forms.FloatField()
    入厂计量方  = forms.FloatField()
    锦天化方  = forms.FloatField()
    精细化工CNG方 = forms.FloatField()
    精细化工方 = forms.FloatField()
    污水处理厂方 = forms.FloatField()
    新奥燃气方 = forms.FloatField()
    自用气方 = forms.FloatField()
    JZ202体系接收方= forms.FloatField()
# 轻油
    V631A米 = forms.FloatField()
    V631B米 = forms.FloatField()
    V631C米 = forms.FloatField()
# 轻烃
    V641A米  = forms.FloatField()
    V641B米  = forms.FloatField()
    V642米  = forms.FloatField()
    V643A米  = forms.FloatField()
    V643B米  = forms.FloatField()
# 数据库
    数据库轻油回收量方  = forms.FloatField()
    数据库丙丁烷回收量方 =forms.FloatField()
# 化学药剂    
    甲醇消耗方 = forms.FloatField()
    乙二醇消耗方 = forms.FloatField()
# 水
    外供水方  = forms.FloatField()
    自采水方  = forms.FloatField()
    污水方  = forms.FloatField()
    库存水米   = forms.FloatField()
# 电
    外供电度= forms.FloatField()
    自发电度= forms.FloatField()
# 备注
    上下游12吋海管通球= forms.CharField(max_length=256,required=False)
    生产备注= forms.CharField(max_length=256,required=False)
# 非日报数据
    FIQ6102方 = forms.FloatField()
    FIQ5014千方= forms.FloatField()
    FIQ2043方= forms.FloatField()

