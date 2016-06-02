from django.shortcuts import render
from Information.models import Message

# Create your views here.
def index(request):
    title='主页'
    messages = Message.objects.order_by('-updatedTime')[:5]
    return render(request, 'index.html', locals())

