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
    # def __str__(self):
    #     return self.日期+':'+self.名称+'['+self.单位+']'

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
    def __str__(self):
        return self.提单号
    def excessiveLoading(self):
        return self.实际装车t > self.计划装车t

class 原油化验(models.Model):
    时间 = models.DateTimeField(null=True)
    日期= models.DateField()
    名称= models.CharField(max_length=32)
    PH值 = models.FloatField(null=True)
    含水 = models.FloatField(null=True,db_column='含水%')
    凝点 = models.FloatField(null=True,db_column='凝点℃')
    备注 = models.TextField(blank=True,null=True)
    数据源 = models.TextField(blank=True,null=True)
    class Meta:
        db_table='原油化验'

class 轻油化验(models.Model):
    时间 = models.DateTimeField(null=True)
    日期= models.DateField()
    名称= models.CharField(max_length=32)
    密度 = models.FloatField(null=True,db_column='密度kg/m3')
    饱和蒸汽压 = models.FloatField(null=True,db_column='饱和蒸汽压KPa')
    凝点 = models.FloatField(null=True,db_column='凝点℃')
    PH值 = models.FloatField(null=True)
    含水 = models.FloatField(null=True,db_column='含水%')
    备注 = models.TextField(blank=True,null=True)
    数据源 = models.TextField(blank=True,null=True)
    class Meta:
        db_table='轻油化验'

class 滑油化验(models.Model):
    日期= models.DateField()
    名称= models.CharField(max_length=32)
    含水 = models.FloatField(null=True,db_column='含水%')
    运动粘度 = models.FloatField(null=True,db_column="运动粘度40℃ mm2/s")
    机械杂质 = models.FloatField(null=True,db_column='机械杂质%')
    备注 = models.TextField(blank=True,null=True)
    数据源 = models.TextField(blank=True,null=True)
    class Meta:
        db_table='滑油化验'

class 烃化验(models.Model):
    时间 = models.DateTimeField(null=True)
    日期 = models.DateField()
    名称 = models.CharField(max_length=32)
    取样点 = models.CharField(max_length=32)
    C1 = models.FloatField(null=True)
    C2 = models.FloatField(null=True)
    C3 = models.FloatField(null=True)
    iC4 = models.FloatField(null=True)
    nC4 = models.FloatField(null=True)
    iC5 = models.FloatField(null=True)
    nC5 = models.FloatField(null=True)
    C5plus = models.FloatField(null=True,db_column='C5+')
    CO2 = models.FloatField(null=True)
    N2 = models.FloatField(null=True) 
    饱和蒸汽压 = models.FloatField(null=True,db_column='饱和蒸汽压KPa')
    塔底温度 = models.FloatField(null=True,db_column='塔底温度℃')
    塔顶压力 = models.FloatField(null=True,db_column='塔顶压力KPa')
    回流量 = models.FloatField(null=True,db_column='回流量m3/h')
    备注 = models.TextField(blank=True,null=True)
    数据源 = models.TextField(blank=True,null=True)
    class Meta:
        db_table = '烃化验'

class 水化验(models.Model):
    日期 = models.DateField()
    名称 = models.CharField(max_length=32)
    PH值 = models.FloatField(null=True,db_column='PH值')
    浊度 = models.FloatField(null=True)
    电导率 = models.FloatField(null=True)
    LSI = models.FloatField(null=True,db_column='LSI')
    氯离子 = models.FloatField(null=True)
    总碱度 = models.FloatField(null=True)
    总硬度 = models.FloatField(null=True)
    总铁 =  models.FloatField(null=True)
    备注 = models.TextField(blank=True,null=True)
    数据源 = models.TextField(blank=True,null=True)
    class Meta:
        db_table = '水化验'
