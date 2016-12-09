from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^ProductionReview',views.productionReview,name='productionReview'),
    url(r'^ProductionDaily',views.ProductionDaily,name='productionDaily'),
    url(r'^ProductionMonthly',views.ProductionMonthly,name='productionMonthly'),
    url(r'^ProductionAnnual',views.ProductionAnnual,name='productionAnnual'),

    url(r'^ProductionDataList',views.ProductionDataList.as_view(),name='ProductionDataList'),
    url(r'^ProductionStatusList',views.ProductionStatusList.as_view(),name='ProductionStatusList'),
    url(r'^LadingBill',views.LadingBill.as_view(),name='LadingBill'),    
]
