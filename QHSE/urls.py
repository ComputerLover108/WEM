from django.urls import path
from .views import WorkPhoneList, LiaoDongPhoneList
from . import views

urlpatterns = [
    path(r'/', views.index, name='index'),
    path(r'contact/', views.contact, name='contact'),
    path(r'WorkPhone/', WorkPhoneList.as_view(), name='WorkPhoneList'),
    path(r'LiaoDongPhone/', LiaoDongPhoneList.as_view(), name='LiaoDongPhoneList'),
    # path(r'^WorkPhone/edit/$',WorkPhoneEdit.as_view(),name='WorkPhoneEdit'),
    # path(r'WorkPhone/add/$',WorkPhoneAdd,name='WorkPhone-add'),
    # path(r'WorkPhone/add/$', WorkPhoneCreate.as_view(), name='WorkPhone-add'),
    # path(r'WorkPhone/(?P<pk>[0-9]+)/$', WorkPhoneUpdate.as_view(), name='WorkPhone-update'),
    # url(r'WorkPhone/(?P<pk>[0-9]+)/delete/$', WorkPhoneDelete.as_view(), name='WorkPhone-delete'),
]
