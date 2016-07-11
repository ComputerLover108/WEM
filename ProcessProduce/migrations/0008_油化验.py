# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ProcessProduce', '0007_auto_20150724_2017'),
    ]

    operations = [
        migrations.CreateModel(
            name='油化验',
            fields=[
                ('id', models.AutoField(primary_key=True, auto_created=True, verbose_name='ID', serialize=False)),
                ('日期', models.DateField()),
                ('名称', models.CharField(max_length=32)),
                ('密度', models.FloatField(null=True)),
                ('饱和蒸汽压', models.FloatField(null=True)),
                ('凝点', models.FloatField(null=True)),
                ('PH值', models.FloatField(null=True)),
                ('含水', models.FloatField(null=True)),
                ('运动粘度', models.FloatField(verbose_name='运动粘度40℃ mm2/s', null=True)),
                ('机械杂质', models.FloatField(null=True)),
            ],
        ),
    ]
