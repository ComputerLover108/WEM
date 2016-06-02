from django.conf.urls import url
from .views import WorkPhoneList
from .views import WorkPhoneCreate, WorkPhoneUpdate, WorkPhoneDelete

urlpatterns = [
    url(r'WorkPhone/$',WorkPhoneList.as_view(),name='WorkPhone-list'),
    url(r'WorkPhone/add/$', WorkPhoneCreate.as_view(), name='WorkPhone-add'),
    url(r'WorkPhone/(?P<pk>[0-9]+)/$', WorkPhoneUpdate.as_view(), name='WorkPhone-update'),
    url(r'WorkPhone/(?P<pk>[0-9]+)/delete/$', WorkPhoneDelete.as_view(), name='WorkPhone-delete'),
]