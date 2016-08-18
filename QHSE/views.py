from django.shortcuts import render
from django.db import connection
import json

# Create your views here.
from django.views.generic import ListView,DetailView
from django.views.generic.edit import CreateView, UpdateView, DeleteView
from django.core.urlresolvers import reverse_lazy
from .models import WorkPhone
from django.db.models import Q

class WorkPhoneList(ListView):
    template_name = "QHSE/workphone_list.html"
    model = WorkPhone
    context_object_name = 'WorkPhoneList'    
    paginate_by = 10
    def get_queryset(self):
    	queryset = WorkPhone.objects.all().order_by('地点','电话')
    	keyword = self.request.GET.get('keyword')
    	if keyword :
    		queryset = WorkPhone.objects.filter(Q(地点__icontains=keyword)|Q(电话__icontains=keyword)|Q(备注__icontains=keyword)).order_by('地点','电话')
    	return queryset
    def get_context_data(self, **kwargs):
        context = super(WorkPhoneList, self).get_context_data(**kwargs)
        context['Title'] = "工作电话"
        return context 


# def WorkPhoneAdd(request):
#     Title = '工作电话'
#     tableHead = ['ID','地点','电话','备注']
#     cursor = connection.cursor()
#     cursor.execute("select ID,地点,电话,备注 from 工作电话 order by 地点,电话;")
#     rows = cursor.fetchall()
#     records = json.dumps(rows)
#     print(rows)
#     # records = serializers.serialize("json", WorkPhone.objects.all())
#     return render(request, 'table.html',locals())
    
class WorkPhoneCreate(CreateView):
    template_name = "QHSE/workphone_form.html"
    model = WorkPhone
    fields = ['地点','电话','备注']
    success_url = reverse_lazy('WorkPhone-list')

class WorkPhoneUpdate(UpdateView):
	model = WorkPhone
	fields = ['地点','电话','备注']
	success_url = reverse_lazy('WorkPhone-list')

class WorkPhoneDelete(DeleteView):
	model = WorkPhone
	fields = ['地点','电话','备注']
	success_url = reverse_lazy('WorkPhone-list')

