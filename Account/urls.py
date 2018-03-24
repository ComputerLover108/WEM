from django.urls import path
from django.contrib.auth import views as auth_views
from .views import *

urlpatterns = [
    path(r'login',login,name='login'),
    path(r'logout',logout,name='logout'),
    path(r'register',register,name='register'),
    # path(r'^login', auth_views.login, {'template_name': 'login.html'}, name='login'),
    # path(r'^logout', auth_views.logout, {'template_name': 'home.html'}, name='logout'),
]