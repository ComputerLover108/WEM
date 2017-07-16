from django.db import models

# Create your models here.


class WorkPhone(models.Model):
    地点 = models.CharField(max_length=32)
    电话 = models.CharField(max_length=16)
    备注 = models.CharField(max_length=32, blank=True)

    class Meta:
        db_table = '工作电话'


class liaoDongPhone(models.Model):
    姓名 = models.CharField(max_length=32)
    电话 = models.CharField(max_length=64)
    手机 = models.CharField(max_length=32)
    电邮 = models.CharField(max_length=32)
    办公地点 = models.CharField(max_length=32)
    单位 = models.CharField(max_length=32)
    部门 = models.CharField(max_length=32)
    岗位 = models.CharField(max_length=32)

    class Meta:
        db_table = '通讯录'
