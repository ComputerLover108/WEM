from django.conf.urls import url

from . import views
from .views import EquipmentList

urlpatterns = [
    url(r'^$', views.index, name='index'),
	url(r'EquipmentList/$',EquipmentList.as_view(),name='Equipment-list'),        
]