from django.shortcuts import render
from django.db.models import Q
from django.views.generic import ListView,DetailView
from .models import Equipment
# Create your views here.
def index(request):
    title='设备维护'
    用户='游客'
    部门 = (('机械',''),('电气',''),('仪表',''),('计控',''))
    设备档案 = (('位号表','EquipmentList'),)
    return render(request, 'EquipmentMaintenance/index.html', locals())

class EquipmentList(ListView):
    template_name = "Equipment_list.html"
    model = Equipment
    context_object_name = 'Equipment-list'    
    paginate_by = 16
    def get_queryset(self):
    	queryset = Equipment.objects.all().order_by('位号','名称')
    	keyword = self.request.GET.get('keyword')
    	if keyword :
    		queryset = Equipment.objects.filter(Q(位号__icontains=keyword)|Q(名称__icontains=keyword)|Q(备注__icontains=keyword)).order_by('位号','名称')
    	return queryset

