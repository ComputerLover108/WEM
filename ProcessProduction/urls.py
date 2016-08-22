from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^ProductionDaily',views.ProductionDaily),
    url(r'^ProductionDataList',views.ProductionDataList.as_view(),name='ProductionDataList'),
    url(r'^ProductionStatusList',views.ProductionStatusList.as_view(),name='ProductionStatusList'),
    url(r'^LadingBill',views.LadingBill.as_view(),name='LadingBill'),
    url(r'^ReportForm/Production/(?P<year>[0-9]{4})/(?P<month>[0-9]{2})/(?P<day>[0-9]{2})/$',views.ProductionDaily),
    url(r'^ReportForm/Production/(?P<year>[0-9]{4})/(?P<month>[0-9]{2})/$',views.ProductionMonthly),
    url(r'^ReportForm/Production/(?P<year>[0-9]{4})/$',views.ProductionAnnual),
]
