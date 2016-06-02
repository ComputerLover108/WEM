from django.shortcuts import render

# Create your views here.
from django.views.generic import ListView,DetailView
from django.views.generic.edit import CreateView, UpdateView, DeleteView
from django.core.urlresolvers import reverse_lazy
from .models import WorkPhone


class WorkPhoneList(ListView):
    # template_name = "WorkPhone_list.html"
    model = WorkPhone
    context_object_name = 'WorkPhone-list'    
    queryset = WorkPhone.objects.all().order_by('地点')
    paginate_by = 10

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

		
		
