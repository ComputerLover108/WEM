from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^Proration',views.proration,name='proration'),
    url(r'QuickInput',views.quickInput,name='quickInput'),
    url(r'^LadingBillForm', views.ladingBillForm, name='ladingBillForm'),
    url(r'^SeaPipeData', views.SeaPipeData, name='SeaPipeData'),
    url(r'^ProductionReview', views.productionReview, name='productionReview'),
    url(r'^ProductionDaily', views.ProductionDaily, name='productionDaily'),
    url(r'^ProductionMonthly', views.ProductionMonthly, name='productionMonthly'),
    url(r'^ProductionAnnual', views.ProductionAnnual, name='productionAnnual'),
    url(r'^loadingDaily', views.loadingDaily, name='loadingDaily'),

    url(r'^ProductionDataList', views.ProductionDataList.as_view(),
        name='ProductionDataList'),
    url(r'^ProductionStatusList', views.ProductionStatusList.as_view(),
        name='ProductionStatusList'),
    url(r'^LadingBillList', views.LadingBillList.as_view(), name='LadingBillList'),
]
