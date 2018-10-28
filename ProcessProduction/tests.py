from django.test import TestCase
from ProcessProduction.models import ProductionData,ProductionStatus

# Create your tests here.
class ProductionDataTestCase(TestCase):
    def setUp(self):
        pass

class ProductionStatusTestCase(TestCase):
    def setUp(self):
        ProductionStatus.objects.Create(时间='2018-10-26',名称='FIQ-5014',单位='方',类别='天然气',数据=199.9,备注='test')
    
