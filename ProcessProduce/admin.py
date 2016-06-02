from django.contrib import admin
from ProcessProduce.models import 生产信息,生产动态,提单
# Register your models here.
class 生产信息表(admin.ModelAdmin):
##      fields = ['日期','名称','单位','数据','类别','状态','备注','月累','年累']
      search_fields = ['名称']
      list_filter=['日期','单位','类别','状态','名称']
      list_display=('日期','名称','单位','数据','类别','状态','备注','月累','年累')


class 生产动态表(admin.ModelAdmin):
##      fields = ['时间','名称','单位','数据','备注']
      search_fields = ['时间','名称']
      list_filter =['名称','单位']
      list_display=('时间','名称','单位','数据','备注')

class 提单表(admin.ModelAdmin):
##      fields = ['提单号','日期','产品名称','客户名称','计划装车t','实际装车t','实际装车bbl','装车数量','备注']
      search_fields = ['客户名称']
      list_filter = ['日期','产品名称','客户名称',]
      list_display=('提单号','日期','产品名称','客户名称','计划装车t','实际装车t','实际装车bbl','装车数量','备注')

admin.site.register(生产信息,生产信息表)
admin.site.register(生产动态,生产动态表)
admin.site.register(提单,提单表)
