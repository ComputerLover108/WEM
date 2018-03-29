from django.urls import path,re_path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('Proration',views.proration,name='proration'),
    path('QuickInput',views.quickInput,name='quickInput'),
    path('LadingBillForm', views.ladingBillForm, name='ladingBillForm'),
    path('SeaPipeData', views.SeaPipeData, name='SeaPipeData'),
    path('ProductionReview', views.productionReview, name='productionReview'),
    path('ProductionDaily', views.ProductionDaily, name='productionDaily'),
    re_path(r'^ProductionDaily/(?P<sd>[0-9]{4}-[0-9]{2}-[0-9]{2})/$',views.specifiedProductionDaily,name='specifiedProductionDaily'),
    path('ProductionMonthly', views.ProductionMonthly, name='productionMonthly'),
    path('ProductionAnnual', views.ProductionAnnual, name='productionAnnual'),
    path('loadingDaily', views.loadingDaily, name='loadingDaily'),
    path('assay/getLaboratoryDaily',views.getLaboratoryDaily,name='getLaboratoryDaily'),

    path('ProductionDataList', views.ProductionDataList.as_view(),
        name='ProductionDataList'),
    path('ProductionStatusList', views.ProductionStatusList.as_view(),
        name='ProductionStatusList'),
    path('LadingBillList', views.LadingBillList.as_view(), name='LadingBillList'),
]
