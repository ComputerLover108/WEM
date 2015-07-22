# -*- coding: utf-8 -*-
"""
Created on Tue Jul 21 21:25:32 2015

@author: wkx
"""

from django import forms

class QuickInputFrom(forms.Form):
    pass
    
class TestDataForm(forms.Form):
    pass

class ProrationForm(forms.Form):
    日期 = forms.DateField()
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
