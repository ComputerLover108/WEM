from django.shortcuts import render
from Information.models import Message,Blog
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger

# Create your views here.
def messageList(request):
    title = '通知列表'
    messages = Message.objects.all()
    paginator = Paginator(messages, 9)

    page = request.GET.get('page')
    try:
        contacts = paginator.page(page)
    except PageNotAnInteger:
        # If page is not an integer, deliver first page.
        contacts = paginator.page(1)
    except EmptyPage:
        # If page is out of range (e.g. 9999), deliver last page of results.
        contacts = paginator.page(paginator.num_pages)

##    return render_to_response('list.html', {"contacts": contacts})
    return render(request,'Information/messageList.html',locals())


def messageAdd(request):
    title = '添加通知'
    return render(request,'Information/messageAdd.html',locals())

def messageDetail(request,blogID):
    return render(request,'Information/messageDetail.html',locals())

def blogList(request):
    messages = Message.objects.all()
    paginator = Paginator(messages, 32)

    page = request.GET.get('page')
    try:
        contacts = paginator.page(page)
    except PageNotAnInteger:
        # If page is not an integer, deliver first page.
        contacts = paginator.page(1)
    except EmptyPage:
        # If page is out of range (e.g. 9999), deliver last page of results.
        contacts = paginator.page(paginator.num_pages)

    return render(request,'Information/index.html',locals())