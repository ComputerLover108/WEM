from django.shortcuts import render
from django.views.generic import ListView,DetailView
from .models import 设备位号
# Create your views here.
def index(request):
    title='设备维护'
    用户='游客'
    部门 = (('机械',''),('电气',''),('仪表',''),('计控',''))
    设备档案 = (('位号表','Equipment'),)
    return render(request, 'EquipmentMaintenance/index.html', locals())

class EquipmentList(ListView):
    template_name = "Equipment_list.html"
    model = 设备位号
    context_object_name = 'Equipment-list'    
    paginate_by = 10
    def get_queryset(self):
    	queryset = WorkPhone.objects.all().order_by('位号','名称')
    	keyword = self.request.GET.get('keyword')
    	if keyword :
    		queryset = WorkPhone.objects.filter(Q(位号__icontains=keyword)|Q(名称__icontains=keyword)|Q(备注__icontains=keyword)).order_by('地点','电话')
    	return queryset

