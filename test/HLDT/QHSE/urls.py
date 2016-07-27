# from django.conf.urls import url
from django.conf.urls import patterns, url, include
from .views import WorkPhoneList,manage_WorkPhone,formset
from .forms import WorkPhoneFormset
# from .views import WorkPhoneCreate, WorkPhoneUpdate, WorkPhoneDelete

urlpatterns = [
    url(r'^WorkPhone/$',WorkPhoneList.as_view(),name='WorkPhone-list'),
    url(r'^WorkPhone/edit/$',manage_WorkPhone,name='manage_WorkPhone'),
    url(r'^WorkPhone/add/$', formset, {'formset_class': WorkPhoneFormset, 'template': 'QHSE/formset-table.html'}, name='WorkPhoneEdit'),
    # url(r'^table/$', 'formset', {'formset_class': ContactFormset, 'template': 'example/formset-table.html'}, name='example_table'),
    # url(r'WorkPhone/add/$', WorkPhoneCreate.as_view(), name='WorkPhone-add'),
    # url(r'WorkPhone/(?P<pk>[0-9]+)/$', WorkPhoneUpdate.as_view(), name='WorkPhone-update'),
    # url(r'WorkPhone/(?P<pk>[0-9]+)/delete/$', WorkPhoneDelete.as_view(), name='WorkPhone-delete'),
]
