from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'ReportForm/Production/(?P<year>[0-9]{4})/(?P<month>[0-9]{2})/(?P<day>[0-9]{2})/$',views.ProductionDaily),
    url(r'ReportForm/Production/(?P<year>[0-9]{4})/(?P<month>[0-9]{2})/$',views.ProductionMonthly),
    url(r'ReportForm/Production/(?P<year>[0-9]{4})/$',views.ProductionAnnual),    
]