from django.db import models

# Create your models here.
class 生产信息(models.Model):
    id = models.AutoField(primary_key=True)
    日期 = models.DateField()
    名称 = models.CharField(max_length=32)
    单位 = models.CharField(max_length=32,blank=True)
    数据 = models.FloatField(null=True)
    类别 = models.CharField(max_length=32)
    状态 = models.CharField(max_length=32)
    备注 = models.TextField(blank=True)
    月累 = models.FloatField(null=True)
    年累 = models.FloatField(null=True)
    数据源 = models.TextField(blank=True)
    class Meta:
        db_table='生产信息'
#          unique_together = ("日期", "名称","单位","备注")
    def __str__(self):
        return self.日期+':'+self.名称+'['+self.单位+']'

class 生产动态(models.Model):
      时间 = models.DateTimeField()
      名称 = models.CharField(max_length=32)
      单位 = models.CharField(max_length=32)
      数据 = models.FloatField()
      类别 = models.CharField(max_length=32)
      备注 = models.TextField(blank=True)
      class Meta:
            db_table='生产动态'
##            unique_together = ("时间", "名称","单位")
      def __str__(self):
          s=str(self.时间)+':'+self.名称+'['+self.单位+']'
          return s


class 提单(models.Model):
    日期 = models.DateField()
    提单号 = models.CharField(max_length=32)
    产品名称 = models.CharField(max_length=32)
    客户名称 = models.CharField(max_length=32)
    计划装车t = models.FloatField()
    实际装车t = models.FloatField()
    实际装车bbl = models.FloatField(null=True)
    装车数量 = models.IntegerField()
    备注 = models.TextField(blank=True)
    class Meta:
        db_table='提单'
    def excessiveLoading(self):
        return self.实际装车t > self.计划装车t

class 油化验(models.Model):
    日期= models.DateField()
    名称= models.CharField(max_length=32)
    密度 = models.FloatField(null=True,db_column='密度kg/m3')
    饱和蒸汽压 = models.FloatField(null=True,db_column='饱和蒸汽压KPa')
    凝点 = models.FloatField(null=True,db_column='凝点℃')
    PH值 = models.FloatField(null=True)
    含水 = models.FloatField(null=True,db_column='含水%')
    运动粘度 = models.FloatField(null=True,db_column="运动粘度40℃ mm2/s")
    机械杂质 = models.FloatField(null=True,db_column='机械杂质%')
    备注 = models.TextField(blank=True,null=True)
    数据源 = models.TextField(null=True)
    class Meta:
        db_table='油化验'