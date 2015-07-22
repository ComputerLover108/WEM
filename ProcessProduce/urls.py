from django.conf.urls import patterns, url

from ProcessProduce import views

urlpatterns = patterns('',
    url(r'^$', views.index, name='index'),
    url(r'^TestData',views.TestData,name='化验录入'),
    url(r'^QuickInput',views.QuickInput,name='快速录入'),
    url(r'^Proration',views.Proration,name='配产')
)