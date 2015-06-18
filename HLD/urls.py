from django.conf.urls import patterns, include, url
from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'HLD.views.home', name='home'),
    url(r'^$', 'HLD.views.index', name='index'),
    url(r'^admin/', include(admin.site.urls)),
    url(r'^Accounts/',include('Accounts.urls')),
    url(r'^ProcessProduce/', include('ProcessProduce.urls')),
    url(r'^EquipmentMaintain/', include('EquipmentMaintain.urls')),
    url(r'^HealthSafetyEnviroment/', include('HealthSafetyEnviroment.urls')),
    url(r'^Information/',include('Information.urls')),
)+ static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
