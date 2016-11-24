from django.conf.urls import url
from .views import WorkPhoneList
from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^WorkPhone/$',WorkPhoneList.as_view(),name='WorkPhoneList'),
    # url(r'^WorkPhone/edit/$',WorkPhoneEdit.as_view(),name='WorkPhoneEdit'),
    # url(r'WorkPhone/add/$',WorkPhoneAdd,name='WorkPhone-add'),
    # url(r'WorkPhone/add/$', WorkPhoneCreate.as_view(), name='WorkPhone-add'),
    # url(r'WorkPhone/(?P<pk>[0-9]+)/$', WorkPhoneUpdate.as_view(), name='WorkPhone-update'),
    # url(r'WorkPhone/(?P<pk>[0-9]+)/delete/$', WorkPhoneDelete.as_view(), name='WorkPhone-delete'),
]