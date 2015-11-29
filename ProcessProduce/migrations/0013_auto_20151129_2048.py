# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ProcessProduce', '0012_auto_20151129_2048'),
    ]

    operations = [
        migrations.AlterField(
            model_name='油化验',
            name='凝点',
            field=models.FloatField(db_column='凝点', null=True),
        ),
    ]
