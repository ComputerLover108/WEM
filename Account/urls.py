from django.conf.urls import url
from django.contrib.auth import views as auth_views
from .views import *

urlpatterns = [
    url(r'^login',login,name='login'),
    url(r'^logout',logout,name='logout'),
    url(r'^register',register,name='register'),
    # url(r'^login', auth_views.login, {'template_name': 'login.html'}, name='login'),    
    # url(r'^logout', auth_views.logout, {'template_name': 'home.html'}, name='logout'),
]