from django.shortcuts import render

# Create your views here.
def home(request):
    title='主页'
    return render(request, 'home.html', locals())