from django.db import models

# Create your models here.


class Equipment(models.Model):
    位号 = models.CharField(max_length=32)
    名称 = models.CharField(max_length=32)
    备注 = models.TextField(blank=True)

    class Meta:
        db_table = '设备位号'
