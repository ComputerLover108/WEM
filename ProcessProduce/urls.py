from django.conf.urls import patterns, url

from . import views

urlpatterns = patterns('',
    url(r'^$', views.index, name='index'),
    url(r'^TestData/$',views.TestData,name='化验录入'),
    url(r'^QuickInput/$',views.QuickInput,name='快速录入'),
    url(r'^Proration/$',views.Proration,name='配产'),
    url(r'^Proration/(?P<date>[0-9]{2,4}-[0-9]{1,2}-[0-9]{1,2})/$',views.ProrationReport,name='配产表'), 
    url(r'^DailyProduction/(?P<date>[0-9]{2,4}-[0-9]{1,2}-[0-9]{1,2})/$',views.DailyProduction,name='生产日报')
)