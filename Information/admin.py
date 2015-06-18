from django.contrib import admin
from Information.models import Category,Message,Blog

# Register your models here.
admin.site.register(Category)

class MessageAdmin(admin.ModelAdmin):
    list_display=('content',)
    list_filter=['createdTime',]
    search_fields =('author',)


class BlogAdmin(admin.ModelAdmin):
    list_display=('title','summary','author','createdTime')
    list_filter=['createdTime',]
    search_fields =('title','author')


admin.site.register(Message,MessageAdmin)
admin.site.register(Blog,BlogAdmin)