from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Category(models.Model):
    name = models.CharField(max_length=64)
    def __str__(self):
        return self.name

class Message(models.Model):
    content = models.TextField()
    author = models.ForeignKey(User)
##    Category = models.ForeignKey('Category')
    createdTime = models.DateTimeField(auto_now_add=True)
    updatedTime = models.DateTimeField(auto_now_add=True)
    def __str__(self):
        return self.content


class Blog(models.Model):
    category = models.ForeignKey('Category')
    title = models.CharField(max_length=64)
    summary = models.CharField(max_length=256,blank=True,null=True)
    content = models.TextField()
    author = models.ForeignKey(User)
    createdTime = models.DateTimeField(auto_now_add=True)
    updatedTime = models.DateTimeField(auto_now_add=True)
    def __str__(self):
        return self.title