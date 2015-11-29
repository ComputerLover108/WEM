# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ProcessProduce', '0011_auto_20151129_2036'),
    ]

    operations = [
        migrations.AlterField(
            model_name='油化验',
            name='运动粘度',
            field=models.FloatField(db_column='运动粘度40 mm2/s', null=True),
        ),
    ]
