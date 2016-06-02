from django.db import models

# Create your models here.
class WorkPhone(models.Model):
      地点 = models.CharField(max_length=32)
      电话 = models.CharField(max_length=32)
      备注 = models.TextField(blank=True)

      class Meta:
            db_table='办公电话'

      def __str__(self):
          return self.地点

性别选项=(
    ('Male','男'),
    ('Female','女'),
)
class EmployeeBasicInformation(models.Model):
    pass

# class PersonInfomation(models.Model):
    # 编号 = models.CharField(max_length=8,unique=True)
    # 姓名 = models.CharField(max_length=32)
    # 部门 = models.CharField(max_length=32)
    # 岗位= models.CharField(max_length=32)
    # 性别= models.CharField(max_length=8,choices=性别选项)
    # 出生日期=models.DateField()
    # 民族= models.CharField(max_length=32)
    # 籍贯= models.CharField(max_length=32)
    # 户口所在地= models.CharField(max_length=32)
    # 政治面貌= models.CharField(max_length=32)
    # 身份证号= models.CharField(max_length=32)
    # 婚姻状况= models.CharField(max_length=32)
    # 职称= models.CharField(max_length=32)
    # 技能鉴定= models.CharField(max_length=32)
    # 家庭地址= models.CharField(max_length=32)
    # 联系电话= models.CharField(max_length=32)
    # 个人电子邮箱=models.EmailField(blank=True)
    # 第一学历= models.CharField(max_length=32)
    # 第一学历毕业院校= models.CharField(max_length=32)
    # 第一学历专业= models.CharField(max_length=32)
    # 第一学历毕业时间= models.DateField()
    # 学历证号= models.CharField(max_length=32)
    # 学位证号= models.CharField(max_length=32)
    # 最高学历= models.CharField(max_length=32)
    # 最高学历毕业院校= models.CharField(max_length=32)
    # 最高学历专业= models.CharField(max_length=32)
    # 最高学历毕业时间=models.DateField()
    # 最高学历学历证号= models.CharField(max_length=32,blank=True)
    # 最高学历学位证号= models.CharField(max_length=32,blank=True)
    # 参加工作时间= models.DateField()
    # 入党时间=models.DateField()
    # 来海油时间=models.DateField()
    # 总工龄=models.IntegerField()
    # 外语水平= models.CharField(max_length=32,blank=True)
    # 个人特长= models.TextField(blank=True)
    # 用工制度= models.CharField(max_length=32)
    # 合同签订时间=models.DateField()
    # 合同签订年限=models.IntegerField()
    # 海上工作经历=models.TextField()
# ##    办证照片2寸=models.ImageField()
# ##    办证照片1寸半=models.ImageField()
# ##    其他所需文件=models.FilePathField()
    # class Meta:
          # db_table='人员信息'
    # def __str__(self):
          # return self.姓名