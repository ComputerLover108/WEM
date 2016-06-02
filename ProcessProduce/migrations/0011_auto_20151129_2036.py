# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ProcessProduce', '0010_auto_20151129_2008'),
    ]

    operations = [
        migrations.AddField(
            model_name='油化验',
            name='备注',
            field=models.TextField(null=True, blank=True),
        ),
        migrations.AddField(
            model_name='油化验',
            name='数据源',
            field=models.TextField(null=True),
        ),
        migrations.AlterField(
            model_name='提单',
            name='实际装车bbl',
            field=models.FloatField(null=True),
        ),
    ]
