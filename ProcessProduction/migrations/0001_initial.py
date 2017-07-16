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
            name='LadingBill',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('日期', models.DateField()),
                ('提单号', models.CharField(max_length=32)),
                ('产品名称', models.CharField(max_length=32)),
                ('客户名称', models.CharField(max_length=32)),
                ('计划装车t', models.FloatField()),
                ('实际装车t', models.FloatField()),
                ('实际装车m3', models.FloatField(null=True)),
                ('实际装车bbl', models.FloatField(null=True)),
                ('装车数量', models.IntegerField()),
                ('备注', models.TextField(blank=True)),
            ],
            options={
                'db_table': '提单',
            },
        ),
        migrations.CreateModel(
            name='原油化验',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('时间', models.DateTimeField(null=True)),
                ('日期', models.DateField()),
                ('名称', models.CharField(max_length=32)),
                ('PH值', models.FloatField(null=True)),
                ('含水', models.FloatField(db_column='含水%', null=True)),
                ('凝点', models.FloatField(db_column='凝点℃', null=True)),
                ('备注', models.TextField(blank=True, null=True)),
                ('数据源', models.TextField(blank=True, null=True)),
            ],
            options={
                'db_table': '原油化验',
            },
        ),
        migrations.CreateModel(
            name='水化验',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('日期', models.DateField()),
                ('名称', models.CharField(max_length=32)),
                ('PH值', models.FloatField(db_column='PH值', null=True)),
                ('浊度', models.FloatField(null=True)),
                ('电导率', models.FloatField(null=True)),
                ('LSI', models.FloatField(db_column='LSI', null=True)),
                ('氯离子', models.FloatField(null=True)),
                ('总碱度', models.FloatField(null=True)),
                ('总硬度', models.FloatField(null=True)),
                ('总铁', models.FloatField(null=True)),
                ('备注', models.TextField(blank=True, null=True)),
                ('数据源', models.TextField(blank=True, null=True)),
            ],
            options={
                'db_table': '水化验',
            },
        ),
        migrations.CreateModel(
            name='滑油化验',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('日期', models.DateField()),
                ('名称', models.CharField(max_length=32)),
                ('含水', models.FloatField(db_column='含水%', null=True)),
                ('运动粘度', models.FloatField(db_column='运动粘度40℃ mm2/s', null=True)),
                ('机械杂质', models.FloatField(db_column='机械杂质%', null=True)),
                ('备注', models.TextField(blank=True, null=True)),
                ('数据源', models.TextField(blank=True, null=True)),
            ],
            options={
                'db_table': '滑油化验',
            },
        ),
        migrations.CreateModel(
            name='烃化验',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('时间', models.DateTimeField(null=True)),
                ('日期', models.DateField()),
                ('名称', models.CharField(max_length=32)),
                ('取样点', models.CharField(max_length=32)),
                ('C1', models.FloatField(null=True)),
                ('C2', models.FloatField(null=True)),
                ('C3', models.FloatField(null=True)),
                ('iC4', models.FloatField(null=True)),
                ('nC4', models.FloatField(null=True)),
                ('iC5', models.FloatField(null=True)),
                ('nC5', models.FloatField(null=True)),
                ('C5plus', models.FloatField(db_column='C5+', null=True)),
                ('CO2', models.FloatField(null=True)),
                ('N2', models.FloatField(null=True)),
                ('饱和蒸汽压', models.FloatField(db_column='饱和蒸汽压KPa', null=True)),
                ('塔底温度', models.FloatField(db_column='塔底温度℃', null=True)),
                ('塔顶压力', models.FloatField(db_column='塔顶压力KPa', null=True)),
                ('回流量', models.FloatField(db_column='回流量m3/h', null=True)),
                ('备注', models.TextField(blank=True, null=True)),
                ('数据源', models.TextField(blank=True, null=True)),
            ],
            options={
                'db_table': '烃化验',
            },
        ),
        migrations.CreateModel(
            name='生产信息',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('日期', models.DateField()),
                ('名称', models.CharField(max_length=32)),
                ('单位', models.CharField(blank=True, max_length=32)),
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
        ),
        migrations.CreateModel(
            name='生产动态',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
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
        ),
        migrations.CreateModel(
            name='轻油化验',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('时间', models.DateTimeField(null=True)),
                ('日期', models.DateField()),
                ('名称', models.CharField(max_length=32)),
                ('密度', models.FloatField(db_column='密度kg/m3', null=True)),
                ('饱和蒸汽压', models.FloatField(db_column='饱和蒸汽压KPa', null=True)),
                ('凝点', models.FloatField(db_column='凝点℃', null=True)),
                ('PH值', models.FloatField(null=True)),
                ('含水', models.FloatField(db_column='含水%', null=True)),
                ('备注', models.TextField(blank=True, null=True)),
                ('数据源', models.TextField(blank=True, null=True)),
            ],
            options={
                'db_table': '轻油化验',
            },
        ),
    ]
