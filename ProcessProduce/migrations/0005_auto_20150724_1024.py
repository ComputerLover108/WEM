# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ProcessProduce', '0004_auto_20150724_1009'),
    ]

    operations = [
        migrations.AlterField(
            model_name='生产信息',
            name='id',
            field=models.AutoField(serialize=False, primary_key=True),
        ),
        migrations.AlterUniqueTogether(
            name='生产信息',
            unique_together=set([]),
        ),
    ]
