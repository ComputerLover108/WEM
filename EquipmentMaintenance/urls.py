from django.urls import path

from . import views
from .views import EquipmentList

urlpatterns = [
    path('', views.index, name='index'),
	path('EquipmentList/',EquipmentList.as_view(),name='EquipmentList'),
]