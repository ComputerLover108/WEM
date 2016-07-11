from django.shortcuts import render

# Create your views here.
def index(request):
    title='安全环保'
    return render(request, 'HealthSafetyEnviroment/index.html', locals())