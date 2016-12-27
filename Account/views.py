from django.shortcuts import render, redirect
from django.contrib import auth
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.decorators import login_required
from Account.forms import LoginForm, RegisterForm, ChangePassword

# Create your views here.


def register(request):
    title = '注册'
    if request.method == 'POST':
        form = RegisterForm(request.POST)
        if form.is_valid():
            inform = '账户申请成功，请重新登录！'
            newUser = form.save()
            return render(request, 'home.html', locals())
    else:
        form = RegisterForm()

    return render(request, 'Account/register.html', {'form': form, 'title': title})


def login(request):
    title = '登录'
    if request.method == 'POST':
        form = LoginForm(request.POST)
        if form.is_valid():
            username = form.cleaned_data['username']
            password = form.cleaned_data['password']
            user = auth.authenticate(username=username, password=password)
            if user is not None:
                auth.login(request, user)
                return redirect('/')
            else:
                # form.add_error('账户没有激活！')
                pass
    else:
        form = LoginForm()

    return render(request, 'Account/login.html', locals())


@login_required
def logout(request):
    auth.logout(request)
    return redirect('/')


@login_required
def changePassword(request):
    title = '修改密码'
    if request.method == 'POST':
        form = ChangePassword(request.POST)
        if form.is_valid():
            inform = '密码修改成功，请重新登录！'
            newUser = form.save()
            return render(request, 'home.html', locals())
    else:
        form = ChangePassword()

    return render(request, 'Account/form.html', locals())
