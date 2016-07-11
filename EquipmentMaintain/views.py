from django.shortcuts import render

# Create your views here.
def index(request):
    title='设备维修'
    return render(request, 'EquipmentMaintain/index.html', locals())