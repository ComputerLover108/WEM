from django.shortcuts import render
from django.db import connection
import json

from django.http import HttpResponse
from django.shortcuts import render_to_response, redirect
from django.template.context import RequestContext

# Create your views here.
from django.views.generic import ListView
# from django.views.generic.edit import CreateView, UpdateView, DeleteView
from django.core.urlresolvers import reverse_lazy
from .models import WorkPhone
from .forms import WorkPhoneForm

from django.forms import formset_factory,modelformset_factory
from django.db.models import Q

# import logging
# logger = logging.getLogger(__name__)

class WorkPhoneList(ListView):
    template_name = "workphone_list.html"
    model = WorkPhone
    context_object_name = 'WorkPhone-list'
    paginate_by = 10
    def get_queryset(self):
    	queryset = WorkPhone.objects.all()
    	keyword = self.request.GET.get('keyword')
    	if keyword :
    		queryset = WorkPhone.objects.filter(Q(地点__icontains=keyword)|Q(电话__icontains=keyword)|Q(备注__icontains=keyword)).order_by('地点','电话')
    	return queryset
    def get_context_data(self, **kwargs):
        context = super(WorkPhoneList, self).get_context_data(**kwargs)
        context['Title'] = "工作电话"
        return context
        # logger.info(context)

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

# class WorkPhoneCreate(CreateView):
#     template_name = "QHSE/workphone_form.html"
#     model = WorkPhone
#     fields = ['地点','电话','备注']
#     success_url = reverse_lazy('WorkPhone-list')

# class WorkPhoneUpdate(UpdateView):
# 	model = WorkPhone
# 	fields = ['地点','电话','备注']
# 	success_url = reverse_lazy('WorkPhone-list')

# class WorkPhoneDelete(DeleteView):
# 	model = WorkPhone
# 	fields = ['地点','电话','备注']
# 	success_url = reverse_lazy('WorkPhone-list')

def manage_WorkPhone(request):
    Title="工作电话"
    columns=['地点','电话','备注']
    queryset = WorkPhone.objects.all()[:9]
    print(queryset)
    WorkPhoneFormSet = modelformset_factory(WorkPhone,fields=columns,can_delete=True)
    if request.method == "GET" :
        address = request.GET.get('address')
        telephone = request.GET.get('telephone')
        remark = request.GET.get('remark')
        if address:
           queryset = queryset.filter(地点__icontains=address)
        if telephone:
            queryset = queryset.filter(电话__icontains=telephone)
        if remark:
            queryset = queryset.filter(备注__icontains=remark)
        print(address,telephone,remark) 
    if request.method == 'POST':
        formset = WorkPhoneFormSet(request.POST,request.FILES,queryset=queryset)
        if formset.is_valid():
            formset.save()
    else:
        formset = WorkPhoneFormSet()
    return render(request, 'QHSE/workphone_form.html', locals())

def display_data(request, data, **kwargs):
    return render_to_response('posted-data.html', dict(data=data, **kwargs),context_instance=RequestContext(request))

def formset(request, formset_class, template):
    if request.method == 'POST':
        formset = formset_class(request.POST)
        if formset.is_valid():
            data = formset.cleaned_data
            print(data)
            return display_data(request, data)
    else:
        formset = formset_class()
    return render_to_response(template, {'formset': formset},context_instance=RequestContext(request))
