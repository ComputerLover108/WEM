# -*- coding: utf-8 -*-
# Generated by Django 1.11.3 on 2017-07-20 11:54
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ProcessProduction', '0002_auto_20170627_1946'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='ladingbill',
            name='id',
        ),
        migrations.AlterField(
            model_name='ladingbill',
            name='提单号',
            field=models.CharField(max_length=32, primary_key=True, serialize=False),
        ),
    ]
