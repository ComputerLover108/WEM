from django.test import TestCase
from ProcessProduction.productionDaily import getBaseData,getRelatedData,getDerivedData
# Create your tests here.

class TestProductionDaily(TestCase):
    def test_getBaseData(self):
        data=dict()
        sd='2017-1-8'
        getBaseData(data,sd)
        self.assertEquals(data[日期],'2017-1-8')

    # def test_getRelatedData(self):
    #     pass
    #
    # def test_getDerivedData(self):
    #     pass