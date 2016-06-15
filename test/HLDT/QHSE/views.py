from django.shortcuts import render

# Create your views here.
from django.views.generic import ListView,DetailView
from django.views.generic.edit import CreateView, UpdateView, DeleteView
from django.core.urlresolvers import reverse_lazy
from .models import WorkPhone
from django.db.models import Q

class WorkPhoneList(ListView):
    template_name = "WorkPhone_list.html"
    model = WorkPhone
    context_object_name = 'WorkPhone-list'    
    paginate_by = 10
    def get_queryset(self):
    	queryset = WorkPhone.objects.all().order_by('地点','电话')
    	keyword = self.request.GET.get('keyword')
    	if keyword :
    		queryset = WorkPhone.objects.filter(Q(地点__icontains=keyword)|Q(电话__icontains=keyword)|Q(备注__icontains=keyword)).order_by('地点','电话')
    	return queryset   

class WorkPhoneCreate(CreateView):
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

		
		
