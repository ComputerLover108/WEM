from django.conf.urls import patterns, url
from Accounts.views import login,logout,register,changePassword

urlpatterns = patterns('',
    url(r'^login',login),
    url(r'^logout',logout),
    url(r'^register',register),
##    url(r'^changePassword',changePassword),
)