# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='提单',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('日期', models.DateField()),
                ('提单号', models.CharField(max_length=32)),
                ('产品名称', models.CharField(max_length=32)),
                ('客户名称', models.CharField(max_length=32)),
                ('计划装车t', models.FloatField()),
                ('实际装车t', models.FloatField()),
                ('实际装车bbl', models.FloatField(null=True)),
                ('装车数量', models.IntegerField()),
                ('备注', models.TextField(blank=True)),
            ],
            options={
                'db_table': '提单',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='生产信息',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('日期', models.DateField()),
                ('名称', models.CharField(max_length=32)),
                ('单位', models.CharField(max_length=32, blank=True)),
                ('数据', models.FloatField(null=True)),
                ('类别', models.CharField(max_length=32)),
                ('状态', models.CharField(max_length=32)),
                ('备注', models.TextField(blank=True)),
                ('月累', models.FloatField(null=True)),
                ('年累', models.FloatField(null=True)),
                ('数据源', models.TextField(blank=True)),
            ],
            options={
                'db_table': '生产信息',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='生产动态',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('时间', models.DateTimeField()),
                ('名称', models.CharField(max_length=32)),
                ('单位', models.CharField(max_length=32)),
                ('数据', models.FloatField()),
                ('类别', models.CharField(max_length=32)),
                ('备注', models.TextField(blank=True)),
            ],
            options={
                'db_table': '生产动态',
            },
            bases=(models.Model,),
        ),
    ]
