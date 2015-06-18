from django.shortcuts import render,redirect
from django.contrib import auth
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.decorators import login_required
from Accounts.forms import LoginForm,RegisterForm,ChangePassword

# Create your views here.
def register(request):
    title='注册'
    if request.method == 'POST':
        form = RegisterForm(request.POST)
##        print(form.cleaned_data)
        if form.is_valid():
            inform='账户申请成功，请重新登录！'
            newUser=form.save()
            return render(request,'main.html',locals())
    else:
        form = RegisterForm()
##        print(UserCreationForm())

    return render(request, 'Accounts/register.html', {'form': form,'title':title})

def login(request):
    title='登录'
    if request.method == 'POST':
        form = LoginForm(request.POST)
        if form.is_valid():
            username = form.cleaned_data['username']
            password = form.cleaned_data['password']
            user = auth.authenticate(username=username, password=password)
##            print(username,password)
            if user and user.is_active:
                auth.login(request,user)
                return redirect('/')
            else:
                form.add_error('')
    else:
        form = LoginForm()

    return render(request, 'Accounts/login.html', locals())

@login_required
def logout(request):
    auth.logout(request)
    return redirect('/')


@login_required
def changePassword(request):
    title='修改密码'
    if request.method == 'POST':
        form = ChangePassword(request.POST)
##        print(form.cleaned_data)
        if form.is_valid():
            inform='密码修改成功，请重新登录！'
            newUser=form.save()
            return render(request,'main.html',locals())
    else:
        form = ChangePassword()
##        print(UserCreationForm())

    return render(request, 'Accounts/form.html', locals())