from django import forms
from django.forms import formset_factory
from .models import WorkPhone

class WorkPhoneForm(forms.ModelForm):
    class Meta:
        model = WorkPhone
        fields = '__all__'
        # fields = [ "地点","电话","备注"]

WorkPhoneFormset = formset_factory(WorkPhoneForm)

# class BaseWorkPhoneFormSet(BaseFormSet):
#      def clean(self):
#          """Checks that no two articles have the same title."""
#          if any(self.errors):
#              # Don't bother validating the formset unless each form is valid on its own
#              return
#          titles = []
#          for form in self.forms:
#              title = form.cleaned_data['title']
#              if title in titles:
#                  raise forms.ValidationError("Articles in a set must have distinct titles.")
#              titles.append(title)

# WorkPhoneFormSet = formset_factory(WorkPhoneForm, formset=BaseWorkPhoneFormSet)
# formset = formset_factory(MyClass, **kwargs)
# empty = formset.empty_form
# # empty is a form instance, so you can do whatever you want to it
# my_empty_form_init(empty_form)
# formset.empty_form = empty_form
