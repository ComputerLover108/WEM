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
    海管进口压力 = forms.FloatField()
    海管出口压力 = forms.FloatField()
    海管进口温度 = forms.FloatField()
    海管出口温度 = forms.FloatField()
    海管通球备注 = forms.CharField(max_length=256)
# 上游
    JZ202凝析油 = forms.FloatField()
    JZ202轻油 = forms.FloatField()
    JZ202凝析油密度 = forms.FloatField()
    JZ202轻油密度 = forms.FloatField()
# 天然气
    稳定区 = forms.FloatField()
    入厂计量 = forms.FloatField()
    外供锦天化 = forms.FloatField()
    精细化工CNG= forms.FloatField()
    外供精细化工= forms.FloatField()
    外供污水处理厂= forms.FloatField()
    外供新奥燃气= forms.FloatField()
    自用气量= forms.FloatField()
    JZ202体系= forms.FloatField()
# 轻油
    V631A液位 = forms.FloatField()
    V631B液位= forms.FloatField()
    V631C液位= forms.FloatField()
# 轻烃
    V641A液位 = forms.FloatField()
    V641B液位 = forms.FloatField()
    V642液位 = forms.FloatField()
    V643A液位 = forms.FloatField()
    V643B液位 = forms.FloatField()
# 数据库
    数据库轻油回收量 = forms.FloatField()
    数据库丙丁烷回收量=forms.FloatField()
# 水
    外供水 = forms.FloatField()
    自采水量 = forms.FloatField()
    污水 = forms.FloatField()
    水池水位m = forms.FloatField()
# 电
    外供电= forms.FloatField()
    自发电= forms.FloatField()
# 备注
    生产备注= forms.CharField(max_length=256)
# 非日报数据
    FIQ6102 = forms.FloatField()
    FIQ5014= forms.FloatField()
    FIQ2043= forms.FloatField()

