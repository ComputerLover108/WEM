from django.contrib import admin
from HealthSafetyEnviroment.models import WorkPhone,PersonInfomation

# Register your models here.
class WorkPhoneAdmin(admin.ModelAdmin):
##      fields=['地点','电话','备注']
      search_fields =['地点']
      list_display = ('地点','电话','备注')

admin.site.register(WorkPhone,WorkPhoneAdmin)

class PersonInformationAdmin(admin.ModelAdmin):
    search_fields = ['姓名']
    list_filter = ['岗位','户口所在地','职称']

admin.site.register(PersonInfomation,PersonInformationAdmin)