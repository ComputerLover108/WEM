# -*- coding: utf-8 -*-
# Generated by Django 1.11.3 on 2017-07-21 00:27
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ProcessProduction', '0003_auto_20170720_1954'),
    ]

    operations = [
        migrations.AlterField(
            model_name='生产信息',
            name='id',
            field=models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID'),
        ),
        migrations.AlterUniqueTogether(
            name='生产信息',
            unique_together=set([('日期', '名称', '单位', '类别', '状态', '备注')]),
        ),
        migrations.AlterUniqueTogether(
            name='生产动态',
            unique_together=set([('时间', '名称', '单位')]),
        ),
    ]
