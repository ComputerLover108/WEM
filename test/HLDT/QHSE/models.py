from django.db import models

# Create your models here.
class WorkPhone(models.Model):
	地点 = models.CharField(max_length=32)
	电话 = models.CharField(max_length=16)
	备注 = models.CharField(max_length=32,blank=True)
	class Meta:
		db_table='工作电话'
	def __str__(self):
		return self.地点+':'+self.电话+'['+self.备注+']'