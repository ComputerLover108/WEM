# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ProcessProduce', '0009_auto_20151129_1942'),
    ]

    operations = [
        migrations.AlterField(
            model_name='油化验',
            name='凝点',
            field=models.FloatField(null=True, db_column='凝点℃'),
        ),
        migrations.AlterField(
            model_name='油化验',
            name='含水',
            field=models.FloatField(null=True, db_column='含水%'),
        ),
        migrations.AlterField(
            model_name='油化验',
            name='密度',
            field=models.FloatField(null=True, db_column='密度kg/m3'),
        ),
        migrations.AlterField(
            model_name='油化验',
            name='机械杂质',
            field=models.FloatField(null=True, db_column='机械杂质%'),
        ),
        migrations.AlterField(
            model_name='油化验',
            name='运动粘度',
            field=models.FloatField(null=True, db_column='运动粘度40℃ mm2/s'),
        ),
        migrations.AlterField(
            model_name='油化验',
            name='饱和蒸汽压',
            field=models.FloatField(null=True, db_column='饱和蒸汽压KPa'),
        ),
    ]
