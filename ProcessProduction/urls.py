from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^ProductionDaily',views.ProductionDaily),
    url(r'^ProductionData',views.ProductionData,name='ProductionData'),
    url(r'^ProductionDataList',views.ProductionDataList,name='ProductionDataList'),
    url(r'^ProductionStatus',views.ProductionStatus,name='ProductionData'),
    url(r'^ReportForm/Production/(?P<year>[0-9]{4})/(?P<month>[0-9]{2})/(?P<day>[0-9]{2})/$',views.ProductionDaily),
    url(r'^ReportForm/Production/(?P<year>[0-9]{4})/(?P<month>[0-9]{2})/$',views.ProductionMonthly),
    url(r'^ReportForm/Production/(?P<year>[0-9]{4})/$',views.ProductionAnnual),
]
