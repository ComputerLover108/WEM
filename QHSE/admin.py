from django.contrib import admin

# Register your models here.
from .models import WorkPhone,LiaoDongPhone

admin.site.register(WorkPhone)
admin.site.register(LiaoDongPhone)