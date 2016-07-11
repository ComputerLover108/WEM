from django import forms
from django.contrib.auth.forms import UserCreationForm,AuthenticationForm,SetPasswordForm

class LoginForm(forms.Form):
    username = forms.CharField(label='账户',max_length=32,
        widget=forms.TextInput(attrs={'class':'form-control','placeholder':'账户'})
        )
    password = forms.CharField(label='密码',
        widget=forms.PasswordInput(attrs={'class':'form-control','placeholder':'密码'})
        )

##class loginForm(AuthenticationForm):
##    username = forms.CharField(label='账户',max_length=32,
##        widget=forms.TextInput(attrs={'class':'form-control','placeholder':'账户'})
##        )
##    password = forms.CharField(label='密码',
##        widget=forms.PasswordInput(attrs={'class':'form-control','placeholder':'密码'})
##        )
##    def confirm_login_allowed(self, user):
##        pass


class RegisterForm(UserCreationForm):
    username = forms.CharField(label='账户',max_length=32,
        widget=forms.TextInput(attrs={'class':'form-control','placeholder':'账户'})
        )
    password1 = forms.CharField(label='密码',
        widget=forms.PasswordInput(attrs={'class':'form-control','placeholder':'密码'})
        )
    password2 = forms.CharField(label='密码确认',
        widget=forms.PasswordInput(attrs={'class':'form-control','placeholder':'密码确认'}),
        )

class ChangePassword(SetPasswordForm):
    password1 = forms.CharField(label='密码确认',
        widget=forms.PasswordInput(attrs={'class':'form-control','placeholder':'密码'})
        )
    password2 = forms.CharField(label='密码',
        widget=forms.PasswordInput(attrs={'class':'form-control','placeholder':'密码确认'}),
        )