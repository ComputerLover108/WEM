# -*- coding: utf-8 -*-
# Generated by Django 1.11.2 on 2017-06-27 11:25
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='WorkPhone',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('地点', models.CharField(max_length=32)),
                ('电话', models.CharField(max_length=16)),
                ('备注', models.CharField(blank=True, max_length=32)),
            ],
            options={
                'db_table': '工作电话',
            },
        ),
    ]