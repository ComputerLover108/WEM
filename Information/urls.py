from django.conf.urls import patterns, url
from Information.views import messageList,messageAdd,messageDetail
urlpatterns = patterns('',
    url(r'^messageList/',messageList),
    url(r'^messageAdd/$',messageAdd),
    url(r'^messageDetail/(\d+)/$',messageDetail),
)